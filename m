Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaCLTGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:06:50 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:44223 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaCLTEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:04:09 -0400
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH v3 3/9] tty: xuartps: Clean up
Date: Wed, 12 Mar 2014 12:02:57 -0700
Message-Id: <1394650983-24780-4-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1394650983-24780-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1394650983-24780-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is all white space and comment clean up. Mostly reformatting
comments.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 210 +++++++++++++------------------------
 1 file changed, 74 insertions(+), 136 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 2cd0cd456c7a..787a12064fa0 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1,14 +1,13 @@
 /*
  * Xilinx PS UART driver
  *
- * 2011 - 2013 (C) Xilinx Inc.
+ * 2011 - 2014 (C) Xilinx Inc.
  *
  * This program is free software; you can redistribute it
  * and/or modify it under the terms of the GNU General Public
  * License as published by the Free Software Foundation;
  * either version 2 of the License, or (at your option) any
  * later version.
- *
  */
 
 #if defined(CONFIG_SERIAL_XILINX_PS_UART_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
@@ -49,39 +48,27 @@ static int rx_timeout = 10;
 module_param(rx_timeout, uint, S_IRUGO);
 MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
 
-/********************************Register Map********************************/
-/** UART
- *
- * Register offsets for the UART.
- *
- */
-#define XUARTPS_CR_OFFSET	0x00  /* Control Register [8:0] */
-#define XUARTPS_MR_OFFSET	0x04  /* Mode Register [10:0] */
-#define XUARTPS_IER_OFFSET	0x08  /* Interrupt Enable [10:0] */
-#define XUARTPS_IDR_OFFSET	0x0C  /* Interrupt Disable [10:0] */
-#define XUARTPS_IMR_OFFSET	0x10  /* Interrupt Mask [10:0] */
-#define XUARTPS_ISR_OFFSET	0x14  /* Interrupt Status [10:0]*/
-#define XUARTPS_BAUDGEN_OFFSET	0x18  /* Baud Rate Generator [15:0] */
-#define XUARTPS_RXTOUT_OFFSET	0x1C  /* RX Timeout [7:0] */
-#define XUARTPS_RXWM_OFFSET	0x20  /* RX FIFO Trigger Level [5:0] */
-#define XUARTPS_MODEMCR_OFFSET	0x24  /* Modem Control [5:0] */
-#define XUARTPS_MODEMSR_OFFSET	0x28  /* Modem Status [8:0] */
-#define XUARTPS_SR_OFFSET	0x2C  /* Channel Status [11:0] */
-#define XUARTPS_FIFO_OFFSET	0x30  /* FIFO [15:0] or [7:0] */
-#define XUARTPS_BAUDDIV_OFFSET	0x34  /* Baud Rate Divider [7:0] */
-#define XUARTPS_FLOWDEL_OFFSET	0x38  /* Flow Delay [15:0] */
-#define XUARTPS_IRRX_PWIDTH_OFFSET 0x3C /* IR Minimum Received Pulse
-						Width [15:0] */
-#define XUARTPS_IRTX_PWIDTH_OFFSET 0x40 /* IR Transmitted pulse
-						Width [7:0] */
-#define XUARTPS_TXWM_OFFSET	0x44  /* TX FIFO Trigger Level [5:0] */
-
-/** Control Register
- *
- * The Control register (CR) controls the major functions of the device.
- *
- * Control Register Bit Definitions
- */
+/* Register offsets for the UART. */
+#define XUARTPS_CR_OFFSET	0x00  /* Control Register */
+#define XUARTPS_MR_OFFSET	0x04  /* Mode Register */
+#define XUARTPS_IER_OFFSET	0x08  /* Interrupt Enable */
+#define XUARTPS_IDR_OFFSET	0x0C  /* Interrupt Disable */
+#define XUARTPS_IMR_OFFSET	0x10  /* Interrupt Mask */
+#define XUARTPS_ISR_OFFSET	0x14  /* Interrupt Status */
+#define XUARTPS_BAUDGEN_OFFSET	0x18  /* Baud Rate Generator */
+#define XUARTPS_RXTOUT_OFFSET	0x1C  /* RX Timeout */
+#define XUARTPS_RXWM_OFFSET	0x20  /* RX FIFO Trigger Level */
+#define XUARTPS_MODEMCR_OFFSET	0x24  /* Modem Control */
+#define XUARTPS_MODEMSR_OFFSET	0x28  /* Modem Status */
+#define XUARTPS_SR_OFFSET	0x2C  /* Channel Status */
+#define XUARTPS_FIFO_OFFSET	0x30  /* FIFO */
+#define XUARTPS_BAUDDIV_OFFSET	0x34  /* Baud Rate Divider */
+#define XUARTPS_FLOWDEL_OFFSET	0x38  /* Flow Delay */
+#define XUARTPS_IRRX_PWIDTH_OFFSET 0x3C /* IR Minimum Received Pulse Width */
+#define XUARTPS_IRTX_PWIDTH_OFFSET 0x40 /* IR Transmitted pulse Width */
+#define XUARTPS_TXWM_OFFSET	0x44  /* TX FIFO Trigger Level */
+
+/* Control Register Bit Definitions */
 #define XUARTPS_CR_STOPBRK	0x00000100  /* Stop TX break */
 #define XUARTPS_CR_STARTBRK	0x00000080  /* Set TX break */
 #define XUARTPS_CR_TX_DIS	0x00000020  /* TX disabled. */
