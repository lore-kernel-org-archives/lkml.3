Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968380Ab3HJGuB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:50:01 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55798 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968279Ab3HJGt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:49:58 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 17/44] cpufreq: e_powersaver: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:13 +0530
Message-Id: <6afdf05679248ea6292a40ae4364e01ea4d2cad4.1376116345.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/e_powersaver.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index c1b7c99..a8cbbd0 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -198,12 +198,6 @@ static int eps_target(struct cpufreq_policy *policy,
 	return ret;
 }
 
-static int eps_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy,
-			&eps_cpu[policy->cpu]->freq_table[0]);
-}
-
 static int eps_cpu_init(struct cpufreq_policy *policy)
 {
 	unsigned int i;
@@ -423,19 +417,14 @@ static int eps_cpu_exit(struct cpufreq_policy *policy)
 	return 0;
 }
 
-static struct freq_attr *eps_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
 static struct cpufreq_driver eps_driver = {
-	.verify		= eps_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= eps_target,
 	.init		= eps_cpu_init,
 	.exit		= eps_cpu_exit,
 	.get		= eps_get,
 	.name		= "e_powersaver",
-	.attr		= eps_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 
-- 
1.7.12.rc2.18.g61b472e

