Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3CKLYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:24:08 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:56368 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab3CKLYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:24:06 -0400
From: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
To: xen-devel@lists.xensource.com
Cc: konrad.wilk@oracle.com, jeremy@goop.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Subject: [PATCH] block: replace kmalloc and then memcpy with kmemdup
Date: Mon, 11 Mar 2013 13:23:36 +0200
Message-Id: <1363001016-8439-1-git-send-email-mihneadb@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
---
 drivers/block/xen-blkfront.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index c3dae2e..9620644 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1203,11 +1203,10 @@ static int blkif_recover(struct blkfront_info *info)
 	int j;
 
 	/* Stage 1: Make a safe copy of the shadow state. */
-	copy = kmalloc(sizeof(info->shadow),
+	copy = kmemdup(info->shadow, sizeof(info->shadow),
 		       GFP_NOIO | __GFP_REPEAT | __GFP_HIGH);
 	if (!copy)
 		return -ENOMEM;
-	memcpy(copy, info->shadow, sizeof(info->shadow));
 
 	/* Stage 2: Set up free list. */
 	memset(&info->shadow, 0, sizeof(info->shadow));
-- 
1.7.10.4

