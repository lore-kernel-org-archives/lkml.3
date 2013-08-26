Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab3HZShe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 14:37:34 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:44468 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752122Ab3HZShd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 14:37:33 -0400
Message-ID: <521BA068.8030003@semaphore.gr>
Date: Mon, 26 Aug 2013 21:37:28 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>
CC: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: governors: Remove duplicate check of target freq
 in supported range
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function __cpufreq_driver_target checks if target_freq is within
policy->min and policy->max range. generic_powersave_bias_target also
checks if target_freq is valid through cpufreq_frequency_table_target
call. So, drop the unnecessary duplicate check in *_check_cpu functions.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq_conservative.c | 4 ----
 drivers/cpufreq/cpufreq_ondemand.c     | 3 ---
 2 files changed, 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 7f67a75..f62d822 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -67,8 +67,6 @@ static void cs_check_cpu(int cpu, unsigned int load)
 			return;
 
 		dbs_info->requested_freq += get_freq_target(cs_tuners, policy);
-		if (dbs_info->requested_freq > policy->max)
-			dbs_info->requested_freq = policy->max;
 
 		__cpufreq_driver_target(policy, dbs_info->requested_freq,
 			CPUFREQ_RELATION_H);
@@ -89,8 +87,6 @@ static void cs_check_cpu(int cpu, unsigned int load)
 			return;
 
 		dbs_info->requested_freq -= get_freq_target(cs_tuners, policy);
-		if (dbs_info->requested_freq < policy->min)
-			dbs_info->requested_freq = policy->min;
 
 		__cpufreq_driver_target(policy, dbs_info->requested_freq,
 				CPUFREQ_RELATION_L);
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 87f3305..32f26f6 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -177,9 +177,6 @@ static void od_check_cpu(int cpu, unsigned int load)
 		/* No longer fully busy, reset rate_mult */
 		dbs_info->rate_mult = 1;
 
-		if (freq_next < policy->min)
-			freq_next = policy->min;
-
 		if (!od_tuners->powersave_bias) {
 			__cpufreq_driver_target(policy, freq_next,
 					CPUFREQ_RELATION_L);
-- 
1.8.3.1

