Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab3IMNJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:09:59 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:53247 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527Ab3IMNJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:09:53 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 058/228] cpufreq: at32ap: Use generic cpufreq routines
Date: Fri, 13 Sep 2013 18:30:04 +0530
Message-Id: <e2d88ba3fcb0b258675f4cbbff4c84217254435b.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/at32ap-cpufreq.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
index 1d19fa5..788f7e7 100644
--- a/drivers/cpufreq/at32ap-cpufreq.c
+++ b/drivers/cpufreq/at32ap-cpufreq.c
@@ -24,16 +24,6 @@
 static struct clk *cpuclk;
 static struct cpufreq_frequency_table *freq_table;
 
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
@@ -152,7 +142,7 @@ out_err:
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

