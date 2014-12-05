Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbaLEDDX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 22:03:23 -0500
Received: from ozlabs.org ([103.22.144.67]:36098 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378AbaLEDDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 22:03:21 -0500
Date: Fri, 5 Dec 2014 14:03:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Beniamino Galvani <b.galvani@gmail.com>,
        Carlo Caione <carlo@caione.org>
Subject: linux-next: manual merge of the v4l-dvb tree with the arm-soc tree
Message-ID: <20141205140313.7d0242a6@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/BH4CUXy06kYO02piip6pns."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BH4CUXy06kYO02piip6pns.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
arch/arm/boot/dts/meson.dtsi between commit 8fba96fac1c4 ("ARM: dts:
meson: add I2C controller nodes") from the arm-soc tree and commit
ac61e3787315 ("[media] ARM: dts: meson: add IR receiver node") from the
v4l-dvb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/meson.dtsi
index 03bcff87bd27,6a37f15e8627..000000000000
--- a/arch/arm/boot/dts/meson.dtsi
+++ b/arch/arm/boot/dts/meson.dtsi
@@@ -114,34 -107,11 +114,41 @@@
  			status =3D "disabled";
  		};
 =20
 +		i2c_AO: i2c@c8100500 {
 +			compatible =3D "amlogic,meson6-i2c";
 +			reg =3D <0xc8100500 0x20>;
 +			interrupts =3D <0 92 1>;
 +			clocks =3D <&clk81>;
 +			#address-cells =3D <1>;
 +			#size-cells =3D <0>;
 +			status =3D "disabled";
 +		};
 +
 +		i2c_A: i2c@c1108500 {
 +			compatible =3D "amlogic,meson6-i2c";
 +			reg =3D <0xc1108500 0x20>;
 +			interrupts =3D <0 21 1>;
 +			clocks =3D <&clk81>;
 +			#address-cells =3D <1>;
 +			#size-cells =3D <0>;
 +			status =3D "disabled";
 +		};
 +
 +		i2c_B: i2c@c11087c0 {
 +			compatible =3D "amlogic,meson6-i2c";
 +			reg =3D <0xc11087c0 0x20>;
 +			interrupts =3D <0 128 1>;
 +			clocks =3D <&clk81>;
 +			#address-cells =3D <1>;
 +			#size-cells =3D <0>;
 +			status =3D "disabled";
 +		};
++
+ 		ir_receiver: ir-receiver@c8100480 {
+ 			compatible=3D "amlogic,meson6-ir";
+ 			reg =3D <0xc8100480 0x20>;
+ 			interrupts =3D <0 15 1>;
+ 			status =3D "disabled";
+ 		};
  	};
  }; /* end of / */

--Sig_/BH4CUXy06kYO02piip6pns.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUgSB4AAoJEMDTa8Ir7ZwVz0QP/3MvjSCvf3fYozghbCfmfHaH
c1pu0ucD9NWSxrV0EPZciBH7MRjphJ8Yjx3gYdKPFSxJunHUmUofmIq/mAl7L3ul
BmHXb+U8kNMwOL8dRs60nQMn8voQXQbFT3Kl9ueHBQ9gDitOdrnin/MxaHfs/pNA
yZiQYiwxsqP4qu79/ffeJIYzVpIaZWumHUKCcmhWYb2tZpF9hFBd4ocM0iCxsfus
K0SUCvWo/QVnACUJEx4rHq1KpOD59xYqDgD+hNR5kiLmatxfIgZbaNaiqFPzdc2l
4AOnnINa5ewqw5n70smEMuHmymz9my9y5qxcr3dp9egTMhhIt5ZlBSugRdmHTdyb
YsmghH/pMOuBu6a2F/qnpaAGX+lyZxo93kifUrHjL/Z+EatcNjY7tqNokrVuwHWH
8YI6eEuamq4dQa4Ac/qYKy2yVrg4lUz/h3NSVCv3lp8b7ljKryHriEE/ZwhDLwyv
MgOtIutbgOKXUFKkDXggPkXk5oPTaolr0rP1W+ZqAMbMtAFNyOukALpggt4fgKPa
/Gf7A9gnTSZSOC+EtQktIntpSO3Q3y09NYUWMunijJ+fPjkd252pCyjqGBdYaGxh
VNuFsnwdLlCsHc+kX+5LFax6L8vTt0zbT8hxvCLNJFkfxu7OdcIXg9ffeS3aK+7e
bh/20AkpEq9CoPUdRdUj
=+29W
-----END PGP SIGNATURE-----

--Sig_/BH4CUXy06kYO02piip6pns.--
