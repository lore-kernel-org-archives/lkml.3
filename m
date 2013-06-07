Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751443Ab3FGFNM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:13:12 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52710 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3FGFNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:13:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        cw00.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq: stats: Remove CONFIG_CPU_FREQ_STAT_DETAILS
Date: Fri,  7 Jun 2013 10:42:57 +0530
Message-Id: <1683304a60f5188dc7f94e1a7797f12a4d1b47ab.1370581794.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current cpufreq stats has got three parts: time_in_state, total_trans and
trans_table.

trans_table was present under a separate macro's from others:
CONFIG_CPU_FREQ_STAT_DETAILS

The reason quoted for that was:
- trans_table goes against the traditional /sysfs rule of one value per
  interface. It provides a whole bunch of value in a 2 dimensional matrix form.

I don't understand how necessary it is to keep trans_table inside a separate
macro. These are all cpufreq sysfs stats, probably it doesn't matter if its one
dimensional or two.

Lets remove CONFIG_CPU_FREQ_STAT_DETAILS and use CONFIG_CPU_FREQ_STAT only to
make code more cleaner (i.e. remove unnecessary macros).

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 Documentation/cpu-freq/cpufreq-stats.txt  | 18 ++++--------------
 arch/mips/configs/lemote2f_defconfig      |  1 -
 arch/powerpc/configs/ppc6xx_defconfig     |  1 -
 arch/sh/configs/sh7785lcr_32bit_defconfig |  1 -
 drivers/cpufreq/Kconfig                   |  9 ---------
 drivers/cpufreq/cpufreq_stats.c           | 12 ------------
 6 files changed, 4 insertions(+), 38 deletions(-)

diff --git a/Documentation/cpu-freq/cpufreq-stats.txt b/Documentation/cpu-freq/cpufreq-stats.txt
index fc64749..838f990 100644
--- a/Documentation/cpu-freq/cpufreq-stats.txt
+++ b/Documentation/cpu-freq/cpufreq-stats.txt
@@ -111,18 +111,8 @@ Config Main Menu
 cpufreq-stats.
 
 "CPU frequency translation statistics" (CONFIG_CPU_FREQ_STAT) provides the
-basic statistics which includes time_in_state and total_trans.
-
-"CPU frequency translation statistics details" (CONFIG_CPU_FREQ_STAT_DETAILS)
-provides fine grained cpufreq stats by trans_table. The reason for having a
-separate config option for trans_table is:
-- trans_table goes against the traditional /sysfs rule of one value per
-  interface. It provides a whole bunch of value in a 2 dimensional matrix
-  form.
-
-Once these two options are enabled and your CPU supports cpufrequency, you
-will be able to see the CPU frequency statistics in /sysfs.
-
-
-
+statistics which includes time_in_state, total_trans and fine grained cpufreq
+stats by trans_table.
 
+Once this option is enabled and your CPU supports cpufrequency, you will be able
+to see the CPU frequency statistics in /sysfs.
diff --git a/arch/mips/configs/lemote2f_defconfig b/arch/mips/configs/lemote2f_defconfig
index 343bebc..f9229e9 100644
--- a/arch/mips/configs/lemote2f_defconfig
+++ b/arch/mips/configs/lemote2f_defconfig
@@ -41,7 +41,6 @@ CONFIG_PM_RUNTIME=y
 CONFIG_CPU_FREQ=y
 CONFIG_CPU_FREQ_DEBUG=y
 CONFIG_CPU_FREQ_STAT=m
-CONFIG_CPU_FREQ_STAT_DETAILS=y
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_CPU_FREQ_GOV_POWERSAVE=m
 CONFIG_CPU_FREQ_GOV_USERSPACE=m
diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index be1cb6e..bb7664c 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -58,7 +58,6 @@ CONFIG_GEF_SBC610=y
 CONFIG_CPU_FREQ=y
 CONFIG_CPU_FREQ_DEBUG=y
 CONFIG_CPU_FREQ_STAT=m
