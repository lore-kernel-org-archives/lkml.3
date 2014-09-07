Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaIGUF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 16:05:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39715 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496AbaIGUFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 16:05:24 -0400
Message-ID: <1410120305.6822.9.camel@decadent.org.uk>
Subject: [PATCH RESEND] x86: Reject x32 executables if x32 ABI not supported
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sun, 07 Sep 2014 21:05:05 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-uAY0rl8HUPqi3/1ZBRRl"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uAY0rl8HUPqi3/1ZBRRl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

It is currently possible to execve() an x32 executable on an x86_64
kernel that has only ia32 compat enabled.  However all its syscalls
will fail, even _exit().  This usually causes it to segfault.

Change the ELF compat architecture check so that x32 executables are
rejected if we don't support the x32 ABI.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/elf.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 1a055c8..ca3347a 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -160,8 +160,9 @@ do {						\
 #define elf_check_arch(x)			\
 	((x)->e_machine =3D=3D EM_X86_64)
=20
-#define compat_elf_check_arch(x)		\
-	(elf_check_arch_ia32(x) || (x)->e_machine =3D=3D EM_X86_64)
+#define compat_elf_check_arch(x)					\
+	(elf_check_arch_ia32(x) ||					\
+	 (IS_ENABLED(CONFIG_X86_X32_ABI) && (x)->e_machine =3D=3D EM_X86_64))
=20
 #if __USER32_DS !=3D __USER_DS
 # error "The following code assumes __USER32_DS =3D=3D __USER_DS"


--=20
Ben Hutchings
Experience is directly proportional to the value of equipment destroyed.
                                                         - Carolyn Scheppne=
r

--=-uAY0rl8HUPqi3/1ZBRRl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVAy6d+e/yOyVhhEJAQqZXw//axU1vljWQQlJXSBuda89IssfBU/okwSj
UvWFwRXHCaMkQUjzqGQqUnxNWYI3Ayhfou1yoEZGSpwekahVR9T91K8wO4zj5jlu
C7bUq4lFHO6w8mdoGOAEtMsk1pEE4HJ3G2Evv0l200arcqH6ZcEOUDmH8vWZiMMC
kT8iBC6yY9/ZdjFKk1xxzGOzCLKVq7wRhmNsEFEWu74jE4xM1jprUHAbQ+0rnmaA
9Gy14yo93vHXWsuSyqc5WHqB2/RMNolQBUmDeF50d16x6al8ITJi6C4z9EEZt/E7
d7W3pt8l4C0FV+w9C6cIaBqJQszsAx8CkoqqiRKTS0bdMklMtJeAhO/pHSM9y56X
ENx2scfLcst7jge7AtNKRJR7trVIJ2s0c4dGz20UvkgSNoFlt4DwADIT4TUGzOA2
/0c3dVVCCybi3UNYe8G3bdFSmLOfwINehwfnHhogPh0JhTrKXfdZWHDWY2MH6RZ+
KYxe24VLiV5Uosy5Z4Oca8bBunTTU2SZ2L8wHD8PZpsOx9Teq9MayNJqEFfQa+fQ
ZMl+p41HVLyIw6fx+Hbh3CTimiEP/nY7LPLcTArHgsKrPqp6gPf5fBDaAEkY24gv
+vUGSzfn116kbczHIJ+n/Y4l5uQ7tp+CfhwCx5AMFPm9YQzOQ63M6IMisYrZ6WJO
00wxJLpjtyU=
=j3a8
-----END PGP SIGNATURE-----

--=-uAY0rl8HUPqi3/1ZBRRl--
