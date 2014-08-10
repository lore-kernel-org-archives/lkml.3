Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751493AbaHJTm6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 15:42:58 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36146 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaHJTm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 15:42:56 -0400
Message-ID: <53E7CB3D.3030403@gmail.com>
Date: Sun, 10 Aug 2014 22:42:53 +0300
From: Tair Rzayev <tair.rzayev@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: arve@android.com, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: android: binder.c: rename binder_user_error()
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename binder_user_error() to shorter but no less readable binder_usr_err()
which fixes 34 "line over 80 characters" checkpatch warnings

Signed-off-by: Tair Rzayev <tair.rzayev@gmail.com>
---
 drivers/staging/android/binder.c | 74 ++++++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 4f34dc0..7b39a68 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -133,7 +133,7 @@ module_param_call(stop_on_user_error, binder_set_stop_on_user_error,
 			pr_info(x); \
 	} while (0)
 
-#define binder_user_error(x...) \
+#define binder_usr_err(x...) \
 	do { \
 		if (binder_debug_mask & BINDER_DEBUG_USER_ERROR) \
 			pr_info(x); \
@@ -446,7 +446,7 @@ static void binder_set_nice(long nice)
 	set_user_nice(current, min_nice);
 	if (min_nice <= MAX_NICE)
 		return;
-	binder_user_error("%d RLIMIT_NICE not set\n", current->pid);
+	binder_usr_err("%d RLIMIT_NICE not set\n", current->pid);
 }
 
 static size_t binder_buffer_size(struct binder_proc *proc,
@@ -664,7 +664,7 @@ static struct binder_buffer *binder_alloc_buf(struct binder_proc *proc,
 		ALIGN(offsets_size, sizeof(void *));
 
 	if (size < data_size || size < offsets_size) {
-		binder_user_error("%d: got transaction with invalid size %zd-%zd\n",
+		binder_usr_err("%d: got transaction with invalid size %zd-%zd\n",
 				proc->pid, data_size, offsets_size);
 		return NULL;
 	}
@@ -1135,7 +1135,7 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 {
 	if (strong) {
 		if (ref->strong == 0) {
-			binder_user_error("%d invalid dec strong, ref %d desc %d s %d w %d\n",
+			binder_usr_err("%d invalid dec strong, ref %d desc %d s %d w %d\n",
 					  ref->proc->pid, ref->debug_id,
 					  ref->desc, ref->strong, ref->weak);
 			return -EINVAL;
@@ -1150,7 +1150,7 @@ static int binder_dec_ref(struct binder_ref *ref, int strong)
 		}
 	} else {
 		if (ref->weak == 0) {
-			binder_user_error("%d invalid dec weak, ref %d desc %d s %d w %d\n",
+			binder_usr_err("%d invalid dec weak, ref %d desc %d s %d w %d\n",
 					  ref->proc->pid, ref->debug_id,
 					  ref->desc, ref->strong, ref->weak);
 			return -EINVAL;
@@ -1335,14 +1335,14 @@ static void binder_transaction(struct binder_proc *proc,
 	if (reply) {
 		in_reply_to = thread->transaction_stack;
 		if (in_reply_to == NULL) {
-			binder_user_error("%d:%d got reply transaction with no transaction stack\n",
+			binder_usr_err("%d:%d got reply transaction with no transaction stack\n",
 					  proc->pid, thread->pid);
 			return_error = BR_FAILED_REPLY;
 			goto err_empty_call_stack;
 		}
 		binder_set_nice(in_reply_to->saved_priority);
 		if (in_reply_to->to_thread != thread) {
-			binder_user_error("%d:%d got reply transaction with bad transaction stack, transaction %d has target %d:%d\n",
+			binder_usr_err("%d:%d got reply transaction with bad transaction stack, transaction %d has target %d:%d\n",
 				proc->pid, thread->pid, in_reply_to->debug_id,
 				in_reply_to->to_proc ?
 				in_reply_to->to_proc->pid : 0,
@@ -1359,7 +1359,7 @@ static void binder_transaction(struct binder_proc *proc,
 			goto err_dead_binder;
 		}
 		if (target_thread->transaction_stack != in_reply_to) {
-			binder_user_error("%d:%d got reply transaction with bad target transaction stack %d, expected %d\n",
+			binder_usr_err("%d:%d got reply transaction with bad target transaction stack %d, expected %d\n",
 				proc->pid, thread->pid,
 				target_thread->transaction_stack ?
 				target_thread->transaction_stack->debug_id : 0,
@@ -1376,7 +1376,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 			ref = binder_get_ref(proc, tr->target.handle);
 			if (ref == NULL) {
-				binder_user_error("%d:%d got transaction to invalid handle\n",
+				binder_usr_err("%d:%d got transaction to invalid handle\n",
 					proc->pid, thread->pid);
 				return_error = BR_FAILED_REPLY;
 				goto err_invalid_target_handle;
@@ -1400,7 +1400,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 			tmp = thread->transaction_stack;
 			if (tmp->to_thread != thread) {
-				binder_user_error("%d:%d got new transaction with bad transaction stack, transaction %d has target %d:%d\n",
+				binder_usr_err("%d:%d got new transaction with bad transaction stack, transaction %d has target %d:%d\n",
 					proc->pid, thread->pid, tmp->debug_id,
 					tmp->to_proc ? tmp->to_proc->pid : 0,
 					tmp->to_thread ?
@@ -1492,20 +1492,20 @@ static void binder_transaction(struct binder_proc *proc,
 
 	if (copy_from_user(t->buffer->data, (const void __user *)(uintptr_t)
 			   tr->data.ptr.buffer, tr->data_size)) {
-		binder_user_error("%d:%d got transaction with invalid data ptr\n",
+		binder_usr_err("%d:%d got transaction with invalid data ptr\n",
 				proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
 	if (copy_from_user(offp, (const void __user *)(uintptr_t)
 			   tr->data.ptr.offsets, tr->offsets_size)) {
-		binder_user_error("%d:%d got transaction with invalid offsets ptr\n",
+		binder_usr_err("%d:%d got transaction with invalid offsets ptr\n",
 				proc->pid, thread->pid);
 		return_error = BR_FAILED_REPLY;
 		goto err_copy_data_failed;
 	}
 	if (!IS_ALIGNED(tr->offsets_size, sizeof(binder_size_t))) {
-		binder_user_error("%d:%d got transaction with invalid offsets size, %lld\n",
+		binder_usr_err("%d:%d got transaction with invalid offsets size, %lld\n",
 				proc->pid, thread->pid, (u64)tr->offsets_size);
 		return_error = BR_FAILED_REPLY;
 		goto err_bad_offset;
@@ -1517,7 +1517,7 @@ static void binder_transaction(struct binder_proc *proc,
 		if (*offp > t->buffer->data_size - sizeof(*fp) ||
 		    t->buffer->data_size < sizeof(*fp) ||
 		    !IS_ALIGNED(*offp, sizeof(u32))) {
-			binder_user_error("%d:%d got transaction with invalid offset, %lld\n",
+			binder_usr_err("%d:%d got transaction with invalid offset, %lld\n",
 					  proc->pid, thread->pid, (u64)*offp);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_offset;
@@ -1539,7 +1539,7 @@ static void binder_transaction(struct binder_proc *proc,
 				node->accept_fds = !!(fp->flags & FLAT_BINDER_FLAG_ACCEPTS_FDS);
 			}
 			if (fp->cookie != node->cookie) {
-				binder_user_error("%d:%d sending u%016llx node %d, cookie mismatch %016llx != %016llx\n",
+				binder_usr_err("%d:%d sending u%016llx node %d, cookie mismatch %016llx != %016llx\n",
 					proc->pid, thread->pid,
 					(u64)fp->binder, node->debug_id,
 					(u64)fp->cookie, (u64)node->cookie);
@@ -1570,7 +1570,7 @@ static void binder_transaction(struct binder_proc *proc,
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 
 			if (ref == NULL) {
-				binder_user_error("%d:%d got transaction with invalid handle, %d\n",
+				binder_usr_err("%d:%d got transaction with invalid handle, %d\n",
 						proc->pid,
 						thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
@@ -1614,13 +1614,13 @@ static void binder_transaction(struct binder_proc *proc,
 
 			if (reply) {
 				if (!(in_reply_to->flags & TF_ACCEPT_FDS)) {
-					binder_user_error("%d:%d got reply with fd, %d, but target does not allow fds\n",
+					binder_usr_err("%d:%d got reply with fd, %d, but target does not allow fds\n",
 						proc->pid, thread->pid, fp->handle);
 					return_error = BR_FAILED_REPLY;
 					goto err_fd_not_allowed;
 				}
 			} else if (!target_node->accept_fds) {
-				binder_user_error("%d:%d got transaction with fd, %d, but target does not allow fds\n",
+				binder_usr_err("%d:%d got transaction with fd, %d, but target does not allow fds\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fd_not_allowed;
@@ -1628,7 +1628,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 			file = fget(fp->handle);
 			if (file == NULL) {
-				binder_user_error("%d:%d got transaction with invalid fd, %d\n",
+				binder_usr_err("%d:%d got transaction with invalid fd, %d\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fget_failed;
@@ -1648,7 +1648,7 @@ static void binder_transaction(struct binder_proc *proc,
 		} break;
 
 		default:
-			binder_user_error("%d:%d got transaction with invalid object type, %x\n",
+			binder_usr_err("%d:%d got transaction with invalid object type, %x\n",
 				proc->pid, thread->pid, fp->type);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_object_type;
@@ -1761,14 +1761,14 @@ static int binder_thread_write(struct binder_proc *proc,
 				ref = binder_get_ref_for_node(proc,
 					       binder_context_mgr_node);
 				if (ref->desc != target) {
-					binder_user_error("%d:%d tried to acquire reference to desc 0, got %d instead\n",
+					binder_usr_err("%d:%d tried to acquire reference to desc 0, got %d instead\n",
 						proc->pid, thread->pid,
 						ref->desc);
 				}
 			} else
 				ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
-				binder_user_error("%d:%d refcount change on invalid ref %d\n",
+				binder_usr_err("%d:%d refcount change on invalid ref %d\n",
 					proc->pid, thread->pid, target);
 				break;
 			}
@@ -1811,7 +1811,7 @@ static int binder_thread_write(struct binder_proc *proc,
 			ptr += sizeof(binder_uintptr_t);
 			node = binder_get_node(proc, node_ptr);
 			if (node == NULL) {
-				binder_user_error("%d:%d %s u%016llx no match\n",
+				binder_usr_err("%d:%d %s u%016llx no match\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" :
@@ -1820,7 +1820,7 @@ static int binder_thread_write(struct binder_proc *proc,
 				break;
 			}
 			if (cookie != node->cookie) {
-				binder_user_error("%d:%d %s u%016llx node %d cookie mismatch %016llx != %016llx\n",
+				binder_usr_err("%d:%d %s u%016llx node %d cookie mismatch %016llx != %016llx\n",
 					proc->pid, thread->pid,
 					cmd == BC_INCREFS_DONE ?
 					"BC_INCREFS_DONE" : "BC_ACQUIRE_DONE",
@@ -1830,7 +1830,7 @@ static int binder_thread_write(struct binder_proc *proc,
 			}
 			if (cmd == BC_ACQUIRE_DONE) {
 				if (node->pending_strong_ref == 0) {
-					binder_user_error("%d:%d BC_ACQUIRE_DONE node %d has no pending acquire request\n",
+					binder_usr_err("%d:%d BC_ACQUIRE_DONE node %d has no pending acquire request\n",
 						proc->pid, thread->pid,
 						node->debug_id);
 					break;
@@ -1838,7 +1838,7 @@ static int binder_thread_write(struct binder_proc *proc,
 				node->pending_strong_ref = 0;
 			} else {
 				if (node->pending_weak_ref == 0) {
-					binder_user_error("%d:%d BC_INCREFS_DONE node %d has no pending increfs request\n",
+					binder_usr_err("%d:%d BC_INCREFS_DONE node %d has no pending increfs request\n",
 						proc->pid, thread->pid,
 						node->debug_id);
 					break;
@@ -1870,12 +1870,12 @@ static int binder_thread_write(struct binder_proc *proc,
 
 			buffer = binder_buffer_lookup(proc, data_ptr);
 			if (buffer == NULL) {
-				binder_user_error("%d:%d BC_FREE_BUFFER u%016llx no match\n",
+				binder_usr_err("%d:%d BC_FREE_BUFFER u%016llx no match\n",
 					proc->pid, thread->pid, (u64)data_ptr);
 				break;
 			}
 			if (!buffer->allow_user_free) {
-				binder_user_error("%d:%d BC_FREE_BUFFER u%016llx matched unreturned buffer\n",
+				binder_usr_err("%d:%d BC_FREE_BUFFER u%016llx matched unreturned buffer\n",
 					proc->pid, thread->pid, (u64)data_ptr);
 				break;
 			}
@@ -1919,11 +1919,11 @@ static int binder_thread_write(struct binder_proc *proc,
 				     proc->pid, thread->pid);
 			if (thread->looper & BINDER_LOOPER_STATE_ENTERED) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("%d:%d ERROR: BC_REGISTER_LOOPER called after BC_ENTER_LOOPER\n",
+				binder_usr_err("%d:%d ERROR: BC_REGISTER_LOOPER called after BC_ENTER_LOOPER\n",
 					proc->pid, thread->pid);
 			} else if (proc->requested_threads == 0) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("%d:%d ERROR: BC_REGISTER_LOOPER called without request\n",
+				binder_usr_err("%d:%d ERROR: BC_REGISTER_LOOPER called without request\n",
 					proc->pid, thread->pid);
 			} else {
 				proc->requested_threads--;
@@ -1937,7 +1937,7 @@ static int binder_thread_write(struct binder_proc *proc,
 				     proc->pid, thread->pid);
 			if (thread->looper & BINDER_LOOPER_STATE_REGISTERED) {
 				thread->looper |= BINDER_LOOPER_STATE_INVALID;
-				binder_user_error("%d:%d ERROR: BC_ENTER_LOOPER called after BC_REGISTER_LOOPER\n",
+				binder_usr_err("%d:%d ERROR: BC_ENTER_LOOPER called after BC_REGISTER_LOOPER\n",
 					proc->pid, thread->pid);
 			}
 			thread->looper |= BINDER_LOOPER_STATE_ENTERED;
@@ -1964,7 +1964,7 @@ static int binder_thread_write(struct binder_proc *proc,
 			ptr += sizeof(binder_uintptr_t);
 			ref = binder_get_ref(proc, target);
 			if (ref == NULL) {
-				binder_user_error("%d:%d %s invalid ref %d\n",
+				binder_usr_err("%d:%d %s invalid ref %d\n",
 					proc->pid, thread->pid,
 					cmd == BC_REQUEST_DEATH_NOTIFICATION ?
 					"BC_REQUEST_DEATH_NOTIFICATION" :
@@ -1984,7 +1984,7 @@ static int binder_thread_write(struct binder_proc *proc,
 
 			if (cmd == BC_REQUEST_DEATH_NOTIFICATION) {
 				if (ref->death) {
-					binder_user_error("%d:%d BC_REQUEST_DEATH_NOTIFICATION death notification already set\n",
+					binder_usr_err("%d:%d BC_REQUEST_DEATH_NOTIFICATION death notification already set\n",
 						proc->pid, thread->pid);
 					break;
 				}
@@ -2011,13 +2011,13 @@ static int binder_thread_write(struct binder_proc *proc,
 				}
 			} else {
 				if (ref->death == NULL) {
-					binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification not active\n",
+					binder_usr_err("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification not active\n",
 						proc->pid, thread->pid);
 					break;
 				}
 				death = ref->death;
 				if (death->cookie != cookie) {
-					binder_user_error("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification cookie mismatch %016llx != %016llx\n",
+					binder_usr_err("%d:%d BC_CLEAR_DEATH_NOTIFICATION death notification cookie mismatch %016llx != %016llx\n",
 						proc->pid, thread->pid,
 						(u64)death->cookie,
 						(u64)cookie);
@@ -2060,7 +2060,7 @@ static int binder_thread_write(struct binder_proc *proc,
 				     proc->pid, thread->pid, (u64)cookie,
 				     death);
 			if (death == NULL) {
-				binder_user_error("%d:%d BC_DEAD_BINDER_DONE %016llx not found\n",
+				binder_usr_err("%d:%d BC_DEAD_BINDER_DONE %016llx not found\n",
 					proc->pid, thread->pid, (u64)cookie);
 				break;
 			}
@@ -2164,7 +2164,7 @@ retry:
 	if (wait_for_proc_work) {
 		if (!(thread->looper & (BINDER_LOOPER_STATE_REGISTERED |
 					BINDER_LOOPER_STATE_ENTERED))) {
-			binder_user_error("%d:%d ERROR: Thread waiting for process work before calling BC_REGISTER_LOOPER or BC_ENTER_LOOPER (state %x)\n",
+			binder_usr_err("%d:%d ERROR: Thread waiting for process work before calling BC_REGISTER_LOOPER or BC_ENTER_LOOPER (state %x)\n",
 				proc->pid, thread->pid, thread->looper);
 			wait_event_interruptible(binder_user_error_wait,
 						 binder_stop_on_user_error < 2);
-- 
1.9.1


