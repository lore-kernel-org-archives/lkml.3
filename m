Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab3IMNEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:04:31 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:55049 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab3IMNE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:04:26 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH 012/228] cpufreq: sparc: call cpufreq_frequency_table_get_attr()
Date: Fri, 13 Sep 2013 18:29:18 +0530
Message-Id: <56edbe14da9944ad026497bc1a0dc4aaa283d506.1379063063.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1379063063.git.viresh.kumar@linaro.org>
References: <cover.1379063063.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This exposes frequency table of driver to cpufreq core and is required for core
to guess what the index for a target frequency is, when it calls
cpufreq_frequency_table_target(). And so this driver needs to expose it.

Cc: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/sparc-us2e-cpufreq.c | 6 +++++-
 drivers/cpufreq/sparc-us3-cpufreq.c  | 7 ++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index cf5bc2c..80e6d92 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -307,6 +307,7 @@ static int __init us2e_freq_cpu_init(struct cpufreq_policy *policy)
 	unsigned long clock_tick = sparc64_get_clock_tick(cpu) / 1000;
 	struct cpufreq_frequency_table *table =
 		&us2e_freq_table[cpu].table[0];
+	int ret;
 
 	table[0].driver_data = 0;
 	table[0].frequency = clock_tick / 1;
@@ -324,7 +325,10 @@ static int __init us2e_freq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
 
-	return cpufreq_frequency_table_cpuinfo(policy, table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, table);
+	if (!ret)
+		cpufreq_frequency_table_get_attr(table, policy->cpu);
+	return ret;
 }
 
 static int us2e_freq_cpu_exit(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index ac76b48..73a90de 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -168,6 +168,7 @@ static int __init us3_freq_cpu_init(struct cpufreq_policy *policy)
 	unsigned long clock_tick = sparc64_get_clock_tick(cpu) / 1000;
 	struct cpufreq_frequency_table *table =
 		&us3_freq_table[cpu].table[0];
+	int ret;
 
 	table[0].driver_data = 0;
 	table[0].frequency = clock_tick / 1;
@@ -181,7 +182,11 @@ static int __init us3_freq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = 0;
 	policy->cur = clock_tick;
 
-	return cpufreq_frequency_table_cpuinfo(policy, table);
+	ret = cpufreq_frequency_table_cpuinfo(policy, table);
+	if (!ret)
+		cpufreq_frequency_table_get_attr(table, policy->cpu);
+
+	return ret;
 }
 
 static int us3_freq_cpu_exit(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

