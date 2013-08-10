Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968089Ab3HJGts (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:49:48 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38449 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031866Ab3HJGtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:49:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Sekhar Nori <nsekhar@ti.com>
Subject: [PATCH 15/44] cpufreq: davinci: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:11 +0530
Message-Id: <fa86cf39e75da395fa3446661fd59856d0a61cc7.1376116345.git.viresh.kumar@linaro.org>
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

Cc: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/davinci-cpufreq.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index f67196e..33e9460 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -157,26 +157,15 @@ static int davinci_cpu_init(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static int davinci_cpu_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-	return 0;
-}
-
-static struct freq_attr *davinci_cpufreq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver davinci_driver = {
 	.flags		= CPUFREQ_STICKY,
 	.verify		= davinci_verify_speed,
 	.target		= davinci_target,
 	.get		= davinci_getspeed,
 	.init		= davinci_cpu_init,
-	.exit		= davinci_cpu_exit,
+	.exit		= cpufreq_generic_exit,
 	.name		= "davinci",
-	.attr		= davinci_cpufreq_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 static int __init davinci_cpufreq_probe(struct platform_device *pdev)
-- 
1.7.12.rc2.18.g61b472e

