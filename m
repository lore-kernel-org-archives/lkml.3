Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217AbaJJB6S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 21:58:18 -0400
Received: from ozlabs.org ([103.22.144.67]:60885 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaJJB6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 21:58:17 -0400
Date: Fri, 10 Oct 2014 12:58:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the mmc-uh tree with Linus' tree
Message-ID: <20141010125809.54245801@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/LUG/Zo6b0g23HVPTy=KDjOm"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/LUG/Zo6b0g23HVPTy=KDjOm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ulf,

Today's linux-next merge of the mmc-uh tree got a conflict in
arch/arm/boot/dts/exynos5420-arndale-octa.dts between commit
aaa25a5a33cb ("ARM: dts: unuse the slot-node and deprecate the
supports-highspeed for dw-mmc in exynos") from Linus' tree and commit
583f958b8a23 ("ARM: dts: fix MMC2 regulators for Exynos5420 Arndale
Octa board") from the mmc-uh tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/exynos5420-arndale-octa.dts
index 75080996ec76,1255d833d576..000000000000
--- a/arch/arm/boot/dts/exynos5420-arndale-octa.dts
+++ b/arch/arm/boot/dts/exynos5420-arndale-octa.dts
@@@ -69,9 -74,13 +69,10 @@@
  		samsung,dw-mshc-ddr-timing =3D <1 2>;
  		pinctrl-names =3D "default";
  		pinctrl-0 =3D <&sd2_clk &sd2_cmd &sd2_cd &sd2_bus4>;
- 		vmmc-supply =3D <&ldo10_reg>;
+ 		vmmc-supply =3D <&ldo19_reg>;
+ 		vqmmc-supply =3D <&ldo13_reg>;
 -
 -		slot@0 {
 -			reg =3D <0>;
 -			bus-width =3D <4>;
 -		};
 +		bus-width =3D <4>;
 +		cap-sd-highspeed;
  	};
 =20
  	hsi2c_4: i2c@12CA0000 {

--Sig_/LUG/Zo6b0g23HVPTy=KDjOm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUNz02AAoJEMDTa8Ir7ZwV6GMP/itMIFHVAev3pt3LwjOiCMwM
Tt0D7TcdgNBB0Ja1BYund/yQ7I6Qe4l/LmWkawqV3CAVoLTEStIwYoY2zEPO8euG
Ck/Izn2CEzlZrV7N/yPaQKP8AlYuL6O5DcXRTtlM91UFJoXQTPu0cJ4QdyRUHyZV
PXd/8gAB2xCfDYBWId71p2h2SMPi1/1RXws/pOxwJrxASmfdAvzNym61AeS9O3A0
SSWOIcolf5eca4vhaIbpHwHAdz+0Z+Q2XLh/EoePGv4paJje2n8iYRqqWoYLa0Eq
mw4b7USNmJe4ECg7XuZFHhm4SZppZpLvD+PJLfzDNOZGf3Mkm+ofkJqbvqNUCZkb
UJKFEw3x+ceJhGKOTafp8erlw8xjqb67oUJHBhqgFvCp8/MhjQA3oRn2zrmLVKJ3
MwmCIsII9sEIIaIsysZ5N80WnvaOQ5Kx9rAtCm+FOSAzOZzwAYqfZSJ7+ZW/4Vjv
Sc47x0ASndA1K1M722VaAJ7mEhuIzjSF+F/8SzyuglZrHl0SDuRxcZYZq1CdHrk0
yZVicdusOFjMlAWzBaIQkbC8tVKF4xk5P/odwHoex21HLMBZjYCDZsohdg6utLTW
N/eKsUu/JQE3x4FT1ZUha0eA0U7CfRqTFtF25RkWItd/U8tScY7w1PKYLRGNG1km
BMpdxe8IyRKsSl54blMm
=OddG
-----END PGP SIGNATURE-----

--Sig_/LUG/Zo6b0g23HVPTy=KDjOm--
