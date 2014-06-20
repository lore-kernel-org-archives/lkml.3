Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967504AbaFTMiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 08:38:20 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:57114 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967289AbaFTMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 08:37:46 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-sh@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 4/4] dmaengine: shdma: Use defines instead of hardcoded numbers
Date: Fri, 20 Jun 2014 14:37:41 +0200
Message-Id: <1403267861-15609-5-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403267861-15609-1-git-send-email-geert+renesas@glider.be>
References: <1403267861-15609-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/dma/sh/shdma-arm.h | 4 ++--
 drivers/dma/sh/shdmac.c    | 3 +--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/sh/shdma-arm.h b/drivers/dma/sh/shdma-arm.h
index a2b8258426c9..a1b0ef45d6a2 100644
--- a/drivers/dma/sh/shdma-arm.h
+++ b/drivers/dma/sh/shdma-arm.h
@@ -45,7 +45,7 @@ enum {
 	((((i) & TS_LOW_BIT) << TS_LOW_SHIFT) |\
 	 (((i) & TS_HI_BIT)  << TS_HI_SHIFT))
 
-#define CHCR_TX(xmit_sz) (DM_FIX | SM_INC | 0x800 | TS_INDEX2VAL((xmit_sz)))
-#define CHCR_RX(xmit_sz) (DM_INC | SM_FIX | 0x800 | TS_INDEX2VAL((xmit_sz)))
+#define CHCR_TX(xmit_sz) (DM_FIX | SM_INC | RS_ERS | TS_INDEX2VAL((xmit_sz)))
+#define CHCR_RX(xmit_sz) (DM_INC | SM_FIX | RS_ERS | TS_INDEX2VAL((xmit_sz)))
 
 #endif
diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
index 1a6f6595c6c1..58eb85770eba 100644
--- a/drivers/dma/sh/shdmac.c
+++ b/drivers/dma/sh/shdmac.c
@@ -239,9 +239,8 @@ static void dmae_init(struct sh_dmae_chan *sh_chan)
 {
 	/*
 	 * Default configuration for dual address memory-memory transfer.
-	 * 0x400 represents auto-request.
 	 */
-	u32 chcr = DM_INC | SM_INC | 0x400 | log2size_to_chcr(sh_chan,
+	u32 chcr = DM_INC | SM_INC | RS_AUTO | log2size_to_chcr(sh_chan,
 						   LOG2_DEFAULT_XFER_SIZE);
 	sh_chan->xmit_shift = calc_xmit_shift(sh_chan, chcr);
 	chcr_write(sh_chan, chcr);
-- 
1.9.1

