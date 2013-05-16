Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab3EPOuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:50:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19573 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953Ab3EPOuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:50:24 -0400
Date: Thu, 16 May 2013 10:50:06 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: systemtap@sourceware.org
Cc: linux-kernel@vger.kernel.org, lwn@lwn.net
Subject: systemtap 2.2.1 release
Message-ID: <20130516145006.GA21409@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9DWx/yDrRhgMJTb"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/9DWx/yDrRhgMJTb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The systemtap team announces release 2.2.1, "jZlakVTeCT"!

Java method probing support using Byteman, stapdyn -G global variable suppo=
rt,=20
misc stapdyn bugfixes & internal improvements

=3D Where to get it

  http://sourceware.org/systemtap/ - our project page
  http://sourceware.org/systemtap/ftp/releases/systemtap-2.2.1.tar.gz
  http://koji.fedoraproject.org/koji/packageinfo?packageID=3D615
  git tag release-2.2.1 (commit 9c4e07c8a3)

  There have been over 200 commits since the last release.
  There have been over 30 bugs/features fixed since the last release.


=3D How to build it

  See the README and NEWS files at
  http://sourceware.org/git/?p=3Dsystemtap.git;a=3Dtree
  Further information at http://sourceware.org/systemtap/wiki/


=3D Systemtap frontend (stap) changes

- Basic support has been added for probing Java methods using Byteman
  http://www.jboss.org/byteman as a backend. Java method probes can
  target method entries, returns, or specific statements in the method
  as specified by line number.  They perform much better than the
  hotspot.method_** probes that instrument all-or-none of the entire java a=
pp.

  probe java("org.my.MyApp").class("^java.lang.Object").method("foo(int)")
    { println($$parms) }

  See java/README for information on manual setup for Java/Byteman
  functionality.  Set env STAPBM_VERBOSE=3Dyes for more tracing.

- A systemd service file and tmpfile have been added to allow
  systemtap-server to be managed natively by systemd.
 =20
=3D Systemtap runtime changes

- The dyninst backend has improved in several aspects:
  - Setting custom values for global variables is now supported, both
    with -G when compiling a script, and from the stapdyn command line
    when loading a precompiled module.
  - A transport layer has been added for two-way communication between
    the stap process and the target process. For now, this allows systemtap
    output to be correctly printed to the stdout of the stap process, rather
    than the target's stdout.


=3D Systemtap tapset changes

- Due to the removal of register_timer_hook in recent kernels, the
  behaviour of timer.profile has been changed slightly. This probe is
  now an alias which uses the old mechanism where possible, but falls
  back to perf.sw.cpu_clock when the kernel timer hook is not
  available.

  To require the kernel timer hook mechanism in your script, use
  timer.profile.tick instead of timer.profile.

- New tapsets:
  timers.stp       defines timer.profile probe alias

- Changed tapsets:
  nfsd.stp         add uid, gid convenience variables to nfsd.proc.*
                   in nfsd.proc4.write, set vlen to 0 if wr_vlen doesn't ex=
ist
  syscalls2.stp    add syscall.sendmmsg and syscall.sendmmsg.return
  nd_syscalls2.stp ditto
  task_time.stp    add cputime_to_usecs() and usecs_to_string()

- The following tapset variables are deprecated in release 2.2:
  - The 'origin' variables in the 'generic.fop.llseek',
    'generic.fop.llseek.return', and 'nfs.fop.llseek' probes. The
    'origin' variable has been replaced by the 'whence' variable.
  - The 'page_index' variable in the 'vfs.block_sync_page' and
    'vfs.buffer_migrate_page' probe aliases.
  - The 'write_from' and 'write_upto' variables in the
    '_vfs.block_prepare_write' and '_vfs.block_prepare_write.return'
    probe aliases.
  - The 'regs' variable in the 'syscall.sigaltstack',
    'nd_syscall.sigaltstack', 'syscall.fork', and 'nd_syscall.fork'
    probe aliases.
  - The 'first', 'second', 'third', and 'uptr_uaddr' variables in the
    'syscall.compat_sys_shmat' and 'nd_syscall.compat_sys_shmat' probe
    aliases.

- The following tapset functions are deprecated in release 2.2:

  'ppos_pos', '_dev_minor', and '_dev_major'

