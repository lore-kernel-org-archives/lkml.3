Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756011Ab3GAWyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:54:10 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.112]:12598 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100Ab3GAWyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:54:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-3.tower-209.messagelabs.com!1372719247!5804240!3
X-Originating-IP: [216.166.12.32]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 2/4] usb: ohci-ep93xx: use platform_get_irq()
Date: Mon, 1 Jul 2013 15:52:51 -0700
User-Agent: KMail/1.9.9
CC: <stern@rowland.harvard.edu>, <kernel@wantstofly.org>,
        <gregkh@linuxfoundation.org>, <hsweeten@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201307011552.51592.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use platform_get_irq() instead of accessing the platform_device
resources directly.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-ep93xx.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/ohci-ep93xx.c b/drivers/usb/host/ohci-ep93xx.c
index 4e12f67..b4f5e64 100644
--- a/drivers/usb/host/ohci-ep93xx.c
+++ b/drivers/usb/host/ohci-ep93xx.c
@@ -45,12 +45,12 @@ static int usb_hcd_ep93xx_probe(const struct hc_driver *driver,
 {
 	struct usb_hcd *hcd;
 	struct resource *res;
+	int irq;
 	int retval;
 
-	if (pdev->resource[1].flags != IORESOURCE_IRQ) {
-		dev_dbg(&pdev->dev, "resource[1] is not IORESOURCE_IRQ\n");
-		return -ENOMEM;
-	}
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -80,7 +80,7 @@ static int usb_hcd_ep93xx_probe(const struct hc_driver *driver,
 
 	ohci_hcd_init(hcd_to_ohci(hcd));
 
-	retval = usb_add_hcd(hcd, pdev->resource[1].start, 0);
+	retval = usb_add_hcd(hcd, irq, 0);
 	if (retval == 0)
 		return retval;
 
-- 
1.8.1.4

