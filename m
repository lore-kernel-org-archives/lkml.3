Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaIHQ1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:27:45 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39467 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbaIHQ1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:27:42 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, rdunlap@infradead.org, trivial@kernel.org
Cc: akpm@linux-foundation.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH][trivial] Documentation: Docbook: Fix typo in DocBook/kernel-api.xml
Date: Tue,  9 Sep 2014 01:27:23 +0900
Message-Id: <1410193643-29232-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.1.0.60.g85f0837
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix spelling typo found in DocBook/kernel-api.xml.
It is because the file is generated from the source comments,
I have to fix the comments in source codes.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 block/blk-core.c      | 8 ++++----
 block/genhd.c         | 2 +-
 include/linux/clk.h   | 2 +-
 include/linux/kfifo.h | 2 +-
 ipc/util.c            | 6 +++---
 kernel/auditsc.c      | 2 +-
 lib/bitmap.c          | 4 ++--
 lib/idr.c             | 2 +-
 lib/vsprintf.c        | 2 +-
 mm/filemap.c          | 2 +-
 security/inode.c      | 2 +-
 11 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index bf930f4..9c888bd 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -240,7 +240,7 @@ EXPORT_SYMBOL(blk_stop_queue);
  *     this function.
  *
  *     This function does not cancel any asynchronous activity arising
- *     out of elevator or throttling code. That would require elevaotor_exit()
+ *     out of elevator or throttling code. That would require elevator_exit()
  *     and blkcg_exit_queue() to be called with queue lock initialized.
  *
  */
@@ -933,7 +933,7 @@ static struct io_context *rq_ioc(struct bio *bio)
  * Get a free request from @q.  This function may fail under memory
  * pressure or if @q is dead.
  *
- * Must be callled with @q->queue_lock held and,
+ * Must be called with @q->queue_lock held and,
  * Returns %NULL on failure, with @q->queue_lock held.
  * Returns !%NULL on success, with @q->queue_lock *not held*.
  */
@@ -1110,7 +1110,7 @@ rq_starved:
  * Get a free request from @q.  If %__GFP_WAIT is set in @gfp_mask, this
  * function keeps retrying under memory pressure and fails iff @q is dead.
  *
- * Must be callled with @q->queue_lock held and,
+ * Must be called with @q->queue_lock held and,
  * Returns %NULL on failure, with @q->queue_lock held.
  * Returns !%NULL on success, with @q->queue_lock *not held*.
  */
