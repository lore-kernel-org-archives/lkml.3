Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbaDWPTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:19:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60576 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073AbaDWPBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 11:01:13 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <marcel@holtmann.org>, <gustavo@padovan.org>, <johan.hedberg@gmail.com>,
        <jslaby@suse.cz>, <grant.likely@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 08/13] tty: serial: omap: switch over to platform_get_resource
Date: Wed, 23 Apr 2014 09:58:32 -0500
Message-ID: <1398265117-11793-8-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.2.459.g68773ac
In-Reply-To: <1398265117-11793-1-git-send-email-balbi@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this way we can remove one pointer declaration.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 3813740..cb45e88 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1644,7 +1644,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 	struct omap_uart_port_info *omap_up_info = dev_get_platdata(&pdev->dev);
 	struct uart_omap_port *up;
 	struct resource *mem;
-	struct resource *irq;
 	int uartirq = 0;
 	int wakeirq = 0;
 	int ret;
@@ -1658,12 +1657,9 @@ static int serial_omap_probe(struct platform_device *pdev)
 		omap_up_info = of_get_uart_port_info(&pdev->dev);
 		pdev->dev.platform_data = omap_up_info;
 	} else {
-		irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
-		if (!irq) {
-			dev_err(&pdev->dev, "no irq resource?\n");
-			return -ENODEV;
-		}
-		uartirq = irq->start;
+		uartirq = platform_get_irq(pdev, 0);
+		if (uartirq < 0)
+			return -EPROBE_DEFER;
 	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
1.9.2.459.g68773ac

