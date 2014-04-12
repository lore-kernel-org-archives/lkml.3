Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbaDLHWd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 03:22:33 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:58020 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaDLHWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 03:22:32 -0400
From: Jianyu Zhan <nasa4836@gmail.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, nasa4836@gmail.com
Subject: [PATCH] block/blk-core.c: print readable string instead of values.
Date: Sat, 12 Apr 2014 15:22:23 +0800
Message-Id: <1397287343-10059-1-git-send-email-nasa4836@gmail.com>
X-Mailer: git-send-email 1.9.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print the r/w direction string instead of internal values.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
---
 block/blk-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a0e3096..0a3bde3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1625,9 +1625,9 @@ static void handle_bad_sector(struct bio *bio)
 	char b[BDEVNAME_SIZE];
 
 	printk(KERN_INFO "attempt to access beyond end of device\n");
-	printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
+	printk(KERN_INFO "%s: rw=%s, want=%Lu, limit=%Lu\n",
 			bdevname(bio->bi_bdev, b),
-			bio->bi_rw,
+			(bio->bi_rw & WRITE) ? "WRITE" : "READ",
 			(unsigned long long)bio_end_sector(bio),
 			(long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
 
-- 
1.9.0.GIT

