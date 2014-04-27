Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaD0QQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 12:16:39 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:40708 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbaD0QPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 12:15:25 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: agruen@kernel.org, bfields@fieldses.org, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, dhowells@redhat.com
Cc: aneesh.kumar@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -V1 04/22] vfs: check for directory early
Date: Sun, 27 Apr 2014 21:44:35 +0530
Message-Id: <1398615293-22931-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398615293-22931-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1398615293-22931-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042716-7014-0000-0000-000004CCD68C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@kernel.org>

Signed-off-by: Andreas Gruenbacher <agruen@kernel.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/namei.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index c7fee619691f..7d93d195f0e5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3868,6 +3868,9 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 	if (!inode)
 		return -ENOENT;
 
+	if (S_ISDIR(inode->i_mode))
+		return -EPERM;
+
 	error = may_create(dir, new_dentry);
 	if (error)
 		return error;
@@ -3882,8 +3885,6 @@ int vfs_link(struct dentry *old_dentry, struct inode *dir, struct dentry *new_de
 		return -EPERM;
 	if (!dir->i_op->link)
 		return -EPERM;
-	if (S_ISDIR(inode->i_mode))
-		return -EPERM;
 
 	error = security_inode_link(old_dentry, dir, new_dentry);
 	if (error)
-- 
1.9.1

