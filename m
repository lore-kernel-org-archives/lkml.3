Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3EIH7v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 03:59:51 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:35568 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3EIH7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 03:59:49 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Denis Efremov <yefremov.denis@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 02/21] fs: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 11:58:24 +0400
Message-Id: <1368086323-9412-2-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 fs/bio.c       | 2 +-
 fs/block_dev.c | 2 +-
 fs/buffer.c    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index b96fc6c..4e1235f 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -402,7 +402,7 @@ void bio_put(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_put);
 
-inline int bio_phys_segments(struct request_queue *q, struct bio *bio)
+int bio_phys_segments(struct request_queue *q, struct bio *bio)
 {
 	if (unlikely(!bio_flagged(bio, BIO_SEG_VALID)))
 		blk_recount_segments(q, bio);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index ce08de7..799d879 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -42,7 +42,7 @@ static inline struct bdev_inode *BDEV_I(struct inode *inode)
 	return container_of(inode, struct bdev_inode, vfs_inode);
 }
 
-inline struct block_device *I_BDEV(struct inode *inode)
+struct block_device *I_BDEV(struct inode *inode)
 {
 	return &BDEV_I(inode)->bdev;
 }
diff --git a/fs/buffer.c b/fs/buffer.c
index bc1fe14..c3cfe44 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -54,7 +54,7 @@ void init_buffer(struct buffer_head *bh, bh_end_io_t *handler, void *private)
 }
 EXPORT_SYMBOL(init_buffer);
 
-inline void touch_buffer(struct buffer_head *bh)
+void touch_buffer(struct buffer_head *bh)
 {
 	trace_block_touch_buffer(bh);
 	mark_page_accessed(bh->b_page);
-- 
1.8.1.4

