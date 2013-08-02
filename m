Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837Ab3HBOvF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:51:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61372 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766Ab3HBOux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:50:53 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Simon Horman <horms@verge.net.au>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH v5 2/7] DMA: shdma: remove private and unused defines from a global header
Date: Fri,  2 Aug 2013 16:50:37 +0200
Message-Id: <1375455042-24093-3-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
References: <1375455042-24093-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:XLQb/IcJugbeKOAtYQ6N/NfWF3o18Ss+Z8RZOl/APV/
 lkkI6ES/h+ee2CzZH6CYQmoSZ9wkd1hn6pgO0jvcDokwl/q9tl
 s/Niy94bURcMUx8RWsstoTxg/KDv9ew2/Yga7ejCrIxPLzhdbd
 E/tyb8R5gkPnEixa3HE7gCwrFzkEEa0NwsZ7i1rPOrHJR2Z9Z9
 zOmHUb/iukL96rnq++25OH3A41wDU369f6BI2+m7M/87a9W4w0
 oZsVtC7/Y6M1idYUFF9slf6nswCB7/FDK++HUlV1qkcP+awbzD
 xkrOiOy7Q/0j/p7q3Gkb7OMlQDxHAFn23P642wtj8tdFeGqg9a
 zv3LECnqqEYZIMfj58Ie7lCSNKalFVleeyA+4rS1z4PltQjW9f
 019+GD5ZOuJbg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Macros, named like TEND or SAR lack a namespace and are too broadly named
for a global header. Besides, they aren't needed globally. Move them to
where they belong - into the driver. Some other macros aren't used at all,
remove them.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/dma/sh/shdmac.c |    9 +++++++++
 include/linux/sh_dma.h  |   21 ---------------------
 2 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 7a01faa..4412cad 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -37,6 +37,15 @@
 #include "../dmaengine.h"
 #include "shdma.h"
 
+/* DMA register */
+#define SAR	0x00
+#define DAR	0x04
+#define TCR	0x08
+#define CHCR	0x0C
+#define DMAOR	0x40
+
+#define TEND	0x18 /* USB-DMAC */
+
 #define SH_DMAE_DRV_NAME "sh-dma-engine"
 
 /* Default MEMCPY transfer size = 2^2 = 4 bytes */
diff --git a/include/linux/sh_dma.h b/include/linux/sh_dma.h
index 776ed9d..b7b43b8 100644
--- a/include/linux/sh_dma.h
+++ b/include/linux/sh_dma.h
@@ -94,39 +94,18 @@ struct sh_dmae_pdata {
 	unsigned int slave_only:1;
 };
 
-/* DMA register */
-#define SAR	0x00
-#define DAR	0x04
-#define TCR	0x08
-#define CHCR	0x0C
-#define DMAOR	0x40
-
-#define TEND	0x18 /* USB-DMAC */
-
 /* DMAOR definitions */
 #define DMAOR_AE	0x00000004
 #define DMAOR_NMIF	0x00000002
 #define DMAOR_DME	0x00000001
 
 /* Definitions for the SuperH DMAC */
-#define REQ_L	0x00000000
-#define REQ_E	0x00080000
-#define RACK_H	0x00000000
-#define RACK_L	0x00040000
-#define ACK_R	0x00000000
-#define ACK_W	0x00020000
-#define ACK_H	0x00000000
-#define ACK_L	0x00010000
 #define DM_INC	0x00004000
 #define DM_DEC	0x00008000
 #define DM_FIX	0x0000c000
 #define SM_INC	0x00001000
 #define SM_DEC	0x00002000
 #define SM_FIX	0x00003000
-#define RS_IN	0x00000200
-#define RS_OUT	0x00000300
-#define TS_BLK	0x00000040
-#define TM_BUR	0x00000020
 #define CHCR_DE	0x00000001
 #define CHCR_TE	0x00000002
 #define CHCR_IE	0x00000004
-- 
1.7.2.5

