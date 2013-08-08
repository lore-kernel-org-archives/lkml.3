Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3HHFk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:40:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56325 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3HHFk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:40:58 -0400
Date: Thu, 8 Aug 2013 15:40:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: linux-next: manual merge of the mvebu tree with the i2c tree
Message-Id: <20130808154043.fe160a4e178e87a8c1c5a045@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Aug_2013_15_40_43_+1000_VN61Arqa2XwMsA+/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Aug_2013_15_40_43_+1000_VN61Arqa2XwMsA+/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt between
commit f480adaf1b71 ("i2c: mv64xxx: Document the newly introduced
allwinner compatible") from the i2c tree and commit e7c4a1e9f937 ("ARM:
dts: mvebu: Introduce a new compatible string for mv64xxx-i2c") from the
mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
index 6113f92,c5dd952..0000000
--- a/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
+++ b/Documentation/devicetree/bindings/i2c/i2c-mv64xxx.txt
@@@ -4,7 -4,8 +4,9 @@@
  Required properties :
 =20
   - reg             : Offset and length of the register set for the device
 - - compatible      : Should be "marvell,mv64xxx-i2c" and "marvell,mv7230-=
i2c"
 -for controller which support the I2C Transaction Generator
 + - compatible      : Should be "marvell,mv64xxx-i2c" or "allwinner,sun4i-=
i2c"
++                     or "marvell,mv7230-i2c" for controller which support
++                     the I2C Transaction Generator
   - interrupts      : The interrupt number
 =20
  Optional properties :

--Signature=_Thu__8_Aug_2013_15_40_43_+1000_VN61Arqa2XwMsA+/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSAy9fAAoJEECxmPOUX5FE3YoP/3g1Z+uFCVSzRdg4xcfrHgA+
WO0BxO9G+k/zo5cvgrybA3IHhZKerniaboxrzuNlCCLOjS/ikqkzEv/4nQ/PaFb6
SK2FJqiEHIQ6Epo2YQ1teqkLRwS2ODL50QHMUjGT/LAxufNIZu2eTvIXY83VRV4o
1RGa4qAlEWzClZ9VpKhBxWvYPKvPImp4uAZCkikvW/gMhVoVtvkWM0IS3DNkzIzw
LGZCYpztvhxXCh7fgNEjysrN4lH/emRSIzIqnasQ2PwIh4jrL3L+QUYPeS7HGZI5
0o3TTjm1O50aaK+dcjngCOr1pOiJm/CqgwkAdMsmO2ipnlKilpq/meYSmpgUbunA
vZ2zx9OoRaVrW89my7JSC3xu2ePRYqzdtNGlJN4TDnECNOWUEIo1A1MOAELQQrpH
b78x4RLOod9zou9jdnI/NozLhdS4AOVvWz6CtgMc1H6yIloOz2Ltci5Bhug5/AYi
/gFRchadNKaeF9p/WovLFnNnt8JMZ0SJ6mdgrHB8+hThvkRXC/ISWW8GJc5cabsJ
1nSKq9YoFQ0tKvQ/72FRwBM0Mzl3grV+qrLfUPvWHk7f2+eJMgVXe6N97XDnYO4s
5gxAxdq0POcTIXFr6UPGAZOJeeJzh1jlrKtyNivS95Pj1XLO4ZtX2lr3UGM6KzhK
cvQ6KulRhUP2d+CStm0L
=xhvc
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Aug_2013_15_40_43_+1000_VN61Arqa2XwMsA+/--
