Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbaKJE2I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 23:28:08 -0500
Received: from ozlabs.org ([103.22.144.67]:51980 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaKJE2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 23:28:06 -0500
Date: Mon, 10 Nov 2014 15:28:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Brian Norris <computersforpeace@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: linux-next: manual merge of the driver-core tree with the l2-mtd
 tree
Message-ID: <20141110152801.221c4f5d@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/g2mI=/xYYtLCISP0Z6vOjsh"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/g2mI=/xYYtLCISP0Z6vOjsh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/mtd/devices/docg3.c between commit a59459f29fb7 ("mtd: docg3:
add device-tree support") from the l2-mtd tree and commit c37c1e160546
("mtd: devices: drop owner assignment from platform_drivers") from the
driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mtd/devices/docg3.c
index 0d9d3ee68b61,72346048532d..000000000000
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@@ -2130,8 -2129,6 +2130,7 @@@ MODULE_DEVICE_TABLE(of, docg3_dt_ids)
  static struct platform_driver g3_driver =3D {
  	.driver		=3D {
  		.name	=3D "docg3",
- 		.owner	=3D THIS_MODULE,
 +		.of_match_table =3D of_match_ptr(docg3_dt_ids),
  	},
  	.suspend	=3D docg3_suspend,
  	.resume		=3D docg3_resume,

--Sig_/g2mI=/xYYtLCISP0Z6vOjsh
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYD7VAAoJEMDTa8Ir7ZwVMx4P/iMCNLJ/24L2EwFel+0Ul6cs
Jhg6aXNrYHGec9AZBzFJzxD48IahDFaU+yE+etOEqZjWyjUh+zXPLvmv+PHtB9sR
0Dpj/r/pBgYo85E5PWpmEZW6anfx9gs8UrmPwkHkSvRqy+XYAWDim3kiAdRArooz
j6EikkXsX1YMpbVLuFRfzh9rGaKmRyroN/Ig9tr5d+MEIlmhsMvSgvwvvaTusCCt
bOjJOcRsCV+0UodNxvto9xun9pY0DtQ/fo5sKoZLXKtO7z0IzXviqKQquC6tf6AX
ZH+91bWVcNWLO6F8CPkxjJm4UryxgprNXoASuPbziaG4msuxm2ahl7Sdao8oQc7q
9+xFR+MMX3b6az16t0HNDjufGpMvR1LO4w5XQrjU99RZChub2lngeBvWSBIhcqmk
SQKO7STR1GLvZFVXPjhwWbsVyPii9T5umctZqzdhQ2gy5ItTuNo5f9dNdbcBaaH3
MLHErcmQNroPYCHzj736IXOhiYPkyHgoLLnsnNm+glmmSSBbihC6ZP5ujGWuWZ/L
jlYjXssIXTtAZbrA2fY+8pvMQ+cUnZccNTl+T+jjBMtblLUnew+VS8o8zWSbroFt
V5YQ1O4pwrFbvmEesVaQ0H18kfjy2iyLMZ6gNdT3pua0W9hCa2PLCt7hyPP7wClm
kE61KZ3HPUWJ15Y64a7u
=rU3z
-----END PGP SIGNATURE-----

--Sig_/g2mI=/xYYtLCISP0Z6vOjsh--
