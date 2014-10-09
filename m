Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513AbaJIV0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:26:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632AbaJIVKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:10:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andrey Vagin <avagin@openvz.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 053/163] fs/notify: don't show f_handle if exportfs_encode_inode_fh failed
Date: Thu,  9 Oct 2014 14:01:18 -0700
Message-Id: <1412888588-26755-54-git-send-email-kamal@canonical.com>
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

commit 7e8824816bda16bb11ff5ff1e1212d642e57b0b3 upstream.

Currently we handle only ENOSPC.  In case of other errors the file_handle
variable isn't filled properly and we will show a part of stack.

Signed-off-by: Andrey Vagin <avagin@openvz.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/notify/fdinfo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 660d33b..9d7e2b9 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -50,7 +50,7 @@ static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
 	size = f.handle.handle_bytes >> 2;
 
 	ret = exportfs_encode_inode_fh(inode, (struct fid *)f.handle.f_handle, &size, 0);
-	if ((ret == FILEID_INVALID) || (ret == -ENOSPC)) {
+	if ((ret == FILEID_INVALID) || (ret < 0)) {
 		WARN_ONCE(1, "Can't encode file handler for inotify: %d\n", ret);
 		return 0;
 	}
-- 
1.9.1

