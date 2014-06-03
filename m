Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbaFCSYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:24:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:57583 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbaFCSY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:24:26 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: arm@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sachin Kamat <spk.linux@gmail.com>
Subject: [PATCH v2] ARM: Remove ARCH_HAS_CPUFREQ config option
Date: Tue,  3 Jun 2014 11:24:23 -0700
Message-Id: <1401819863-20296-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.9.0.1.gd5ccf8c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This config exists entirely to hide the cpufreq menu from the
kernel configuration unless a platform has selected it. Nothing
is actually built if this config is 'Y' and it just leads to more
patches that add a select under a platform Kconfig so that some
other CPUfreq option can be chosen. Let's remove the option so
that we can always enable CPUfreq drivers on ARM platforms.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Maybe this can go through the arm-soc tree by direct patch
application?

 arch/arm/Kconfig               | 17 -----------------
 arch/arm/mach-davinci/Kconfig  |  1 -
 arch/arm/mach-exynos/Kconfig   |  1 -
 arch/arm/mach-highbank/Kconfig |  1 -
 arch/arm/mach-imx/Kconfig      |  3 ---
 arch/arm/mach-mvebu/Kconfig    |  1 -
 arch/arm/mach-omap2/Kconfig    |  1 -
 arch/arm/mach-shmobile/Kconfig |  2 --
 arch/arm/mach-spear/Kconfig    |  1 -
 arch/arm/mach-tegra/Kconfig    |  1 -
 arch/arm/mach-ux500/Kconfig    |  1 -
 arch/arm/mach-vexpress/Kconfig |  1 -
 arch/arm/mach-vt8500/Kconfig   |  1 -
 arch/arm/mach-zynq/Kconfig     |  1 -
 14 files changed, 33 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 692399cc1170..e5a7396c990d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -176,13 +176,6 @@ config ARCH_HAS_ILOG2_U32
 config ARCH_HAS_ILOG2_U64
 	bool
 
-config ARCH_HAS_CPUFREQ
-	bool
-	help
-	  Internal node to signify that the ARCH has CPUFREQ support
-	  and that the relevant menu configurations are displayed for
-	  it.
-
 config ARCH_HAS_BANDGAP
 	bool
 
@@ -319,7 +312,6 @@ config ARCH_MULTIPLATFORM
 
 config ARCH_INTEGRATOR
 	bool "ARM Ltd. Integrator family"
-	select ARCH_HAS_CPUFREQ
 	select ARM_AMBA
 	select ARM_PATCH_PHYS_VIRT
 	select AUTO_ZRELADDR
@@ -539,7 +531,6 @@ config ARCH_DOVE
 
 config ARCH_KIRKWOOD
 	bool "Marvell Kirkwood"
-	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select CPU_FEROCEON
 	select GENERIC_CLOCKEVENTS
@@ -638,7 +629,6 @@ config ARCH_LPC32XX
 config ARCH_PXA
 	bool "PXA2xx/PXA3xx-based"
 	depends on MMU
-	select ARCH_HAS_CPUFREQ
 	select ARCH_MTD_XIP
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_CPU_SUSPEND if PM
@@ -708,7 +698,6 @@ config ARCH_RPC
 
 config ARCH_SA1100
 	bool "SA1100-based"
-	select ARCH_HAS_CPUFREQ
 	select ARCH_MTD_XIP
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_SPARSEMEM_ENABLE
@@ -726,7 +715,6 @@ config ARCH_SA1100
 
 config ARCH_S3C24XX
 	bool "Samsung S3C24XX SoCs"
-	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select ATAGS
 	select CLKDEV_LOOKUP
@@ -747,7 +735,6 @@ config ARCH_S3C24XX
 
 config ARCH_S3C64XX
 	bool "Samsung S3C64XX"
-	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_AMBA
 	select ARM_VIC
@@ -810,7 +797,6 @@ config ARCH_S5PC100
 
 config ARCH_S5PV210
 	bool "Samsung S5PV210/S5PC110"
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_SPARSEMEM_ENABLE
 	select ATAGS
@@ -846,7 +832,6 @@ config ARCH_DAVINCI
 config ARCH_OMAP1
 	bool "TI OMAP1"
 	depends on MMU
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_OMAP
 	select ARCH_REQUIRE_GPIOLIB
@@ -2115,9 +2100,7 @@ endmenu
 
 menu "CPU Power Management"
 
-if ARCH_HAS_CPUFREQ
 source "drivers/cpufreq/Kconfig"
-endif
 
 source "drivers/cpuidle/Kconfig"
 
diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index db18ef866593..584e8d4e2892 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -39,7 +39,6 @@ config ARCH_DAVINCI_DA830
 config ARCH_DAVINCI_DA850
 	bool "DA850/OMAP-L138/AM18x based system"
 	select ARCH_DAVINCI_DA8XX
-	select ARCH_HAS_CPUFREQ
 	select CP_INTC
 
 config ARCH_DAVINCI_DA8XX
diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index d58995c9a95a..845031b50826 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -10,7 +10,6 @@
 config ARCH_EXYNOS
 	bool "Samsung EXYNOS" if ARCH_MULTI_V7
 	select ARCH_HAS_BANDGAP
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_AMBA
diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
index 830b76e70250..a5960e2ac090 100644
--- a/arch/arm/mach-highbank/Kconfig
+++ b/arch/arm/mach-highbank/Kconfig
@@ -1,7 +1,6 @@
 config ARCH_HIGHBANK
 	bool "Calxeda ECX-1000/2000 (Highbank/Midway)" if ARCH_MULTI_V7
 	select ARCH_DMA_ADDR_T_64BIT if ARM_LPAE
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_HAS_OPP
 	select ARCH_SUPPORTS_BIG_ENDIAN
