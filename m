Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaCDS73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 13:59:29 -0500
Received: from mail-ig0-f179.google.com ([209.85.213.179]:42777 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbaCDS7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 13:59:25 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 1/6] tty: xemacps: Clean up
Date: Tue,  4 Mar 2014 09:17:24 -0800
Message-Id: <1393953449-28551-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
In-Reply-To: <1393953449-28551-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1393953449-28551-1-git-send-email-soren.brinkmann@xilinx.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is all white space and comment clean up. Mostly reformatting
comments.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
 drivers/tty/serial/xilinx_uartps.c | 288 ++++++++++++++-----------------------
 1 file changed, 108 insertions(+), 180 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index f619ad5b5eae..8769b68534b1 100644
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
@@ -163,11 +146,11 @@ MODULE_PARM_DESC(rx_timeout, "Rx timeout, 1-255");
 
 /**
  * struct xuartps - device data
- * @port		Pointer to the UART port
- * @refclk		Reference clock
- * @aperclk		APB clock
- * @baud		Current baud rate
- * @clk_rate_change_nb	Notifier block for clock changes
+ * @port:		Pointer to the UART port
+ * @refclk:		Reference clock
+ * @aperclk:		APB clock
+ * @baud:		Current baud rate
+ * @clk_rate_change_nb:	Notifier block for clock changes
  */
 struct xuartps {
 	struct uart_port	*port;
@@ -183,8 +166,8 @@ struct xuartps {
  * @irq: Irq number
  * @dev_id: Id of the port
  *
- * Returns IRQHANDLED
- **/
+ * Return: IRQHANDLED
+ */
 static irqreturn_t xuartps_isr(int irq, void *dev_id)
 {
 	struct uart_port *port = (struct uart_port *)dev_id;
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
 
@@ -325,7 +308,7 @@ static irqreturn_t xuartps_isr(int irq, void *dev_id)
  * @rbdiv: BDIV value (return value)
  * @rcd: CD value (return value)
  * @div8: Value for clk_sel bit in mod (return value)
- * Returns baud rate, requested baud when possible, or actual baud when there
+ * Return: baud rate, requested baud when possible, or actual baud when there
  *	was too much error, zero if no valid divisors are found.
  *
  * Formula to obtain baud rate is
@@ -384,7 +367,7 @@ static unsigned int xuartps_calc_baud_divs(unsigned int clk, unsigned int baud,
  * xuartps_set_baud_rate - Calculate and set the baud rate
  * @port: Handle to the uart port structure
  * @baud: Baud rate to set
- * Returns baud rate, requested baud when possible, or actual baud when there
+ * Return: baud rate, requested baud when possible, or actual baud when there
  *	   was too much error, zero if no valid divisors are found.
  */
 static unsigned int xuartps_set_baud_rate(struct uart_port *port,
@@ -419,7 +402,7 @@ static unsigned int xuartps_set_baud_rate(struct uart_port *port,
  * @nb:		Notifier block
  * @event:	Notify event
  * @data:	Notifier data
- * Returns NOTIFY_OK on success, NOTIFY_BAD on error.
+ * Return:	NOTIFY_OK or NOTIFY_DONE on success, NOTIFY_BAD on error.
  */
 static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 		unsigned long event, void *data)
@@ -509,13 +492,10 @@ static int xuartps_clk_notifier_cb(struct notifier_block *nb,
 }
 #endif
 
-/*----------------------Uart Operations---------------------------*/
-
 /**
  * xuartps_start_tx -  Start transmitting bytes
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_start_tx(struct uart_port *port)
 {
 	unsigned int status, numbytes = port->fifosize;
@@ -530,9 +510,8 @@ static void xuartps_start_tx(struct uart_port *port)
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
@@ -562,8 +541,7 @@ static void xuartps_start_tx(struct uart_port *port)
 /**
  * xuartps_stop_tx - Stop TX
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_stop_tx(struct uart_port *port)
 {
 	unsigned int regval;
@@ -577,8 +555,7 @@ static void xuartps_stop_tx(struct uart_port *port)
 /**
  * xuartps_stop_rx - Stop RX
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_stop_rx(struct uart_port *port)
 {
 	unsigned int regval;
@@ -593,8 +570,8 @@ static void xuartps_stop_rx(struct uart_port *port)
  * xuartps_tx_empty -  Check whether TX is empty
  * @port: Handle to the uart port structure
  *
- * Returns TIOCSER_TEMT on success, 0 otherwise
- **/
+ * Return: TIOCSER_TEMT on success, 0 otherwise
+ */
 static unsigned int xuartps_tx_empty(struct uart_port *port)
 {
 	unsigned int status;
@@ -608,8 +585,7 @@ static unsigned int xuartps_tx_empty(struct uart_port *port)
  *			transmitting char breaks
  * @port: Handle to the uart port structure
  * @ctl: Value based on which start or stop decision is taken
- *
- **/
+ */
 static void xuartps_break_ctl(struct uart_port *port, int ctl)
 {
 	unsigned int status;
@@ -636,8 +612,7 @@ static void xuartps_break_ctl(struct uart_port *port, int ctl)
  * @port: Handle to the uart port structure
  * @termios: Handle to the input termios structure
  * @old: Values of the previously saved termios structure
- *
- **/
+ */
 static void xuartps_set_termios(struct uart_port *port,
 				struct ktermios *termios, struct ktermios *old)
 {
@@ -671,9 +646,7 @@ static void xuartps_set_termios(struct uart_port *port,
 	if (tty_termios_baud_rate(termios))
 		tty_termios_encode_baud_rate(termios, baud, baud);
 
-	/*
-	 * Update the per-port timeout.
-	 */
+	/* Update the per-port timeout. */
 	uart_update_timeout(port, termios->c_cflag, baud);
 
 	/* Set TX/RX Reset */
@@ -761,8 +734,8 @@ static void xuartps_set_termios(struct uart_port *port,
  * xuartps_startup - Called when an application opens a xuartps port
  * @port: Handle to the uart port structure
  *
- * Returns 0 on success, negative error otherwise
- **/
+ * Return: 0 on success, negative errno otherwise
+ */
 static int xuartps_startup(struct uart_port *port)
 {
 	unsigned int retval = 0, status = 0;
@@ -824,8 +797,7 @@ static int xuartps_startup(struct uart_port *port)
 /**
  * xuartps_shutdown - Called when an application closes a xuartps port
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_shutdown(struct uart_port *port)
 {
 	int status;
@@ -844,8 +816,8 @@ static void xuartps_shutdown(struct uart_port *port)
  * xuartps_type - Set UART type to xuartps port
  * @port: Handle to the uart port structure
  *
- * Returns string on success, NULL otherwise
- **/
+ * Return: string on success, NULL otherwise
+ */
 static const char *xuartps_type(struct uart_port *port)
 {
 	return port->type == PORT_XUARTPS ? XUARTPS_NAME : NULL;
@@ -856,8 +828,8 @@ static const char *xuartps_type(struct uart_port *port)
  * @port: Handle to the uart port structure
  * @ser: Handle to the structure whose members are compared
  *
- * Returns 0 if success otherwise -EINVAL
- **/
+ * Return: 0 on success, negative errno otherwise.
+ */
 static int xuartps_verify_port(struct uart_port *port,
 					struct serial_struct *ser)
 {
@@ -880,8 +852,8 @@ static int xuartps_verify_port(struct uart_port *port,
  *				uart_add_one_port()
  * @port: Handle to the uart port structure
  *
- * Returns 0, -ENOMEM if request fails
- **/
+ * Return: 0 on success, negative errno otherwise.
+ */
 static int xuartps_request_port(struct uart_port *port)
 {
 	if (!request_mem_region(port->mapbase, XUARTPS_REGISTER_SPACE,
@@ -899,12 +871,12 @@ static int xuartps_request_port(struct uart_port *port)
 }
 
 /**
- * xuartps_release_port - Release the memory region attached to a xuartps
- *				port, called when the driver removes a xuartps
- *				port via uart_remove_one_port().
+ * xuartps_release_port - Release UART port
  * @port: Handle to the uart port structure
  *
- **/
+ * Release the memory region attached to a xuartps port. Called when the
+ * driver removes a xuartps port via uart_remove_one_port().
+ */
 static void xuartps_release_port(struct uart_port *port)
 {
 	release_mem_region(port->mapbase, XUARTPS_REGISTER_SPACE);
@@ -913,12 +885,10 @@ static void xuartps_release_port(struct uart_port *port)
 }
 
 /**
- * xuartps_config_port - Configure xuartps, called when the driver adds a
- *				xuartps port
+ * xuartps_config_port - Configure UART port
  * @port: Handle to the uart port structure
  * @flags: If any
- *
- **/
+ */
 static void xuartps_config_port(struct uart_port *port, int flags)
 {
 	if (flags & UART_CONFIG_TYPE && xuartps_request_port(port) == 0)
@@ -927,12 +897,10 @@ static void xuartps_config_port(struct uart_port *port, int flags)
 
 /**
  * xuartps_get_mctrl - Get the modem control state
- *
  * @port: Handle to the uart port structure
  *
- * Returns the modem control state
- *
- **/
+ * Return: The modem control state
+ */
 static unsigned int xuartps_get_mctrl(struct uart_port *port)
 {
 	return TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
@@ -996,38 +964,23 @@ static void xuartps_poll_put_char(struct uart_port *port, unsigned char c)
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
@@ -1037,11 +990,10 @@ static struct uart_ops xuartps_ops = {
 static struct uart_port xuartps_port[2];
 
 /**
- * xuartps_get_port - Configure the port from the platform device resource
- *			info
+ * xuartps_get_port - Configure the port from the platform device resource info
  *
- * Returns a pointer to a uart_port or NULL for failure
- **/
+ * Return: Pointer to a uart_port or NULL for failure
+ */
 static struct uart_port *xuartps_get_port(void)
 {
 	struct uart_port *port;
@@ -1072,14 +1024,11 @@ static struct uart_port *xuartps_get_port(void)
 	return port;
 }
 
-/*-----------------------Console driver operations--------------------------*/
-
 #ifdef CONFIG_SERIAL_XILINX_PS_UART_CONSOLE
 /**
  * xuartps_console_wait_tx - Wait for the TX to be full
  * @port: Handle to the uart port structure
- *
- **/
+ */
 static void xuartps_console_wait_tx(struct uart_port *port)
 {
 	while ((xuartps_readl(XUARTPS_SR_OFFSET) & XUARTPS_SR_TXEMPTY)
@@ -1091,8 +1040,7 @@ static void xuartps_console_wait_tx(struct uart_port *port)
  * xuartps_console_putchar - write the character to the FIFO buffer
  * @port: Handle to the uart port structure
  * @ch: Character to be written
- *
- **/
+ */
 static void xuartps_console_putchar(struct uart_port *port, int ch)
 {
 	xuartps_console_wait_tx(port);
@@ -1101,10 +1049,10 @@ static void xuartps_console_putchar(struct uart_port *port, int ch)
 
 /**
  * xuartps_console_write - perform write operation
- * @port: Handle to the uart port structure
+ * @co: Handle to the console
  * @s: Pointer to character array
  * @count: No of characters
- **/
+ */
 static void xuartps_console_write(struct console *co, const char *s,
 				unsigned int count)
 {
@@ -1151,8 +1099,8 @@ static void xuartps_console_write(struct console *co, const char *s,
  * @co: Console handle
  * @options: Initial settings of uart
  *
- * Returns 0, -ENODEV if no device
- **/
+ * Return: 0 on success, negative errno otherwise.
+ */
 static int __init xuartps_console_setup(struct console *co, char *options)
 {
 	struct uart_port *port = &xuartps_port[co->index];
@@ -1190,8 +1138,8 @@ static struct console xuartps_console = {
 /**
  * xuartps_console_init - Initialization call
  *
- * Returns 0 on success, negative error otherwise
- **/
+ * Return: 0 on success, negative error otherwise.
+ */
 static int __init xuartps_console_init(void)
 {
 	register_console(&xuartps_console);
@@ -1202,17 +1150,15 @@ console_initcall(xuartps_console_init);
 
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
 
@@ -1221,7 +1167,7 @@ static struct uart_driver xuartps_uart_driver = {
  * xuartps_suspend - suspend event
  * @device: Pointer to the device structure
  *
- * Returns 0
+ * Return: 0
  */
 static int xuartps_suspend(struct device *device)
 {
@@ -1269,7 +1215,7 @@ static int xuartps_suspend(struct device *device)
  * xuartps_resume - Resume after a previous suspend
  * @device: Pointer to the device structure
  *
- * Returns 0
+ * Return: 0
  */
 static int xuartps_resume(struct device *device)
 {
@@ -1329,15 +1275,12 @@ static int xuartps_resume(struct device *device)
 
 static SIMPLE_DEV_PM_OPS(xuartps_dev_pm_ops, xuartps_suspend, xuartps_resume);
 
-/* ---------------------------------------------------------------------
- * Platform bus binding
- */
 /**
  * xuartps_probe - Platform driver probe
  * @pdev: Pointer to the platform device structure
  *
- * Returns 0 on success, negative error otherwise
- **/
+ * Return: 0 on success, negative error otherwise.
+ */
 static int xuartps_probe(struct platform_device *pdev)
 {
 	int rc;
@@ -1437,8 +1380,8 @@ err_out_clk_dis_aper:
  * xuartps_remove - called when the platform driver is unregistered
  * @pdev: Pointer to the platform device structure
  *
- * Returns 0 on success, negative error otherwise
- **/
+ * Return: 0 on success, negative error otherwise.
+ */
 static int xuartps_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
@@ -1465,24 +1408,16 @@ static struct of_device_id xuartps_of_match[] = {
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
- * Returns whether the registration was successful or not
- **/
 static int __init xuartps_init(void)
 {
 	int retval = 0;
@@ -1500,15 +1435,8 @@ static int __init xuartps_init(void)
 	return retval;
 }
 
-/**
- * xuartps_exit - Driver unregistration call
- **/
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

