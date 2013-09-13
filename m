Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab3IMNSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:18:18 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49841 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933479Ab3IMNSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:18:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 128/228] cpufreq: remove CONFIG_CPU_FREQ_TABLE
Date: Fri, 13 Sep 2013 18:31:14 +0530
Message-Id: <c18dd0d709be136b97e128676e080d94f1e6f582.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_CPU_FREQ_TABLE will be always enabled when cpufreq framework is used, as
cpufreq core depends on it. So, we don't need this CONFIG option anymore as it
is not configurable. Remove CONFIG_CPU_FREQ_TABLE and update its users.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-davinci/Kconfig   |  1 -
 arch/arm/mach-pxa/Kconfig       |  3 ---
 arch/arm/mach-ux500/Kconfig     |  1 -
 arch/blackfin/Kconfig           |  1 -
 arch/cris/Kconfig               |  2 --
 drivers/cpufreq/Kconfig         | 12 ------------
 drivers/cpufreq/Kconfig.arm     | 11 -----------
 drivers/cpufreq/Kconfig.powerpc |  6 ------
 drivers/cpufreq/Kconfig.x86     | 13 -------------
 drivers/cpufreq/Makefile        |  5 +----
 drivers/cpufreq/cpufreq.c       |  2 --
 drivers/thermal/Kconfig         |  1 -
 12 files changed, 1 insertion(+), 57 deletions(-)

diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
index e026b19..a075b3e 100644
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -40,7 +40,6 @@ config ARCH_DAVINCI_DA850
 	bool "DA850/OMAP-L138/AM18x based system"
 	select ARCH_DAVINCI_DA8XX
 	select ARCH_HAS_CPUFREQ
-	select CPU_FREQ_TABLE
 	select CP_INTC
 
 config ARCH_DAVINCI_DA8XX
diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
index a842711..96100db 100644
--- a/arch/arm/mach-pxa/Kconfig
+++ b/arch/arm/mach-pxa/Kconfig
@@ -615,14 +615,12 @@ endmenu
 config PXA25x
 	bool
 	select CPU_XSCALE
-	select CPU_FREQ_TABLE if CPU_FREQ
 	help
 	  Select code specific to PXA21x/25x/26x variants
 
 config PXA27x
 	bool
 	select CPU_XSCALE
-	select CPU_FREQ_TABLE if CPU_FREQ
 	help
 	  Select code specific to PXA27x variants
 
@@ -635,7 +633,6 @@ config CPU_PXA26x
 config PXA3xx
 	bool
 	select CPU_XSC3
-	select CPU_FREQ_TABLE if CPU_FREQ
 	help
 	  Select code specific to PXA3xx variants
 
diff --git a/arch/arm/mach-ux500/Kconfig b/arch/arm/mach-ux500/Kconfig
index b19b072..e6eaefa 100644
--- a/arch/arm/mach-ux500/Kconfig
+++ b/arch/arm/mach-ux500/Kconfig
@@ -34,7 +34,6 @@ config UX500_SOC_COMMON
 
 config UX500_SOC_DB8500
 	bool
-	select CPU_FREQ_TABLE if CPU_FREQ
 	select MFD_DB8500_PRCMU
 	select PINCTRL_DB8500
 	select PINCTRL_DB8540
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 3b6abc5..1ac474a 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -1430,7 +1430,6 @@ source "drivers/cpufreq/Kconfig"
 config BFIN_CPU_FREQ
 	bool
 	depends on CPU_FREQ
-	select CPU_FREQ_TABLE
 	default y
 
 config CPU_VOLTAGE
diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 3201ddb..9f3c5436 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -134,13 +134,11 @@ config SVINTO_SIM
 
 config ETRAXFS
 	bool "ETRAX-FS-V32"
-	select CPU_FREQ_TABLE if CPU_FREQ
 	help
 	  Support CRIS V32.
 
 config CRIS_MACH_ARTPEC3
         bool "ARTPEC-3"
-	select CPU_FREQ_TABLE if CPU_FREQ
         help
           Support Axis ARTPEC-3.
 
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 2d06754..38093e2 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -2,7 +2,6 @@ menu "CPU Frequency scaling"
 
 config CPU_FREQ
 	bool "CPU Frequency scaling"