@@ -92,14 +79,11 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
 #define XUARTPS_CR_RXRST	0x00000001  /* RX logic reset */
 #define XUARTPS_CR_RST_TO	0x00000040  /* Restart Timeout Counter */
 
-/** Mode Register
- *
+/*
+ * Mode Register:
  * The mode register (MR) defines the mode of transfer as well as the data
  * format. If this register is modified during transmission or reception,
  * data validity cannot be guaranteed.
- *
- * Mode Register Bit Definitions
- *
  */
 #define XUARTPS_MR_CLKSEL		0x00000001  /* Pre-scalar selection */
 #define XUARTPS_MR_CHMODE_L_LOOP	0x00000200  /* Local loop back mode */
@@ -118,8 +102,8 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
 #define XUARTPS_MR_CHARLEN_7_BIT	0x00000004  /* 7 bits data */
 #define XUARTPS_MR_CHARLEN_8_BIT	0x00000000  /* 8 bits data */
 
-/** Interrupt Registers
- *
+/*
+ * Interrupt Registers:
  * Interrupt control logic uses the interrupt enable register (IER) and the
  * interrupt disable register (IDR) to set the value of the bits in the
  * interrupt mask register (IMR). The IMR determines whether to pass an
@@ -127,7 +111,6 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
  * Writing a 1 to IER Enables an interrupt, writing a 1 to IDR disables an
  * interrupt. IMR and ISR are read only, and IER and IDR are write only.
  * Reading either IER or IDR returns 0x00.
- *
  * All four registers have the same bit definitions.
  */
 #define XUARTPS_IXR_TOUT	0x00000100 /* RX Timeout error interrupt */
@@ -145,8 +128,8 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
 /* Goes in read_status_mask for break detection as the HW doesn't do it*/
 #define XUARTPS_IXR_BRK		0x80000000
 
-/** Channel Status Register
- *
+/*
+ * Channel Status Register:
  * The channel status register (CSR) is provided to enable the control logic
  * to monitor the status of bits in the channel interrupt status register,
  * even if these are masked out by the interrupt mask register.
@@ -205,7 +188,6 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 	 * error with all-zeros data as a break sequence. Most of the time,
 	 * there's another non-zero byte at the end of the sequence.
 	 */
-
 	if (isrstatus & XUARTPS_IXR_FRAMING) {
 		while (!(xuartps_readl(XUARTPS_SR_OFFSET) &
 					XUARTPS_SR_RXEMPTY)) {
@@ -264,8 +246,9 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 			} else if (isrstatus & XUARTPS_IXR_FRAMING) {
 				port->icount.frame++;
 				status = TTY_FRAME;
-			} else if (isrstatus & XUARTPS_IXR_OVERRUN)
+			} else if (isrstatus & XUARTPS_IXR_OVERRUN) {
 				port->icount.overrun++;
+			}
 
 			uart_insert_char(port, isrstatus, XUARTPS_IXR_OVERRUN,
 					data, status);
