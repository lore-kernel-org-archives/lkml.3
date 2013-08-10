Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031879Ab3HJGuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 02:50:09 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40196 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968279Ab3HJGuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 02:50:04 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 18/44] cpufreq: elanfreq: Use generic cpufreq routines
Date: Sat, 10 Aug 2013 12:14:14 +0530
Message-Id: <adefd9c73e0ad25f9f80e747727010ff590a4b5e.1376116345.git.viresh.kumar@linaro.org>
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
 drivers/cpufreq/elanfreq.c | 32 +++-----------------------------
 1 file changed, 3 insertions(+), 29 deletions(-)

diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index 4000c34..fe7053c 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -165,19 +165,6 @@ static void elanfreq_set_cpu_state(struct cpufreq_policy *policy,
 };
 
 
-/**
- *	elanfreq_validatespeed: test if frequency range is valid
- *	@policy: the policy to validate
- *
- *	This function checks if a given frequency range in kHz is valid
- *	for the hardware supported by the driver.
- */
-
-static int elanfreq_verify(struct cpufreq_policy *policy)
-{
-	return cpufreq_frequency_table_verify(policy, &elanfreq_table[0]);
-}
-
 static int elanfreq_target(struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
@@ -226,13 +213,6 @@ static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 }
 
 
-static int elanfreq_cpu_exit(struct cpufreq_policy *policy)
-{
-	cpufreq_frequency_table_put_attr(policy->cpu);
-	return 0;
-}
-
-
 #ifndef MODULE
 /**
  * elanfreq_setup - elanfreq command line parameter parsing
@@ -255,20 +235,14 @@ __setup("elanfreq=", elanfreq_setup);
 #endif
 
 
-static struct freq_attr *elanfreq_attr[] = {
-	&cpufreq_freq_attr_scaling_available_freqs,
-	NULL,
-};
-
-
 static struct cpufreq_driver elanfreq_driver = {
 	.get		= elanfreq_get_cpu_frequency,
-	.verify		= elanfreq_verify,
+	.verify		= cpufreq_generic_frequency_table_verify,
 	.target		= elanfreq_target,
 	.init		= elanfreq_cpu_init,
-	.exit		= elanfreq_cpu_exit,
+	.exit		= cpufreq_generic_exit,
 	.name		= "elanfreq",
-	.attr		= elanfreq_attr,
+	.attr		= cpufreq_generic_attr,
 };
 
 static const struct x86_cpu_id elan_id[] = {
-- 
1.7.12.rc2.18.g61b472e

