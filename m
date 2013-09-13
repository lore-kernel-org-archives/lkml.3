Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab3IMNQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:16:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:33621 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab3IMNQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:16:24 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 113/228] cpufreq: pcc: don't initialize part of policy that is set by core too
Date: Fri, 13 Sep 2013 18:30:59 +0530
Message-Id: <980fc9e44953ea5b8d13284ae62a8f2c00130453.1379063063.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/pcc-cpufreq.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/cpufreq/pcc-cpufreq.c b/drivers/cpufreq/pcc-cpufreq.c
index 78787e9..ef66347 100644
--- a/drivers/cpufreq/pcc-cpufreq.c
+++ b/drivers/cpufreq/pcc-cpufreq.c
@@ -559,13 +559,6 @@ static int pcc_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		ioread32(&pcch_hdr->nominal) * 1000;
 	policy->min = policy->cpuinfo.min_freq =
 		ioread32(&pcch_hdr->minimum_frequency) * 1000;
-	policy->cur = pcc_get_freq(cpu);
-
-	if (!policy->cur) {
-		pr_debug("init: Unable to get current CPU frequency\n");
-		result = -EINVAL;
-		goto out;
-	}
 
 	pr_debug("init: policy->max is %d, policy->min is %d\n",
 		policy->max, policy->min);
-- 
1.7.12.rc2.18.g61b472e

