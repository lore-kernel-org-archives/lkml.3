Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaDZSxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 14:53:23 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:48792 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbaDZSxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 14:53:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgMVAHD/W1NXQBKy/2dsb2JhbABYgwasAAMBAQIBBAGZcgICgQoXdIJTExwjGIECJBOIRQHJeoVaiH+EQAEDjnyKDwGSXoMzOw
Date: Sat, 26 Apr 2014 20:55:21 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/1] fs/direct-io.c: replace 0 by NULL for pointers +
 clean-up
Message-Id: <20140426205521.a8fc991c39e445dd1110c23a@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sparse warning: fs/direct-io.c:1123:36:
"warning: Using plain integer as NULL pointer"
Also fixed lot of checkpatch warnings mainly trailing whitespaces

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/direct-io.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 31ba093..cc8c83b 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -198,7 +198,7 @@ static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 		ret = 0;
 	}
 out:
-	return ret;	
+	return ret;
 }
 
 /*
@@ -293,7 +293,7 @@ static void dio_aio_complete_work(struct work_struct *work)
 static int dio_bio_complete(struct dio *dio, struct bio *bio);
 
 /*
- * Asynchronous IO callback. 
+ * Asynchronous IO callback.
  */
 static void dio_bio_end_aio(struct bio *bio, int error)
 {
@@ -699,7 +699,7 @@ static inline int dio_bio_add_page(struct dio_submit *sdio)
 	}
 	return ret;
 }
-		
+
 /*
  * Put cur_page under IO.  The section of cur_page which is described by
  * cur_page_offset,cur_page_len is put into a BIO.  The section of cur_page
@@ -761,7 +761,7 @@ out:
  * An autonomous function to put a chunk of a page under deferred IO.
  *
  * The caller doesn't actually know (or care) whether this piece of page is in
- * a BIO, or is under IO or whatever.  We just take care of all possible 
+ * a BIO, or is under IO or whatever.  We just take care of all possible
  * situations here.  The separation between the logic of do_direct_IO() and
  * that of submit_page_section() is important for clarity.  Please don't break.
  *
@@ -879,7 +879,7 @@ static inline void dio_zero_block(struct dio *dio, struct dio_submit *sdio,
 	 * We need to zero out part of an fs block.  It is either at the
 	 * beginning or the end of the fs block.
 	 */
-	if (end) 
+	if (end)
 		this_chunk_blocks = dio_blocks_per_fs_block - this_chunk_blocks;
 
 	this_chunk_bytes = this_chunk_blocks << sdio->blkbits;
@@ -1107,7 +1107,7 @@ static inline int drop_refcount(struct dio *dio)
  */
 static inline ssize_t
 do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
-	struct block_device *bdev, const struct iovec *iov, loff_t offset, 
+	struct block_device *bdev, const struct iovec *iov, loff_t offset,
 	unsigned long nr_segs, get_block_t get_block, dio_iodone_t end_io,
 	dio_submit_t submit_io,	int flags)
 {
@@ -1120,7 +1120,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	ssize_t retval = -EINVAL;
 	loff_t end = offset;
 	struct dio *dio;
-	struct dio_submit sdio = { 0, };
+	struct dio_submit sdio = { NULL, };
 	unsigned long user_addr;
 	size_t bytes;
 	struct buffer_head map_bh = { 0, };
@@ -1201,7 +1201,7 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (is_sync_kiocb(iocb))
 		dio->is_async = false;
 	else if (!(dio->flags & DIO_ASYNC_EXTEND) &&
-            (rw & WRITE) && end > i_size_read(inode))
+		 (rw & WRITE) && end > i_size_read(inode))
 		dio->is_async = false;
 	else
 		dio->is_async = true;
@@ -1354,9 +1354,9 @@ do_blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 	if (retval != -EIOCBQUEUED)
 		dio_await_completion(dio);
 
-	if (drop_refcount(dio) == 0) {
+	if (drop_refcount(dio) == 0)
 		retval = dio_complete(dio, offset, retval, false);
-	} else
+	else
 		BUG_ON(retval != -EIOCBQUEUED);
 
 out:
@@ -1385,7 +1385,6 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 				     nr_segs, get_block, end_io,
 				     submit_io, flags);
 }
-
 EXPORT_SYMBOL(__blockdev_direct_IO);
 
 static __init int dio_init(void)
-- 
1.8.4.5

