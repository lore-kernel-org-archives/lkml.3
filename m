Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3LKHLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:11:19 -0500
Received: from mga02.intel.com ([134.134.136.20]:40037 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3LKHLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:11:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,870,1378882800"; 
   d="scan'208";a="450352512"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, eranian@google.com, andi@firstfloor.org,
        "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [PATCH 08/15] perf, x86: Allocate memory for saving LBR stack
Date: Wed, 11 Dec 2013 15:10:53 +0800
Message-Id: <1386745860-21143-9-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
References: <1386745860-21143-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Allocate memory for perf task context, use the memory to save
LBR stack.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 arch/x86/kernel/cpu/perf_event.c | 1 +
 arch/x86/kernel/cpu/perf_event.h | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 69e2095..2e43f1b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1879,6 +1879,7 @@ static struct pmu pmu = {
 
 	.event_idx		= x86_pmu_event_idx,
 	.sched_task		= x86_pmu_sched_task,
+	.task_ctx_size          = sizeof(struct x86_perf_task_context),
 };
 
 void arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index 3ef4b79..3ed9629 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -459,6 +459,13 @@ struct x86_pmu {
 	struct perf_guest_switch_msr *(*guest_get_msrs)(int *nr);
 };
 
+struct x86_perf_task_context {
+	u64 lbr_from[MAX_LBR_ENTRIES];
+	u64 lbr_to[MAX_LBR_ENTRIES];
+	int lbr_callstack_users;
+	int lbr_stack_state;
+};
+
 enum {
 	PERF_SAMPLE_BRANCH_CALL_STACK_SHIFT = PERF_SAMPLE_BRANCH_MAX_SHIFT,
 	PERF_SAMPLE_BRANCH_SELECT_MAP_SIZE,
-- 
1.8.1.4

