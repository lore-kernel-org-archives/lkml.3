Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745Ab3IMNUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:20:08 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:49499 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933724Ab3IMNUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:20:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 144/228] cpufreq: sa11x0: use cpufreq_generic_init() routine
Date: Fri, 13 Sep 2013 18:31:30 +0530
Message-Id: <254e7e912c3817fdf1499bb1ea7be7bc7f3cdbef.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic cpufreq_generic_init() routine instead of replicating the same code
here.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sa1100-cpufreq.c | 6 +-----
 drivers/cpufreq/sa1110-cpufreq.c | 6 +-----
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/cpufreq/sa1100-cpufreq.c b/drivers/cpufreq/sa1100-cpufreq.c
index a1d1bb7..b282cea 100644
--- a/drivers/cpufreq/sa1100-cpufreq.c
+++ b/drivers/cpufreq/sa1100-cpufreq.c
@@ -218,11 +218,7 @@ static int sa1100_target(struct cpufreq_policy *policy,
 
 static int __init sa1100_cpu_init(struct cpufreq_policy *policy)
 {
-	if (policy->cpu != 0)
-		return -EINVAL;
-	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
-
-	return cpufreq_table_validate_and_show(policy, sa11x0_freq_table);
+	return cpufreq_generic_init(policy, sa11x0_freq_table, CPUFREQ_ETERNAL);
 }
 
 static struct cpufreq_driver sa1100_driver __refdata = {
diff --git a/drivers/cpufreq/sa1110-cpufreq.c b/drivers/cpufreq/sa1110-cpufreq.c
index 9da940e..bca04c0 100644
--- a/drivers/cpufreq/sa1110-cpufreq.c
+++ b/drivers/cpufreq/sa1110-cpufreq.c
@@ -332,11 +332,7 @@ static int sa1110_target(struct cpufreq_policy *policy,
 
 static int __init sa1110_cpu_init(struct cpufreq_policy *policy)
 {
-	if (policy->cpu != 0)
-		return -EINVAL;
-	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
-
-	return cpufreq_table_validate_and_show(policy, sa11x0_freq_table);
+	return cpufreq_generic_init(policy, sa11x0_freq_table, CPUFREQ_ETERNAL);
 }
 
 /* sa1110_driver needs __refdata because it must remain after init registers
-- 
1.7.12.rc2.18.g61b472e

