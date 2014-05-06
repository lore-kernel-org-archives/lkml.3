Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbaEFPQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:16:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52165 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754361AbaEFPQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:16:20 -0400
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] usb: gadget: atmel_usba: always test udc->driver
Date: Tue,  6 May 2014 17:16:07 +0200
Message-Id: <1399389367-15456-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found using smatch: drivers/usb/gadget/atmel_usba_udc.c:1689 usba_udc_irq()
error: we previously assumed 'udc->driver' could be null (see line 1636)

Always test udc->driver before using its members.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 drivers/usb/gadget/atmel_usba_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 9f65324f9ae0..76023ce449a3 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1686,7 +1686,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 		reset_all_endpoints(udc);
 
 		if (udc->gadget.speed != USB_SPEED_UNKNOWN
-				&& udc->driver->disconnect) {
+				&& udc->driver && udc->driver->disconnect) {
 			udc->gadget.speed = USB_SPEED_UNKNOWN;
 			spin_unlock(&udc->lock);
 			udc->driver->disconnect(&udc->gadget);
-- 
1.9.1

