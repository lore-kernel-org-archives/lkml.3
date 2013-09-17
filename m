Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3IQDWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 23:22:09 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33058 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3IQDWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 23:22:05 -0400
Date: Tue, 17 Sep 2013 11:21:58 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH V2 0/2] Auto stop async-write on block device when device removed.
X-Priority: 3
X-GUID: 88952C34-4B77-4599-AB14-332896586588
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309171121559232246@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8H3MGYl008936

For async-write on block device,if device removed,but the vfs don't know it.
It will continue to do.
Patch1 set size of inode of block device to zero when removed disk.By this,vfs know 
disk changed.
Path2 add size-check on blk_aio_write.If pos of write larger than size of inode,it will
return zero.So the user can check disk state.

V2:
patch1:
      -consider the case which disk has partitions
      -move i_size_write into func invalidate_partition
patch2: No change

Jianpeng Ma (2):
  block: Set inode of block_device size to zero when delete gendisk.
  block_dev: Add size check before doing async write on block device.

 block/genhd.c | 6 ++++++
 fs/block_dev.c |  4 ++++
 2 files changed, 10 insertions(+)

-- 
1.8.4-rc0ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
