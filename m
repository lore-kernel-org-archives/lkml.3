Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3GXEqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 00:46:54 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:32886 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3GXEqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 00:46:52 -0400
Date: Wed, 24 Jul 2013 12:46:44 +0800
From: majianpeng <majianpeng@gmail.com>
To: sage <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH] ceph: Don't use ceph-sync-mode for synchronous-fs.
References: <201306271556037311581@gmail.com>, 
	<201307161949279533980@gmail.com> <201307240828220999500@gmail.com>, 
	<alpine.DEB.2.00.1307231812280.8332@cobra.newdream.net>
X-Priority: 3
X-GUID: 7FABF9DC-66BF-4D53-868E-1897418653CA
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201307241246395750351@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6O4l1BT025552

>Hi,
>
>Sorry for the slow review.  The patch looks good, but I have a hard time 
>understanding your changelog... is it okay if I change it to something 
>like:
>
>
>Sending reads and writes through the sync read/write paths bypasses the 
>page cache, which is not expected or generally a good idea.  Removing 
>the write check is safe as there is a conditional vfs_fsync_range() later 
>in ceph_aio_write that already checks for the same flag (via 
>IS_SYNC(inode)).
>
Very good.
It's my fault. I will notice the message later.

Thanks !
Jianpeng Ma
>?
>
>Thanks!
>sage
>
>
>On Wed, 24 Jul 2013, majianpeng wrote:
>
>> Ping
>> >Hi sage,
>> >	How about this patch?Can you give some advisement?
>> >Thanks!
>> >Jianpeng Ma
>> >>At now for synchronous-fs, all write-operations use ceph_sync_mode.
>> >>But for the file which opened with O_SYNC, it don't use sync_mode.
>> >>The behaviour of them should be the same.
>> >>For fs which mounted using '-o sync', it want all I/O to the filesystem
>> >>should be done synchronously.But the ceph-sync-mode don't be suitful
>> >>for.For example,using ceph-sync-mode the content of file don't have in
>> >>memory.This will cause the following read only from osd rather than
>> >>memory.
>> >>
>> >>Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>> >>---
>> >> fs/ceph/file.c | 2 --
>> >> 1 file changed, 2 deletions(-)
>> >>
>> >>diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> >>index 656e169..44670ad 100644
>> >>--- a/fs/ceph/file.c
>> >>+++ b/fs/ceph/file.c
>> >>@@ -659,7 +659,6 @@ again:
>> >> 
>> >> 	if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
>> >> 	    (iocb->ki_filp->f_flags & O_DIRECT) ||
>> >>-	    (inode->i_sb->s_flags & MS_SYNCHRONOUS) ||
>> >> 	    (fi->flags & CEPH_F_SYNC))
>> >> 		/* hmm, this isn't really async... */
>> >> 		ret = ceph_sync_read(filp, base, len, ppos, &checkeof);
>> >>@@ -764,7 +763,6 @@ retry_snap:
>> >> 
>> >> 	if ((got & (CEPH_CAP_FILE_BUFFER|CEPH_CAP_FILE_LAZYIO)) == 0 ||
>> >> 	    (iocb->ki_filp->f_flags & O_DIRECT) ||
>> >>-	    (inode->i_sb->s_flags & MS_SYNCHRONOUS) ||
>> >> 	    (fi->flags & CEPH_F_SYNC)) {
>> >> 		mutex_unlock(&inode->i_mutex);
>> >> 		written = ceph_sync_write(file, iov->iov_base, count,
>> >>-- 
>> >>1.8.1.2ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
