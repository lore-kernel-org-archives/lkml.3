Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3FEQB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:01:56 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:34059 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756384Ab3FEQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:01:53 -0400
Message-ID: <51AF60EE.2080909@semaphore.gr>
Date: Wed, 05 Jun 2013 19:01:50 +0300
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Viresh Kumar <viresh.kumar@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>,
        linux-pm@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 3/3] cpufreq: Remove unused function __cpufreq_driver_getavg
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculation of target frequency in ondemand governor changed and it is
independent from measured average frequency.

Remove unused__cpufreq_driver_getavg function and getavg member from
cpufreq_driver struct.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq.c | 12 ------------
 include/linux/cpufreq.h   |  6 ------
 2 files changed, 18 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index f8c2860..a61aacb 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1584,18 +1584,6 @@ fail:
 }
 EXPORT_SYMBOL_GPL(cpufreq_driver_target);
 
-int __cpufreq_driver_getavg(struct cpufreq_policy *policy, unsigned int cpu)
-{
-	if (cpufreq_disabled())
-		return 0;
-
-	if (!cpufreq_driver->getavg)
-		return 0;
-
-	return cpufreq_driver->getavg(policy, cpu);
-}
-EXPORT_SYMBOL_GPL(__cpufreq_driver_getavg);
-
 /*
  * when "event" is CPUFREQ_GOV_LIMITS
  */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index d939056..50f19ad 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -215,10 +215,6 @@ extern int __cpufreq_driver_target(struct cpufreq_policy *policy,
 				   unsigned int target_freq,
 				   unsigned int relation);
 
-
-extern int __cpufreq_driver_getavg(struct cpufreq_policy *policy,
-				   unsigned int cpu);
-
 int cpufreq_register_governor(struct cpufreq_governor *governor);
 void cpufreq_unregister_governor(struct cpufreq_governor *governor);
 
@@ -258,8 +254,6 @@ struct cpufreq_driver {
 	unsigned int	(*get)	(unsigned int cpu);
 
 	/* optional */
-	unsigned int (*getavg)	(struct cpufreq_policy *policy,
-				 unsigned int cpu);
 	int	(*bios_limit)	(int cpu, unsigned int *limit);
 
 	int	(*exit)		(struct cpufreq_policy *policy);
-- 
1.8.1.4

