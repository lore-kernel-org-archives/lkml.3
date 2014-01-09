Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757139AbaAIXwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 18:52:22 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:55214 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaAIXvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 18:51:50 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 3/3] perf: clarify comment regarding perf_pmu_contexts
Date: Thu,  9 Jan 2014 15:51:32 -0800
Message-Id: <1389311492-5059-4-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1389311492-5059-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010923-7164-0000-0000-000004FB3577
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, note that the behavior of task_ctx_nr < 0 is an exception.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 kernel/events/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e9f60d0..159ef12 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6276,8 +6276,9 @@ static int perf_event_idx_default(struct perf_event *event)
 }
 
 /*
- * Ensures all contexts with the same task_ctx_nr have the same
- * pmu_cpu_context too.
+ * Ensures all contexts with the same task_ctx_nr (where that task_ctx_nr
+ * is >=0) have the same pmu_cpu_context too. Contexts with with negative (<0)
+ * task_ctx_nr do not share pmu_cpu_contexts.
  */
 static void *find_pmu_context(int ctxn)
 {
-- 
1.8.5.2