-CONFIG_CPU_FREQ_STAT_DETAILS=y
 CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE=y
 CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
 CONFIG_CPU_FREQ_GOV_POWERSAVE=m
diff --git a/arch/sh/configs/sh7785lcr_32bit_defconfig b/arch/sh/configs/sh7785lcr_32bit_defconfig
index 9bdcf72..7ce136d 100644
--- a/arch/sh/configs/sh7785lcr_32bit_defconfig
+++ b/arch/sh/configs/sh7785lcr_32bit_defconfig
@@ -25,7 +25,6 @@ CONFIG_SH_SH7785LCR=y
 CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_CPU_FREQ=y
-CONFIG_CPU_FREQ_STAT_DETAILS=y
 CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y
 CONFIG_SH_CPU_FREQ=y
 CONFIG_HEARTBEAT=y
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 534fcb8..f64ed8a 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -36,15 +36,6 @@ config CPU_FREQ_STAT
 
 	  If in doubt, say N.
 
-config CPU_FREQ_STAT_DETAILS
-	bool "CPU frequency translation statistics details"
-	depends on CPU_FREQ_STAT
-	help
-	  This will show detail CPU frequency translation table in sysfs file
-	  system.
-
-	  If in doubt, say N.
-
 choice
 	prompt "Default CPUFreq governor"
 	default CPU_FREQ_DEFAULT_GOV_USERSPACE if ARM_SA1100_CPUFREQ || ARM_SA1110_CPUFREQ
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index fb65dec..c774005 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -33,9 +33,7 @@ struct cpufreq_stats {
 	unsigned int last_index;
 	u64 *time_in_state;
 	unsigned int *freq_table;
-#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	unsigned int *trans_table;
-#endif
 };
 
 static DEFINE_PER_CPU(struct cpufreq_stats *, cpufreq_stats_table);
@@ -86,7 +84,6 @@ static ssize_t show_time_in_state(struct cpufreq_policy *policy, char *buf)
 	return len;
 }
 
-#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 static ssize_t show_trans_table(struct cpufreq_policy *policy, char *buf)
 {
 	ssize_t len = 0;
@@ -131,7 +128,6 @@ static ssize_t show_trans_table(struct cpufreq_policy *policy, char *buf)
 	return len;
 }
 cpufreq_freq_attr_ro(trans_table);
-#endif
 
 cpufreq_freq_attr_ro(total_trans);
 cpufreq_freq_attr_ro(time_in_state);
@@ -139,9 +135,7 @@ cpufreq_freq_attr_ro(time_in_state);
 static struct attribute *default_attrs[] = {
 	&total_trans.attr,
 	&time_in_state.attr,
-#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	&trans_table.attr,
-#endif
 	NULL
 };
 static struct attribute_group stats_attr_group = {
@@ -231,9 +225,7 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 
 	alloc_size = count * sizeof(int) + count * sizeof(u64);
 
-#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	alloc_size += count * count * sizeof(int);
-#endif
 	stat->max_state = count;
 	stat->time_in_state = kzalloc(alloc_size, GFP_KERNEL);
 	if (!stat->time_in_state) {
@@ -242,9 +234,7 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	}
 	stat->freq_table = (unsigned int *)(stat->time_in_state + count);
 
-#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	stat->trans_table = stat->freq_table + count;
-#endif
 	j = 0;
 	for (i = 0; table[i].frequency != CPUFREQ_TABLE_END; i++) {
 		unsigned int freq = table[i].frequency;
@@ -333,9 +323,7 @@ static int cpufreq_stat_notifier_trans(struct notifier_block *nb,
 
 	spin_lock(&cpufreq_stats_lock);
 	stat->last_index = new_index;
-#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
 	stat->trans_table[old_index * stat->max_state + new_index]++;
-#endif
 	stat->total_trans++;
 	spin_unlock(&cpufreq_stats_lock);
 	return 0;
-- 
1.7.12.rc2.18.g61b472e

