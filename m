Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab3CEIHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 03:07:21 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:63661 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3CEIHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 03:07:19 -0500
Message-ID: <5135A78E.7040609@huawei.com>
Date: Tue, 5 Mar 2013 16:06:38 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/9] sched: Move wake flags to kernel/sched/sched.h
References: <5135A736.8050104@huawei.com>
In-Reply-To: <5135A736.8050104@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are used internally only.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 include/linux/sched.h | 7 -------
 kernel/sched/sched.h  | 7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0d64130..863b505 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -920,13 +920,6 @@ struct uts_namespace;
 struct rq;
 struct sched_domain;
 
-/*
- * wake flags
- */
-#define WF_SYNC		0x01		/* waker goes to sleep after wakup */
-#define WF_FORK		0x02		/* child wakeup after fork */
-#define WF_MIGRATED	0x04		/* internal use, task got migrated */
-
 #define ENQUEUE_WAKEUP		1
 #define ENQUEUE_HEAD		2
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1a4a2b1..4e5c2af 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -865,6 +865,13 @@ static inline void finish_lock_switch(struct rq *rq, struct task_struct *prev)
 }
 #endif /* __ARCH_WANT_UNLOCKED_CTXSW */
 
+/*
+ * wake flags
+ */
+#define WF_SYNC		0x01		/* waker goes to sleep after wakeup */
+#define WF_FORK		0x02		/* child wakeup after fork */
+#define WF_MIGRATED	0x4		/* internal use, task got migrated */
+
 static inline void update_load_add(struct load_weight *lw, unsigned long inc)
 {
 	lw->weight += inc;
-- 
1.8.0.2
