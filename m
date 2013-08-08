Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965653Ab3HHNwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:52:07 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40619 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965625Ab3HHNwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:52:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 26/35] cpufreq: ppc: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:28 +0530
Message-Id: <f230ab3e64a1323b7e06d67df77b9d489f134d00.1375964117.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/ppc-corenet-cpufreq.c | 3 +--
 drivers/cpufreq/ppc_cbe_cpufreq.c     | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index 60e81d5..5716b44 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -202,7 +202,7 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	table[i].frequency = CPUFREQ_TABLE_END;
 
 	/* set the min and max frequency properly */
-	ret = cpufreq_frequency_table_cpuinfo(policy, table);
+	ret = cpufreq_table_validate_and_show(policy, table);
 	if (ret) {
 		pr_err("invalid frequency table: %d\n", ret);
 		goto err_nomem1;
@@ -219,7 +219,6 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	policy->cur = corenet_cpufreq_get_speed(policy->cpu);
 
-	cpufreq_frequency_table_get_attr(table, cpu);
 	of_node_put(np);
 
 	return 0;
diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 2e448f0..6c5be63 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -123,11 +123,9 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	cpumask_copy(policy->cpus, cpu_sibling_mask(policy->cpu));
 #endif
 
-	cpufreq_frequency_table_get_attr(cbe_freqs, policy->cpu);
-
 	/* this ensures that policy->cpuinfo_min
 	 * and policy->cpuinfo_max are set correctly */
-	return cpufreq_frequency_table_cpuinfo(policy, cbe_freqs);
+	return cpufreq_table_validate_and_show(policy, cbe_freqs);
 }
 
 static int cbe_cpufreq_cpu_exit(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

