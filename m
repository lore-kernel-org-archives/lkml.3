Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbaAMQF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:05:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53834 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbaAMQFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 201/208] intel_pstate: Add X86_FEATURE_APERFMPERF to cpu match parameters.
Date: Mon, 13 Jan 2014 16:00:42 +0000
Message-Id: <1389628849-1614-202-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit 6cbd7ee10e2842a3d1f9b60abede1c8f3d1f1130 upstream.

KVM environments do not support APERF/MPERF MSRs. intel_pstate cannot
operate without these registers.

The previous validity checks in intel_pstate_msrs_not_valid() are
insufficent in nested KVMs.

References: https://bugzilla.redhat.com/show_bug.cgi?id=1046317
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 85f02a0..8d10dda 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -520,7 +520,8 @@ static void intel_pstate_timer_func(unsigned long __data)
 }
 
 #define ICPU(model, policy) \
-	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY, (unsigned long)&policy }
+	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_APERFMPERF,\
+			(unsigned long)&policy }
 
 static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
 	ICPU(0x2a, default_policy),
-- 
1.8.3.2

