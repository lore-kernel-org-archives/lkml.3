Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933504Ab3CHXWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:22:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:25771 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757262Ab3CHXWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:22:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,810,1355126400"; 
   d="scan'208";a="274491742"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Add Sandy Bridge constraints for CYCLE_ACTIVITY.*
Date: Fri,  8 Mar 2013 15:22:48 -0800
Message-Id: <1362784968-12542-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add CYCLE_ACTIVITY.CYCLES_NO_DISPATCH/CYCLES_L1D_PENDING
These recently documented events have restrictions to counter 0-3
and counter 2 respectively.  The scheduler needs to know that
to schedule them correctly.

IvyBridge already has the necessary constraints.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 5b59c6c..0d2f9d8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -104,6 +104,8 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_DISPATCH */
+	INTEL_UEVENT_CONSTRAINT(0x02a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
 	EVENT_CONSTRAINT_END
 };
 
-- 
1.7.7.6

