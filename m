Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab3JBFEF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 01:04:05 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:60038 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3JBFED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 01:04:03 -0400
From: =?UTF-8?q?Mathieu=20Rh=C3=A9aume?= <mathieu@codingrhemes.com>
To: mathieu@codingrhemes.com
Cc: joe@perches.com, gregkh@linuxfoundation.org, arve@android.com,
        dan.carpenter@oracle.com, mirsal@mirsal.fr,
        serban.constantinescu@arm.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] Staging : android: binder.c: Prefer seq_puts to seq_printf
Date: Wed,  2 Oct 2013 01:02:39 -0400
Message-Id: <1380690159-17623-1-git-send-email-mathieu@codingrhemes.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
 * Fixed the indent in the method calls that had too many tab.

>8------------------------------------------------------8<

This patch changes seq_printf for seq_puts in binder.c.
It fixes the warnings emitted by checkpatch.pl.

Signed-off-by: Mathieu Rhéaume <mathieu@codingrhemes.com>
---
 drivers/staging/android/binder.c | 109 +++++++++++++++++++++------------------
 1 file changed, 58 insertions(+), 51 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 09edebb..7c3e7ef 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -3272,33 +3272,33 @@ binder_defer_work(struct binder_proc *proc, enum binder_deferred_state defer)
 static void print_binder_transaction(struct seq_file *m, const char *prefix,
 				     struct binder_transaction *t)
 {
-	seq_printf(m,
-		   "%s %d: %p from %d:%d to %d:%d code %x flags %x pri %ld r%d",
-		   prefix, t->debug_id, t,
-		   t->from ? t->from->proc->pid : 0,
-		   t->from ? t->from->pid : 0,
-		   t->to_proc ? t->to_proc->pid : 0,
-		   t->to_thread ? t->to_thread->pid : 0,
-		   t->code, t->flags, t->priority, t->need_reply);
+	seq_puts(m, "%s %d: %p from %d:%d to %d:%d code %x flags %x pri %ld r%d",
+		 prefix, t->debug_id, t,
+		 t->from ? t->from->proc->pid : 0,
+		 t->from ? t->from->pid : 0,
+		 t->to_proc ? t->to_proc->pid : 0,
+		 t->to_thread ? t->to_thread->pid : 0,
+		 t->code, t->flags, t->priority, t->need_reply);
 	if (t->buffer == NULL) {
 		seq_puts(m, " buffer free\n");
 		return;
 	}
 	if (t->buffer->target_node)
-		seq_printf(m, " node %d",
-			   t->buffer->target_node->debug_id);
-	seq_printf(m, " size %zd:%zd data %p\n",
-		   t->buffer->data_size, t->buffer->offsets_size,
-		   t->buffer->data);
+		seq_puts(m, " node %d",
+			 t->buffer->target_node->debug_id);
+	seq_puts(m, " size %zd:%zd data %p\n",
+		 t->buffer->data_size,
+		 t->buffer->offsets_size,
+		 t->buffer->data);
 }
 
 static void print_binder_buffer(struct seq_file *m, const char *prefix,
 				struct binder_buffer *buffer)
 {
-	seq_printf(m, "%s %d: %p size %zd:%zd %s\n",
-		   prefix, buffer->debug_id, buffer->data,
-		   buffer->data_size, buffer->offsets_size,
-		   buffer->transaction ? "active" : "delivered");
+	seq_puts(m, "%s %d: %p size %zd:%zd %s\n",
+		 prefix, buffer->debug_id, buffer->data,
+		 buffer->data_size, buffer->offsets_size,
+		 buffer->transaction ? "active" : "delivered");
 }
 
 static void print_binder_work(struct seq_file *m, const char *prefix,
@@ -3314,24 +3314,30 @@ static void print_binder_work(struct seq_file *m, const char *prefix,
 		print_binder_transaction(m, transaction_prefix, t);
 		break;
 	case BINDER_WORK_TRANSACTION_COMPLETE:
-		seq_printf(m, "%stransaction complete\n", prefix);
+		seq_puts(m, "%stransaction complete\n",
+			 prefix);
 		break;
 	case BINDER_WORK_NODE:
 		node = container_of(w, struct binder_node, work);
-		seq_printf(m, "%snode work %d: u%p c%p\n",
-			   prefix, node->debug_id, node->ptr, node->cookie);
+		seq_puts(m, "%snode work %d: u%p c%p\n",
+			 prefix,
+			 node->debug_id,
+			 node->ptr,
+			 node->cookie);
 		break;
 	case BINDER_WORK_DEAD_BINDER:
-		seq_printf(m, "%shas dead binder\n", prefix);
+		seq_puts(m, "%shas dead binder\n", prefix);
 		break;
 	case BINDER_WORK_DEAD_BINDER_AND_CLEAR:
-		seq_printf(m, "%shas cleared dead binder\n", prefix);
+		seq_puts(m, "%shas cleared dead binder\n", prefix);
 		break;
 	case BINDER_WORK_CLEAR_DEATH_NOTIFICATION:
-		seq_printf(m, "%shas cleared death notification\n", prefix);
+		seq_puts(m, "%shas cleared death notification\n", prefix);
 		break;
 	default:
-		seq_printf(m, "%sunknown work: type %d\n", prefix, w->type);
+		seq_puts(m, "%sunknown work: type %d\n",
+			 prefix,
+			 w->type);
 		break;
 	}
 }
