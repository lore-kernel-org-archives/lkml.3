Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbbAYSWE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:22:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150AbbAYSKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Bo Shen <voice.shen@atmel.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.18 148/183] usb: gadget: udc: atmel: change setting for DMA
Date: Sun, 25 Jan 2015 10:07:50 -0800
Message-Id: <20150125180816.612712749@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bo Shen <voice.shen@atmel.com>

commit f40afdddeb6c54ffd1e2920a5e93e363d6748db6 upstream.

According to the datasheet, when transfer using DMA, the control
setting for IN packet only need END_BUF_EN, END_BUF_IE, CH_EN,
while for OUT packet, need more two bits END_TR_EN and END_TR_IE
to be configured.

Fixes: 914a3f3b3754 (USB: add atmel_usba_udc driver)
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Bo Shen <voice.shen@atmel.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc/atmel_usba_udc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -716,10 +716,10 @@ static int queue_dma(struct usba_udc *ud
 	req->using_dma = 1;
 	req->ctrl = USBA_BF(DMA_BUF_LEN, req->req.length)
 			| USBA_DMA_CH_EN | USBA_DMA_END_BUF_IE
-			| USBA_DMA_END_TR_EN | USBA_DMA_END_TR_IE;
+			| USBA_DMA_END_BUF_EN;
 
-	if (ep->is_in)
-		req->ctrl |= USBA_DMA_END_BUF_EN;
+	if (!ep->is_in)
+		req->ctrl |= USBA_DMA_END_TR_EN | USBA_DMA_END_TR_IE;
 
 	/*
 	 * Add this request to the queue and submit for DMA if


