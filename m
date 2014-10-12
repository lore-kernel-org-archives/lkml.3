Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaJLUqP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:46:15 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52254 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaJLUqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:46:13 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 1/5] fs/anon_inodes.c: Remove unnecessary IS_ERR(anon_inode_inode)
Date: Sun, 12 Oct 2014 15:42:38 -0500
Message-Id: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

anon_inode_inode is allocated by anon_inode_init(), which is fs_initcall
and will panic if it couldn't be allocated.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/anon_inodes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index 80ef38c..1faff09 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -75,9 +75,6 @@ struct file *anon_inode_getfile(const char *name,
 	struct path path;
 	struct file *file;
 
-	if (IS_ERR(anon_inode_inode))
-		return ERR_PTR(-ENODEV);
-
 	if (fops->owner && !try_module_get(fops->owner))
 		return ERR_PTR(-ENOENT);
 
-- 
2.1.2

