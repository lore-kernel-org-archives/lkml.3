Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031902Ab3HJGui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:50:38 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:47200 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968400Ab3HJGud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:50:33 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 22/44] cpufreq: kirkwood: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:18 +0530
Message-Id: <4651cb39618a41f6f4f5ba16946120ad7c5e7430.1376116345.git.viresh.kumar@linaro.org>
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

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/kirkwood-cpufreq.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 336f171..9018c4d 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -102,11 +102,6 @@ static void kirkwood_cpufreq_set_cpu_state(struct cpufreq_policy *policy,
 	cpufreq_notify_transition(policy, &freqs, CPUFREQ_POSTCHANGE);
 };
 
-static int kirkwood_cpufreq_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, kirkwood_freq_table);
-}
-
 static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
@@ -132,25 +127,14 @@ static int kirkwood_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	return cpufreq_table_validate_and_show(policy, kirkwood_freq_table);
 }
 
-static int kirkwood_cpufreq_cpu_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-	return 0;
-}
-
-static struct freq_attr *kirkwood_cpufreq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver kirkwood_cpufreq_driver = {
 	.get	= kirkwood_cpufreq_get_cpu_frequency,
-	.verify	= kirkwood_cpufreq_verify,
+	.verify	= cpufreq_generic_frequency_table_verify,
 	.target	= kirkwood_cpufreq_target,
 	.init	= kirkwood_cpufreq_cpu_init,
-	.exit	= kirkwood_cpufreq_cpu_exit,
+	.exit	= cpufreq_generic_exit,
 	.name	= "kirkwood-cpufreq",
-	.attr	= kirkwood_cpufreq_attr,
+	.attr	= cpufreq_generic_attr,
 };
 
 static int kirkwood_cpufreq_probe(struct platform_device *pdev)
-- 
1.7.12.rc2.18.g61b472e

