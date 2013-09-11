Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab3IKLAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:00:41 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:38934 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab3IKLAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:00:39 -0400
Date: Wed, 11 Sep 2013 19:00:27 +0800
From: majianpeng <majianpeng@gmail.com>
To: axboe <axboe@kernel.dk>, viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [PATCH 0/2] Auto stop async-write on block device when device removed.
X-Priority: 3
X-GUID: F4DDE3AE-1EA8-4836-9E93-10A18A3DC270
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.93[cn]
Mime-Version: 1.0
Message-ID: <201309111900239451333@gmail.com>
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8BB0jnW004167

For async-write on block device,if device removed,but the vfs don't know it.
It will continu do.
Patch1 set size of inode of block device to zero when removed disk.By this,vfs know 
disk changed.
Path2 add size-check on blk_aio_write.If pos of write larger than size of inode,it will
return zero.So the user can check disk state.


Jianpeng Ma (2):
  block: Set inode of block_device size to zero when delete gendisk.
  block_dev: Add size check before doing async write on block device.

 block/genhd.c  | 14 ++++++++++++++
 fs/block_dev.c |  4 ++++
 2 files changed, 18 insertions(+)

-- 
1.8.4-rc0
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
