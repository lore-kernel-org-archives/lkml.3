Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbaDMQKr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 12:10:47 -0400
Received: from mout.gmx.net ([212.227.15.18]:49197 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaDMQKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 12:10:45 -0400
From: xypron.glpk@gmx.de
To: viro@zeniv.linux.org.uk
Cc: jack@suse.cz, eparis@redhat.com, mtk.manpages@gmail.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] fanotify: create FAN_ACCESS event for readdir
Date: Sun, 13 Apr 2014 18:10:30 +0200
Message-Id: <1397405430-7577-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 1.7.10.4
X-Provags-ID: V03:K0:o+l9FrOjL6R8CI7DDqd3QhVz/7I5f1P2WgqRXLvrDyXHfKSR9Gz
 +Jg7H8UdH5O5i2mF+tjuqnjxRejp9U2Pc9Q5/z08YkACVVG1INeVFb7eS23VKY7SzLORpML
 +OtZ3J2iukm4dsObzKvpVuHsi9tiaDAyQ43iyLyavgHbemqcl6LDs2yJ6J/YNw0mHT/UuuU
 f1YKaqEB1tWEoYXwDuMuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heinrich Schuchardt <xypron.glpk@gmx.de>

Before the patch,
read creates FAN_ACCESS_PERM and FAN_ACCESS events,
readdir creates only FAN_ACCESS_PERM events.

This is inconsistent.

After the patch,
readdir creates FAN_ACCESS_PERM and FAN_ACCESS events.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 fs/readdir.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/readdir.c b/fs/readdir.c
index 5b53d99..33fd922 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -13,6 +13,7 @@
 #include <linux/stat.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/fsnotify.h>
 #include <linux/dirent.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
@@ -40,6 +41,7 @@ int iterate_dir(struct file *file, struct dir_context *ctx)
 		ctx->pos = file->f_pos;
 		res = file->f_op->iterate(file, ctx);
 		file->f_pos = ctx->pos;
+		fsnotify_access(file);
 		file_accessed(file);
 	}
 	mutex_unlock(&inode->i_mutex);
-- 
1.7.10.4

