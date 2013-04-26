Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3DZLj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 07:39:59 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:60358 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3DZLj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 07:39:58 -0400
Date: Fri, 26 Apr 2013 12:39:47 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 03/32 v4] dmaengine: ste_dma40: Use the BIT macro to replace
 ugly '(1 << x)'s
Message-ID: <20130426113947.GB31899@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aim is to make the code that little more readable.
    
Acked-by: Vinod Koul <vnod.koul@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index d7e926d..78511ef 100644
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
 
 #define D40_IS_SRC(dir)  (dir == STEDMA40_PERIPH_TO_MEM)
@@ -1728,7 +1728,7 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 		}
 
 		/* ACK interrupt */
-		writel(1 << idx, base->virtbase + il[row].clr);
+		writel(BIT(idx), base->virtbase + il[row].clr);
 
 		spin_lock(&d40c->lock);
 
@@ -1818,8 +1818,8 @@ static bool d40_alloc_mask_set(struct d40_phy_res *phy,
 		if (phy->allocated_src == D40_ALLOC_FREE)
 			phy->allocated_src = D40_ALLOC_LOG_FREE;
 
-		if (!(phy->allocated_src & (1 << log_event_line))) {
-			phy->allocated_src |= 1 << log_event_line;
+		if (!(phy->allocated_src & BIT(log_event_line))) {
+			phy->allocated_src |= BIT(log_event_line);
 			goto found;
 		} else
 			goto not_found;
@@ -1830,8 +1830,8 @@ static bool d40_alloc_mask_set(struct d40_phy_res *phy,
 		if (phy->allocated_dst == D40_ALLOC_FREE)
 			phy->allocated_dst = D40_ALLOC_LOG_FREE;
 
-		if (!(phy->allocated_dst & (1 << log_event_line))) {
-			phy->allocated_dst |= 1 << log_event_line;
+		if (!(phy->allocated_dst & BIT(log_event_line))) {
+			phy->allocated_dst |= BIT(log_event_line);
 			goto found;
 		} else
 			goto not_found;
@@ -1861,11 +1861,11 @@ static bool d40_alloc_mask_free(struct d40_phy_res *phy, bool is_src,
 
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
@@ -2333,7 +2333,7 @@ static void __d40_set_prio_rt(struct d40_chan *d40c, int dev_type, bool src)
 	u32 rtreg;
 	u32 event = D40_TYPE_TO_EVENT(dev_type);
 	u32 group = D40_TYPE_TO_GROUP(dev_type);
-	u32 bit = 1 << event;
+	u32 bit = BIT(event);
 	u32 prioreg;
 	struct d40_gen_dmac *dmac = &d40c->base->gen_dmac;
