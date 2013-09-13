Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab3IMNM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:12:27 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:52387 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932867Ab3IMNMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:12:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 079/228] cpufreq: ppc_cbe: Use generic cpufreq routines
Date: Fri, 13 Sep 2013 18:30:25 +0530
Message-Id: <889403c08078118ca2763484571de34a7cb114fc.1379063063.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/ppc_cbe_cpufreq.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/ppc_cbe_cpufreq.c b/drivers/cpufreq/ppc_cbe_cpufreq.c
index 6c5be63..38540d1 100644
--- a/drivers/cpufreq/ppc_cbe_cpufreq.c
+++ b/drivers/cpufreq/ppc_cbe_cpufreq.c
@@ -128,17 +128,6 @@ static int cbe_cpufreq_cpu_init(struct cpufreq_policy *policy)
 	return cpufreq_table_validate_and_show(policy, cbe_freqs);
 }
 
-static int cbe_cpufreq_cpu_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-	return 0;
-}
-
-static int cbe_cpufreq_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, cbe_freqs);
-}
-
 static int cbe_cpufreq_target(struct cpufreq_policy *policy,
 			      unsigned int target_freq,
 			      unsigned int relation)
@@ -174,10 +163,10 @@ static int cbe_cpufreq_target(struct cpufreq_policy *policy,
 }
 
 static struct cpufreq_driver cbe_cpufreq_driver = {
-	.verify		= cbe_cpufreq_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= cbe_cpufreq_target,
 	.init		= cbe_cpufreq_cpu_init,
-	.exit		= cbe_cpufreq_cpu_exit,
+	.exit		= cpufreq_generic_exit,
 	.name		= "cbe-cpufreq",
 	.flags		= CPUFREQ_CONST_LOOPS,
 };
-- 
1.7.12.rc2.18.g61b472e

