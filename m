Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679Ab3DDMzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:55:46 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53540 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760654Ab3DDMzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:55:43 -0400
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
Subject: [PATCH 04/18] cpufreq: pxa3xx: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:12 +0530
Message-Id: <5aa065e550ad6b9f443155913a383374235df865.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of ARM based pxa3xx platform to drivers/cpufreq.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Eric Miao <eric.y.miao@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-pxa/Makefile                                           | 1 -
 arch/arm/mach-pxa/include/mach/generic.h                             | 1 +
 drivers/cpufreq/Makefile                                             | 1 +
 .../mach-pxa/cpufreq-pxa3xx.c => drivers/cpufreq/pxa3xx-cpufreq.c    | 5 +----
 4 files changed, 3 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm/mach-pxa/include/mach/generic.h
 rename arch/arm/mach-pxa/cpufreq-pxa3xx.c => drivers/cpufreq/pxa3xx-cpufreq.c (98%)

diff --git a/arch/arm/mach-pxa/Makefile b/arch/arm/mach-pxa/Makefile
index 12c5005..929e700 100644
--- a/arch/arm/mach-pxa/Makefile
+++ b/arch/arm/mach-pxa/Makefile
@@ -10,7 +10,6 @@ obj-$(CONFIG_PM)		+= pm.o sleep.o standby.o
 ifeq ($(CONFIG_CPU_FREQ),y)
 obj-$(CONFIG_PXA25x)		+= cpufreq-pxa2xx.o
 obj-$(CONFIG_PXA27x)		+= cpufreq-pxa2xx.o
-obj-$(CONFIG_PXA3xx)		+= cpufreq-pxa3xx.o
 endif
 
 # Generic drivers that other drivers may depend upon
diff --git a/arch/arm/mach-pxa/include/mach/generic.h b/arch/arm/mach-pxa/include/mach/generic.h
new file mode 100644
index 0000000..665542e
--- /dev/null
+++ b/arch/arm/mach-pxa/include/mach/generic.h
@@ -0,0 +1 @@
+#include "../../generic.h"
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index c0e8921..3458bf2 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_ARM_HIGHBANK_CPUFREQ)	+= highbank-cpufreq.o
 obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
 obj-$(CONFIG_ARM_KIRKWOOD_CPUFREQ)	+= kirkwood-cpufreq.o
 obj-$(CONFIG_ARM_OMAP2PLUS_CPUFREQ)	+= omap-cpufreq.o
+obj-$(CONFIG_PXA3xx)			+= pxa3xx-cpufreq.o
 obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
 obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c64xx-cpufreq.o
 obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
diff --git a/arch/arm/mach-pxa/cpufreq-pxa3xx.c b/drivers/cpufreq/pxa3xx-cpufreq.c
similarity index 98%
rename from arch/arm/mach-pxa/cpufreq-pxa3xx.c
rename to drivers/cpufreq/pxa3xx-cpufreq.c
index 8c45b2b..15d60f8 100644
--- a/arch/arm/mach-pxa/cpufreq-pxa3xx.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -1,6 +1,4 @@
 /*
- * linux/arch/arm/mach-pxa/cpufreq-pxa3xx.c
- *
  * Copyright (C) 2008 Marvell International Ltd.
  *
  * This program is free software; you can redistribute it and/or modify
@@ -17,10 +15,9 @@
 #include <linux/slab.h>
 #include <linux/io.h>
 
+#include <mach/generic.h>
 #include <mach/pxa3xx-regs.h>
 
-#include "generic.h"
-
 #define HSS_104M	(0)
 #define HSS_156M	(1)
 #define HSS_208M	(2)
-- 
1.7.12.rc2.18.g61b472e

