Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaJLUrE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 16:47:04 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:44879 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaJLUqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 16:46:32 -0400
From: Eric Biggers <ebiggers3@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 5/5] fs/anon_inodes.c: Remove incorrect information in comment
Date: Sun, 12 Oct 2014 15:42:42 -0500
Message-Id: <1413146562-18147-5-git-send-email-ebiggers3@gmail.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
References: <1413146562-18147-1-git-send-email-ebiggers3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dentries for the anonymous inode are *not* named based on the inode
sequence number.

Signed-off-by: Eric Biggers <ebiggers3@gmail.com>
---
 fs/anon_inodes.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
index bbfa038..ee81409 100644
--- a/fs/anon_inodes.c
+++ b/fs/anon_inodes.c
@@ -73,10 +73,7 @@ struct file *anon_inode_getfile(const char *name,
 	if (fops->owner && !try_module_get(fops->owner))
 		return ERR_PTR(-ENOENT);
 
-	/*
-	 * Link the inode to a directory entry by creating a unique name
-	 * using the inode sequence number.
-	 */
+	/* Create a dentry for the new file.  */
 	file = ERR_PTR(-ENOMEM);
 	this.name = name;
 	this.len = strlen(name);
-- 
2.1.2

