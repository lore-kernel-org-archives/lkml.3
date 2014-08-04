Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbaHDOXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:23:51 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:34256 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373AbaHDOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:23:48 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: davidb@codeaurora.org
Cc: dwalker@fifo99.com, bryanh@codeaurora.org, sboyd@codeaurora.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        kiran.padwal@smartplayin.com, linux-arm-msm@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tty: serial: msm: fix checkpatch warnings
Date: Mon,  4 Aug 2014 19:50:46 +0530
Message-Id: <1407162046-29729-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following checkpatch.pl warning:

WARNING: braces {} are not necessary for any arm of this statement

WARNING: Missing a blank line after declarations

WARNING: Prefer [subsystem eg: netdev]_err([subsystem]dev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

WARNING: Prefer [subsystem eg: netdev]_info([subsystem]dev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

WARNING: else is not generally useful after a break or return

WARNING: void function return statements are not generally useful

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/tty/serial/msm_serial.c |   26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 0da0b54..26df038 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -190,11 +190,10 @@ static void handle_rx(struct uart_port *port)
 		/* Mask conditions we're ignorning. */
 		sr &= port->read_status_mask;
 
-		if (sr & UART_SR_RX_BREAK) {
+		if (sr & UART_SR_RX_BREAK)
 			flag = TTY_BREAK;
-		} else if (sr & UART_SR_PAR_FRAME_ERR) {
+		else if (sr & UART_SR_PAR_FRAME_ERR)
 			flag = TTY_FRAME;
-		}
 
 		if (!uart_handle_sysrq_char(port, c))
 			tty_insert_flip_char(tport, c, flag);
@@ -315,7 +314,6 @@ static unsigned int msm_get_mctrl(struct uart_port *port)
 	return TIOCM_CAR | TIOCM_CTS | TIOCM_DSR | TIOCM_RTS;
 }
 
-
 static void msm_reset(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
@@ -336,6 +334,7 @@ static void msm_reset(struct uart_port *port)
 static void msm_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
 	unsigned int mr;
+
 	mr = msm_read(port, UART_MR1);
 
 	if (!(mctrl & TIOCM_RTS)) {
@@ -431,7 +430,6 @@ static int msm_set_baud_rate(struct uart_port *port, unsigned int baud)
 	return baud;
 }
 
-
 static void msm_init_clock(struct uart_port *port)
 {
 	struct msm_port *msm_port = UART_TO_MSM(port);
@@ -646,6 +644,7 @@ fail_release_port:
 static void msm_config_port(struct uart_port *port, int flags)
 {
 	int ret;
+
 	if (flags & UART_CONFIG_TYPE) {
 		port->type = PORT_MSM;
 		ret = msm_request_port(port);
@@ -678,7 +677,7 @@ static void msm_power(struct uart_port *port, unsigned int state,
 		clk_disable_unprepare(msm_port->pclk);
 		break;
 	default:
-		printk(KERN_ERR "msm_serial: Unknown PM state %d\n", state);
+		pr_err("msm_serial: Unknown PM state %d\n", state);
 	}
 }
 
@@ -701,8 +700,8 @@ static int msm_poll_get_char_single(struct uart_port *port)
 
 	if (!(msm_read(port, UART_SR) & UART_SR_RX_READY))
 		return NO_POLL_CHAR;
-	else
-		return msm_read(port, rf_reg) & 0xff;
+
+	return msm_read(port, rf_reg) & 0xff;
 }
 
 static int msm_poll_get_char_dm_1p3(struct uart_port *port)
@@ -788,8 +787,6 @@ static void msm_poll_put_char(struct uart_port *port, unsigned char c)
 
 	/* Enable interrupts */
 	msm_write(port, imr, UART_IMR);
-
-	return;
 }
 #endif
 
@@ -958,7 +955,7 @@ static int __init msm_console_setup(struct console *co, char *options)
 		msm_write(port, UART_CR_TX_ENABLE, UART_CR);
 	}
 
-	printk(KERN_INFO "msm_serial: console setup on port #%d\n", port->line);
+	pr_info("msm_serial: console setup on port #%d\n", port->line);
 
 	return uart_set_options(port, co, baud, parity, bits, flow);
 }
@@ -1013,7 +1010,7 @@ static int msm_serial_probe(struct platform_device *pdev)
 	if (unlikely(pdev->id < 0 || pdev->id >= UART_NR))
 		return -ENXIO;
 
-	printk(KERN_INFO "msm_serial: detected port #%d\n", pdev->id);
+	dev_info(&pdev->dev, "msm_serial: detected port #%d\n", pdev->id);
 
 	port = get_port_from_line(pdev->id);
 	port->dev = &pdev->dev;
@@ -1038,8 +1035,7 @@ static int msm_serial_probe(struct platform_device *pdev)
 	}
 
 	port->uartclk = clk_get_rate(msm_port->clk);
-	printk(KERN_INFO "uartclk = %d\n", port->uartclk);
-
+	dev_info(&pdev->dev, "uartclk = %d\n", port->uartclk);
 
 	resource = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (unlikely(!resource))
@@ -1093,7 +1089,7 @@ static int __init msm_serial_init(void)
 	if (unlikely(ret))
 		uart_unregister_driver(&msm_uart_driver);
 
-	printk(KERN_INFO "msm_serial: driver initialized\n");
+	pr_info("msm_serial: driver initialized\n");
 
 	return ret;
 }
-- 
1.7.9.5

