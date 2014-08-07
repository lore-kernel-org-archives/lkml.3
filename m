Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492AbaHGDnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 23:43:23 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:24992 "EHLO
	DVREDG01.corp.atmel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754342AbaHGDnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 23:43:21 -0400
From: Bo Shen <voice.shen@atmel.com>
To: Felipe Balbi <balbi@ti.com>
CC: <nicolas.ferre@atmel.com>, <liaops@embest-tech.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Bo Shen <voice.shen@atmel.com>
Subject: [PATCH] USB: atmel_usba_udc: fix it to deal with final DMA channel
Date: Thu, 7 Aug 2014 11:43:07 +0800
Message-ID: <1407382987-11242-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As, the interrupt for DMA is counted from 1, so need to checked
the USBA_NR_DMAS, in old way, it only check (USBA_NR_DMAS - 1),
so fix it.

Reported-by: Max Liao <liaops@embest-tech.com>
Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 drivers/usb/gadget/udc/atmel_usba_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/atmel_usba_udc.c b/drivers/usb/gadget/udc/atmel_usba_udc.c
index 906e65f..c9fe67e 100644
--- a/drivers/usb/gadget/udc/atmel_usba_udc.c
+++ b/drivers/usb/gadget/udc/atmel_usba_udc.c
@@ -1661,7 +1661,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 	if (dma_status) {
 		int i;
 
-		for (i = 1; i < USBA_NR_DMAS; i++)
+		for (i = 1; i <= USBA_NR_DMAS; i++)
 			if (dma_status & (1 << i))
 				usba_dma_irq(udc, &udc->usba_ep[i]);
 	}
-- 
1.8.5.2

