Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaKSJTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:19:21 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:32666 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750757AbaKSJTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:19:19 -0500
From: Bo Shen <voice.shen@atmel.com>
To: Felipe Balbi <balbi@ti.com>
CC: <nicolas.ferre@atmel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 1/2] usb: gadget: at91_udc: remove unused release function
Date: Wed, 19 Nov 2014 17:19:05 +0800
Message-ID: <1416388746-7386-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the driver call usb_add_gadget_udc --> usb_add_gadget_udc_release
with NULL as release parameter, so it will use usb_udc_no_release.
So, the release in driver won't used, remove it.

And at the same time, in the usb_add_gadget_udc_release will set the
gadget name, so remove it also in driver.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---
 drivers/usb/gadget/udc/at91_udc.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/usb/gadget/udc/at91_udc.c b/drivers/usb/gadget/udc/at91_udc.c
index 9968f53..b179ab1 100644
--- a/drivers/usb/gadget/udc/at91_udc.c
+++ b/drivers/usb/gadget/udc/at91_udc.c
@@ -1512,20 +1512,11 @@ static irqreturn_t at91_udc_irq (int irq, void *_udc)
 
 /*-------------------------------------------------------------------------*/
 
-static void nop_release(struct device *dev)
-{
-	/* nothing to free */
-}
-
 static struct at91_udc controller = {
 	.gadget = {
 		.ops	= &at91_udc_ops,
 		.ep0	= &controller.ep[0].ep,
 		.name	= driver_name,
-		.dev	= {
-			.init_name = "gadget",
-			.release = nop_release,
-		}
 	},
 	.ep[0] = {
 		.ep = {
-- 
2.1.0.24.g4109c28

