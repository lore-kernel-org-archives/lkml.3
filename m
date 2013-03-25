Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783Ab3CYKMH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:12:07 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49692 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab3CYKL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:11:59 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH 2/9] cpufreq: tegra: Move driver to drivers/cpufreq
Date: Mon, 25 Mar 2013 15:41:33 +0530
Message-Id: <fb8f986f4f94109ad0916917d8fa0d1692c757a0.1364205812.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364205812.git.viresh.kumar@linaro.org>
References: <cover.1364205812.git.viresh.kumar@linaro.org>
X-OriginalArrivalTime: 25 Mar 2013 10:11:57.0000 (UTC) FILETIME=[2E7ED480:01CE2941]
X-MC-Unique: 113032510115752301
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r2PAERkV026824

This patch moves cpufreq driver of ARM based tegra platform to drivers/cpufreq.

Cc: Stephen Warren <swarren@wwwdotorg.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
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
index e33a30e..966ea28 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_ARM_S3C2416_CPUFREQ)	+= s3c2416-cpufreq.o
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


