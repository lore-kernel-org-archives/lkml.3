Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965623Ab3HHNvv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:51:51 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34967 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965593Ab3HHNvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:51:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 24/35] cpufreq: pmac: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:26 +0530
Message-Id: <5543f97ceba9becba711bd29e57d781a19c1ad26.1375964117.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pmac32-cpufreq.c | 3 +--
 drivers/cpufreq/pmac64-cpufreq.c | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index 38cdc63..0b3efdb 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -407,8 +407,7 @@ static int pmac_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency	= transition_latency;
 	policy->cur = cur_freq;
 
-	cpufreq_frequency_table_get_attr(pmac_cpu_freqs, policy->cpu);
-	return cpufreq_frequency_table_cpuinfo(policy, pmac_cpu_freqs);
+	return cpufreq_table_validate_and_show(policy, pmac_cpu_freqs);
 }
 
 static u32 read_gpio(struct device_node *np)
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index b6850d9..366be61 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -362,10 +362,8 @@ static int g5_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	 * cpufreq core if in the secondary policy we tell it that
 	 * it actually must be one policy together with all others. */
 	cpumask_copy(policy->cpus, cpu_online_mask);
-	cpufreq_frequency_table_get_attr(g5_cpu_freqs, policy->cpu);
 
-	return cpufreq_frequency_table_cpuinfo(policy,
-		g5_cpu_freqs);
+	return cpufreq_table_validate_and_show(policy, g5_cpu_freqs);
 }
 
 
-- 
1.7.12.rc2.18.g61b472e

