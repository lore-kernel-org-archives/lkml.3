Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967568AbaFTMiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:38:23 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:57785 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967224AbaFTMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:37:46 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/4] dmaengine: shdma: Add more register documentation
Date: Fri, 20 Jun 2014 14:37:38 +0200
Message-Id: <1403267861-15609-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403267861-15609-1-git-send-email-geert+renesas@glider.be>
References: <1403267861-15609-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also add a few definitions that were missing.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 arch/sh/include/asm/dma-register.h | 36 +++++++++++++++++++-----------------
 drivers/dma/sh/shdmac.c            | 12 ++++++------
 include/linux/sh_dma.h             | 24 +++++++++++++-----------
 3 files changed, 38 insertions(+), 34 deletions(-)

diff --git a/arch/sh/include/asm/dma-register.h b/arch/sh/include/asm/dma-register.h
index 51cd78feacff..c757b47e6b64 100644
--- a/arch/sh/include/asm/dma-register.h
+++ b/arch/sh/include/asm/dma-register.h
@@ -13,17 +13,17 @@
 #ifndef DMA_REGISTER_H
 #define DMA_REGISTER_H
 
-/* DMA register */
-#define SAR	0x00
-#define DAR	0x04
-#define TCR	0x08
-#define CHCR	0x0C
-#define DMAOR	0x40
+/* DMA registers */
+#define SAR	0x00	/* Source Address Register */
+#define DAR	0x04	/* Destination Address Register */
+#define TCR	0x08	/* Transfer Count Register */
+#define CHCR	0x0C	/* Channel Control Register */
+#define DMAOR	0x40	/* DMA Operation Register */
 
 /* DMAOR definitions */
-#define DMAOR_AE	0x00000004
+#define DMAOR_AE	0x00000004	/* Address Error Flag */
 #define DMAOR_NMIF	0x00000002
-#define DMAOR_DME	0x00000001
+#define DMAOR_DME	0x00000001	/* DMA Master Enable */
 
 /* Definitions for the SuperH DMAC */
 #define REQ_L	0x00000000
@@ -34,18 +34,20 @@
 #define ACK_W	0x00020000
 #define ACK_H	0x00000000
 #define ACK_L	0x00010000
-#define DM_INC	0x00004000
-#define DM_DEC	0x00008000
-#define DM_FIX	0x0000c000
-#define SM_INC	0x00001000
-#define SM_DEC	0x00002000
-#define SM_FIX	0x00003000
+#define DM_INC	0x00004000	/* Destination addresses are incremented */
+#define DM_DEC	0x00008000	/* Destination addresses are decremented */
+#define DM_FIX	0x0000c000	/* Destination address is fixed */
+#define SM_INC	0x00001000	/* Source addresses are incremented */
+#define SM_DEC	0x00002000	/* Source addresses are decremented */
+#define SM_FIX	0x00003000	/* Source address is fixed */
 #define RS_IN	0x00000200
 #define RS_OUT	0x00000300
+#define RS_AUTO	0x00000400	/* Auto Request */
+#define RS_ERS	0x00000800	/* DMA extended resource selector */
 #define TS_BLK	0x00000040
 #define TM_BUR	0x00000020
-#define CHCR_DE	0x00000001
-#define CHCR_TE	0x00000002
-#define CHCR_IE	0x00000004
+#define CHCR_DE	0x00000001	/* DMA Enable */
+#define CHCR_TE	0x00000002	/* Transfer End Flag */
+#define CHCR_IE	0x00000004	/* Interrupt Enable */
 
 #endif
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 146d5df926db..1a6f6595c6c1 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -38,12 +38,12 @@
 #include "../dmaengine.h"
 #include "shdma.h"
 
-/* DMA register */
-#define SAR	0x00
-#define DAR	0x04
-#define TCR	0x08
-#define CHCR	0x0C
-#define DMAOR	0x40
+/* DMA registers */
+#define SAR	0x00	/* Source Address Register */
+#define DAR	0x04	/* Destination Address Register */
+#define TCR	0x08	/* Transfer Count Register */
+#define CHCR	0x0C	/* Channel Control Register */
+#define DMAOR	0x40	/* DMA Operation Register */
 
 #define TEND	0x18 /* USB-DMAC */
 
diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index b7b43b82231e..56b97eed28a4 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -95,19 +95,21 @@ struct sh_dmae_pdata {
 };
 
 /* DMAOR definitions */
-#define DMAOR_AE	0x00000004
+#define DMAOR_AE	0x00000004	/* Address Error Flag */
 #define DMAOR_NMIF	0x00000002
-#define DMAOR_DME	0x00000001
+#define DMAOR_DME	0x00000001	/* DMA Master Enable */
 
 /* Definitions for the SuperH DMAC */
-#define DM_INC	0x00004000
-#define DM_DEC	0x00008000
-#define DM_FIX	0x0000c000
-#define SM_INC	0x00001000
-#define SM_DEC	0x00002000
-#define SM_FIX	0x00003000
-#define CHCR_DE	0x00000001
-#define CHCR_TE	0x00000002
-#define CHCR_IE	0x00000004
+#define DM_INC	0x00004000	/* Destination addresses are incremented */
+#define DM_DEC	0x00008000	/* Destination addresses are decremented */
+#define DM_FIX	0x0000c000	/* Destination address is fixed */
+#define SM_INC	0x00001000	/* Source addresses are incremented */
+#define SM_DEC	0x00002000	/* Source addresses are decremented */
+#define SM_FIX	0x00003000	/* Source address is fixed */
+#define RS_AUTO	0x00000400	/* Auto Request */
+#define RS_ERS	0x00000800	/* DMA extended resource selector */
+#define CHCR_DE	0x00000001	/* DMA Enable */
+#define CHCR_TE	0x00000002	/* Transfer End Flag */
+#define CHCR_IE	0x00000004	/* Interrupt Enable */
 
 #endif
-- 
1.9.1

