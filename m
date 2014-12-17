Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaLQJTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 04:19:05 -0500
Received: from nasmtp01.atmel.com ([192.199.1.245]:27427 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbaLQJTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 04:19:03 -0500
From: Bo Shen <voice.shen@atmel.com>
To: <balbi@ti.com>, <nicolas.ferre@atmel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH 1/2] USB: gadget: udc: atmel: change setting for DMA
Date: Wed, 17 Dec 2014 17:18:48 +0800
Message-ID: <1418807929-31952-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 2.1.0.24.g4109c28
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet, when transfer using DMA, the control
setting for IN packet only need END_BUF_EN, END_BUF_IE, CH_EN,
while for OUT packet, need more two bits END_TR_EN and END_TR_IE
to be configured.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 drivers/usb/gadget/udc/atmel_usba_udc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
index ce88237..63e90f5 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -716,10 +716,10 @@ static int queue_dma(struct usba_udc *udc, struct usba_ep *ep,
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
-- 
2.1.0.24.g4109c28

