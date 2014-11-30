Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbaK3MEp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:04:45 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaK3MEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:04:43 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/6] UBI: Fastmap: Fix leb_count unbalance
Date: Sun, 30 Nov 2014 13:04:25 +0100
Message-Id: <1417349070-8894-2-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349070-8894-1-git-send-email-richard@nod.at>
References: <1417349070-8894-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a LEB is unmapped we have to decrement leb_count as well.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 3d913f5..5db41a5 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -362,6 +362,7 @@ static void unmap_peb(struct ubi_attach_info *ai, int pnum)
 			aeb = rb_entry(node2, struct ubi_ainf_peb, u.rb);
 			if (aeb->pnum == pnum) {
 				rb_erase(&aeb->u.rb, &av->root);
+				av->leb_count--;
 				kmem_cache_free(ai->aeb_slab_cache, aeb);
 				return;
 			}
-- 
1.8.4.5

