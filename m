Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3LCVY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:24:28 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:35553 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3LCVYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:24:18 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH 1/2] block: Silence spurious compiler warnings
Date: Tue,  3 Dec 2013 13:24:07 -0800
Message-Id: <1386105848-25660-2-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386105848-25660-1-git-send-email-kmo@daterainc.com>
References: <1386105848-25660-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uninitialized_var() macro appears to not work on structs...

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---
 block/blk-merge.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 05c17be..8f8adaa 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -86,7 +86,7 @@ EXPORT_SYMBOL(blk_recount_segments);
 static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 				   struct bio *nxt)
 {
-	struct bio_vec end_bv, nxt_bv;
+	struct bio_vec end_bv = { NULL }, nxt_bv;
 	struct bvec_iter iter;
 
 	if (!blk_queue_cluster(q))
@@ -168,7 +168,7 @@ new_segment:
 int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 		  struct scatterlist *sglist)
 {
-	struct bio_vec bvec, bvprv;
+	struct bio_vec bvec, bvprv = { NULL };
 	struct req_iterator iter;
 	struct scatterlist *sg;
 	int nsegs, cluster;
@@ -230,7 +230,7 @@ EXPORT_SYMBOL(blk_rq_map_sg);
 int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
 		   struct scatterlist *sglist)
 {
-	struct bio_vec bvec, bvprv;
+	struct bio_vec bvec, bvprv = { NULL };
 	struct scatterlist *sg;
 	int nsegs, cluster;
 	struct bvec_iter iter;
-- 
1.8.4.4

