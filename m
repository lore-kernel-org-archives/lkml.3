Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaH2QVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:21:47 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:45237 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaH2QVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:21:46 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Iyappan Subramanian <isubramanian@apm.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] drivers: net: NET_XGENE should depend on HAS_DMA
Date: Fri, 29 Aug 2014 18:21:41 +0200
Message-Id: <1409329301-6747-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If NO_DMA=y:

drivers/built-in.o: In function `xgene_enet_delete_ring':
xgene_enet_main.c:(.text+0x28755a): undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `xgene_enet_setup_tx_desc':
xgene_enet_main.c:(.text+0x287774): undefined reference to `dma_map_single'
xgene_enet_main.c:(.text+0x287780): undefined reference to `dma_mapping_error'
drivers/built-in.o: In function `xgene_enet_tx_completion':
xgene_enet_main.c:(.text+0x2878e6): undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `xgene_enet_refill_bufpool':
xgene_enet_main.c:(.text+0x2879d4): undefined reference to `dma_map_single'
xgene_enet_main.c:(.text+0x2879e0): undefined reference to `dma_mapping_error'
drivers/built-in.o: In function `xgene_enet_rx_frame':
xgene_enet_main.c:(.text+0x287aaa): undefined reference to `dma_unmap_single'
drivers/built-in.o: In function `xgene_enet_free_desc_ring':
xgene_enet_main.c:(.text+0x287f98): undefined reference to `dma_free_coherent'
drivers/built-in.o: In function `xgene_enet_create_desc_ring':
xgene_enet_main.c:(.text+0x28808e): undefined reference to `dma_alloc_coherent'
drivers/built-in.o: In function `xgene_enet_probe':
xgene_enet_main.c:(.text+0x2883d4): undefined reference to `dma_set_mask'
xgene_enet_main.c:(.text+0x2883ec): undefined reference to `dma_supported'

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/net/ethernet/apm/xgene/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/apm/xgene/Kconfig b/drivers/net/ethernet/apm/xgene/Kconfig
index 616dff6d3f5f..f4054d242f3c 100644
--- a/drivers/net/ethernet/apm/xgene/Kconfig
+++ b/drivers/net/ethernet/apm/xgene/Kconfig
@@ -1,5 +1,6 @@
 config NET_XGENE
 	tristate "APM X-Gene SoC Ethernet Driver"
+	depends on HAS_DMA
 	select PHYLIB
 	help
 	  This is the Ethernet driver for the on-chip ethernet interface on the
-- 
1.9.1

