Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699AbaDWPTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 11:19:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:60577 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757080AbaDWPBN (ORCPT
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
Subject: [PATCH 06/13] tty: serial: omap: switch over to devm_request_gpio
Date: Wed, 23 Apr 2014 09:58:30 -0500
Message-ID: <1398265117-11793-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.9.2.459.g68773ac
In-Reply-To: <1398265117-11793-1-git-send-email-balbi@ti.com>
References: <1398265117-11793-1-git-send-email-balbi@ti.com>
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
index f456f46..07d4273 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -1611,7 +1611,7 @@ static int serial_omap_probe_rs485(struct uart_omap_port *up,
 	/* check for tx enable gpio */
 	up->rts_gpio = of_get_named_gpio_flags(np, "rts-gpio", 0, &flags);
 	if (gpio_is_valid(up->rts_gpio)) {
-		ret = gpio_request(up->rts_gpio, "omap-serial");
+		ret = devm_gpio_request(up->dev, up->rts_gpio, "omap-serial");
 		if (ret < 0)
 			return ret;
 		ret = gpio_direction_output(up->rts_gpio,
@@ -1677,7 +1677,8 @@ static int serial_omap_probe(struct platform_device *pdev)
 
 	if (gpio_is_valid(omap_up_info->DTR_gpio) &&
 	    omap_up_info->DTR_present) {
-		ret = gpio_request(omap_up_info->DTR_gpio, "omap-serial");
+		ret = devm_gpio_request(&pdev->dev, omap_up_info->DTR_gpio,
+				"omap-serial");
 		if (ret < 0)
 			return ret;
 		ret = gpio_direction_output(omap_up_info->DTR_gpio,
-- 
1.9.2.459.g68773ac

