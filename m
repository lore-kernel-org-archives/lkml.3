Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaJERVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:21:45 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:28853 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765AbaJERVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:21:41 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkMOAAt9MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmSmBPgJ+FwF7hAQBBScvIxBGCzkeGYhCAbBMjkcYhiCKJQeESwWGK5cTjFKJLoIggUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: [PATCH 13/13 linux-next] tty: ar933x_uart: use container_of to resolve ar933x_uart_port from uart_port
Date: Sun,  5 Oct 2014 19:19:49 +0200
Message-Id: <1412529589-1753-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412529589-1753-1-git-send-email-fabf@skynet.be>
References: <1412528475-1449-1-git-send-email-fabf@skynet.be>
 <1412529589-1753-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/tty/serial/ar933x_uart.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/ar933x_uart.c b/drivers/tty/serial/ar933x_uart.c
index 0be1c45..2739361 100644
--- a/drivers/tty/serial/ar933x_uart.c
+++ b/drivers/tty/serial/ar933x_uart.c
@@ -119,7 +119,8 @@ static inline void ar933x_uart_putc(struct ar933x_uart_port *up, int ch)
 
 static unsigned int ar933x_uart_tx_empty(struct uart_port *port)
 {
-	struct ar933x_uart_port *up = (struct ar933x_uart_port *) port;
+	struct ar933x_uart_port *up =
+		container_of(port, struct ar933x_uart_port, port);
 	unsigned long flags;
 	unsigned int rdata;
 
@@ -141,21 +142,24 @@ static void ar933x_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 static void ar933x_uart_start_tx(struct uart_port *port)
 {
-	struct ar933x_uart_port *up = (struct ar933x_uart_port *) port;
+	struct ar933x_uart_port *up =
+		container_of(port, struct ar933x_uart_port, port);
 
 	ar933x_uart_start_tx_interrupt(up);
 }
 
 static void ar933x_uart_stop_tx(struct uart_port *port)
 {
-	struct ar933x_uart_port *up = (struct ar933x_uart_port *) port;
+	struct ar933x_uart_port *up =
+		container_of(port, struct ar933x_uart_port, port);
 
 	ar933x_uart_stop_tx_interrupt(up);
 }
 
 static void ar933x_uart_stop_rx(struct uart_port *port)
 {
-	struct ar933x_uart_port *up = (struct ar933x_uart_port *) port;
+	struct ar933x_uart_port *up =
+		container_of(port, struct ar933x_uart_port, port);
 
 	up->ier &= ~AR933X_UART_INT_RX_VALID;
 	ar933x_uart_write(up, AR933X_UART_INT_EN_REG, up->ier);
@@ -163,7 +167,8 @@ static void ar933x_uart_stop_rx(struct uart_port *port)
 
 static void ar933x_uart_break_ctl(struct uart_port *port, int break_state)
 {
-	struct ar933x_uart_port *up = (struct ar933x_uart_port *) port;
+	struct ar933x_uart_port *up =
+		container_of(port, struct ar933x_uart_port, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&up->port.lock, flags);
@@ -231,7 +236,8 @@ static void ar933x_uart_set_termios(struct uart_port *port,
 				    struct ktermios *new,
 				    struct ktermios *old)
 {
-	struct ar933x_uart_port *up = (struct ar933x_uart_port *) port;
+	struct ar933x_uart_port *up =
+		container_of(port, struct ar933x_uart_port, port);
 	unsigned int cs;
 	unsigned long flags;
 	unsigned int baud, scale, step;
@@ -404,7 +410,8 @@ static irqreturn_t ar933x_uart_interrupt(int irq, void *dev_id)
 
 static int ar933x_uart_startup(struct uart_port *port)
 {
-	struct ar933x_uart_port *up = (struct ar933x_uart_port *) port;
+	struct ar933x_uart_port *up =
+		container_of(port, struct ar933x_uart_port, port);
 	unsigned long flags;
 	int ret;
 
@@ -430,7 +437,8 @@ static int ar933x_uart_startup(struct uart_port *port)
 
 static void ar933x_uart_shutdown(struct uart_port *port)
 {
-	struct ar933x_uart_port *up = (struct ar933x_uart_port *) port;
+	struct ar933x_uart_port *up =
+		container_of(port, struct ar933x_uart_port, port);
 
 	/* Disable all interrupts */
 	up->ier = 0;
@@ -468,7 +476,8 @@ static void ar933x_uart_config_port(struct uart_port *port, int flags)
 static int ar933x_uart_verify_port(struct uart_port *port,
 				   struct serial_struct *ser)
 {
-	struct ar933x_uart_port *up = (struct ar933x_uart_port *) port;
+	struct ar933x_uart_port *up =
+		container_of(port, struct ar933x_uart_port, port);
 
 	if (ser->type != PORT_UNKNOWN &&
 	    ser->type != PORT_AR933X)
@@ -521,7 +530,8 @@ static void ar933x_uart_wait_xmitr(struct ar933x_uart_port *up)
 
 static void ar933x_uart_console_putchar(struct uart_port *port, int ch)
 {
-	struct ar933x_uart_port *up = (struct ar933x_uart_port *) port;
+	struct ar933x_uart_port *up =
+		container_of(port, struct ar933x_uart_port, port);
 
 	ar933x_uart_wait_xmitr(up);
 	ar933x_uart_putc(up, ch);
-- 
1.9.1