@@ -1241,7 +1241,7 @@ struct request *blk_make_request(struct request_queue *q, struct bio *bio,
 EXPORT_SYMBOL(blk_make_request);
 
 /**
- * blk_rq_set_block_pc - initialize a requeest to type BLOCK_PC
+ * blk_rq_set_block_pc - initialize a request to type BLOCK_PC
  * @rq:		request to be initialized
  *
  */
diff --git a/block/genhd.c b/block/genhd.c
index 791f419..048e2ce 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1543,7 +1543,7 @@ void disk_flush_events(struct gendisk *disk, unsigned int mask)
 /**
  * disk_clear_events - synchronously check, clear and return pending events
  * @disk: disk to fetch and clear events from
- * @mask: mask of events to be fetched and clearted
+ * @mask: mask of events to be fetched and cleared
  *
  * Disk events are synchronously checked and pending events in @mask
  * are cleared and returned.  This ignores the block count.
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e097..afb44bf 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -238,7 +238,7 @@ void clk_put(struct clk *clk);
 
 /**
  * devm_clk_put	- "free" a managed clock source
- * @dev: device used to acuqire the clock
+ * @dev: device used to acquire the clock
  * @clk: clock source acquired with devm_clk_get()
  *
  * Note: drivers must ensure that all clk_enable calls made on this
diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index 554fde3..473b436 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -722,7 +722,7 @@ __kfifo_uint_must_check_helper( \
 /**
  * kfifo_dma_out_finish - finish a DMA OUT operation
  * @fifo: address of the fifo to be used
- * @len: number of bytes transferrd
+ * @len: number of bytes transferred
  *
  * This macro finish a DMA OUT operation. The out counter will be updated by
  * the len parameter. No error checking will be done.
diff --git a/ipc/util.c b/ipc/util.c
index 27d74e6..d73b7af5 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -309,7 +309,7 @@ int ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int size)
 /**
  * ipcget_new -	create a new ipc object
  * @ns: ipc namespace
- * @ids: ipc identifer set
+ * @ids: ipc identifier set
  * @ops: the actual creation routine to call
  * @params: its parameters
  *
@@ -363,7 +363,7 @@ static int ipc_check_perms(struct ipc_namespace *ns,
 /**
  * ipcget_public - get an ipc object or create a new one
  * @ns: ipc namespace
- * @ids: ipc identifer set
+ * @ids: ipc identifier set
  * @ops: the actual creation routine to call
  * @params: its parameters
  *
@@ -669,7 +669,7 @@ out:
 
 /**
  * ipcget - Common sys_*get() code
- * @ns: namsepace
+ * @ns: namespace
  * @ids: ipc identifier set
  * @ops: operations to be called on ipc object creation, permission checks
  *       and further checks
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 21eae3c..7208c1d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2406,7 +2406,7 @@ int __audit_log_bprm_fcaps(struct linux_binprm *bprm,
  * @new: the new credentials
  * @old: the old (current) credentials
  *
- * Record the aguments userspace sent to sys_capset for later printing by the
+ * Record the arguments userspace sent to sys_capset for later printing by the
  * audit system if applicable
  */
 void __audit_log_capset(const struct cred *new, const struct cred *old)
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1e031f2..cd250a2 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -884,7 +884,7 @@ EXPORT_SYMBOL(bitmap_bitremap);
  * read it, you're overqualified for your current job.)
  *
  * In other words, @orig is mapped onto (surjectively) @dst,
- * using the the map { <n, m> | the n-th bit of @relmap is the
+ * using the map { <n, m> | the n-th bit of @relmap is the
  * m-th set bit of @relmap }.
  *
  * Any set bits in @orig above bit number W, where W is the
@@ -932,7 +932,7 @@ EXPORT_SYMBOL(bitmap_bitremap);
  *
  *  Further lets say we use the following code, invoking
  *  bitmap_fold() then bitmap_onto, as suggested above to
- *  avoid the possitility of an empty @dst result:
+ *  avoid the possibility of an empty @dst result:
  *
  *	unsigned long *tmp;	// a temporary bitmap's bits
  *
diff --git a/lib/idr.c b/lib/idr.c
index 50be3fa..e654aeb 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -626,7 +626,7 @@ static void __idr_remove_all(struct idr *idp)
  * idr_destroy().
  *
  * A typical clean-up sequence for objects stored in an idr tree will use
- * idr_for_each() to free all objects, if necessay, then idr_destroy() to
+ * idr_for_each() to free all objects, if necessary, then idr_destroy() to
  * free up the id mappings and cached idr_layers.
  */
 void idr_destroy(struct idr *idp)
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 6fe2c84..ba3cd0a 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -1937,7 +1937,7 @@ EXPORT_SYMBOL(sprintf);
  * @args: Arguments for the format string
  *
  * The format follows C99 vsnprintf, except %n is ignored, and its argument
- * is skiped.
+ * is skipped.
  *
  * The return value is the number of words(32bits) which would be generated for
  * the given input.
diff --git a/mm/filemap.c b/mm/filemap.c
index 90effcd..8554d20 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -727,7 +727,7 @@ EXPORT_SYMBOL_GPL(add_page_wait_queue);
  *
  * Unlocks the page and wakes up sleepers in ___wait_on_page_locked().
  * Also wakes sleepers in wait_on_page_writeback() because the wakeup
- * mechananism between PageLocked pages and PageWriteback pages is shared.
+ * mechanism between PageLocked pages and PageWriteback pages is shared.
  * But that's OK - sleepers in wait_on_page_writeback() just go back to sleep.
  *
  * The mb is necessary to enforce ordering between the clear_bit and the read
diff --git a/security/inode.c b/security/inode.c
index 43ce6e1..8e7ca62 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -74,7 +74,7 @@ static struct file_system_type fs_type = {
  * pointer must be passed to the securityfs_remove() function when the file is
  * to be removed (no automatic cleanup happens if your module is unloaded,
  * you are responsible here).  If an error occurs, the function will return
- * the erorr value (via ERR_PTR).
+ * the error value (via ERR_PTR).
  *
  * If securityfs is not enabled in the kernel, the value %-ENODEV is
  * returned.
-- 
2.1.0.60.g85f0837

