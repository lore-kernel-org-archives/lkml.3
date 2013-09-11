Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab3IKLAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:00:48 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:49905 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab3IKLAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:00:45 -0400
Date: Wed, 11 Sep 2013 19:00:34 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 2/2] block_dev: Add size check before doing async write on block device.
X-Priority: 3
X-GUID: AF3F4965-20D3-4453-BED0-EB197C91FFF8
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309111900317069315@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8BB0w5r004175

For async-write on block device,when disk removed,the vfs don't know.
It will continue do async-write.Add this check it will stop async-write
when disk removed.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 fs/block_dev.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 1173a4e..e308b52 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1514,6 +1514,10 @@ ssize_t blkdev_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	struct file *file = iocb->ki_filp;
 	struct blk_plug plug;
 	ssize_t ret;
+	loff_t size = i_size_read(file->f_mapping->host);
+
+	if (pos >= size)
+		return 0;
 
 	BUG_ON(iocb->ki_pos != pos);
 
-- 
1.8.4-rc0
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
