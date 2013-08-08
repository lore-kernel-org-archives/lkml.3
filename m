Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965330Ab3HHNts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:49:48 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:56219 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965294Ab3HHNto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:49:44 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH 07/35] cpufreq: blackfin: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:09 +0530
Message-Id: <fb770a8203838709148d692427c2d3ca55327405.1375964117.git.viresh.kumar@linaro.org>
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

Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/blackfin-cpufreq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index ef05978..54c0a0c 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -210,8 +210,7 @@ static int __bfin_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 50000; /* 50us assumed */
 
 	policy->cur = cclk;
-	cpufreq_frequency_table_get_attr(bfin_freq_table, policy->cpu);
-	return cpufreq_frequency_table_cpuinfo(policy, bfin_freq_table);
+	return cpufreq_table_validate_and_show(policy, bfin_freq_table);
 }
 
 static struct freq_attr *bfin_freq_attr[] = {
-- 
1.7.12.rc2.18.g61b472e

