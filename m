Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbaDNWc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:32:28 -0400
Received: from mout.gmx.net ([212.227.17.20]:54446 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbaDNWc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:32:27 -0400
Date: Tue, 15 Apr 2014 00:32:05 +0200
From: Christian Engelmayer <cengelma@gmx.at>
To: Brian Norris <computersforpeace@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Pekon Gupta <pekon@ti.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd: nand: omap: fix compile warning on =?UTF-8?B?4oCY?=
 =?UTF-8?B?ZXJhc2VkX3NlY3Rvcl9iaXRmbGlwc+KAmQ==?=
Message-ID: <20140415003205.0bb2cf44@spike>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YwI7xoFi+9LkH9H.x7TJ02J"; protocol="application/pgp-signature"
X-Provags-ID: V03:K0:qWMzmQysVVI4XGvcU0oGNtXB9mAG6kX/bZOUnKOBBjNK39Xw9uA
 ohF12Eq1B6G5MbtftwhCswHvthPIYqEJ45Swa8UEVnTeArJuE2EaHFcPg2iV08pcBASHW1x
 1Pl2i0bKU6X/K5s2tr5V+JRpuzavQpYWV7Er2fL9G2Rp3GBclFWsk732WtDF2jMUmpdZNCP
 WkBpeB0B0Z15laId+G7Hg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YwI7xoFi+9LkH9H.x7TJ02J
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Commit 2c9f2365 (mtd: nand: omap: ecc.calculate: merge omap3_calculate_ecc_=
bch4
in omap_calculate_ecc_bch) introduced minor compile warning
"=E2=80=98erased_sector_bitflips=E2=80=99 defined but not used [-Wunused-fu=
nction]" when
compiling without CONFIG_MTD_NAND_OMAP_BCH. Move function
erased_sector_bitflips() into the same ifdef section as the only caller.

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 drivers/mtd/nand/omap2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/omap2.c b/drivers/mtd/nand/omap2.c
index 1ff49b8..1b800bc 100644
--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -1237,6 +1237,7 @@ static int __maybe_unused omap_calculate_ecc_bch(stru=
ct mtd_info *mtd,
 	return 0;
 }
=20
+#ifdef CONFIG_MTD_NAND_OMAP_BCH
 /**
  * erased_sector_bitflips - count bit flips
  * @data:	data sector buffer
@@ -1276,7 +1277,6 @@ static int erased_sector_bitflips(u_char *data, u_cha=
r *oob,
 	return flip_bits;
 }
=20
-#ifdef CONFIG_MTD_NAND_OMAP_BCH
 /**
  * omap_elm_correct_data - corrects page data area in case error reported
  * @mtd:	MTD device structure
--=20
1.8.3.2

--Sig_/YwI7xoFi+9LkH9H.x7TJ02J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTTGHlAAoJEKssnEpaPQKEk7sP/i1eh6vmkiWAYSv5ZZkwX6vx
SbIJK+X6Y0nWgNskPRMh+tRGxogKL5QPELXgZZUYpMSMLLqwu1FLLOeZk6p2hGRB
BYIvOSg52deiiF2+cLgrUcPysOas78qzBGt3LvJGcnj/r1N0eXIFOM9FPdaxD7W3
1S7YSh6CeJi1LWi81xzeo6vylj6j4OOfylroy7HsF71EYdxw00wh0bJcoMi7uX4G
4bXB9H3jZxnKQVcCT9b2wByxpji2qgF70h8Td6DBplVRB+PyWMKegh+TVACDRRLh
7L1U3cbU5o4gDito47e3rycRDZDhHtet1HuhDSyFcebZhseYWw+P2VZ8IBpc6264
W7fbn4a/Td94zIyBAMDUlcMdn1uIm2/jD6BKL6C7fu9rqsuwZQFN3yujTkYBgWJ6
FmPMHmihVSk74ptACY19igI+lZKSRzrqoX9xXSymRf+N6xEwO9UnemgSIUrTnt9F
rw2jp5qLjxAncMHfSEgznmk+yb27vZlzhaeVFQ3mm3s+0v7zXDNnV/AhFGm9LVPJ
OU5NFJ7OySaxyCfYJ+wGbbb8sjmSIQHnKI4GWv727oHX+gpb2tJYuGHjdXjOD1jB
R2vzqK4wDPYyRRyincBLKD1MiWh3Sx1xV0apUCwnuQu8NE7AFX4uHS2SlUvF3zJA
Aq30Fvpdr3Kt1G+gnFJF
=QSrD
-----END PGP SIGNATURE-----

--Sig_/YwI7xoFi+9LkH9H.x7TJ02J--
