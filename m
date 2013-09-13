Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab3IMNIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:08:07 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:59855 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757645Ab3IMNIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:08:01 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 042/228] cpufreq: sparc: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:48 +0530
Message-Id: <454f6bb0c5fa53654e694c82db6ca758410826f5.1379063063.git.viresh.kumar@linaro.org>
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
Cc: sparclinux@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sparc-us2e-cpufreq.c | 6 +-----
 drivers/cpufreq/sparc-us3-cpufreq.c  | 7 +------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 80e6d92..e35840d 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -307,7 +307,6 @@ static int __init us2e_freq_cpu_init(struct cpufreq_policy *policy)
 	unsigned long clock_tick = sparc64_get_clock_tick(cpu) / 1000;
 	struct cpufreq_frequency_table *table =
 		&us2e_freq_table[cpu].table[0];
-	int ret;
 
 	table[0].driver_data = 0;
 	table[0].frequency = clock_tick / 1;
@@ -325,10 +324,7 @@ static int __init us2e_freq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, table);
-	if (!ret)
-		cpufreq_frequency_table_get_attr(table, policy->cpu);
-	return ret;
+	return cpufreq_table_validate_and_show(policy, table);
 }
 
 static int us2e_freq_cpu_exit(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index 73a90de..23f2d3b 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -168,7 +168,6 @@ static int __init us3_freq_cpu_init(struct cpufreq_policy *policy)
 	unsigned long clock_tick = sparc64_get_clock_tick(cpu) / 1000;
 	struct cpufreq_frequency_table *table =
 		&us3_freq_table[cpu].table[0];
-	int ret;
 
 	table[0].driver_data = 0;
 	table[0].frequency = clock_tick / 1;
@@ -182,11 +181,7 @@ static int __init us3_freq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, table);
-	if (!ret)
-		cpufreq_frequency_table_get_attr(table, policy->cpu);
-
-	return ret;
+	return cpufreq_table_validate_and_show(policy, table);
 }
 
 static int us3_freq_cpu_exit(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

