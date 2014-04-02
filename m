Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbaDBL1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 07:27:09 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:40203
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758226AbaDBL1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 07:27:08 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1de2h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h268bh26d3h1155h)
From: Suresh Gupta <suresh.gupta@freescale.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Suresh Gupta <suresh.gupta@freescale.com>
Subject: [PATCH] USB : Gadget : fsl: Fix the fault issue on rmmod
Date: Wed, 2 Apr 2014 22:26:46 +0530
Message-ID: <1396457806-22061-1-git-send-email-suresh.gupta@freescale.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

completion in udc_controller->done should be assign with proper
value before complete called. The complete called in fsl_udc_release
which intern called from usb_del_gadget_udc, so moving assignment
before calling usb_del_gadget_udc

Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
---
 drivers/usb/gadget/fsl_udc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 5a0f89c..e55d04f 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -2537,8 +2537,8 @@ static int __exit fsl_udc_remove(struct platform_device *pdev)
 	if (!udc_controller)
 		return -ENODEV;
 
-	usb_del_gadget_udc(&udc_controller->gadget);
 	udc_controller->done = &done;
+	usb_del_gadget_udc(&udc_controller->gadget);
 
 	fsl_udc_clk_release();
 
-- 
1.8.4.1


