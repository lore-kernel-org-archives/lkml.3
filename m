Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3HUOnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:43:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64079 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab3HUOnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:43:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 04/14] cpufreq: exynos: use cpufreq_generic_init() routine
Date: Wed, 21 Aug 2013 20:12:23 +0530
Message-Id: <49fe6e3b9a14023e6a49f80fc0e6d87c02fca6cd.1377093938.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic cpufreq_generic_init() routine instead of replicating the same code
here.

Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/exynos-cpufreq.c     |  7 +------
 drivers/cpufreq/exynos5440-cpufreq.c | 14 ++------------
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 0f87a29..c9ae7e6 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -214,12 +214,7 @@ static struct notifier_block exynos_cpufreq_nb = {
 
 static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
-	/* set the transition latency value */
-	policy->cpuinfo.transition_latency = 100000;
-
-	cpumask_setall(policy->cpus);
-
-	return cpufreq_table_validate_and_show(policy, exynos_info->freq_table);
+	return cpufreq_generic_init(policy, exynos_info->freq_table, 100000);
 }
 
 static struct cpufreq_driver exynos_driver = {
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index b9673fa..68da5f4 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -308,18 +308,8 @@ static void exynos_sort_descend_freq_table(void)
 
 static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
-	int ret;
-
-	ret = cpufreq_table_validate_and_show(policy, dvfs_info->freq_table);
-	if (ret) {
-		dev_err(dvfs_info->dev, "Invalid frequency table: %d\n", ret);
-		return ret;
-	}
-
-	policy->cpuinfo.transition_latency = dvfs_info->latency;
-	cpumask_setall(policy->cpus);
-
-	return 0;
+	return cpufreq_generic_init(policy, dvfs_info->freq_table,
+			dvfs_info->latency);
 }
 
 static struct cpufreq_driver exynos_driver = {
-- 
1.7.12.rc2.18.g61b472e

