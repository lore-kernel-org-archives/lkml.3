Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbaFCAuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:50:52 -0400
Received: from ozlabs.org ([103.22.144.67]:33569 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932400AbaFCAuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:50:51 -0400
Date: Tue, 3 Jun 2014 10:50:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>
Subject: linux-next: manual merge of the mips tree with Linus' tree
Message-ID: <20140603105040.4fa16742@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/uBgmu1iJ9bAfYhFq_s.F1pU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/uBgmu1iJ9bAfYhFq_s.F1pU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

Today's linux-next merge of the mips tree got a conflict in
arch/mips/mti-malta/malta-memory.c between commit 2ff89d64f23e ("MIPS:
malta: memory.c: Initialize the 'memsize' variable") from Linus' tree
and commit acd8bc1a70ff ("MIPS: malta: Remove 'maybe_unused' attribute
from ememsize{, _str}") from the mips tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/mips/mti-malta/malta-memory.c
index f2364e419682,1ca34887d990..000000000000
--- a/arch/mips/mti-malta/malta-memory.c
+++ b/arch/mips/mti-malta/malta-memory.c
@@@ -26,8 -26,8 +26,8 @@@ unsigned long physical_memsize =3D 0L
 =20
  fw_memblock_t * __init fw_getmdesc(int eva)
  {
- 	char *memsize_str, *ememsize_str __maybe_unused =3D NULL, *ptr;
- 	unsigned long memsize =3D 0, ememsize __maybe_unused =3D 0;
+ 	char *memsize_str, *ememsize_str =3D NULL, *ptr;
 -	unsigned long memsize, ememsize =3D 0;
++	unsigned long memsize =3D 0, ememsize =3D 0;
  	static char cmdline[COMMAND_LINE_SIZE] __initdata;
  	int tmp;
 =20

--Sig_/uBgmu1iJ9bAfYhFq_s.F1pU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTjRvoAAoJEMDTa8Ir7ZwVGlcP/0inDanZDzlhhH8GUKNAZKab
HTGtn86BUpcfO/NPeBikWwMjJLV1I/dYpvQ5ul3rwsm2wC1/fTz+CdheiYFUYPMv
VRhfDlb913hnzP42Rsd1+1Px0bDRrYZKvhWcN10v9K8hd+1y2hbVsg31GdNfAgJU
vC34z7G2n5S2i9amgd6ibx+OazK1tB3eMhD1MD0C2ccX/c2AEwJvFNyZ/P406A5J
s72NWV2LhMwfKejxf0yD5BlftgI7V5OwfMrP7WXMhicMME2niGkdbQPAbYFDSJYz
E51QQu4Y+83xv6jyo0y8nZwmXaHUZhy3autZnO1jqnMtt4hxSvxT/ClYtYSKBJXB
3tLY1575u1w6ZxmOpp6DtQoJd+J+W/r+bkLAC1iS5xLz5rKPaX3C75ckOvYPoWV8
4tKdrmuW/THIZoLDMnK+znMjpUSO3pAG6fGBCbTBFUhqhyHB+PbD01Y1a2Gur5Br
HOId6Ef4Q8tvCtsKhn2MUmMK8grXRs+hkrn8UmPxo6DStHlSsumCy0x1OK5z7qde
2wEHOJHz06jkPj3utcct0+7iY2m3M7VNATWr7C6WEN7WC6fCC7OCYT7Inn5/U7bq
Tyjf3dpwKC2kFXy3VaELgWh7VooQarPt3W2BN+8XbMGiSWEarFkKFRLXOKZjqIVT
tKQr8AjjCOufpmTOjsIk
=xUvy
-----END PGP SIGNATURE-----

--Sig_/uBgmu1iJ9bAfYhFq_s.F1pU--
