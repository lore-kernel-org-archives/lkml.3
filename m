Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab3J2QHz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:07:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51323 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab3J2QHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:07:53 -0400
From: Ming Lei <ming.lei@canonical.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 1/2] lib/scatterlist: export sg_miter_skip()
Date: Wed, 30 Oct 2013 00:07:22 +0800
Message-Id: <1383062842-28453-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sg_copy_buffer() can't meet demand for some drrivers(such usb
mass storage), so we have to use the sg_miter_* APIs to access
sg buffer, then need export sg_miter_skip() for these drivers.

The API is needed for converting to sg_miter_* APIs in USB storage
driver for accessing sg buffer.

Cc: Andrew Morton <akpm@linux-foundation.org>,
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
Cc: Tejun Heo <tj@kernel.org>,
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 include/linux/scatterlist.h |    1 +
 lib/scatterlist.c           |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index adae88f..a964f72 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -345,6 +345,7 @@ struct sg_mapping_iter {
 
 void sg_miter_start(struct sg_mapping_iter *miter, struct scatterlist *sgl,
 		    unsigned int nents, unsigned int flags);
+bool sg_miter_skip(struct sg_mapping_iter *miter, off_t offset);
 bool sg_miter_next(struct sg_mapping_iter *miter);
 void sg_miter_stop(struct sg_mapping_iter *miter);
 
diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index d16fa29..3a8e8e8 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -495,7 +495,7 @@ static bool sg_miter_get_next_page(struct sg_mapping_iter *miter)
  *   true if @miter contains the valid mapping.  false if end of sg
  *   list is reached.
  */
-static bool sg_miter_skip(struct sg_mapping_iter *miter, off_t offset)
+bool sg_miter_skip(struct sg_mapping_iter *miter, off_t offset)
 {
 	sg_miter_stop(miter);
 
@@ -513,6 +513,7 @@ static bool sg_miter_skip(struct sg_mapping_iter *miter, off_t offset)
 
 	return true;
 }
+EXPORT_SYMBOL(sg_miter_skip);
 
 /**
  * sg_miter_next - proceed mapping iterator to the next mapping
-- 
1.7.9.5

