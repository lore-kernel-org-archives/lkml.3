Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839Ab3DDM7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:59:48 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:51193 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760724Ab3DDM4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:56:33 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 10/18] cpufreq: blackfin: move cpufreq driver to drivers/cpufreq
Date: Thu,  4 Apr 2013 18:24:18 +0530
Message-Id: <23070472a9b7ed67cd4411b6c43a1f8770d7d11d.1365079581.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1365079581.git.viresh.kumar@linaro.org>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of BLACKFIN architecture to drivers/cpufreq.

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Acked-by: Steven Miao <realmz6@gmail.com>
---
 arch/blackfin/mach-common/Makefile                                       | 1 -
 drivers/cpufreq/Makefile                                                 | 1 +
 .../blackfin/mach-common/cpufreq.c => drivers/cpufreq/blackfin-cpufreq.c | 0
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename arch/blackfin/mach-common/cpufreq.c => drivers/cpufreq/blackfin-cpufreq.c (100%)

diff --git a/arch/blackfin/mach-common/Makefile b/arch/blackfin/mach-common/Makefile
index 75f0ba2..675466d 100644
--- a/arch/blackfin/mach-common/Makefile
+++ b/arch/blackfin/mach-common/Makefile
@@ -10,7 +10,6 @@ obj-$(CONFIG_PM)          += pm.o
 ifneq ($(CONFIG_BF60x),y)
 obj-$(CONFIG_PM)	  += dpmc_modes.o
 endif
-obj-$(CONFIG_CPU_FREQ)    += cpufreq.o
 obj-$(CONFIG_CPU_VOLTAGE) += dpmc.o
 obj-$(CONFIG_SMP)         += smp.o
 obj-$(CONFIG_BFIN_KERNEL_CLOCK) += clocks-init.o
diff --git a/drivers/cpufreq/Makefile b/drivers/cpufreq/Makefile
index 36a93a6..19de776 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -83,3 +83,4 @@ obj-$(CONFIG_CPU_FREQ_MAPLE)		+= maple-cpufreq.o
 ##################################################################################
 # Other platform drivers
 obj-$(CONFIG_AVR32_AT32AP_CPUFREQ)	+= at32ap-cpufreq.o
+obj-$(CONFIG_BLACKFIN)			+= blackfin-cpufreq.o
diff --git a/arch/blackfin/mach-common/cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
similarity index 100%
rename from arch/blackfin/mach-common/cpufreq.c
rename to drivers/cpufreq/blackfin-cpufreq.c
-- 
1.7.12.rc2.18.g61b472e

