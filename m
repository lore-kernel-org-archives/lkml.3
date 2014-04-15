Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777AbaDOGKa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 02:10:30 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:48046 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaDOGK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 02:10:29 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: Re: [PATCH] block/blk-core.c: print readable string instead of values.
Date: Tue, 15 Apr 2014 14:10:20 +0800
Message-Id: <1397542220-32690-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Joe Perches, I think your suggestion is more desirable. The message is 
too long, I broke it into two lines. Thanks.

---<8---
 
Also print the r/w direction string instead of only internal values.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 block/blk-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a0e3096..f8170c7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1624,10 +1624,10 @@ static void handle_bad_sector(struct bio *bio)
 {
 	char b[BDEVNAME_SIZE];
 
-	printk(KERN_INFO "attempt to access beyond end of device\n");
-	printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
+	printk(KERN_INFO "%s: attempt to access beyond end of device - "
+			"rw=%s(%lx), want=%Lu, limit=%Lu\n",
 			bdevname(bio->bi_bdev, b),
-			bio->bi_rw,
+			bio->bi_rw & WRITE ? "WRITE" : "READ", bio->bi_rw,
 			(unsigned long long)bio_end_sector(bio),
 			(long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
 
-- 
1.9.0.GIT

