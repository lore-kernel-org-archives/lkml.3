Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465Ab3BDLjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:39:25 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:34267 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415Ab3BDLjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:39:22 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/4] cpufreq: stats: Get rid of CPUFREQ_STATDEVICE_ATTR
Date: Mon,  4 Feb 2013 17:08:52 +0530
Message-Id: <0f3f2223e79388db616fc5925ef8fc6b223f1d81.1359976493.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1359976493.git.viresh.kumar@linaro.org>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1359976493.git.viresh.kumar@linaro.org>
References: <cover.1359976493.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macro "CPUFREQ_STATDEVICE_ATTR" is defined local to cpufreq_stats.c file and is
almost a copy of the generic version present in cpufreq.h file. Lets use the
generic version instead.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq_stats.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 572124c..a2dee4c 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -24,12 +24,6 @@
 
 static spinlock_t cpufreq_stats_lock;
 
-#define CPUFREQ_STATDEVICE_ATTR(_name, _mode, _show) \
-static struct freq_attr _attr_##_name = {\
-	.attr = {.name = __stringify(_name), .mode = _mode, }, \
-	.show = _show,\
-};
-
 struct cpufreq_stats {
 	unsigned int cpu;
 	unsigned int total_trans;
@@ -136,17 +130,17 @@ static ssize_t show_trans_table(struct cpufreq_policy *policy, char *buf)
 		return PAGE_SIZE;
 	return len;
 }
-CPUFREQ_STATDEVICE_ATTR(trans_table, 0444, show_trans_table);
+cpufreq_freq_attr_ro(trans_table);
 #endif
 
-CPUFREQ_STATDEVICE_ATTR(total_trans, 0444, show_total_trans);
-CPUFREQ_STATDEVICE_ATTR(time_in_state, 0444, show_time_in_state);
+cpufreq_freq_attr_ro(total_trans);
+cpufreq_freq_attr_ro(time_in_state);
 
 static struct attribute *default_attrs[] = {
-	&_attr_total_trans.attr,
-	&_attr_time_in_state.attr,
+	&total_trans.attr,
+	&time_in_state.attr,
 #ifdef CONFIG_CPU_FREQ_STAT_DETAILS
-	&_attr_trans_table.attr,
+	&trans_table.attr,
 #endif
 	NULL
 };
-- 
1.7.12.rc2.18.g61b472e

