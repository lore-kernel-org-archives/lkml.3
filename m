Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab3JWWus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 18:50:48 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:61885 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3JWWuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 18:50:12 -0400
X-Amavis-Alert: BAD HEADER SECTION, Duplicate header field: "References"
From: Philippe Proulx <philippe.proulx@savoirfairelinux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Mark Jackson <mpfj-list@newflow.co.uk>, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: [PATCH 2/2] serial: omap: fix a few checkpatch warnings
Date: Wed, 23 Oct 2013 18:49:59 -0400
Message-Id: <ce53cd6c6bc139399b711228ff16c1072190d4d2.1382567103.git.philippe.proulx@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <cover.1382567103.git.philippe.proulx@savoirfairelinux.com>
References: <cover.1382567103.git.philippe.proulx@savoirfairelinux.com>
In-Reply-To: <cover.1382567103.git.philippe.proulx@savoirfairelinux.com>
References: <cover.1382567103.git.philippe.proulx@savoirfairelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philippe Proulx <philippe.proulx@savoirfairelinux.com>
---
 drivers/tty/serial/omap-serial.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
index 02cb61e..bf00477 100644
--- a/drivers/tty/serial/omap-serial.c
+++ b/drivers/tty/serial/omap-serial.c
@@ -175,7 +175,7 @@ struct uart_omap_port {
 	bool			is_suspending;
 };
 
-#define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
+#define to_uart_omap_port(p) ((container_of((p), struct uart_omap_port, port)))
 
 static struct uart_omap_port *ui[OMAP_MAX_HSUART_PORTS];
 
@@ -242,9 +242,9 @@ serial_omap_baud_is_mode16(struct uart_port *port, unsigned int baud)
 	unsigned int n16 = port->uartclk / (16 * baud);
 	int baudAbsDiff13 = baud - (port->uartclk / (13 * n13));
 	int baudAbsDiff16 = baud - (port->uartclk / (16 * n16));
-	if(baudAbsDiff13 < 0)
+	if (baudAbsDiff13 < 0)
 		baudAbsDiff13 = -baudAbsDiff13;
-	if(baudAbsDiff16 < 0)
+	if (baudAbsDiff16 < 0)
 		baudAbsDiff16 = -baudAbsDiff16;
 
 	return (baudAbsDiff13 >= baudAbsDiff16);
@@ -301,9 +301,8 @@ static void serial_omap_stop_tx(struct uart_port *port)
 			serial_out(up, UART_OMAP_SCR, up->scr);
 			res = (up->rs485.flags & SER_RS485_RTS_AFTER_SEND) ? 1 : 0;
 			if (gpio_get_value(up->rts_gpio) != res) {
-				if (up->rs485.delay_rts_after_send > 0) {
+				if (up->rs485.delay_rts_after_send > 0)
 					mdelay(up->rs485.delay_rts_after_send);
-				}
 				gpio_set_value(up->rts_gpio, res);
 			}
 		} else {
@@ -407,9 +406,8 @@ static void serial_omap_start_tx(struct uart_port *port)
 		res = (up->rs485.flags & SER_RS485_RTS_ON_SEND) ? 1 : 0;
 		if (gpio_get_value(up->rts_gpio) != res) {
 			gpio_set_value(up->rts_gpio, res);
-			if (up->rs485.delay_rts_before_send > 0) {
+			if (up->rs485.delay_rts_before_send > 0)
 				mdelay(up->rs485.delay_rts_before_send);
-			}
 		}
 	}
 
@@ -1686,8 +1684,9 @@ static int serial_omap_probe(struct platform_device *pdev)
 	up->port.uartclk = omap_up_info->uartclk;
 	if (!up->port.uartclk) {
 		up->port.uartclk = DEFAULT_CLK_SPEED;
-		dev_warn(&pdev->dev, "No clock speed specified: using default:"
-						"%d\n", DEFAULT_CLK_SPEED);
+		dev_warn(&pdev->dev,
+			 "No clock speed specified: using default: %d\n"
+			 DEFAULT_CLK_SPEED);
 	}
 
 	up->latency = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE;
-- 
1.8.4.1

