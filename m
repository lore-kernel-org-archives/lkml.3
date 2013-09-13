Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3IMNqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:46:38 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:44440 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687Ab3IMNTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:19:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 141/228] cpufreq: pmac64: use cpufreq_generic_init() routine
Date: Fri, 13 Sep 2013 18:31:27 +0530
Message-Id: <3c39921134990a55770b0421cf7131916384e8d5.1379063063.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/pmac64-cpufreq.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 79e40c9..b977b9a 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -347,16 +347,9 @@ static unsigned int g5_cpufreq_get_speed(unsigned int cpu)
 
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

