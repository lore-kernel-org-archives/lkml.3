Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932935Ab3HNNfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:35:40 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:33445 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905Ab3HNNff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:35:35 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: [PATCH 22/37] cpufreq: omap: don't initialize part of policy that is set by core too
Date: Wed, 14 Aug 2013 19:02:11 +0530
Message-Id: <d6018ce6b131eb0a56c1df5710c9e4324aa51774.1376486713.git.viresh.kumar@linaro.org>
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

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/omap-cpufreq.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index 69bf7d8..92d45e6 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -146,8 +146,6 @@ static int omap_cpu_init(struct cpufreq_policy *policy)
 		goto fail_ck;
 	}
 
-	policy->cur = omap_getspeed(policy->cpu);
-
 	if (!freq_table)
 		result = opp_init_cpufreq_table(mpu_dev, &freq_table);
 
@@ -163,8 +161,6 @@ static int omap_cpu_init(struct cpufreq_policy *policy)
 	if (result)
 		goto fail_table;
 
-	policy->cur = omap_getspeed(policy->cpu);
-
 	/*
 	 * On OMAP SMP configuartion, both processors share the voltage
 	 * and clock. So both CPUs needs to be scaled together and hence
-- 
1.7.12.rc2.18.g61b472e

