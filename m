Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964780AbaCTO6h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:58:37 -0400
Received: from [216.32.181.181] ([216.32.181.181]:52577 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933061AbaCTO6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:58:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551bizzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1de2h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Suresh Gupta <suresh.gupta@freescale.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Suresh Gupta <B42813@freescale.com>
Subject: [PATCH v2] usb: gadget: fsl: Set dma_ops for FSL USB Gadget Device
Date: Fri, 21 Mar 2014 01:56:49 +0530
Message-ID: <1395347209-22480-1-git-send-email-suresh.gupta@freescale.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Gupta <B42813@freescale.com>

DMA mapping functions are moved to common place in udc_core.c
which expect the DMA operation of gadget device

Signed-off-by: Suresh Gupta <B42813@freescale.com>
---
Changes from previous version:
* Added description

 drivers/usb/gadget/fsl_udc_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index d68aa77..35cb972 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2456,6 +2456,7 @@ static int __init fsl_udc_probe(struct platform_device *pdev)
 	/* Setup gadget.dev and register with kernel */
 	dev_set_name(&udc_controller->gadget.dev, "gadget");
 	udc_controller->gadget.dev.of_node = pdev->dev.of_node;
+	set_dma_ops(&udc_controller->gadget.dev, pdev->dev.archdata.dma_ops);
 
 	if (!IS_ERR_OR_NULL(udc_controller->transceiver))
 		udc_controller->gadget.is_otg = 1;
-- 
1.8.4.1


