Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab3GZBwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 21:52:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757303Ab3GZBwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 21:52:20 -0400
Message-ID: <51F1D64A.202@redhat.com>
Date: Thu, 25 Jul 2013 20:52:10 -0500
From: David Smith <dsmith@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Systemtap List <systemtap@sourceware.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LWN <lwn@lwn.net>
Subject: systemtap 2.3 release
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The systemtap team announces release 2.3, "jbnq fdhvjjry"!

   improved pass-2 error messages, runtime preprocessor conditionals,
   global module variable visibility, internal improvements,
   colorized error messages, uprobe pre-filtering, re-written
   regular expression support

= Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-2.3.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=615
  git tag release-2.3 (commit e5813857)

  There have been over 200 commits since the last release.
  There have been over 50 bugs fixed / features added since the last
  release.


= How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=systemtap.git;a=tree

  Further information at http://sourceware.org/systemtap/wiki/


= Systemtap frontend (stap) changes

- java("org.my.MyApp") probes are now restricted to pre-existing jvm
  pid's with a listing in jps -l output to avoid recursive calls

- Alternative functions are now suggested when function probes could
  not be resolved. For example, kernel.function("vfs_reads") will
  suggest vfs_read. Other probes for which suggestions are made are
  module.function, process.function, and process.library.function.

- Has life been a bit bland lately? Want to spice things up? Why not
  write a few faulty probes and feast your eyes upon the myriad of
  colours adorning your terminal as SystemTap softly whispers in your
  ear... 'parse error'. Search for '--color' in 'man stap' for more
  info.

- systemtap's dyninst runtime now allows use of the -c command
  parameter to target runtime over the course of a process

- global module variables are now available to probe with the @var
  syntax


= Systemtap script language changes

- A "runtime" preprocessor conditional has been added as follows:

    %( runtime == "kernel" %?
    # do something we can only do in kernel mode
    %)

    %( runtime == "dyninst" %?
    # ...
    %)

- The notation @var("varname@cuname", "module") is used for accessing
  global variables.  If the cuname is not specified, then all cu's are
  searched

- Support for the Posix ERE named character classes has been added to
  the regexp engine, e.g. [:digit:], [:alpha:]


= Systemtap runtime changes

- The java backend now requires the targeted process to be pre-existing.

- Systemtap now makes use of the kernel uprobes pre-filtering to call
  UPROBE_HANDLER_REMOVE for any process that happens to share the same
  inode.  This removes unwanted overhead on unrelated processes.

- A substantial internal overhaul of the regexp engine has resulted in
  correct behaviour on further obscure edge cases. The regexp engine
  now implements the ERE standard and correctly passes the testsuite
  for the glibc regexp engine (minus portions corresponding to
  unimplemented features -- i.e. subexpression capture and reuse).


= Systemtap tapset changes

- New tapsets:
  rcu.stp		  Read-copy-update lock tapset

- Changed tapsets:
  context.stp		  added various process context functions
  target_set.stp 	  created(func equiv of linux/target_set.stp)
  aux_syscalls.stp	  updated for latest kernel changes
  guru-signal.stp	  created(ability to raise a signal in the
                          current thread)
  nd_syscalls.stp	  use sigaltstack probe alias when
                          CONFIG_GENERIC_SIGALTSTACK is set or
  			  when on kernel v3.9+
  syscalls.stp		  ditto
  ipmib.stp		  updated probe aliases
  nd_syscalls.stp	  'syscall.{execve,compat_execve}' on newer
                          kernels, use of CONFIG_GENERIC_SIGNALSTACK
  nd_syscalls2.stp	  ditto
  nfs_proc.stp		  Abstract use of nfs_{read,write,commit}_data
                          structs in macro file
  nfs_proc.stpm		  said macro file
  rpc.stp		  updated aliases
  socket.stp		  function deprecations (see NEWS) and use of
                          macros
  syscalls.stp		  Fix 'syscall.{execve,compat_execve}'
  syscalls2.stp 	  Break {nd_}syscall.rt_sigprocmask into
                          'rt_sigprocmask' and 'compat_rt_sigprocmask'
  target_set.stp 	  use process.{begin,end} probes to better
                          track the process
  tcp.stp		  make use of ntohs() function for return values
  tcpmib.stp		  ditto
  ucontext.stp		  properly error/warn if _stp_umod_lookup fails
  udp.stp 		  add source/dest ip/port variables
  string.stp		  adds error checking
  tzinfo.stp		  split into dyninst and linux implementation
                          tapsets
  uconversions.stp 	  error checking improvements and added
                          user_string2_warn and user_string2_n_warn

- The function user_string() has been superseded by the function
  user_string_quoted()

- The tapset [nd_]syscall.semop parameter tsops_uaddr is renamed
  sops_uaddr for consistency with [nd_]syscall.semtimedop.

- The following tapset functions are deprecated in release 2.3:
  'stap_NFS_CLIENT', '__getfh_inode', '_success_check',
  '_sock_prot_num', '_sock_fam_num', '_sock_state_num',
  '_sock_type_num', and '_sock_flags_num'.

= Systemtap sample scripts

- New samples:
  semop-watch.stp              demonstrates pulling apart userspace
                               struct/array parameters from syscall.*
                               probe context
  thread-business.stp	       monitor syscall history
  pf4.stp		       time based sampling of the top 20 stack
                               backtraces (kernel or user) on a per-cpu
                               basis

