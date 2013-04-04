Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760562Ab3DDMzY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:55:24 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64184 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760402Ab3DDMzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:55:18 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 01/18] cpufreq: ARM: Arrange drivers in alphabetical order
Date: Thu,  4 Apr 2013 18:24:09 +0530
Message-Id: <216bbdfc94c40cb1b4e0dd6544ad27001de1c519.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally we keep drivers in alphabetical inside Kconfig and Makefile and over
time this was broken for ARM cpufreq drivers. Fix it.

Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/cpufreq/Kconfig.arm | 116 ++++++++++++++++++++++----------------------
 drivers/cpufreq/Makefile    |  10 ++--
 2 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 87b7e48..25d866a 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -14,6 +14,64 @@ config ARM_DT_BL_CPUFREQ
 	  This enables the Generic CPUfreq driver for ARM big.LITTLE platform.
 	  This gets frequency tables from DT.
 
+config ARM_EXYNOS_CPUFREQ
+	bool "SAMSUNG EXYNOS SoCs"
+	depends on ARCH_EXYNOS
+	default y
+	help
+	  This adds the CPUFreq driver common part for Samsung
+	  EXYNOS SoCs.
+
+	  If in doubt, say N.
+
+config ARM_EXYNOS4210_CPUFREQ
+	def_bool CPU_EXYNOS4210
+	help
+	  This adds the CPUFreq driver for Samsung EXYNOS4210
+	  SoC (S5PV310 or S5PC210).
+
+config ARM_EXYNOS4X12_CPUFREQ
+	def_bool (SOC_EXYNOS4212 || SOC_EXYNOS4412)
+	help
+	  This adds the CPUFreq driver for Samsung EXYNOS4X12
+	  SoC (EXYNOS4212 or EXYNOS4412).
+
+config ARM_EXYNOS5250_CPUFREQ
+	def_bool SOC_EXYNOS5250
+	help
+	  This adds the CPUFreq driver for Samsung EXYNOS5250
+	  SoC.
+
+config ARM_HIGHBANK_CPUFREQ
+	tristate "Calxeda Highbank-based"
+	depends on ARCH_HIGHBANK
+	select CPU_FREQ_TABLE
+	select GENERIC_CPUFREQ_CPU0
+	select PM_OPP
+	select REGULATOR
+
+	default m
+	help
+	  This adds the CPUFreq driver for Calxeda Highbank SoC
+	  based boards.
+
+	  If in doubt, say N.
+
+config ARM_IMX6Q_CPUFREQ
+	tristate "Freescale i.MX6Q cpufreq support"
+	depends on SOC_IMX6Q
+	depends on REGULATOR_ANATOP
+	help
+	  This adds cpufreq driver support for Freescale i.MX6Q SOC.
+
+	  If in doubt, say N.
+
+config ARM_KIRKWOOD_CPUFREQ
+	def_bool ARCH_KIRKWOOD && OF
+	help
+	  This adds the CPUFreq driver for Marvell Kirkwood
+	  SoCs.
+
 config ARM_OMAP2PLUS_CPUFREQ
 	bool "TI OMAP2+"
 	depends on ARCH_OMAP2PLUS
@@ -61,67 +119,9 @@ config ARM_S5PV210_CPUFREQ
 
 	  If in doubt, say N.
 
-config ARM_EXYNOS_CPUFREQ
-	bool "SAMSUNG EXYNOS SoCs"
-	depends on ARCH_EXYNOS
-	default y
-	help
-	  This adds the CPUFreq driver common part for Samsung
-	  EXYNOS SoCs.
-
-	  If in doubt, say N.
-
-config ARM_EXYNOS4210_CPUFREQ
-	def_bool CPU_EXYNOS4210
-	help
-	  This adds the CPUFreq driver for Samsung EXYNOS4210
-	  SoC (S5PV310 or S5PC210).
-
-config ARM_EXYNOS4X12_CPUFREQ
-	def_bool (SOC_EXYNOS4212 || SOC_EXYNOS4412)
-	help
-	  This adds the CPUFreq driver for Samsung EXYNOS4X12
-	  SoC (EXYNOS4212 or EXYNOS4412).
-
-config ARM_EXYNOS5250_CPUFREQ
-	def_bool SOC_EXYNOS5250
-	help
-	  This adds the CPUFreq driver for Samsung EXYNOS5250
-	  SoC.
-
-config ARM_KIRKWOOD_CPUFREQ
-	def_bool ARCH_KIRKWOOD && OF
-	help
-	  This adds the CPUFreq driver for Marvell Kirkwood
-	  SoCs.
-
-config ARM_IMX6Q_CPUFREQ
-	tristate "Freescale i.MX6Q cpufreq support"
-	depends on SOC_IMX6Q
-	depends on REGULATOR_ANATOP
-	help
-	  This adds cpufreq driver support for Freescale i.MX6Q SOC.
-
-	  If in doubt, say N.
-
 config ARM_SPEAR_CPUFREQ
 	bool "SPEAr CPUFreq support"
 	depends on PLAT_SPEAR
 	default y
 	help
 	  This adds the CPUFreq driver support for SPEAr SOCs.
-
-config ARM_HIGHBANK_CPUFREQ
-	tristate "Calxeda Highbank-based"
-	depends on ARCH_HIGHBANK
-	select CPU_FREQ_TABLE
-	select GENERIC_CPUFREQ_CPU0
-	select PM_OPP
-	select REGULATOR
-
-	default m
-	help
-	  This adds the CPUFreq driver for Calxeda Highbank SoC
-	  based boards.
-
-	  If in doubt, say N.
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index ba9a3e1..2c25504 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -50,18 +50,18 @@ obj-$(CONFIG_ARM_BIG_LITTLE_CPUFREQ)	+= arm_big_little.o
 obj-$(CONFIG_ARM_DT_BL_CPUFREQ)		+= arm_big_little_dt.o
 
 obj-$(CONFIG_UX500_SOC_DB8500)		+= dbx500-cpufreq.o
-obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
-obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c64xx-cpufreq.o
-obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS_CPUFREQ)	+= exynos-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4X12_CPUFREQ)	+= exynos4x12-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS5250_CPUFREQ)	+= exynos5250-cpufreq.o
+obj-$(CONFIG_ARM_HIGHBANK_CPUFREQ)	+= highbank-cpufreq.o
+obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUFREQ)	+= kirkwood-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)	+= omap-cpufreq.o
+obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
+obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c64xx-cpufreq.o
+obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
-obj-$(CONFIG_ARM_HIGHBANK_CPUFREQ)	+= highbank-cpufreq.o
-obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
 
 ##################################################################################
 # PowerPC platform drivers
-- 
1.7.12.rc2.18.g61b472e

