Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaGUHpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 03:45:34 -0400
Received: from ozlabs.org ([103.22.144.67]:38660 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799AbaGUHpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 03:45:32 -0400
Date: Mon, 21 Jul 2014 17:45:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>, James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: manual merge of the random tree with the security tree
Message-ID: <20140721174524.03ee7808@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/CSU2sqo54EteUSgO5dj=xiT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CSU2sqo54EteUSgO5dj=xiT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ted,

Today's linux-next merge of the random tree got conflicts in
arch/x86/syscalls/syscall_32.tbl, arch/x86/syscalls/syscall_64.tbl,
include/linux/syscalls.h and include/uapi/asm-generic/unistd.h between
commit 48dc92b9fc39 ("seccomp: add "seccomp" syscall") from the
security tree and commit 386474e168a8 ("random: introduce getrandom(2)
system call") from the random tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/syscalls/syscall_32.tbl
index 7527eac24122,f484e39e3c7d..000000000000
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@@ -360,4 -360,4 +360,5 @@@
  351	i386	sched_setattr		sys_sched_setattr
  352	i386	sched_getattr		sys_sched_getattr
  353	i386	renameat2		sys_renameat2
 -354	i386	getrandom		sys_getrandom
 +354	i386	seccomp			sys_seccomp
++355	i386	getrandom		sys_getrandom
diff --cc arch/x86/syscalls/syscall_64.tbl
index 16272a6c12b7,6705032c0520..000000000000
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@@ -323,7 -323,7 +323,8 @@@
  314	common	sched_setattr		sys_sched_setattr
  315	common	sched_getattr		sys_sched_getattr
  316	common	renameat2		sys_renameat2
 -317	common	getrandom		sys_getrandom
 +317	common	seccomp			sys_seccomp
++318	common	getrandom		sys_getrandom
 =20
  #
  # x32-specific system call numbers start at 512 to avoid cache impact
diff --cc include/linux/syscalls.h
index 1713977ee26f,cd82f72fc908..000000000000
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@@ -866,6 -866,7 +866,9 @@@ asmlinkage long sys_process_vm_writev(p
  asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
  			 unsigned long idx1, unsigned long idx2);
  asmlinkage long sys_finit_module(int fd, const char __user *uargs, int fl=
ags);
 +asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
 +			    const char __user *uargs);
+ asmlinkage long sys_getrandom(char __user * buf, size_t count,
+ 			      unsigned int flags);
+=20
  #endif
diff --cc include/uapi/asm-generic/unistd.h
index 65acbf0e2867,2926b1d04b88..000000000000
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@@ -699,11 -699,11 +699,13 @@@ __SYSCALL(__NR_sched_setattr, sys_sched
  __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
  #define __NR_renameat2 276
  __SYSCALL(__NR_renameat2, sys_renameat2)
 -#define __NR_getrandom 277
 +#define __NR_seccomp 277
 +__SYSCALL(__NR_seccomp, sys_seccomp)
++#define __NR_getrandom 278
+ __SYSCALL(__NR_getrandom, sys_getrandom)
 =20
  #undef __NR_syscalls
--#define __NR_syscalls 278
++#define __NR_syscalls 279
 =20
  /*
   * All syscalls below here should go away really,

--Sig_/CSU2sqo54EteUSgO5dj=xiT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTzMUYAAoJEMDTa8Ir7ZwVd3EP/3c9usSMOByIsxlgsspVWtsJ
vZ7/JKPDvN+SZLP+CHTd5oALgFs1n4KMBd1bavEat9k7o59CbJ4e61RDXKJ9RCw4
Mc1jMXyi1JAR+7igKy/ToZOjEM8q4BvE6qAs4bobI7xi9T52ZdD6OH8H3rJD9nmO
i2BvQHl0KT15d3xX0RP4vdPO9B5GRSjGtVoXLsir0UHUPRFKYVe85EG+g18dofco
5HfQavaMzEhmIducaIbnMOhC9fuB5X19YS7Wv3EQl9mdWhq2Fb57/bumJsUxmWD+
TGnQ7QLGiqcFUH5wRu3XXQkEWVuHJ5Krvd5YH9UJ4BbfHOFAbWMuzVe/QHpCmBB6
oloq6v3fivxSNTPUHuNEyB5JlTHnwUOnycLHeoEFTb+upB+fLEaDwlgTurGWfYzu
2y/wL0dpFBK4NVhuIPOfIwLT8wGxH/wgWw9uqu3ZP9r1nahAeBRw/Q2Zs3lSEXcu
+gWzVLcgiyrf4qbLFCpIStAuavVnnzfjiUk0C+hrsK+teNsSCyahouKBCTN8i1pW
N7h7fnLHqD/BlMGpUFXVAHPlqzDCorEXg7v0bFW3y5lSbdnqsB0lOebxKUtiPH8j
b6tBEgJIxCMoYNOi92/UFofQcIlIKt5/6HqaMmaEsBNIF1ITEbpa3Afkn4stnyGV
6LG2EIZva5NRazVYfnAq
=7KOr
-----END PGP SIGNATURE-----

--Sig_/CSU2sqo54EteUSgO5dj=xiT--
