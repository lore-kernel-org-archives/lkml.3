Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaBZURu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:17:50 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:33532 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaBZURr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:17:47 -0500
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>
Subject: [PATCH 2/3] cpufreq: stats: Fix error handling in __cpufreq_stats_create_table()
Date: Wed, 26 Feb 2014 12:17:37 -0800
Message-Id: <1393445858-7062-2-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove sysfs group if __cpufreq_stats_create_table() fails after creating
one.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/cpufreq/cpufreq_stats.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index e4bd27f..c52b440 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -216,7 +216,7 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	stat->time_in_state = kzalloc(alloc_size, GFP_KERNEL);
 	if (!stat->time_in_state) {
 		ret = -ENOMEM;
-		goto error_out;
+		goto error_alloc;
 	}
 	stat->freq_table = (unsigned int *)(stat->time_in_state + count);
 
@@ -237,6 +237,8 @@ static int __cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	stat->last_index = freq_table_get_index(stat, policy->cur);
 	spin_unlock(&cpufreq_stats_lock);
 	return 0;
+error_alloc:
+	sysfs_remove_group(&policy->kobj, &stats_attr_group);
 error_out:
 	kfree(stat);
 	per_cpu(cpufreq_stats_table, cpu) = NULL;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

