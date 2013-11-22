Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab3KVQyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 11:54:15 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50504 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab3KVQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 11:54:14 -0500
From: andrew.liu200917@gmail.com
To: dan.j.williams@intel.com, vinod.koul@intel.com
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Liu <andrew.liu200917@gmail.com>
Subject: [PATCH] edma: free the same memory twice
Date: Sat, 23 Nov 2013 00:54:03 +0800
Message-Id: <1385139243-5892-1-git-send-email-andrew.liu200917@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Liu <andrew.liu200917@gmail.com>

Signed-off-by: Andrew Liu <andrew.liu200917@gmail.com>
---
 drivers/dma/edma.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index bef8a36..04bc1be 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -305,7 +305,6 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 				edma_alloc_slot(EDMA_CTLR(echan->ch_num),
 						EDMA_SLOT_ANY);
 			if (echan->slot[i] < 0) {
-				kfree(edesc);
 				dev_err(dev, "Failed to allocate slot\n");
 				kfree(edesc);
 				return NULL;
-- 
1.7.9

