Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756931Ab3FAJg7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:36:59 -0400
Received: from www17.your-server.de ([213.133.104.17]:58462 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756771Ab3FAJgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:36:51 -0400
Message-ID: <1370079406.29224.1.camel@localhost.localdomain>
Subject: [PATCH] usb: gadget: lpc32xx_udc: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: balbi@ti.com, grant.likely@linaro.org, rob.herring@calxeda.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:36:46 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/usb/gadget/lpc32xx_udc.c b/drivers/usb/gadget/lpc32xx_udc.c
--- a/drivers/usb/gadget/lpc32xx_udc.c
+++ b/drivers/usb/gadget/lpc32xx_udc.c
@@ -3046,11 +3046,10 @@ static int __init lpc32xx_udc_probe(stru
 	dma_addr_t dma_handle;
 	struct device_node *isp1301_node;
 
-	udc = kzalloc(sizeof(*udc), GFP_KERNEL);
+	udc = kmemdup(&controller_template, sizeof(*udc), GFP_KERNEL);
 	if (!udc)
 		return -ENOMEM;
 
-	memcpy(udc, &controller_template, sizeof(*udc));
 	for (i = 0; i <= 15; i++)
 		udc->ep[i].udc = udc;
 	udc->gadget.ep0 = &udc->ep[0].ep;


