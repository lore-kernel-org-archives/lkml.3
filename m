Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab3IKKRQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:17:16 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:57601 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab3IKKRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:17:11 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/5] cpufreq: rename __cpufreq_set_policy() as cpufreq_set_policy()
Date: Wed, 11 Sep 2013 15:43:08 +0530
Message-Id: <47fe5de177e308bae5035aac60fad8d5d3730c79.1378893296.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1378893296.git.viresh.kumar@linaro.org>
References: <cover.1378893296.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1378893296.git.viresh.kumar@linaro.org>
References: <cover.1378893296.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier there used to be two functions named __cpufreq_set_policy() and
cpufreq_set_policy(), but now we only have a single routine lets name it
cpufreq_set_policy() instead of __cpufreq_set_policy().

This also removes some invalid comments or fixes some incorrect comments.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 5a64f66..749bf06 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -414,7 +414,7 @@ show_one(scaling_min_freq, min);
 show_one(scaling_max_freq, max);
 show_one(scaling_cur_freq, cur);
 
-static int __cpufreq_set_policy(struct cpufreq_policy *policy,
+static int cpufreq_set_policy(struct cpufreq_policy *policy,
 				struct cpufreq_policy *new_policy);
 
 /**
@@ -435,7 +435,7 @@ static ssize_t store_##file_name					\
 	if (ret != 1)							\
 		return -EINVAL;						\
 									\
-	ret = __cpufreq_set_policy(policy, &new_policy);		\
+	ret = cpufreq_set_policy(policy, &new_policy);		\
 	policy->user_policy.object = policy->object;			\
 									\
 	return ret ? ret : count;					\
@@ -493,11 +493,7 @@ static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
 						&new_policy.governor))
 		return -EINVAL;
 
-	/*
-	 * Do not use cpufreq_set_policy here or the user_policy.max
-	 * will be wrongly overridden
-	 */
-	ret = __cpufreq_set_policy(policy, &new_policy);
+	ret = cpufreq_set_policy(policy, &new_policy);
 
 	policy->user_policy.policy = policy->policy;
 	policy->user_policy.governor = policy->governor;
@@ -844,11 +840,11 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
 	int ret = 0;
 
 	memcpy(&new_policy, policy, sizeof(*policy));
-	/* assure that the starting sequence is run in __cpufreq_set_policy */
+	/* assure that the starting sequence is run in cpufreq_set_policy */
 	policy->governor = NULL;
 
 	/* set default policy */
-	ret = __cpufreq_set_policy(policy, &new_policy);
+	ret = cpufreq_set_policy(policy, &new_policy);
 	policy->user_policy.policy = policy->policy;
 	policy->user_policy.governor = policy->governor;
 
@@ -1844,10 +1840,10 @@ int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu)
 EXPORT_SYMBOL(cpufreq_get_policy);
 
 /*
- * data   : current policy.
- * policy : policy to be set.
+ * policy : current policy.
+ * new_policy: policy to be set.
  */
-static int __cpufreq_set_policy(struct cpufreq_policy *policy,
+static int cpufreq_set_policy(struct cpufreq_policy *policy,
 				struct cpufreq_policy *new_policy)
 {
 	int ret = 0, failed = 1;
@@ -1996,7 +1992,7 @@ int cpufreq_update_policy(unsigned int cpu)
 		}
 	}
 
-	ret = __cpufreq_set_policy(policy, &new_policy);
+	ret = cpufreq_set_policy(policy, &new_policy);
 
 	unlock_policy_rwsem_write(cpu);
 
-- 
1.7.12.rc2.18.g61b472e

