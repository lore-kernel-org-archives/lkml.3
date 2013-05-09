Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab3EIB5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 21:57:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43056 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab3EIB5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 21:57:17 -0400
Date: Thu, 9 May 2013 11:56:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the regmap tree with Linus' tree
Message-Id: <20130509115659.fed19d305e0b180697060f95@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__9_May_2013_11_56_59_+1000_ZeAXPaI2h0brtA7I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_May_2013_11_56_59_+1000_ZeAXPaI2h0brtA7I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

Today's linux-next merge of the regmap tree got a conflict in
drivers/base/regmap/regmap-debugfs.c between commit 480738de0e07
("regmap: debugfs: Simplify calculation of `c->max_reg'") from Linus'
tree and commit 5e3f5901ac6c ("regmap: debugfs: Fix start_reg
calculation") from the regmap tree.

I am not sure that the latter patch is ever required on top of the
former, so for now I just used the former version (except for the last
hunk) (see below) and can carry the fix as necessary (no action is
required).

Please let me know if this is the incorrect resolution.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/base/regmap/regmap-debugfs.c
index 23b701f,6cd1b78a..0000000
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@@ -144,8 -146,7 +144,8 @@@ static unsigned int regmap_debugfs_get_
  			fpos_offset =3D from - c->min;
  			reg_offset =3D fpos_offset / map->debugfs_tot_len;
  			*pos =3D c->min + (reg_offset * map->debugfs_tot_len);
 +			mutex_unlock(&map->cache_lock);
- 			return c->base_reg + reg_offset;
+ 			return c->base_reg + (reg_offset * map->reg_stride);
  		}
 =20
  		*pos =3D c->max;

--Signature=_Thu__9_May_2013_11_56_59_+1000_ZeAXPaI2h0brtA7I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRiwJrAAoJEECxmPOUX5FE9EcP/1FGat4Okrg2Wg+dYmwIOnR+
atKxqFibZr4Cd/8aAoavsTETaVzAt24BfzIf+7pD4daGSyT+Q+sCQVXY+nWySAet
8uNAFWwL0xaDX5RT8s/rFxSapSqX5cqRan4FnCuRe8rYJXYKCoplxv/Ub/BsSdP4
eV03AMmIlY8Rw8jK0lYj7RjJnassNCco/Iidr6G4tn+Yn/ruEi2NmJC+6Ub6jSp9
ot2TB0wpsB1xo9ZWwrIVB4Qi5mkfN68XdxAQvWX4gNMg0emLwiCLLQv4T5mSqupC
kgQmmTHquyT2p6HHWw+0N4ib1+P6+2lOGrbLB7IXDtk6Ch/qDGEW4ovyxUC/fPO5
YRj7teD2+wEcjM9tXIvDXD9HBu+7HfWmKgsjirKM1OAtS/merPhjnIt8Wvgzl1ug
aUJdUvTnXQD/tQn78R9VGAbRu7ALphFbax4UyPfb5lXP8REn6IoTOPOtTPA8eY+L
sRC1AAc5wz1o9ZKgh+x+ulTHvvUnNSasV0Es/r8z0NfziXCZKaVsVHeyJ1Y9zpNT
i3pJfBMr5InkIUA14ZqHFxdV9c5v9rtaz5qX1iEWObHJgRwuky4gNgbj7apnRCDr
K3NVav5DhqxGbKwTMtB7Ej0mmA2oSO6nftoPpHWiuJKR6rSIOM431vQFj+vTXRG4
/O0wGVcsyY92QA5ix0se
=7Vs2
-----END PGP SIGNATURE-----

--Signature=_Thu__9_May_2013_11_56_59_+1000_ZeAXPaI2h0brtA7I--
