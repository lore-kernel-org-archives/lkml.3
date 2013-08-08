Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965346Ab3HHNug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:50:36 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45359 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934171Ab3HHNu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:50:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 13/35] cpufreq: elanfreq: use cpufreq_table_validate_and_show()
Date: Thu,  8 Aug 2013 19:18:15 +0530
Message-Id: <ebbe3ba20c4c600c20650e1eb10eae29e4beefaa.1375964117.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375964117.git.viresh.kumar@linaro.org>
References: <cover.1375964117.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use cpufreq_table_validate_and_show() instead of calling
cpufreq_frequency_table_cpuinfo() and cpufreq_frequency_table_get_attr().

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/elanfreq.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/cpufreq/elanfreq.c b/drivers/cpufreq/elanfreq.c
index 823a400..4000c34 100644
--- a/drivers/cpufreq/elanfreq.c
+++ b/drivers/cpufreq/elanfreq.c
@@ -202,7 +202,6 @@ static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 {
 	struct cpuinfo_x86 *c = &cpu_data(0);
 	unsigned int i;
-	int result;
 
 	/* capability check */
 	if ((c->x86_vendor != X86_VENDOR_AMD) ||
@@ -223,12 +222,7 @@ static int elanfreq_cpu_init(struct cpufreq_policy *policy)
 	policy->cpuinfo.transition_latency = CPUFREQ_ETERNAL;
 	policy->cur = elanfreq_get_cpu_frequency(0);
 
-	result = cpufreq_frequency_table_cpuinfo(policy, elanfreq_table);
-	if (result)
-		return result;
-
-	cpufreq_frequency_table_get_attr(elanfreq_table, policy->cpu);
-	return 0;
+	return cpufreq_table_validate_and_show(policy, elanfreq_table);
 }
 
 
-- 
1.7.12.rc2.18.g61b472e

