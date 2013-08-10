Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab3HJGtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:49:22 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:58394 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758745Ab3HJGtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:49:16 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Steven Miao <realmz6@gmail.com>
Subject: [PATCH 12/44] cpufreq: blackfin: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:08 +0530
Message-Id: <31c535b3b686faf04ca231c365a212032938cd97.1376116345.git.viresh.kumar@linaro.org>
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

Cc: Steven Miao <realmz6@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/blackfin-cpufreq.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/cpufreq/blackfin-cpufreq.c b/drivers/cpufreq/blackfin-cpufreq.c
index 84d446a..48888cf 100644
--- a/drivers/cpufreq/blackfin-cpufreq.c
+++ b/drivers/cpufreq/blackfin-cpufreq.c
@@ -191,11 +191,6 @@ static int bfin_target(struct cpufreq_policy *policy,
 	return ret;
 }
 
-static int bfin_verify_speed(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, bfin_freq_table);
-}
-
 static int __bfin_cpu_init(struct cpufreq_policy *policy)
 {
 
@@ -213,25 +208,14 @@ static int __bfin_cpu_init(struct cpufreq_policy *policy)
 	return cpufreq_table_validate_and_show(policy, bfin_freq_table);
 }
 
-static int __bfin_cpu_exit(struct cpufreq_policy *policy)
-{
-
-	cpufreq_frequency_table_put_attr(policy->cpu);
-}
-
-static struct freq_attr *bfin_freq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver bfin_driver = {
-	.verify = bfin_verify_speed,
+	.verify = cpufreq_generic_frequency_table_verify,
 	.target = bfin_target,
 	.get = bfin_getfreq_khz,
 	.init = __bfin_cpu_init,
-	.exit = __bfin_cpu_exit,
+	.exit = cpufreq_generic_exit,
 	.name = "bfin cpufreq",
-	.attr = bfin_freq_attr,
+	.attr = cpufreq_generic_attr,
 };
 
 static int __init bfin_cpu_init(void)
-- 
1.7.12.rc2.18.g61b472e

