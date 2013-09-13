Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933351Ab3IMNQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:16:50 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64095 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932249Ab3IMNQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:16:46 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 116/228] cpufreq: ppc: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:31:02 +0530
Message-Id: <bb32c408741e1008c39ce62ec03bc76e5ccaa267.1379063063.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/ppc-corenet-cpufreq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cpufreq/ppc-corenet-cpufreq.c b/drivers/cpufreq/ppc-corenet-cpufreq.c
index befd489..a0f562c 100644
--- a/drivers/cpufreq/ppc-corenet-cpufreq.c
+++ b/drivers/cpufreq/ppc-corenet-cpufreq.c
@@ -217,8 +217,6 @@ static int corenet_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		per_cpu(cpu_data, i) = data;
 
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
-	policy->cur = corenet_cpufreq_get_speed(policy->cpu);
-
 	of_node_put(np);
 
 	return 0;
-- 
1.7.12.rc2.18.g61b472e

