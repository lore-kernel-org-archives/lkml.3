Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaKFWmx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:42:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58918 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbaKFWmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:46 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ray Jui <rjui@broadcom.com>, Mark Brown <broonie@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 112/162] spi: pl022: Fix incorrect dma_unmap_sg
Date: Thu,  6 Nov 2014 14:36:16 -0800
Message-Id: <1415313426-9622-113-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ray Jui <rjui@broadcom.com>

commit 3ffa6158f002e096d28ede71be4e0ee8ab20baa2 upstream.

When mapped RX DMA entries are unmapped in an error condition when DMA
is firstly configured in the driver, the number of TX DMA entries was
passed in, which is incorrect

Signed-off-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/spi/spi-pl022.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 2789b45..971855e 100644
--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1075,7 +1075,7 @@ err_rxdesc:
 		     pl022->sgt_tx.nents, DMA_TO_DEVICE);
 err_tx_sgmap:
 	dma_unmap_sg(rxchan->device->dev, pl022->sgt_rx.sgl,
-		     pl022->sgt_tx.nents, DMA_FROM_DEVICE);
+		     pl022->sgt_rx.nents, DMA_FROM_DEVICE);
 err_rx_sgmap:
 	sg_free_table(&pl022->sgt_tx);
 err_alloc_tx_sg:
-- 
1.9.1

