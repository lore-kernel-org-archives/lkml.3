Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab3IQDWO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 23:22:14 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:60799 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3IQDWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 23:22:09 -0400
Date: Tue, 17 Sep 2013 11:22:01 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH V2 1/2] block: Set inode of block_device size to zero when delete gendisk.
X-Priority: 3
X-GUID: AAF89344-1C0F-4746-870F-F77EC00E3D87
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309171121587796647@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8H3MRwo008940

When remove gendisk, set the size of inode of block_device to zero.
This is mainly let the vfs know disk removed.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 block/genhd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index dadf42b..9a4c245 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1369,6 +1369,12 @@ int invalidate_partition(struct gendisk *disk, int partno)
 	if (bdev) {
 		fsync_bdev(bdev);
 		res = __invalidate_device(bdev, true);
+		/*
+		 * When used buffer-mode on raw blockdevice,the disk removed.
+		 * But the vfs don't know.So tell the vfs size of disk
+		 * became zero, the buffer write can return
+		 */
+		i_size_write(bdev->bd_inode, 0);
 		bdput(bdev);
 	}
 	return res;
-- 
1.8.4-rc0
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
