Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaG0DUR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 23:20:17 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57897 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751219AbaG0DUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 23:20:15 -0400
Message-ID: <1406431195.29010.154.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] x86: Reject x32 executables if x32 ABI not supported
From: Ben Hutchings <ben@decadent.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 708070@bugs.debian.org
Date: Sun, 27 Jul 2014 04:19:55 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-cGr9/ewGvn1DFM/27PHw"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cGr9/ewGvn1DFM/27PHw
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
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-cGr9/ewGvn1DFM/27PHw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU9Rv4ee/yOyVhhEJAQoyKhAAngP+6aHv7U/znLC5gpO/sGd3jAhgBlJ/
UBZOnM8wTLkemOvYSBjMDFW6hnDhXDXGkTDGK6WXm2xbOdwX/OKy+EIuFkh+mM3X
VdNlOC4nxAQNN5/YVurAGzxT/idzpiSE+Hd8LkDYb8qtVBVAs/ALmwnpdwkUA7b9
+pY15K0iZmTuFHgGErfwWxd45aFHYkKCc5pY9uWIdS/gzPAzpBe2jpSaeraYoiHa
jFwM4ATVclg5RR17unblT1ETfsWqUG4HJYjLsDHEp66nI20gJuvbz5x3NHWoCet/
Zld3xNttMev9xRl50iwk6dWHY8rqCkbpEhoC8plMwBNZSRoMZpM1dHs6+e4o3xXO
SvdNlYUlnWnm8Ri515ucEyUWMyV3VW2iWg/Xtsvfz1vPgUWDgEjqmX6PudqVl4xZ
t64EwiOE2tFjpojteQbtYkhhJHVCWuu7+EzWKJfcS21ZNJY4jUY0A2DEhxNK+c/j
gx85acTg8JbMqH1We5D5u1yt4qu5+FwgyW2NlRcnWTwQmh1OSzJLAe+TbANQ+Ftr
WFt6yZVaSdHZxFNhqZdhnBdhigW2vT2ZwYKMfoDQQqBilrZyJqLZ15OTsJpVkjHG
uRnhikj927zaCBVhjHJs1+X051Dyt9Izpk4O69BoNo5Gyn2fsrCkHl34fnWI/RMI
NIsGh2d6fJs=
=ht2l
-----END PGP SIGNATURE-----

--=-cGr9/ewGvn1DFM/27PHw--
