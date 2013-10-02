Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab3JBBme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:42:34 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:62542 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3JBBmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:42:31 -0400
From: =?UTF-8?q?Mathieu=20Rh=C3=A9aume?= <mathieu@codingrhemes.com>
To: mathieu@codingrhemes.com
Cc: gregkh@linuxfoundation.org, arve@android.com, dan.carpenter@oracle.com,
        mirsal@mirsal.fr, serban.constantinescu@arm.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: android: binder.c: Fixed 80 characters warnings from checkpatch.pl
Date: Tue,  1 Oct 2013 21:39:48 -0400
Message-Id: <1380677988-9329-1-git-send-email-mathieu@codingrhemes.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a lot of warnings from checkpatch.pl about the 80 characters per line limitation.

Signed-off-by: Mathieu Rhéaume <mathieu@codingrhemes.com>
---
 drivers/staging/android/binder.c | 520 ++++++++++++++++++++++++++-------------
 1 file changed, 353 insertions(+), 167 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 98ac020..09edebb 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -663,7 +663,8 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		ALIGN(offsets_size, sizeof(void *));
 
 	if (size < data_size || size < offsets_size) {
-		binder_user_error("%d: got transaction with invalid size %zd-%zd\n",
+		binder_user_error(
+		"%d: got transaction with invalid size %zd-%zd\n",
 				proc->pid, data_size, offsets_size);
 		return NULL;
 	}
@@ -1093,7 +1094,7 @@ static void binder_delete_ref(struct binder_ref *ref)
 	binder_dec_node(ref->node, 0, 1);
 	if (ref->death) {
 		binder_debug(BINDER_DEBUG_DEAD_BINDER,
-			     "%d delete ref %d desc %d has death notification\n",
+			"%d delete ref %d desc %d has death notification\n",
 			      ref->proc->pid, ref->debug_id, ref->desc);
 		list_del(&ref->death->work.entry);
 		kfree(ref->death);
@@ -1130,7 +1131,8 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 {
 	if (strong) {
 		if (ref->strong == 0) {
-			binder_user_error("%d invalid dec strong, ref %d desc %d s %d w %d\n",
+			binder_user_error(
+			"%d invalid dec strong, ref %d desc %d s %d w %d\n",
 					  ref->proc->pid, ref->debug_id,
 					  ref->desc, ref->strong, ref->weak);
 			return -EINVAL;
@@ -1144,7 +1146,8 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 		}
 	} else {
 		if (ref->weak == 0) {
-			binder_user_error("%d invalid dec weak, ref %d desc %d s %d w %d\n",
+			binder_user_error(
+			"%d invalid dec weak, ref %d desc %d s %d w %d\n",
 					  ref->proc->pid, ref->debug_id,
 					  ref->desc, ref->strong, ref->weak);
 			return -EINVAL;
@@ -1189,15 +1192,17 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 			}
 			if (target_thread->return_error == BR_OK) {
 				binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-					     "send failed reply for transaction %d to %d:%d\n",
-					      t->debug_id, target_thread->proc->pid,
-					      target_thread->pid);
+			"send failed reply for transaction %d to %d:%d\n",
+						t->debug_id,
+						target_thread->proc->pid,
+						target_thread->pid);
 
 				binder_pop_transaction(target_thread, t);
 				target_thread->return_error = error_code;
 				wake_up_interruptible(&target_thread->wait);
 			} else {
-				pr_err("reply failed, target thread, %d:%d, has error code %d already\n",
+				pr_err(
+	"reply failed, target thread, %d:%d, has error code %d already\n",
 					target_thread->proc->pid,
 					target_thread->pid,
 					target_thread->return_error);
@@ -1207,19 +1212,19 @@ static void binder_send_failed_reply(struct binder_transaction *t,
 			struct binder_transaction *next = t->from_parent;
 
 			binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-				     "send failed reply for transaction %d, target dead\n",
+			"send failed reply for transaction %d, target dead\n",
 				     t->debug_id);
 
 			binder_pop_transaction(target_thread, t);
 			if (next == NULL) {
 				binder_debug(BINDER_DEBUG_DEAD_BINDER,
-					     "reply failed, no target thread at root\n");
+				"reply failed, no target thread at root\n");
 				return;
 			}
 			t = next;
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "reply failed, no target thread -- retry %d\n",
-				      t->debug_id);
+				"reply failed, no target thread -- retry %d\n",
+								t->debug_id);
 		}
 	}
 }
@@ -1239,7 +1244,8 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 	if (buffer->target_node)
 		binder_dec_node(buffer->target_node, 1, 0);
 
-	offp = (size_t *)(buffer->data + ALIGN(buffer->data_size, sizeof(void *)));
+	offp = (size_t *)(buffer->data + ALIGN(buffer->data_size,
+						sizeof(void *)));
 	if (failed_at)
 		off_end = failed_at;
 	else
