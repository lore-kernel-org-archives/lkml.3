Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab3K0Aj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:39:56 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:35452 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3K0Ajx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:39:53 -0500
Date: Tue, 26 Nov 2013 16:39:49 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Olof Johansson <olof@lixom.net>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] block: Silence spurious compiler warnings
Message-ID: <20131127003949.GA21305@kmo>
References: <20131126132946.e402679788ae8269f0c5128a@canb.auug.org.au>
 <20131126143550.7a2195476ff4aa5c73db20b2@canb.auug.org.au>
 <CAOesGMiPpetDRt7dfHvcZ3LTSYyR3CBj2L2kq=pBMamkzCbb3A@mail.gmail.com>
 <5294F030.5090805@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5294F030.5090805@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 46e7081430f5f483906f496733a23f8e9d898879 Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kmo@daterainc.com>
Date: Tue, 26 Nov 2013 16:36:49 -0800
Subject: [PATCH] block: Silence spurious compiler warnings

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
---

On Tue, Nov 26, 2013 at 12:02:08PM -0700, Jens Axboe wrote:
> On 11/26/2013 12:01 PM, Olof Johansson wrote:
> > I just noticed that i see this with gcc 4.7.0, but 4.8.1 does not warn.
> 
> That's good, because it's not a bug. But arguably we should shut up 4.7
> as well, however...

Here you go:

 block/blk-merge.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 05c17be..0b097f6 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -89,6 +89,8 @@ static int blk_phys_contig_segment(struct request_queue *q, struct bio *bio,
 	struct bio_vec end_bv, nxt_bv;
 	struct bvec_iter iter;
 
+	uninitialized_var(end_bv);
+
 	if (!blk_queue_cluster(q))
 		return 0;
 
@@ -173,6 +175,8 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	struct scatterlist *sg;
 	int nsegs, cluster;
 
+	uninitialized_var(bvprv);
+
 	nsegs = 0;
 	cluster = blk_queue_cluster(q);
 
@@ -235,6 +239,8 @@ int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
 	int nsegs, cluster;
 	struct bvec_iter iter;
 
+	uninitialized_var(bvprv);
+
 	nsegs = 0;
 	cluster = blk_queue_cluster(q);
 
-- 
1.8.4.4

