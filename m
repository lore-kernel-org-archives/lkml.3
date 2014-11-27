Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573AbaK0Xga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 18:36:30 -0500
Received: from ozlabs.org ([103.22.144.67]:36217 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279AbaK0Xg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 18:36:28 -0500
Date: Fri, 28 Nov 2014 10:36:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chen-Yu Tsai <wens@csie.org>
Subject: linux-next: manual merge of the sunxi tree with the arm-soc tree
Message-ID: <20141128103617.13a1821c@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/w/pxrGfvDUlbaoj6rA7DIt5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/w/pxrGfvDUlbaoj6rA7DIt5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Maxime,

Today's linux-next merge of the sunxi tree got a conflict in
arch/arm/boot/dts/sun6i-a31.dtsi between commit 3fd0c05da46c ("Revert
"ARM: dts: sunxi: Use sun4i-a10-apb1-clk for sun6i/sun8i apb2
clocks."") from the arm-soc tree and commit 74c947ab33c9 ("ARM: dts:
sunxi: Use sun4i-a10-apb1-clk for sun6i/sun8i apb2 clocks") from the
sunxi tree.

I fixed it up (I just used the arm-soc version for now) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/sun6i-a31.dtsi
index 529c73803976,f47156b6572b..000000000000
--- a/arch/arm/boot/dts/sun6i-a31.dtsi
+++ b/arch/arm/boot/dts/sun6i-a31.dtsi
@@@ -217,19 -229,11 +229,19 @@@
  					"apb1_daudio1";
  		};
 =20
 -		apb2: clk@01c20058 {
 +		apb2_mux: apb2_mux@01c20058 {
 +			#clock-cells =3D <0>;
 +			compatible =3D "allwinner,sun4i-a10-apb1-mux-clk";
 +			reg =3D <0x01c20058 0x4>;
 +			clocks =3D <&osc32k>, <&osc24M>, <&pll6 0>, <&pll6 0>;
 +			clock-output-names =3D "apb2_mux";
 +		};
 +
 +		apb2: apb2@01c20058 {
  			#clock-cells =3D <0>;
- 			compatible =3D "allwinner,sun6i-a31-apb2-div-clk";
+ 			compatible =3D "allwinner,sun4i-a10-apb1-clk";
  			reg =3D <0x01c20058 0x4>;
- 			clocks =3D <&apb2_mux>;
+ 			clocks =3D <&osc32k>, <&osc24M>, <&pll6 0>, <&pll6 0>;
  			clock-output-names =3D "apb2";
  		};
 =20

--Sig_/w/pxrGfvDUlbaoj6rA7DIt5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUd7V1AAoJEMDTa8Ir7ZwVgsIP/0WswgU6gPBB/X0vtmosaOWP
agr09gOo+x9+AbcPkvUFc+n0VkIIokGZSEdVxj106QLoNP83SBqHzLgswq/F6uEX
GCpqzKUXLtsv6DbtQUh5fJJgtroMjj08RYA1owfgqeSD1MeHNYGzoxoEg/wqQutL
yg+KWq8LPu15HlF1y7p5/SizgEQCjG4JaTLjh6HhWWaVkR+mpZz2e8XwLq3HUpVs
+gh08EUpFBKMAj/b+HzmgLYkyTVez3SQgTDVHnEryke2taUjK73hSBT04AXV2e48
B7nUf596TXAJSqyV6n+jsH0E5Hk3RRkrKuh5Mwp3H3CT477Pvy4x43iLXUSSiLzp
tH/4dcd3oqvu9lhZkKyXpqAo3dGNYBb7gc227MM+x+erUgGE3yoF1pZ+rdWsiozo
D2pP/DMdqHhEj+LbLNd00SK5nb/LGQrDSdLTLdwu+prD10UAUo4MHpRs3lA3gSW1
gLOsLo2ngIwA00Wirzsb6YQ774uMjUt0vI+p9bEO28HRDAa4UrVujN7T+xRydX/E
VOnIv9G6g2hrxwGSmZL1fGIvIoWM4gmmEGeCI1pphbXCbVhuND0eUMqPhTXqbBvY
GQCMxrZhfghzdmZulBFNUBgWfpkxBb+k5HZopUUxCtNWaxrkYRQl+DJEugFJKU86
HFGxWU6yk10tqu7tM1Ds
=2rfY
-----END PGP SIGNATURE-----

--Sig_/w/pxrGfvDUlbaoj6rA7DIt5--
