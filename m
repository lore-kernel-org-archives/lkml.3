Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933506AbaBUN5p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:57:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46779 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbaBUMte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:49:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Zhang, Xiong Y" <xiong.y.zhang@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 018/121] intel_pstate: Correct calculation of min pstate value
Date: Fri, 21 Feb 2014 12:47:22 +0000
Message-Id: <1392986945-9693-19-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 7244cb62d96e735847dc9d08f870550df896898c upstream.

The minimum pstate is supposed to be a percentage of the maximum P
state available.  Calculate min using max pstate and not the
current max which may have been limited by the user

Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Zhang, Xiong Y <xiong.y.zhang@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 50392ac..e52e542 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -366,12 +366,13 @@ static int intel_pstate_turbo_pstate(void)
 static void intel_pstate_get_min_max(struct cpudata *cpu, int *min, int *max)
 {
 	int max_perf = cpu->pstate.turbo_pstate;
+	int max_perf_adj;
 	int min_perf;
 	if (limits.no_turbo)
 		max_perf = cpu->pstate.max_pstate;
 
-	max_perf = fp_toint(mul_fp(int_tofp(max_perf), limits.max_perf));
-	*max = clamp_t(int, max_perf,
+	max_perf_adj = fp_toint(mul_fp(int_tofp(max_perf), limits.max_perf));
+	*max = clamp_t(int, max_perf_adj,
 			cpu->pstate.min_pstate, cpu->pstate.turbo_pstate);
 
 	min_perf = fp_toint(mul_fp(int_tofp(max_perf), limits.min_perf));
-- 
1.9.0

