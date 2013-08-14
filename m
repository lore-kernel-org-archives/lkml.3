Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760021Ab3HNNfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 09:35:48 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:60480 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932937Ab3HNNfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 09:35:42 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 23/37] cpufreq: p4: don't initialize part of policy that is set by core too
Date: Wed, 14 Aug 2013 19:02:12 +0530
Message-Id: <89c8a7b58cbbf991eda016b191f7196db200eef4.1376486713.git.viresh.kumar@linaro.org>
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

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/p4-clockmod.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 5a6263e..3c23053 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -220,7 +220,6 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 	/* the transition latency is set to be 1 higher than the maximum
 	 * transition latency of the ondemand governor */
 	policy->cpuinfo.transition_latency = 10000001;
-	policy->cur = stock_freq;
 
 	return cpufreq_table_validate_and_show(policy, &p4clockmod_table[0]);
 }
-- 
1.7.12.rc2.18.g61b472e

