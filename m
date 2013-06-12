Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab3FLIV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 04:21:59 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61076 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab3FLIV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 04:21:57 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com, arnd@arndb.de,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 10/11] cpufreq: tegra: select CPU_FREQ_TABLE for ARCH_TEGRA
Date: Wed, 12 Jun 2013 13:45:17 +0530
Message-Id: <881257c10f24b5ca8721b561726bac8887dc922e.1371022830.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1371022830.git.viresh.kumar@linaro.org>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1371022830.git.viresh.kumar@linaro.org>
References: <cover.1371022830.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_TEGRA selects ARCH_HAS_CPUFREQ, so CPUFREQ will be enabled for all variants
of TEGRA. CPUFreq driver for tegra is enabled if ARCH_TEGRA is selected. Driver
uses APIs from freq_table.c and so we must select CPU_FREQ_TABLE for ARCH_TEGRA.

This also removes select CPU_FREQ_TABLE from individual tegra variants.

Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/mach-tegra/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 84d72fc..3636b6c 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -6,6 +6,7 @@ config ARCH_TEGRA
 	select CLKSRC_MMIO
 	select CLKSRC_OF
 	select COMMON_CLK
+	select CPU_FREQ_TABLE
 	select GENERIC_CLOCKEVENTS
 	select HAVE_ARM_SCU if SMP
 	select HAVE_ARM_TWD if LOCAL_TIMERS
@@ -28,7 +29,6 @@ config ARCH_TEGRA_2x_SOC
 	select ARM_ERRATA_754327 if SMP
 	select ARM_ERRATA_764369 if SMP
 	select ARM_GIC
-	select CPU_FREQ_TABLE if CPU_FREQ
 	select CPU_V7
 	select PINCTRL
 	select PINCTRL_TEGRA20
@@ -46,7 +46,6 @@ config ARCH_TEGRA_3x_SOC
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_764369 if SMP
 	select ARM_GIC
-	select CPU_FREQ_TABLE if CPU_FREQ
 	select CPU_V7
 	select PINCTRL
 	select PINCTRL_TEGRA30
@@ -63,7 +62,6 @@ config ARCH_TEGRA_114_SOC
 	select ARM_ARCH_TIMER
 	select ARM_GIC
 	select ARM_L1_CACHE_SHIFT_6
-	select CPU_FREQ_TABLE if CPU_FREQ
 	select CPU_V7
 	select PINCTRL
 	select PINCTRL_TEGRA114
-- 
1.7.12.rc2.18.g61b472e

