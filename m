Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393AbaCLB1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:27:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49254 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbaCLB1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:27:12 -0400
Date: Wed, 12 Mar 2014 01:27:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140312012701.c99ebd52abb416cbae3863ad@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2014_01_27_01_+0000_he5rynqJ2dVP3afB"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the staging tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2014_01_27_01_+0000_he5rynqJ2dVP3afB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in arch/arm/boo=
t/dts/imx53-qsb.dts between various commits from the arm-soc tree and commi=
t 17b5001b5143e3b ("imx-drm: convert to componentised device support") from=
 the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc arch/arm/boot/dts/imx53-qsb.dts
index dec4b073ceb1,8b254289344f..000000000000
--- a/arch/arm/boot/dts/imx53-qsb.dts
+++ b/arch/arm/boot/dts/imx53-qsb.dts
diff --git a/arch/arm/boot/dts/imx53-qsb-common.dtsi b/arch/arm/boot/dts/im=
x53-qsb-common.dtsi
index 2dca98b79f48..50823d0f05bf 100644
--- a/arch/arm/boot/dts/imx53-qsb-common.dtsi
+++ b/arch/arm/boot/dts/imx53-qsb-common.dtsi
@@ -17,7 +17,7 @@
                reg =3D <0x70000000 0x40000000>;
        };
=20
-       display@di0 {
+       display0: display@di0 {
                compatible =3D "fsl,imx-parallel-display";
                crtcs =3D <&ipu 0>;
                interface-pix-fmt =3D "rgb565";
@@ -68,6 +68,12 @@
                };
        };
=20
+       imx-drm {
+               compatible =3D "fsl,imx-drm";
+               crtcs =3D <&ipu 0>;
+               connectors =3D <&display0>;
+       };
+
        leds {
                compatible =3D "gpio-leds";
                pinctrl-names =3D "default";

--Signature=_Wed__12_Mar_2014_01_27_01_+0000_he5rynqJ2dVP3afB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH7flAAoJELSic+t+oim9rDYQAIXAv4ib3+/NMWX50rNaPH8J
+CVmii407n55W1FwWrSsqadJkQ5np4J3tW0KJJZgPqq+0SBSgQFgBBZtOIVSTOXh
5fHpVFS2h+7X22+OXwGDOuVajyl+U34mZSFe2QHug87j8Zn2E+uf8+45UFfZjJuC
eh2UhMENSO1WqIS0ak8V1nuDbW0MlX5jWdD9tbHBItXA9LCedCdEtpCcu90f4/Cf
CtU6/s1CMEHwKNJf+RkwqmhdlRoK8ZZ+IDTmuXQqbWRWuXCQMxBp34AuE+E345ug
MH7KfXZiIvlBdCUjE9DSb0cR64R51cIsPOAqKze1p9YAoM4HD+P/tGsBi+iLvQU3
vCmVv7OXTg2CAEx0+Q47AA/db+DtzqLgsj2eD2fpzn+kj+Q8IJE0TfcyiJ1yR0Ru
QGqveDNJHBOUEoLwJMFLooneGnWX/FIvx3erd2cR1sShJt9Szuy8TveVgHHvEHEf
8rN7zyL9hgsN2Wy25KrbXmuK5mTTVuvy8pMDEHwUfS5213LPrFzmXOl/LroWZuPv
RIpcRfArchK4eoCiVwu17TI0T0kVCjbm+4bVCbOVbGdQsjnNJd2vUrcQsBy4AsyN
OD3D80Ribbq8nf5OXuB6vUhej1FHNCcyN2Krja3CvaEwz0mVvUhIVnMwFu8Y6LZN
mBmoFpMNcRiWC8ZjTVO4
=z5yx
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2014_01_27_01_+0000_he5rynqJ2dVP3afB--
