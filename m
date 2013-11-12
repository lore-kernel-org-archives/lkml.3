Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab3KLB7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:59:01 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44862 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab3KLB6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:58:55 -0500
Date: Tue, 12 Nov 2013 12:58:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Matt Porter <mporter@ti.com>,
        Benoit Cousson <bcousson@baylibre.com>, Joel Fernandes <joelf@ti.com>
Subject: linux-next: manual merge of the input tree with Linus' tree
Message-Id: <20131112125842.0f7b06add01d795cbcdce5bf@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__12_Nov_2013_12_58_42_+1100_cFu+UbzkcCUk.Fny"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Nov_2013_12_58_42_+1100_cFu+UbzkcCUk.Fny
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next merge of the input tree got a conflict in
arch/arm/boot/dts/am335x-evmsk.dts between commit 55b4452b4b70 ("ARM:
dts: AM33XX: Add MMC support and documentation") (and others) from Linus'
tree and commit 2c027b7c48a8 ("arm: dts: am335x sk: add touchscreen
support") from the input tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/am335x-evmsk.dts
index 03febf85fd2f,d7c2c0c58437..000000000000
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@@ -452,36 -420,12 +452,46 @@@
  	phy-mode =3D "rgmii-txid";
  };
 =20
 +&mmc1 {
 +	status =3D "okay";
 +	vmmc-supply =3D <&vmmc_reg>;
 +	bus-width =3D <4>;
 +};
 +
 +&sham {
 +	status =3D "okay";
 +};
 +
 +&aes {
 +	status =3D "okay";
 +};
 +
 +&gpio0 {
 +	ti,no-reset-on-init;
 +};
 +
 +&mcasp1 {
 +		pinctrl-names =3D "default";
 +		pinctrl-0 =3D <&mcasp1_pins>;
 +
 +		status =3D "okay";
 +
 +		op-mode =3D <0>;          /* MCASP_IIS_MODE */
 +		tdm-slots =3D <2>;
 +		/* 4 serializers */
 +		serial-dir =3D <  /* 0: INACTIVE, 1: TX, 2: RX */
 +			0 0 1 2
 +		>;
 +		tx-num-evt =3D <1>;
 +		rx-num-evt =3D <1>;
 +};
++
+ &tscadc {
+ 	status =3D "okay";
+ 	tsc {
+ 		ti,wires =3D <4>;
+ 		ti,x-plate-resistance =3D <200>;
+ 		ti,coordinate-readouts =3D <5>;
+ 		ti,wire-config =3D <0x00 0x11 0x22 0x33>;
+ 	};
+ };

--Signature=_Tue__12_Nov_2013_12_58_42_+1100_cFu+UbzkcCUk.Fny
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSgYtWAAoJEMDTa8Ir7ZwVMhsQAIT2kW1edUpicLsEs2DP8uOO
A33d/IRzrKxTMlXlziPe3UNqmE6M8fE34QejxNdGMHsZgEsJj5Wp0OT7d0ZeUOhM
1h7hOnu93FSVVAgW6S8SBzLqPH3NFschVKSFOLqk/dvW7pKHzkGUuDa2jqpReFx+
VpBjrFeolfw81cbBPRk1wuvWO9ZJVcrtoZvcP7lUQ7lGyr6So4sQVcF+/0c7PRaD
u7TmrdsvMoaRcNEFAWen9CjFRBOIQxecaOkkILpRyeSk6soyzhYhNjtL/6gYXMUz
Ei2kStdNkvCNflMHPRRqZjnc8WQLfc0JaK1/yXm87hAXUAbzK20RkLb4BF7I4UPQ
fOF4tHL0LfOIrEQd+TBE90/GLRGleiJ+VU6TJQfH73M9iaj2Ww8W6/quztiVslpH
oSAkzk1r5yxXMEgbxvYC3GJ1KgQ8mx36mKNzC4wC4LicCoGPiH8SXpr5oYZLpBT4
RbUUCsw9bcVXTHVeY9rbV1RuVIjY9zIMhVVVXJ68iofwba0v0dq+dxUq+CyGP+OW
ZL5czSDvc5mPdLVdfTnXkfBzdrzaa1gxYxrJ84k+o43y8EcNIGBSfNNAkRylyruR
pefa+gzLW8LWnM8h58wqaoFFgW09HZ4+mX+9h0n5ao+5JeCwdoEO9tyJv12d7sUA
0ye8Qi1KzX9SIhvgu3k1
=TK2R
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Nov_2013_12_58_42_+1100_cFu+UbzkcCUk.Fny--
