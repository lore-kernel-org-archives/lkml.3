Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab3IMOIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 10:08:45 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48277 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab3IMNGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:06:38 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 030/228] cpufreq: p4-clockmod: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:36 +0530
Message-Id: <1476114c469dd7b3b3a4e793c7c04441021fd315.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/p4-clockmod.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/p4-clockmod.c b/drivers/cpufreq/p4-clockmod.c
index 2f0a2a6..03478bf 100644
--- a/drivers/cpufreq/p4-clockmod.c
+++ b/drivers/cpufreq/p4-clockmod.c
@@ -230,7 +230,6 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 		else
 			p4clockmod_table[i].frequency = (stock_freq * i)/8;
 	}
-	cpufreq_frequency_table_get_attr(p4clockmod_table, policy->cpu);
 
 	/* cpuinfo and default policy values */
 
@@ -239,7 +238,7 @@ static int cpufreq_p4_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 10000001;
 	policy->cur = stock_freq;
 
-	return cpufreq_frequency_table_cpuinfo(policy, &p4clockmod_table[0]);
+	return cpufreq_table_validate_and_show(policy, &p4clockmod_table[0]);
 }
 
 
-- 
1.7.12.rc2.18.g61b472e

