Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751157AbaCREPq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 00:15:46 -0400
Received: from ozlabs.org ([203.10.76.45]:53460 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbaCREPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 00:15:44 -0400
Date: Tue, 18 Mar 2014 15:15:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>, Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>
Subject: linux-next: manual merge of the audit tree with the mips tree
Message-Id: <20140318151529.0b0acf9a6d74c6aca080efe0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Mar_2014_15_15_29_+1100_3y4HHsUKBftS/T/J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Mar_2014_15_15_29_+1100_3y4HHsUKBftS/T/J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the audit tree got conflicts in
arch/mips/include/asm/syscall.h and arch/mips/kernel/ptrace.c between
commits cdda64d4d01f ("MIPS: asm: syscall: Define syscall_get_arch"),
d746666c2862 ("MIPS: ptrace: Move away from secure_computing_strict") and
f5179287b016 ("MIPS: Fix randconfig build error") from the mips tree and
commits 74d0bf770dd6 ("syscall_get_arch: remove useless function
arguments") and e8d1226a197d ("audit: use uapi/linux/audit.h for
AUDIT_ARCH declarations") from the audit tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/include/asm/syscall.h
index 6c488c85d791,fc556d8052c9..000000000000
--- a/arch/mips/include/asm/syscall.h
+++ b/arch/mips/include/asm/syscall.h
@@@ -13,8 -13,7 +13,8 @@@
  #ifndef __ASM_MIPS_SYSCALL_H
  #define __ASM_MIPS_SYSCALL_H
 =20
 +#include <linux/compiler.h>
- #include <linux/audit.h>
+ #include <uapi/linux/audit.h>
  #include <linux/elf-em.h>
  #include <linux/kernel.h>
  #include <linux/sched.h>
@@@ -132,8 -105,7 +131,8 @@@ static inline int syscall_get_arch(void
  {
  	int arch =3D EM_MIPS;
  #ifdef CONFIG_64BIT
- 	if (!test_tsk_thread_flag(task, TIF_32BIT_REGS))
 -	arch |=3D  __AUDIT_ARCH_64BIT;
++	if (!test_tsk_thread_flag(current, TIF_32BIT_REGS))
 +		arch |=3D __AUDIT_ARCH_64BIT;
  #endif
  #if defined(__LITTLE_ENDIAN)
  	arch |=3D  __AUDIT_ARCH_LE;
diff --cc arch/mips/kernel/ptrace.c
index 4137a49eae26,65ba622baf3e..000000000000
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@@ -706,11 -671,10 +706,11 @@@ asmlinkage long syscall_trace_enter(str
  	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
  		trace_sys_enter(regs, regs->regs[2]);
 =20
- 	audit_syscall_entry(syscall_get_arch(current, regs),
+ 	audit_syscall_entry(syscall_get_arch(),
 -			    regs->regs[2],
 +			    syscall,
  			    regs->regs[4], regs->regs[5],
  			    regs->regs[6], regs->regs[7]);
 +	return syscall;
  }
 =20
  /*

--Signature=_Tue__18_Mar_2014_15_15_29_+1100_3y4HHsUKBftS/T/J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJ8hlAAoJEMDTa8Ir7ZwV8lYP/icvMK/pMXbBP0axym3GKB7R
gRzeL6yXpzIvH8dh4+O3M5kpv1Kygn34OnpzvRVHoFMAGf5KxSYGg03xg0FT+qhj
rNq2owgteX/hz+pM8ilHOy3/DlVLLamje8OfAPLp6YWaprKpiL7B2tdBaDf93ELc
oWG1NpKuVV70ZEQK71xIN3m80Nb+y7ouGLWgEVRuWbd69ZVPRUfeDCRvx7Ol126C
6Suku8VG81rYi2r4KsjNvw3jihztv6Lf18WBM1Jj7CDMPji3nZ7pn2zhYhJxoFdC
fwoaWN+lMXxCCNu4zMOW6c2YiZPQmq2T5mFtpv3KDJYpFEAL4FbG1vND2j5Xlu3I
qISn3GrLQuWL2VEiSo4QNUoZn0liybxpgquZstN0wu8nh3ZmH8ZBC6RXvc5rzXGe
QboH/pe5IAkKT5/+CVqZKoVq85J1xY432w9wNnLKZc768jBZ3crieP3Ni/jJ4D2q
/cajSf4qagb0yuMgqeYF2Pk2kQWBfTeOrpkmfnGHiAv2K/6FlBnKmSy0OvUu6RaM
JIB5w0RoUfRik8iTPnLANlhQhKxR4emZ+tXianKR5yAl4tiFrhE2TaFYcCuhS3ae
xGn3qbWtZ7pt+m874NhMH7yW/81gYJC3a2YDRWXfMVTSj8FkfkQHOXnqMJaukhP3
JPvPtvRXXa5MnUuGZa9g
=uRdS
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Mar_2014_15_15_29_+1100_3y4HHsUKBftS/T/J--
