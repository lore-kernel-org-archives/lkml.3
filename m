Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbaJIVJq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:09:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59412 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbaJIVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:09:42 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrey Vagin <avagin@openvz.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 052/163] fsnotify/fdinfo: use named constants instead of hardcoded values
Date: Thu,  9 Oct 2014 14:01:17 -0700
Message-Id: <1412888588-26755-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vagin <avagin@openvz.org>

commit 1fc98d11cac6dd66342e5580cb2687e5b1e9a613 upstream.

MAX_HANDLE_SZ is equal to 128, but currently the size of pad is only 64
bytes, so exportfs_encode_inode_fh can return an error.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/notify/fdinfo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 238a593..660d33b 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -42,7 +42,7 @@ static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
 {
 	struct {
 		struct file_handle handle;
-		u8 pad[64];
+		u8 pad[MAX_HANDLE_SZ];
 	} f;
 	int size, ret, i;
 
@@ -50,7 +50,7 @@ static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
 	size = f.handle.handle_bytes >> 2;
 
 	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
-	if ((ret == 255) || (ret == -ENOSPC)) {
+	if ((ret == FILEID_INVALID) || (ret == -ENOSPC)) {
 		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
 		return 0;
 	}
-- 
1.9.1

