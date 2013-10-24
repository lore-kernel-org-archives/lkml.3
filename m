Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3JXNOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 09:14:42 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:63329 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab3JXNOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 09:14:41 -0400
From: Valentin Ilie <valentin.ilie@gmail.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, Valentin Ilie <valentin.ilie@gmail.com>
Subject: [PATCH] dma: edma: Fix memory leak
Date: Thu, 24 Oct 2013 16:14:22 +0300
Message-Id: <1382620462-9799-1-git-send-email-valentin.ilie@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When it fails to allocate a slot, edesc should be free'd before return;

Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
---
 drivers/dma/edma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 098a8da..79ebac6 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -305,6 +305,7 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
 						EDMA_SLOT_ANY);
 			if (echan->slot[i] < 0) {
+				kfree(edesc);
 				dev_err(dev, "Failed to allocate slot\n");
 				return NULL;
 			}
-- 
1.8.1.2

