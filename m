Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab3GWDHT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 23:07:19 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60998 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab3GWDHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 23:07:17 -0400
Date: Tue, 23 Jul 2013 13:07:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the imx-mxs tree with the arm tree
Message-Id: <20130723130706.29d43b431ebfc99ff21a673a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__23_Jul_2013_13_07_06_+1000_wnz7q_COTF1iQTGc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Jul_2013_13_07_06_+1000_wnz7q_COTF1iQTGc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/Kconfig.debug between commit 5e33abe38413 ("ARM: debug: move
PL01X debug include into arch/arm/include/debug/") from the arm tree and
commit d1814df976f2 ("ARM: imx: add low-level debug for vybrid") from the
imx-mxs tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig.debug
index 6638398,0aa5b9d..0000000
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@@ -879,12 -782,30 +886,13 @@@ config DEBUG_LL_INCLUD
  				 DEBUG_IMX53_UART ||\
  				 DEBUG_IMX6Q_UART || \
  				 DEBUG_IMX6SL_UART
 -	default "debug/keystone.S" if DEBUG_KEYSTONE_UART0 || \
 -				      DEBUG_KEYSTONE_UART1
 -	default "debug/mvebu.S" if DEBUG_MVEBU_UART || \
 -				   DEBUG_MVEBU_UART_ALTERNATE
 -	default "debug/mxs.S" if DEBUG_IMX23_UART || DEBUG_IMX28_UART
 -	default "debug/nomadik.S" if DEBUG_NOMADIK_UART
 -	default "debug/nspire.S" if 	DEBUG_NSPIRE_CX_UART || \
 -					DEBUG_NSPIRE_CLASSIC_UART
  	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
 -	default "debug/picoxcell.S" if DEBUG_PICOXCELL_UART
 -	default "debug/pxa.S" if DEBUG_PXA_UART1 || DEBUG_MMP_UART2 || \
 -				 DEBUG_MMP_UART3
 -	default "debug/rockchip.S" if DEBUG_ROCKCHIP_UART
  	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UART1
 -	default "debug/socfpga.S" if DEBUG_SOCFPGA_UART
  	default "debug/sti.S" if DEBUG_STI_UART
 -	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
  	default "debug/tegra.S" if DEBUG_TEGRA_UART
 -	default "debug/u300.S" if DEBUG_U300_UART
  	default "debug/ux500.S" if DEBUG_UX500_UART
 -	default "debug/vexpress.S" if DEBUG_VEXPRESS_UART0_DETECT || \
 -		DEBUG_VEXPRESS_UART0_CA9 || DEBUG_VEXPRESS_UART0_RS1 || \
 -		DEBUG_VEXPRESS_UART0_CRX
 +	default "debug/vexpress.S" if DEBUG_VEXPRESS_UART0_DETECT
+ 	default "debug/vf.S" if DEBUG_VF_UART
  	default "debug/vt8500.S" if DEBUG_VT8500_UART0
  	default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
  	default "mach/debug-macro.S"

--Signature=_Tue__23_Jul_2013_13_07_06_+1000_wnz7q_COTF1iQTGc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR7fNeAAoJEECxmPOUX5FE9HUQAJoFyFIBJz3D5pPIXpfZ3vok
DXgvMEAmHREAAUR2WsK2W90tJt7llj5o9xslhRcnqK2EWsti5hHr4mIq3XLFSyVW
3SGawZtuiP3EUdLIP2wNN2BpQxfqR9xGE/PLCAnzzgaJH0C7JrGtoKqKjCd0FR3t
47Iyfd4OC116Dx0oGUim+jE9sx1YHOhAuytb0uwj7EcK4Nfli5GTPpPzilY5YUmh
/6M4jRarDQ7t7Q4R+uuycQV19n13RdlcaBPVKA2Ui/FQjzGzMesVb7cnVZNaTl1L
WRZSaxL5WlYScH1fvAK8zl1VmHXf2+zKRpQfJq0ay+kE5/G7DOahn2xKUvRTrT29
nOxiadmX9guKJQkr3tEDXaGxV6kWQIJqhI8VBMbp8usLgYchCFIvFA2R9ZUGYy/Q
UAlhczlzNEIIgDoHuYbfRnMgr49r6vRdCXVoC7D7yK8JY1YabEX++Gt7/AAvyiJB
BvUnts5VpulWy/8avuwOgtlfxrs7Sq0/c2CQiM68jfl9yf+WiarabgnBD1IO0D8i
YjovrlPchd1I24IzFKj88WXek7oz2kIQypZjDnCvxoTaP2VcNn6FeG7RRedEsW+K
PSSnorJ8XB05B56A7E91iQ7LltX0OGv6P9tdSDAICXAeczALB9Gq4K2YVdCjyc40
/+0cJz3tETLfMZQUlnWr
=jbMW
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Jul_2013_13_07_06_+1000_wnz7q_COTF1iQTGc--
