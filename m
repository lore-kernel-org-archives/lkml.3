Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab3JROEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 10:04:35 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:48561 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140Ab3JROEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 10:04:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2 Resend 34/34] cpufreq: tegra: Convert to light weight ->target_index() routine
Date: Fri, 18 Oct 2013 19:29:57 +0530
Message-Id: <0dd5f7232b4c4782e5434b39b399835a2eb7ea94.1382104515.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1382104514.git.viresh.kumar@linaro.org>
References: <cover.1382104514.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1382104514.git.viresh.kumar@linaro.org>
References: <cover.1382104514.git.viresh.kumar@linaro.org>
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
index 32483ef..bd7d89c 100644
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
 
@@ -238,7 +232,7 @@ static int tegra_cpu_exit(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver tegra_cpufreq_driver = {
 	.verify		= cpufreq_generic_frequency_table_verify,
-	.target		= tegra_target,
+	.target_index	= tegra_target,
 	.get		= tegra_getspeed,
 	.init		= tegra_cpu_init,
 	.exit		= tegra_cpu_exit,
-- 
1.7.12.rc2.18.g61b472e

