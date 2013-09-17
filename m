Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3IQDWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 23:22:20 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41188 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3IQDWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 23:22:15 -0400
Date: Tue, 17 Sep 2013 11:22:07 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH V2 2/2] block_dev: Add size check before doing async write on block device.
X-Priority: 3
X-GUID: 6C980CBA-ED8F-400A-A5A9-4F6E72032661
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309171122014439438@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8H3MRAJ008944

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
1.8.4-rc0ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
