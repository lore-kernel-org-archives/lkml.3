Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbaIBIBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 04:01:33 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:35326 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbaIBIBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 04:01:32 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrey Vagin <avagin@openvz.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] fsnotify/fdinfo: use named constants instead of hardcoded values
Date: Tue,  2 Sep 2014 12:00:14 +0400
Message-Id: <1409644815-19367-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX_HANDLE_SZ is equal to 128, but currently the size of pad is only 64
bytes, so exportfs_encode_inode_fh can return an error.

Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
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
1.9.3

