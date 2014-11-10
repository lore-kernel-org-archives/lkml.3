Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaKJGed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:34:33 -0500
Received: from ozlabs.org ([103.22.144.67]:48279 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaKJGeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:34:31 -0500
Date: Mon, 10 Nov 2014 17:34:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the pinctrl tree with the arm-soc tree
Message-ID: <20141110173425.6962fc1c@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_//jn8PmuRO.tf9w5QFc5OzRt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//jn8PmuRO.tf9w5QFc5OzRt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
arch/arm/boot/dts/ste-nomadik-stn8815.dtsi between commit 2096eb80e446
("ARM: nomadik: move GPIO I2C to S8815 board file") and 43c4034963d6
("ARM: nomadik: set up MCDATDIR2") from the arm-soc tree and commits
68d41f23ce8d ("pinctrl: nomadik: force-convert to generic mux
bindings") and 1637d480f873 ("pinctrl: nomadik: force-convert to
generic config bindings") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

I also added this merge fix patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 10 Nov 2014 17:30:59 +1100
Subject: [PATCH] pinctrl: nomadik: fix up for binding changes

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/boot/dts/ste-nomadik-s8815.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/ste-nomadik-s8815.dts b/arch/arm/boot/dts/st=
e-nomadik-s8815.dts
index 7a7e2443503f..85d3b95dfdba 100644
--- a/arch/arm/boot/dts/ste-nomadik-s8815.dts
+++ b/arch/arm/boot/dts/ste-nomadik-s8815.dts
@@ -43,7 +43,7 @@
 		gpioi2c {
 			gpioi2c_default_mode: gpioi2c_default {
 				gpioi2c_default_cfg {
-					ste,pins =3D "GPIO73_C21", "GPIO74_C20";
+					pins =3D "GPIO73_C21", "GPIO74_C20";
 					ste,input =3D <0>;
 				};
 			};
--=20
2.1.3

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
index f435ff20aefe,c8b4a93180f8..000000000000
--- a/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
+++ b/arch/arm/boot/dts/ste-nomadik-stn8815.dtsi
@@@ -116,8 -116,8 +116,8 @@@
  		mmcsd {
  			mmcsd_default_mux: mmcsd_mux {
  				mmcsd_default_mux {
- 					ste,function =3D "mmcsd";
- 					ste,pins =3D "mmcsd_a_1", "mmcsd_b_1";
+ 					function =3D "mmcsd";
 -					groups =3D "mmcsd_a_1";
++					groups =3D "mmcsd_a_1", "mmcsd_b_1";
  				};
  			};
  			mmcsd_default_mode: mmcsd_default {
@@@ -127,9 -127,9 +127,9 @@@
  					ste,output =3D <0>;
  				};
  				mmcsd_default_cfg2 {
 -					/* MCCMDDIR, MCDAT0DIR, MCDAT31DIR */
 +					/* MCCMDDIR, MCDAT0DIR, MCDAT31DIR, MCDATDIR2 */
- 					ste,pins =3D "GPIO10_C11", "GPIO15_A12",
+ 					pins =3D "GPIO10_C11", "GPIO15_A12",
 -					"GPIO16_C13";
 +					"GPIO16_C13", "GPIO23_D15";
  					ste,output =3D <1>;
  				};
  				mmcsd_default_cfg3 {

--Sig_//jn8PmuRO.tf9w5QFc5OzRt
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYFx1AAoJEMDTa8Ir7ZwV0TIQAIzyAwa8Gyyduj9wIAbzwyyT
b/C4aZwoamkxFaEsZdqOyfvDeIxHo8RmUEokl0xZc52DwecidlHwEahn7FV6o9BN
vWO9gDMJjP3alZuGssLTBfdF/bMxBqd+Cr0lmxKdPP1Q+MCU8ODo2LlvfkY5iyTJ
NF/I27L4qNNueWwCTL9k/z2unChxLxZUFxLNj3kzEPTqv4cm0YDZj8gLzGtAc0AY
1OGZPsGIdhjk36+KF51H2kfUHn3KO9RXEXul+myViluJ9dcioDBOEn5WXazuqZgv
lI6CfUWAdGhJxrOWBIYUDTvWrUAk2+s/BG4j7JyiWPjDD7Rk+5bNXDhrqlmyRuHj
uwCurnB0vioUi1VPOW++RazwiunFCQToQAN4lJpsxXAaCuk3myp0KdQgV+Rd3CLa
8VZF0OD5fc4/hr7e9J+lOoRFwtfuoZ5teEcN2Dcn79I8xVAur0T/RI5LYhbkbP7w
hdd9U3v66K9RWCcvDF01ZW4s+q852sCOlmSgRp/YMaOwz3yvQDHbX/Lwh85Rh03z
kynh1MLwbMLMDig1Vsm9IVhf/FnWvmNFMw6NWei13yJONLzMN5dhc5gs58lCSGP2
DfIVdPM62DwbDINgxh+eOhTKwHJXLpvpqvIeQv6gXbdXPBdYj8Y0a7Ai6l2w+0Q/
rK+vKfM2psABdhWVwlJA
=V+TI
-----END PGP SIGNATURE-----

--Sig_//jn8PmuRO.tf9w5QFc5OzRt--
