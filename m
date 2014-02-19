Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaBSDsf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 22:48:35 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64524 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbaBSDse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 22:48:34 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: gregkh@linuxfoundation.org
Cc: sachin.kamat@linaro.org, swetland@google.com, devel@driverdev.osusl.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] staging: android: binder: convert commented messages to pr_debug
Date: Wed, 19 Feb 2014 12:49:33 +0900
Message-Id: <1392781773-1941-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2 debugging messages were just commented out for normal case. Let them
be activated on debug mode without explicit code modification.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/staging/android/binder.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index eaec1da..a56f941 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2553,7 +2553,8 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 	unsigned int size = _IOC_SIZE(cmd);
 	void __user *ubuf = (void __user *)arg;
 
-	/*pr_info("binder_ioctl: %d:%d %x %lx\n", proc->pid, current->pid, cmd, arg);*/
+	pr_debug("binder_ioctl: %d:%d %x %lx\n",
+		 proc->pid, current->pid, cmd, arg);
 
 	trace_binder_ioctl(cmd, arg);
 
@@ -2787,8 +2788,8 @@ static int binder_mmap(struct file *filp, struct vm_area_struct *vma)
 	proc->vma = vma;
 	proc->vma_vm_mm = vma->vm_mm;
 
-	/*pr_info("binder_mmap: %d %lx-%lx maps %p\n",
-		 proc->pid, vma->vm_start, vma->vm_end, proc->buffer);*/
+	pr_debug("binder_mmap: %d %lx-%lx maps %p\n",
+		 proc->pid, vma->vm_start, vma->vm_end, proc->buffer);
 	return 0;
 
 err_alloc_small_buf_failed:
-- 
1.8.3.2

