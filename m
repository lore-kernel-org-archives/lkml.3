Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaDVD6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 23:58:48 -0400
Received: from ozlabs.org ([103.22.144.67]:33332 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244AbaDVD6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 23:58:46 -0400
Date: Tue, 22 Apr 2014 13:58:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the audit tree with Linus' tree
Message-Id: <20140422135839.7c0471ebff244cf3d123e276@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_Apr_2014_13_58_39_+1000_ZyDcQpCMnUcyEUiD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Apr_2014_13_58_39_+1000_ZyDcQpCMnUcyEUiD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the audit tree got a conflict in
arch/mips/kernel/ptrace.c between commits 6e34574603f6 ("MIPS: asm:
syscall: Define syscall_get_arch") and 1225eb825208("MIPS: ptrace: Move
away from secure_computing_strict") from Linus' tree and commit
8ea408a0c1e7 ("ARCH: AUDIT: audit_syscall_entry() should not require the
arch") from the audit tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/kernel/ptrace.c
index 71f85f427034,8b393bcf7919..000000000000
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@@ -649,11 -677,8 +649,9 @@@ asmlinkage long syscall_trace_enter(str
  	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT)))
  		trace_sys_enter(regs, regs->regs[2]);
 =20
- 	audit_syscall_entry(syscall_get_arch(),
- 			    syscall,
- 			    regs->regs[4], regs->regs[5],
 -	audit_syscall_entry(regs->regs[2], regs->regs[4], regs->regs[5],
++	audit_syscall_entry(syscall, regs->regs[4], regs->regs[5],
  			    regs->regs[6], regs->regs[7]);
 +	return syscall;
  }
 =20
  /*

--Signature=_Tue__22_Apr_2014_13_58_39_+1000_ZyDcQpCMnUcyEUiD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVejzAAoJEMDTa8Ir7ZwVnD0P/27VaAk0Zyce+khrJWx1p4lV
Vu4oaVxN/E/a8ZEtkgvBvscOxIVHw9MZheolWSfNt24ePQpPLgNAVP8wBasmVg98
rgsn6GTw8twGP/eXdkowoBjQyvVEawlUpggRwu2C9Hprq0GV8ZhxDfwqdFN3nr7v
UuOoFcImR9cFPn5yxpMiGeZ8uSc6UHwW1+x5AZxxTvSdns8bJHa4xRcIdDrIzq9n
x1CRN9z7dZi+X1Aiy4rIQoRWtUIGW/plpHUIBa3R+XzywE800YHd90ruCDEeIByt
QyflR26RWeNnV9C5MIfpR/6+WrPHIcYxfPLju2pxEaZj5+1ER1iskmSu40rpEvsK
Bc4c0C6XP1O5zhxNXAlCudJxxjhfpolT+FR/WHI++bc77/F1gHxVPm237SskiLnA
uRPuvMFPfv1nEaatTOyTdns2k7ncr4TqVFvU+Za8ZgrT3l1atbUeIR1KonQibTa6
Wc5uelWTOYln10++MMwdQxDk8f/CAz9cLlzJDxHb7fXUyQSdGjcBjhFl4w3MPZ5b
TBNtOtWJTxYP1P5Reapvnl6zl1KoZSIeKA6UH2VWyCPC4jUb+jv5+0e/Xawu97UE
44ouxVvv98LJdgtQQ9yGTXk7AGIBoYE28Vy7CiRQ7Ec5WE8pas8gA5YKACeq27g6
UmmXlRj5SOESeD4sSOtr
=yIT0
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Apr_2014_13_58_39_+1000_ZyDcQpCMnUcyEUiD--
