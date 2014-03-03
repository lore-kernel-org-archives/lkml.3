Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaCCB7B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 20:59:01 -0500
Received: from ozlabs.org ([203.10.76.45]:55784 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbaCCB7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 20:59:00 -0500
Date: Mon, 3 Mar 2014 12:58:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: linux-next: manual merge of the imx-mxs tree with the arm-soc tree
Message-Id: <20140303125852.f0f4ebf5af79627aaa3baf5d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_12_58_52_+1100_cXYmIIYPQGGuoZ_W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_12_58_52_+1100_cXYmIIYPQGGuoZ_W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

Today's linux-next merge of the imx-mxs tree got a conflict in
arch/arm/mach-imx/Kconfig between commits ddb902cc3459 ("ARM: centralize
common multi-platform kconfig options") and 37dff0825611 ("ARM: imx6:
introduce CONFIG_SOC_IMX6 for i.MX6 common stuff") from the arm-soc tree
and commit f702c0213144 ("ARM: mach-imx: Select CONFIG_SRAM at ARCH_MXC
level") from the imx-mxs tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/Kconfig
index 41ffd433f709,e45062d41fcb..000000000000
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@@ -1,12 -1,22 +1,15 @@@
  config ARCH_MXC
  	bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7
+ 	select ARCH_HAS_CPUFREQ
+ 	select ARCH_HAS_OPP
  	select ARCH_REQUIRE_GPIOLIB
  	select ARM_CPU_SUSPEND if PM
 -	select ARM_PATCH_PHYS_VIRT
  	select CLKSRC_MMIO
- 	select GENERIC_ALLOCATOR
 -	select COMMON_CLK
 -	select GENERIC_CLOCKEVENTS
  	select GENERIC_IRQ_CHIP
 -	select MIGHT_HAVE_CACHE_L2X0 if ARCH_MULTI_V6_V7
 -	select MULTI_IRQ_HANDLER
  	select PINCTRL
+ 	select PM_OPP if PM
  	select SOC_BUS
 -	select SPARSE_IRQ
+ 	select SRAM
 -	select USE_OF
  	help
  	  Support for Freescale MXC/iMX-based family of processors
 =20
@@@ -114,10 -124,11 +117,10 @@@ config SOC_IMX3
  config SOC_IMX35
  	bool
  	select ARCH_MXC_IOMUX_V3
 -	select CPU_V6K
  	select HAVE_EPIT
  	select MXC_AVIC
+ 	select PINCTRL_IMX35
  	select SMP_ON_UP if SMP
- 	select PINCTRL
 =20
  config SOC_IMX5
  	bool
@@@ -775,16 -786,12 +777,11 @@@ config	SOC_IMX5
  	help
  	  This enables support for Freescale i.MX53 processor.
 =20
- config SOC_IMX6Q
- 	bool "i.MX6 Quad/DualLite support"
- 	select ARCH_HAS_CPUFREQ
- 	select ARCH_HAS_OPP
+ config SOC_IMX6
+ 	bool
  	select ARM_ERRATA_754322
- 	select ARM_ERRATA_764369 if SMP
  	select ARM_ERRATA_775420
  	select ARM_GIC
- 	select HAVE_ARM_SCU if SMP
- 	select HAVE_ARM_TWD if SMP
 -	select CPU_V7
  	select HAVE_IMX_ANATOP
  	select HAVE_IMX_GPC
  	select HAVE_IMX_MMDC
@@@ -793,10 -800,17 +790,16 @@@
  	select PL310_ERRATA_588369 if CACHE_PL310
  	select PL310_ERRATA_727915 if CACHE_PL310
  	select PL310_ERRATA_769419 if CACHE_PL310
- 	select PM_OPP if PM
+=20
+ config SOC_IMX6Q
+ 	bool "i.MX6 Quad/DualLite support"
+ 	select ARM_ERRATA_764369 if SMP
+ 	select HAVE_ARM_SCU if SMP
+ 	select HAVE_ARM_TWD if SMP
 -	select HAVE_SMP
+ 	select MIGHT_HAVE_PCI
+ 	select PCI_DOMAINS if PCI
+ 	select PINCTRL_IMX6Q
+ 	select SOC_IMX6
 =20
  	help
  	  This enables support for Freescale i.MX6 Quad processor.

--Signature=_Mon__3_Mar_2014_12_58_52_+1100_cXYmIIYPQGGuoZ_W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTE+HgAAoJEMDTa8Ir7ZwVyR0QAIzjYT60WHRSLaD4e/y4BKxy
junoqaADBmazPUOSyXeKqy+9OsTindpeaWjAGC1mYmZRm6xZcJ2lX5XvuNtniTPI
pwBgwRsMep6fHun0jllyPWB4zupA4wIXYmqa1MO4z9h7j7NkYeIEVRwz+4G9FfdK
LUivltD656Z/GLq+Zjlot6nabNvVm3DAqCJurMBnPDLnbr0TKpPPNFfd2Np8raIc
x/08sVxrvwR1c2qTjbi4w/RBJMq3ZaTKD79ot37KXl7JIwBihohYgfVAfCSGYr7L
6Q/SlqZRIZTpTLjckDqdRK7stknpaYMkCnC9Q5kCdksDGfFQCfjHvtMINAACWl9S
tz/GvjI4oQnK6rvsxMZQVXi38twZTt6ceKWvs7gYTnaBqGAvloNLIHANR0j2x0pi
Id0KmXLLwSWtOYcr62Yob8HSfkUQ+YE3mL7lBU7KWzPVkhWuTI9zABSlcQIf9UXn
dE4fdCO3+N90YpPa7CbiPLYHEVwA0hx/4lHUPmlct6JvUGG8YiqTO8twnK+HUC1U
0FwQdnUbiULUEbMmP1gxQgNPfmd/dqouQjsuCBhOdFIuHgGnij5A1NKiIzJDt2Bf
YvDObwARxpuiS1MgUecsaTBtmtLWBICKRKqytb7qq61O/wf2u8D5iudEsCzNkrYD
l6mKq6uIhyncLz2BX7+6
=CNrE
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_12_58_52_+1100_cXYmIIYPQGGuoZ_W--
