Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640Ab3DDMzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:55:38 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:60998 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760616Ab3DDMze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:55:34 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Sekhar Nori <nsekhar@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 03/18] cpufreq: davinci: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:11 +0530
Message-Id: <eb5d22a8f338116621cdffdf46e4e3d50966e428.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of ARM based davinci platform to
drivers/cpufreq.

Cc: Sekhar Nori <nsekhar@ti.com>
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Sekhar Nori <nsekhar@ti.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-davinci/Makefile                                       | 1 -
 drivers/cpufreq/Makefile                                             | 1 +
 arch/arm/mach-davinci/cpufreq.c => drivers/cpufreq/davinci-cpufreq.c | 2 --
 3 files changed, 1 insertion(+), 3 deletions(-)
 rename arch/arm/mach-davinci/cpufreq.c => drivers/cpufreq/davinci-cpufreq.c (99%)

diff --git a/arch/arm/mach-davinci/Makefile b/arch/arm/mach-davinci/Makefile
index fb5c1aa..dd1ffcc 100644
--- a/arch/arm/mach-davinci/Makefile
+++ b/arch/arm/mach-davinci/Makefile
@@ -37,7 +37,6 @@ obj-$(CONFIG_MACH_MITYOMAPL138)		+= board-mityomapl138.o
 obj-$(CONFIG_MACH_OMAPL138_HAWKBOARD)	+= board-omapl138-hawk.o
 
 # Power Management
-obj-$(CONFIG_CPU_FREQ)			+= cpufreq.o
 obj-$(CONFIG_CPU_IDLE)			+= cpuidle.o
 obj-$(CONFIG_SUSPEND)			+= pm.o sleep.o
 obj-$(CONFIG_HAVE_CLK)			+= pm_domain.o
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index c34094b..c0e8921 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_ARM_BIG_LITTLE_CPUFREQ)	+= arm_big_little.o
 # LITTLE drivers, so that it is probed last.
 obj-$(CONFIG_ARM_DT_BL_CPUFREQ)		+= arm_big_little_dt.o
 
+obj-$(CONFIG_ARCH_DAVINCI_DA850)	+= davinci-cpufreq.o
 obj-$(CONFIG_UX500_SOC_DB8500)		+= dbx500-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS_CPUFREQ)	+= exynos-cpufreq.o
 obj-$(CONFIG_ARM_EXYNOS4210_CPUFREQ)	+= exynos4210-cpufreq.o
diff --git a/arch/arm/mach-davinci/cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
similarity index 99%
rename from arch/arm/mach-davinci/cpufreq.c
rename to drivers/cpufreq/davinci-cpufreq.c
index 7c2e943..c33c76c 100644
--- a/arch/arm/mach-davinci/cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -30,8 +30,6 @@
 #include <mach/cpufreq.h>
 #include <mach/common.h>
 
-#include "clock.h"
-
 struct davinci_cpufreq {
 	struct device *dev;
 	struct clk *armclk;
-- 
1.7.12.rc2.18.g61b472e

