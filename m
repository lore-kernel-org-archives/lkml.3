Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720Ab3DDM4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:56:03 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45095 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864Ab3DDMz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:55:59 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 06/18] cpufreq: integrator: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:14 +0530
Message-Id: <062b894f52bcf748d2a5ba82e98319b9734356a9.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of ARM based integrator platform to
drivers/cpufreq.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/Kconfig                                              | 11 -----------
 arch/arm/mach-integrator/Makefile                             |  1 -
 drivers/cpufreq/Kconfig.arm                                   |  8 ++++++++
 drivers/cpufreq/Makefile                                      |  1 +
 .../cpu.c => drivers/cpufreq/integrator-cpufreq.c             |  2 --
 5 files changed, 9 insertions(+), 14 deletions(-)
 rename arch/arm/mach-integrator/cpu.c => drivers/cpufreq/integrator-cpufreq.c (99%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 76eb836..c3563f6 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2166,17 +2166,6 @@ config CPU_FREQ_SA1100
 config CPU_FREQ_SA1110
 	bool
 
-config CPU_FREQ_INTEGRATOR
-	tristate "CPUfreq driver for ARM Integrator CPUs"
-	depends on ARCH_INTEGRATOR && CPU_FREQ
-	default y
-	help
-	  This enables the CPUfreq driver for ARM Integrator CPUs.
-
-	  For details, take a look at <file:Documentation/cpu-freq>.
-
-	  If in doubt, say Y.
-
 config CPU_FREQ_S3C
 	bool
 	help
diff --git a/arch/arm/mach-integrator/Makefile b/arch/arm/mach-integrator/Makefile
index 5521d18..d14d6b7 100644
--- a/arch/arm/mach-integrator/Makefile
+++ b/arch/arm/mach-integrator/Makefile
@@ -9,5 +9,4 @@ obj-$(CONFIG_ARCH_INTEGRATOR_AP)	+= integrator_ap.o
 obj-$(CONFIG_ARCH_INTEGRATOR_CP)	+= integrator_cp.o
 
 obj-$(CONFIG_PCI)			+= pci_v3.o pci.o
-obj-$(CONFIG_CPU_FREQ_INTEGRATOR)	+= cpu.o
 obj-$(CONFIG_INTEGRATOR_IMPD1)		+= impd1.o
diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 25d866a..97f208d 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -66,6 +66,14 @@ config ARM_IMX6Q_CPUFREQ
 
 	  If in doubt, say N.
 
+config ARM_INTEGRATOR
+	tristate "CPUfreq driver for ARM Integrator CPUs"
+	depends on ARCH_INTEGRATOR
+	default y
+	help
+	  This enables the CPUfreq driver for ARM Integrator CPUs.
+	  If in doubt, say Y.
+
 config ARM_KIRKWOOD_CPUFREQ
 	def_bool ARCH_KIRKWOOD && OF
 	help
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index aa766fb..8d58016 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_ARM_EXYNOS4X12_CPUFREQ)	+= exynos4x12-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS5250_CPUFREQ)	+= exynos5250-cpufreq.o
 obj-$(CONFIG_ARM_HIGHBANK_CPUFREQ)	+= highbank-cpufreq.o
 obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
+obj-$(CONFIG_ARM_INTEGRATOR)		+= integrator-cpufreq.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUFREQ)	+= kirkwood-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)	+= omap-cpufreq.o
 obj-$(CONFIG_PXA25x)			+= pxa2xx-cpufreq.o
diff --git a/arch/arm/mach-integrator/cpu.c b/drivers/cpufreq/integrator-cpufreq.c
similarity index 99%
rename from arch/arm/mach-integrator/cpu.c
rename to drivers/cpufreq/integrator-cpufreq.c
index df863c3..f7c99df 100644
--- a/arch/arm/mach-integrator/cpu.c
+++ b/drivers/cpufreq/integrator-cpufreq.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/arm/mach-integrator/cpu.c
- *
  *  Copyright (C) 2001-2002 Deep Blue Solutions Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
-- 
1.7.12.rc2.18.g61b472e

