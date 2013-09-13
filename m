Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933035Ab3IMNN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:13:58 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:45840 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933021Ab3IMNNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:13:54 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 092/228] cpufreq: arm_big_little: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:30:38 +0530
Message-Id: <799a45eb0d50557b20e508e55f98ce2df9e16b76.1379063063.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/arm_big_little.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 132c966..f7717ef 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -171,8 +171,6 @@ static int bL_cpufreq_init(struct cpufreq_policy *policy)
 	else
 		policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 
-	policy->cur = bL_cpufreq_get(policy->cpu);
-
 	cpumask_copy(policy->cpus, topology_core_cpumask(policy->cpu));
 
 	dev_info(cpu_dev, "%s: CPU %d initialized\n", __func__, policy->cpu);
-- 
1.7.12.rc2.18.g61b472e