diff --git a/arch/arm/mach-imx/Kconfig b/arch/arm/mach-imx/Kconfig
index 4cce93d6c042..8acd4b1cc5d6 100644
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@ -1,6 +1,5 @@
 config ARCH_MXC
 	bool "Freescale i.MX family" if ARCH_MULTI_V4_V5 || ARCH_MULTI_V6_V7
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_CPU_SUSPEND if PM
@@ -99,7 +98,6 @@ config SOC_IMX25
 
 config SOC_IMX27
 	bool
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
 	select CPU_ARM926T
 	select IMX_HAVE_IOMUX_V1
@@ -693,7 +691,6 @@ comment "Device tree only"
 
 config SOC_IMX5
 	bool
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
 	select HAVE_IMX_SRC
 	select MXC_TZIC
diff --git a/arch/arm/mach-mvebu/Kconfig b/arch/arm/mach-mvebu/Kconfig
index 6090b9eb00c8..c8bef39ec199 100644
--- a/arch/arm/mach-mvebu/Kconfig
+++ b/arch/arm/mach-mvebu/Kconfig
@@ -84,7 +84,6 @@ config MACH_DOVE
 
 config MACH_KIRKWOOD
 	bool "Marvell Kirkwood boards" if ARCH_MULTI_V5
-	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select CPU_FEROCEON
 	select KIRKWOOD_CLK
diff --git a/arch/arm/mach-omap2/Kconfig b/arch/arm/mach-omap2/Kconfig
index 0ba482638ebf..d8006a2bb808 100644
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -80,7 +80,6 @@ config SOC_DRA7XX
 config ARCH_OMAP2PLUS
 	bool
 	select ARCH_HAS_BANDGAP
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_OMAP
 	select ARCH_REQUIRE_GPIOLIB
diff --git a/arch/arm/mach-shmobile/Kconfig b/arch/arm/mach-shmobile/Kconfig
index dbd954e61aa7..270e5caf3c97 100644
--- a/arch/arm/mach-shmobile/Kconfig
+++ b/arch/arm/mach-shmobile/Kconfig
@@ -85,7 +85,6 @@ config ARCH_R8A73A4
 	select CPU_V7
 	select SH_CLK_CPG
 	select RENESAS_IRQC
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
 	select SYS_SUPPORTS_SH_CMT
 	select SYS_SUPPORTS_SH_TMU
@@ -264,7 +263,6 @@ config MACH_KOELSCH
 config MACH_KZM9G
 	bool "KZM-A9-GT board"
 	depends on ARCH_SH73A0
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
 	select ARCH_REQUIRE_GPIOLIB
 	select REGULATOR_FIXED_VOLTAGE if REGULATOR
diff --git a/arch/arm/mach-spear/Kconfig b/arch/arm/mach-spear/Kconfig
index 0786249b2832..90df2022276a 100644
--- a/arch/arm/mach-spear/Kconfig
+++ b/arch/arm/mach-spear/Kconfig
@@ -14,7 +14,6 @@ if PLAT_SPEAR
 config ARCH_SPEAR13XX
 	bool "ST SPEAr13xx"
 	depends on ARCH_MULTI_V7 || PLAT_SPEAR_SINGLE
-	select ARCH_HAS_CPUFREQ
 	select ARM_GIC
 	select GPIO_SPEAR_SPICS
 	select HAVE_ARM_SCU if SMP
diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index e16999e5b735..8981ed49787d 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -1,6 +1,5 @@
 config ARCH_TEGRA
 	bool "NVIDIA Tegra" if ARCH_MULTI_V7
-	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_SUPPORTS_TRUSTED_FOUNDATIONS
 	select ARM_GIC
diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index b41a42da1505..9b93144c1c2b 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -3,7 +3,6 @@ config ARCH_U8500
 	depends on MMU
 	select AB8500_CORE
 	select ABX500_CORE
-	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select ARM_AMBA
 	select ARM_ERRATA_754322
diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
index 90249cfc37b3..2e2e8bbb88d7 100644
--- a/arch/arm/mach-vexpress/Kconfig
+++ b/arch/arm/mach-vexpress/Kconfig
@@ -65,7 +65,6 @@ config ARCH_VEXPRESS_DCSCB
 
 config ARCH_VEXPRESS_SPC
 	bool "Versatile Express Serial Power Controller (SPC)"
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
 	select PM_OPP
 	help
diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index 08f56a41cb55..aaaa24fe4d71 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -1,6 +1,5 @@
 config ARCH_VT8500
 	bool
-	select ARCH_HAS_CPUFREQ
 	select ARCH_REQUIRE_GPIOLIB
 	select CLKDEV_LOOKUP
 	select VT8500_TIMER
diff --git a/arch/arm/mach-zynq/Kconfig b/arch/arm/mach-zynq/Kconfig
index 573e0db1d0f0..0c164f81e72d 100644
--- a/arch/arm/mach-zynq/Kconfig
+++ b/arch/arm/mach-zynq/Kconfig
@@ -1,6 +1,5 @@
 config ARCH_ZYNQ
 	bool "Xilinx Zynq ARM Cortex A9 Platform" if ARCH_MULTI_V7
-	select ARCH_HAS_CPUFREQ
 	select ARCH_HAS_OPP
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

