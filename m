Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3IPMwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:52:19 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:43998 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3IPMvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:51:50 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 10/11] nfs: set FILE_CREATED
Date: Mon, 16 Sep 2013 14:52:04 +0200
Message-Id: <1379335925-30858-11-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Set FILE_CREATED on O_CREAT|O_EXCL.  If the NFS server honored our request
for exclusivity then this must be correct.

Currently this is a no-op, since the VFS sets FILE_CREATED anyway.  The
next patch will, however, require this flag to be always set by
filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index de434f3..854a8f0 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1392,6 +1392,9 @@ static int nfs_finish_open(struct nfs_open_context *ctx,
 {
 	int err;
 
+	if ((open_flags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+		*opened |= FILE_CREATED;
+
 	err = finish_open(file, dentry, do_open, opened);
 	if (err)
 		goto out;
-- 
1.8.1.4

