Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbaKLBYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:24:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013AbaKLBYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:24:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Meelis Roos <mroos@linux.ee>
Subject: [PATCH 3.17 094/319] Revert "block: all blk-mq requests are tagged"
Date: Wed, 12 Nov 2014 10:13:52 +0900
Message-Id: <20141112011008.103568477@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/blkdev.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1142,8 +1142,7 @@ static inline bool blk_needs_flush_plug(
 /*
  * tag stuff
  */
-#define blk_rq_tagged(rq) \
-	((rq)->mq_ctx || ((rq)->cmd_flags & REQ_QUEUED))
+#define blk_rq_tagged(rq)		((rq)->cmd_flags & REQ_QUEUED)
 extern int blk_queue_start_tag(struct request_queue *, struct request *);
 extern struct request *blk_queue_find_tag(struct request_queue *, int);
 extern void blk_queue_end_tag(struct request_queue *, struct request *);


