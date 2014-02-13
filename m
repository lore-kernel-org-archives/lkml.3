Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbaBMJvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:51:48 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:62990 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaBMJvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:51:46 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: hch@infradead.org, kmo@daterainc.com, snitzer@redhat.com,
        JBottomley@parallels.com, ming.m.lin@intel.com, j-nomura@ce.jp.nec.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] block: use NULL instead of 0 for pointer in blkdev.h
Date: Thu, 13 Feb 2014 18:51:37 +0900
Message-ID: <2953697.jlbnRv7EM7@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From dc82a41842df1e20e8508cea6922882f8b122a50 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Thu, 13 Feb 2014 16:44:58 +0900
Subject: [PATCH] block: use NULL instead of 0 for pointer in blkdev.h

following sparse warning:

include/linux/blkdev.h:1518:16: warning:
 Using plain integer as NULL pointer

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 include/linux/blkdev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8678c43..26b8466 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1515,7 +1515,7 @@ static inline int blk_rq_map_integrity_sg(struct request_queue *q,
 }
 static inline struct blk_integrity *bdev_get_integrity(struct block_device *b)
 {
-	return 0;
+	return NULL;
 }
 static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
 {
-- 
1.7.9.5
---

