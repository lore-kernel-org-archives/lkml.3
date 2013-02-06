Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531Ab3BFUOi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:14:38 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62908 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab3BFTtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:25 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Chas Williams <chas@cmf.nrl.navy.mil>, netdev@vger.kernel.org
Subject: [PATCH 03/77] atm/nicstar: don't use idr_remove_all()
Date: Wed,  6 Feb 2013 11:39:35 -0800
Message-Id: <1360179649-22465-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: netdev@vger.kernel.org
---
 drivers/atm/nicstar.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/atm/nicstar.c b/drivers/atm/nicstar.c
index ed1d2b7..628787e 100644
--- a/drivers/atm/nicstar.c
+++ b/drivers/atm/nicstar.c
@@ -251,7 +251,6 @@ static void nicstar_remove_one(struct pci_dev *pcidev)
 		if (card->scd2vc[j] != NULL)
 			free_scq(card, card->scd2vc[j]->scq, card->scd2vc[j]->tx_vcc);
 	}
-	idr_remove_all(&card->idr);
 	idr_destroy(&card->idr);
 	pci_free_consistent(card->pcidev, NS_RSQSIZE + NS_RSQ_ALIGNMENT,
 			    card->rsq.org, card->rsq.dma);
-- 
1.8.1

