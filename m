Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422796Ab3CVRvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:51:19 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54948 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422678Ab3CVRvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:51:17 -0400
X-Greylist: delayed 170543 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Mar 2013 13:51:16 EDT
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH] cpufreq/intel_pstate: Fix calculation of current frequency
Date: Fri, 22 Mar 2013 10:51:05 -0700
Message-Id: <1363974665-22049-1-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Use the correct pstate value to calculate the effective frequency.

https://bugzilla.redhat.com/show_bug.cgi?id=923942
Reported-by: Satish Balay <balay@fastmail.fm>

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index e84af66..ad72922 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -454,7 +454,7 @@ static inline void intel_pstate_calc_busy(struct cpudata *cpu,
 					sample->idletime_us * 100,
 					sample->duration_us);
 	core_pct = div64_u64(sample->aperf * 100, sample->mperf);
-	sample->freq = cpu->pstate.turbo_pstate * core_pct * 1000;
+	sample->freq = cpu->pstate.max_pstate * core_pct * 1000;
 
 	sample->core_pct_busy = div_s64((sample->pstate_pct_busy * core_pct),
 					100);
-- 
1.7.7.6

