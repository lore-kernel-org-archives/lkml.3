Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab3CKLRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:17:10 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46613 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3CKLRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:17:09 -0400
From: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: ecashin@coraid.com, Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
Subject: [PATCH] aoe: replace kmalloc and then memcpy with kmemdup
Date: Mon, 11 Mar 2013 13:16:47 +0200
Message-Id: <1363000607-8173-1-git-send-email-mihneadb@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mihnea Dobrescu-Balaur <mihneadb@gmail.com>
---
 drivers/block/aoe/aoechr.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 42e67ad..ab41be6 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -139,13 +139,12 @@ bail:		spin_unlock_irqrestore(&emsgs_lock, flags);
 		return;
 	}
 
-	mp = kmalloc(n, GFP_ATOMIC);
+	mp = kmemdup(msg, n, GFP_ATOMIC);
 	if (mp == NULL) {
 		printk(KERN_ERR "aoe: allocation failure, len=%ld\n", n);
 		goto bail;
 	}
 
-	memcpy(mp, msg, n);
 	em->msg = mp;
 	em->flags |= EMFL_VALID;
 	em->len = n;
-- 
1.7.10.4

