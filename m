Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab3AQBnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:43:00 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:33222 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758199Ab3AQBmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:42:55 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/17] workqueue: unexport work_cpu()
Date: Wed, 16 Jan 2013 17:42:33 -0800
Message-Id: <1358386969-945-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function no longer has any external users.  Unexport it.  It will
be removed later on.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h | 1 -
 kernel/workqueue.c        | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2b58905..ff68b1d 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -426,7 +426,6 @@ extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
 extern void workqueue_set_max_active(struct workqueue_struct *wq,
 				     int max_active);
 extern bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq);
-extern unsigned int work_cpu(struct work_struct *work);
 extern unsigned int work_busy(struct work_struct *work);
 
 /*
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7967f34..4275ae7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -476,6 +476,7 @@ static atomic_t unbound_pool_nr_running[NR_WORKER_POOLS] = {
 };
 
 static int worker_thread(void *__worker);
+static unsigned int work_cpu(struct work_struct *work);
 
 static int worker_pool_pri(struct worker_pool *pool)
 {
@@ -3428,13 +3429,12 @@ EXPORT_SYMBOL_GPL(workqueue_congested);
  * RETURNS:
  * CPU number if @work was ever queued.  WORK_CPU_NONE otherwise.
  */
-unsigned int work_cpu(struct work_struct *work)
+static unsigned int work_cpu(struct work_struct *work)
 {
 	struct global_cwq *gcwq = get_work_gcwq(work);
 
 	return gcwq ? gcwq->cpu : WORK_CPU_NONE;
 }
-EXPORT_SYMBOL_GPL(work_cpu);
 
 /**
  * work_busy - test whether a work is currently pending or running
-- 
1.8.0.2

