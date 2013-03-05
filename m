Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab3CEWPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:15:47 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:50111 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab3CEWPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:15:40 -0500
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Cc: konrad.wilk@oracle.com, jwboyer@redhat.com,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 1/2] cpufreq/intel_pstate: Do not load on VM that do not report max P state.
Date: Tue,  5 Mar 2013 14:15:26 -0800
Message-Id: <1362521727-20666-2-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1362521727-20666-1-git-send-email-dirk.brandewie@gmail.com>
References: <1362521727-20666-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

It seems some VMs support the P state MSRs but return zeros. Fail
gracefully if we are running in this environment.

https://bugzilla.redhat.com/show_bug.cgi?id=916833

Reported-by: jwboyer@redhat.com
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 drivers/cpufreq/intel_pstate.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 096fde0..2bfd083 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -662,6 +662,9 @@ static int intel_pstate_set_policy(struct cpufreq_policy *policy)
 
 	cpu = all_cpu_data[policy->cpu];
 
+	if (!policy->cpuinfo.max_freq)
+		return -ENODEV;
+
 	intel_pstate_get_min_max(cpu, &min, &max);
 
 	limits.min_perf_pct = (policy->min * 100) / policy->cpuinfo.max_freq;
-- 
1.7.7.6

