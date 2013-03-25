Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab3CYKME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:12:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49072 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab3CYKL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:11:59 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/9] cpufreq: ARM: Arrange drivers in alphabetical order
Date: Mon, 25 Mar 2013 15:41:32 +0530
Message-Id: <e7b8875eff197c3baef8dd474ff167f9a27ccdc6.1364205812.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Mar 2013 10:11:55.0360 (UTC) FILETIME=[2D849600:01CE2941]
X-MC-Unique: 113032510115713701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PAFagG026841

Normally we keep drivers in alphabetical inside Kconfig and Makefile and over
time this was broken for ARM cpufreq drivers. Fix it.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/Kconfig.arm | 116 ++++++++++++++++++++++----------------------
 drivers/cpufreq/Makefile    |  10 ++--
 2 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 030ddf6..b72a2b3 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -2,6 +2,64 @@
 # ARM CPU Frequency scaling drivers
 #
 
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
@@ -49,67 +107,9 @@ config ARM_S5PV210_CPUFREQ
 
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
index 863fd18..e33a30e 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -45,18 +45,18 @@ obj-$(CONFIG_X86_INTEL_PSTATE)		+= intel_pstate.o
 ##################################################################################
 # ARM SoC drivers
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


