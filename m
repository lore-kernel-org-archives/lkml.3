Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968AbaJ2MqY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:46:24 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14402 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806AbaJ2MqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:21 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 24/35] UBI: Fastmap: Fix leb_count unbalance
Date: Wed, 29 Oct 2014 13:45:47 +0100
Message-Id: <1414586758-9972-25-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a LEB is unmapped we have to decrement leb_count as well.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 79b7387..af490c3 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -426,6 +426,7 @@ static void unmap_peb(struct ubi_attach_info *ai, int pnum)
 			aeb = rb_entry(node2, struct ubi_ainf_peb, u.rb);
 			if (aeb->pnum == pnum) {
 				rb_erase(&aeb->u.rb, &av->root);
+				av->leb_count--;
 				kmem_cache_free(ai->aeb_slab_cache, aeb);
 				return;
 			}
-- 
1.8.4.5

