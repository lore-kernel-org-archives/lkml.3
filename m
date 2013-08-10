Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161126Ab3HJGwo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:52:44 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:65385 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161111Ab3HJGwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:52:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        spear-devel@list.st.com
Subject: [PATCH 40/44] cpufreq: spear: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:36 +0530
Message-Id: <f91ae85d1760fe69d7daa5844084482cf0a346b8.1376116345.git.viresh.kumar@linaro.org>
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

Cc: spear-devel@list.st.com
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/spear-cpufreq.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 1d619dd..d31accc 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -30,11 +30,6 @@ static struct {
 	u32 cnt;
 } spear_cpufreq;
 
-static int spear_cpufreq_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, spear_cpufreq.freq_tbl);
-}
-
 static unsigned int spear_cpufreq_get(unsigned int cpu)
 {
 	return clk_get_rate(spear_cpufreq.clk) / 1000;
@@ -192,26 +187,15 @@ static int spear_cpufreq_init(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static int spear_cpufreq_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-	return 0;
-}
-
-static struct freq_attr *spear_cpufreq_attr[] = {
-	 &cpufreq_freq_attr_scaling_available_freqs,
-	 NULL,
-};
-
 static struct cpufreq_driver spear_cpufreq_driver = {
 	.name		= "cpufreq-spear",
 	.flags		= CPUFREQ_STICKY,
-	.verify		= spear_cpufreq_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= spear_cpufreq_target,
 	.get		= spear_cpufreq_get,
 	.init		= spear_cpufreq_init,
-	.exit		= spear_cpufreq_exit,
-	.attr		= spear_cpufreq_attr,
+	.exit		= cpufreq_generic_exit,
+	.attr		= cpufreq_generic_attr,
 };
 
 static int spear_cpufreq_driver_init(void)
-- 
1.7.12.rc2.18.g61b472e

