Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab3EOJxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:53:10 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:48317 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932703Ab3EOJxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:53:05 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 29/39] dmaengine: ste_dma40: Use the BIT macro to replace ugly '(1 << x)'s
Date: Wed, 15 May 2013 10:51:52 +0100
Message-Id: <1368611522-9984-30-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aim is to make the code that little more readable.

Acked-by: Vinod Koul <vnod.koul@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 6ed7757..08bc58a 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -54,8 +54,8 @@
 #define MAX_LCLA_ALLOC_ATTEMPTS 256
 
 /* Bit markings for allocation map */
-#define D40_ALLOC_FREE		(1 << 31)
-#define D40_ALLOC_PHY		(1 << 30)
+#define D40_ALLOC_FREE		BIT(31)
+#define D40_ALLOC_PHY		BIT(30)
 #define D40_ALLOC_LOG_FREE	0
 
 /* Reserved event lines for memcpy only. */
@@ -1738,7 +1738,7 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 		}
 
 		/* ACK interrupt */
-		writel(1 << idx, base->virtbase + il[row].clr);
+		writel(BIT(idx), base->virtbase + il[row].clr);
 
 		spin_lock(&d40c->lock);
 
@@ -1828,8 +1828,8 @@ static bool d40_alloc_mask_set(struct d40_phy_res *phy,
 		if (phy->allocated_src == D40_ALLOC_FREE)
 			phy->allocated_src = D40_ALLOC_LOG_FREE;
 
-		if (!(phy->allocated_src & (1 << log_event_line))) {
-			phy->allocated_src |= 1 << log_event_line;
+		if (!(phy->allocated_src & BIT(log_event_line))) {
+			phy->allocated_src |= BIT(log_event_line);
 			goto found;
 		} else
 			goto not_found;
@@ -1840,8 +1840,8 @@ static bool d40_alloc_mask_set(struct d40_phy_res *phy,
 		if (phy->allocated_dst == D40_ALLOC_FREE)
 			phy->allocated_dst = D40_ALLOC_LOG_FREE;
 
-		if (!(phy->allocated_dst & (1 << log_event_line))) {
-			phy->allocated_dst |= 1 << log_event_line;
+		if (!(phy->allocated_dst & BIT(log_event_line))) {
+			phy->allocated_dst |= BIT(log_event_line);
 			goto found;
 		} else
 			goto not_found;
@@ -1871,11 +1871,11 @@ static bool d40_alloc_mask_free(struct d40_phy_res *phy, bool is_src,
 
 	/* Logical channel */
 	if (is_src) {
-		phy->allocated_src &= ~(1 << log_event_line);
+		phy->allocated_src &= ~BIT(log_event_line);
 		if (phy->allocated_src == D40_ALLOC_LOG_FREE)
 			phy->allocated_src = D40_ALLOC_FREE;
 	} else {
-		phy->allocated_dst &= ~(1 << log_event_line);
+		phy->allocated_dst &= ~BIT(log_event_line);
 		if (phy->allocated_dst == D40_ALLOC_LOG_FREE)
 			phy->allocated_dst = D40_ALLOC_FREE;
 	}
@@ -2356,7 +2356,7 @@ static void __d40_set_prio_rt(struct d40_chan *d40c, int dev_type, bool src)
 	u32 rtreg;
 	u32 event = D40_TYPE_TO_EVENT(dev_type);
 	u32 group = D40_TYPE_TO_GROUP(dev_type);
-	u32 bit = 1 << event;
+	u32 bit = BIT(event);
 	u32 prioreg;
 	struct d40_gen_dmac *dmac = &d40c->base->gen_dmac;
 
-- 
1.7.10.4

