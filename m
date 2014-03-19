Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbaCSVhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:37:09 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:45139 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750934AbaCSVhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:37:06 -0400
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 17:37:06 EDT
Message-ID: <532A0C2D.9010600@semaphore.gr>
Date: Wed, 19 Mar 2014 23:29:17 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: Fix checkpatch errors and warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 2 checkpatch errors about using assignment in if condition,
1 checkpatch error about a required space after comma
and 3 warnings about line over 80 characters.

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index e3aa9de..1eafd8c 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -939,8 +939,10 @@ static int cpufreq_add_policy_cpu(struct cpufreq_policy *policy,
 	up_write(&policy->rwsem);
 
 	if (has_target()) {
-		if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
-			(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
+		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
+		if (!ret)
+			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
+		if (ret) {
 			pr_err("%s: Failed to start governor\n", __func__);
 			return ret;
 		}
@@ -1394,14 +1396,13 @@ static int __cpufreq_remove_dev_finish(struct device *dev,
 
 		if (!cpufreq_suspended)
 			cpufreq_policy_free(policy);
-	} else {
-		if (has_target()) {
-			if ((ret = __cpufreq_governor(policy, CPUFREQ_GOV_START)) ||
-					(ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS))) {
-				pr_err("%s: Failed to start governor\n",
-				       __func__);
-				return ret;
-			}
+	} else if (has_target()) {
+		ret = __cpufreq_governor(policy, CPUFREQ_GOV_START);
+		if (!ret)
+			ret = __cpufreq_governor(policy, CPUFREQ_GOV_LIMITS);
+		if (ret) {
+			pr_err("%s: Failed to start governor\n", __func__);
+			return ret;
 		}
 	}
 
@@ -2086,7 +2087,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	if (old_gov) {
 		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
 		up_write(&policy->rwsem);
-		__cpufreq_governor(policy,CPUFREQ_GOV_POLICY_EXIT);
+		__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
 		down_write(&policy->rwsem);
 	}
 
-- 
1.8.5.3

