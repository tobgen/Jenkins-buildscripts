class jenkinsslave ($slavename) {
  group { 'jenkins': ensure => present, }

  $usershell = $osfamily ? {
    /(OpenBSD|FreeBSD)/ => '/usr/local/bin/bash',
    solaris             => '/usr/bin/bash',
    default             => '/bin/bash',
  }

  $makeversion = $osfamily ? {
    solaris => 'gmake',
    default => 'make',
  }
  
  $configureoptions = $osfamily ? {
    default => '',
    solaris =>'--tre-includes="/usr/local/include"'
  }
  
   $configureextras = $::lsbmajdistrelease  ? {
    default => 'm_regex_pcre.cpp,m_regex_tre.cpp,m_ssl_gnutls.cpp,m_ssl_openssl.cpp',
    5       => 'm_regex_pcre.cpp,m_regex_tre.cpp,m_ssl_openssl.cpp'
  }

  $managehome = $::osfamily ? {
    Darwin  => false,
    default => true,
  }

  $homedir = $::osfamily ? {
    Darwin  => '/Users/tobgen/jenkins',
    Solaris => '/export/home/jenkins',
    default => '/home/jenkins',
  }

  $CXXCLANG = $::osfamily ? {
    Darwin  => 'clang++',
    default => 'clang++',
  }
    
  $CXXGCC = $::lsbmajdistrelease ? {
    5       => 'c++',
    14      => 'arm-linux-gnueabihf-g++',
    default => 'g++',
  }

  $clangoption = $::osfamily ? {
    Darwin  => '--with-cc=llvm-gcc',
    default => '--with-cc=clang',
  }

  $scriptdir = $::osfamily ? {
    Darwin  => 'osx',
    Debian  => 'debian6',
    FreeBSD => 'freebsd',
    OpenBSD => 'openbsd',
    RedHat  => 'centos59',
    Solaris => 'solaris',
    default => 'debian6',
  }

  user { 'jenkins':
    ensure     => present,
    home       => $homedir,
    shell      => $usershell,
    gid        => 'jenkins',
    require    => Group['jenkins'],
    managehome => $managehome,
  }

  file { "/home/jenkins/scripts/":
    ensure  => directory,
    mode    => 755,
    owner   => 'jenkins',
    group   => 'jenkins',
    require => User['jenkins'],
  }

  file { '/home/jenkins/slave.sh':
    ensure => file,
    mode   => 755,
    content => template("jenkinsslave/slave.sh.erb"),
    owner  => 'jenkins',
    group  => 'jenkins',
    require => User['jenkins'],
  }

  file { "${homedir}/scripts/inspircd-clang":
    ensure  => file,
    mode    => 755,
    content => template("jenkinsslave/inspircd-clang.erb"),
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  file { "${homedir}/scripts/inspircd-gcc":
    ensure  => file,
    mode    => 755,
    content => template("jenkinsslave/inspircd-gcc.erb"),
    owner   => 'jenkins',
    group   => 'jenkins',
  }
  
  file { "${homedir}/scripts/atheme70":
    ensure  => file,
    mode    => 755,
    content => template("jenkinsslave/atheme70.erb"),
    owner   => 'jenkins',
    group   => 'jenkins',
  }
  
  file { "${homedir}/scripts/unreal34":
    ensure  => file,
    mode    => 755,
    content => template("jenkinsslave/unreal34.erb"),
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  file { "${homedir}/scripts/libmowgli-2":
    ensure  => file,
    mode    => 755,
    content => template("jenkinsslave/libmowgli-2.erb"),
    owner   => 'jenkins',
    group   => 'jenkins',
  }

  file { "${homedir}/scripts/anope-19":
    ensure  => file,
    mode    => 755,
    content => template("jenkinsslave/anope-19.erb"),
    owner   => 'jenkins',
    group   => 'jenkins',
  }
  
    file { "${homedir}/scripts/charybdis35":
    ensure  => file,
    mode    => 755,
    content => template("jenkinsslave/charybdis35.erb"),
    owner   => 'jenkins',
    group   => 'jenkins',
  }
}
