Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3J1LUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:20:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42556 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab3J1LUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:20:23 -0400
Date: Mon, 28 Oct 2013 22:20:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Chris Ball <cjb@laptop.org>
Subject: linux-next: manual merge of the driver-core tree with the mmc tree
Message-Id: <20131028222007.30619a9f7d18f5acd9b1ae60@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.21; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Oct_2013_22_20_07_+1100_0MRmy.RDzThOFZz0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Oct_2013_22_20_07_+1100_0MRmy.RDzThOFZz0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/mmc/host/mvsdio.c between commit 50596285e0be ("mmc: mvsdio:
Remove redundant suspend and resume callbacks") from the mmc tree and
commit 1867adee6ed7 ("mmc: mvsdio: fix deferred probe from __init") from
the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mmc/host/mvsdio.c
index 22ba4d33e95b,deecee08c288..000000000000
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@@ -845,7 -872,10 +845,8 @@@ static const struct of_device_id mvsdio
  MODULE_DEVICE_TABLE(of, mvsdio_dt_ids);
 =20
  static struct platform_driver mvsd_driver =3D {
- 	.remove		=3D __exit_p(mvsd_remove),
+ 	.probe		=3D mvsd_probe,
+ 	.remove		=3D mvsd_remove,
 -	.suspend	=3D mvsd_suspend,
 -	.resume		=3D mvsd_resume,
  	.driver		=3D {
  		.name	=3D DRIVER_NAME,
  		.of_match_table =3D mvsdio_dt_ids,

--Signature=_Mon__28_Oct_2013_22_20_07_+1100_0MRmy.RDzThOFZz0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSbkhsAAoJEMDTa8Ir7ZwVEKMP/2f7Mz0GCWpalD0R8CAwbT0y
ROms8T3aXpzWAYj5i150KXa93gYphFg2/pDRyEmxPyX9WleS/pCkiBmhamNLyVTd
PoQoaF+6OPY5qKyGoadJvsUJZCA+KLW70HtdnpvK9SBZ3yZTb+JflLys2bMR3Bh7
uTxjY/iDH6mj1jg3xneDgKtzU7kT7c/yyRoG/BuxAmrSXXQVwqcqW0Qt70ObmOUE
pIDYV3PYAWp6dR7DRvQDRboRpupLRst6F1HrIy/jtpR7TahlsC6wGZqZltYtRIL/
Ex6ECBOuqOHulpK8srl9Wyn0xAZewKHis+Si7QA03UJnZqGM5BNEWpr/QlcSIR2q
5Z6iTqssYKT1D9cS7QTr55y++vMEmDqhDPrfQ9cjE7o/OjnsS9jxkWhd5x2yM9yt
JLPv3F6e4ApKYH+NsC1nQ3kG2qV4P0LyfRDO/2MnuCfQo0YN/8O0P2w7gGWvPFiM
0FA3NLDTN6vLwiRmDw78FySjDRZul5dPYKtGzNDnGM7idFEwsRnaCz81rPbNsarV
HHwmAlCdt7QmH3IKkoNTTT2bWEk2mXg3kR922/7uWV8R0VXEMV0S2VYfiobP8h+7
o0emFj6oLnqob6RxUOW5bI5jZk91C5cgObvUjP4C1qTjBO0kUrIXM5syqahIkd49
btAr2D86RpqQkQijte07
=fQ5p
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Oct_2013_22_20_07_+1100_0MRmy.RDzThOFZz0--
