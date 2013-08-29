Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3H2UMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:12:03 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33754 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757112Ab3H2UMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:12:00 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, ceph-devel@vger.kernel.org
Subject: [PATCH 5/6] ceph: Convert kmem_cache_alloc(...GFP_ZERO) to kmem_cache_zalloc
Date: Thu, 29 Aug 2013 13:11:09 -0700
Message-Id: <a67358bbb2f7d191cac51493a9207ba301439f4b.1377806578.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1377806578.git.joe@perches.com>
References: <cover.1377806578.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper exists, might as well use it instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ceph/dir.c  | 2 +-
 fs/ceph/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 868b61d..c10bc70 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -40,7 +40,7 @@ int ceph_init_dentry(struct dentry *dentry)
 	if (dentry->d_fsdata)
 		return 0;
 
-	di = kmem_cache_alloc(ceph_dentry_cachep, GFP_NOFS | __GFP_ZERO);
+	di = kmem_cache_zalloc(ceph_dentry_cachep, GFP_NOFS);
 	if (!di)
 		return -ENOMEM;          /* oh well */
 
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 20d0222..1b5f8ec 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -75,7 +75,7 @@ static int ceph_init_file(struct inode *inode, struct file *file, int fmode)
 	case S_IFDIR:
 		dout("init_file %p %p 0%o (regular)\n", inode, file,
 		     inode->i_mode);
-		cf = kmem_cache_alloc(ceph_file_cachep, GFP_NOFS | __GFP_ZERO);
+		cf = kmem_cache_zalloc(ceph_file_cachep, GFP_NOFS);
 		if (cf == NULL) {
 			ceph_put_fmode(ceph_inode(inode), fmode); /* clean up */
 			return -ENOMEM;
-- 
1.8.1.2.459.gbcd45b4.dirty

