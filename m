Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbaFDXoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:44:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40722 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbaFDXXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris BREZILLON <b.brezillon@overkiz.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.10 035/103] usb: gadget: at91-udc: fix irq and iomem resource retrieval
Date: Wed,  4 Jun 2014 16:24:58 -0700
Message-Id: <20140604232548.004163091@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>

commit 886c7c426d465732ec9d1b2bbdda5642fc2e7e05 upstream.

When using dt resources retrieval (interrupts and reg properties) there is
no predefined order for these resources in the platform dev resource
table. Also don't expect the number of resource to be always 2.

Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/at91_udc.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1703,16 +1703,6 @@ static int at91udc_probe(struct platform
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