-	select CPU_FREQ_TABLE
 	help
 	  CPU Frequency scaling allows you to change the clock speed of 
 	  CPUs on the fly. This is a nice method to save power, because 
@@ -18,15 +17,11 @@ config CPU_FREQ
 
 if CPU_FREQ
 
-config CPU_FREQ_TABLE
-	tristate
-
 config CPU_FREQ_GOV_COMMON
 	bool
 
 config CPU_FREQ_STAT
 	tristate "CPU frequency translation statistics"
-	select CPU_FREQ_TABLE
 	default y
 	help
 	  This driver exports CPU frequency statistics information through sysfs
@@ -144,7 +139,6 @@ config CPU_FREQ_GOV_USERSPACE
 
 config CPU_FREQ_GOV_ONDEMAND
 	tristate "'ondemand' cpufreq policy governor"
-	select CPU_FREQ_TABLE
 	select CPU_FREQ_GOV_COMMON
 	help
 	  'ondemand' - This driver adds a dynamic cpufreq policy governor.
@@ -188,7 +182,6 @@ config CPU_FREQ_GOV_CONSERVATIVE
 config GENERIC_CPUFREQ_CPU0
 	tristate "Generic CPU0 cpufreq driver"
 	depends on HAVE_CLK && REGULATOR && PM_OPP && OF
-	select CPU_FREQ_TABLE
 	help
 	  This adds a generic cpufreq driver for CPU0 frequency management.
 	  It supports both uniprocessor (UP) and symmetric multiprocessor (SMP)
@@ -224,7 +217,6 @@ depends on IA64
 
 config IA64_ACPI_CPUFREQ
 	tristate "ACPI Processor P-States driver"
-	select CPU_FREQ_TABLE
 	depends on ACPI_PROCESSOR
 	help
 	This driver adds a CPUFreq driver which utilizes the ACPI
@@ -241,7 +233,6 @@ depends on MIPS
 
 config LOONGSON2_CPUFREQ
 	tristate "Loongson2 CPUFreq Driver"
-	select CPU_FREQ_TABLE
 	help
 	  This option adds a CPUFreq driver for loongson processors which
 	  support software configurable cpu frequency.
@@ -263,7 +254,6 @@ menu "SPARC CPU frequency scaling drivers"
 depends on SPARC64
 config SPARC_US3_CPUFREQ
 	tristate "UltraSPARC-III CPU Frequency driver"
-	select CPU_FREQ_TABLE
 	help
 	  This adds the CPUFreq driver for UltraSPARC-III processors.
 
@@ -273,7 +263,6 @@ config SPARC_US3_CPUFREQ
 
 config SPARC_US2E_CPUFREQ
 	tristate "UltraSPARC-IIe CPU Frequency driver"
-	select CPU_FREQ_TABLE
 	help
 	  This adds the CPUFreq driver for UltraSPARC-IIe processors.
 
@@ -286,7 +275,6 @@ menu "SH CPU Frequency scaling"
 depends on SUPERH
 config SH_CPU_FREQ
 	tristate "SuperH CPU Frequency driver"
-	select CPU_FREQ_TABLE
 	help
 	  This adds the cpufreq driver for SuperH. Any CPU that supports
 	  clock rate rounding through the clock framework can use this
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 0fa204b..701ec95 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -5,7 +5,6 @@
 config ARM_BIG_LITTLE_CPUFREQ
 	tristate "Generic ARM big LITTLE CPUfreq driver"
 	depends on ARM_CPU_TOPOLOGY && PM_OPP && HAVE_CLK
-	select CPU_FREQ_TABLE
 	help
 	  This enables the Generic CPUfreq driver for ARM big.LITTLE platforms.
 
@@ -18,7 +17,6 @@ config ARM_DT_BL_CPUFREQ
 
 config ARM_EXYNOS_CPUFREQ
 	bool
-	select CPU_FREQ_TABLE
 
 config ARM_EXYNOS4210_CPUFREQ
 	bool "SAMSUNG EXYNOS4210"
@@ -58,7 +56,6 @@ config ARM_EXYNOS5440_CPUFREQ
 	depends on SOC_EXYNOS5440
 	depends on HAVE_CLK && PM_OPP && OF
 	default y
-	select CPU_FREQ_TABLE
 	help
 	  This adds the CPUFreq driver for Samsung EXYNOS5440
 	  SoC. The nature of exynos5440 clock controller is
