Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbaCLQaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:30:13 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:38708 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaCLQaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:30:11 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <balbi@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <jjhiblot@traphandler.com>, <b.brezillon@overkiz.com>,
        stable <stable@vger.kernel.org>
Subject: [PATCH RESEND] usb: at91-udc: fix irq and iomem resource retrieval
Date: Wed, 12 Mar 2014 17:30:08 +0100
Message-ID: <1394641808-27919-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1390488102-8548-1-git-send-email-jjhiblot@traphandler.com>
References: <1390488102-8548-1-git-send-email-jjhiblot@traphandler.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

When using dt resources retrieval (interrupts and reg properties) there is
no predefined order for these resources in the platform dev resource
table. Also don't expect the number of resource to be always 2.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: stable <stable@vger.kernel.org> # 3.4
---
 drivers/usb/gadget/at91_udc.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index cea8c20a1425..1926925a52a9 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1709,16 +1709,6 @@ static int at91udc_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if (pdev->num_resources != 2) {
-		DBG("invalid num_resources\n");
-		return -ENODEV;
-	}
-	if ((pdev->resource[0].flags != IORESOURCE_MEM)
-			|| (pdev->resource[1].flags != IORESOURCE_IRQ)) {
-		DBG("invalid resource type\n");
-		return -ENODEV;
-	}
-
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENXIO;
-- 
1.8.2.2

