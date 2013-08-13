Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab3HMNhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 09:37:36 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62520 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932592Ab3HMNhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 09:37:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 35/35] cpufreq: tegra: Covert to light weight ->target_index() routine
Date: Tue, 13 Aug 2013 19:02:48 +0530
Message-Id: <8becd7a6b5383426e35e89d108dbc9bb8ee17655.1376392602.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376392602.git.viresh.kumar@linaro.org>
References: <cover.1376392602.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts existing .target() to newly defined light weight
.target_index() routine for this driver.

CPUFreq core will call cpufreq_frequency_table_target() before calling this
routine and will pass index to it.

Cc: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/tegra-cpufreq.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index affb294..ee2cf8f3 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -150,11 +150,8 @@ static unsigned long tegra_cpu_highest_speed(void)
 	return rate;
 }
 
-static int tegra_target(struct cpufreq_policy *policy,
-		       unsigned int target_freq,
-		       unsigned int relation)
+static int tegra_target(struct cpufreq_policy *policy, unsigned int index)
 {
-	unsigned int idx;
 	unsigned int freq;
 	int ret = 0;
 
@@ -165,10 +162,7 @@ static int tegra_target(struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	cpufreq_frequency_table_target(policy, freq_table, target_freq,
-		relation, &idx);
-
-	freq = freq_table[idx].frequency;
+	freq = freq_table[index].frequency;
 
 	target_cpu_speed[policy->cpu] = freq;
 
@@ -234,7 +228,7 @@ static int tegra_cpu_exit(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver tegra_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= tegra_target,
+	.target_index	= tegra_target,
 	.get		= tegra_getspeed,
 	.init		= tegra_cpu_init,
 	.exit		= tegra_cpu_exit,
-- 
1.7.12.rc2.18.g61b472e

