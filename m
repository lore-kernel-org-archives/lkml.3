Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab3IMNQi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:16:38 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35862 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932612Ab3IMNQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:16:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 114/228] cpufreq: pmac: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:31:00 +0530
Message-Id: <b9cbb0d716bc4c9ecbbd64546b8282975c869b28.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
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
index 8715ab9..672b7f4 100644
--- a/drivers/cpufreq/pmac32-cpufreq.c
+++ b/drivers/cpufreq/pmac32-cpufreq.c
@@ -396,7 +396,6 @@ static int pmac_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return -ENODEV;
 
 	policy->cpuinfo.transition_latency	= transition_latency;
-	policy->cur = cur_freq;
 
 	return cpufreq_table_validate_and_show(policy, pmac_cpu_freqs);
 }
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index e853b85..79e40c9 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -348,7 +348,6 @@ static unsigned int g5_cpufreq_get_speed(unsigned int cpu)
 static int g5_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
 	policy->cpuinfo.transition_latency = transition_latency;
-	policy->cur = g5_cpu_freqs[g5_query_freq()].frequency;
 	/* secondary CPUs are tied to the primary one by the
 	 * cpufreq core if in the secondary policy we tell it that
 	 * it actually must be one policy together with all others. */
-- 
1.7.12.rc2.18.g61b472e

