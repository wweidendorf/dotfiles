# base-files version 3.7-1

# To pick up the latest recommended .bashrc content,
# look in /etc/defaults/etc/skel/.bashrc

# Modifying /etc/skel/.bashrc directly will prevent
# setup from updating it.

# The copy in your home directory (~/.bashrc) is yours, please
# feel free to customise it to create a shell
# environment to your liking.  If you feel a change
# would be benificial to all, please feel free to send
# a patch to the cygwin mailing list.

# User dependent .bashrc file


# Shell Options
# #############

# See man bash for more options...

# Don't wait for job termination notification
# set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# Use case-insensitive filename globbing
# shopt -s nocaseglob

# Make bash append rather than overwrite the history on disk
# shopt -s histappend

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell


# Completion options
# ##################

# These completion tuning parameters change the default behavior of bash_completion:

# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# If this shell is interactive, turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# case $- in
#   *i*) [[ -f /etc/bash_completion ]] && . /etc/bash_completion ;;
# esac

if [ -n "$PS1" ]; then
  if [ -r /etc/bash_completion ]; then
    # Source completion code.
    . /etc/bash_completion
  fi
fi


# History Options
# ###############

# Don't put duplicate lines in the history.
export HISTCONTROL="ignoredups"

# Ignore some controlling instructions
# export HISTIGNORE="[   ]*:&:bg:fg:exit"
export HISTIGNORE="&:ls:[bf]g:exit:gst:gl:gp:gt:gittower"

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Aliases
# #######

# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.

# Interactive operation...
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
# alias less='less -r'                          # raw control characters
# alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias myips="ifconfig | grep 'inet ' | grep -v 127.0.0.1 | cut -d\   -f2"

# Some shortcuts for different directory listings
# alias ls='ls -hF --color=tty'                 # classify files in colour
# alias dir='ls --color=auto --format=vertical'
# alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
# alias l='ls -CF'                              #

# Moving up directories
alias ..='cd ..'
alias ...='cd .. && cd ..'
alias ....='cd .. && cd .. && cd ..'
alias .....='cd .. && cd .. && cd .. && cd ..'

function m {
  files=$(ls *.tmproj 2> /dev/null)
  if [ "$files" != "" ]; then
    open $files
  else
    mate .
  fi
}

# Setup automatic bundle exec for common gem executables

BUNDLED_COMMANDS="${BUNDLED_COMMANDS:-cucumber padrino rackup rails rake rspec ruby shotgun spec spork unicorn unicorn_rails}"

## Functions

function bundler-installed {
  which bundle > /dev/null 2>&1
}

function within-bundled-project {
  local dir="$(pwd)"
  while [ "$(dirname $dir)" != "/" ]; do
    [ -f "$dir/Gemfile" ] && return
    dir="$(dirname $dir)"
  done
  false
}

function run-with-bundler {
  local command="$1"
  shift
  if bundler-installed && within-bundled-project; then
    bundle exec $command "$@"
  else
    $command "$@"
  fi
}

## Main program

for CMD in $BUNDLED_COMMANDS; do
  alias $CMD="run-with-bundler $CMD"
done



# Rails/Padrino aliases
function sc {
	if [ -f './bin/rails' ]; then
		rails console $*
	elif [ -f './script/rails' ]; then
		rails console $*
	elif [ -f './config/apps.rb' ]; then
	  padrino console $*
	else
		./script/console $*
	fi
}
function sr {
	if [ -f './script/rails' ]; then
		rails runner $*
	else
		./script/runner $*
	fi
}
function ss {
  if [ -f './bin/rails' ]; then
		rails server $*
  elif [ -f './script/rails' ]; then
		rails server $*
	elif [ -f './script/server' ]; then
		./script/server $*
	elif [ -f './config/apps.rb' ]; then
	  padrino start $*
	else
	  ruby -r webrick -e "trap('INT')  { @server.stop }; (@server = WEBrick::HTTPServer.new(:DocumentRoot => Dir.pwd, :Port => 3000)).start"
	fi
}
function sg {
	if [ -f './bin/rails' ]; then
		rails generate $*
	elif [ -f './script/rails' ]; then
		rails generate $*
	elif [ -f './config/apps.rb' ]; then
	  padrino g $*
	else
		./script/generate $*
	fi
}
alias tfd='tail -f log/development.log'
alias tfp='tail -f log/production.log'
alias atr='autotest -rails'
alias rdm='rake db:migrate'
alias rr='rake routes'

