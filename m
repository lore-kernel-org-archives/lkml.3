Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaK1Nz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:55:26 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34900 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaK1NvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:12 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/17] net2280: Remove dma_started field
Date: Fri, 28 Nov 2014 14:50:50 +0100
Message-Id: <1417182662-7405-6-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dma_started field from net2280_ep structure, since it is not used
by any function.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 4 ----
 drivers/usb/gadget/udc/net2280.h | 2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index 230b8d4..0340462 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -834,16 +834,12 @@ static void start_dma(struct net2280_ep *ep, struct net2280_request *req)
 static inline void resume_dma(struct net2280_ep *ep)
 {
 	writel(readl(&ep->dma->dmactl) | BIT(DMA_ENABLE), &ep->dma->dmactl);
-
-	ep->dma_started = true;
 }
 
 static inline void ep_stop_dma(struct net2280_ep *ep)
 {
 	writel(readl(&ep->dma->dmactl) & ~BIT(DMA_ENABLE), &ep->dma->dmactl);
 	spin_stop_dma(ep->dma);
-
-	ep->dma_started = false;
 }
 
 static inline void
diff --git a/drivers/usb/gadget/udc/net2280.h b/drivers/usb/gadget/udc/net2280.h
index 03f1524..4c53b83 100644
--- a/drivers/usb/gadget/udc/net2280.h
+++ b/drivers/usb/gadget/udc/net2280.h
@@ -100,7 +100,7 @@ struct net2280_ep {
 	dma_addr_t				td_dma;	/* of dummy */
 	struct net2280				*dev;
 	unsigned long				irqs;
-	unsigned is_halt:1, dma_started:1;
+	unsigned is_halt:1;
 
 	/* analogous to a host-side qh */
 	struct list_head			queue;
-- 
2.1.3

