Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab3GaGIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 02:08:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54148 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3GaGI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 02:08:28 -0400
Date: Wed, 31 Jul 2013 16:08:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Brown <davidb@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the msm tree with the arm tree
Message-Id: <20130731160816.cb6be9d41221da826f6851d2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__31_Jul_2013_16_08_16_+1000_gSHvg_EzvCkChwrx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Jul_2013_16_08_16_+1000_gSHvg_EzvCkChwrx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the msm tree got a conflict in
arch/arm/Kconfig.debug between several commits from the arm tree and
commit 7bd51cd4526d ("ARM: msm: Move debug-macro.S to include/debug")
from the msm tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/Kconfig.debug
index 38c92d7,4a62a8d..0000000
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@@ -886,178 -775,43 +886,183 @@@ config DEBUG_LL_INCLUD
  				 DEBUG_IMX53_UART ||\
  				 DEBUG_IMX6Q_UART || \
  				 DEBUG_IMX6SL_UART
 -	default "debug/keystone.S" if DEBUG_KEYSTONE_UART0 || \
 -				      DEBUG_KEYSTONE_UART1
+ 	default "debug/msm.S" if DEBUG_MSM_UART1 || \
+ 				 DEBUG_MSM_UART2 || \
+ 				 DEBUG_MSM_UART3 || \
+ 				 DEBUG_MSM8660_UART || \
+ 				 DEBUG_MSM8960_UART
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
 +	default "debug/vf.S" if DEBUG_VF_UART
  	default "debug/vt8500.S" if DEBUG_VT8500_UART0
  	default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
  	default "mach/debug-macro.S"
 =20
 +# Compatibility options for PL01x
 +config DEBUG_UART_PL01X
 +	def_bool ARCH_EP93XX || \
 +		ARCH_INTEGRATOR || \
 +		ARCH_SPEAR3XX || \
 +		ARCH_SPEAR6XX || \
 +		ARCH_SPEAR13XX || \
 +		ARCH_VERSATILE
 +
 +# Compatibility options for 8250
 +config DEBUG_UART_8250
 +	def_bool ARCH_DOVE || ARCH_EBSA110 || \
 +		(FOOTBRIDGE && !DEBUG_DC21285_PORT) || \
 +		ARCH_GEMINI || ARCH_IOP13XX || ARCH_IOP32X || \
 +		ARCH_IOP33X || ARCH_IXP4XX || ARCH_KIRKWOOD || \
 +		ARCH_LPC32XX || ARCH_MV78XX0 || ARCH_ORION5X || ARCH_RPC
 +
 +config DEBUG_UART_PHYS
 +	hex "Physical base address of debug UART"
 +	default 0x01c20000 if DEBUG_DAVINCI_DMx_UART0
 +	default 0x01c28000 if DEBUG_SUNXI_UART0
 +	default 0x01c28400 if DEBUG_SUNXI_UART1
 +	default 0x01d0c000 if DEBUG_DAVINCI_DA8XX_UART1
 +	default 0x01d0d000 if DEBUG_DAVINCI_DA8XX_UART2
 +	default 0x02530c00 if DEBUG_KEYSTONE_UART0
 +	default 0x02531000 if DEBUG_KEYSTONE_UART1
 +	default 0x03010fe0 if ARCH_RPC
 +	default 0x08108300 if DEBUG_DAVINCI_TNETV107X_UART1
 +	default 0x10009000 if DEBUG_REALVIEW_STD_PORT || DEBUG_CNS3XXX || \
 +				DEBUG_VEXPRESS_UART0_CA9
 +	default 0x1010c000 if DEBUG_REALVIEW_PB1176_PORT
 +	default 0x10124000 if DEBUG_RK3X_UART0
 +	default 0x10126000 if DEBUG_RK3X_UART1
 +	default 0x101f1000 if ARCH_VERSATILE
 +	default 0x101fb000 if DEBUG_NOMADIK_UART
 +	default 0x16000000 if ARCH_INTEGRATOR
 +	default 0x1c090000 if DEBUG_VEXPRESS_UART0_RS1
 +	default 0x20060000 if DEBUG_RK29_UART0
 +	default 0x20064000 if DEBUG_RK29_UART1 || DEBUG_RK3X_UART2
 +	default 0x20068000 if DEBUG_RK29_UART2 || DEBUG_RK3X_UART3
 +	default 0x20201000 if DEBUG_BCM2835
 +	default 0x40090000 if ARCH_LPC32XX
 +	default 0x40100000 if DEBUG_PXA_UART1
 +	default 0x42000000 if ARCH_GEMINI
 +	default 0x7c0003f8 if FOOTBRIDGE
 +	default 0x80230000 if DEBUG_PICOXCELL_UART
 +	default 0x80070000 if DEBUG_IMX23_UART
 +	default 0x80074000 if DEBUG_IMX28_UART
 +	default 0x808c0000 if ARCH_EP93XX
 +	default 0x90020000 if DEBUG_NSPIRE_CLASSIC_UART || DEBUG_NSPIRE_CX_UART
 +	default 0xb0090000 if DEBUG_VEXPRESS_UART0_CRX
 +	default 0xc0013000 if DEBUG_U300_UART
 +	default 0xc8000000 if ARCH_IXP4XX && !CPU_BIG_ENDIAN
 +	default 0xc8000003 if ARCH_IXP4XX && CPU_BIG_ENDIAN
 +	default 0xd0000000 if ARCH_SPEAR3XX || ARCH_SPEAR6XX
 +	default 0xd0012000 if DEBUG_MVEBU_UART
 +	default 0xd4017000 if DEBUG_MMP_UART2
 +	default 0xd4018000 if DEBUG_MMP_UART3
 +	default 0xe0000000 if ARCH_SPEAR13XX
 +	default 0xf0000be0 if ARCH_EBSA110
 +	default 0xf1012000 if DEBUG_MVEBU_UART_ALTERNATE
 +	default 0xf1012000 if ARCH_DOVE || ARCH_KIRKWOOD || ARCH_MV78XX0 || \
 +				ARCH_ORION5X
 +	default 0xfe800000 if ARCH_IOP32X
 +	default 0xffc02000 if DEBUG_SOCFPGA_UART
 +	default 0xffd82340 if ARCH_IOP13XX
 +	default 0xfff36000 if DEBUG_HIGHBANK_UART
 +	default 0xfffff700 if ARCH_IOP33X
 +	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 +		DEBUG_UART_8250 || DEBUG_UART_PL01X
 +
 +config DEBUG_UART_VIRT
 +	hex "Virtual base address of debug UART"
 +	default 0xe0010fe0 if ARCH_RPC
 +	default 0xf0000be0 if ARCH_EBSA110
 +	default 0xf0009000 if DEBUG_CNS3XXX
 +	default 0xf01fb000 if DEBUG_NOMADIK_UART
 +	default 0xf0201000 if DEBUG_BCM2835
 +	default 0xf11f1000 if ARCH_VERSATILE
 +	default 0xf1600000 if ARCH_INTEGRATOR
 +	default 0xf1c28000 if DEBUG_SUNXI_UART0
 +	default 0xf1c28400 if DEBUG_SUNXI_UART1
 +	default 0xf2100000 if DEBUG_PXA_UART1
 +	default 0xf4090000 if ARCH_LPC32XX
 +	default 0xf4200000 if ARCH_GEMINI
 +	default 0xf8009000 if DEBUG_VEXPRESS_UART0_CA9
 +	default 0xf8090000 if DEBUG_VEXPRESS_UART0_RS1
 +	default 0xfb009000 if DEBUG_REALVIEW_STD_PORT
 +	default 0xfb10c000 if DEBUG_REALVIEW_PB1176_PORT
 +	default 0xfd000000 if ARCH_SPEAR3XX || ARCH_SPEAR6XX
 +	default 0xfd000000 if ARCH_SPEAR13XX
 +	default 0xfd012000 if ARCH_MV78XX0
 +	default 0xfde12000 if ARCH_DOVE
 +	default 0xfe012000 if ARCH_ORION5X
 +	default 0xfe017000 if DEBUG_MMP_UART2
 +	default 0xfe018000 if DEBUG_MMP_UART3
 +	default 0xfe100000 if DEBUG_IMX23_UART || DEBUG_IMX28_UART
 +	default 0xfe230000 if DEBUG_PICOXCELL_UART
 +	default 0xfe800000 if ARCH_IOP32X
 +	default 0xfeb24000 if DEBUG_RK3X_UART0
 +	default 0xfeb26000 if DEBUG_RK3X_UART1
 +	default 0xfeb30c00 if DEBUG_KEYSTONE_UART0
 +	default 0xfeb31000 if DEBUG_KEYSTONE_UART1
 +	default 0xfec12000 if DEBUG_MVEBU_UART || DEBUG_MVEBU_UART_ALTERNATE
 +	default 0xfed60000 if DEBUG_RK29_UART0
 +	default 0xfed64000 if DEBUG_RK29_UART1 || DEBUG_RK3X_UART2
 +	default 0xfed68000 if DEBUG_RK29_UART2 || DEBUG_RK3X_UART3
 +	default 0xfec02000 if DEBUG_SOCFPGA_UART
 +	default 0xfec20000 if DEBUG_DAVINCI_DMx_UART0
 +	default 0xfed0c000 if DEBUG_DAVINCI_DA8XX_UART1
 +	default 0xfed0d000 if DEBUG_DAVINCI_DA8XX_UART2
 +	default 0xfed12000 if ARCH_KIRKWOOD
 +	default 0xfedc0000 if ARCH_EP93XX
 +	default 0xfee003f8 if FOOTBRIDGE
 +	default 0xfee08300 if DEBUG_DAVINCI_TNETV107X_UART1
 +	default 0xfee20000 if DEBUG_NSPIRE_CLASSIC_UART || DEBUG_NSPIRE_CX_UART
 +	default 0xfee36000 if DEBUG_HIGHBANK_UART
 +	default 0xfee82340 if ARCH_IOP13XX
 +	default 0xfef00000 if ARCH_IXP4XX && !CPU_BIG_ENDIAN
 +	default 0xfef00003 if ARCH_IXP4XX && CPU_BIG_ENDIAN
 +	default 0xfefff700 if ARCH_IOP33X
 +	default 0xff003000 if DEBUG_U300_UART
 +	default DEBUG_UART_PHYS if !MMU
 +	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
 +		DEBUG_UART_8250 || DEBUG_UART_PL01X
 +
 +config DEBUG_UART_8250_SHIFT
 +	int "Register offset shift for the 8250 debug UART"
 +	depends on DEBUG_LL_UART_8250 || DEBUG_UART_8250
 +	default 0 if FOOTBRIDGE || ARCH_IOP32X
 +	default 2
 +
 +config DEBUG_UART_8250_WORD
 +	bool "Use 32-bit accesses for 8250 UART"
 +	depends on DEBUG_LL_UART_8250 || DEBUG_UART_8250
 +	depends on DEBUG_UART_8250_SHIFT >=3D 2
 +	default y if DEBUG_PICOXCELL_UART || DEBUG_SOCFPGA_UART || \
 +		ARCH_KEYSTONE || \
 +		DEBUG_DAVINCI_DMx_UART0 || DEBUG_DAVINCI_DA8XX_UART1 || \
 +		DEBUG_DAVINCI_DA8XX_UART2 || DEBUG_DAVINCI_TNETV107X_UART1
 +
 +config DEBUG_UART_8250_FLOW_CONTROL
 +	bool "Enable flow control for 8250 UART"
 +	depends on DEBUG_LL_UART_8250 || DEBUG_UART_8250
 +	default y if ARCH_EBSA110 || FOOTBRIDGE || ARCH_GEMINI || ARCH_RPC
 +
  config DEBUG_UNCOMPRESS
  	bool
