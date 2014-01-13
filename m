Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaAMD0g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 22:26:36 -0500
Received: from ozlabs.org ([203.10.76.45]:57513 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaAMD0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 22:26:30 -0500
Date: Mon, 13 Jan 2014 14:26:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Chris Zankel <chris@zankel.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: linux-next: manual merge of the tip tree with the xtensa tree
Message-Id: <20140113142619.6b3b48a7e48c0d57591d0c7e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Jan_2014_14_26_19_+1100_UTFhpGX=tRhfqy=y"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Jan_2014_14_26_19_+1100_UTFhpGX=tRhfqy=y
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/xtensa/include/asm/barrier.h between commit dbacef090841 ("xtensa:
add SMP support") from the xtensa tree and commit 93ea02bb8435 ("arch:
Clean up asm/barrier.h implementations using asm-generic/barrier.h") from
the tip tree.

I fixed it up (I am pretty sure - see below) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/xtensa/include/asm/barrier.h
index 8e5e5c980a7a,e1ee6b51dfc5..000000000000
--- a/arch/xtensa/include/asm/barrier.h
+++ b/arch/xtensa/include/asm/barrier.h
@@@ -16,16 -13,10 +13,6 @@@
  #define rmb() barrier()
  #define wmb() mb()
 =20
--#ifdef CONFIG_SMP
- #define smp_mb()	mb()
- #define smp_rmb()	rmb()
- #define smp_wmb()	wmb()
- #else
- #define smp_mb()	barrier()
- #define smp_rmb()	barrier()
- #define smp_wmb()	barrier()
 -#error smp_* not defined
--#endif
--
- #define set_mb(var, value)	do { var =3D value; mb(); } while (0)
+ #include <asm-generic/barrier.h>
 =20
  #endif /* _XTENSA_SYSTEM_H */

--Signature=_Mon__13_Jan_2014_14_26_19_+1100_UTFhpGX=tRhfqy=y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS01zfAAoJEMDTa8Ir7ZwVE78P/1f/BlG7POFlFH/bT4XqWHXm
7cJiR3SIaptznW75FfNJ2v84FSlJtR8VuW5hiPD4nup+gXqgivANlQm6KP9ZX0mv
IBtGx7A4YYVAFf4bP1g85Ezz/Bvjd15Ddz9E9FEPKB30GukSzm5y9xNhWBTbbQOK
ByqXkre+yhIelXW6BeVBHOultYaHFGqWHUYRK2KzpfWOgad5EVXyl8h9yw3j2Apk
t7pqIdsKOUBfTDrjo27IyNSO6M9vskarhVZggWqBkk71iU7IL6x7AbLZNtW+3NTp
o1SV3vnC3jgxBYBCDRSRuo7L7wnLQYEt44WWruj7pcFs2KSNPpqUtErG2EqIkdIx
hVIURwGO7e25ustpsa/Q+oI2ZfCYWEMp6BpKm+iPspZ8Z2lmsK4Xi32NtpH1CRsH
ctsir3Z3pXl60JjFhGT5U0Su3n0jp2m1RC2NS5MoZ5/EvVhIRpbMBrRDYhUqQlOS
evdGE1gkFeWW53RJyf+K71FjEc6js3y2pZ20pfek2/NBUmS938ZW3LmlGrqmHpOC
GlqDWeLEr/xszRdpdzv8oR/yKkIFeFDdjEVIrQmsHNIGhMK0S6el7wLniTpDiJO9
xznpWNPvX5KTHQZx5qkOTCyCS4qobu2jfjsSGaF5+rTdRXwXadg/EzKOiC7QbtLF
yJqOC4SNDeoZ7cwAwcMh
=wg0e
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Jan_2014_14_26_19_+1100_UTFhpGX=tRhfqy=y--
