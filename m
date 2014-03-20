Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933949AbaCTO64 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:58:56 -0400
Received: from [213.199.154.207] ([213.199.154.207]:55403 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933061AbaCTO6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:58:54 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1de2h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Suresh Gupta <suresh.gupta@freescale.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Suresh Gupta <suresh.gupta@freescale.com>
Subject: [PATCH v2] USB: Gadget: fsl driver pullup fix
Date: Fri, 21 Mar 2014 01:57:18 +0530
Message-ID: <1395347238-22518-1-git-send-email-suresh.gupta@freescale.com>
X-Mailer: git-send-email 1.8.4.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix the fsl usb gadget driver in a way that the usb device
will be only "pulled up" on requests only when vbus is powered

Signed-off-by: Suresh Gupta <suresh.gupta@freescale.com>
---
Changes from previous version:
* Removed re-factored code, Will send another patch for re-factoring
  duplicated code
* Changed Description 

 drivers/usb/gadget/fsl_udc_core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/fsl_udc_core.c b/drivers/usb/gadget/fsl_udc_core.c
index 35cb972..49d66779 100644
--- a/drivers/usb/gadget/fsl_udc_core.c
+++ b/drivers/usb/gadget/fsl_udc_core.c
@@ -1219,6 +1219,10 @@ static int fsl_pullup(struct usb_gadget *gadget, int is_on)
 	struct fsl_udc *udc;
 
 	udc = container_of(gadget, struct fsl_udc, gadget);
+
+	if(!udc->vbus_active)
+		return -EOPNOTSUPP;
+
 	udc->softconnect = (is_on != 0);
 	if (can_pullup(udc))
 		fsl_writel((fsl_readl(&dr_regs->usbcmd) | USB_CMD_RUN_STOP),
-- 
1.8.4.1


