Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab3CLKme (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:42:34 -0400
Received: from vpn.mirsal.fr ([178.79.141.108]:42904 "EHLO
	mirsal-laptop1.mirsal.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754962Ab3CLKm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:42:29 -0400
From: Mirsal Ennaime <mirsal@mirsal.fr>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Brian Swetland <swetland@google.com>, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>, Mirsal Ennaime <mirsal@mirsal.fr>
Subject: [PATCH v3 2/4] drivers: android: binder: Fix code style in binder_deferred_release
Date: Tue, 12 Mar 2013 11:42:00 +0100
Message-Id: <1363084922-19698-3-git-send-email-mirsal@mirsal.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1363084922-19698-1-git-send-email-mirsal@mirsal.fr>
References: <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
 <1363084922-19698-1-git-send-email-mirsal@mirsal.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 * Use tabs where applicable
 * Remove a few "80-columns" checkpatch warnings
 * Separate code paths with empty lines for readability

Signed-off-by: Mirsal Ennaime <mirsal@mirsal.fr>
---
 drivers/staging/android/binder.c |   32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 9180a5b..ccf3087 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -2927,12 +2927,14 @@ static void binder_deferred_release(struct binder_proc *proc)
 {
 	struct binder_transaction *t;
 	struct rb_node *n;
-	int threads, nodes, incoming_refs, outgoing_refs, buffers, active_transactions, page_count;
+	int threads, nodes, incoming_refs, outgoing_refs, buffers,
+		active_transactions, page_count;
 
 	BUG_ON(proc->vma);
 	BUG_ON(proc->files);
 
 	hlist_del(&proc->proc_node);
+
 	if (binder_context_mgr_node && binder_context_mgr_node->proc == proc) {
 		binder_debug(BINDER_DEBUG_DEAD_BINDER,
 			     "binder_release: %d context_mgr_node gone\n",
@@ -2943,33 +2945,42 @@ static void binder_deferred_release(struct binder_proc *proc)
 	threads = 0;
 	active_transactions = 0;
 	while ((n = rb_first(&proc->threads))) {
-		struct binder_thread *thread = rb_entry(n, struct binder_thread, rb_node);
+		struct binder_thread *thread;
+
+		thread = rb_entry(n, struct binder_thread, rb_node);
 		threads++;
 		active_transactions += binder_free_thread(proc, thread);
 	}
+
 	nodes = 0;
 	incoming_refs = 0;
 	while ((n = rb_first(&proc->nodes))) {
-		struct binder_node *node = rb_entry(n, struct binder_node, rb_node);
+		struct binder_node *node;
 
+		node = rb_entry(n, struct binder_node, rb_node);
 		nodes++;
 		rb_erase(&node->rb_node, &proc->nodes);
 		incoming_refs = binder_node_release(node, incoming_refs);
 	}
+
 	outgoing_refs = 0;
 	while ((n = rb_first(&proc->refs_by_desc))) {
-		struct binder_ref *ref = rb_entry(n, struct binder_ref,
-						  rb_node_desc);
+		struct binder_ref *ref;
+
+		ref = rb_entry(n, struct binder_ref, rb_node_desc);
 		outgoing_refs++;
 		binder_delete_ref(ref);
 	}
+
 	binder_release_work(&proc->todo);
 	binder_release_work(&proc->delivered_death);
-	buffers = 0;
 
+	buffers = 0;
 	while ((n = rb_first(&proc->allocated_buffers))) {
-		struct binder_buffer *buffer = rb_entry(n, struct binder_buffer,
-							rb_node);
+		struct binder_buffer *buffer;
+
+		buffer = rb_entry(n, struct binder_buffer, rb_node);
+
 		t = buffer->transaction;
 		if (t) {
 			t->buffer = NULL;
@@ -2978,6 +2989,7 @@ static void binder_deferred_release(struct binder_proc *proc)
 			       proc->pid, t->debug_id);
 			/*BUG();*/
 		}
+
 		binder_free_buf(proc, buffer);
 		buffers++;
 	}
@@ -2987,13 +2999,13 @@ static void binder_deferred_release(struct binder_proc *proc)
 	page_count = 0;
 	if (proc->pages) {
 		int i;
+
 		for (i = 0; i < proc->buffer_size / PAGE_SIZE; i++) {
 			if (proc->pages[i]) {
 				void *page_addr = proc->buffer + i * PAGE_SIZE;
 				binder_debug(BINDER_DEBUG_BUFFER_ALLOC,
 					     "binder_release: %d: page %d at %p not freed\n",
-					     proc->pid, i,
-					     page_addr);
+					     proc->pid, i, page_addr);
 				unmap_kernel_range((unsigned long)page_addr,
 					PAGE_SIZE);
 				__free_page(proc->pages[i]);
-- 
1.7.10.4

