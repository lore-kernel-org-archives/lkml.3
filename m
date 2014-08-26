Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbaHZQAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 12:00:30 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:52930 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaHZQA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 12:00:28 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v2] usb: gadget: net2280: Fix invalid handling of Reset irq
Date: Tue, 26 Aug 2014 18:00:19 +0200
Message-Id: <1409068819-11273-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch, some hosts keep restarting indefinitely the target.

Fixes: ae8e530 (usb: gadget: net2280: Code Cleanup)
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---

v2: Request by Felipe Balbi

Use Fixes: on commit message

 drivers/usb/gadget/udc/net2280.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index f4eac11..2e95715 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -3320,7 +3320,7 @@ static void handle_stat1_irqs(struct net2280 *dev, u32 stat)
 	if (stat & tmp) {
 		writel(tmp, &dev->regs->irqstat1);
 		if ((((stat & BIT(ROOT_PORT_RESET_INTERRUPT)) &&
-				(readl(&dev->usb->usbstat) & mask)) ||
+				((readl(&dev->usb->usbstat) & mask) == 0)) ||
 				((readl(&dev->usb->usbctl) &
 					BIT(VBUS_PIN)) == 0)) &&
 				(dev->gadget.speed != USB_SPEED_UNKNOWN)) {
-- 
2.1.0

