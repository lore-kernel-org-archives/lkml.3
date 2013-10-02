Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3JBB7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:59:08 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:47143 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556Ab3JBB7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:59:05 -0400
From: =?UTF-8?q?Mathieu=20Rh=C3=A9aume?= <mathieu@codingrhemes.com>
To: mathieu@codingrhemes.com
Cc: gregkh@linuxfoundation.org, arve@android.com, dan.carpenter@oracle.com,
        mirsal@mirsal.fr, serban.constantinescu@arm.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging : android: binder.c: Prefer seq_puts to seq_printf
Date: Tue,  1 Oct 2013 21:57:36 -0400
Message-Id: <1380679056-10175-1-git-send-email-mathieu@codingrhemes.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes seq_printf for seq_puts in binder.c.
It fixes the warnings emitted by checkpatch.pl.

Signed-off-by: Mathieu Rhéaume <mathieu@codingrhemes.com>
---
 drivers/staging/android/binder.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 09edebb..f3d4a1f 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -3272,7 +3272,7 @@ binder_defer_work(struct binder_proc *proc, enum binder_deferred_state defer)
 static void print_binder_transaction(struct seq_file *m, const char *prefix,
 				     struct binder_transaction *t)
 {
-	seq_printf(m,
+	seq_puts(m,
 		   "%s %d: %p from %d:%d to %d:%d code %x flags %x pri %ld r%d",
 		   prefix, t->debug_id, t,
 		   t->from ? t->from->proc->pid : 0,
@@ -3287,7 +3287,7 @@ static void print_binder_transaction(struct seq_file *m, const char *prefix,
 	if (t->buffer->target_node)
 		seq_printf(m, " node %d",
 			   t->buffer->target_node->debug_id);
-	seq_printf(m, " size %zd:%zd data %p\n",
+	seq_puts(m, " size %zd:%zd data %p\n",
 		   t->buffer->data_size, t->buffer->offsets_size,
 		   t->buffer->data);
 }
@@ -3656,7 +3656,7 @@ static int binder_proc_show(struct seq_file *m, void *unused)
 static void print_binder_transaction_log_entry(struct seq_file *m,
 				struct binder_transaction_log_entry *e)
 {
-	seq_printf(m,
+	seq_puts(m,
 		  "%d: %s from %d:%d to %d:%d node %d handle %d size %d:%d\n",
 		   e->debug_id, (e->call_type == 2) ? "reply" :
 		   ((e->call_type == 1) ? "async" : "call "), e->from_proc,
-- 
1.8.3.1

