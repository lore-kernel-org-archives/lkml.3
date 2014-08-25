Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696AbaHYWo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 18:44:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:65151 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117AbaHYWnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 18:43:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,400,1406617200"; 
   d="scan'208";a="563318684"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/5] perf, x86: Use Broadwell cache event list for Haswell
Date: Mon, 25 Aug 2014 15:43:31 -0700
Message-Id: <1409006611-30741-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409006611-30741-1-git-send-email-andi@firstfloor.org>
References: <1409006611-30741-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Use the newly added Broadwell cache event list for Haswell too.
They are identical, but Haswell is very different from the Sandy Bridge
list that was used previously. That fixes a wide range of mis-counting
cache events.

The node events are now only for retired memory events.

The prefetch events are gone now. They way the hardware counts
them is very misleading (some prefetches included, others not), so
it seemed best to leave them out.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 53bd98d..190b29e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2692,8 +2692,8 @@ __init int intel_pmu_init(void)
 	case 63: /* 22nm Haswell Server */
 	case 69: /* 22nm Haswell ULT */
 		x86_pmu.late_ack = true;
-		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
-		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
+		memcpy(hw_cache_event_ids, bdw_hw_cache_event_ids, sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, bdw_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_snb();
 
-- 
1.9.3

