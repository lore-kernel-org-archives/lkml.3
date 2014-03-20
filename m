Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933922AbaCTThv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:37:51 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57351 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964985AbaCTTcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:32:01 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <peter@hurleysoftware.com>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 04/11] tty: serial: omap: switch over to platform_get_resource
Date: Thu, 20 Mar 2014 14:30:00 -0500
Message-ID: <1395343807-21618-4-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395343807-21618-1-git-send-email-balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
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
index 6831425..d041060 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1627,7 +1627,6 @@ static int serial_omap_probe(struct platform_device *pdev)
 	struct omap_uart_port_info *omap_up_info = dev_get_platdata(&pdev->dev);
 	struct uart_omap_port *up;
 	struct resource *mem;
-	struct resource *irq;
 	int uartirq = 0;
 	int wakeirq = 0;
 	int ret;
@@ -1641,12 +1640,9 @@ static int serial_omap_probe(struct platform_device *pdev)
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
1.9.1.286.g5172cb3

