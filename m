Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbaGCNRc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:17:32 -0400
Received: from mx2.parallels.com ([199.115.105.18]:60443 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757408AbaGCNRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:17:30 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH TRIVIAL -mm] fork: make mm_init_owner static
Date: Thu, 3 Jul 2014 17:17:23 +0400
Message-ID: <1404393443-14453-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's only used in fork.c:mm_init().

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
---
 include/linux/sched.h |    5 -----
 kernel/fork.c         |   14 +++++++-------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 322d4fc8976c..c1d6d46ce941 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2959,15 +2959,10 @@ static inline void inc_syscw(struct task_struct *tsk)
 
 #ifdef CONFIG_MEMCG
 extern void mm_update_next_owner(struct mm_struct *mm);
-extern void mm_init_owner(struct mm_struct *mm, struct task_struct *p);
 #else
 static inline void mm_update_next_owner(struct mm_struct *mm)
 {
 }
-
-static inline void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
-{
-}
 #endif /* CONFIG_MEMCG */
 
 static inline unsigned long task_rlimit(const struct task_struct *tsk,
diff --git a/kernel/fork.c b/kernel/fork.c
index c3117443f42e..371cb7cc4f80 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -526,6 +526,13 @@ static void mm_init_aio(struct mm_struct *mm)
 #endif
 }
 
+static void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
+{
+#ifdef CONFIG_MEMCG
+	mm->owner = p;
+#endif
+}
+
 static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 {
 	mm->mmap = NULL;
@@ -1098,13 +1105,6 @@ static void rt_mutex_init_task(struct task_struct *p)
 #endif
 }
 
-#ifdef CONFIG_MEMCG
-void mm_init_owner(struct mm_struct *mm, struct task_struct *p)
-{
-	mm->owner = p;
-}
-#endif /* CONFIG_MEMCG */
-
 /*
  * Initialize POSIX timer handling for a single task.
  */
-- 
1.7.10.4

