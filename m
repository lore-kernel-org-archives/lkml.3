Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab3CLKma (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:42:30 -0400
Received: from vpn.mirsal.fr ([178.79.141.108]:42906 "EHLO
	mirsal-laptop1.mirsal.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751908Ab3CLKm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:42:29 -0400
From: Mirsal Ennaime <mirsal@mirsal.fr>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>, Mirsal Ennaime <mirsal@mirsal.fr>
Subject: [PATCH v3 4/4] drivers: android: binder: Use __func__ in debug messages
Date: Tue, 12 Mar 2013 11:42:02 +0100
Message-Id: <1363084922-19698-5-git-send-email-mirsal@mirsal.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363084922-19698-1-git-send-email-mirsal@mirsal.fr>
References: <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
 <1363084922-19698-1-git-send-email-mirsal@mirsal.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debug messages sent in binder_deferred_release begin with
"binder_release:" which is a bit misleading as binder_release is not
directly part of the call stack. Use __func__ instead for debug messages
in binder_deferred_release.

Signed-off-by: Mirsal Ennaime <mirsal@mirsal.fr>
---
 drivers/staging/android/binder.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 9db21b4..1567ac2 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2937,8 +2937,8 @@ static void binder_deferred_release(struct binder_proc *proc)
 
 	if (binder_context_mgr_node && binder_context_mgr_node->proc == proc) {
 		binder_debug(BINDER_DEBUG_DEAD_BINDER,
-			     "binder_release: %d context_mgr_node gone\n",
-			     proc->pid);
+			     "%s: %d context_mgr_node gone\n",
+			     __func__, proc->pid);
 		binder_context_mgr_node = NULL;
 	}
 
@@ -3008,8 +3008,8 @@ static void binder_deferred_release(struct binder_proc *proc)
 
 			page_addr = proc->buffer + i * PAGE_SIZE;
 			binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-				     "binder_release: %d: page %d at %p not freed\n",
-				     proc->pid, i, page_addr);
+				     "%s: %d: page %d at %p not freed\n",
+				     __func__, proc->pid, i, page_addr);
 			unmap_kernel_range((unsigned long)page_addr, PAGE_SIZE);
 			__free_page(proc->pages[i]);
 			page_count++;
@@ -3021,9 +3021,9 @@ static void binder_deferred_release(struct binder_proc *proc)
 	put_task_struct(proc->tsk);
 
 	binder_debug(BINDER_DEBUG_OPEN_CLOSE,
-		     "binder_release: %d threads %d, nodes %d (ref %d), refs %d, active transactions %d, buffers %d, pages %d\n",
-		     proc->pid, threads, nodes, incoming_refs, outgoing_refs,
-		     active_transactions, buffers, page_count);
+		     "%s: %d threads %d, nodes %d (ref %d), refs %d, active transactions %d, buffers %d, pages %d\n",
+		     __func__, proc->pid, threads, nodes, incoming_refs,
+		     outgoing_refs, active_transactions, buffers, page_count);
 
 	kfree(proc);
 }
-- 
1.7.10.4

