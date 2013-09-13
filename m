Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3IMNLY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:11:24 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44178 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab3IMNLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:11:19 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 070/228] cpufreq: longhaul: Use generic cpufreq routines
Date: Fri, 13 Sep 2013 18:30:16 +0530
Message-Id: <44ef88358799992e51a786756e17139fb620cdef.1379063063.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/longhaul.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index 70b66fd..57d7b02 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -625,12 +625,6 @@ static void longhaul_setup_voltagescaling(void)
 }
 
 
-static int longhaul_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, longhaul_table);
-}
-
-
 static int longhaul_target(struct cpufreq_policy *policy,
 			    unsigned int target_freq, unsigned int relation)
 {
@@ -924,25 +918,14 @@ static int longhaul_cpu_init(struct cpufreq_policy *policy)
 	return cpufreq_table_validate_and_show(policy, longhaul_table);
 }
 
-static int longhaul_cpu_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-	return 0;
-}
-
-static struct freq_attr *longhaul_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver longhaul_driver = {
-	.verify	= longhaul_verify,
+	.verify	= cpufreq_generic_frequency_table_verify,
 	.target	= longhaul_target,
 	.get	= longhaul_get,
 	.init	= longhaul_cpu_init,
-	.exit	= longhaul_cpu_exit,
+	.exit	= cpufreq_generic_exit,
 	.name	= "longhaul",
-	.attr	= longhaul_attr,
+	.attr	= cpufreq_generic_attr,
 };
 
 static const struct x86_cpu_id longhaul_id[] = {
-- 
1.7.12.rc2.18.g61b472e

