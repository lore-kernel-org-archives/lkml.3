Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715AbaE3UK7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:10:59 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58881 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934432AbaE3UKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:10:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [RFC 29/32] f2fs: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:53 +0200
Message-Id: <1401480116-1973111-30-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:8jYKt+6KB+WZdmmdOlua3+Q5ej9UGy9BUiIak5x3b1G
 lTRxWWZI6nEmNst46IXyarlTxv+yO69+3VaOrOQg//TRp/RFh2
 y8jM1yrN6yp6+ZoSL8wcjlAhggoRM3GpFK187j2dL3Ci3AUOLq
 g/YuiqXIEGQQC2fMWnk5JtlaF6eYtNOIChtDaXyZrOJ9kCZfU2
 6FolrrXaQBYkic0byGUDXoKDrQ8ULYcjSJjE36h5MGBvXjlOvJ
 dm1vchYeKAxXZwmxclHL1DVfLQhWBUg5xN7yFNkSDZuoZECKJC
 vizDP0dQN/zr8D5g6Zo6ZJdBKkK/fRj+fJpE8vDiW8NRqGCSkF
 93NOktQSaoRvjgXYy0kUyyUV1ALEKImN7mvOW1F/r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

f2fs uses unsigned 40-bit seconds for inode timestamps, which will work
basically forever, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in f2fs.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net
---
 fs/f2fs/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 37d0e1f..6ff6e5b 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -474,13 +474,13 @@ static void __setattr_copy(struct inode *inode, const struct iattr *attr)
 	if (ia_valid & ATTR_GID)
 		inode->i_gid = attr->ia_gid;
 	if (ia_valid & ATTR_ATIME)
-		inode->i_atime = timespec_trunc(attr->ia_atime,
+		inode->i_atime = inode_time_trunc(attr->ia_atime,
 						inode->i_sb->s_time_gran);
 	if (ia_valid & ATTR_MTIME)
-		inode->i_mtime = timespec_trunc(attr->ia_mtime,
+		inode->i_mtime = inode_time_trunc(attr->ia_mtime,
 						inode->i_sb->s_time_gran);
 	if (ia_valid & ATTR_CTIME)
-		inode->i_ctime = timespec_trunc(attr->ia_ctime,
+		inode->i_ctime = inode_time_trunc(attr->ia_ctime,
 						inode->i_sb->s_time_gran);
 	if (ia_valid & ATTR_MODE) {
 		umode_t mode = attr->ia_mode;
-- 
1.8.3.2

