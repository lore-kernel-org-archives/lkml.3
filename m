Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3HUOng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:43:36 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37091 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392Ab3HUOnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:43:33 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Subject: [PATCH 07/14] cpufreq: maple: use cpufreq_generic_init() routine
Date: Wed, 21 Aug 2013 20:12:26 +0530
Message-Id: <ff89c213678230603e6b46a658bc7542b8698707.1377093938.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1377093938.git.viresh.kumar@linaro.org>
References: <cover.1377093938.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use generic cpufreq_generic_init() routine instead of replicating the same code
here.

Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/maple-cpufreq.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/cpufreq/maple-cpufreq.c b/drivers/cpufreq/maple-cpufreq.c
index 45db7a2..2a2532a 100644
--- a/drivers/cpufreq/maple-cpufreq.c
+++ b/drivers/cpufreq/maple-cpufreq.c
@@ -141,16 +141,9 @@ static unsigned int maple_cpufreq_get_speed(unsigned int cpu)
 
 static int maple_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
-	policy->cpuinfo.transition_latency = 12000;
-	/* secondary CPUs are tied to the primary one by the
-	 * cpufreq core if in the secondary policy we tell it that
-	 * it actually must be one policy together with all others. */
-	cpumask_setall(policy->cpus);
-
-	return cpufreq_table_validate_and_show(policy, maple_cpu_freqs);
+	return cpufreq_generic_init(policy, maple_cpu_freqs, 12000);
 }
 
-
 static struct cpufreq_driver maple_cpufreq_driver = {
 	.name		= "maple",
 	.flags		= CPUFREQ_CONST_LOOPS,
-- 
1.7.12.rc2.18.g61b472e

