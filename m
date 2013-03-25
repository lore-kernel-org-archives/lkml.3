Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab3CYKNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:13:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55868 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab3CYKMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:12:07 -0400
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
Subject: [PATCH 6/9] cpufreq: pxa3xx: move cpufreq driver to drivers/cpufreq
Date: Mon, 25 Mar 2013 15:41:37 +0530
Message-Id: <2aa937c3d81776f01c2c1d6fcfcb08ba74163b53.1364205812.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Mar 2013 10:12:03.0704 (UTC) FILETIME=[327DC780:01CE2941]
X-MC-Unique: 113032510120507101
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PADkMI026808

This patch moves cpufreq driver of ARM based pxa3xx platform to drivers/cpufreq.

Cc: Eric Miao <eric.y.miao@gmail.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
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
index 170f01a..c5c276a 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -56,6 +56,7 @@ obj-$(CONFIG_ARM_IMX6Q_CPUFREQ)		+= imx6q-cpufreq.o
 obj-$(CONFIG_ARM_INTEGRATOR)		+= integrator-cpufreq.o
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