@@ -3345,7 +3351,8 @@ static void print_binder_thread(struct seq_file *m,
 	size_t start_pos = m->count;
 	size_t header_pos;
 
-	seq_printf(m, "  thread %d: l %02x\n", thread->pid, thread->looper);
+	seq_puts(m, "  thread %d: l %02x\n",
+		 thread->pid, thread->looper);
 	header_pos = m->count;
 	t = thread->transaction_stack;
 	while (t) {
@@ -3379,11 +3386,11 @@ static void print_binder_node(struct seq_file *m, struct binder_node *node)
 	hlist_for_each_entry(ref, &node->refs, node_entry)
 		count++;
 
-	seq_printf(m, "  node %d: u%p c%p hs %d hw %d ls %d lw %d is %d iw %d",
-		   node->debug_id, node->ptr, node->cookie,
-		   node->has_strong_ref, node->has_weak_ref,
-		   node->local_strong_refs, node->local_weak_refs,
-		   node->internal_strong_refs, count);
+	seq_puts(m, "  node %d: u%p c%p hs %d hw %d ls %d lw %d is %d iw %d",
+		 node->debug_id, node->ptr, node->cookie,
+		 node->has_strong_ref, node->has_weak_ref,
+		 node->local_strong_refs, node->local_weak_refs,
+		 node->internal_strong_refs, count);
 	if (count) {
 		seq_puts(m, " proc");
 		hlist_for_each_entry(ref, &node->refs, node_entry)
@@ -3397,9 +3404,9 @@ static void print_binder_node(struct seq_file *m, struct binder_node *node)
 
 static void print_binder_ref(struct seq_file *m, struct binder_ref *ref)
 {
-	seq_printf(m, "  ref %d: desc %d %snode %d s %d w %d d %p\n",
-		   ref->debug_id, ref->desc, ref->node->proc ? "" : "dead ",
-		   ref->node->debug_id, ref->strong, ref->weak, ref->death);
+	seq_puts(m, "  ref %d: desc %d %snode %d s %d w %d d %p\n",
+		 ref->debug_id, ref->desc, ref->node->proc ? "" : "dead ",
+		 ref->node->debug_id, ref->strong, ref->weak, ref->death);
 }
 
 static void print_binder_proc(struct seq_file *m,
@@ -3410,7 +3417,7 @@ static void print_binder_proc(struct seq_file *m,
 	size_t start_pos = m->count;
 	size_t header_pos;
 
-	seq_printf(m, "proc %d\n", proc->pid);
+	seq_puts(m, "proc %d\n", proc->pid);
 	header_pos = m->count;
 
 	for (n = rb_first(&proc->threads); n != NULL; n = rb_next(n))
@@ -3534,20 +3541,21 @@ static void print_binder_proc_stats(struct seq_file *m,
 	struct rb_node *n;
 	int count, strong, weak;
 
-	seq_printf(m, "proc %d\n", proc->pid);
+	seq_puts(m, "proc %d\n",
+		 proc->pid);
 	count = 0;
 	for (n = rb_first(&proc->threads); n != NULL; n = rb_next(n))
 		count++;
-	seq_printf(m, "  threads: %d\n", count);
-	seq_printf(m, "  requested threads: %d+%d/%d\n"
-			"  ready threads %d\n"
-			"  free async space %zd\n", proc->requested_threads,
-			proc->requested_threads_started, proc->max_threads,
-			proc->ready_threads, proc->free_async_space);
+	seq_puts(m, "  threads: %d\n", count);
+	seq_puts(m, "  requested threads: %d+%d/%d\n"
+		 "  ready threads %d\n"
+		 "  free async space %zd\n", proc->requested_threads,
+		 proc->requested_threads_started, proc->max_threads,
+		 proc->ready_threads, proc->free_async_space);
 	count = 0;
 	for (n = rb_first(&proc->nodes); n != NULL; n = rb_next(n))
 		count++;
-	seq_printf(m, "  nodes: %d\n", count);
+	seq_puts(m, "  nodes: %d\n", count);
 	count = 0;
 	strong = 0;
 	weak = 0;
@@ -3558,12 +3566,12 @@ static void print_binder_proc_stats(struct seq_file *m,
 		strong += ref->strong;
 		weak += ref->weak;
 	}
-	seq_printf(m, "  refs: %d s %d w %d\n", count, strong, weak);
+	seq_puts(m, "  refs: %d s %d w %d\n", count, strong, weak);
 
 	count = 0;
 	for (n = rb_first(&proc->allocated_buffers); n != NULL; n = rb_next(n))
 		count++;
-	seq_printf(m, "  buffers: %d\n", count);
+	seq_puts(m, "  buffers: %d\n", count);
 
 	count = 0;
 	list_for_each_entry(w, &proc->todo, entry) {
@@ -3575,7 +3583,7 @@ static void print_binder_proc_stats(struct seq_file *m,
 			break;
 		}
 	}
-	seq_printf(m, "  pending transactions: %d\n", count);
+	seq_puts(m, "  pending transactions: %d\n", count);
 
 	print_binder_stats(m, "  ", &proc->stats);
 }
@@ -3656,12 +3664,11 @@ static int binder_proc_show(struct seq_file *m, void *unused)
 static void print_binder_transaction_log_entry(struct seq_file *m,
 				struct binder_transaction_log_entry *e)
 {
-	seq_printf(m,
-		  "%d: %s from %d:%d to %d:%d node %d handle %d size %d:%d\n",
-		   e->debug_id, (e->call_type == 2) ? "reply" :
-		   ((e->call_type == 1) ? "async" : "call "), e->from_proc,
-		   e->from_thread, e->to_proc, e->to_thread, e->to_node,
-		   e->target_handle, e->data_size, e->offsets_size);
+	seq_puts(m, "%d: %s from %d:%d to %d:%d node %d handle %d size %d:%d\n",
+		 e->debug_id, (e->call_type == 2) ? "reply" :
+		 ((e->call_type == 1) ? "async" : "call "), e->from_proc,
+		 e->from_thread, e->to_proc, e->to_thread, e->to_node,
+		 e->target_handle, e->data_size, e->offsets_size);
 }
 
 static int binder_transaction_log_show(struct seq_file *m, void *unused)
-- 
1.8.3.1

