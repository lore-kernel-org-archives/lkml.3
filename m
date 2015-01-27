Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbbA0MTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:19:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35249 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758622AbbA0MTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:01 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bo Shen <voice.shen@atmel.com>, Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 077/126] usb: gadget: udc: atmel: change setting for DMA
Date: Tue, 27 Jan 2015 12:16:22 +0000
Message-Id: <1422361031-19364-78-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.16:
  - file rename: drivers/usb/gadget/udc/atmel_usba_udc.c ->
    drivers/usb/gadget/atmel_usba_udc.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/atmel_usba_udc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 76023ce449a3..9fff23fa1519 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
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
2.1.4

