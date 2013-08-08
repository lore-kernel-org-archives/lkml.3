Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab3HHNtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:49:42 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:50733 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294Ab3HHNth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:49:37 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 06/35] cpufreq: arm_big_little: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:08 +0530
Message-Id: <d7a79034d750bee261bbd83a9a5991da473afafe.1375964117.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/arm_big_little.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 3549f07..5070273 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -165,7 +165,7 @@ static int bL_cpufreq_init(struct cpufreq_policy *policy)
 	if (ret)
 		return ret;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, freq_table[cur_cluster]);
+	ret = cpufreq_table_validate_and_show(policy, freq_table[cur_cluster]);
 	if (ret) {
 		dev_err(cpu_dev, "CPU %d, cluster: %d invalid freq table\n",
 				policy->cpu, cur_cluster);
@@ -173,8 +173,6 @@ static int bL_cpufreq_init(struct cpufreq_policy *policy)
 		return ret;
 	}
 
-	cpufreq_frequency_table_get_attr(freq_table[cur_cluster], policy->cpu);
-
 	if (arm_bL_ops->get_transition_latency)
 		policy->cpuinfo.transition_latency =
 			arm_bL_ops->get_transition_latency(cpu_dev);
-- 
1.7.12.rc2.18.g61b472e

