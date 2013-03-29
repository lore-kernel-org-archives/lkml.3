Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3C2DDK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 23:03:10 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:62352 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab3C2DDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 23:03:08 -0400
Message-ID: <51550460.6050408@gmail.com>
Date: Fri, 29 Mar 2013 11:02:56 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: miklos@szeredi.hu
CC: fuse-devel@lists.sourceforge.net,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fuse: Don't do file_update_time for write_operation.
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For direct-write and normal-write operations, after write they will call fuse_invalidate_attr.
So it's make no sense to call file_update_time before writing.

In function file_update_time, there is other thing which update version of
inode.For this i am not sure.

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
fs/fuse/file.c | 4 ----
1 file changed, 4 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 34b80ba..214279c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -988,10 +988,6 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
if (err)
goto out;

- err = file_update_time(file);
- if (err)
- goto out;
-
if (file->f_flags & O_DIRECT) {
written = generic_file_direct_write(iocb, iov, &nr_segs,
pos, &iocb->ki_pos,
-- 
1.8.2.rc2.4.g7799588

