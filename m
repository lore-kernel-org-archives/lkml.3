Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031937Ab3HJGuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:50:51 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:41310 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031905Ab3HJGur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:50:47 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        John Crispin <blogic@openwrt.org>
Subject: [PATCH 24/44] cpufreq: loongson2: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:20 +0530
Message-Id: <e0e54e576a372b17f485d3ab2bb6a6fde33e71c6.1376116345.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376116344.git.viresh.kumar@linaro.org>
References: <cover.1376116344.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of the CPUFreq drivers do similar things in .exit() and .verify() routines
and .attr. So its better if we have generic routines for them which can be used
by cpufreq drivers then.

This patch uses these generic routines for this driver.

Cc: John Crispin <blogic@openwrt.org>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/loongson2_cpufreq.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/loongson2_cpufreq.c b/drivers/cpufreq/loongson2_cpufreq.c
index cec4e72..ed7fbe2 100644
--- a/drivers/cpufreq/loongson2_cpufreq.c
+++ b/drivers/cpufreq/loongson2_cpufreq.c
@@ -137,12 +137,6 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 					    &loongson2_clockmod_table[0]);
 }
 
-static int loongson2_cpufreq_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy,
-					      &loongson2_clockmod_table[0]);
-}
-
 static int loongson2_cpufreq_exit(struct cpufreq_policy *policy)
 {
 	cpufreq_frequency_table_put_attr(policy->cpu);
@@ -150,19 +144,14 @@ static int loongson2_cpufreq_exit(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static struct freq_attr *loongson2_table_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver loongson2_cpufreq_driver = {
 	.name = "loongson2",
 	.init = loongson2_cpufreq_cpu_init,
-	.verify = loongson2_cpufreq_verify,
+	.verify = cpufreq_generic_frequency_table_verify,
 	.target = loongson2_cpufreq_target,
 	.get = loongson2_cpufreq_get,
 	.exit = loongson2_cpufreq_exit,
-	.attr = loongson2_table_attr,
+	.attr = cpufreq_generic_attr,
 };
 
 static struct platform_device_id platform_device_ids[] = {
-- 
1.7.12.rc2.18.g61b472e

