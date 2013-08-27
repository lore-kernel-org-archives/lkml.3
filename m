Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab3H0I3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:29:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51588 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753314Ab3H0I3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:29:37 -0400
Date: Tue, 27 Aug 2013 18:29:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20130827182935.ff4005b60cc1ce80d32d5e46@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_18_29_35_+1000_myFMxkUhaRHXyFwO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_18_29_35_+1000_myFMxkUhaRHXyFwO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/tegra20-trimslice.dts between commit 30ca2226bea6
("ARM: tegra: always enable USB VBUS regulators") from Linus' tree and
commit 23f95ef2d951 ("ARM: tegra: use TEGRA_GPIO() in a couple more
places") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/tegra20-trimslice.dts
index 1e9d33a,22e227f..0000000
--- a/arch/arm/boot/dts/tegra20-trimslice.dts
+++ b/arch/arm/boot/dts/tegra20-trimslice.dts
@@@ -310,8 -310,19 +310,18 @@@
  		nvidia,sys-clock-req-active-high;
  	};
 =20
+ 	pcie-controller {
+ 		status =3D "okay";
+ 		pex-clk-supply =3D <&pci_clk_reg>;
+ 		vdd-supply =3D <&pci_vdd_reg>;
+=20
+ 		pci@1,0 {
+ 			status =3D "okay";
+ 		};
+ 	};
+=20
  	usb@c5000000 {
  		status =3D "okay";
 -		nvidia,vbus-gpio =3D <&gpio TEGRA_GPIO(V, 2) GPIO_ACTIVE_HIGH>;
  	};
 =20
  	usb-phy@c5000000 {
@@@ -410,10 -421,26 +420,28 @@@
  			regulator-min-microvolt =3D <5000000>;
  			regulator-max-microvolt =3D <5000000>;
  			enable-active-high;
- 			gpio =3D <&gpio 170 0>; /* PV2 */
+ 			gpio =3D <&gpio TEGRA_GPIO(V, 2) 0>;
 +			regulator-always-on;
 +			regulator-boot-on;
  		};
+=20
+ 		pci_clk_reg: regulator@3 {
+ 			compatible =3D "regulator-fixed";
+ 			reg =3D <3>;
+ 			regulator-name =3D "pci_clk";
+ 			regulator-min-microvolt =3D <3300000>;
+ 			regulator-max-microvolt =3D <3300000>;
+ 			regulator-always-on;
+ 		};
+=20
+ 		pci_vdd_reg: regulator@4 {
+ 			compatible =3D "regulator-fixed";
+ 			reg =3D <4>;
+ 			regulator-name =3D "pci_vdd";
+ 			regulator-min-microvolt =3D <1050000>;
+ 			regulator-max-microvolt =3D <1050000>;
+ 			regulator-always-on;
+ 		};
  	};
 =20
  	sound {

--Signature=_Tue__27_Aug_2013_18_29_35_+1000_myFMxkUhaRHXyFwO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHGNvAAoJEECxmPOUX5FEAWUP/3I/dv3b0g8Fs7vBUwEZ7D3Q
cQFsoVBCaXnypswBHCWQaO4sGiWpxOl/4Qc6til6X0k/F3vW+2JWTvUgPCP2FHQY
vniE8gGec3+3BvtUbeO4uQGeYxV0mWJCjaRIAYftE0ZNGlS9grkRew/xlSQR/zQf
pBNjWU8Zuqc/8ltKl5dK0zRw4A7A2ErsV9YggcBj/69G4AnP+dtgwlJY7u7HsZvR
h85jA9sqSd3qwO6dofRnftAzgFvylnjnFft6oV6d1W917epTM4YKBcGNPF30ugUK
ARQvN5mRu3h0S5z1VJ/zDPGpqqakI9q1RxRh3VxhC/gKINdKDhHPk4/ncCxSSRrq
oZNuAI2Bq+TSA+GxE4lj37f2nY1p6m/UhSYCTXlz/rqe0ZclQIE83cESh89+dqmW
7H56x+K+brzDdt5clLmCpUZq7YP6I3rkv1wvbZ0z6Mcs/BJjvacub/GwBttz7uW7
SZdYPrG7rrxOzGANBozrvT4g8l7ixX9i0JTXupF3JchBoL7vWoeIJC5iF+wRiXEk
ytdVHv9eCrpNSbGKnodtDtpRg7g24ahj/WU3JfNEwFR7jLBvhLjF9x2eRFb4zR1n
P7rrAvJqCFhW23Vbm3O/EkNaWW11cp+moi6Muw6WmV+MutrlkQDbaFY1q04a3aF/
GXIPG9FAWAHBwn6Desek
=74QI
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_18_29_35_+1000_myFMxkUhaRHXyFwO--
