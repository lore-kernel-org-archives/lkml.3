Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab3H0IYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:24:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58353 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab3H0IYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:24:17 -0400
Date: Tue, 27 Aug 2013 18:24:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Kishon Vijay Abraham I <kishon@ti.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20130827182414.33ff08dc24b6762dec907f82@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_18_24_14_+1000__kkvTL4MoAks0Fe4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_18_24_14_+1000__kkvTL4MoAks0Fe4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/omap5.dtsi between commit 22a5aa170c52 ("usb: dwc3:
core: switch to snps,dwc3") from the usb tree and commit ec0a71838da2
("ARM: OMAP5: dts: fix reg property size") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/omap5.dtsi
index 07be2cd,4fc0912..0000000
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@@ -644,8 -644,8 +644,8 @@@
  			utmi-mode =3D <2>;
  			ranges;
  			dwc3@4a030000 {
 -				compatible =3D "synopsys,dwc3";
 +				compatible =3D "snps,dwc3";
- 				reg =3D <0x4a030000 0x1000>;
+ 				reg =3D <0x4a030000 0x10000>;
  				interrupts =3D <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
  				usb-phy =3D <&usb2_phy>, <&usb3_phy>;
  				tx-fifo-resize;

--Signature=_Tue__27_Aug_2013_18_24_14_+1000__kkvTL4MoAks0Fe4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHGIuAAoJEECxmPOUX5FEL5MQAJwph0/0RVcZxhU8HRDgX49y
f0ayiHfU+fWPhyrC95YpzeQCngsqgndprQGYWFSmfkIP6rWVL3NBDuJt2WzZZgKf
CJ9sLuxupJQ6CWjtceptAGtxwJg8Foxtr7Dn1PMv4Is/Ljv+E/xqHevv7T1Igi7+
4SqA7WdCC2tvsK8lvtsrQVdSrtAU43DU0lITFTKZyZFj3G3oh66GpXpoqX7/QJ7K
AL01HSAnRpY8Hs+bLXBy+EhIHlBD2Cl12QeJNoVLy9WT0TVumQp6AduzYltkq0Tk
UKkJ1lGoK0KDcsnUzquUwSPUvFuz5LShC+Ntsd+PBIT84Lxk6yvAVs4ZGiLdx2lM
U+FxpYBDBcXBtY4L9jb+vTgBn8nVtvc5u0/tZkF7ylQUP4zPes1FRnLT9ZuoI/c+
KULKAw9hWBzYQuCW53hqksx2BOJWenBfqt0Gt/Y9JAzm3D03q/8Xx2PPT6ZtKEK3
U1S8isPinxpw/QobyVt/qYe4zx78JO4TrX8uTH5xtEw+Ni8u4hMXYOjeoCUJCu8D
e5qh+4QbX0MQoKByGusnztbyt6n7t2bLjUFMCv4I0ySSvzsnJka4NUuh0Cup/QTt
3TnSiLDC5j71SMdRAlgf30bsnjzJrUedEC8518gnufQEXw3mP+dV2sNCCEPYCc+8
MLu9N1WsfkCwOl0vtwLV
=Am1h
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_18_24_14_+1000__kkvTL4MoAks0Fe4--
