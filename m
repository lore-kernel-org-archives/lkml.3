Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaAQDAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:00:05 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:45477 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983AbaAQDAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:00:03 -0500
From: Bo Shen <voice.shen@atmel.com>
To: Felipe Balbi <balbi@ti.com>
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        Bo Shen <voice.shen@atmel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] USB: at91: fix the number of endpoint parameter
Date: Fri, 17 Jan 2014 10:59:24 +0800
Message-Id: <1389927565-22477-1-git-send-email-voice.shen@atmel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sama5d3 SoC, there are 16 endpoints. As the USBA_NR_ENDPOINTS
is only 7. So, fix it for sama5d3 SoC using the udc->num_ep.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
---

 drivers/usb/gadget/atmel_usba_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/atmel_usba_udc.c b/drivers/usb/gadget/atmel_usba_udc.c
index 2cb52e0..7e67a81 100644
--- a/drivers/usb/gadget/atmel_usba_udc.c
+++ b/drivers/usb/gadget/atmel_usba_udc.c
@@ -1670,7 +1670,7 @@ static irqreturn_t usba_udc_irq(int irq, void *devid)
 	if (ep_status) {
 		int i;
 
-		for (i = 0; i < USBA_NR_ENDPOINTS; i++)
+		for (i = 0; i < udc->num_ep; i++)
 			if (ep_status & (1 << i)) {
 				if (ep_is_control(&udc->usba_ep[i]))
 					usba_control_irq(udc, &udc->usba_ep[i]);
-- 
1.8.5.2

