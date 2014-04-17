Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269AbaDQXjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:39:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:50746 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852AbaDQXjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:39:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,882,1389772800"; 
   d="scan'208";a="522542628"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Don't mark DataLA addresses as store
Date: Thu, 17 Apr 2014 16:39:16 -0700
Message-Id: <1397777956-11466-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Haswell supports reporting the data address for a range
of events, including UOPS_RETIRED.ALL and some load
events. Currently these addresses were always marked
as stores, which is wrong, as they could be loads too.
Change it to NA instead.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index ae96cfa..7e9546a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -113,7 +113,7 @@ static u64 precise_store_data_hsw(u64 status)
 	union perf_mem_data_src dse;
 
 	dse.val = 0;
-	dse.mem_op = PERF_MEM_OP_STORE;
+	dse.mem_op = PERF_MEM_OP_NA;
 	dse.mem_lvl = PERF_MEM_LVL_NA;
 	if (status & 1)
 		dse.mem_lvl = PERF_MEM_LVL_L1;
-- 
1.8.5.3

