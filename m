Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab3CFOjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:39:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758370Ab3CFOi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:38:58 -0500
Date: Wed, 6 Mar 2013 06:37:42 -0800
From: tip-bot for Li Zefan <tipbot@zytor.com>
Message-ID: <tip-b13095f07f25464de65f5ce5ea94e16813d67488@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, lizefan@huawei.com
In-Reply-To: <5135A78E.7040609@huawei.com>
References: <5135A78E.7040609@huawei.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Move wake flags to kernel/sched/sched.h
Git-Commit-ID: b13095f07f25464de65f5ce5ea94e16813d67488
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Mar 2013 06:37:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b13095f07f25464de65f5ce5ea94e16813d67488
Gitweb:     http://git.kernel.org/tip/b13095f07f25464de65f5ce5ea94e16813d67488
Author:     Li Zefan <lizefan@huawei.com>
AuthorDate: Tue, 5 Mar 2013 16:06:38 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Mar 2013 11:24:32 +0100

sched: Move wake flags to kernel/sched/sched.h

They are used internally only.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/5135A78E.7040609@huawei.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
