Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab3GHHZv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:25:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:44963 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab3GHHZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:25:50 -0400
From: Alexander Savchenko <oleksandr.savchenko@ti.com>
To: <gregkh@linuxfoundation.org>, <jslaby@suse.cz>
CC: <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexander Savchenko <oleksandr.savchenko@ti.com>
Subject: [PATCH] serial: omap: Initialize platform_data
Date: Mon, 8 Jul 2013 10:25:43 +0300
Message-ID: <1373268343-2981-1-git-send-email-oleksandr.savchenko@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vikram Pandita <vikram.pandita@ti.com>

Otherwise serial driver would crash accessing platform_data that was
not initialized in functions like:

        serial_omap_pm(...)
        ...
        if (!state && pdata->enable_wakeup)
                   ^^^^^^^
        ...

Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
Signed-off-by: Alexander Savchenko <oleksandr.savchenko@ti.com>
---
 drivers/tty/serial/omap-serial.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index b6d1728..e42b4c9 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1402,8 +1402,10 @@ static int serial_omap_probe(struct platform_device *pdev)
 	struct omap_uart_port_info *omap_up_info = pdev->dev.platform_data;
 	int ret;
 
-	if (pdev->dev.of_node)
+	if (pdev->dev.of_node) {
 		omap_up_info = of_get_uart_port_info(&pdev->dev);
+		pdev->dev.platform_data = omap_up_info;
+	}
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!mem) {
-- 
1.7.9.5

