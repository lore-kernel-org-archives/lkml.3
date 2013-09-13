Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3IMNIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 09:08:20 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41695 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab3IMNIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 09:08:15 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 044/228] cpufreq: speedstep: use cpufreq_table_validate_and_show()
Date: Fri, 13 Sep 2013 18:29:50 +0530
Message-Id: <9013bee8cd8d799dabdf630317285947f2bdbcf9.1379063063.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/speedstep-centrino.c | 10 +---------
 drivers/cpufreq/speedstep-ich.c      |  9 +--------
 drivers/cpufreq/speedstep-smi.c      |  8 +-------
 3 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/drivers/cpufreq/speedstep-centrino.c b/drivers/cpufreq/speedstep-centrino.c
index f897d51..f180561 100644
--- a/drivers/cpufreq/speedstep-centrino.c
+++ b/drivers/cpufreq/speedstep-centrino.c
@@ -345,7 +345,6 @@ static int centrino_cpu_init(struct cpufreq_policy *policy)
 	struct cpuinfo_x86 *cpu = &cpu_data(policy->cpu);
 	unsigned freq;
 	unsigned l, h;
-	int ret;
 	int i;
 
 	/* Only Intel makes Enhanced Speedstep-capable CPUs */
@@ -402,15 +401,8 @@ static int centrino_cpu_init(struct cpufreq_policy *policy)
 
 	pr_debug("centrino_cpu_init: cur=%dkHz\n", policy->cur);
 
-	ret = cpufreq_frequency_table_cpuinfo(policy,
+	return cpufreq_table_validate_and_show(policy,
 		per_cpu(centrino_model, policy->cpu)->op_points);
-	if (ret)
-		return (ret);
-
-	cpufreq_frequency_table_get_attr(
-		per_cpu(centrino_model, policy->cpu)->op_points, policy->cpu);
-
-	return 0;
 }
 
 static int centrino_cpu_exit(struct cpufreq_policy *policy)
diff --git a/drivers/cpufreq/speedstep-ich.c b/drivers/cpufreq/speedstep-ich.c
index 5355abb..86a184e 100644
--- a/drivers/cpufreq/speedstep-ich.c
+++ b/drivers/cpufreq/speedstep-ich.c
@@ -320,7 +320,6 @@ static void get_freqs_on_cpu(void *_get_freqs)
 
 static int speedstep_cpu_init(struct cpufreq_policy *policy)
 {
-	int result;
 	unsigned int policy_cpu, speed;
 	struct get_freqs gf;
 
@@ -349,13 +348,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 	/* cpuinfo and default policy values */
 	policy->cur = speed;
 
-	result = cpufreq_frequency_table_cpuinfo(policy, speedstep_freqs);
-	if (result)
-		return result;
-
-	cpufreq_frequency_table_get_attr(speedstep_freqs, policy->cpu);
-
-	return 0;
+	return cpufreq_table_validate_and_show(policy, speedstep_freqs);
 }
 
 
diff --git a/drivers/cpufreq/speedstep-smi.c b/drivers/cpufreq/speedstep-smi.c
index abfba4f..f4d0318 100644
--- a/drivers/cpufreq/speedstep-smi.c
+++ b/drivers/cpufreq/speedstep-smi.c
@@ -329,13 +329,7 @@ static int speedstep_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	policy->cur = speed;
 
-	result = cpufreq_frequency_table_cpuinfo(policy, speedstep_freqs);
-	if (result)
-		return result;
-
-	cpufreq_frequency_table_get_attr(speedstep_freqs, policy->cpu);
-
-	return 0;
+	return cpufreq_table_validate_and_show(policy, speedstep_freqs);
 }
 
 static int speedstep_cpu_exit(struct cpufreq_policy *policy)
-- 
1.7.12.rc2.18.g61b472e