- The following tapset functions used to return error strings instead
  of raising an error. The original behavior is deprecated in release
  2.2.

  'ctime', 'probemod', 'modname'


=3D Systemtap sample scripts

- New samples:
  eatmydata.stp - (guru mode) suppress fsync() syscalls in indicated process

- Changed samples:
  hw_watch_addr.stp     use a more-likely-to-trigger target symbol
  hw_watch_sym.stp      ditto
  iodevstats.stp        switch from _dev_minor and _dev_major to MINOR and =
MAJOR
  mutex_contention.stp  drop compulsory array-size argument


=3D Examples of tested kernel versions

3.10-rc1 (i686, x86_64)
3.9.0 (x86_64)
3.8.11 (armv7l)
3.5.0 (i686)
3.4.0 (armv7l)
2.6.18 (i686, x86_64)
2.6.9 (i686)


=3D Known issues with this release

- Some kernel crashes continue to be reported when a script probes
  broad kernel function wildcards.  (PR2725)

- The java byteman backend is a work in progress.  Robustness issues
  are suspected with concurrent user and/or JVM usage, and some
  installation steps are manual.  Not enough context variables are
  available.  But it's a start!


- The dyninst backend is still a work in progress. Current issues:
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


=3D Contributors for this release

Dave Brolley, David Smith, Frank Ch. Eigler, Josh Stone, Lukas Berk,
Mark Wielaard, Masanari Iida*, Negreanu Marius Adrian, Serguei Makarov,
Timo Juhani Lindfors, Torsten Polle

Special thanks to Serguei Makarov for drafting these notes.
Special thanks to new contributors, marked with '*' above.


=3D Bugs fixed for this release <http://sourceware.org/PR#####>

11341 update_visitor::require/provide uses hazardous static_casts
12894 Provide a systemd target replacing the current stap-server initscript
14275 Possible hotspot.function(" ") style probes
14297 stap -l and pn() fail to expand complex wildcards
14491 Add a proper stapdyn transport layer
15053 stapdyn needs -G (setting global variables) support
15112 Can't connect to stap-server via IPv6 raw hex addresses
15114 [PATCH] Propagate uid and gid from nfsd module as well
15123 workaround for bad debuginfo for -mfentry
15147 _stp_error() doesn't behave as described
15155 syscall tapset doesn't know sendmmsg
15162 eh_frame table too big, may kernel panic
15168 tolerate ppc deprecated ptrace commands
15170 nfsd.proc4.write probe alias needs updating
15171 inet_get_local_port() tapset function is broken on rawhide kernels
15172 tolerate unavailable System.map, as on ubuntu
15173 'origin' renamed to 'whence'
15177 need to handle new 'whence' values of 'SEEK_DATA' and 'SEEK_HOLE'
15197 syscall.fork/nd_syscall.fork broken on rawhide kernels
15198 syscall.sigaltstack / nd_syscall.sigaltstack broken on rawhide
15211 syscall.exp failures on rawhide
15237 adapt to changes in hlist_* kernel api in 3.9
15279 Stop munging the uprobes IP with kernel 3.9
15290 Update the inode-uretprobes support for aarapov's latest iteration
15306 stapdyn IRPC on terminated process, child SEGV
15315 Implement basic process filtering for inode-uprobes
15363 don't abort for a measly inode-uprobes registration failure
15408 procfs probes broken on rawhide
15422 loc2c with 32-on-64 sometimes creates integer-widening-into-pointer g=
cc warnings
15445 kernel.data (hwbkpt) probes can cause kernel panic on i686
15446 procfs probes broken on rawhide (kernel 3.10)  =20
15452 segmentation fault in libdw while running debugtyptes.stp on rawhide =
 =20
15456 syscalls and nd_syscalls tapset compat probe points broken on kernel =
3.10
15466 add fallback for timer.profile on kernels without register_timer_hook=
()



--/9DWx/yDrRhgMJTb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFRlPIeVZbdDOm/ZT0RAtlcAJ9Mui7K7jvC4JfBYL44W109+jHIlgCcCvO6
/1wdQLSMEaphvfKBmIvIuKA=
=Nqg1
-----END PGP SIGNATURE-----

--/9DWx/yDrRhgMJTb--
