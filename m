Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaKRTmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:42:39 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33455 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbaKRTmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:42:36 -0500
From: =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
To: hch@infradead.org, axboe@fb.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: thornber@redhat.com, bvanassche@acm.org, jmad@itu.dk,
        =?UTF-8?q?Matias=20Bj=C3=B8rling?= <m@bjorling.me>
Subject: [RPC PATCH 1/5] block: expose init_request_from_bio
Date: Tue, 18 Nov 2014 20:41:55 +0100
Message-Id: <1416339719-8488-2-git-send-email-m@bjorling.me>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416339719-8488-1-git-send-email-m@bjorling.me>
References: <1416339719-8488-1-git-send-email-m@bjorling.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When doing internal commands within LightNVM, we may form it as a bio.
It can then use the existing infrastructure for handling bio's.
Expose init_request_from_bio as blk_init_request_from_bio and allow
requests to initialized from bio's.

Signed-off-by: Matias Bjørling <m@bjorling.me>
---
 block/blk-core.c       | 6 ++++++
 include/linux/blkdev.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index bf930f4..53f9488 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1546,6 +1546,12 @@ void init_request_from_bio(struct request *req, struct bio *bio)
 	blk_rq_bio_prep(req->q, req, bio);
 }
 
+void blk_init_request_from_bio(struct request *req, struct bio *bio)
+{
+	init_request_from_bio(req, bio);
+}
+EXPORT_SYMBOL(blk_init_request_from_bio);
+
 void blk_queue_bio(struct request_queue *q, struct bio *bio)
 {
 	const bool sync = !!(bio->bi_rw & REQ_SYNC);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 518b465..75296c0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -823,6 +823,7 @@ extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
 
 extern void blk_queue_bio(struct request_queue *q, struct bio *bio);
+extern void blk_init_request_from_bio(struct request *req, struct bio *bio);
 
 /*
  * A queue has just exitted congestion.  Note this in the global counter of
-- 
1.9.1

