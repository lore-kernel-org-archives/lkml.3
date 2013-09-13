Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab3IMNFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:05:43 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57578 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757478Ab3IMNFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:05:38 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 022/228] cpufreq: exynos: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:28 +0530
Message-Id: <f65d16316d788ed0de4b48451d6eb92393d8aef3.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos-cpufreq.c     | 4 +---
 drivers/cpufreq/exynos5440-cpufreq.c | 4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 0fac344..954baed 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -249,14 +249,12 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
 	policy->cur = policy->min = policy->max = exynos_getspeed(policy->cpu);
 
-	cpufreq_frequency_table_get_attr(exynos_info->freq_table, policy->cpu);
-
 	/* set the transition latency value */
 	policy->cpuinfo.transition_latency = 100000;
 
 	cpumask_setall(policy->cpus);
 
-	return cpufreq_frequency_table_cpuinfo(policy, exynos_info->freq_table);
+	return cpufreq_table_validate_and_show(policy, exynos_info->freq_table);
 }
 
 static int exynos_cpufreq_cpu_exit(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 1e391ac..83bd700 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -329,7 +329,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
 	int ret;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, dvfs_info->freq_table);
+	ret = cpufreq_table_validate_and_show(policy, dvfs_info->freq_table);
 	if (ret) {
 		dev_err(dvfs_info->dev, "Invalid frequency table: %d\n", ret);
 		return ret;
@@ -339,8 +339,6 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = dvfs_info->latency;
 	cpumask_setall(policy->cpus);
 
-	cpufreq_frequency_table_get_attr(dvfs_info->freq_table, policy->cpu);
-
 	return 0;
 }
 
-- 
1.7.12.rc2.18.g61b472e

