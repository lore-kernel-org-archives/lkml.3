Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3ILMEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 08:04:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:50086 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3ILMEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 08:04:11 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH] cpufreq: Detect spurious invocations of update_policy_cpu()
To: rjw@sisk.pl, viresh.kumar@linaro.org, swarren@wwwdotorg.org
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 12 Sep 2013 17:29:09 +0530
Message-ID: <20130912115710.25951.98497.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091212-0928-0000-0000-000001A196BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function update_policy_cpu() is expected to be called when the policy->cpu
of a cpufreq policy is to be changed: ie., the new CPU nominated to become the
policy->cpu is different from the old one.

Print a warning if it is invoked with new_cpu == old_cpu, since such an
invocation might hint at a faulty logic in the caller.

Suggested-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 43c24aa..2084132 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -949,7 +949,7 @@ static void cpufreq_policy_free(struct cpufreq_policy *policy)
 
 static void update_policy_cpu(struct cpufreq_policy *policy, unsigned int cpu)
 {
-	if (cpu == policy->cpu)
+	if (WARN_ON(cpu == policy->cpu))
 		return;
 
 	policy->last_cpu = policy->cpu;

