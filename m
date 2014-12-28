Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaL1P2i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 10:28:38 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:30091 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbaL1P2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 10:28:34 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnUNAOMgoFRXQ78c/2dsb2JhbABcgwaBKrQdBgEBAQEBBQF3lzaBDBcBAQEBAX2EOi8jgRo3iBgDFQG1P4lgFYUBLIYDiSMBAU8dhBMFjXSJFJFQIoFFAYIpPTGBDIE3AQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Evgeniy Dushistov <dushistov@mail.ru>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/ufs/super.c: remove unnecessary casting
Date: Sun, 28 Dec 2014 16:28:29 +0100
Message-Id: <1419780509-4582-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following coccinelle warning:
fs/ufs/super.c:1418:7-28: WARNING: casting value returned by memory
allocation function to (struct ufs_inode_info *) is useless.

Cc: Evgeniy Dushistov <dushistov@mail.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ufs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index da73801..a15798f 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1414,8 +1414,8 @@ static struct kmem_cache * ufs_inode_cachep;
 
 static struct inode *ufs_alloc_inode(struct super_block *sb)
 {
-	struct ufs_inode_info *ei;
-	ei = (struct ufs_inode_info *)kmem_cache_alloc(ufs_inode_cachep, GFP_NOFS);
+	struct ufs_inode_info *ei = kmem_cache_alloc(ufs_inode_cachep,
+						     GFP_NOFS);
 	if (!ei)
 		return NULL;
 	ei->vfs_inode.i_version = 1;
-- 
2.1.0

