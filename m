Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161061Ab3HJGwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:52:15 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:52916 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161050Ab3HJGwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:52:10 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: [PATCH 36/44] cpufreq: s5pv210: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:32 +0530
Message-Id: <2cdad5ad539ad2d4a480baee55a26fd60b2074a9.1376116345.git.viresh.kumar@linaro.org>
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

Cc: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/s5pv210-cpufreq.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index c266a7e..0eafc52 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -174,14 +174,6 @@ static void s5pv210_set_refresh(enum s5pv210_dmc_port ch, unsigned long freq)
 	__raw_writel(tmp1, reg);
 }
 
-static int s5pv210_verify_speed(struct cpufreq_policy *policy)
-{
-	if (policy->cpu)
-		return -EINVAL;
-
-	return cpufreq_frequency_table_verify(policy, s5pv210_freq_table);
-}
-
 static unsigned int s5pv210_getspeed(unsigned int cpu)
 {
 	if (cpu)
@@ -603,7 +595,7 @@ static int s5pv210_cpufreq_reboot_notifier_event(struct notifier_block *this,
 
 static struct cpufreq_driver s5pv210_driver = {
 	.flags		= CPUFREQ_STICKY,
-	.verify		= s5pv210_verify_speed,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= s5pv210_target,
 	.get		= s5pv210_getspeed,
 	.init		= s5pv210_cpu_init,
-- 
1.7.12.rc2.18.g61b472e

