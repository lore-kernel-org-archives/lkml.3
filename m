Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab3CAJLf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 04:11:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:2446 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab3CAJLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:11:17 -0500
X-IronPort-AV: E=Sophos;i="4.84,760,1355068800"; 
   d="scan'208";a="6793628"
From: liguang <lig.fnst@cn.fujitsu.com>
To: luciarosculete@gmail.com, jkosina@suse.cz, linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] semaphore: boolize semaphore_waiter's up
Date: Fri, 1 Mar 2013 17:03:48 +0800
Message-Id: <1362128628-18457-2-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1362128628-18457-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1362128628-18457-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 17:03:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/01 17:03:21,
	Serialize complete at 2013/03/01 17:03:21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/semaphore.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 9c7017d..6815171 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -193,7 +193,7 @@ EXPORT_SYMBOL(up);
 struct semaphore_waiter {
 	struct list_head list;
 	struct task_struct *task;
-	int up;
+	bool up;
 };
 
 /*
@@ -209,7 +209,7 @@ static inline int __sched __down_common(struct semaphore *sem, long state,
 
 	list_add_tail(&waiter.list, &sem->wait_list);
 	waiter.task = task;
-	waiter.up = 0;
+	waiter.up = false;
 
 	for (;;) {
 		if (signal_pending_state(state, task))
@@ -258,6 +258,6 @@ static noinline void __sched __up(struct semaphore *sem)
 	struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
 						struct semaphore_waiter, list);
 	list_del(&waiter->list);
-	waiter->up = 1;
+	waiter->up = true;
 	wake_up_process(waiter->task);
 }
-- 
1.7.2.5

