Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbaKROTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:19:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57040 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbaKROK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:26 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Mark Brown <broonie@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 155/206] spi: pl022: Fix incorrect dma_unmap_sg
Date: Tue, 18 Nov 2014 15:08:30 +0100
Message-Id: <d0ef4acce233803e2113b9e6b2c6f8400e48a9fe.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ray Jui <rjui@broadcom.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3ffa6158f002e096d28ede71be4e0ee8ab20baa2 upstream.

When mapped RX DMA entries are unmapped in an error condition when DMA
is firstly configured in the driver, the number of TX DMA entries was
passed in, which is incorrect

Signed-off-by: Ray Jui <rjui@broadcom.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/spi/spi-pl022.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-pl022.c b/drivers/spi/spi-pl022.c
index 9c511a954d21..b1a9ba893fab 100644
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
2.1.3