@@ -85,7 +82,6 @@ config ARM_IMX6Q_CPUFREQ
 	tristate "Freescale i.MX6Q cpufreq support"
 	depends on SOC_IMX6Q
 	depends on REGULATOR_ANATOP
-	select CPU_FREQ_TABLE
 	help
 	  This adds cpufreq driver support for Freescale i.MX6Q SOC.
 
@@ -101,7 +97,6 @@ config ARM_INTEGRATOR
 
 config ARM_KIRKWOOD_CPUFREQ
 	def_bool ARCH_KIRKWOOD && OF
-	select CPU_FREQ_TABLE
 	help
 	  This adds the CPUFreq driver for Marvell Kirkwood
 	  SoCs.
@@ -110,7 +105,6 @@ config ARM_OMAP2PLUS_CPUFREQ
 	bool "TI OMAP2+"
 	depends on ARCH_OMAP2PLUS
 	default ARCH_OMAP2PLUS
-	select CPU_FREQ_TABLE
 
 config ARM_S3C_CPUFREQ
 	bool
@@ -165,7 +159,6 @@ config ARM_S3C2412_CPUFREQ
 config ARM_S3C2416_CPUFREQ
 	bool "S3C2416 CPU Frequency scaling support"
 	depends on CPU_S3C2416
-	select CPU_FREQ_TABLE
 	help
 	  This adds the CPUFreq driver for the Samsung S3C2416 and
 	  S3C2450 SoC. The S3C2416 supports changing the rate of the
@@ -196,7 +189,6 @@ config ARM_S3C2440_CPUFREQ
 config ARM_S3C64XX_CPUFREQ
 	bool "Samsung S3C64XX"
 	depends on CPU_S3C6410
-	select CPU_FREQ_TABLE
 	default y
 	help
 	  This adds the CPUFreq driver for Samsung S3C6410 SoC.
@@ -206,7 +198,6 @@ config ARM_S3C64XX_CPUFREQ
 config ARM_S5PV210_CPUFREQ
 	bool "Samsung S5PV210 and S5PC110"
 	depends on CPU_S5PV210
-	select CPU_FREQ_TABLE
 	default y
 	help
 	  This adds the CPUFreq driver for Samsung S5PV210 and
@@ -223,7 +214,6 @@ config ARM_SA1110_CPUFREQ
 config ARM_SPEAR_CPUFREQ
 	bool "SPEAr CPUFreq support"
 	depends on PLAT_SPEAR
-	select CPU_FREQ_TABLE
 	default y
 	help
 	  This adds the CPUFreq driver support for SPEAr SOCs.
@@ -231,7 +221,6 @@ config ARM_SPEAR_CPUFREQ
 config ARM_TEGRA_CPUFREQ
 	bool "TEGRA CPUFreq support"
 	depends on ARCH_TEGRA
-	select CPU_FREQ_TABLE
 	default y
 	help
 	  This adds the CPUFreq driver support for TEGRA SOCs.
diff --git a/drivers/cpufreq/Kconfig.powerpc b/drivers/cpufreq/Kconfig.powerpc
index 25ca9db..ca0021a 100644
--- a/drivers/cpufreq/Kconfig.powerpc
+++ b/drivers/cpufreq/Kconfig.powerpc
@@ -1,7 +1,6 @@
 config CPU_FREQ_CBE
 	tristate "CBE frequency scaling"
 	depends on CBE_RAS && PPC_CELL
-	select CPU_FREQ_TABLE
 	default m
 	help
 	  This adds the cpufreq driver for Cell BE processors.
@@ -20,7 +19,6 @@ config CPU_FREQ_CBE_PMI
 config CPU_FREQ_MAPLE
 	bool "Support for Maple 970FX Evaluation Board"
 	depends on PPC_MAPLE
-	select CPU_FREQ_TABLE
 	help
 	  This adds support for frequency switching on Maple 970FX
 	  Evaluation Board and compatible boards (IBM JS2x blades).
@@ -28,7 +26,6 @@ config CPU_FREQ_MAPLE
 config PPC_CORENET_CPUFREQ
 	tristate "CPU frequency scaling driver for Freescale E500MC SoCs"
 	depends on PPC_E500MC && OF && COMMON_CLK
