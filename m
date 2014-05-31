Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673AbaEaXaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 19:30:14 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:51167 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaEaXaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 19:30:12 -0400
From: Daniel Dressler <danieru.dressler@gmail.com>
To: danieru.dressler@gmail.com
Cc: john.stultz@linaro.org, yangds.fnst@cn.fujitsu.com, prtvar.b@gmail.com,
        waydi1@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, serban.constantinescu@arm.com,
        arve@android.com, gregkh@linuxfoundation.org
Subject: [PATCH] staging: android: binder: Fix 10 overlong lines
Date: Sat, 31 May 2014 17:29:53 -0600
Message-Id: <1401578993-24829-1-git-send-email-danieru.dressler@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch was made following Greg Kroah-Hartman's
newbie guide. It is not intended to make any
logical alterations to codeflow. Of note to reviews
this patch switch's a call to kzalloc to kcalloc on
line 2837

Neil Brown gave good advice on how to align
the over-long function calls. He suggested
using a single tab to indent the arguments.
Like thus:
var = function(
	arg1, arg2, arg3, arg4);

I intended to use the style he suggested but
noticed much of the existing code instead
aligns the overflow with the first argument
and tries to give all arguments equal space.
Like thus:
var = function(arg1, arg2
	       arg3, arg4);

This second method uses spaces to align the
arguments.

Taking a survey of the first 800 lines the
following lines used each method:

Method #1: 666, 527, 572
Method #2: 475, 495, 520, 545, 554, 582, 630,
           677, 788

Thus to maintain consistancy this patch uses
method #1. If method #1 is not acceptable
please do not hesitate to say so.

Signed-off-by: Daniel Dressler <danieru.dressler@gmail.com>
---
 drivers/staging/android/binder.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index c7392bc..d45dd43 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2604,11 +2604,13 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	void __user *ubuf = (void __user *)arg;
 	const struct cred *cred = current_cred();
 
-	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
+	/*pr_info("binder_ioctl: %d:%d %x %lx\n",
+		  proc->pid, current->pid, cmd, arg);*/
 
 	trace_binder_ioctl(cmd, arg);
 
-	ret = wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
+	ret = wait_event_interruptible(binder_user_error_wait,
+				       binder_stop_on_user_error < 2);
 	if (ret)
 		goto err_unlocked;
 
@@ -2676,7 +2678,8 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 	case BINDER_SET_MAX_THREADS:
-		if (copy_from_user(&proc->max_threads, ubuf, sizeof(proc->max_threads))) {
+		if (copy_from_user(&proc->max_threads, ubuf,
+				   sizeof(proc->max_threads))) {
 			ret = -EINVAL;
 			goto err;
 		}
@@ -2691,7 +2694,8 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			if (!uid_eq(binder_context_mgr_uid, cred->euid)) {
 				pr_err("BINDER_SET_CONTEXT_MGR bad uid %d != %d\n",
 				       from_kuid(&init_user_ns, cred->euid),
-				       from_kuid(&init_user_ns, binder_context_mgr_uid));
+				       from_kuid(&init_user_ns,
+						 binder_context_mgr_uid));
 				ret = -EPERM;
 				goto err;
 			}
@@ -2736,9 +2740,11 @@ err:
 	if (thread)
 		thread->looper &= ~BINDER_LOOPER_STATE_NEED_RETURN;
 	binder_unlock(__func__);
-	wait_event_interruptible(binder_user_error_wait, binder_stop_on_user_error < 2);
+	wait_event_interruptible(binder_user_error_wait,
+				 binder_stop_on_user_error < 2);
 	if (ret && ret != -ERESTARTSYS)
-		pr_info("%d:%d ioctl %x %lx returned %d\n", proc->pid, current->pid, cmd, arg, ret);
+		pr_info("%d:%d ioctl %x %lx returned %d\n",
+			proc->pid, current->pid, cmd, arg, ret);
 err_unlocked:
 	trace_binder_ioctl_done(ret);
 	return ret;
@@ -2821,12 +2827,15 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 #ifdef CONFIG_CPU_CACHE_VIPT
 	if (cache_is_vipt_aliasing()) {
 		while (CACHE_COLOUR((vma->vm_start ^ (uint32_t)proc->buffer))) {
-			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n", proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
+			pr_info("binder_mmap: %d %lx-%lx maps %p bad alignment\n",
+				proc->pid, vma->vm_start, vma->vm_end,
+				proc->buffer);
 			vma->vm_start += PAGE_SIZE;
 		}
 	}
 #endif
-	proc->pages = kzalloc(sizeof(proc->pages[0]) * ((vma->vm_end - vma->vm_start) / PAGE_SIZE), GFP_KERNEL);
+	proc->pages = kcalloc((vma->vm_end - vma->vm_start) / PAGE_SIZE,
+			      sizeof(proc->pages[0]), GFP_KERNEL);
 	if (proc->pages == NULL) {
 		ret = -ENOMEM;
 		failure_string = "alloc page array";
@@ -2837,7 +2846,8 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 	vma->vm_ops = &binder_vm_ops;
 	vma->vm_private_data = proc;
 
-	if (binder_update_page_range(proc, 1, proc->buffer, proc->buffer + PAGE_SIZE, vma)) {
+	if (binder_update_page_range(proc, 1, proc->buffer,
+				     proc->buffer + PAGE_SIZE, vma)) {
 		ret = -ENOMEM;
 		failure_string = "alloc small buf";
 		goto err_alloc_small_buf_failed;
@@ -2925,7 +2935,9 @@ static void binder_deferred_flush(struct binder_proc *proc)
 	int wake_count = 0;
 
 	for (n = rb_first(&proc->threads); n != NULL; n = rb_next(n)) {
-		struct binder_thread *thread = rb_entry(n, struct binder_thread, rb_node);
+		struct binder_thread *thread = rb_entry(n,
+							struct binder_thread,
+							rb_node);
 
 		thread->looper |= BINDER_LOOPER_STATE_NEED_RETURN;
 		if (thread->looper & BINDER_LOOPER_STATE_WAITING) {
-- 
1.9.1

