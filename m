Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab3FQOT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:19:59 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:41887 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3FQOT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:19:58 -0400
Message-ID: <51BF1AE7.8040300@gmail.com>
Date: Mon, 17 Jun 2013 22:19:19 +0800
From: majianpeng <majianpeng@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: sage@inktank.com
CC: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: remove sb_start/end_write in ceph_aio_write.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Either in vfs_write or io_submit,it call file_start/end_write.
The different between file_start/end_write and sb_start/end_write is
file_ only handle regular file.But i think in ceph_aio_write,it only
for regular file.

Signed-off-by: Jianpeng Ma<majianpeng@gmail.com>
---
  fs/ceph/file.c | 2 --
  1 file changed, 2 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 656e169..7c69f4f 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -716,7 +716,6 @@ static ssize_t ceph_aio_write(struct kiocb *iocb, const struct iovec *iov,
  	if (ceph_snap(inode) != CEPH_NOSNAP)
  		return -EROFS;
  
-	sb_start_write(inode->i_sb);
  	mutex_lock(&inode->i_mutex);
  	hold_mutex = true;
  
@@ -809,7 +808,6 @@ retry_snap:
  out:
  	if (hold_mutex)
  		mutex_unlock(&inode->i_mutex);
-	sb_end_write(inode->i_sb);
  	current->backing_dev_info = NULL;
  
  	return written ? written : err;
-- 1.8.3.rc1.44.gb387c77

