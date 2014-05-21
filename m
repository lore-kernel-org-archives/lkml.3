Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402AbaEUEMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 00:12:41 -0400
Received: from ozlabs.org ([103.22.144.67]:40979 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaEUEMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 00:12:40 -0400
Date: Wed, 21 May 2014 14:12:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-ID: <20140521141231.5752baae@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/p_mjuqMg51itUvlnSq8w56K"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/p_mjuqMg51itUvlnSq8w56K
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/vdso/vdso32-setup.c between commit fa81511bb0bb ("x86-64,
modify_ldt: Make support for 16-bit segments a runtime option") from
Linus' tree and commit 18d0a6fd2271 ("x86, vdso: Move the 32-bit vdso
special pages after the text") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/vdso/vdso32-setup.c
index e1f220e3ca68,c3ed708e50f4..000000000000
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@@ -36,12 -21,6 +21,10 @@@
  #define VDSO_DEFAULT	1
  #endif
 =20
 +#ifdef CONFIG_X86_64
- #define vdso_enabled			sysctl_vsyscall32
- #define arch_setup_additional_pages	syscall32_setup_pages
 +extern int sysctl_ldt16;
 +#endif
 +
  /*
   * Should the kernel map a VDSO page into processes and pass its
   * address down to glibc upon exec()?

--Sig_/p_mjuqMg51itUvlnSq8w56K
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTfCe1AAoJEMDTa8Ir7ZwVPuwP/2q8ochgYOtVoD//ifHSVOV9
AASfWB9Kmjocr6phz4SMq0HOTlAgdKZ14flEeIQB7nhCA7L2nUhNbSIx8peiIenF
iWDi2x/dZR0RBybVYhASJegjWiW8e37nKxCOptPET6DCQqw5ejsrBkoaERGZWtxS
tlYe4X6k4ZIzFGlJOd4vX4CvdVKsKF3Hjxwe57QgLd0dQt6JxQhbdJxqqzXjtJ5O
VgrQplqbgM8Yn2sk17LaP565crSpFJ7LwSH+FgZ7rr83BD3S3bWPFCXAxIIzffNm
8sxWAuHfK2KLXAGbNw+Ldeewy/6Z5ZrP63WLN1b4ugRlqvV4kDfJcxTPSNXAeSix
1wtI28wtmBLQX/F2oCR5P9IIBr55WowZ6KenYNu69A+f/LFyuFhYxIiGR0csHe8n
oLcTvZMOkT5aFo2ceQ4EZLsMFc7GIlD3W5meOwwYUzqA7u6+dKVwJOc139TY9zCK
ylxwYk/BnwRjNPSIDygXtgT0RFzQSmeixKDmshzP3NYCRh69aSPH2VflFKBQoFEF
uXjWQz6lUEOUxI9ms1JaESk6f8JuRHFjMskg89NBiS7Lu68fosyHarGRV3XZ7kDj
IHY1oTWxI6LUReXH0Dy95r+hyHzgOjs2/We+hTc3bSKeGP3KeuPA+FUGRMb6ZDQ4
lXUGUk66QLMLDVOslK4Y
=WZiL
-----END PGP SIGNATURE-----

--Sig_/p_mjuqMg51itUvlnSq8w56K--
