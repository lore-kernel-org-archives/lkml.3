Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3CONoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:44:37 -0400
Received: from multi.imgtec.com ([194.200.65.239]:34593 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab3CONog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:44:36 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 6/9] metag: perf: use hard_processor_id() to get thread
Date: Fri, 15 Mar 2013 13:43:45 +0000
Message-ID: <1363355028-23278-7-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
References: <1363355028-23278-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_15_13_44_34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use hard_processor_id() to get the current thread number rather than
get_cpu() and the hardware thread mapping. There was no matching
put_cpu(), and in any case this should be slightly more efficient.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 arch/metag/kernel/perf/perf_event.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/metag/kernel/perf/perf_event.c b/arch/metag/kernel/perf/perf_event.c
index 6210126..54fde35 100644
--- a/arch/metag/kernel/perf/perf_event.c
+++ b/arch/metag/kernel/perf/perf_event.c
@@ -22,9 +22,9 @@
 #include <linux/slab.h>
 
 #include <asm/core_reg.h>
-#include <asm/hwthread.h>
 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/processor.h>
 
 #include "perf_event.h"
 
@@ -651,7 +651,7 @@ static void metag_pmu_enable_counter(struct hw_perf_event *event, int idx)
 	}
 
 	tmp = ((config & 0xf) << 28) |
-			((1 << 24) << cpu_2_hwthread_id[get_cpu()]);
+			((1 << 24) << hard_processor_id());
 	if (metag_pmu->max_period)
 		/*
 		 * Cores supporting overflow interrupts may have had the counter
-- 
1.8.1.2


