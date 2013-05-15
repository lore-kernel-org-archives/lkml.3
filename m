Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab3EOMEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:04:14 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:35106 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926Ab3EOMEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:04:11 -0400
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        Praveena Nadahally <praveen.nadahally@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 02/10] usb: musb: various cosmetic fixes on ux500 files
Date: Wed, 15 May 2013 14:03:25 +0200
Message-Id: <1368619413-24647-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
References: <1368619413-24647-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various non functional coding style fixes on ux500_dma.c and
phy-ab8500-usb.c drivers.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/musb/ux500_dma.c     | 6 +++---
 drivers/usb/phy/phy-ab8500-usb.c | 9 +++++----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
index 3381206..63e7c8a 100644
--- a/drivers/usb/musb/ux500_dma.c
+++ b/drivers/usb/musb/ux500_dma.c
@@ -71,8 +71,7 @@ static void ux500_dma_callback(void *private_data)
 	spin_lock_irqsave(&musb->lock, flags);
 	ux500_channel->channel.actual_len = ux500_channel->cur_len;
 	ux500_channel->channel.status = MUSB_DMA_STATUS_FREE;
-	musb_dma_completion(musb, hw_ep->epnum,
-		ux500_channel->is_tx);
+	musb_dma_completion(musb, hw_ep->epnum, ux500_channel->is_tx);
 	spin_unlock_irqrestore(&musb->lock, flags);
 
 }
@@ -366,7 +365,8 @@ void dma_controller_destroy(struct dma_controller *c)
 	kfree(controller);
 }
 
-struct dma_controller *dma_controller_create(struct musb *musb, void __iomem *base)
+struct dma_controller *dma_controller_create(struct musb *musb,
+					void __iomem *base)
 {
 	struct ux500_dma_controller *controller;
 	struct platform_device *pdev = to_platform_device(musb->controller);
diff --git a/drivers/usb/phy/phy-ab8500-usb.c b/drivers/usb/phy/phy-ab8500-usb.c
index 4acef26..b043faa 100644
--- a/drivers/usb/phy/phy-ab8500-usb.c
+++ b/drivers/usb/phy/phy-ab8500-usb.c
@@ -286,7 +286,8 @@ static void ab8500_usb_phy_disable(struct ab8500_usb *ab, bool sel_host)
 		else if (pinctrl_select_state(ab->pinctrl, ab->pins_sleep))
 			dev_err(ab->dev, "could not set pins to sleep state\n");
 
-		/* as USB pins are shared with idddet, release them to allow
+		/*
+		 * as USB pins are shared with iddet, release them to allow
 		 * iddet to request them
 		 */
 		pinctrl_put(ab->pinctrl);
@@ -553,7 +554,7 @@ static irqreturn_t ab8500_usb_disconnect_irq(int irq, void *data)
 
 static irqreturn_t ab8500_usb_link_status_irq(int irq, void *data)
 {
-	struct ab8500_usb *ab = (struct ab8500_usb *) data;
+	struct ab8500_usb *ab = (struct ab8500_usb *)data;
 
 	abx500_usb_link_status_update(ab);
 
@@ -627,7 +628,7 @@ static int ab8500_usb_set_peripheral(struct usb_otg *otg,
 	 * is fixed.
 	 */
 
-	if ((ab->mode != USB_IDLE) && (!gadget)) {
+	if ((ab->mode != USB_IDLE) && !gadget) {
 		ab->mode = USB_IDLE;
 		schedule_work(&ab->phy_dis_work);
 	}
@@ -651,7 +652,7 @@ static int ab8500_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
 	 * is fixed.
 	 */
 
-	if ((ab->mode != USB_IDLE) && (!host)) {
+	if ((ab->mode != USB_IDLE) && !host) {
 		ab->mode = USB_IDLE;
 		schedule_work(&ab->phy_dis_work);
 	}
-- 
1.8.2

