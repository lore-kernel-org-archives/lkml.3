Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbaG1IyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:54:19 -0400
Received: from ozlabs.org ([103.22.144.67]:47132 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbaG1IyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:54:17 -0400
Date: Mon, 28 Jul 2014 18:54:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: manual merge of the random tree with the security tree
Message-ID: <20140728185408.4d288309@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/b5ez6FDW7a9Je.Z1S_AxTEo"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/b5ez6FDW7a9Je.Z1S_AxTEo
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Theodore,

Today's linux-next merge of the random tree got conflicts in
arch/x86/syscalls/syscall_32.tbl, arch/x86/syscalls/syscall_64.tbl,
include/linux/syscalls.h and include/uapi/asm-generic/unistd.h between
commit 48dc92b9fc39 ("seccomp: add "seccomp" syscall") from the
security tree and commit fd6f349345c7 ("random: introduce getrandom(2)
system call") from the random tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/syscalls/syscall_32.tbl
index 7527eac24122,5b46a618aeb1..000000000000
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@@ -360,4 -360,4 +360,5 @@@
  351	i386	sched_setattr		sys_sched_setattr
  352	i386	sched_getattr		sys_sched_getattr
  353	i386	renameat2		sys_renameat2
 +354	i386	seccomp			sys_seccomp
+ 355	i386	getrandom		sys_getrandom
diff --cc arch/x86/syscalls/syscall_64.tbl
index 16272a6c12b7,0dc4bf891460..000000000000
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@@ -323,7 -323,7 +323,8 @@@
  314	common	sched_setattr		sys_sched_setattr
  315	common	sched_getattr		sys_sched_getattr
  316	common	renameat2		sys_renameat2
 +317	common	seccomp			sys_seccomp
+ 318	common	getrandom		sys_getrandom
 =20
  #
  # x32-specific system call numbers start at 512 to avoid cache impact
diff --cc include/linux/syscalls.h
index 1713977ee26f,43324a897cf2..000000000000
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@@ -866,6 -866,7 +866,9 @@@ asmlinkage long sys_process_vm_writev(p
  asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
  			 unsigned long idx1, unsigned long idx2);
  asmlinkage long sys_finit_module(int fd, const char __user *uargs, int fl=
ags);
 +asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
 +			    const char __user *uargs);
+ asmlinkage long sys_getrandom(char __user *buf, size_t count,
+ 			      unsigned int flags);
+=20
  #endif
diff --cc include/uapi/asm-generic/unistd.h
index 65acbf0e2867,1d104a2ca643..000000000000
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@@ -699,11 -699,11 +699,13 @@@ __SYSCALL(__NR_sched_setattr, sys_sched
  __SYSCALL(__NR_sched_getattr, sys_sched_getattr)
  #define __NR_renameat2 276
  __SYSCALL(__NR_renameat2, sys_renameat2)
 +#define __NR_seccomp 277
 +__SYSCALL(__NR_seccomp, sys_seccomp)
+ #define __NR_getrandom 278
+ __SYSCALL(__NR_getrandom, sys_getrandom)
 =20
  #undef __NR_syscalls
- #define __NR_syscalls 278
+ #define __NR_syscalls 279
 =20
  /*
   * All syscalls below here should go away really,

--Sig_/b5ez6FDW7a9Je.Z1S_AxTEo
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT1g+2AAoJEMDTa8Ir7ZwV/FgP/0RwuG0o3TwnD5yXt/XvC7+C
dKjIytGCa7l53m98G00uwCFh/APjlMbDqlKmOD4zw+2XHPmZF/jhGJlL/EIhYulm
3qZH3MEwEBSPjtb48909f1DETgThSs0Nkcji38FlCIRGPKaDnx/3QRgT7LVglj/X
YiFQRnePX1Wm5Z6ggciY+CiyM15BSCyz+Q2IgQAZBw8i6DVav7x+9vpPRKAUQSIX
8qNeystsNRCJJ5GnYup+W1jebeVn0mudURlk93mXvml2YxE94sXwXBc/kGuzVoA0
grCv/iPAvzgD7wNpHNtcNe683jl753hGvecHVgp7BdK82GaEF+x2rXdI/4UcfZl+
UZ8gBV5hNCV2Ojl/Z0ETo2B9MgHQQV7zoaheMmXCl/OZeDHnBpiUd20an7PygibG
siKtIInNcw37LSdEgtEkDk99hxPenUeF0/ALNlDehyrTLRe/bnZzUHxx9MnxmFP1
2+ErivU3YF8y3pIukqI5T+VfE3/feqETxA6V+DnDOTr9CsSdG+hQUlBdYdoMr37K
P4kFRV5ALnW61KkamM5Vt9sKnqvf27mElQS8yIG7vo6GLt5UdKRpXdJZx0LjkXkO
gndT1TzwqZKBrosuScNvCuu1/nCo/Q3BnwfmnhQIB58/uzaen5qHTbtLeH/jAPm3
0ckbTaeBHNP6OMrU8sJr
=GuxE
-----END PGP SIGNATURE-----

--Sig_/b5ez6FDW7a9Je.Z1S_AxTEo--
