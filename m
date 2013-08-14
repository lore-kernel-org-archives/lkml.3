Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab3HNNeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:34:44 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:44709 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab3HNNek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:34:40 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 14/37] cpufreq: gx: don't initialize part of policy that is set by core too
Date: Wed, 14 Aug 2013 19:02:03 +0530
Message-Id: <ffea055b81c78e42d5bae58b1c5c6beadd133a3a.1376486713.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/gx-suspmod.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
index 70442c7..d83e826 100644
--- a/drivers/cpufreq/gx-suspmod.c
+++ b/drivers/cpufreq/gx-suspmod.c
@@ -401,7 +401,7 @@ static int cpufreq_gx_target(struct cpufreq_policy *policy,
 
 static int cpufreq_gx_cpu_init(struct cpufreq_policy *policy)
 {
-	unsigned int maxfreq, curfreq;
+	unsigned int maxfreq;
 
 	if (!policy || policy->cpu != 0)
 		return -ENODEV;
@@ -415,10 +415,8 @@ static int cpufreq_gx_cpu_init(struct cpufreq_policy *policy)
 		maxfreq = 30000 * gx_freq_mult[getCx86(CX86_DIR1) & 0x0f];
 
 	stock_freq = maxfreq;
-	curfreq = gx_get_cpuspeed(0);
 
 	pr_debug("cpu max frequency is %d.\n", maxfreq);
-	pr_debug("cpu current frequency is %dkHz.\n", curfreq);
 
 	/* setup basic struct for cpufreq API */
 	policy->cpu = 0;
@@ -428,7 +426,6 @@ static int cpufreq_gx_cpu_init(struct cpufreq_policy *policy)
 	else
 		policy->min = maxfreq / POLICY_MIN_DIV;
 	policy->max = maxfreq;
-	policy->cur = curfreq;
 	policy->cpuinfo.min_freq = maxfreq / max_duration;
 	policy->cpuinfo.max_freq = maxfreq;
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
-- 
1.7.12.rc2.18.g61b472e

