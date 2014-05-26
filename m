Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaEZUTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:19:20 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:56515 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbaEZUTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:19:17 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiwKAAyhg1NbsG99/2dsb2JhbABZgweCRaheBAEBAQEBAQUBgzyUUIEXF3SCZhwjGIECJBOIRgHVKYVViH2ERwEDjz+KMwGLF4gQgzo7
Date: Mon, 26 May 2014 22:19:14 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1] block/blk-lib.c: make __blkdev_issue_zeroout static
Message-Id: <20140526221914.503f8b9dab389f8100638b71@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__blkdev_issue_zeroout is only used in blk-lib.c

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/blk-lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 97a733c..8411be3 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -226,8 +226,8 @@ EXPORT_SYMBOL(blkdev_issue_write_same);
  *  Generate and issue number of bios with zerofiled pages.
  */
 
-int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-			sector_t nr_sects, gfp_t gfp_mask)
+static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
+				  sector_t nr_sects, gfp_t gfp_mask)
 {
 	int ret;
 	struct bio *bio;
-- 
1.9.1

