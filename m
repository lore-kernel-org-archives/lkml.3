Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab3LKHLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:11:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:40037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3LKHLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:11:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,870,1378882800"; 
   d="scan'208";a="450352494"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 07/15] perf, core: Always swtich pmu specific data during context switch
Date: Wed, 11 Dec 2013 15:10:52 +0800
Message-Id: <1386745860-21143-8-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
References: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Swtich pmu specific data even if switching perf task conext is
optimized out.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 kernel/events/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 6499dae..974f7c7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2318,6 +2318,8 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 			next->perf_event_ctxp[ctxn] = ctx;
 			ctx->task = next;
 			next_ctx->task = task;
+			ctx->task_ctx_data = xchg(&next_ctx->task_ctx_data,
+						  ctx->task_ctx_data);
 			do_switch = 0;
 
 			perf_event_sync_stat(ctx, next_ctx);
-- 
1.8.1.4

