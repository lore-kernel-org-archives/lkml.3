Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450Ab3CYQzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 12:55:25 -0400
Received: from mail-da0-f44.google.com ([209.85.210.44]:59241 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab3CYQzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 12:55:20 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: arvind.chauhan@arm.com, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        arnd.bergmann@linaro.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 2/9] blackfin: cpufreq:  move cpufreq driver to drivers/cpufreq
Date: Mon, 25 Mar 2013 22:24:38 +0530
Message-Id: <df07f927c36e109e49363b9b87965a184ea941ca.1364229828.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1364229828.git.viresh.kumar@linaro.org>
References: <cover.1364229828.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves cpufreq driver of BLACKFIN architecture to drivers/cpufreq.

Cc: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
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
index 7573c22..2d86377 100644
--- a/drivers/cpufreq/Makefile
+++ b/drivers/cpufreq/Makefile
@@ -79,3 +79,4 @@ obj-$(CONFIG_CPU_FREQ_MAPLE)		+= maple-cpufreq.o
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

