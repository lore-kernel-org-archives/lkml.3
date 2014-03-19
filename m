Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbaCSVmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:42:08 -0400
Received: from sema.semaphore.gr ([78.46.194.137]:45158 "EHLO
	sema.semaphore.gr" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750934AbaCSVmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:42:06 -0400
Message-ID: <532A0D0C.50507@semaphore.gr>
Date: Wed, 19 Mar 2014 23:33:00 +0200
From: Stratos Karafotis <stratosk@semaphore.gr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpufreq: Remove unnecessary braces
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove 3 sets of unnecessary braces

Signed-off-by: Stratos Karafotis <stratosk@semaphore.gr>
---
 drivers/cpufreq/cpufreq.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1eafd8c..ca3c01f 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1325,17 +1325,16 @@ static int __cpufreq_remove_dev_prepare(struct device *dev,
 	cpus = cpumask_weight(policy->cpus);
 	up_read(&policy->rwsem);
 
-	if (cpu != policy->cpu) {
+	if (cpu != policy->cpu)
 		sysfs_remove_link(&dev->kobj, "cpufreq");
-	} else if (cpus > 1) {
+	else if (cpus > 1) {
 		new_cpu = cpufreq_nominate_new_policy_cpu(policy, cpu);
 		if (new_cpu >= 0) {
 			update_policy_cpu(policy, new_cpu);
 
-			if (!cpufreq_suspended) {
+			if (!cpufreq_suspended)
 				pr_debug("%s: policy Kobject moved to cpu: %d from: %d\n",
 					 __func__, new_cpu, cpu);
-			}
 		}
 	}
 
@@ -2158,11 +2157,9 @@ int cpufreq_update_policy(unsigned int cpu)
 		if (!policy->cur) {
 			pr_debug("Driver did not initialize current freq\n");
 			policy->cur = new_policy.cur;
-		} else {
-			if (policy->cur != new_policy.cur && has_target())
+		} else if (policy->cur != new_policy.cur && has_target())
 				cpufreq_out_of_sync(cpu, policy->cur,
 								new_policy.cur);
-		}
 	}
 
 	ret = cpufreq_set_policy(policy, &new_policy);
-- 
1.8.5.3
