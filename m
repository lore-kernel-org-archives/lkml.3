Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab3HUOnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:43:52 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:57286 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab3HUOns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:43:48 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 09/14] cpufreq: pmac64: use cpufreq_generic_init() routine
Date: Wed, 21 Aug 2013 20:12:28 +0530
Message-Id: <b5c71baeb7ae63079899b244cb58edc4083b0993.1377093938.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic cpufreq_generic_init() routine instead of replicating the same code
here.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pmac64-cpufreq.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 2557f16..18fecf3 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -321,16 +321,9 @@ static unsigned int g5_cpufreq_get_speed(unsigned int cpu)
 
 static int g5_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
-	policy->cpuinfo.transition_latency = transition_latency;
-	/* secondary CPUs are tied to the primary one by the
-	 * cpufreq core if in the secondary policy we tell it that
-	 * it actually must be one policy together with all others. */
-	cpumask_copy(policy->cpus, cpu_online_mask);
-
-	return cpufreq_table_validate_and_show(policy, g5_cpu_freqs);
+	return cpufreq_generic_init(policy, g5_cpu_freqs, transition_latency);
 }
 
-
 static struct cpufreq_driver g5_cpufreq_driver = {
 	.name		= "powermac",
 	.flags		= CPUFREQ_CONST_LOOPS,
-- 
1.7.12.rc2.18.g61b472e

