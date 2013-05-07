Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab3EGPU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 11:20:59 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:60370 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab3EGPU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 11:20:56 -0400
From: dirk.brandewie@gmail.com
To: rjw@sisk.pl, linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 5/6] cpufreq/intel_pstate: Remove unused code
Date: Tue,  7 May 2013 08:20:29 -0700
Message-Id: <1367940030-19311-6-git-send-email-dirk.j.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
References: <1367940030-19311-1-git-send-email-dirk.j.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Remove call to intel_pstate_get_min_max() the values returned are not
used.

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index fc9b187..c7bd91f 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -579,15 +579,12 @@ static unsigned int intel_pstate_get(unsigned int cpu_num)
 static int intel_pstate_set_policy(struct cpufreq_policy *policy)
 {
 	struct cpudata *cpu;
-	int min, max;
 
 	cpu = all_cpu_data[policy->cpu];
 
 	if (!policy->cpuinfo.max_freq)
 		return -ENODEV;
 
-	intel_pstate_get_min_max(cpu, &min, &max);
-
 	limits.min_perf_pct = (policy->min * 100) / policy->cpuinfo.max_freq;
 	limits.min_perf_pct = clamp_t(int, limits.min_perf_pct, 0 , 100);
 	limits.min_perf = div_fp(int_tofp(limits.min_perf_pct), int_tofp(100));
-- 
1.7.7.6

