Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab3AZBbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:31:36 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:40721 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3AZBbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:31:22 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Chas Williams <chas@cmf.nrl.navy.mil>,
        netdev@vger.kernel.org
Subject: [PATCH 02/14] atm/nicstar: don't use idr_remove_all()
Date: Fri, 25 Jan 2013 17:31:00 -0800
Message-Id: <1359163872-1949-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359163872-1949-1-git-send-email-tj@kernel.org>
References: <1359163872-1949-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

idr_destroy() can destroy idr by itself and idr_remove_all() is being
deprecated.  Drop its usage.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: netdev@vger.kernel.org
---
This patch depends on an earlier idr patch and given the trivial
nature of the patch, I think it would be best to route these together
through -mm.  Please holler if there's any objection.

Thanks.

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

