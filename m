Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893Ab3CYKNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:13:04 -0400
Received: from service87.mimecast.com ([91.220.42.44]:56116 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab3CYKMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:12:08 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 7/9] cpufreq: pxa2xx: move cpufreq driver to drivers/cpufreq
Date: Mon, 25 Mar 2013 15:41:38 +0530
Message-Id: <e4abaad7218d2a27f4f35131667868b3685acd70.1364205812.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Mar 2013 10:12:05.0422 (UTC) FILETIME=[3383ECE0:01CE2941]
X-MC-Unique: 113032510120609501
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PAD5TX026800

This patch moves cpufreq driver of ARM based pxa2xx platform to drivers/cpufreq.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/Kconfig                                                   | 7 -------
 arch/arm/mach-pxa/Makefile                                         | 5 -----
 drivers/cpufreq/Makefile                                           | 2 ++
 .../mach-pxa/cpufreq-pxa2xx.c => drivers/cpufreq/pxa2xx-cpufreq.c  | 2 --
 4 files changed, 2 insertions(+), 14 deletions(-)
 rename arch/arm/mach-pxa/cpufreq-pxa2xx.c => drivers/cpufreq/pxa2xx-cpufreq.c (99%)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fbb9587..39c8a3b 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2162,13 +2162,6 @@ config CPU_FREQ_SA1100
 config CPU_FREQ_SA1110
 	bool
 
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
index c5c276a..aa00ca4 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -56,6 +56,8 @@ obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
 obj-$(CONFIG_ARM_INTEGRATOR)		+= integrator-cpufreq.o
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


