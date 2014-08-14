Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaHNLcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 07:32:50 -0400
Received: from mail2.tiolive.com ([94.23.229.207]:43110 "EHLO
	mail2.tiolive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901AbaHNLct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 07:32:49 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Aug 2014 07:32:48 EDT
From: Kirill Smelkov <kirr@nexedi.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kirill Smelkov <kirr@nexedi.com>, Pekka Enberg <penberg@kernel.org>
Subject: [PATCH] vfs: fix typo in s_op->alloc_inode() documentation
Date: Thu, 14 Aug 2014 15:25:10 +0400
Message-Id: <1408015510-2563-1-git-send-email-kirr@nexedi.com>
X-Mailer: git-send-email 2.1.0.rc2.234.ge4c5f60
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function which calls s_op->alloc_inode() is not inode_alloc(), but
instead alloc_inode() which lives in fs/inode.c .

The typo was there from the beginning from 5ea626aa (VFS: update
documentation, 2005) - there was no standalone inode_alloc() for the
whole kernel history.

Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Kirill Smelkov <kirr@nexedi.com>
---
 Documentation/filesystems/vfs.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 61d65cc..02a766c 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -237,7 +237,7 @@ noted. This means that most methods can block safely. All methods are
 only called from a process context (i.e. not from an interrupt handler
 or bottom half).
 
-  alloc_inode: this method is called by inode_alloc() to allocate memory
+  alloc_inode: this method is called by alloc_inode() to allocate memory
  	for struct inode and initialize it.  If this function is not
  	defined, a simple 'struct inode' is allocated.  Normally
  	alloc_inode will be used to allocate a larger structure which
-- 
2.1.0.rc2.234.ge4c5f60
