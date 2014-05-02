Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaEBQ0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:26:15 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:10309 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753373AbaEBQ0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:26:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgaAIXBY1NbsmU4/2dsb2JhbABagwarXwMBAQEBAQEEAZoBAgKBEBd0glMTHCMYgQIkE4hFAcpEhVaIfIRAAQOPFooZAZJvgzY7
Date: Fri, 2 May 2014 18:28:17 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1] block/blk-throttle.c: fix return of 0/1 with return
 type bool
Message-Id: <20140502182817.acc69a0ac05575c25311d2c6@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix 4 coccinelle warnings.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/blk-throttle.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 033745c..366b1d8 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -744,7 +744,7 @@ static inline void throtl_extend_slice(struct throtl_grp *tg, bool rw,
 static bool throtl_slice_used(struct throtl_grp *tg, bool rw)
 {
 	if (time_in_range(jiffies, tg->slice_start[rw], tg->slice_end[rw]))
-		return 0;
+		return false;
 
 	return 1;
 }
@@ -842,7 +842,7 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
 	if (tg->io_disp[rw] + 1 <= io_allowed) {
 		if (wait)
 			*wait = 0;
-		return 1;
+		return true;
 	}
 
 	/* Calc approx time to dispatch */
@@ -880,7 +880,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
 	if (tg->bytes_disp[rw] + bio->bi_iter.bi_size <= bytes_allowed) {
 		if (wait)
 			*wait = 0;
-		return 1;
+		return true;
 	}
 
 	/* Calc approx time to dispatch */
@@ -923,7 +923,7 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
 	if (tg->bps[rw] == -1 && tg->iops[rw] == -1) {
 		if (wait)
 			*wait = 0;
-		return 1;
+		return true;
 	}
 
 	/*
-- 
1.8.4.5

