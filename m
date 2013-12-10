Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab3LJUhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:37:05 -0500
Received: from mail1.windriver.com ([147.11.146.13]:44703 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3LJUhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:37:01 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] lustre: delete pointless wait queue related casts.
Date: Tue, 10 Dec 2013 15:36:50 -0500
Message-ID: <1386707810-6227-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These serve no purpose at all, and can only mask real type
clash issues that one would want to actually see.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
index cc9829ffbdcb..c7bc7fcccb8e 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-prim.c
@@ -46,13 +46,10 @@
 #include <asm/kgdb.h>
 #endif
 
-#define LINUX_WAITQ(w) ((wait_queue_t *) w)
-#define LINUX_WAITQ_HEAD(w) ((wait_queue_head_t *) w)
-
 void
 init_waitqueue_entry_current(wait_queue_t *link)
 {
-	init_waitqueue_entry(LINUX_WAITQ(link), current);
+	init_waitqueue_entry(link, current);
 }
 EXPORT_SYMBOL(init_waitqueue_entry_current);
 
@@ -74,9 +71,9 @@ add_wait_queue_exclusive_head(wait_queue_head_t *waitq, wait_queue_t *link)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&LINUX_WAITQ_HEAD(waitq)->lock, flags);
-	__add_wait_queue_exclusive(LINUX_WAITQ_HEAD(waitq), LINUX_WAITQ(link));
-	spin_unlock_irqrestore(&LINUX_WAITQ_HEAD(waitq)->lock, flags);
+	spin_lock_irqsave(&waitq->lock, flags);
+	__add_wait_queue_exclusive(waitq, link);
+	spin_unlock_irqrestore(&waitq->lock, flags);
 }
 EXPORT_SYMBOL(add_wait_queue_exclusive_head);
 
-- 
1.8.5.1

