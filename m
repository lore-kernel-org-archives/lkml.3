Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab3IPMwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:52:09 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:40201 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab3IPMvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:48 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Steven Whitehouse <swhiteho@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH 07/11] gfs2: pass correct dentry to finish_open() in __gfs2_lookup()
Date: Mon, 16 Sep 2013 14:52:01 +0200
Message-Id: <1379335925-30858-8-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

AFAICS if d_splice_alias() returned non-NULL, this code would Oops
(finish_open expects an instantiated dentry).

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: stable@vger.kernel.org
---
 fs/gfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 6d7f976..abe7dae 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -774,7 +774,7 @@ static struct dentry *__gfs2_lookup(struct inode *dir, struct dentry *dentry,
 
 	d = d_splice_alias(inode, dentry);
 	if (file && S_ISREG(inode->i_mode))
-		error = finish_open(file, dentry, gfs2_open_common, opened);
+		error = finish_open(file, d ? d : dentry, gfs2_open_common, opened);
 
 	gfs2_glock_dq_uninit(&gh);
 	if (error)
-- 
1.8.1.4

