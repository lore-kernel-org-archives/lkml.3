Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447Ab3HUOnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:43:45 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52931 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424Ab3HUOnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:43:41 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 08/14] cpufreq: pasemi: use cpufreq_generic_init() routine
Date: Wed, 21 Aug 2013 20:12:27 +0530
Message-Id: <8a509e8c318a77779f8fef0e1c88a44a4b912a2a.1377093938.git.viresh.kumar@linaro.org>
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

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/pasemi-cpufreq.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/cpufreq/pasemi-cpufreq.c b/drivers/cpufreq/pasemi-cpufreq.c
index 4d69958..1c33136 100644
--- a/drivers/cpufreq/pasemi-cpufreq.c
+++ b/drivers/cpufreq/pasemi-cpufreq.c
@@ -202,20 +202,13 @@ static int pas_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		pr_debug("%d: %d\n", i, pas_freqs[i].frequency);
 	}
 
-	policy->cpuinfo.transition_latency = get_gizmo_latency();
-
 	cur_astate = get_cur_astate(policy->cpu);
 	pr_debug("current astate is at %d\n",cur_astate);
 
 	policy->cur = pas_freqs[cur_astate].frequency;
-	cpumask_copy(policy->cpus, cpu_online_mask);
-
 	ppc_proc_freq = policy->cur * 1000ul;
 
-	/* this ensures that policy->cpuinfo_min and policy->cpuinfo_max
-	 * are set correctly
-	 */
-	return cpufreq_table_validate_and_show(policy, pas_freqs);
+	return cpufreq_generic_init(policy, pas_freqs, get_gizmo_latency());
 
 out_unmap_sdcpwr:
 	iounmap(sdcpwr_mapbase);
-- 
1.7.12.rc2.18.g61b472e

