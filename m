Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbaFPTrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:47:08 -0400
Received: from mail-ig0-f195.google.com ([209.85.213.195]:50468 "EHLO
	mail-ig0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPTrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:47:06 -0400
From: Nicholas Krause <xerofoify@gmail.com>
To: joern@logfs.org
Cc: prasadjoshi.linux@gmail.com, logfs@logfs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Check for Null return from logfs_readpage_nolock in btree_write_block
Date: Mon, 16 Jun 2014 15:47:01 -0400
Message-Id: <1402948021-8797-1-git-send-email-xerofoify@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 fs/logfs/readwrite.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
index 4814031..adb9233 100644
--- a/fs/logfs/readwrite.c
+++ b/fs/logfs/readwrite.c
@@ -2210,6 +2210,8 @@ void btree_write_block(struct logfs_block *block)
 	page = logfs_get_write_page(inode, block->bix, block->level);
 
 	err = logfs_readpage_nolock(page);
+	if (!err)
+		return -ENOMEM;
 	BUG_ON(err);
 	BUG_ON(!PagePrivate(page));
 	BUG_ON(logfs_block(page) != block);
-- 
1.9.1

