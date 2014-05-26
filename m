Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658AbaEZFnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 01:43:40 -0400
Received: from ozlabs.org ([103.22.144.67]:33530 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751607AbaEZFnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 01:43:39 -0400
Date: Mon, 26 May 2014 15:43:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cosmin Stoica <cosminstefan.stoica@freescale.com>,
        Shawn Guo <shawn.guo@freescale.com>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: linux-next: manual merge of the clockevents tree with the arm-soc
 tree
Message-ID: <20140526154331.7fc6b30c@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fnJgPSxbvrLc3RXv=182FNj"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fnJgPSxbvrLc3RXv=182FNj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

Today's linux-next merge of the clockevents tree got a conflict in
arch/arm/boot/dts/vf610.dtsi between commit 0517fe6aa880 ("ARM: dts:
vf610-twr: Add support for sdhc1") from the arm-soc tree and commit
07513e1330a9 ("ARM: dts: vf610: Add Freescale FlexTimer Module timer
node") from the clockevents tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/vf610.dtsi
index 73355ddc5186,3c91b84066a1..000000000000
--- a/arch/arm/boot/dts/vf610.dtsi
+++ b/arch/arm/boot/dts/vf610.dtsi
@@@ -360,17 -347,19 +360,30 @@@
  				status =3D "disabled";
  			};
 =20
 +			esdhc1: esdhc@400b2000 {
 +				compatible =3D "fsl,imx53-esdhc";
 +				reg =3D <0x400b2000 0x4000>;
 +				interrupts =3D <0 28 0x04>;
 +				clocks =3D <&clks VF610_CLK_IPG_BUS>,
 +					<&clks VF610_CLK_PLATFORM_BUS>,
 +					<&clks VF610_CLK_ESDHC1>;
 +				clock-names =3D "ipg", "ahb", "per";
 +				status =3D "disabled";
 +			};
 +
+ 			ftm: ftm@400b8000 {
+ 				compatible =3D "fsl,ftm-timer";
+ 				reg =3D <0x400b8000 0x1000 0x400b9000 0x1000>;
+ 				interrupts =3D <0 44 IRQ_TYPE_LEVEL_HIGH>;
+ 				clock-names =3D "ftm-evt", "ftm-src",
+ 					"ftm-evt-counter-en", "ftm-src-counter-en";
+ 				clocks =3D <&clks VF610_CLK_FTM2>,
+ 					<&clks VF610_CLK_FTM3>,
+ 					<&clks VF610_CLK_FTM2_EXT_FIX_EN>,
+ 					<&clks VF610_CLK_FTM3_EXT_FIX_EN>;
+ 				status =3D "disabled";
+ 			};
+=20
  			fec0: ethernet@400d0000 {
  				compatible =3D "fsl,mvf600-fec";
  				reg =3D <0x400d0000 0x1000>;

--Sig_/fnJgPSxbvrLc3RXv=182FNj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTgtSIAAoJEMDTa8Ir7ZwVlA0P/0POL6vfY5pCCxiOIgIAXwXX
WCpHd+yxKm3KrmxPXDf5TT63efkJmENLk4veUPT6bKL75nV7rCErP0RYeby3AWbR
VeVGWYoXJj21eRCFxyfO6d4kRAPnE9+3kXGtloemTbrFWVsVQY6fcJ1cWVvUXBMm
U13Q1DW04JfHtMfIurAQvwJS7KX8gPrse9UvGvaJcc9baty35u6QJvwf53cw0q5S
cw8PWme/kZpsQ5lsHcyExeU7O9vnsB+ASoVwqfqxiAVA8AhGAkVtv2lfmoxpsb7H
vbnBl/wCmYW2bVGvEXKESQ/DLn6IDGw0FKn0ET2yPLgkJRLt/+cvJL5ZUvLyTh/c
ArhQuu9RIqofO3PyVLymcL/WxbbbdOa3r4bVPn+Vv0BY2kk85/nylB+uL6xham3y
s/1GeLwgVcO9N50GWNEm3EY9Hs8LWcQ2lzD956cAsTb+VWak+FYMez7U0sceAI/B
dLugcX8fFp1ylr/Jagh8Rll1hJ8hNgM317+UnAgkWkrWdjgRhP4oz3HumGjlebtc
Ab4+2Qg7E67ZRc3ORXUR5KF8/aKI3wzr4lF/BDmrladWC0s5/Rf84BR0OthRkfo7
0OngBMR8BK2YJ4LS04ki44V42LXNvRBNQ2/o7HKixpzdAeXvuELD8CtBuZLnduua
L3bDLcjJUcTvPf3u0Y53
=PJg3
-----END PGP SIGNATURE-----

--Sig_/fnJgPSxbvrLc3RXv=182FNj--
