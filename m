Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab3EFVpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:45:10 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:46003 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab3EFVpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 17:45:08 -0400
From: Marc Dionne <marc.c.dionne@gmail.com>
To: Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] workqueue: Make schedule_work() available again to non GPL modules
Date: Mon,  6 May 2013 17:44:55 -0400
Message-Id: <1367876695-3697-1-git-send-email-marc.dionne@your-file-system.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8425e3d5bdbe ("workqueue: inline trivial wrappers") changed
schedule_work() and schedule_delayed_work() to inline wrappers,
but these rely on some symbols that are EXPORT_SYMBOL_GPL, while
the original functions were EXPORT_SYMBOL.  This has the effect of
changing the licensing requirement for these functions and making
them unavailable to non GPL modules.

Make them available again by removing the restriction on the
required symbols.

Signed-off-by: Marc Dionne <marc.dionne@your-file-system.com>
---
 kernel/workqueue.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 4aa9f5b..b7db830 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -296,7 +296,7 @@ static DEFINE_HASHTABLE(unbound_pool_hash, UNBOUND_POOL_HASH_ORDER);
 static struct workqueue_attrs *unbound_std_wq_attrs[NR_STD_WORKER_POOLS];
 
 struct workqueue_struct *system_wq __read_mostly;
-EXPORT_SYMBOL_GPL(system_wq);
+EXPORT_SYMBOL(system_wq);
 struct workqueue_struct *system_highpri_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_highpri_wq);
 struct workqueue_struct *system_long_wq __read_mostly;
@@ -1411,7 +1411,7 @@ bool queue_work_on(int cpu, struct workqueue_struct *wq,
 	local_irq_restore(flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(queue_work_on);
+EXPORT_SYMBOL(queue_work_on);
 
 void delayed_work_timer_fn(unsigned long __data)
 {
@@ -1485,7 +1485,7 @@ bool queue_delayed_work_on(int cpu, struct workqueue_struct *wq,
 	local_irq_restore(flags);
 	return ret;
 }
-EXPORT_SYMBOL_GPL(queue_delayed_work_on);
+EXPORT_SYMBOL(queue_delayed_work_on);
 
 /**
  * mod_delayed_work_on - modify delay of or queue a delayed work on specific CPU
-- 
1.8.1.4

