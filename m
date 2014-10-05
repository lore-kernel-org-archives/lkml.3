Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaJERUi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:20:38 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:4893 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbaJERUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:20:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsOAAt9MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmmcCfhcBe4QEAQUnLyMQUTkeGYhCAbBMjkcYhiCKJQeESwWGK5cTjFKJLoIggUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: [PATCH 11/13 linux-next] serial: pnx8xxx: use container_of to resolve pnx8xxx_port from uart_port
Date: Sun,  5 Oct 2014 19:19:47 +0200
Message-Id: <1412529589-1753-2-git-send-email-fabf@skynet.be>
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
 drivers/tty/serial/pnx8xxx_uart.c | 48 ++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/serial/pnx8xxx_uart.c b/drivers/tty/serial/pnx8xxx_uart.c
index 2ba24a4..9fd9414 100644
--- a/drivers/tty/serial/pnx8xxx_uart.c
+++ b/drivers/tty/serial/pnx8xxx_uart.c
@@ -126,7 +126,8 @@ static void pnx8xxx_timeout(unsigned long data)
  */
 static void pnx8xxx_stop_tx(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 	u32 ien;
 
 	/* Disable TX intr */
@@ -142,7 +143,8 @@ static void pnx8xxx_stop_tx(struct uart_port *port)
  */
 static void pnx8xxx_start_tx(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 	u32 ien;
 
 	/* Clear all pending TX intr */
@@ -158,7 +160,8 @@ static void pnx8xxx_start_tx(struct uart_port *port)
  */
 static void pnx8xxx_stop_rx(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 	u32 ien;
 
 	/* Disable RX intr */
@@ -174,7 +177,8 @@ static void pnx8xxx_stop_rx(struct uart_port *port)
  */
 static void pnx8xxx_enable_ms(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 
 	mod_timer(&sport->timer, jiffies);
 }
@@ -313,14 +317,16 @@ static irqreturn_t pnx8xxx_int(int irq, void *dev_id)
  */
 static unsigned int pnx8xxx_tx_empty(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 
 	return serial_in(sport, PNX8XXX_FIFO) & PNX8XXX_UART_FIFO_TXFIFO_STA ? 0 : TIOCSER_TEMT;
 }
 
 static unsigned int pnx8xxx_get_mctrl(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 	unsigned int mctrl = TIOCM_DSR;
 	unsigned int msr;
 
@@ -347,7 +353,8 @@ static void pnx8xxx_set_mctrl(struct uart_port *port, unsigned int mctrl)
  */
 static void pnx8xxx_break_ctl(struct uart_port *port, int break_state)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 	unsigned long flags;
 	unsigned int lcr;
 
@@ -363,7 +370,8 @@ static void pnx8xxx_break_ctl(struct uart_port *port, int break_state)
 
 static int pnx8xxx_startup(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 	int retval;
 
 	/*
@@ -397,7 +405,8 @@ static int pnx8xxx_startup(struct uart_port *port)
 
 static void pnx8xxx_shutdown(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 	int lcr;
 
 	/*
@@ -434,7 +443,8 @@ static void
 pnx8xxx_set_termios(struct uart_port *port, struct ktermios *termios,
 		   struct ktermios *old)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 	unsigned long flags;
 	unsigned int lcr_fcr, old_ien, baud, quot;
 	unsigned int old_csize = old ? old->c_cflag & CSIZE : CS8;
@@ -551,7 +561,8 @@ pnx8xxx_set_termios(struct uart_port *port, struct ktermios *termios,
 
 static const char *pnx8xxx_type(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 
 	return sport->port.type == PORT_PNX8XXX ? "PNX8XXX" : NULL;
 }
@@ -561,7 +572,8 @@ static const char *pnx8xxx_type(struct uart_port *port)
  */
 static void pnx8xxx_release_port(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 
 	release_mem_region(sport->port.mapbase, UART_PORT_SIZE);
 }
@@ -571,7 +583,8 @@ static void pnx8xxx_release_port(struct uart_port *port)
  */
 static int pnx8xxx_request_port(struct uart_port *port)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 	return request_mem_region(sport->port.mapbase, UART_PORT_SIZE,
 			"pnx8xxx-uart") != NULL ? 0 : -EBUSY;
 }
@@ -581,7 +594,8 @@ static int pnx8xxx_request_port(struct uart_port *port)
  */
 static void pnx8xxx_config_port(struct uart_port *port, int flags)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 
 	if (flags & UART_CONFIG_TYPE &&
 	    pnx8xxx_request_port(&sport->port) == 0)
@@ -596,7 +610,8 @@ static void pnx8xxx_config_port(struct uart_port *port, int flags)
 static int
 pnx8xxx_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port,	port);
 	int ret = 0;
 
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_PNX8XXX)
@@ -662,7 +677,8 @@ static void __init pnx8xxx_init_ports(void)
 
 static void pnx8xxx_console_putchar(struct uart_port *port, int ch)
 {
-	struct pnx8xxx_port *sport = (struct pnx8xxx_port *)port;
+	struct pnx8xxx_port *sport =
+		container_of(port, struct pnx8xxx_port, port);
 	int status;
 
 	do {
-- 
1.9.1

