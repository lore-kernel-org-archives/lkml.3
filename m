Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaAPAsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:48:47 -0500
Received: from ozlabs.org ([203.10.76.45]:55479 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaAPAsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:48:45 -0500
Date: Thu, 16 Jan 2014 11:48:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Guinot <simon.guinot@sequanux.org>,
        Jason Cooper <jason@lakedaemon.net>
Subject: linux-next: manual merge of the libata tree with the arm-soc tree
Message-Id: <20140116114831.50261e22b6fb25aac2004b43@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Jan_2014_11_48_31_+1100_Z2tO_HsQO5aZZquV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jan_2014_11_48_31_+1100_Z2tO_HsQO5aZZquV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the libata tree got a conflict in
arch/arm/boot/dts/armada-370-xp.dtsi between commit a095b1c78a35 ("ARM:
mvebu: sort DT nodes by address") from the arm-soc tree and commit
a96cc303e42a ("ARM: mvebu: update the SATA compatible string for Armada
370/XP") from the libata tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/armada-370-xp.dtsi
index b6b253924893,df141a1d6448..000000000000
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@@ -236,12 -183,13 +236,12 @@@
  				status =3D "disabled";
  			};
 =20
 -			i2c0: i2c@11000 {
 -				compatible =3D "marvell,mv64xxx-i2c";
 -				#address-cells =3D <1>;
 -				#size-cells =3D <0>;
 -				interrupts =3D <31>;
 -				timeout-ms =3D <1000>;
 -				clocks =3D <&coreclk 0>;
 +			sata@a0000 {
- 				compatible =3D "marvell,orion-sata";
++				compatible =3D "marvell,armada-370-sata";
 +				reg =3D <0xa0000 0x5000>;
 +				interrupts =3D <55>;
 +				clocks =3D <&gateclk 15>, <&gateclk 30>;
 +				clock-names =3D "0", "1";
  				status =3D "disabled";
  			};
 =20

--Signature=_Thu__16_Jan_2014_11_48_31_+1100_Z2tO_HsQO5aZZquV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS1yxjAAoJEMDTa8Ir7ZwVHkAP/1PmRayrcJrVICTx2Ue7Uq+S
t5SI4k6tgPpm/U1dBeV4EpZnYw7CI7vSmOVZWBa0mggrL4wtIB96N2smVMDFyxPL
XSsJPQjsrFCzUMgrEbEC7Iw1Dl+EuyrYlQFaUBHzN1z+7ixEERX7NxJkEcQYcMCC
873SpMo4XPevgif9c/PUldeQJiEs17e0AmduwXaMbXmfYg+Iag0rl+rtrPGiLdKz
nSm4kcNMLRLWYJLtQklxOMuTyEi5BbgtWKl/OglkzQ8Uhi3wrf039IfBX0IYVCqd
2kxvwUs86T0HOXnBEMP5pCL3yWC2VWXkOsT7pXIC0QBNcW1TD2MpnNj/ulc5BnH4
thFpc5TfAmQIQfoZ0nz2MoLPosEso0yrt19Ljo+OGhe41f/0C90zgMbmDA0xlpa3
K7DG7S5az98H8QphRYl4InQIedZbpsyHfoDBy8wa0tyqCNpnZEKa4MlZ6GsB817M
lwJfyuPZQHXGOkB3UgFe11hkyl9siB0iQcFboVo0zbDyYPboi+cgV+DQMWGkwfnf
iQzmOw2gffapf3b+mJnZHh/Gnu4OEsh4olqjWLk3MSByBC3XLbPMF25BrZELSOEV
0/WFKoReI+ZHMHLDiydFkrRZUkimqEcCL29xyZq325p1QvZp+qJcnzQ52xET8/Eq
6iSlE4DqANIkHxfgCOk4
=GA+/
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jan_2014_11_48_31_+1100_Z2tO_HsQO5aZZquV--
