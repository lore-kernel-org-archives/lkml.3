Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab3ITUT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:19:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41722 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3ITUPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:15:06 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Miklos Szeredi <mszeredi@suse.cz>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 68/93] fuse: readdir: check for slash in names
Date: Fri, 20 Sep 2013 13:09:03 -0700
Message-Id: <1379707768-1804-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit efeb9e60d48f7778fdcad4a0f3ad9ea9b19e5dfd upstream.

Userspace can add names containing a slash character to the directory
listing.  Don't allow this as it could cause all sorts of trouble.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
[ kamal: backport to 3.8 (no dirplus) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/fuse/dir.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 54a24fc..146276a 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1148,6 +1148,8 @@ static int parse_dirfile(char *buf, size_t nbytes, struct file *file,
 			return -EIO;
 		if (reclen > nbytes)
 			break;
+		if (memchr(dirent->name, '/', dirent->namelen) != NULL)
+			return -EIO;
 
 		over = filldir(dstbuf, dirent->name, dirent->namelen,
 			       file->f_pos, dirent->ino, dirent->type);
-- 
1.8.1.2

