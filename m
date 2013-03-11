Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651Ab3CKTl3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:41:29 -0400
Received: from vpn.mirsal.fr ([178.79.141.108]:47706 "EHLO
	mirsal-laptop1.mirsal.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754261Ab3CKTlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:41:24 -0400
From: Mirsal Ennaime <mirsal@mirsal.fr>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mirsal Ennaime <mirsal@mirsal.fr>
Subject: [PATCH 2/4] drivers: android: binder: Fix code style
Date: Mon, 11 Mar 2013 20:31:53 +0100
Message-Id: <1363030315-10229-3-git-send-email-mirsal@mirsal.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Use tabs
 * Remove a couple of "80-columns" checkpatch warnings
 * Separate code paths with empty lines for readability

Signed-off-by: Mirsal Ennaime <mirsal@mirsal.fr>
---
 drivers/staging/android/binder.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 11b3f7b..49cc573 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2934,6 +2934,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 	BUG_ON(proc->files);
 
 	hlist_del(&proc->proc_node);
+
 	if (binder_context_mgr_node && binder_context_mgr_node->proc == proc) {
 		binder_debug(BINDER_DEBUG_DEAD_BINDER,
 			     "binder_release: %d context_mgr_node gone\n",
@@ -2943,28 +2944,39 @@ static void binder_deferred_release(struct binder_proc *proc)
 
 	threads = 0;
 	active_transactions = 0;
+
 	while ((n = rb_first(&proc->threads))) {
-		struct binder_thread *thread = rb_entry(n, struct binder_thread, rb_node);
+		struct binder_thread *thread = rb_entry(n,
+			struct binder_thread,
+			rb_node);
+
 		threads++;
 		active_transactions += binder_free_thread(proc, thread);
 	}
+
 	nodes = 0;
 	incoming_refs = 0;
+
 	while ((n = rb_first(&proc->nodes))) {
-		struct binder_node *node = rb_entry(n, struct binder_node, rb_node);
+		struct binder_node *node = rb_entry(n,
+			struct binder_node,
+			rb_node);
 
 		nodes++;
 		rb_erase(&node->rb_node, &proc->nodes);
 		nd_refs = binder_node_deferred_release(node, incoming_refs);
 		incoming_refs = nd_refs;
 	}
+
 	outgoing_refs = 0;
+
 	while ((n = rb_first(&proc->refs_by_desc))) {
 		struct binder_ref *ref = rb_entry(n, struct binder_ref,
 						  rb_node_desc);
 		outgoing_refs++;
 		binder_delete_ref(ref);
 	}
+
 	binder_release_work(&proc->todo);
 	binder_release_work(&proc->delivered_death);
 	buffers = 0;
@@ -2993,9 +3005,9 @@ static void binder_deferred_release(struct binder_proc *proc)
 			if (proc->pages[i]) {
 				void *page_addr = proc->buffer + i * PAGE_SIZE;
 				binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
-					     "binder_release: %d: page %d at %p not freed\n",
-					     proc->pid, i,
-					     page_addr);
+					"binder_release: %d: page %d at %p not freed\n",
+					proc->pid, i,
+					page_addr);
 				unmap_kernel_range((unsigned long)page_addr,
 					PAGE_SIZE);
 				__free_page(proc->pages[i]);
-- 
1.7.10.4

