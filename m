Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaJRVmh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2014 17:42:37 -0400
Received: from alderaan.wessner.org ([213.136.64.202]:42193 "EHLO wessner.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaJRVmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2014 17:42:35 -0400
From: Joseph Wessner <joseph@wessner.org>
To: viro@zeniv.linux.org.uk
Cc: linux-aio@kvack.org, linux-kernel@vger.kernel.org,
        Joseph Wessner <joseph@wessner.org>
Subject: [PATCH] FS: aio: Fixed some coding style issues.
Date: Sat, 18 Oct 2014 23:42:13 +0200
Message-Id: <1413668533-7641-1-git-send-email-joseph@wessner.org>
X-Mailer: git-send-email 2.1.2
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (wessner.org [0.0.0.0]); Sat, 18 Oct 2014 23:42:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues in aio.c

Signed-off-by: Joseph Wessner <joseph@wessner.org>
---
 fs/aio.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 84a7510..eab03a6 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -171,6 +171,7 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
 	struct file *file;
 	struct path path;
 	struct inode *inode = alloc_anon_inode(aio_mnt->mnt_sb);
+
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
 
@@ -221,7 +222,7 @@ static int __init aio_setup(void)
 		panic("Failed to create aio fs mount.");
 
 	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
-	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
+	kioctx_cachep = KMEM_CACHE(kioctx, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
 
 	pr_debug("sizeof(struct page) = %zu\n", sizeof(struct page));
 
@@ -232,6 +233,7 @@ __initcall(aio_setup);
 static void put_aio_ring_file(struct kioctx *ctx)
 {
 	struct file *aio_ring_file = ctx->aio_ring_file;
+
 	if (aio_ring_file) {
 		truncate_setsize(aio_ring_file->f_inode, 0);
 
@@ -256,6 +258,7 @@ static void aio_free_ring(struct kioctx *ctx)
 
 	for (i = 0; i < ctx->nr_pages; i++) {
 		struct page *page;
+
 		pr_debug("pid(%d) [%d] page->count=%d\n", current->pid, i,
 				page_count(ctx->ring_pages[i]));
 		page = ctx->ring_pages[i];
@@ -405,6 +408,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 
 	for (i = 0; i < nr_pages; i++) {
 		struct page *page;
+
 		page = find_or_create_page(file->f_inode->i_mapping,
 					   i, GFP_HIGHUSER | __GFP_ZERO);
 		if (!page)
@@ -871,7 +875,7 @@ out:
  *	called holding ctx->completion_lock.
  */
 static void refill_reqs_available(struct kioctx *ctx, unsigned head,
-                                  unsigned tail)
+		unsigned tail)
 {
 	unsigned events_in_ring, completed;
 
@@ -1234,10 +1238,10 @@ static long read_events(struct kioctx *ctx, long min_nr, long nr,
  *	Create an aio_context capable of receiving at least nr_events.
  *	ctxp must not point to an aio_context that already exists, and
  *	must be initialized to 0 prior to the call.  On successful
- *	creation of the aio_context, *ctxp is filled in with the resulting 
+ *	creation of the aio_context, *ctxp is filled in with the resulting
  *	handle.  May fail with -EINVAL if *ctxp is not initialized,
- *	if the specified nr_events exceeds internal limits.  May fail 
- *	with -EAGAIN if the specified nr_events exceeds the user's limit 
+ *	if the specified nr_events exceeds internal limits.  May fail
+ *	with -EAGAIN if the specified nr_events exceeds the user's limit
  *	of available events.  May fail with -ENOMEM if insufficient kernel
  *	resources are available.  May fail with -EFAULT if an invalid
  *	pointer is passed for ctxp.  Will fail with -ENOSYS if not
@@ -1256,7 +1260,7 @@ SYSCALL_DEFINE2(io_setup, unsigned, nr_events, aio_context_t __user *, ctxp)
 	ret = -EINVAL;
 	if (unlikely(ctx || nr_events == 0)) {
 		pr_debug("EINVAL: io_setup: ctx %lu nr_events %u\n",
-		         ctx, nr_events);
+			 ctx, nr_events);
 		goto out;
 	}
 
@@ -1274,7 +1278,7 @@ out:
 }
 
 /* sys_io_destroy:
- *	Destroy the aio_context specified.  May cancel any outstanding 
+ *	Destroy the aio_context specified.  May cancel any outstanding
  *	AIOs and block on completion.  Will fail with -ENOSYS if not
  *	implemented.  May fail with -EINVAL if the context pointed to
  *	is invalid.
@@ -1282,6 +1286,7 @@ out:
 SYSCALL_DEFINE1(io_destroy, aio_context_t, ctx)
 {
 	struct kioctx *ioctx = lookup_ioctx(ctx);
+
 	if (likely(NULL != ioctx)) {
 		struct completion requests_done =
 			COMPLETION_INITIALIZER_ONSTACK(requests_done);
@@ -1568,7 +1573,7 @@ long do_io_submit(aio_context_t ctx_id, long nr,
 	 * AKPM: should this return a partial result if some of the IOs were
 	 * successfully submitted?
 	 */
-	for (i=0; i<nr; i++) {
+	for (i = 0; i < nr; i++) {
 		struct iocb __user *user_iocb;
 		struct iocb tmp;
 
@@ -1626,6 +1631,7 @@ static struct kiocb *lookup_kiocb(struct kioctx *ctx, struct iocb __user *iocb,
 	/* TODO: use a hash or array, this sucks. */
 	list_for_each(pos, &ctx->active_reqs) {
 		struct kiocb *kiocb = list_kiocb(pos);
+
 		if (kiocb->ki_obj.user == iocb)
 			return kiocb;
 	}
-- 
2.1.2

