Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab3IMNS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:18:27 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40125 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933506Ab3IMNSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:18:17 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 129/228] cpufreq: cpu0: use cpufreq_generic_init() routine
Date: Fri, 13 Sep 2013 18:31:15 +0530
Message-Id: <5634a2ff3f1e3d0544cc09fbf6dafb4a788ae91e.1379063063.git.viresh.kumar@linaro.org>
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

Cc: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq-cpu0.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/cpufreq/cpufreq-cpu0.c b/drivers/cpufreq/cpufreq-cpu0.c
index 2486c13..d8756e7 100644
--- a/drivers/cpufreq/cpufreq-cpu0.c
+++ b/drivers/cpufreq/cpufreq-cpu0.c
@@ -121,24 +121,7 @@ post_notify:
 
 static int cpu0_cpufreq_init(struct cpufreq_policy *policy)
 {
-	int ret;
-
-	ret = cpufreq_table_validate_and_show(policy, freq_table);
-	if (ret) {
-		pr_err("invalid frequency table: %d\n", ret);
-		return ret;
-	}
-
-	policy->cpuinfo.transition_latency = transition_latency;
-
-	/*
-	 * The driver only supports the SMP configuartion where all processors
-	 * share the clock and voltage and clock.  Use cpufreq affected_cpus
-	 * interface to have all CPUs scaled together.
-	 */
-	cpumask_setall(policy->cpus);
-
-	return 0;
+	return cpufreq_generic_init(policy, freq_table, transition_latency);
 }
 
 static struct cpufreq_driver cpu0_cpufreq_driver = {
-- 
1.7.12.rc2.18.g61b472e

