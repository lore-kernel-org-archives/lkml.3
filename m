Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965264AbaH0VEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:04:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:39546 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965197AbaH0VEF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:04:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="377839690"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/5] perf, x86: Remove incorrect model number from Haswell perf
Date: Wed, 27 Aug 2014 14:03:53 -0700
Message-Id: <1409173437-3041-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409173437-3041-1-git-send-email-andi@firstfloor.org>
References: <1409173437-3041-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

71 is a Broadwell, not a Haswell. The model number was added
by mistake earlier.

Remove it for now, until it can be re-added later with
real Broadwell support.

In practice it does not cause a lot of issues because the Broadwell
PMU is very similar to Haswell, but some details were wrong,
and it's better to handle it correctly.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 89bc750..f962e26 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2544,7 +2544,6 @@ __init int intel_pmu_init(void)
 	case 63:
 	case 69:
 	case 70:
-	case 71:
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
-- 
1.9.3

