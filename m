Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbaFLSFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:05:20 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:50581 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbaFLSFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:05:18 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjoIAHTqmVNbsHy//2dsb2JhbABagw2qdQUBAQEBAQEFAZkegQsXdYQxLyOBGjeIRgG4PJoWF4VciH8dhCsEj2iKSoswiCKDPjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] block/partitions/amiga.c: replace nolevel printk by pr_err
Date: Thu, 12 Jun 2014 20:04:52 +0200
Message-Id: <1402596292-3993-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add no prefix pr_fmt to avoid any future default format update

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 block/partitions/amiga.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/partitions/amiga.c b/block/partitions/amiga.c
index 70cbf44..2b13533 100644
--- a/block/partitions/amiga.c
+++ b/block/partitions/amiga.c
@@ -7,6 +7,8 @@
  *  Re-organised Feb 1998 Russell King
  */
 
+#define pr_fmt(fmt) fmt
+
 #include <linux/types.h>
 #include <linux/affs_hardblocks.h>
 
@@ -40,7 +42,7 @@ int amiga_partition(struct parsed_partitions *state)
 		data = read_part_sector(state, blk, &sect);
 		if (!data) {
 			if (warn_no_part)
-				printk("Dev %s: unable to read RDB block %d\n",
+				pr_err("Dev %s: unable to read RDB block %d\n",
 				       bdevname(state->bdev, b), blk);
 			res = -1;
 			goto rdb_done;
@@ -57,12 +59,12 @@ int amiga_partition(struct parsed_partitions *state)
 		*(__be32 *)(data+0xdc) = 0;
 		if (checksum_block((__be32 *)data,
 				be32_to_cpu(rdb->rdb_SummedLongs) & 0x7F)==0) {
-			printk("Warning: Trashed word at 0xd0 in block %d "
-				"ignored in checksum calculation\n",blk);
+			pr_err("Trashed word at 0xd0 in block %d ignored in checksum calculation\n",
+			       blk);
 			break;
 		}
 
-		printk("Dev %s: RDB in block %d has bad checksum\n",
+		pr_err("Dev %s: RDB in block %d has bad checksum\n",
 		       bdevname(state->bdev, b), blk);
 	}
 
@@ -83,7 +85,7 @@ int amiga_partition(struct parsed_partitions *state)
 		data = read_part_sector(state, blk, &sect);
 		if (!data) {
 			if (warn_no_part)
-				printk("Dev %s: unable to read partition block %d\n",
+				pr_err("Dev %s: unable to read partition block %d\n",
 				       bdevname(state->bdev, b), blk);
 			res = -1;
 			goto rdb_done;
-- 
1.9.1

