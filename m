Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887Ab3DBG4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:56:11 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44800 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756125Ab3DBG4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:56:08 -0400
Date: Tue, 2 Apr 2013 17:55:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the imx-mxs tree with the arm-soc tree
Message-Id: <20130402175557.e44f384205d2d32dcd95be1d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_17_55_57_+1100_.+D=qq=qJEIVcImZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_17_55_57_+1100_.+D=qq=qJEIVcImZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/Kconfig.debug between commit 266c347924f5 ("ARM: nomadik: move
debugmacro to debug includes") from the arm-soc tree and commit
11c6f861cf3a ("ARM: mxs: rename debug-macro.S for multiplatform build")
from the imx-mxs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig.debug
index d212ae0,057601e..0000000
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@@ -611,10 -591,9 +611,11 @@@ config DEBUG_LL_INCLUD
  				 DEBUG_IMX6Q_UART
  	default "debug/highbank.S" if DEBUG_HIGHBANK_UART
  	default "debug/mvebu.S" if DEBUG_MVEBU_UART
 +	default "debug/nomadik.S" if DEBUG_NOMADIK_UART
+ 	default "debug/mxs.S" if DEBUG_IMX23_UART || DEBUG_IMX28_UART
  	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
  	default "debug/picoxcell.S" if DEBUG_PICOXCELL_UART
 +	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
  	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
  	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
  	default "debug/vexpress.S" if DEBUG_VEXPRESS_UART0_DETECT || \

--Signature=_Tue__2_Apr_2013_17_55_57_+1100_.+D=qq=qJEIVcImZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWoD9AAoJEECxmPOUX5FE6A0P/jBTov+jMGR3+CO32t3PTult
s66vmJfYwFTPOHepWK1phjtBtYvj/DWToWeM8maz7Y2AhDtWzK/EyK79QOtYw5o4
pa9yOv0r85PJrhetXd76pc9KYWXxdsECL+Ys9+/WmFakrDY90J5fAEjEcwtSrKWk
2opFZG2S3NYh4o2UCTvtjSL/OzI1hzvWWDIemhUBWb7f2uYKFZDnnQGxliyfem50
EqHezGKTdcBADdE355m8k2KD1XO60Pta3/wCIXmBSa7nz9rQ34s4T9+71+WWZPbB
L3koCc/UGtbD82ZPH+Cy3zbBck8xKXg6esPR5rDT20Ingu+QUj7C1PZ5aqbFXE9p
djwedidDVCGnSMOc9Qhvl0mQCGWP7W2SbqvbzIcg0CvhqQCQQR5LA77ZUONKLgLA
Jpz3aM+ug1JInYnqVxKLLpwdO705D6ct7/7omGtZM1x9K5tZw+7Vw2vxddK/+Tn0
fe33F45q7wgfvpjvfGrgEZXy/20FgqBM4f5HEZqxumtuqw9UgwbS5p+5Wcx5oErX
lJTbMS+gaNx2R204g3GP0cO6fSE8t7+hpieyBDhWK0V7mVxR2qJFGahPleJ2Q+OV
WfVtYs4COlomGGOY5E0ty/ZZoiWGOHOv0T/4H8YmvlkqxfcafipF63/UZh6bunJ8
X8l4UZJGkPCPY8AyOdhs
=cnuk
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_17_55_57_+1100_.+D=qq=qJEIVcImZ--