alias b='bundle'
alias bi="b install --path vendor --binstubs=.bin"
alias bu="b update"
alias be="b exec"
alias bo="b open"
alias binit="bi && b package && echo 'vendor/ruby' >> .gitignore"

# Aliases for git
alias gl='git pull'
alias gp='git push'
alias gb='git branch -a -v'
alias gst='git status'
alias gss='ruby ~/.submodule_status.rb `pwd`'
alias gd='git diff | gitx'
alias gdi='git diff --ignore-space-change | gitx'
alias gdc='git diff --cached | gitx'
alias gdic='git diff --cached --ignore-space-change | gitx'
alias gi='git commit'
alias gc='git checkout'
alias gt='gittower'

function git-add-remote-branch {
  git push origin origin:refs/heads/$1
}

function git-add-remote-branch-and-checkout {
  git push origin origin:refs/heads/$1
  git checkout --track -b $1 origin/$1
}

function git-remove-remote-branch {
  git push origin :heads/$1
}

_gl_git ()
{
 local i c=1 command="pull" __git_dir

 local cur words cword prev
 _get_comp_words_by_ref -n =: cur words cword prev

 _git_pull
}

_gp_git ()
{
 local i c=1 command="push" __git_dir

 local cur words cword prev
 _get_comp_words_by_ref -n =: cur words cword prev

 _git_push
}

_gc_git ()
{
 local i c=1 command="checkout" __git_dir

 local cur words cword prev
 _get_comp_words_by_ref -n =: cur words cword prev

 _git_checkout
}

_gi_git ()
{
 local i c=1 command="commit" __git_dir

 local cur words cword prev
 _get_comp_words_by_ref -n =: cur words cword prev

 _git_commit
}

complete -o bashdefault -o default -o nospace -F _gl_git gl 2>/dev/null \
 || complete -o default -o nospace -F _gl_git gl
complete -o bashdefault -o default -o nospace -F _gp_git gp 2>/dev/null \
 || complete -o default -o nospace -F _gp_git gp
complete -o bashdefault -o default -o nospace -F _git_status gst 2>/dev/null \
 || complete -o default -o nospace -F _git_status gst
complete -o bashdefault -o default -o nospace -F _gc_git gc 2>/dev/null \
 || complete -o default -o nospace -F _gc_git gc
complete -o bashdefault -o default -o nospace -F _gi_git gi 2>/dev/null \
 || complete -o default -o nospace -F _gi_git gi


# Aliases for ruby

# use completion and require rubygems by default for irb
alias irb='irb -r irb/completion -rubygems'

alias gemdir='gem env gemdir'

# really awesome function, use: cdgem <gem name>, cd's into your gems directory
# and opens gem that best matches the gem name provided
function cdgem {
  cd `gemdir`/gems
  cd `ls | grep $1 | sort | tail -1`
}
function gemdoc {
  GEMDIR=`gemdir`/doc
  open $GEMDIR/`ls $GEMDIR | grep $1 | sort | tail -1`/rdoc/index.html
}
function mategem {
  GEMDIR=`gemdir`/gems
  mate $GEMDIR/`ls $GEMDIR | grep $1 | sort | tail -1`
}

function _gem_list {
  COMPREPLY=($(compgen -W "$(ls `gemdir`/gems)" -- "${COMP_WORDS[COMP_CWORD]}"))
}
function _gem_doc_list {
  COMPREPLY=($(compgen -W "$(ls `gemdir`/doc)" -- "${COMP_WORDS[COMP_CWORD]}"))
}

