Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932961Ab3HNNgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:36:00 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:47232 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3HNNf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:35:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 25/37] cpufreq: pmac: don't initialize part of policy that is set by core too
Date: Wed, 14 Aug 2013 19:02:14 +0530
Message-Id: <345a99e64efed233ce2f42183d8a7b4e45712f1e.1376486713.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376486713.git.viresh.kumar@linaro.org>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376486713.git.viresh.kumar@linaro.org>
References: <cover.1376486713.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many common initializations of struct policy are moved to core now and hence
this driver doesn't need to do it. This patch removes such code.

Most recent of those changes is to call ->get() in the core after calling
->init().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pmac32-cpufreq.c | 1 -
 drivers/cpufreq/pmac64-cpufreq.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/cpufreq/pmac32-cpufreq.c b/drivers/cpufreq/pmac32-cpufreq.c
index b1ba708..47c227c 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -389,7 +389,6 @@ static int pmac_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return -ENODEV;
 
 	policy->cpuinfo.transition_latency	= transition_latency;
-	policy->cur = cur_freq;
 
 	return cpufreq_table_validate_and_show(policy, pmac_cpu_freqs);
 }
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 7679990..63f9642 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -338,7 +338,6 @@ static unsigned int g5_cpufreq_get_speed(unsigned int cpu)
 static int g5_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
 	policy->cpuinfo.transition_latency = transition_latency;
-	policy->cur = g5_cpu_freqs[g5_query_freq()].frequency;
 	/* secondary CPUs are tied to the primary one by the
 	 * cpufreq core if in the secondary policy we tell it that
 	 * it actually must be one policy together with all others. */
-- 
1.7.12.rc2.18.g61b472e

