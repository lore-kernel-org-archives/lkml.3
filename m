Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928AbaL1OzO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 09:55:14 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:61560 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619AbaL1OzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 09:55:11 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnUNAO0YoFRXQ78c/2dsb2JhbABcgwaBKrQdBgEBAQEBBQF3lzaBCxcBAQEBAX2EOi8jgRo3iDABtTiPIYYDiXQdhBMFjXSJFJFQIoFFAYIpPTGCQwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/befs/linuxvfs.c: remove unnecessary casting
Date: Sun, 28 Dec 2014 15:55:03 +0100
Message-Id: <1419778503-2721-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following coccinelle warning:

fs/befs/linuxvfs.c:278:14-36: WARNING: casting value returned by memory
allocation function to (struct befs_inode_info *) is useless.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/befs/linuxvfs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index edf4777..2255f4a 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -274,9 +274,8 @@ more:
 static struct inode *
 befs_alloc_inode(struct super_block *sb)
 {
-        struct befs_inode_info *bi;
-        bi = (struct befs_inode_info *)kmem_cache_alloc(befs_inode_cachep,
-							GFP_KERNEL);
+	struct befs_inode_info *bi = kmem_cache_alloc(befs_inode_cachep,
+						      GFP_KERNEL);
         if (!bi)
                 return NULL;
         return &bi->vfs_inode;
-- 
2.1.0

