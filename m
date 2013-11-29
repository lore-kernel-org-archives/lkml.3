Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3K2AcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:32:11 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:51194 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3K2AcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:32:08 -0500
Date: Fri, 29 Nov 2013 11:32:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>, Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolin Chen <b42378@freescale.com>,
        Lucas Stach <l.stach@pengutronix.de>
Subject: linux-next: manual merge of the slave-dma tree with the imx-mxs
 tree
Message-Id: <20131129113201.ed4d0e254c20bcaac82c822f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Nov_2013_11_32_01_+1100_hfp_Zpkdo2dLVxb_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Nov_2013_11_32_01_+1100_hfp_Zpkdo2dLVxb_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
arch/arm/boot/dts/imx53.dtsi between commit a0cd556100d0 ("ARM: imx53:
use clock defines in DTS files") from the imx-mxs tree and commit
786f0db6d439 ("ARM: dts: imx: use dual-fifo sdma script for ssi") from
the slave-dma tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/imx53.dtsi
index 4b2053b585d1,7208fde9bc16..000000000000
--- a/arch/arm/boot/dts/imx53.dtsi
+++ b/arch/arm/boot/dts/imx53.dtsi
@@@ -173,9 -152,9 +173,9 @@@
  					compatible =3D "fsl,imx53-ssi", "fsl,imx21-ssi";
  					reg =3D <0x50014000 0x4000>;
  					interrupts =3D <30>;
 -					clocks =3D <&clks 49>;
 +					clocks =3D <&clks IMX5_CLK_SSI2_IPG_GATE>;
- 					dmas =3D <&sdma 24 1 0>,
- 					       <&sdma 25 1 0>;
+ 					dmas =3D <&sdma 24 22 0>,
+ 					       <&sdma 25 22 0>;
  					dma-names =3D "rx", "tx";
  					fsl,fifo-depth =3D <15>;
  					fsl,ssi-dma-events =3D <25 24 23 22>; /* TX0 RX0 TX1 RX1 */

--Signature=_Fri__29_Nov_2013_11_32_01_+1100_hfp_Zpkdo2dLVxb_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSl+CFAAoJEMDTa8Ir7ZwV/t4P/RFy+vJhQGFg+dMgijqRQIVl
P80OV3Ep3oc/wZC/4gxdExTrNk0T6UyJYnkcjeHunpDSVIBHYcZa78+VZbV3E59v
8XbUczWLC/0xQ6mLbVQioezecvaP+9LfInpRN5Ac3A1Lq2mic+kPa67rYaPmHis0
86PFupf7KsdDOH46CeRzI1qkrgICQSKlRHgaTs+0ziWHdWKtXXi29MVA27bM5nu2
awVH+xJkzIRaO3JHzDef36mbThZN6Brd33BYuWOGzMEBv014bjchq2QIIiQe93M5
JiEgRkYsT5Fl2VVk1C80nHslf67zSKk7Vg7RbIQYJuIdCo1PpPu2xTw/PHr2bvTs
0LnPL8OrtEYZ/LoYzAscdl/l7vJosdJEY+0hO9Nh8vR9rkJmnxkLYqTIP/4lddLQ
cWOUyRHe4GN3I8ZpqiJHuMFz5JWJtGdFPImALCE1FVomL+m1RO/wTtARD/A/Ho9b
YWhRFO1pF7g4XNoV6gVcaS/sWqC3jFx4IiC89fGSHJ+oRBJOcqiE6Jq61oIAxCQT
GkzDScZwsup+6DwHxLGQdZbf5ns44c5IsEU6OWS1esjc1dHmpRC4h9ZVCCvTsvoT
wNMt2mPzwSkCa/WiQGDMtZJ74fJ6pNy8WON7adiHZbmkitt+swyA0O+M6pLtpIiA
od8qakHtB5aWIGlu3wOx
=0ODw
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Nov_2013_11_32_01_+1100_hfp_Zpkdo2dLVxb_--
