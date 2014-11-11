Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaKKLXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:23:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57789 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbaKKLLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 137/170] Revert "block: all blk-mq requests are tagged"
Date: Tue, 11 Nov 2014 11:08:16 +0000
Message-Id: <1415704129-12709-138-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit e999dbc254044e8d2a5818d92d205f65bae28f37 upstream.

This reverts commit fb3ccb5da71273e7f0d50b50bc879e50cedd60e7.

SCSI-2/SPI actually needs the tagged/untagged flag in the request to
work properly.  Revert this patch and add a follow on to set it in
the right place.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/blkdev.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8699bcf5f099..279390ee523a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1140,8 +1140,7 @@ static inline bool blk_needs_flush_plug(struct task_struct *tsk)
 /*
  * tag stuff
  */
-#define blk_rq_tagged(rq) \
-	((rq)->mq_ctx || ((rq)->cmd_flags & REQ_QUEUED))
+#define blk_rq_tagged(rq)		((rq)->cmd_flags & REQ_QUEUED)
 extern int blk_queue_start_tag(struct request_queue *, struct request *);
 extern struct request *blk_queue_find_tag(struct request_queue *, int);
 extern void blk_queue_end_tag(struct request_queue *, struct request *);
-- 
2.1.0

