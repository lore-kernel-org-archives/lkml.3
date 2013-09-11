Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3IKM7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:59:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:33376 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab3IKM7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:59:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,884,1371106800"; 
   d="scan'208";a="376589800"
From: tianyu.lan@intel.com
To: rjw@sisk.pl, viresh.kumar@linaro.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Cpufreq/governor: Remove fossil comment
Date: Wed, 11 Sep 2013 20:49:57 +0800
Message-Id: <1378903797-6350-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lan Tianyu <tianyu.lan@intel.com>

cpufreq_set_policy() has been changed to origin __cpufreq_set_policy()
and policy->lock has been converted to rewrite lock by commit 5a01f2.
So remove the comment.

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
This patch is based on patch "cpufreq: rename __cpufreq_set_policy()
as cpufreq_set_policy()."
http://marc.info/?l=linux-kernel&m=137889464210638&w=2

 drivers/cpufreq/cpufreq_userspace.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index 0307809..4dbf1db 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -38,18 +38,7 @@ static int cpufreq_set(struct cpufreq_policy *policy, unsigned int freq)
 	if (!per_cpu(cpu_is_managed, policy->cpu))
 		goto err;
 
-	/*
-	 * We're safe from concurrent calls to ->target() here
-	 * as we hold the userspace_mutex lock. If we were calling
-	 * cpufreq_driver_target, a deadlock situation might occur:
-	 * A: cpufreq_set (lock userspace_mutex) ->
-	 *      cpufreq_driver_target(lock policy->lock)
-	 * B: cpufreq_set_policy(lock policy->lock) ->
-	 *      __cpufreq_governor ->
-	 *         cpufreq_governor_userspace (lock userspace_mutex)
-	 */
 	ret = __cpufreq_driver_target(policy, freq, CPUFREQ_RELATION_L);
-
  err:
 	mutex_unlock(&userspace_mutex);
 	return ret;
-- 
1.8.4.rc0.1.g8f6a3e5.dirty

