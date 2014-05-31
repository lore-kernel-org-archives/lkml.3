Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaEaEbn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 00:31:43 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:63755 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbaEaEbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 00:31:41 -0400
From: Daniel Dressler <danieru.dressler@gmail.com>
To: gregkh@linuxfoundation.org
Cc: arve@android.com, serban.constantinescu@arm.com, prtvar.b@gmail.com,
        john.stultz@linaro.org, standby24x7@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        danieru <danieru.dressler@gmail.com>
Subject: [PATCH] Staging: android: binder: Fix over-80-char lines
Date: Fri, 30 May 2014 22:31:20 -0600
Message-Id: <1401510680-13991-1-git-send-email-danieru.dressler@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: danieru <danieru.dressler@gmail.com>

Following Greg Kroah-Hartman's newbie guide to hacking
the linux kernel this patch addresses only coding style
issues.

Binder still has many too-long lines but I'm worried
doing too much work in a single patch is unfair to the
reviewers. So this patch address 20% of the file's
issues.

There is one change to take notice of: it merges two if
statement's conditionals together. Then it removes a
redundant else clause.

Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>
---
 drivers/staging/android/binder.c | 89 ++++++++++++++++++++++++----------------
 1 file changed, 54 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index cfe4bc8..6e80861a 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2211,11 +2211,14 @@ retry:
 			binder_stats_deleted(BINDER_STAT_TRANSACTION_COMPLETE);
 		} break;
 		case BINDER_WORK_NODE: {
-			struct binder_node *node = container_of(w, struct binder_node, work);
+			struct binder_node *node = container_of(w,
+						struct binder_node, work);
 			uint32_t cmd = BR_NOOP;
 			const char *cmd_name;
-			int strong = node->internal_strong_refs || node->local_strong_refs;
-			int weak = !hlist_empty(&node->refs) || node->local_weak_refs || strong;
+			int strong = node->internal_strong_refs ||
+						node->local_strong_refs;
+			int weak = !hlist_empty(&node->refs) ||
+					node->local_weak_refs || strong;
 			if (weak && !node->has_weak_ref) {
 				cmd = BR_INCREFS;
 				cmd_name = "BR_INCREFS";
@@ -2311,8 +2314,10 @@ retry:
 				binder_stats_deleted(BINDER_STAT_DEATH);
 			} else
 				list_move(&w->entry, &proc->delivered_death);
+
+			/* DEAD_BINDER notifications can cause transactions */
 			if (cmd == BR_DEAD_BINDER)
-				goto done; /* DEAD_BINDER notifications can cause transactions */
+				goto done;
 		} break;
 		}
 
@@ -2321,7 +2326,8 @@ retry:
 
 		BUG_ON(t->buffer == NULL);
 		if (t->buffer->target_node) {
-			struct binder_node *target_node = t->buffer->target_node;
+			struct binder_node *target_node =
+							t->buffer->target_node;
 			tr.target.ptr = target_node->ptr;
 			tr.cookie =  target_node->cookie;
 			t->saved_priority = task_nice(current);
@@ -2344,7 +2350,7 @@ retry:
 		if (t->from) {
 			struct task_struct *sender = t->from->proc->tsk;
 			tr.sender_pid = task_tgid_nr_ns(sender,
-							task_active_pid_ns(current));
+						task_active_pid_ns(current));
 		} else {
 			tr.sender_pid = 0;
 		}
@@ -2575,11 +2581,13 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	unsigned int size = _IOC_SIZE(cmd);
 	void __user *ubuf = (void __user *)arg;
 
-	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
+	/*pr_info("binder_ioctl: %d:%d %x %lx\n",
+					proc->pid, current->pid, cmd, arg);*/
 
 	trace_binder_ioctl(cmd, arg);
 
-	ret = wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
+	ret = wait_event_interruptible(binder_user_error_wait,
+						binder_stop_on_user_error < 2);
 	if (ret)
 		goto err_unlocked;
 