-	select CPU_FREQ_TABLE
 	select CLK_PPC_CORENET
 	help
 	  This adds the CPUFreq driver support for Freescale e500mc,
@@ -38,7 +35,6 @@ config PPC_CORENET_CPUFREQ
 config CPU_FREQ_PMAC
 	bool "Support for Apple PowerBooks"
 	depends on ADB_PMU && PPC32
-	select CPU_FREQ_TABLE
 	help
 	  This adds support for frequency switching on Apple PowerBooks,
 	  this currently includes some models of iBook & Titanium
@@ -47,7 +43,6 @@ config CPU_FREQ_PMAC
 config CPU_FREQ_PMAC64
 	bool "Support for some Apple G5s"
 	depends on PPC_PMAC && PPC64
-	select CPU_FREQ_TABLE
 	help
 	  This adds support for frequency switching on Apple iMac G5,
 	  and some of the more recent desktop G5 machines as well.
@@ -55,7 +50,6 @@ config CPU_FREQ_PMAC64
 config PPC_PASEMI_CPUFREQ
 	bool "Support for PA Semi PWRficient"
 	depends on PPC_PASEMI
-	select CPU_FREQ_TABLE
 	default y
 	help
 	  This adds the support for frequency switching on PA Semi
diff --git a/drivers/cpufreq/Kconfig.x86 b/drivers/cpufreq/Kconfig.x86
index e2b6eab..6897ad8 100644
--- a/drivers/cpufreq/Kconfig.x86
+++ b/drivers/cpufreq/Kconfig.x86
@@ -31,7 +31,6 @@ config X86_PCC_CPUFREQ
 
 config X86_ACPI_CPUFREQ
 	tristate "ACPI Processor P-States driver"
-	select CPU_FREQ_TABLE
 	depends on ACPI_PROCESSOR
 	help
 	  This driver adds a CPUFreq driver which utilizes the ACPI
@@ -60,7 +59,6 @@ config X86_ACPI_CPUFREQ_CPB
 
 config ELAN_CPUFREQ
 	tristate "AMD Elan SC400 and SC410"
-	select CPU_FREQ_TABLE
 	depends on MELAN
 	---help---
 	  This adds the CPUFreq driver for AMD Elan SC400 and SC410
@@ -76,7 +74,6 @@ config ELAN_CPUFREQ
 
 config SC520_CPUFREQ
 	tristate "AMD Elan SC520"
-	select CPU_FREQ_TABLE
 	depends on MELAN
 	---help---
 	  This adds the CPUFreq driver for AMD Elan SC520 processor.
@@ -88,7 +85,6 @@ config SC520_CPUFREQ
 
 config X86_POWERNOW_K6
 	tristate "AMD Mobile K6-2/K6-3 PowerNow!"
-	select CPU_FREQ_TABLE
 	depends on X86_32
 	help
 	  This adds the CPUFreq driver for mobile AMD K6-2+ and mobile
@@ -100,7 +96,6 @@ config X86_POWERNOW_K6
 
 config X86_POWERNOW_K7
 	tristate "AMD Mobile Athlon/Duron PowerNow!"
-	select CPU_FREQ_TABLE
 	depends on X86_32
 	help
 	  This adds the CPUFreq driver for mobile AMD K7 mobile processors.
@@ -118,7 +113,6 @@ config X86_POWERNOW_K7_ACPI
 
 config X86_POWERNOW_K8
 	tristate "AMD Opteron/Athlon64 PowerNow!"
-	select CPU_FREQ_TABLE
 	depends on ACPI && ACPI_PROCESSOR && X86_ACPI_CPUFREQ
 	help
 	  This adds the CPUFreq driver for K8/early Opteron/Athlon64 processors.
@@ -132,7 +126,6 @@ config X86_POWERNOW_K8
 config X86_AMD_FREQ_SENSITIVITY
 	tristate "AMD frequency sensitivity feedback powersave bias"
 	depends on CPU_FREQ_GOV_ONDEMAND && X86_ACPI_CPUFREQ && CPU_SUP_AMD
-	select CPU_FREQ_TABLE
 	help
 	  This adds AMD-specific powersave bias function to the ondemand
 	  governor, which allows it to make more power-conscious frequency
