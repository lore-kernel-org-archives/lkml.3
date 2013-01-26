Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab3AZRig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 12:38:36 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55379 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3AZRid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 12:38:33 -0500
From: anish kumar <anish198519851985@gmail.com>
To: fweisbec@gmail.com, linux-kernel@vger.kernel.org
Cc: rostedt@goodmis.org, akpm@linux-foundation.org, peterz@infradead.org,
        mingo@kernel.org, tglx@linutronix.de, paul.gortmaker@windriver.com,
        anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [PATCH] IRQ CORE: irq_work_queue function return value not used.
Date: Sat, 26 Jan 2013 23:08:18 +0530
Message-Id: <1359221898-5651-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

As no one is using the return value of irq_work_queue function
it is better to just make it void.

Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 include/linux/irq_work.h |    2 +-
 kernel/irq_work.c        |    5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index 6a9e8f5..ce60c08 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -16,7 +16,7 @@ void init_irq_work(struct irq_work *work, void (*func)(struct irq_work *))
 	work->func = func;
 }
 
-bool irq_work_queue(struct irq_work *work);
+void irq_work_queue(struct irq_work *work);
 void irq_work_run(void);
 void irq_work_sync(struct irq_work *work);
 
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 1588e3b..4829a31 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -79,17 +79,16 @@ static void __irq_work_queue(struct irq_work *work)
  *
  * Can be re-enqueued while the callback is still in progress.
  */
-bool irq_work_queue(struct irq_work *work)
+void irq_work_queue(struct irq_work *work)
 {
 	if (!irq_work_claim(work)) {
 		/*
 		 * Already enqueued, can't do!
 		 */
-		return false;
+		return;
 	}
 
 	__irq_work_queue(work);
-	return true;
 }
 EXPORT_SYMBOL_GPL(irq_work_queue);
 
-- 
1.7.1

