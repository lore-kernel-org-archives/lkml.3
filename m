Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaDSJEF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 05:04:05 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:18947 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbaDSJD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 05:03:59 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYVAHU6UlNbskNu/2dsb2JhbABagwaDZKdjmV4CAoEaF3SCUxMcIxiBAiQTiEUBzWSOYoQ/AQOOaYoEAYpqh2WDMzs
Date: Sat, 19 Apr 2014 11:05:54 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Viro <viro@zeniv.linux.org.uk>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/bio.c: remove nr_segs (unused function parameter)
Message-Id: <20140419110554.1bda5930297d3ef8e4e458a9@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nr_segs is no longer used in bio_alloc_map_data since

c8db444820a1e3 ("block: Don't save/copy bvec array anymore")

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/bio.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 6f0362b..bd39c5b 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1011,8 +1011,7 @@ static void bio_set_map_data(struct bio_map_data *bmd, struct bio *bio,
 	bio->bi_private = bmd;
 }
 
-static struct bio_map_data *bio_alloc_map_data(int nr_segs,
-					       unsigned int iov_count,
+static struct bio_map_data *bio_alloc_map_data(unsigned int iov_count,
 					       gfp_t gfp_mask)
 {
 	if (iov_count > UIO_MAXIOV)
@@ -1154,7 +1153,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 	if (offset)
 		nr_pages++;
 
-	bmd = bio_alloc_map_data(nr_pages, iov_count, gfp_mask);
+	bmd = bio_alloc_map_data(iov_count, gfp_mask);
 	if (!bmd)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.8.4.5
