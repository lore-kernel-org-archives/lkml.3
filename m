Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbaLWSAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 13:00:24 -0500
Received: from www.osadl.org ([62.245.132.105]:33794 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbaLWSAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 13:00:23 -0500
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Prarit Bhargava <prarit@redhat.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicholas Mc Guire <der.herr@hofr.at>
Subject: [PATCH] incorrect use of init_completion fixup
Date: Tue, 23 Dec 2014 18:52:31 +0100
Message-Id: <1419357151-22889-1-git-send-email-der.herr@hofr.at>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The successive init_completion calls should be reinit_completion here.

patch is against 3.18.0 linux-next

Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
---
 drivers/dma/ioat/dma_v3.c |    4 +-
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 32eae38..3dbcc42 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -1353,7 +1353,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 	}

 	async_tx_ack(tx);
-	init_completion(&cmp);
+	reinit_completion(&cmp);
 	tx->callback = ioat3_dma_test_callback;
 	tx->callback_param = &cmp;
 	cookie = tx->tx_submit(tx);
@@ -1405,7 +1405,7 @@ static int ioat_xor_val_self_test(struct ioatdma_device *device)
 	}

 	async_tx_ack(tx);
-	init_completion(&cmp);
+	reinit_completion(&cmp);
 	tx->callback = ioat3_dma_test_callback;
 	tx->callback_param = &cmp;
 	cookie = tx->tx_submit(tx);
--
1.7.10.4

