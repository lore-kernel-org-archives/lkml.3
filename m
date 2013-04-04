Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048Ab3DDMds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 08:33:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:64420 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759756Ab3DDMcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:32:45 -0400
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH 4/8] staging: android: binder: fix printk() format specifier
Date: Thu,  4 Apr 2013 13:32:34 +0100
Message-Id: <1365078758-28674-5-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
References: <1365078758-28674-1-git-send-email-serban.constantinescu@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix format specifiers warnings introduced by the previous patch which
changes some structures in binder.h.

The patch does not change in any way the functionality of the binder driver.

Signed-off-by: Serban Constantinescu <serban.constantinescu@arm.com>
---
 drivers/staging/android/binder.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index caa6dde..a2cdd9e 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -1271,7 +1271,7 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				pr_err("transaction release %d bad handle %ld\n",
+				pr_err("transaction release %d bad handle %d\n",
 				 debug_id, fp->handle);
 				break;
 			}
@@ -1283,13 +1283,13 @@ static void binder_transaction_buffer_release(struct binder_proc *proc,
 
 		case BINDER_TYPE_FD:
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        fd %ld\n", fp->handle);
+				     "        fd %d\n", fp->handle);
 			if (failed_at)
 				task_close_fd(proc, fp->handle);
 			break;
 
 		default:
-			pr_err("transaction release %d bad object type %lx\n",
+			pr_err("transaction release %d bad object type %x\n",
 				debug_id, fp->type);
 			break;
 		}
@@ -1547,7 +1547,7 @@ static void binder_transaction(struct binder_proc *proc,
 		case BINDER_TYPE_WEAK_HANDLE: {
 			struct binder_ref *ref = binder_get_ref(proc, fp->handle);
 			if (ref == NULL) {
-				binder_user_error("%d:%d got transaction with invalid handle, %ld\n",
+				binder_user_error("%d:%d got transaction with invalid handle, %d\n",
 						proc->pid,
 						thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
@@ -1590,13 +1590,13 @@ static void binder_transaction(struct binder_proc *proc,
 
 			if (reply) {
 				if (!(in_reply_to->flags & TF_ACCEPT_FDS)) {
-					binder_user_error("%d:%d got reply with fd, %ld, but target does not allow fds\n",
+					binder_user_error("%d:%d got reply with fd, %d, but target does not allow fds\n",
 						proc->pid, thread->pid, fp->handle);
 					return_error = BR_FAILED_REPLY;
 					goto err_fd_not_allowed;
 				}
 			} else if (!target_node->accept_fds) {
-				binder_user_error("%d:%d got transaction with fd, %ld, but target does not allow fds\n",
+				binder_user_error("%d:%d got transaction with fd, %d, but target does not allow fds\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fd_not_allowed;
@@ -1604,7 +1604,7 @@ static void binder_transaction(struct binder_proc *proc,
 
 			file = fget(fp->handle);
 			if (file == NULL) {
-				binder_user_error("%d:%d got transaction with invalid fd, %ld\n",
+				binder_user_error("%d:%d got transaction with invalid fd, %d\n",
 					proc->pid, thread->pid, fp->handle);
 				return_error = BR_FAILED_REPLY;
 				goto err_fget_failed;
@@ -1618,13 +1618,13 @@ static void binder_transaction(struct binder_proc *proc,
 			task_fd_install(target_proc, target_fd, file);
 			trace_binder_transaction_fd(t, fp->handle, target_fd);
 			binder_debug(BINDER_DEBUG_TRANSACTION,
-				     "        fd %ld -> %d\n", fp->handle, target_fd);
+				     "        fd %d -> %d\n", fp->handle, target_fd);
 			/* TODO: fput? */
 			fp->handle = target_fd;
 		} break;
 
 		default:
-			binder_user_error("%d:%d got transaction with invalid object type, %lx\n",
+			binder_user_error("%d:%d got transaction with invalid object type, %x\n",
 				proc->pid, thread->pid, fp->type);
 			return_error = BR_FAILED_REPLY;
 			goto err_bad_object_type;
@@ -2578,7 +2578,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			goto err;
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d write %ld at %08lx, read %ld at %08lx\n",
+			     "%d:%d write %zd at %016lx, read %zd at %016lx\n",
 			     proc->pid, thread->pid, bwr.write_size,
 			     bwr.write_buffer, bwr.read_size, bwr.read_buffer);
 
@@ -2604,7 +2604,7 @@ static long binder_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 			}
 		}
 		binder_debug(BINDER_DEBUG_READ_WRITE,
-			     "%d:%d wrote %ld of %ld, read return %ld of %ld\n",
+			     "%d:%d wrote %zd of %zd, read return %zd of %zd\n",
 			     proc->pid, thread->pid, bwr.write_consumed, bwr.write_size,
 			     bwr.read_consumed, bwr.read_size);
 		if (copy_to_user(ubuf, &bwr, sizeof(bwr))) {
-- 
1.7.9.5

