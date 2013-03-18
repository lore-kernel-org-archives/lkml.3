Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366Ab3CRDuE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 23:50:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42705 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3CRDuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 23:50:00 -0400
Date: Mon, 18 Mar 2013 14:49:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20130318144948.1d2c83fb633404d206f3ea0a@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Mar_2013_14_49_48_+1100_jaqnDBA_v_UQf4EC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Mar_2013_14_49_48_+1100_jaqnDBA_v_UQf4EC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/snowball.dts between commit d52701d39e37 ("mfd: ab8500:
Kill "reg" property from binding") from Linus' tree and commit
924e82dacab9 ("ARM: ux500: allow Snowball access to the AB8500 GPIO
pins") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/snowball.dts
index d3ec32f,b095e85..0000000
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@@ -298,7 -298,11 +298,11 @@@
  				};
  			};
 =20
 -			ab8500@5 {
 +			ab8500 {
+ 				ab8500-gpio {
+ 					compatible =3D "stericsson,ab8500-gpio";
+ 				};
+=20
  				ab8500-regulators {
  					ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
  						regulator-name =3D "V-DISPLAY";

--Signature=_Mon__18_Mar_2013_14_49_48_+1100_jaqnDBA_v_UQf4EC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRRo7cAAoJEECxmPOUX5FExucP/A5qhoQikNByyIKczBzCkcWy
4SXU4NSQO5+H12iJ7ggxM0aRMNlLBtmXoCRkejMncJAaumPxGcDK/TQnTCMNgfc3
U1CT190Xnuwr86CnoYVSbJIkl9aqdeodTXuoIvjWm2aSbc5BGqmNoA8la/vbEG2O
cqi+zHISOhV05E4OIcGIr17XfR9P6UuHK6LGRIDYcb2CTjci/uiK+JgtPRxeFynD
WdStr5VFj/kci22zBXgWzHZctvzqCFHz2gDS+Bj6VU+DkAdUqJ+MaMwLEeYSJxdI
J07za0akkdgJiVP4SgmDBMhJNXfsv/Fyh4YK2pj2OuISUqCPHKcmo1kCOs3T1q9Q
NVwxbEh5Qu9eo7DXKoVas7IgtvFc2Lb8aPxKSmSpWGuiZNx7ENY6Hzo+LszjBJms
1GWqUvafa9647nAuc1qgQwEmKlNYHHPGwMnqGURBB5/lYheJLGhEEW7twoayMZKe
HH8KzSmUR4zo1KMPIwZlhKuKFhZNDs1jrWOX436CFebv7hn4/qLYNESfdlU6yEyN
v9yZJyR2QI57GDB3GPJ2+t9A7vMj3qU4qBXhSl6+/3gUsq6e3IBkSRWW5KAZhJe3
O24E4K4jUFXnnIJn+vJWPARsEZS9dpO2Yqcly0dDk9lFCsia02EDGF8asiDXUxnu
wsr2JyPOdNMop8UxIbqB
=fKfH
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Mar_2013_14_49_48_+1100_jaqnDBA_v_UQf4EC--