@@ -1249,15 +1255,17 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		if (*offp > buffer->data_size - sizeof(*fp) ||
 		    buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(u32))) {
-			pr_err("transaction release %d bad offset %zd, size %zd\n",
-			 debug_id, *offp, buffer->data_size);
+			pr_err(
+			"transaction release %d bad offset %zd, size %zd\n",
+					debug_id, *offp, buffer->data_size);
 			continue;
 		}
 		fp = (struct flat_binder_object *)(buffer->data + *offp);
 		switch (fp->type) {
 		case BINDER_TYPE_BINDER:
 		case BINDER_TYPE_WEAK_BINDER: {
-			struct binder_node *node = binder_get_node(proc, fp->binder);
+			struct binder_node *node = binder_get_node(proc,
+								fp->binder);
 			if (node == NULL) {
 				pr_err("transaction release %d bad node %p\n",
 					debug_id, fp->binder);
@@ -1266,11 +1274,13 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			binder_debug(BINDER_DEBUG_TRANSACTION,
 				     "        node %d u%p\n",
 				     node->debug_id, node->ptr);
-			binder_dec_node(node, fp->type == BINDER_TYPE_BINDER, 0);
+			binder_dec_node(node, fp->type ==
+						BINDER_TYPE_BINDER, 0);
 		} break;
 		case BINDER_TYPE_HANDLE:
 		case BINDER_TYPE_WEAK_HANDLE: {
-			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
+			struct binder_ref *ref = binder_get_ref(proc,
+								fp->handle);
 			if (ref == NULL) {
 				pr_err("transaction release %d bad handle %d\n",
 				 debug_id, fp->handle);
@@ -1278,7 +1288,9 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 			}
 			binder_debug(BINDER_DEBUG_TRANSACTION,
 				     "        ref %d desc %d (node %d)\n",
-				     ref->debug_id, ref->desc, ref->node->debug_id);
+					ref->debug_id,
+					ref->desc,
+					ref->node->debug_id);
 			binder_dec_ref(ref, fp->type == BINDER_TYPE_HANDLE);
 		} break;
 
@@ -1324,8 +1336,9 @@ static void binder_transaction(struct binder_proc *proc,
 	if (reply) {
 		in_reply_to = thread->transaction_stack;
 		if (in_reply_to == NULL) {
-			binder_user_error("%d:%d got reply transaction with no transaction stack\n",
-					  proc->pid, thread->pid);
+			binder_user_error(
+		"%d:%d got reply transaction with no transaction stack\n",
+							proc->pid, thread->pid);
 			return_error = BR_FAILED_REPLY;
 			goto err_empty_call_stack;
 		}
@@ -1364,8 +1377,9 @@ static void binder_transaction(struct binder_proc *proc,
 			struct binder_ref *ref;
 			ref = binder_get_ref(proc, tr->target.handle);
 			if (ref == NULL) {
-				binder_user_error("%d:%d got transaction to invalid handle\n",
-					proc->pid, thread->pid);
+				binder_user_error(
+				"%d:%d got transaction to invalid handle\n",
+				proc->pid, thread->pid);
 				return_error = BR_FAILED_REPLY;
 				goto err_invalid_target_handle;
 			}
@@ -1432,14 +1446,14 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (reply)
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "%d:%d BC_REPLY %d -> %d:%d, data %p-%p size %zd-%zd\n",
+			"%d:%d BC_REPLY %d -> %d:%d, data %p-%p size %zd-%zd\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_thread->pid,
 			     tr->data.ptr.buffer, tr->data.ptr.offsets,
 			     tr->data_size, tr->offsets_size);
 	else
 		binder_debug(BINDER_DEBUG_TRANSACTION,
-			     "%d:%d BC_TRANSACTION %d -> %d - node %d, data %p-%p size %zd-%zd\n",
+	"%d:%d BC_TRANSACTION %d -> %d - node %d, data %p-%p size %zd-%zd\n",
 			     proc->pid, thread->pid, t->debug_id,
 			     target_proc->pid, target_node->debug_id,
 			     tr->data.ptr.buffer, tr->data.ptr.offsets,
@@ -1472,23 +1486,29 @@ static void binder_transaction(struct binder_proc *proc,
 	if (target_node)
 		binder_inc_node(target_node, 1, 0, NULL);
 
-	offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size, sizeof(void *)));
+	offp = (size_t *)(t->buffer->data + ALIGN(tr->data_size,
+						sizeof(void *)));
 
-	if (copy_from_user(t->buffer->data, tr->data.ptr.buffer, tr->data_size)) {
-		binder_user_error("%d:%d got transaction with invalid data ptr\n",
-				proc->pid, thread->pid);
+	if (copy_from_user(t->buffer->data,
+				tr->data.ptr.buffer,
+				tr->data_size)) {
+		binder_user_error(
+			"%d:%d got transaction with invalid data ptr\n",
+						proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
 	if (copy_from_user(offp, tr->data.ptr.offsets, tr->offsets_size)) {
-		binder_user_error("%d:%d got transaction with invalid offsets ptr\n",
-				proc->pid, thread->pid);
+		binder_user_error(
+			"%d:%d got transaction with invalid offsets ptr\n",
+			proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
 	if (!IS_ALIGNED(tr->offsets_size, sizeof(size_t))) {
-		binder_user_error("%d:%d got transaction with invalid offsets size, %zd\n",
-				proc->pid, thread->pid, tr->offsets_size);
+		binder_user_error(
+		"%d:%d got transaction with invalid offsets size, %zd\n",
+		proc->pid, thread->pid, tr->offsets_size);
 		return_error = BR_FAILED_REPLY;
 		goto err_bad_offset;
 	}
@@ -1498,7 +1518,8 @@ static void binder_transaction(struct binder_proc *proc,
 		if (*offp > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(u32))) {
-			binder_user_error("%d:%d got transaction with invalid offset, %zd\n",
+			binder_user_error(
+			"%d:%d got transaction with invalid offset, %zd\n",
 					proc->pid, thread->pid, *offp);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_offset;
@@ -1508,18 +1529,26 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_BINDER:
 		case BINDER_TYPE_WEAK_BINDER: {
 			struct binder_ref *ref;
-			struct binder_node *node = binder_get_node(proc, fp->binder);
+			struct binder_node *node = binder_get_node(proc,
+								fp->binder);
 			if (node == NULL) {
-				node = binder_new_node(proc, fp->binder, fp->cookie);
+				node = binder_new_node(proc,
+						fp->binder,
+						fp->cookie);
 				if (node == NULL) {
 					return_error = BR_FAILED_REPLY;
 					goto err_binder_new_node_failed;
 				}
-				node->min_priority = fp->flags & FLAT_BINDER_FLAG_PRIORITY_MASK;
-				node->accept_fds = !!(fp->flags & FLAT_BINDER_FLAG_ACCEPTS_FDS);
+				node->min_priority =
+						fp->flags &
+						FLAT_BINDER_FLAG_PRIORITY_MASK;
+				node->accept_fds =
+						!!(fp->flags &
+						FLAT_BINDER_FLAG_ACCEPTS_FDS);
 			}
 			if (fp->cookie != node->cookie) {
-				binder_user_error("%d:%d sending u%p node %d, cookie mismatch %p != %p\n",
+				binder_user_error(
+		"%d:%d sending u%p node %d, cookie mismatch %p != %p\n",
 					proc->pid, thread->pid,
 					fp->binder, node->debug_id,
 					fp->cookie, node->cookie);
@@ -1546,9 +1575,11 @@ static void binder_transaction(struct binder_proc *proc,
 		} break;
 		case BINDER_TYPE_HANDLE:
 		case BINDER_TYPE_WEAK_HANDLE: {
-			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
+			struct binder_ref *ref = binder_get_ref(proc,
+								fp->handle);
 			if (ref == NULL) {
-				binder_user_error("%d:%d got transaction with invalid handle, %d\n",
+				binder_user_error(
+			"%d:%d got transaction with invalid handle, %d\n",
 						proc->pid,
 						thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
@@ -1561,27 +1592,38 @@ static void binder_transaction(struct binder_proc *proc,
 					fp->type = BINDER_TYPE_WEAK_BINDER;
 				fp->binder = ref->node->ptr;
 				fp->cookie = ref->node->cookie;
-				binder_inc_node(ref->node, fp->type == BINDER_TYPE_BINDER, 0, NULL);
+				binder_inc_node(ref->node,
+					fp->type == BINDER_TYPE_BINDER,
+						0,
+						NULL);
 				trace_binder_transaction_ref_to_node(t, ref);
 				binder_debug(BINDER_DEBUG_TRANSACTION,
-					     "        ref %d desc %d -> node %d u%p\n",
-					     ref->debug_id, ref->desc, ref->node->debug_id,
-					     ref->node->ptr);
+				"        ref %d desc %d -> node %d u%p\n",
+						ref->debug_id,
+						ref->desc,
+						ref->node->debug_id,
+						ref->node->ptr);
 			} else {
 				struct binder_ref *new_ref;
-				new_ref = binder_get_ref_for_node(target_proc, ref->node);
+				new_ref = binder_get_ref_for_node(target_proc,
+								ref->node);
 				if (new_ref == NULL) {
 					return_error = BR_FAILED_REPLY;
 					goto err_binder_get_ref_for_node_failed;
 				}
 				fp->handle = new_ref->desc;
-				binder_inc_ref(new_ref, fp->type == BINDER_TYPE_HANDLE, NULL);
+				binder_inc_ref(new_ref,
+						fp->type == BINDER_TYPE_HANDLE,
+						NULL);
 				trace_binder_transaction_ref_to_ref(t, ref,
 								    new_ref);
 				binder_debug(BINDER_DEBUG_TRANSACTION,
 					     "        ref %d desc %d -> ref %d desc %d (node %d)\n",
-					     ref->debug_id, ref->desc, new_ref->debug_id,
-					     new_ref->desc, ref->node->debug_id);
+						ref->debug_id,
+						ref->desc,
+						new_ref->debug_id,
+						new_ref->desc,
+						ref->node->debug_id);
 			}
 		} break;
 
@@ -1591,13 +1633,17 @@ static void binder_transaction(struct binder_proc *proc,
 
 			if (reply) {
 				if (!(in_reply_to->flags & TF_ACCEPT_FDS)) {
-					binder_user_error("%d:%d got reply with fd, %d, but target does not allow fds\n",
-						proc->pid, thread->pid, fp->handle);
+					binder_user_error(
+	"%d:%d got reply with fd, %d, but target does not allow fds\n",
+						proc->pid,
+						thread->pid,
+						fp->handle);
 					return_error = BR_FAILED_REPLY;
 					goto err_fd_not_allowed;
 				}
 			} else if (!target_node->accept_fds) {
-				binder_user_error("%d:%d got transaction with fd, %d, but target does not allow fds\n",
+				binder_user_error(
+	"%d:%d got transaction with fd, %d, but target does not allow fds\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fd_not_allowed;
@@ -1605,28 +1651,32 @@ static void binder_transaction(struct binder_proc *proc,
 
 			file = fget(fp->handle);
 			if (file == NULL) {
-				binder_user_error("%d:%d got transaction with invalid fd, %d\n",
+				binder_user_error(
+				"%d:%d got transaction with invalid fd, %d\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fget_failed;
 			}
-			target_fd = task_get_unused_fd_flags(target_proc, O_CLOEXEC);
+			target_fd = task_get_unused_fd_flags(target_proc,
+								O_CLOEXEC);
 			if (target_fd < 0) {
 				fput(file);
-				return_error = BR_FAILED_REPLY;
 				goto err_get_unused_fd_failed;
 			}
 			task_fd_install(target_proc, target_fd, file);
 			trace_binder_transaction_fd(t, fp->handle, target_fd);
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        fd %d -> %d\n", fp->handle, target_fd);
+					"        fd %d -> %d\n",
+					fp->handle,
+					target_fd);
 			/* TODO: fput? */
 			fp->handle = target_fd;
 		} break;
 
 		default:
-			binder_user_error("%d:%d got transaction with invalid object type, %x\n",
-				proc->pid, thread->pid, fp->type);
+			binder_user_error(
+		"%d:%d got transaction with invalid object type, %x\n",
+					proc->pid, thread->pid, fp->type);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_object_type;
 		}
@@ -1688,7 +1738,8 @@ err_no_context_mgr_node:
 
 	{
 		struct binder_transaction_log_entry *fe;
-		fe = binder_transaction_log_add(&binder_transaction_log_failed);
+		fe = binder_transaction_log_add(
+			&binder_transaction_log_failed);
 		*fe = *e;
 	}
 
@@ -1700,7 +1751,8 @@ err_no_context_mgr_node:
 		thread->return_error = return_error;
 }
 
-int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
+int binder_thread_write(struct binder_proc *proc,
+			struct binder_thread *thread,
 			void __user *buffer, size_t size, size_t *consumed)
 {
 	uint32_t cmd;
@@ -1734,14 +1786,17 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				ref = binder_get_ref_for_node(proc,
 					       binder_context_mgr_node);
 				if (ref->desc != target) {
-					binder_user_error("%d:%d tried to acquire reference to desc 0, got %d instead\n",
-						proc->pid, thread->pid,
-						ref->desc);
+					binder_user_error(
+	"%d:%d tried to acquire reference to desc 0, got %d instead\n",
+							proc->pid,
+							thread->pid,
+							ref->desc);
 				}
 			} else
 				ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
-				binder_user_error("%d:%d refcount change on invalid ref %d\n",
+				binder_user_error(
+			"%d:%d refcount change on invalid ref %d\n",
 					proc->pid, thread->pid, target);
 				break;
 			}
@@ -1765,9 +1820,15 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				break;
 			}
 			binder_debug(BINDER_DEBUG_USER_REFS,
-				     "%d:%d %s ref %d desc %d s %d w %d for node %d\n",
-				     proc->pid, thread->pid, debug_string, ref->debug_id,
-				     ref->desc, ref->strong, ref->weak, ref->node->debug_id);
+			"%d:%d %s ref %d desc %d s %d w %d for node %d\n",
+				proc->pid,
+				thread->pid,
+				debug_string,
+				ref->debug_id,
+				ref->desc,
+				ref->strong,
+				ref->weak,
+				ref->node->debug_id);
 			break;
 		}
 		case BC_INCREFS_DONE:
@@ -1793,7 +1854,8 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				break;
 			}
 			if (cookie != node->cookie) {
-				binder_user_error("%d:%d %s u%p node %d cookie mismatch %p != %p\n",
+				binder_user_error(
+			"%d:%d %s u%p node %d cookie mismatch %p != %p\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
@@ -1803,27 +1865,33 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 			}
 			if (cmd == BC_ACQUIRE_DONE) {
 				if (node->pending_strong_ref == 0) {
-					binder_user_error("%d:%d BC_ACQUIRE_DONE node %d has no pending acquire request\n",
-						proc->pid, thread->pid,
+					binder_user_error(
+	"%d:%d BC_ACQUIRE_DONE node %d has no pending acquire request\n",
+						proc->pid,
+						thread->pid,
 						node->debug_id);
 					break;
 				}
 				node->pending_strong_ref = 0;
 			} else {
 				if (node->pending_weak_ref == 0) {
-					binder_user_error("%d:%d BC_INCREFS_DONE node %d has no pending increfs request\n",
+					binder_user_error(
+	"%d:%d BC_INCREFS_DONE node %d has no pending increfs request\n",
 						proc->pid, thread->pid,
-						node->debug_id);
+							node->debug_id);
 					break;
 				}
 				node->pending_weak_ref = 0;
 			}
 			binder_dec_node(node, cmd == BC_ACQUIRE_DONE, 0);
 			binder_debug(BINDER_DEBUG_USER_REFS,
-				     "%d:%d %s node %d ls %d lw %d\n",
-				     proc->pid, thread->pid,
-				     cmd == BC_INCREFS_DONE ? "BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
-				     node->debug_id, node->local_strong_refs, node->local_weak_refs);
+					"%d:%d %s node %d ls %d lw %d\n",
+					proc->pid, thread->pid,
+					cmd == BC_INCREFS_DONE ?
+					"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
+					node->debug_id,
+					node->local_strong_refs,
+					node->local_weak_refs);
 			break;
 		}
 		case BC_ATTEMPT_ACQUIRE:
@@ -1843,30 +1911,42 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 
 			buffer = binder_buffer_lookup(proc, data_ptr);
 			if (buffer == NULL) {
-				binder_user_error("%d:%d BC_FREE_BUFFER u%p no match\n",
+				binder_user_error(
+				"%d:%d BC_FREE_BUFFER u%p no match\n",
 					proc->pid, thread->pid, data_ptr);
 				break;
 			}
 			if (!buffer->allow_user_free) {
-				binder_user_error("%d:%d BC_FREE_BUFFER u%p matched unreturned buffer\n",
+				binder_user_error(
+		"%d:%d BC_FREE_BUFFER u%p matched unreturned buffer\n",
 					proc->pid, thread->pid, data_ptr);
 				break;
 			}
 			binder_debug(BINDER_DEBUG_FREE_BUFFER,
-				     "%d:%d BC_FREE_BUFFER u%p found buffer %d for %s transaction\n",
-				     proc->pid, thread->pid, data_ptr, buffer->debug_id,
-				     buffer->transaction ? "active" : "finished");
+	"%d:%d BC_FREE_BUFFER u%p found buffer %d for %s transaction\n",
+					proc->pid,
+					thread->pid,
+					data_ptr,
+					buffer->debug_id,
+					buffer->transaction ? "active" :
+								"finished");
 
 			if (buffer->transaction) {
 				buffer->transaction->buffer = NULL;
 				buffer->transaction = NULL;
 			}
 			if (buffer->async_transaction && buffer->target_node) {
-				BUG_ON(!buffer->target_node->has_async_transaction);
-				if (list_empty(&buffer->target_node->async_todo))
-					buffer->target_node->has_async_transaction = 0;
+				BUG_ON(!buffer->target_node->
+						has_async_transaction);
+				if (list_empty(&buffer->
+						target_node->async_todo))
+					buffer->target_node->
+						has_async_transaction = 0;
 				else
-					list_move_tail(buffer->target_node->async_todo.next, &thread->todo);
+					list_move_tail(buffer->
+							target_node->
+							async_todo.next,
+							&thread->todo);
 			}
 			trace_binder_transaction_buffer_release(buffer);
 			binder_transaction_buffer_release(proc, buffer, NULL);
@@ -1891,11 +1971,13 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     proc->pid, thread->pid);
 			if (thread->looper & BINDER_LOOPER_STATE_ENTERED) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("%d:%d ERROR: BC_REGISTER_LOOPER called after BC_ENTER_LOOPER\n",
+				binder_user_error(
+	"%d:%d ERROR: BC_REGISTER_LOOPER called after BC_ENTER_LOOPER\n",
 					proc->pid, thread->pid);
 			} else if (proc->requested_threads == 0) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("%d:%d ERROR: BC_REGISTER_LOOPER called without request\n",
+				binder_user_error(
+		"%d:%d ERROR: BC_REGISTER_LOOPER called without request\n",
 					proc->pid, thread->pid);
 			} else {
 				proc->requested_threads--;
@@ -1909,7 +1991,8 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     proc->pid, thread->pid);
 			if (thread->looper & BINDER_LOOPER_STATE_REGISTERED) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("%d:%d ERROR: BC_ENTER_LOOPER called after BC_REGISTER_LOOPER\n",
+				binder_user_error(
+	"%d:%d ERROR: BC_ENTER_LOOPER called after BC_REGISTER_LOOPER\n",
 					proc->pid, thread->pid);
 			}
 			thread->looper |= BINDER_LOOPER_STATE_ENTERED;
@@ -1951,21 +2034,24 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				     cmd == BC_REQUEST_DEATH_NOTIFICATION ?
 				     "BC_REQUEST_DEATH_NOTIFICATION" :
 				     "BC_CLEAR_DEATH_NOTIFICATION",
-				     cookie, ref->debug_id, ref->desc,
-				     ref->strong, ref->weak, ref->node->debug_id);
+				     cookie, ref->debug_id,
+					ref->desc, ref->strong,
+					ref->weak, ref->node->debug_id);
 
 			if (cmd == BC_REQUEST_DEATH_NOTIFICATION) {
 				if (ref->death) {
-					binder_user_error("%d:%d BC_REQUEST_DEATH_NOTIFICATION death notification already set\n",
+					binder_user_error(
+"%d:%d BC_REQUEST_DEATH_NOTIFICATION death notification already set\n",
 						proc->pid, thread->pid);
 					break;
 				}
 				death = kzalloc(sizeof(*death), GFP_KERNEL);
 				if (death == NULL) {
 					thread->return_error = BR_ERROR;
-					binder_debug(BINDER_DEBUG_FAILED_TRANSACTION,
-						     "%d:%d BC_REQUEST_DEATH_NOTIFICATION failed\n",
-						     proc->pid, thread->pid);
+					binder_debug(
+						BINDER_DEBUG_FAILED_TRANSACTION,
+			"%d:%d BC_REQUEST_DEATH_NOTIFICATION failed\n",
+						proc->pid, thread->pid);
 					break;
 				}
 				binder_stats_created(BINDER_STAT_DEATH);
@@ -1973,17 +2059,28 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				death->cookie = cookie;
 				ref->death = death;
 				if (ref->node->proc == NULL) {
-					ref->death->work.type = BINDER_WORK_DEAD_BINDER;
-					if (thread->looper & (BINDER_LOOPER_STATE_REGISTERED | BINDER_LOOPER_STATE_ENTERED)) {
-						list_add_tail(&ref->death->work.entry, &thread->todo);
+					ref->death->work.type =
+						BINDER_WORK_DEAD_BINDER;
+					if (thread->looper &
+					(BINDER_LOOPER_STATE_REGISTERED|
+						BINDER_LOOPER_STATE_ENTERED)) {
+						list_add_tail(&ref->
+							death->
+							work.entry,
+							&thread->todo);
 					} else {
-						list_add_tail(&ref->death->work.entry, &proc->todo);
-						wake_up_interruptible(&proc->wait);
+						list_add_tail(&ref->
+							death->
+							work.entry,
+							&proc->todo);
+						wake_up_interruptible(&proc->
+									wait);
 					}
 				}
 			} else {
 				if (ref->death == NULL) {
-					binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification not active\n",
+					binder_user_error(
+	"%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification not active\n",
 						proc->pid, thread->pid);
 					break;
 				}
@@ -1996,16 +2093,26 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				}
 				ref->death = NULL;
 				if (list_empty(&death->work.entry)) {
-					death->work.type = BINDER_WORK_CLEAR_DEATH_NOTIFICATION;
-					if (thread->looper & (BINDER_LOOPER_STATE_REGISTERED | BINDER_LOOPER_STATE_ENTERED)) {
-						list_add_tail(&death->work.entry, &thread->todo);
+					death->work.type =
+					BINDER_WORK_CLEAR_DEATH_NOTIFICATION;
+					if (thread->looper &
+					(BINDER_LOOPER_STATE_REGISTERED|
+						BINDER_LOOPER_STATE_ENTERED)) {
+						list_add_tail(&death->
+								work.entry,
+								&thread->todo);
 					} else {
-						list_add_tail(&death->work.entry, &proc->todo);
-						wake_up_interruptible(&proc->wait);
+						list_add_tail(&death->
+								work.entry,
+								&proc->todo);
+						wake_up_interruptible(&proc->
+									wait);
 					}
 				} else {
-					BUG_ON(death->work.type != BINDER_WORK_DEAD_BINDER);
-					death->work.type = BINDER_WORK_DEAD_BINDER_AND_CLEAR;
+					BUG_ON(death->work.type !=
+						BINDER_WORK_DEAD_BINDER);
+					death->work.type =
+					BINDER_WORK_DEAD_BINDER_AND_CLEAR;
 				}
 			}
 		} break;
@@ -2017,29 +2124,42 @@ int binder_thread_write(struct binder_proc *proc, struct binder_thread *thread,
 				return -EFAULT;
 
 			ptr += sizeof(void *);
-			list_for_each_entry(w, &proc->delivered_death, entry) {
-				struct binder_ref_death *tmp_death = container_of(w, struct binder_ref_death, work);
+			list_for_each_entry(w,
+					&proc->delivered_death,
+					entry) {
+					struct binder_ref_death *tmp_death =
+					container_of(w,
+						struct binder_ref_death,
+								work);
 				if (tmp_death->cookie == cookie) {
 					death = tmp_death;
 					break;
 				}
 			}
 			binder_debug(BINDER_DEBUG_DEAD_BINDER,
-				     "%d:%d BC_DEAD_BINDER_DONE %p found %p\n",
+				"%d:%d BC_DEAD_BINDER_DONE %p found %p\n",
 				     proc->pid, thread->pid, cookie, death);
 			if (death == NULL) {
-				binder_user_error("%d:%d BC_DEAD_BINDER_DONE %p not found\n",
+				binder_user_error(
+				"%d:%d BC_DEAD_BINDER_DONE %p not found\n",
 					proc->pid, thread->pid, cookie);
 				break;
 			}
 
 			list_del_init(&death->work.entry);
-			if (death->work.type == BINDER_WORK_DEAD_BINDER_AND_CLEAR) {
-				death->work.type = BINDER_WORK_CLEAR_DEATH_NOTIFICATION;
-				if (thread->looper & (BINDER_LOOPER_STATE_REGISTERED | BINDER_LOOPER_STATE_ENTERED)) {
-					list_add_tail(&death->work.entry, &thread->todo);
+			if (death->work.type ==
+				BINDER_WORK_DEAD_BINDER_AND_CLEAR) {
+				death->work.type =
+					BINDER_WORK_CLEAR_DEATH_NOTIFICATION;
+				if (thread->looper &
+					(BINDER_LOOPER_STATE_REGISTERED|
+					BINDER_LOOPER_STATE_ENTERED)) {
+						list_add_tail(&death->
+								work.entry,
+								&thread->todo);
 				} else {
-					list_add_tail(&death->work.entry, &proc->todo);
+					list_add_tail(&death->work.entry,
+								&proc->todo);
 					wake_up_interruptible(&proc->wait);
 				}
 			}
@@ -2102,7 +2222,8 @@ retry:
 
 	if (thread->return_error != BR_OK && ptr < end) {
 		if (thread->return_error2 != BR_OK) {
-			if (put_user(thread->return_error2, (uint32_t __user *)ptr))
+			if (put_user(thread->return_error2,
+				(uint32_t __user *)ptr))
 				return -EFAULT;
 			ptr += sizeof(uint32_t);
 			binder_stat_br(proc, thread, thread->return_error2);
@@ -2141,13 +2262,15 @@ retry:
 			if (!binder_has_proc_work(proc, thread))
 				ret = -EAGAIN;
 		} else
-			ret = wait_event_freezable_exclusive(proc->wait, binder_has_proc_work(proc, thread));
+			ret = wait_event_freezable_exclusive(proc->wait,
+					binder_has_proc_work(proc, thread));
 	} else {
 		if (non_block) {
 			if (!binder_has_thread_work(thread))
 				ret = -EAGAIN;
 		} else
-			ret = wait_event_freezable(thread->wait, binder_has_thread_work(thread));
+			ret = wait_event_freezable(thread->wait,
+					binder_has_thread_work(thread));
 	}
 
 	binder_lock(__func__);
@@ -2166,11 +2289,18 @@ retry:
 		struct binder_transaction *t = NULL;
 
 		if (!list_empty(&thread->todo))
-			w = list_first_entry(&thread->todo, struct binder_work, entry);
+			w = list_first_entry(&thread->todo,
+					struct binder_work,
+					entry);
 		else if (!list_empty(&proc->todo) && wait_for_proc_work)
-			w = list_first_entry(&proc->todo, struct binder_work, entry);
+			w = list_first_entry(&proc->todo,
+					struct binder_work,
+					entry);
 		else {
-			if (ptr - buffer == 4 && !(thread->looper & BINDER_LOOPER_STATE_NEED_RETURN)) /* no data added */
+			if (ptr - buffer == 4 &&
+				!(thread->looper &
+				/* no data added */
+				BINDER_LOOPER_STATE_NEED_RETURN))
 				goto retry;
 			break;
 		}
@@ -2198,11 +2328,15 @@ retry:
 			binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
 		} break;
 		case BINDER_WORK_NODE: {
-			struct binder_node *node = container_of(w, struct binder_node, work);
+			struct binder_node *node = container_of(w,
+							struct binder_node,
+							work);
 			uint32_t cmd = BR_NOOP;
 			const char *cmd_name;
-			int strong = node->internal_strong_refs || node->local_strong_refs;
-			int weak = !hlist_empty(&node->refs) || node->local_weak_refs || strong;
+			int strong = node->internal_strong_refs ||
+					node->local_strong_refs;
+			int weak = !hlist_empty(&node->refs) ||
+					node->local_weak_refs || strong;
 			if (weak && !node->has_weak_ref) {
 				cmd = BR_INCREFS;
 				cmd_name = "BR_INCREFS";
@@ -2231,29 +2365,43 @@ retry:
 				if (put_user(node->ptr, (void * __user *)ptr))
 					return -EFAULT;
 				ptr += sizeof(void *);
-				if (put_user(node->cookie, (void * __user *)ptr))
+				if (put_user(node->cookie,
+					(void * __user *)ptr))
 					return -EFAULT;
 				ptr += sizeof(void *);
 
 				binder_stat_br(proc, thread, cmd);
 				binder_debug(BINDER_DEBUG_USER_REFS,
-					     "%d:%d %s %d u%p c%p\n",
-					     proc->pid, thread->pid, cmd_name, node->debug_id, node->ptr, node->cookie);
+						"%d:%d %s %d u%p c%p\n",
+						proc->pid,
+						thread->pid,
+						cmd_name,
+						node->debug_id,
+						node->ptr,
+						node->cookie);
 			} else {
 				list_del_init(&w->entry);
 				if (!weak && !strong) {
-					binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-						     "%d:%d node %d u%p c%p deleted\n",
-						     proc->pid, thread->pid, node->debug_id,
-						     node->ptr, node->cookie);
+					binder_debug(
+						BINDER_DEBUG_INTERNAL_REFS,
+					"%d:%d node %d u%p c%p deleted\n",
+						proc->pid,
+						thread->pid,
+						node->debug_id,
+						node->ptr, node->cookie);
 					rb_erase(&node->rb_node, &proc->nodes);
 					kfree(node);
-					binder_stats_deleted(BINDER_STAT_NODE);
+					binder_stats_deleted(
+						BINDER_STAT_NODE);
 				} else {
-					binder_debug(BINDER_DEBUG_INTERNAL_REFS,
-						     "%d:%d node %d u%p c%p state unchanged\n",
-						     proc->pid, thread->pid, node->debug_id, node->ptr,
-						     node->cookie);
+					binder_debug(
+						BINDER_DEBUG_INTERNAL_REFS,
+				"%d:%d node %d u%p c%p state unchanged\n",
+							proc->pid,
+							thread->pid,
+							node->debug_id,
+							node->ptr,
+							node->cookie);
 				}
 			}
 		} break;
@@ -2290,7 +2438,9 @@ retry:
 			} else
 				list_move(&w->entry, &proc->delivered_death);
 			if (cmd == BR_DEAD_BINDER)
-				goto done; /* DEAD_BINDER notifications can cause transactions */
+				/* DEAD_BINDER notifications
+					can cause transactions */
+				goto done;
 		} break;
 		}
 
@@ -2299,7 +2449,8 @@ retry:
 
 		BUG_ON(t->buffer == NULL);
 		if (t->buffer->target_node) {
-			struct binder_node *target_node = t->buffer->target_node;
+			struct binder_node *target_node =
+					t->buffer->target_node;
 			tr.target.ptr = target_node->ptr;
 			tr.cookie =  target_node->cookie;
 			t->saved_priority = task_nice(current);
@@ -2307,7 +2458,8 @@ retry:
 			    !(t->flags & TF_ONE_WAY))
 				binder_set_nice(t->priority);
 			else if (!(t->flags & TF_ONE_WAY) ||
-				 t->saved_priority > target_node->min_priority)
+				 t->saved_priority >
+					target_node->min_priority)
 				binder_set_nice(target_node->min_priority);
 			cmd = BR_TRANSACTION;
 		} else {
@@ -2322,7 +2474,8 @@ retry:
 		if (t->from) {
 			struct task_struct *sender = t->from->proc->tsk;
 			tr.sender_pid = task_tgid_nr_ns(sender,
-							task_active_pid_ns(current));
+							task_active_pid_ns(
+								current));
 		} else {
 			tr.sender_pid = 0;
 		}
@@ -2544,7 +2697,9 @@ static unsigned int binder_poll(struct file *filp,
 	return 0;
 }
 
-static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+static long binder_ioctl(struct file *filp,
+			unsigned int cmd,
+			unsigned long arg)
 {
 	int ret;
 	struct binder_proc *proc = filp->private_data;
@@ -2552,11 +2707,13 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	unsigned int size = _IOC_SIZE(cmd);
 	void __user *ubuf = (void __user *)arg;
 
-	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
+	/*pr_info("binder_ioctl: %d:%d %x %lx\n",
+		*proc->pid, current->pid, cmd, arg);*/
 
 	trace_binder_ioctl(cmd, arg);
 
-	ret = wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
+	ret = wait_event_interruptible(binder_user_error_wait,
+					binder_stop_on_user_error < 2);
 	if (ret)
 		goto err_unlocked;
 
@@ -2584,7 +2741,11 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			     bwr.write_buffer, bwr.read_size, bwr.read_buffer);
 
 		if (bwr.write_size > 0) {
-			ret = binder_thread_write(proc, thread, (void __user *)bwr.write_buffer, bwr.write_size, &bwr.write_consumed);
+			ret = binder_thread_write(proc,
+						thread,
+						(void __user *)bwr.write_buffer,
+						bwr.write_size,
+						&bwr.write_consumed);
 			trace_binder_write_done(ret);
 			if (ret < 0) {
 				bwr.read_consumed = 0;
@@ -2594,7 +2755,11 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		}
 		if (bwr.read_size > 0) {
-			ret = binder_thread_read(proc, thread, (void __user *)bwr.read_buffer, bwr.read_size, &bwr.read_consumed, filp->f_flags & O_NONBLOCK);
+			ret = binder_thread_read(proc, thread,
+					(void __user *)bwr.read_buffer,
+					bwr.read_size,
+					&bwr.read_consumed,
+					filp->f_flags & O_NONBLOCK);
 			trace_binder_read_done(ret);
 			if (!list_empty(&proc->todo))
 				wake_up_interruptible(&proc->wait);
@@ -2605,9 +2770,12 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d wrote %zd of %zd, read return %zd of %zd\n",
-			     proc->pid, thread->pid, bwr.write_consumed, bwr.write_size,
-			     bwr.read_consumed, bwr.read_size);
+			"%d:%d wrote %zd of %zd, read return %zd of %zd\n",
+				proc->pid,
+				thread->pid,
+				bwr.write_consumed,
+				bwr.write_size,
+				bwr.read_consumed, bwr.read_size);
 		if (copy_to_user(ubuf, &bwr, sizeof(bwr))) {
 			ret = -EFAULT;
 			goto err;
@@ -2615,7 +2783,8 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 	case BINDER_SET_MAX_THREADS:
-		if (copy_from_user(&proc->max_threads, ubuf, sizeof(proc->max_threads))) {
+		if (copy_from_user(&proc->max_threads,
+					ubuf, sizeof(proc->max_threads))) {
 			ret = -EINVAL;
 			goto err;
 		}
@@ -2627,10 +2796,14 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto err;
 		}
 		if (uid_valid(binder_context_mgr_uid)) {
-			if (!uid_eq(binder_context_mgr_uid, current->cred->euid)) {
-				pr_err("BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
-				       from_kuid(&init_user_ns, current->cred->euid),
-				       from_kuid(&init_user_ns, binder_context_mgr_uid));
+			if (!uid_eq(binder_context_mgr_uid,
+				current->cred->euid)) {
+					pr_err(
+				"BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
+						from_kuid(&init_user_ns,
+						current->cred->euid),
+						from_kuid(&init_user_ns,
+						binder_context_mgr_uid));
 				ret = -EPERM;
 				goto err;
 			}
@@ -2657,7 +2830,8 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			ret = -EINVAL;
 			goto err;
 		}
-		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
+		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
+			&((struct binder_version *)ubuf)->protocol_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
@@ -2671,9 +2845,11 @@ err:
 	if (thread)
 		thread->looper &= ~BINDER_LOOPER_STATE_NEED_RETURN;
 	binder_unlock(__func__);
-	wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
+	wait_event_interruptible(binder_user_error_wait,
+				binder_stop_on_user_error < 2);
 	if (ret && ret != -ERESTARTSYS)
-		pr_info("%d:%d ioctl %x %lx returned %d\n", proc->pid, current->pid, cmd, arg, ret);
+		pr_info("%d:%d ioctl %x %lx returned %d\n",
+			proc->pid, current->pid, cmd, arg, ret);
 err_unlocked:
 	trace_binder_ioctl_done(ret);
 	return ret;
@@ -2753,13 +2929,17 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
-		while (CACHE_COLOUR((vma->vm_start ^ (uint32_t)proc->buffer))) {
-			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n", proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
+		while (CACHE_COLOUR((vma->vm_start ^
+				(uint32_t)proc->buffer))) {
+			pr_info(
+			"binder_mmap: %d %lx-%lx maps %p bad alignment\n",
+			proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
 			vma->vm_start += PAGE_SIZE;
 		}
 	}
 #endif
-	proc->pages = kzalloc(sizeof(proc->pages[0]) * ((vma->vm_end - vma->vm_start) / PAGE_SIZE), GFP_KERNEL);
+	proc->pages = kzalloc(sizeof(proc->pages[0]) *
+		((vma->vm_end - vma->vm_start) / PAGE_SIZE), GFP_KERNEL);
 	if (proc->pages == NULL) {
 		ret = -ENOMEM;
 		failure_string = "alloc page array";
@@ -2770,7 +2950,8 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_ops = &binder_vm_ops;
 	vma->vm_private_data = proc;
 
-	if (binder_update_page_range(proc, 1, proc->buffer, proc->buffer + PAGE_SIZE, vma)) {
+	if (binder_update_page_range(proc, 1,
+			proc->buffer, proc->buffer + PAGE_SIZE, vma)) {
 		ret = -ENOMEM;
 		failure_string = "alloc small buf";
 		goto err_alloc_small_buf_failed;
@@ -2836,7 +3017,8 @@ static int binder_open(struct inode *nodp, struct file *filp)
 		char strbuf[11];
 		snprintf(strbuf, sizeof(strbuf), "%u", proc->pid);
 		proc->debugfs_entry = debugfs_create_file(strbuf, S_IRUGO,
-			binder_debugfs_dir_entry_proc, proc, &binder_proc_fops);
+			binder_debugfs_dir_entry_proc,
+						proc, &binder_proc_fops);
 	}
 
 	return 0;
@@ -2856,7 +3038,9 @@ static void binder_deferred_flush(struct binder_proc *proc)
 	struct rb_node *n;
 	int wake_count = 0;
 	for (n = rb_first(&proc->threads); n != NULL; n = rb_next(n)) {
-		struct binder_thread *thread = rb_entry(n, struct binder_thread, rb_node);
+		struct binder_thread *thread = rb_entry(n,
+						struct binder_thread,
+						rb_node);
 		thread->looper |= BINDER_LOOPER_STATE_NEED_RETURN;
 		if (thread->looper & BINDER_LOOPER_STATE_WAITING) {
 			wake_up_interruptible(&thread->wait);
@@ -3011,7 +3195,8 @@ static void binder_deferred_release(struct binder_proc *proc)
 			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
 				     "%s: %d: page %d at %p not freed\n",
 				     __func__, proc->pid, i, page_addr);
-			unmap_kernel_range((unsigned long)page_addr, PAGE_SIZE);
+			unmap_kernel_range((unsigned long)page_addr,
+								PAGE_SIZE);
 			__free_page(proc->pages[i]);
 			page_count++;
 		}
@@ -3040,7 +3225,8 @@ static void binder_deferred_func(struct work_struct *work)
 		mutex_lock(&binder_deferred_lock);
 		if (!hlist_empty(&binder_deferred_list)) {
 			proc = hlist_entry(binder_deferred_list.first,
-					struct binder_proc, deferred_work_node);
+					struct binder_proc,
+					deferred_work_node);
 			hlist_del_init(&proc->deferred_work_node);
 			defer = proc->deferred_work;
 			proc->deferred_work = 0;
@@ -3468,10 +3654,10 @@ static int binder_proc_show(struct seq_file *m, void *unused)
 }
 
 static void print_binder_transaction_log_entry(struct seq_file *m,
-					struct binder_transaction_log_entry *e)
+				struct binder_transaction_log_entry *e)
 {
 	seq_printf(m,
-		   "%d: %s from %d:%d to %d:%d node %d handle %d size %d:%d\n",
+		  "%d: %s from %d:%d to %d:%d node %d handle %d size %d:%d\n",
 		   e->debug_id, (e->call_type == 2) ? "reply" :
 		   ((e->call_type == 1) ? "async" : "call "), e->from_proc,
 		   e->from_thread, e->to_proc, e->to_thread, e->to_node,
-- 
1.8.3.1

