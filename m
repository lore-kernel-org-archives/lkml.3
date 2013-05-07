Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933529Ab3EGNq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:46:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54764 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933566Ab3EGNqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:46:39 -0400
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Peter Hurley <peter@hurleysoftware.com>
Cc: Alex Shi <alex.shi@intel.com>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 14/14] rwsem: no need for explicit signed longs
Date: Tue,  7 May 2013 06:46:02 -0700
Message-Id: <1367934362-10433-15-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367934362-10433-1-git-send-email-walken@google.com>
References: <1367934362-10433-1-git-send-email-walken@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

Change explicit "signed long" declarations into plain "long" as suggested
by Peter Hurley.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Reviewed-by: Michel Lespinasse <walken@google.com>
Signed-off-by: Michel Lespinasse <walken@google.com>
---
 lib/rwsem.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/lib/rwsem.c b/lib/rwsem.c
index 61f91ca75e40..cf0ad2ad19f5 100644
--- a/lib/rwsem.c
+++ b/lib/rwsem.c
@@ -64,7 +64,7 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
 	struct rwsem_waiter *waiter;
 	struct task_struct *tsk;
 	struct list_head *next;
-	signed long oldcount, woken, loop, adjustment;
+	long oldcount, woken, loop, adjustment;
 
 	waiter = list_entry(sem->wait_list.next, struct rwsem_waiter, list);
 	if (waiter->type == RWSEM_WAITING_FOR_WRITE) {
@@ -145,10 +145,9 @@ __rwsem_do_wake(struct rw_semaphore *sem, enum rwsem_wake_type wake_type)
  */
 struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
 {
-	signed long adjustment = -RWSEM_ACTIVE_READ_BIAS;
+	long count, adjustment = -RWSEM_ACTIVE_READ_BIAS;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
-	signed long count;
 
 	/* set up my own style of waitqueue */
 	waiter.task = tsk;
@@ -193,10 +192,9 @@ struct rw_semaphore __sched *rwsem_down_read_failed(struct rw_semaphore *sem)
  */
 struct rw_semaphore __sched *rwsem_down_write_failed(struct rw_semaphore *sem)
 {
-	signed long adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
+	long count, adjustment = -RWSEM_ACTIVE_WRITE_BIAS;
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk = current;
-	signed long count;
 
 	/* set up my own style of waitqueue */
 	waiter.task = tsk;
-- 
1.8.2.1