@@ -300,7 +283,7 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
 				 * the buffer if it reaches limit.
 				 */
 				port->state->xmit.tail =
-					(port->state->xmit.tail + 1) & \
+					(port->state->xmit.tail + 1) &
 						(UART_XMIT_SIZE - 1);
 			}
 
@@ -419,7 +402,7 @@ static unsigned int xuartps_set_baud_rate(struct uart_port *port,
  * @nb:		Notifier block
  * @event:	Notify event
  * @data:	Notifier data
- * Return: NOTIFY_OK on success, NOTIFY_BAD on error.
+ * Return:	NOTIFY_OK or NOTIFY_DONE on success, NOTIFY_BAD on error.
  */
 static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 		unsigned long event, void *data)
@@ -438,8 +421,7 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 	switch (event) {
 	case PRE_RATE_CHANGE:
 	{
-		u32 bdiv;
-		u32 cd;
+		u32 bdiv, cd;
 		int div8;
 
 		/*
@@ -509,8 +491,6 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 }
 #endif
 
-/*----------------------Uart Operations---------------------------*/
-
 /**
  * xuartps_start_tx -  Start transmitting bytes
  * @port: Handle to the uart port structure
@@ -529,9 +509,8 @@ static void xuartps_start_tx(struct uart_port *port)
 	xuartps_writel((status & ~XUARTPS_CR_TX_DIS) | XUARTPS_CR_TX_EN,
 		XUARTPS_CR_OFFSET);
 
-	while (numbytes-- && ((xuartps_readl(XUARTPS_SR_OFFSET)
-		& XUARTPS_SR_TXFULL)) != XUARTPS_SR_TXFULL) {
-
+	while (numbytes-- && ((xuartps_readl(XUARTPS_SR_OFFSET) &
+				XUARTPS_SR_TXFULL)) != XUARTPS_SR_TXFULL) {
 		/* Break if no more data available in the UART buffer */
 		if (uart_circ_empty(&port->state->xmit))
 			break;
@@ -666,9 +645,7 @@ static void xuartps_set_termios(struct uart_port *port,
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
 
-	/*
-	 * Update the per-port timeout.
-	 */
+	/* Update the per-port timeout. */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
 	/* Set TX/RX Reset */
@@ -678,7 +655,8 @@ static void xuartps_set_termios(struct uart_port *port,
 
 	ctrl_reg = xuartps_readl(XUARTPS_CR_OFFSET);
 
-	/* Clear the RX disable and TX disable bits and then set the TX enable
+	/*
+	 * Clear the RX disable and TX disable bits and then set the TX enable
 	 * bit and RX enable bit to enable the transmitter and receiver.
 	 */
 	xuartps_writel(
@@ -756,7 +734,7 @@ static void xuartps_set_termios(struct uart_port *port,
  * xuartps_startup - Called when an application opens a xuartps port
  * @port: Handle to the uart port structure
  *
- * Return: 0 on success, negative error otherwise
+ * Return: 0 on success, negative errno otherwise
  */
 static int xuartps_startup(struct uart_port *port)
 {
@@ -850,7 +828,7 @@ static const char *xuartps_type(struct uart_port *port)
  * @port: Handle to the uart port structure
  * @ser: Handle to the structure whose members are compared
  *
- * Return: 0 if success otherwise -EINVAL
+ * Return: 0 on success, negative errno otherwise.
  */
 static int xuartps_verify_port(struct uart_port *port,
 					struct serial_struct *ser)
@@ -874,7 +852,7 @@ static int xuartps_verify_port(struct uart_port *port,
  *				uart_add_one_port()
  * @port: Handle to the uart port structure
  *
- * Return: 0, -ENOMEM if request fails
+ * Return: 0 on success, negative errno otherwise.
  */
 static int xuartps_request_port(struct uart_port *port)
 {
@@ -893,10 +871,11 @@ static int xuartps_request_port(struct uart_port *port)
 }
 
 /**
- * xuartps_release_port - Release the memory region attached to a xuartps
- *				port, called when the driver removes a xuartps
- *				port via uart_remove_one_port().
+ * xuartps_release_port - Release UART port
  * @port: Handle to the uart port structure
+ *
+ * Release the memory region attached to a xuartps port. Called when the
+ * driver removes a xuartps port via uart_remove_one_port().
  */
 static void xuartps_release_port(struct uart_port *port)
 {
@@ -906,8 +885,7 @@ static void xuartps_release_port(struct uart_port *port)
 }
 
 /**
- * xuartps_config_port - Configure xuartps, called when the driver adds a
- *				xuartps port
+ * xuartps_config_port - Configure UART port
  * @port: Handle to the uart port structure
  * @flags: If any
  */
@@ -919,7 +897,6 @@ static void xuartps_config_port(struct uart_port *port, int flags)
 
 /**
  * xuartps_get_mctrl - Get the modem control state
- *
  * @port: Handle to the uart port structure
  *
  * Return: the modem control state
@@ -987,38 +964,23 @@ static void xuartps_poll_put_char(struct uart_port *port, unsigned char c)
 }
 #endif
 
-/** The UART operations structure
- */
 static struct uart_ops xuartps_ops = {
 	.set_mctrl	= xuartps_set_mctrl,
 	.get_mctrl	= xuartps_get_mctrl,
 	.enable_ms	= xuartps_enable_ms,
-
-	.start_tx	= xuartps_start_tx,	/* Start transmitting */
-	.stop_tx	= xuartps_stop_tx,	/* Stop transmission */
-	.stop_rx	= xuartps_stop_rx,	/* Stop reception */
-	.tx_empty	= xuartps_tx_empty,	/* Transmitter busy? */
-	.break_ctl	= xuartps_break_ctl,	/* Start/stop
-						 * transmitting break
-						 */
-	.set_termios	= xuartps_set_termios,	/* Set termios */
-	.startup	= xuartps_startup,	/* App opens xuartps */
-	.shutdown	= xuartps_shutdown,	/* App closes xuartps */
-	.type		= xuartps_type,		/* Set UART type */
-	.verify_port	= xuartps_verify_port,	/* Verification of port
-						 * params
-						 */
-	.request_port	= xuartps_request_port,	/* Claim resources
-						 * associated with a
-						 * xuartps port
-						 */
-	.release_port	= xuartps_release_port,	/* Release resources
-						 * associated with a
-						 * xuartps port
-						 */
-	.config_port	= xuartps_config_port,	/* Configure when driver
-						 * adds a xuartps port
-						 */
+	.start_tx	= xuartps_start_tx,
+	.stop_tx	= xuartps_stop_tx,
+	.stop_rx	= xuartps_stop_rx,
+	.tx_empty	= xuartps_tx_empty,
+	.break_ctl	= xuartps_break_ctl,
+	.set_termios	= xuartps_set_termios,
+	.startup	= xuartps_startup,
+	.shutdown	= xuartps_shutdown,
+	.type		= xuartps_type,
+	.verify_port	= xuartps_verify_port,
+	.request_port	= xuartps_request_port,
+	.release_port	= xuartps_release_port,
+	.config_port	= xuartps_config_port,
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_get_char	= xuartps_poll_get_char,
 	.poll_put_char	= xuartps_poll_put_char,
@@ -1028,9 +990,7 @@ static struct uart_ops xuartps_ops = {
 static struct uart_port xuartps_port[2];
 
 /**
- * xuartps_get_port - Configure the port from the platform device resource
- *			info
- *
+ * xuartps_get_port - Configure the port from the platform device resource info
  * @id: Port id
  *
  * Return: a pointer to a uart_port or NULL for failure
@@ -1067,8 +1027,6 @@ static struct uart_port *xuartps_get_port(int id)
 	return port;
 }
 
-/*-----------------------Console driver operations--------------------------*/
-
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 /**
  * xuartps_console_wait_tx - Wait for the TX to be full
@@ -1144,7 +1102,7 @@ static void xuartps_console_write(struct console *co, const char *s,
  * @co: Console handle
  * @options: Initial settings of uart
  *
- * Return: 0, -ENODEV if no device
+ * Return: 0 on success, negative errno otherwise.
  */
 static int __init xuartps_console_setup(struct console *co, char *options)
 {
@@ -1183,7 +1141,7 @@ static struct console xuartps_console = {
 /**
  * xuartps_console_init - Initialization call
  *
- * Return: 0 on success, negative error otherwise
+ * Return: 0 on success, negative errno otherwise
  */
 static int __init xuartps_console_init(void)
 {
@@ -1195,17 +1153,15 @@ console_initcall(xuartps_console_init);
 
 #endif /* CONFIG_SERIAL_XILINX_PS_UART_CONSOLE */
 
-/** Structure Definitions
- */
 static struct uart_driver xuartps_uart_driver = {
-	.owner		= THIS_MODULE,		/* Owner */
-	.driver_name	= XUARTPS_NAME,		/* Driver name */
-	.dev_name	= XUARTPS_TTY_NAME,	/* Node name */
-	.major		= XUARTPS_MAJOR,	/* Major number */
-	.minor		= XUARTPS_MINOR,	/* Minor number */
-	.nr		= XUARTPS_NR_PORTS,	/* Number of UART ports */
+	.owner		= THIS_MODULE,
+	.driver_name	= XUARTPS_NAME,
+	.dev_name	= XUARTPS_TTY_NAME,
+	.major		= XUARTPS_MAJOR,
+	.minor		= XUARTPS_MINOR,
+	.nr		= XUARTPS_NR_PORTS,
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
-	.cons		= &xuartps_console,	/* Console */
+	.cons		= &xuartps_console,
 #endif
 };
 
@@ -1322,14 +1278,11 @@ static int xuartps_resume(struct device *device)
 
 static SIMPLE_DEV_PM_OPS(xuartps_dev_pm_ops, xuartps_suspend, xuartps_resume);
 
-/* ---------------------------------------------------------------------
- * Platform bus binding
- */
 /**
  * xuartps_probe - Platform driver probe
  * @pdev: Pointer to the platform device structure
  *
- * Return: 0 on success, negative error otherwise
+ * Return: 0 on success, negative errno otherwise
  */
 static int xuartps_probe(struct platform_device *pdev)
 {
@@ -1434,7 +1387,7 @@ err_out_clk_dis_aper:
  * xuartps_remove - called when the platform driver is unregistered
  * @pdev: Pointer to the platform device structure
  *
- * Return: 0 on success, negative error otherwise
+ * Return: 0 on success, negative errno otherwise
  */
 static int xuartps_remove(struct platform_device *pdev)
 {
@@ -1462,24 +1415,16 @@ static struct of_device_id xuartps_of_match[] = {
 MODULE_DEVICE_TABLE(of, xuartps_of_match);
 
 static struct platform_driver xuartps_platform_driver = {
-	.probe   = xuartps_probe,		/* Probe method */
-	.remove  = xuartps_remove,		/* Detach method */
+	.probe   = xuartps_probe,
+	.remove  = xuartps_remove,
 	.driver  = {
 		.owner = THIS_MODULE,
-		.name = XUARTPS_NAME,		/* Driver name */
+		.name = XUARTPS_NAME,
 		.of_match_table = xuartps_of_match,
 		.pm = &xuartps_dev_pm_ops,
 		},
 };
 
-/* ---------------------------------------------------------------------
- * Module Init and Exit
- */
-/**
- * xuartps_init - Initial driver registration call
- *
- * Return: whether the registration was successful or not
- */
 static int __init xuartps_init(void)
 {
 	int retval = 0;
@@ -1497,15 +1442,8 @@ static int __init xuartps_init(void)
 	return retval;
 }
 
-/**
- * xuartps_exit - Driver unregistration call
- */
 static void __exit xuartps_exit(void)
 {
-	/* The order of unregistration is important. Unregister the
-	 * UART driver before the platform driver crashes the system.
-	 */
-
 	/* Unregister the platform driver */
 	platform_driver_unregister(&xuartps_platform_driver);
 
-- 
1.9.0.1.g4196000

