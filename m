Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab3JGWYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:24:16 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:41671 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3JGWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:24:14 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: dan.j.williams@intel.com, vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, kernel-br@googlegroups.com,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] dma: edma.c: remove edma_desc leakage
Date: Mon,  7 Oct 2013 19:19:58 -0300
Message-Id: <1381184398-11307-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free memory allocated to edma_desc when failing to allocate slot.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/dma/edma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index ff50ff4..3aab605 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -306,6 +306,7 @@ static struct dma_async_tx_descriptor *edma_prep_slave_sg(
 						EDMA_SLOT_ANY);
 			if (echan->slot[i] < 0) {
 				dev_err(dev, "Failed to allocate slot\n");
+				kfree(edesc);
 				return NULL;
 			}
 		}
-- 
1.8.4