@@ -160,7 +153,6 @@ config X86_GX_SUSPMOD
 
 config X86_SPEEDSTEP_CENTRINO
 	tristate "Intel Enhanced SpeedStep (deprecated)"
-	select CPU_FREQ_TABLE
 	select X86_SPEEDSTEP_CENTRINO_TABLE if X86_32
 	depends on X86_32 || (X86_64 && ACPI_PROCESSOR)
 	help
@@ -190,7 +182,6 @@ config X86_SPEEDSTEP_CENTRINO_TABLE
 
 config X86_SPEEDSTEP_ICH
 	tristate "Intel Speedstep on ICH-M chipsets (ioport interface)"
-	select CPU_FREQ_TABLE
 	depends on X86_32
 	help
 	  This adds the CPUFreq driver for certain mobile Intel Pentium III
@@ -204,7 +195,6 @@ config X86_SPEEDSTEP_ICH
 
 config X86_SPEEDSTEP_SMI
 	tristate "Intel SpeedStep on 440BX/ZX/MX chipsets (SMI interface)"
-	select CPU_FREQ_TABLE
 	depends on X86_32
 	help
 	  This adds the CPUFreq driver for certain mobile Intel Pentium III
@@ -217,7 +207,6 @@ config X86_SPEEDSTEP_SMI
 
 config X86_P4_CLOCKMOD
 	tristate "Intel Pentium 4 clock modulation"
-	select CPU_FREQ_TABLE
 	help
 	  This adds the CPUFreq driver for Intel Pentium 4 / XEON
 	  processors.  When enabled it will lower CPU temperature by skipping
@@ -259,7 +248,6 @@ config X86_LONGRUN
 
 config X86_LONGHAUL
 	tristate "VIA Cyrix III Longhaul"
-	select CPU_FREQ_TABLE
 	depends on X86_32 && ACPI_PROCESSOR
 	help
 	  This adds the CPUFreq driver for VIA Samuel/CyrixIII,
@@ -272,7 +260,6 @@ config X86_LONGHAUL
 
 config X86_E_POWERSAVER
 	tristate "VIA C7 Enhanced PowerSaver (DANGEROUS)"
-	select CPU_FREQ_TABLE
 	depends on X86_32 && ACPI_PROCESSOR
 	help
 	  This adds the CPUFreq driver for VIA C7 processors.  However, this driver
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index ad5866c..b7948bb 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -1,5 +1,5 @@
 # CPUfreq core
-obj-$(CONFIG_CPU_FREQ)			+= cpufreq.o
+obj-$(CONFIG_CPU_FREQ)			+= cpufreq.o freq_table.o
 # CPUfreq stats
 obj-$(CONFIG_CPU_FREQ_STAT)             += cpufreq_stats.o
 
@@ -11,9 +11,6 @@ obj-$(CONFIG_CPU_FREQ_GOV_ONDEMAND)	+= cpufreq_ondemand.o
 obj-$(CONFIG_CPU_FREQ_GOV_CONSERVATIVE)	+= cpufreq_conservative.o
 obj-$(CONFIG_CPU_FREQ_GOV_COMMON)		+= cpufreq_governor.o
 
-# CPUfreq cross-arch helpers
-obj-$(CONFIG_CPU_FREQ_TABLE)		+= freq_table.o
-
 obj-$(CONFIG_GENERIC_CPUFREQ_CPU0)	+= cpufreq-cpu0.o
 
 ##################################################################################
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c4d89c5..5295694 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1025,9 +1025,7 @@ static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 	policy->last_cpu = policy->cpu;
 	policy->cpu = cpu;
 
-#ifdef CONFIG_CPU_FREQ_TABLE
 	cpufreq_frequency_table_update_policy_cpu(policy);
-#endif
 	blocking_notifier_call_chain(&cpufreq_policy_notifier_list,
 			CPUFREQ_UPDATE_POLICY_CPU, policy);
 }
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index e988c81..6a5b948 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -69,7 +69,6 @@ config THERMAL_GOV_USER_SPACE
 config CPU_THERMAL
 	bool "generic cpu cooling support"
 	depends on CPU_FREQ
-	select CPU_FREQ_TABLE
 	help
 	  This implements the generic cpu cooling mechanism through frequency
 	  reduction. An ACPI version of this already exists
-- 
1.7.12.rc2.18.g61b472e

