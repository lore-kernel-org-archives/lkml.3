Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3H2ULf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:11:35 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52861 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757234Ab3H2ULe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:11:34 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] block: Convert kmem_cache_alloc(...GFP_ZERO) to kmem_cache_zalloc
Date: Thu, 29 Aug 2013 13:11:06 -0700
Message-Id: <bb264668d7536628a9886f655a0e61c5257c36c9.1377806578.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1377806578.git.joe@perches.com>
References: <cover.1377806578.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The helper exists, might as well use it instead of __GFP_ZERO.

Signed-off-by: Joe Perches <joe@perches.com>
---
 block/blk-integrity.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 03cf717..b97f2e2 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -388,8 +388,7 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 	BUG_ON(disk == NULL);
 
 	if (disk->integrity == NULL) {
-		bi = kmem_cache_alloc(integrity_cachep,
-				      GFP_KERNEL | __GFP_ZERO);
+		bi = kmem_cache_zalloc(integrity_cachep, GFP_KERNEL);
 		if (!bi)
 			return -1;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

