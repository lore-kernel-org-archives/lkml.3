Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3HTGk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:40:26 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40843 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab3HTGkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:40:22 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/5] cpufreq: remove unnecessary check in __cpufreq_governor()
Date: Tue, 20 Aug 2013 12:08:24 +0530
Message-Id: <609fce7109561fc217544e0ef63d750ea45db1a8.1376979090.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1376979090.git.viresh.kumar@linaro.org>
References: <cover.1376979090.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1376979090.git.viresh.kumar@linaro.org>
References: <cover.1376979090.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to check if event is CPUFREQ_GOV_POLICY_INIT and put governor
module as we are sure event can only be START/STOP here.

And so remove this useless check.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 0302121..b03a851 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1719,8 +1719,6 @@ static int __cpufreq_governor(struct cpufreq_policy *policy,
 	if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
 	    (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
 		mutex_unlock(&cpufreq_governor_lock);
-		if (event == CPUFREQ_GOV_POLICY_INIT)
-			module_put(policy->governor->owner);
 		return -EBUSY;
 	}
 
-- 
1.7.12.rc2.18.g61b472e

