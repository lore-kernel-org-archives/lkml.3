Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3CYKOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:14:40 -0400
Received: from service87.mimecast.com ([91.220.42.44]:54189 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab3CYKMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:12:05 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5/9] cpufreq: integrator: move cpufreq driver to drivers/cpufreq
Date: Mon, 25 Mar 2013 15:41:36 +0530
Message-Id: <fae1030e861c5dfd00df8f03526b0bdc5156de4d.1364205812.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Mar 2013 10:12:02.0016 (UTC) FILETIME=[317C3600:01CE2941]
X-MC-Unique: 113032510120327201
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PAEfj8026829

This patch moves cpufreq driver of ARM based integrator platform to
drivers/cpufreq.

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/Kconfig                                              | 11 -----------
 arch/arm/mach-integrator/Makefile                             |  1 -
 drivers/cpufreq/Kconfig.arm                                   |  8 ++++++++
 drivers/cpufreq/Makefile                                      |  1 +
 .../cpu.c => drivers/cpufreq/integrator-cpufreq.c             |  2 --
 5 files changed, 9 insertions(+), 14 deletions(-)
 rename arch/arm/mach-integrator/cpu.c => drivers/cpufreq/integrator-cpufreq.c (99%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 0295a08..fbb9587 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2162,17 +2162,6 @@ config CPU_FREQ_SA1100
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
 config CPU_FREQ_PXA
 	bool
 	depends on CPU_FREQ && ARCH_PXA && PXA25x
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
index 3d83bc5..a345e20 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -61,6 +61,14 @@ config ARM_IMX6Q_CPUFREQ
 
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
index 2759192..170f01a 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_ARM_EXYNOS5250_CPUFREQ)	+= exynos5250-cpufreq.o
 obj-$(CONFIG_ARM_HIGHBANK_CPUFREQ)	+= highbank-cpufreq.o
 obj-$(CONFIG_ARM_IMX_CPUFREQ)		+= imx-cpufreq.o
 obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
+obj-$(CONFIG_ARM_INTEGRATOR)		+= integrator-cpufreq.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUFREQ)	+= kirkwood-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)	+= omap-cpufreq.o
 obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
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


