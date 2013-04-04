Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606Ab3DDMza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:55:30 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:41975 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760571Ab3DDMz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:55:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 02/18] cpufreq: tegra: Move driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:10 +0530
Message-Id: <64b0150f8052708fa606c59322e34bd023ee4b0b.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of ARM based tegra platform to drivers/cpufreq.

Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Stephen Warren <swarren@nvidia.com>
Tested-by: Stephen Warren <swarren@nvidia.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/mach-tegra/Makefile                                       | 1 -
 drivers/cpufreq/Makefile                                           | 1 +
 arch/arm/mach-tegra/cpu-tegra.c => drivers/cpufreq/tegra-cpufreq.c | 2 --
 3 files changed, 1 insertion(+), 3 deletions(-)
 rename arch/arm/mach-tegra/cpu-tegra.c => drivers/cpufreq/tegra-cpufreq.c (99%)

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index f6b46ae..09b578f 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -24,7 +24,6 @@ obj-$(CONFIG_ARCH_TEGRA_3x_SOC)		+= cpuidle-tegra30.o
 endif
 obj-$(CONFIG_SMP)			+= platsmp.o headsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)               += hotplug.o
-obj-$(CONFIG_CPU_FREQ)                  += cpu-tegra.o
 obj-$(CONFIG_TEGRA_PCI)			+= pcie.o
 
 obj-$(CONFIG_ARCH_TEGRA_2x_SOC)		+= board-dt-tegra20.o
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 2c25504..c34094b 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
 obj-$(CONFIG_ARM_S3C64XX_CPUFREQ)	+= s3c64xx-cpufreq.o
 obj-$(CONFIG_ARM_S5PV210_CPUFREQ)	+= s5pv210-cpufreq.o
 obj-$(CONFIG_ARM_SPEAR_CPUFREQ)		+= spear-cpufreq.o
+obj-$(CONFIG_ARCH_TEGRA)		+= tegra-cpufreq.o
 
 ##################################################################################
 # PowerPC platform drivers
diff --git a/arch/arm/mach-tegra/cpu-tegra.c b/drivers/cpufreq/tegra-cpufreq.c
similarity index 99%
rename from arch/arm/mach-tegra/cpu-tegra.c
rename to drivers/cpufreq/tegra-cpufreq.c
index 11ca730..c74c0e1 100644
--- a/arch/arm/mach-tegra/cpu-tegra.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -1,6 +1,4 @@
 /*
- * arch/arm/mach-tegra/cpu-tegra.c
- *
  * Copyright (C) 2010 Google, Inc.
  *
  * Author:
-- 
1.7.12.rc2.18.g61b472e

