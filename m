Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab3HJGtO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:49:14 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48490 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745Ab3HJGtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:49:09 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>
Subject: [PATCH 11/44] cpufreq: at32ap: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:07 +0530
Message-Id: <c70729588f2f21d10fa5d53e5189890af4248a93.1376116345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/at32ap-cpufreq.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index e0c38d9..b27f750 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -22,16 +22,6 @@
 
 static struct clk *cpuclk;
 
-static int at32_verify_speed(struct cpufreq_policy *policy)
-{
-	if (policy->cpu != 0)
-		return -EINVAL;
-
-	cpufreq_verify_within_limits(policy, policy->cpuinfo.min_freq,
-			policy->cpuinfo.max_freq);
-	return 0;
-}
-
 static unsigned int at32_get_speed(unsigned int cpu)
 {
 	/* No SMP support */
@@ -109,7 +99,7 @@ static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
 static struct cpufreq_driver at32_driver = {
 	.name		= "at32ap",
 	.init		= at32_cpufreq_driver_init,
-	.verify		= at32_verify_speed,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= at32_set_target,
 	.get		= at32_get_speed,
 	.flags		= CPUFREQ_STICKY,
-- 
1.7.12.rc2.18.g61b472e

