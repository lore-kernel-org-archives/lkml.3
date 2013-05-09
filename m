Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3EIVHw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 17:07:52 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:47757 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab3EIVFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 17:05:09 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 08/12] net/ethernet: MACB should depend on HAS_DMA
Date: Thu,  9 May 2013 23:04:50 +0200
Message-Id: <1368133494-22198-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
References: <1368133494-22198-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `macb_free_consistent':
drivers/net/ethernet/cadence/macb.c:878: undefined reference to `dma_free_coherent'
drivers/net/ethernet/cadence/macb.c:883: undefined reference to `dma_free_coherent'
drivers/net/ethernet/cadence/macb.c:888: undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `macb_alloc_consistent':
drivers/net/ethernet/cadence/macb.c:905: undefined reference to `dma_alloc_coherent'
drivers/built-in.o: In function `macb_tx_interrupt':
drivers/net/ethernet/cadence/macb.c:515: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `macb_tx_error_task':
drivers/net/ethernet/cadence/macb.c:457: undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `macb_start_xmit':
drivers/net/ethernet/cadence/macb.c:838: undefined reference to `dma_map_single'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/cadence/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/cadence/Kconfig b/drivers/net/ethernet/cadence/Kconfig
index 0d9d6e6..768285e 100644
--- a/drivers/net/ethernet/cadence/Kconfig
+++ b/drivers/net/ethernet/cadence/Kconfig
@@ -31,6 +31,7 @@ config ARM_AT91_ETHER
 
 config MACB
 	tristate "Cadence MACB/GEM support"
+	depends on HAS_DMA
 	select PHYLIB
 	---help---
 	  The Cadence MACB ethernet interface is found on many Atmel AT32 and
-- 
1.7.0.4

