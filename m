Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965033AbaCTTcD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:32:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53487 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaCTTb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:31:59 -0400
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <peter@hurleysoftware.com>, <m-karicheri2@ti.com>,
        <b32955@freescale.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 02/11] tty: serial: omap: switch over to devm_request_gpio
Date: Thu, 20 Mar 2014 14:29:58 -0500
Message-ID: <1395343807-21618-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.1.286.g5172cb3
In-Reply-To: <1395343807-21618-1-git-send-email-balbi@ti.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this will make sure gpio gets freed automatically
when this device is destroyed.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/tty/serial/omap-serial.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 73abba8..db5d90b 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1594,7 +1594,7 @@ static int serial_omap_probe_rs485(struct uart_omap_port *up,
 	/* check for tx enable gpio */
 	up->rts_gpio = of_get_named_gpio_flags(np, "rts-gpio", 0, &flags);
 	if (gpio_is_valid(up->rts_gpio)) {
-		ret = gpio_request(up->rts_gpio, "omap-serial");
+		ret = devm_gpio_request(up->dev, up->rts_gpio, "omap-serial");
 		if (ret < 0)
 			return ret;
 		ret = gpio_direction_output(up->rts_gpio,
@@ -1660,7 +1660,8 @@ static int serial_omap_probe(struct platform_device *pdev)
 
 	if (gpio_is_valid(omap_up_info->DTR_gpio) &&
 	    omap_up_info->DTR_present) {
-		ret = gpio_request(omap_up_info->DTR_gpio, "omap-serial");
+		ret = devm_gpio_request(&pdev->dev, omap_up_info->DTR_gpio,
+				"omap-serial");
 		if (ret < 0)
 			return ret;
 		ret = gpio_direction_output(omap_up_info->DTR_gpio,
-- 
1.9.1.286.g5172cb3

