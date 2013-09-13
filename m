Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3IMNHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:07:20 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:61881 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab3IMNHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:07:12 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH 035/228] cpufreq: pxa: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:41 +0530
Message-Id: <87e39df53232f7feaa018a89d67c4b5b77c0ebcc.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Eric Miao <eric.y.miao@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pxa2xx-cpufreq.c | 6 ++----
 drivers/cpufreq/pxa3xx-cpufreq.c | 8 ++------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index 5b8ce9a..b3bfb57 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -454,12 +454,10 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 		pr_info("PXA255 cpufreq using %s frequency table\n",
 			pxa255_turbo_table ? "turbo" : "run");
 
-		cpufreq_frequency_table_cpuinfo(policy, pxa255_freq_table);
-		cpufreq_frequency_table_get_attr(pxa255_freq_table, policy->cpu);
+		cpufreq_table_validate_and_show(policy, pxa255_freq_table);
 	}
 	else if (cpu_is_pxa27x()) {
-		cpufreq_frequency_table_cpuinfo(policy, pxa27x_freq_table);
-		cpufreq_frequency_table_get_attr(pxa27x_freq_table, policy->cpu);
+		cpufreq_table_validate_and_show(policy, pxa27x_freq_table);
 	}
 
 	printk(KERN_INFO "PXA CPU frequency change support initialized\n");
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 8f14234..3f4986e 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -91,7 +91,7 @@ static int setup_freqs_table(struct cpufreq_policy *policy,
 			     struct pxa3xx_freq_info *freqs, int num)
 {
 	struct cpufreq_frequency_table *table;
-	int i, ret;
+	int i;
 
 	table = kzalloc((num + 1) * sizeof(*table), GFP_KERNEL);
 	if (table == NULL)
@@ -108,11 +108,7 @@ static int setup_freqs_table(struct cpufreq_policy *policy,
 	pxa3xx_freqs_num = num;
 	pxa3xx_freqs_table = table;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, table);
-	if (!ret)
-		cpufreq_frequency_table_get_attr(table, policy->cpu);
-
-	return ret;
+	return cpufreq_table_validate_and_show(policy, table);
 }
 
 static void __update_core_freq(struct pxa3xx_freq_info *info)
-- 
1.7.12.rc2.18.g61b472e

