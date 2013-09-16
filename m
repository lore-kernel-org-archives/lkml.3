Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3IPMwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:52:17 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:58443 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3IPMvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:49 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/11] gfs2: set FILE_CREATED
Date: Mon, 16 Sep 2013 14:52:03 +0200
Message-Id: <1379335925-30858-10-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

In gfs2_create_inode() set FILE_CREATED in *opened.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/gfs2/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9a1be62..ef411a3 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -694,8 +694,10 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 
 	mark_inode_dirty(inode);
 	d_instantiate(dentry, inode);
-	if (file)
+	if (file) {
+		*opened |= FILE_CREATED;
 		error = finish_open(file, dentry, gfs2_open_common, opened);
+	}
 	gfs2_glock_dq_uninit(ghs);
 	gfs2_glock_dq_uninit(ghs + 1);
 	return error;
-- 
1.8.1.4