@@ -2602,10 +2610,10 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto err;
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d write %lld at %016llx, read %lld at %016llx\n",
-			     proc->pid, thread->pid,
-			     (u64)bwr.write_size, (u64)bwr.write_buffer,
-			     (u64)bwr.read_size, (u64)bwr.read_buffer);
+			"%d:%d write %lld at %016llx, read %lld at %016llx\n",
+			proc->pid, thread->pid,
+			(u64)bwr.write_size, (u64)bwr.write_buffer,
+			(u64)bwr.read_size, (u64)bwr.read_buffer);
 
 		if (bwr.write_size > 0) {
 			ret = binder_thread_write(proc, thread,
@@ -2635,10 +2643,10 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d wrote %lld of %lld, read return %lld of %lld\n",
-			     proc->pid, thread->pid,
-			     (u64)bwr.write_consumed, (u64)bwr.write_size,
-			     (u64)bwr.read_consumed, (u64)bwr.read_size);
+			"%d:%d wrote %lld of %lld, read return %lld of %lld\n",
+			proc->pid, thread->pid,
+			(u64)bwr.write_consumed, (u64)bwr.write_size,
+			(u64)bwr.read_consumed, (u64)bwr.read_size);
 		if (copy_to_user(ubuf, &bwr, sizeof(bwr))) {
 			ret = -EFAULT;
 			goto err;
@@ -2646,7 +2654,8 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 	case BINDER_SET_MAX_THREADS:
-		if (copy_from_user(&proc->max_threads, ubuf, sizeof(proc->max_threads))) {
+		if (copy_from_user(&proc->max_threads, ubuf,
+						sizeof(proc->max_threads))) {
 			ret = -EINVAL;
 			goto err;
 		}
@@ -2657,16 +2666,16 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			ret = -EBUSY;
 			goto err;
 		}
-		if (uid_valid(binder_context_mgr_uid)) {
-			if (!uid_eq(binder_context_mgr_uid, current->cred->euid)) {
-				pr_err("BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
-				       from_kuid(&init_user_ns, current->cred->euid),
-				       from_kuid(&init_user_ns, binder_context_mgr_uid));
-				ret = -EPERM;
-				goto err;
-			}
-		} else
-			binder_context_mgr_uid = current->cred->euid;
+		if (uid_valid(binder_context_mgr_uid) &&
+			!uid_eq(binder_context_mgr_uid, current->cred->euid)) {
+			pr_err("BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
+			       from_kuid(&init_user_ns, current->cred->euid),
+			       from_kuid(&init_user_ns, binder_context_mgr_uid)
+			       );
+			ret = -EPERM;
+			goto err;
+		}
+		binder_context_mgr_uid = current->cred->euid;
 		binder_context_mgr_node = binder_new_node(proc, 0, 0);
 		if (binder_context_mgr_node == NULL) {
 			ret = -ENOMEM;
@@ -2688,7 +2697,8 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			ret = -EINVAL;
 			goto err;
 		}
-		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION, &((struct binder_version *)ubuf)->protocol_version)) {
+		if (put_user(BINDER_CURRENT_PROTOCOL_VERSION,
+			&((struct binder_version *)ubuf)->protocol_version)) {
 			ret = -EINVAL;
 			goto err;
 		}
@@ -2702,9 +2712,11 @@ err:
 	if (thread)
 		thread->looper &= ~BINDER_LOOPER_STATE_NEED_RETURN;
 	binder_unlock(__func__);
-	wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
+	wait_event_interruptible(binder_user_error_wait,
+						binder_stop_on_user_error < 2);
 	if (ret && ret != -ERESTARTSYS)
-		pr_info("%d:%d ioctl %x %lx returned %d\n", proc->pid, current->pid, cmd, arg, ret);
+		pr_info("%d:%d ioctl %x %lx returned %d\n", proc->pid,
+						current->pid, cmd, arg, ret);
 err_unlocked:
 	trace_binder_ioctl_done(ret);
 	return ret;
@@ -2784,13 +2796,18 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
-		while (CACHE_COLOUR((vma->vm_start ^ (uint32_t)proc->buffer))) {
-			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n", proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
+		uint32_t proc_buffer = (uint32_t)proc->buffer;
+		while (CACHE_COLOUR((vma->vm_start ^ proc_buffer))) {
+			pr_info(
+			"binder_mmap: %d %lx-%lx maps %p bad alignment\n",
+						proc->pid, vma->vm_start,
+						vma->vm_end, proc->buffer);
 			vma->vm_start += PAGE_SIZE;
 		}
 	}
 #endif
-	proc->pages = kzalloc(sizeof(proc->pages[0]) * ((vma->vm_end - vma->vm_start) / PAGE_SIZE), GFP_KERNEL);
+	size_t num_pages = (vma->vm_end - vma->vm_start) / PAGE_SIZE;
+	proc->pages = kzalloc(sizeof(proc->pages[0]) * num_pages, GFP_KERNEL);
 	if (proc->pages == NULL) {
 		ret = -ENOMEM;
 		failure_string = "alloc page array";
@@ -2801,7 +2818,8 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_ops = &binder_vm_ops;
 	vma->vm_private_data = proc;
 
-	if (binder_update_page_range(proc, 1, proc->buffer, proc->buffer + PAGE_SIZE, vma)) {
+	if (binder_update_page_range(proc, 1, proc->buffer,
+					proc->buffer + PAGE_SIZE, vma)) {
 		ret = -ENOMEM;
 		failure_string = "alloc small buf";
 		goto err_alloc_small_buf_failed;
@@ -2887,7 +2905,8 @@ static void binder_deferred_flush(struct binder_proc *proc)
 	struct rb_node *n;
 	int wake_count = 0;
 	for (n = rb_first(&proc->threads); n != NULL; n = rb_next(n)) {
-		struct binder_thread *thread = rb_entry(n, struct binder_thread, rb_node);
+		struct binder_thread *thread = rb_entry(n, struct binder_thread,
+								rb_node);
 		thread->looper |= BINDER_LOOPER_STATE_NEED_RETURN;
 		if (thread->looper & BINDER_LOOPER_STATE_WAITING) {
 			wake_up_interruptible(&thread->wait);
-- 
1.9.1

