Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbaIBSpN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 14:45:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:55128 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbaIBSpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 14:45:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,450,1406617200"; 
   d="scan'208";a="593517515"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/5] perf, x86: Use Broadwell cache event list for Haswell
Date: Tue,  2 Sep 2014 11:44:15 -0700
Message-Id: <1409683455-29168-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409683455-29168-1-git-send-email-andi@firstfloor.org>
References: <1409683455-29168-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use the newly added Broadwell cache event list for Haswell too.
All Haswell and Broadwell events and offcore masks used in these lists
are identical.

However Haswell is very different from the Sandy Bridge
list that was used previously. That fixes a wide range of mis-counting
cache events.

The node events are now only for retired memory events, so prefetching
and speculative memory accesses are not included. They are PEBS
capable now, which makes it much easier to sample for them, plus it's
possible to create address maps with -d.

The prefetch events are gone now. They way the hardware counts
them is very misleading (some prefetches included, others not), so
it seemed best to leave them out.

v2: Change name of variable.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6733a7f..ecea3e5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2692,8 +2692,8 @@ __init int intel_pmu_init(void)
 	case 69: /* 22nm Haswell ULT */
 	case 70: /* 22nm Haswell + GT3e (Intel Iris Pro graphics) */
 		x86_pmu.late_ack = true;
-		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
-		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
+		memcpy(hw_cache_event_ids, hsw_hw_cache_event_ids, sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, hsw_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_snb();
 
-- 
1.9.3