complete -F _gem_list cdgem
complete -F _gem_list mategem
complete -F _gem_doc_list gemdoc

complete -W 'apps1 apps2 db1 db2 legacy media router1 staging utilities' $default ssh

function tunnel {
  if [ "apps1_ipmi" == "$1" ]
  then
    ssh -L 8080:10.10.11.52:80 -N gateway@router1.xspond.com
  elif [ "db1_areca" == "$1" ]
  then
    ssh -L 8080:10.10.11.101:80 -N gateway@router1.xspond.com
  elif [ "db1_ipmi" == "$1" ]
  then
    ssh -L 8080:10.10.11.51:80 -N gateway@router1.xspond.com
  elif [ "db1_mongo" == "$1" ]
  then
    ssh -L 8888:db1:27017 -N gateway@router1.xspond.com
  elif [ "db1_mysql" == "$1" ]
  then
    ssh -L 3306:db1:3306 -N gateway@router1.xspond.com
  elif [ "db1_rabbitmq" == "$1" ]
  then
    ssh -L 15672:db1:15672 -N gateway@router1.xspond.com
  elif [ "db2_mongo" == "$1" ]
  then
    ssh -L 8888:db2:27017 -N gateway@router1.xspond.com
  elif [ "db2_rabbitmq" == "$1" ]
  then
    ssh -L 15672:db2:15672 -N gateway@router1.xspond.com
  elif [ "dtp_rdc" == "$1" ]
  then
    ssh -L 3389:dtp:3389 -N -C gateway@router1.xspond.com
  elif [ "netgear_http" == "$1" ]
  then
    open "http://localhost:9090/"
    ssh -L 9090:10.10.11.5:80 -N -C gateway@router1.xspond.com
  fi
}
complete -W 'apps1_ipmi db1_areca db1_ipmi db1_mongo db1_mysql db1_rabbitmq db2_mongo db2_rabbitmq dtp_rdc netgear_http staging_postgres' $default tunnel


# Functions
# #########

# Some example functions
# function settitle() { echo -ne "\e]2;$@\a\e]1;$@\a"; }

if type -t __git_ps1 > /dev/null
then
  export PS1="\h:\W \u\$(__git_ps1 ' {%s}')\$ "
elif which git > /dev/null
then
  export PS1="\h:\W \u\$(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/ {\1}/')\$ "
fi

# stty erase 

# Add git to the PATH
export PATH=$PATH:/usr/local/git/bin

# Add Java stuff to the path
export PATH=$PATH:/usr/local/maven/bin

# Add node to the path
export PATH=$PATH:/usr/local/node/bin:/usr/local/mongodb/bin

# Add MySQL to the path
export PATH=$PATH:/usr/local/mysql/bin

# Add git docs to manpath
export MANPATH=/usr/local/git/man:$MANPATH

# Setup CDPATH
PROJ_DIR="~/Projects/Work"
ORDERED_SUBFOLDERS="clients citadel libraries dealers blueprints assets infrastructure open_source"

CDPATH=".:~:$PROJ_DIR"
for FOLDER in $ORDERED_SUBFOLDERS; do
  CDPATH="$CDPATH:$PROJ_DIR/$FOLDER"
done

export CLICOLOR="1"

export RUBY_HEAP_MIN_SLOTS=250000
export RUBY_HEAP_SLOTS_INCREMENT=25000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=50000000

export BUNDLER_EDITOR=mate

# Set environment flags for build scripts
export ARCHFLAGS="-arch x86_64"
export JOBS=9

# Use rbenv
export PATH=$HOME/.rbenv/bin:$PATH
eval "$(rbenv init -)"

# Add bundler binstubs to the head of the path
export PATH=./.bin:$PATH

# Use GCC to compile for now, not clang
export CC=/usr/bin/gcc

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