- 	depends on ARCH_MULTIPLATFORM
 -	default y if (ARCH_MULTIPLATFORM || ARCH_MSM) && DEBUG_LL && \
 -		     !DEBUG_OMAP2PLUS_UART && \
++	depends on ARCH_MULTIPLATFORM || ARCH_MSM
 +	default y if DEBUG_LL && !DEBUG_OMAP2PLUS_UART && \
  		     !DEBUG_TEGRA_UART
 +	help
 +	  This option influences the normal decompressor output for
 +	  multiplatform kernels.  Normally, multiplatform kernels disable
 +	  decompressor output because it is not possible to know where to
 +	  send the decompressor output.
 +
 +	  When this option is set, the selected DEBUG_LL output method
 +	  will be re-used for normal decompressor output on multiplatform
 +	  kernels.
 +	 =20
 =20
  config UNCOMPRESS_INCLUDE
  	string

--Signature=_Wed__31_Jul_2013_16_08_16_+1000_gSHvg_EzvCkChwrx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR+KnUAAoJEECxmPOUX5FEX7MQAJbqdVHjpXXu5L+RaXXoom40
NmIOedqd5Ur2qp0g1zuD2MIIzEJ3Ev59IS3S6nvi+OeV0W2Fa8JSJ+m2P7Qk2bDV
lB2Rj5KSLt4H6uLtFHXLOiw6jX+u7Eius5C44SLU3Ze+3ueQxgbQ/wqgPTwNzlaU
HfUN6J7oww15GL5fwPET9aLGzPPBsSoZQgaQHZPMP6PXnEdBUIUrgOLdP2vdnoZa
hFybErkHTh7uyv/ubBna0INi/CGChBIlXEvSuABtm2b5Dyv5kHwIJR+rgCzGn8id
0IAZ6AHNl6Uz+1VPNG6qlpIek9SAP3MDvoWlCVwsRfE3jQm6jy7Czc7wYAIBpphk
XETAx/R93LMDF9Z9GgSQLm7VAtmTp+c4+prHbAI1bOwIqrSboazLWI48hrzKp3eP
Ukf3q9g8j0w/l8w+0Yak3tbuQmwb8GB49lB3+YZUrorjGcPoA1GaWG5VaMcqKS5u
NFUXq/8DvYATOd68Vu1/R5iG6kEqv//i4VUMPzEhchAAdNvOGZRHehB7oWquoyi5
/IQeEb25xB4DLJpA18TzwfB8lMvpdlmu3RCQUhn4jL0VduDzI61IMN0ptSExD9ZZ
Q4uKh4/sCkYDsG3vvbrQEcGYS5uQqEhWWcXGGkMpNgMrh6YEpr39lGFVFunJNrQa
6zlZIsoYoVPstfEC8bDo
=byzI
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Jul_2013_16_08_16_+1000_gSHvg_EzvCkChwrx--
