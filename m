Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab3DZHHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 03:07:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48952 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab3DZHHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:07:08 -0400
Date: Fri, 26 Apr 2013 17:06:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wenyou Yang <wenyou.yang@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: linux-next: manual merge of the arm-soc tree with the spi-mb tree
Message-Id: <20130426170649.d21c2d7a74e56d836ff6f04f@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Apr_2013_17_06_49_+1000_.gWkdUh4WvAJACri"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Apr_2013_17_06_49_+1000_.gWkdUh4WvAJACri
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/at91sam9x5.dtsi between commits d50f88a0c304 ("ARM:
dts: add spi nodes for atmel SoC") and a68b728f7a21 ("ARM: dts: add
pinctrl property for spi node for atmel SoC") from the spi-mb tree and
commits e9a72ee81d58 ("ARM: at91: dt: at91sam9x5: add i2c pinctrl"),
463c9c7bf1f3 ("ARM: at91: dt: at91sam9x5: add i2c-gpio pinctrl") and
b909c6c94462 ("ARM: at91/at91sam9x5: add RTC node") from the arm-soc tree.

I fixed it up (hopefully - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/at91sam9x5.dtsi
index 347b438,284bf24..0000000
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@@ -343,23 -343,53 +343,70 @@@
  					};
  				};
 =20
 +				spi0 {
 +					pinctrl_spi0: spi0-0 {
 +						atmel,pins =3D
 +							<0 11 0x1 0x0	/* PA11 periph A SPI0_MISO pin */
 +							 0 12 0x1 0x0	/* PA12 periph A SPI0_MOSI pin */
 +							 0 13 0x1 0x0>;	/* PA13 periph A SPI0_SPCK pin */
 +					};
 +				};
 +
 +				spi1 {
 +					pinctrl_spi1: spi1-0 {
 +						atmel,pins =3D
 +							<0 21 0x2 0x0	/* PA21 periph B SPI1_MISO pin */
 +							 0 22 0x2 0x0	/* PA22 periph B SPI1_MOSI pin */
 +							 0 23 0x2 0x0>;	/* PA23 periph B SPI1_SPCK pin */
 +					};
 +				};
+ 				i2c0 {
+ 					pinctrl_i2c0: i2c0-0 {
+ 						atmel,pins =3D
+ 							<0 30 0x1 0x0	/* PA30 periph A I2C0 data */
+ 							 0 31 0x1 0x0>;	/* PA31 periph A I2C0 clock */
+ 					};
+ 				};
+=20
+ 				i2c1 {
+ 					pinctrl_i2c1: i2c1-0 {
+ 						atmel,pins =3D
+ 							<2 0 0x3 0x0	/* PC0 periph C I2C1 data */
+ 							 2 1 0x3 0x0>;	/* PC1 periph C I2C1 clock */
+ 					};
+ 				};
+=20
+ 				i2c2 {
+ 					pinctrl_i2c2: i2c2-0 {
+ 						atmel,pins =3D
+ 							<1 4 0x2 0x0	/* PB4 periph B I2C2 data */
+ 							 1 5 0x2 0x0>;	/* PB5 periph B I2C2 clock */
+ 					};
+ 				};
+=20
+ 				i2c_gpio0 {
+ 					pinctrl_i2c_gpio0: i2c_gpio0-0 {
+ 						atmel,pins =3D
+ 							<0 30 0x0 0x2	/* PA30 gpio multidrive I2C0 data */
+ 							 0 31 0x0 0x2>;	/* PA31 gpio multidrive I2C0 clock */
+ 					};
+ 				};
+=20
+ 				i2c_gpio1 {
+ 					pinctrl_i2c_gpio1: i2c_gpio1-0 {
+ 						atmel,pins =3D
+ 							<2 0 0x0 0x2	/* PC0 gpio multidrive I2C1 data */
+ 							 2 1 0x0 0x2>;	/* PC1 gpio multidrive I2C1 clock */
+ 					};
+ 				};
+=20
+ 				i2c_gpio2 {
+ 					pinctrl_i2c_gpio2: i2c_gpio2-0 {
+ 						atmel,pins =3D
+ 							<1 4 0x0 0x2	/* PB4 gpio multidrive I2C2 data */
+ 							 1 5 0x0 0x2>;	/* PB5 gpio multidrive I2C2 clock */
+ 					};
+ 				};
 =20
  				pioA: gpio@fffff400 {
  					compatible =3D "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
@@@ -548,27 -587,12 +604,33 @@@
  				};
  			};
 =20
 +			spi0: spi@f0000000 {
 +				#address-cells =3D <1>;
 +				#size-cells =3D <0>;
 +				compatible =3D "atmel,at91rm9200-spi";
 +				reg =3D <0xf0000000 0x100>;
 +				interrupts =3D <13 4 3>;
 +				pinctrl-names =3D "default";
 +				pinctrl-0 =3D <&pinctrl_spi0>;
 +				status =3D "disabled";
 +			};
 +
 +			spi1: spi@f0004000 {
 +				#address-cells =3D <1>;
 +				#size-cells =3D <0>;
 +				compatible =3D "atmel,at91rm9200-spi";
 +				reg =3D <0xf0004000 0x100>;
 +				interrupts =3D <14 4 3>;
 +				pinctrl-names =3D "default";
 +				pinctrl-0 =3D <&pinctrl_spi1>;
 +				status =3D "disabled";
 +			};
+ 			rtc@fffffeb0 {
+ 				compatible =3D "atmel,at91rm9200-rtc";
+ 				reg =3D <0xfffffeb0 0x40>;
+ 				interrupts =3D <1 4 7>;
+ 				status =3D "disabled";
+ 			};
  		};
 =20
  		nand0: nand@40000000 {

--Signature=_Fri__26_Apr_2013_17_06_49_+1000_.gWkdUh4WvAJACri
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJReieJAAoJEECxmPOUX5FEW3QP/2pDNQojoRhiyavVkbr/FLyM
00IEsn2ehrvqf/0pZxJiLIVWnumCRezJ6yIjHBANX69n4GYDJ/90TA3WkU2UzFcC
WpWS3/IwPOQ94VS4YscshHfm0R8G9bu5Lhj80F9T42eTP+lSczUutCnIvLdKT4qB
a34AbgYFnGcVzUP0oKSqRrv/2km0rapOCRZzSCsFf23/yBy+YozOmkMHm1OrTJG8
hzK9YIfoLyU9wECIDSzplqGtc4qhdptOCQaW4HPinspybduNxtPN4OaaUIpBFSRj
0Nt7Vc0TCzKvMBdeKnLbdyUi1iMzpRo7Jh7Z/jcPt2ZoMNria1UPbt5toG7OfM/R
ZHl+iRLw87E+1aGzBmLWjU8uPu1BjzyqNA9RdDntGtD7kkBuymx8nAbz+wol1lbq
WNTieWG522opM+nPYpqtAKzKqta1423aUNOWmNzDkVNyC++sP7R91eF0USDiE2/L
vWVLAOzADgg6iN1p2WbYeRxyYsI5HH02eh8zSS5ns+R2/75uc9zP3Rn1FBW1Ks4G
5RrJOktexg00egok03GUqsYvE2+A6M5q/eda45K6fohdKCbQfVJkR84x4iz5QWYJ
IsBNT5N+Z5t02AIbLKW2/xDoSxbotXQal0fUmiL+Cprs73lbhwrgN//D/E5hNafQ
pmsJ9gq5o4TRecy5psLw
=sFcP
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Apr_2013_17_06_49_+1000_.gWkdUh4WvAJACri--
