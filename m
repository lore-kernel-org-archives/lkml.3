Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965516Ab3HHNvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:51:03 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:55673 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965502Ab3HHNu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:50:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH 17/35] cpufreq: kirkwood: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:19 +0530
Message-Id: <8b7f30f52b99c21697168d77f1fae298dad50226.1375964117.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/kirkwood-cpufreq.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 45e4d7f..336f171 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -125,19 +125,11 @@ static int kirkwood_cpufreq_target(struct cpufreq_policy *policy,
 /* Module init and exit code */
 static int kirkwood_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
-	int result;
-
 	/* cpuinfo and default policy values */
 	policy->cpuinfo.transition_latency = 5000; /* 5uS */
 	policy->cur = kirkwood_cpufreq_get_cpu_frequency(0);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, kirkwood_freq_table);
-	if (result)
-		return result;
-
-	cpufreq_frequency_table_get_attr(kirkwood_freq_table, policy->cpu);
-
-	return 0;
+	return cpufreq_table_validate_and_show(policy, kirkwood_freq_table);
 }
 
 static int kirkwood_cpufreq_cpu_exit(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

