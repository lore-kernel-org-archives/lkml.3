Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913Ab3HNNlH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:41:07 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:33994 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab3HNNfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:35:02 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 17/37] cpufreq: integrator: don't initialize part of policy that is set by core too
Date: Wed, 14 Aug 2013 19:02:06 +0530
Message-Id: <9f337589aed2e258907bf1fd3de5ff87d02aaa12.1376486713.git.viresh.kumar@linaro.org>
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

Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/integrator-cpufreq.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/integrator-cpufreq.c b/drivers/cpufreq/integrator-cpufreq.c
index f7c99df..6391dd3 100644
--- a/drivers/cpufreq/integrator-cpufreq.c
+++ b/drivers/cpufreq/integrator-cpufreq.c
@@ -186,10 +186,9 @@ static int integrator_cpufreq_init(struct cpufreq_policy *policy)
 {
 
 	/* set default policy and cpuinfo */
-	policy->cpuinfo.max_freq = 160000;
-	policy->cpuinfo.min_freq = 12000;
+	policy->max = policy->cpuinfo.max_freq = 160000;
+	policy->min = policy->cpuinfo.min_freq = 12000;
 	policy->cpuinfo.transition_latency = 1000000; /* 1 ms, assumed */
-	policy->cur = policy->min = policy->max = integrator_get(policy->cpu);
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

