Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883Ab3HNNfS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:35:18 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39770 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab3HNNfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:35:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 19/37] cpufreq: longhaul: don't initialize part of policy that is set by core too
Date: Wed, 14 Aug 2013 19:02:08 +0530
Message-Id: <04c2fe3a595a11096e89a886b5271951bbe28f47.1376486713.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/longhaul.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/longhaul.c b/drivers/cpufreq/longhaul.c
index e566776..45bafdd 100644
--- a/drivers/cpufreq/longhaul.c
+++ b/drivers/cpufreq/longhaul.c
@@ -904,7 +904,6 @@ static int longhaul_cpu_init(struct cpufreq_policy *policy)
 		longhaul_setup_voltagescaling();
 
 	policy->cpuinfo.transition_latency = 200000;	/* nsec */
-	policy->cur = calc_speed(longhaul_get_cpu_mult());
 
 	return cpufreq_table_validate_and_show(policy, longhaul_table);
 }
-- 
1.7.12.rc2.18.g61b472e

