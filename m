Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760699Ab3DDMzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:55:53 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:64485 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758864Ab3DDMzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:55:51 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 05/18] cpufreq: pxa2xx: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:13 +0530
Message-Id: <41cb34556b2cb26923842fcaf38990f46dfbd7f1.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of ARM based pxa2xx platform to drivers/cpufreq.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig                                                   | 7 -------
 arch/arm/mach-pxa/Makefile                                         | 5 -----
 drivers/cpufreq/Makefile                                           | 2 ++
 .../mach-pxa/cpufreq-pxa2xx.c => drivers/cpufreq/pxa2xx-cpufreq.c  | 2 --
 4 files changed, 2 insertions(+), 14 deletions(-)
 rename arch/arm/mach-pxa/cpufreq-pxa2xx.c => drivers/cpufreq/pxa2xx-cpufreq.c (99%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 13b7394..76eb836 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2177,13 +2177,6 @@ config CPU_FREQ_INTEGRATOR
 
 	  If in doubt, say Y.
 
-config CPU_FREQ_PXA
-	bool
-	depends on CPU_FREQ && ARCH_PXA && PXA25x
-	default y
-	select CPU_FREQ_DEFAULT_GOV_USERSPACE
-	select CPU_FREQ_TABLE
-
 config CPU_FREQ_S3C
 	bool
 	help
diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 929e700..648867a 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -7,11 +7,6 @@ obj-y				+= clock.o devices.o generic.o irq.o \
 				   time.o reset.o
 obj-$(CONFIG_PM)		+= pm.o sleep.o standby.o
 
-ifeq ($(CONFIG_CPU_FREQ),y)
-obj-$(CONFIG_PXA25x)		+= cpufreq-pxa2xx.o
-obj-$(CONFIG_PXA27x)		+= cpufreq-pxa2xx.o
-endif
-
 # Generic drivers that other drivers may depend upon
 
 # SoC-specific code
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 3458bf2..aa766fb 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -59,6 +59,8 @@ obj-$(CONFIG_ARM_HIGHBANK_CPUFREQ)	+= highbank-cpufreq.o
 obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUFREQ)	+= kirkwood-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)	+= omap-cpufreq.o
+obj-$(CONFIG_PXA25x)			+= pxa2xx-cpufreq.o
+obj-$(CONFIG_PXA27x)			+= pxa2xx-cpufreq.o
 obj-$(CONFIG_PXA3xx)			+= pxa3xx-cpufreq.o
 obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
 obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c64xx-cpufreq.o
diff --git a/arch/arm/mach-pxa/cpufreq-pxa2xx.c b/drivers/cpufreq/pxa2xx-cpufreq.c
similarity index 99%
rename from arch/arm/mach-pxa/cpufreq-pxa2xx.c
rename to drivers/cpufreq/pxa2xx-cpufreq.c
index f1ca4da..fe4c55b 100644
--- a/arch/arm/mach-pxa/cpufreq-pxa2xx.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -1,6 +1,4 @@
 /*
- *  linux/arch/arm/mach-pxa/cpufreq-pxa2xx.c
- *
  *  Copyright (C) 2002,2003 Intrinsyc Software
  *
  * This program is free software; you can redistribute it and/or modify
-- 
1.7.12.rc2.18.g61b472e