- Changed samples:
  ioblktime.stp		increase global array size to allow capture of
                        more statistics
  traceio.stp     	check for and throw any negative return values
  tcpdumplike.stp  	extend to show new demo new variable captures
  errsnoop.stp     	reduced the memory consumption
  mutex-contention.stp 	fixed readability
  pfiles.stp 	       	must be run with guru mode enabled
  plimit.stp 	       	enabled invocation with -x PID as well as $1
  pf3.stp	       	fix umodname() eliding issues

- Removed samples:
  tcp.stp

= Examples of tested kernel versions

  2.6.9 (i686)
  2.6.18 (x86_64)
  2.6.32 (x86_64, ppc64)
  3.8.12 (x86_64)
  3.9.8 (x86_64)
  3.9.9 (armv7l)
  3.10.0 (x86_64)
  3.11-rc0 (x86_64)

= Known issues with this release

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.  (PR2725)

- The java byteman backend is a work in progress.  Some installation
  steps are manual, and not enough context variables are available.

- 32-on-64 bit userspace unwinding is truncated on older kernels, such
  as 2.6.32 (PR15757)

- The dyninst backend is still very much a prototype, with a number
  of issues, limitations, and general teething woes. For instance:
  + lack of support for multiarch/cross-instrumentation
  + tapset functions are still incomplete relative to what is supported
    when the kernel backend is active
  + exception handling becomes completely broken in programs
    instrumented by the current version of dyninst (PR14702)
  + command line interrupts are slightly mishandled (PR15049)
  + not all registers are made available on 32-bit x86 (PR15136)

  See dyninst/README and the systemtap/dyninst Bugzilla component
  (http://tinyurl.com/stapdyn-PR-list) if you want all the gory
  details about the state of the feature.


= Contributors for this release

  Alexander Y. Fomichev*, Casey Dahlin*, Dave Brolley, David Smith,
  Frank Ch. Eigler, Jonathan Lebon*, Josh Stone, Lukas Berk, Mark
  Wielaard, Martin Lazar*, Peter Feiner*, Raphaël Beamonte*, Serguei
  Makarov, Timo Juhani Lindfors, Torsten Polle, William Cohen, Yang
  Wen*, Yichun Zhang (agentzh)*, Zifei Tong

  Special thanks to new contributors, marked with '*' above.
  Special thanks to Lukas Berk for compiling these notes.

= Bugs fixed for this release <http://sourceware.org/PR#####>

9771   Detecting probes classes system wide
10272  backtraces fail with 32-on-64 executables
10395  testsuite/systemtap.base/kmodule.exp fails when ext3 isn't a
       module
11096  Getting global module vars in functions
11414  nd_syscall.exp failures
13977  rlimit tests fail as-root portions
14440  improve plimit.stp example to take -x PID
14454  respect /etc/modules /etc/depmod.d/* module overriding directives
14665  stapdyn should handle signals and clean up nicely
14791  stapdyn needs output file ('-o') option
14927  color error/warning messages
15029  stapdyn needs better exit values
15044  eradicate cutesy errorish return texts
15063  regular expressions: correct subtleties with ^ and $ anchoring
15064  regular expressions: named character class support
15066  regular expressions: clean up and integrate re2c code
15083  stapdyn needs system() support
15110  dyninst needs duplicate warning elimination
15193  assigned_user_credentials = pr_stapdev
15198  syscall.sigaltstack / nd_syscall.sigaltstack broken on rawhide
15278  Use uprobes pre-filtering in kernel 3.9
15375  improve pass-2 error messages
15481  stapdyn end probes fail with a -c command
15484  child of PR13193, optimized-kprobes kernel crashes
15486  stapdyn get hung when printing debug messages
15513  add a "runtime" preprocessor conditional
15523  socket tapset broken
15525  The syscall.open probe alias has an odd flag string
15543  the sunrpc.clnt.clone_client probe alias is broken
15549  the 'sunrpc.clnt.create_client' probe alias doesn't work on
       rawhide
15554  nfs.proc.commit_done probe returning invalid data
15556  stapbm causes recursive calls with multiple java probes
15572  on rawhide, the ipmib.InNoRoutes and ipmib.InAddrErrors probes
       don't work
15575  __tcp_sock_dport and __tcp_sock_sport should return host order
15587  ine numbers are missing/incorrect for inline statements
15617  user_string_n_quoted() does not truncate properly
15619  on rawhide ia32, simple scripts sometimes hang
15624  stapdyn deref failure with high pointers on i686
15656  SELinux blocks Dyninst attach if allow_execmod is off
15659  On rawhide, the "mount" subtests of the syscall.exp and
       nd_syscall.exp test fail
15669  syscall probe handlers are called exactly twice for every
       syscall on Amazon Linux
15673  stapdyn fails to write memory
15675  'kprobe.module("foo").function("bar")' probes do not work
15688  Accessing globals in DSO or PIE results in read faults
15690  syscall.rt_sigprocmask probe alias broken on s390x/ppc64 for
       32-bit apps
15727  perf probes fail on rawhide
15731  syscall.execve probe alias broken on rawhide
15740  stapdyn linking failed
15743  dyninst "utrace" probes (with a path) seem to be broken
15751  on rawhide, sigaction32/old_sigaction32 have been replaced
15782  nss usage bugs - PR_Read returning short results
