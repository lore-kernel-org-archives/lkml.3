Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaJERFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:05:13 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:53452 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbaJERFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:05:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsOAJF5MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmmcCfhcBe4QEAQUnLyMQUTkeGYhCAbBLjkcYhiCKJQeESwWGK5cTjFKJLoIggUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: [PATCH 02/13 linux-next] serial: sa1100: use container_of to resolve sa1100_port from uart_port
Date: Sun,  5 Oct 2014 19:01:03 +0200
Message-Id: <1412528475-1449-3-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412528475-1449-1-git-send-email-fabf@skynet.be>
References: <1412528475-1449-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/tty/serial/sa1100.c | 45 ++++++++++++++++++++++++++++++---------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/serial/sa1100.c b/drivers/tty/serial/sa1100.c
index 753d452..4eb24fe 100644
--- a/drivers/tty/serial/sa1100.c
+++ b/drivers/tty/serial/sa1100.c
@@ -142,7 +142,8 @@ static void sa1100_timeout(unsigned long data)
  */
 static void sa1100_stop_tx(struct uart_port *port)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 	u32 utcr3;
 
 	utcr3 = UART_GET_UTCR3(sport);
@@ -155,7 +156,8 @@ static void sa1100_stop_tx(struct uart_port *port)
  */
 static void sa1100_start_tx(struct uart_port *port)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 	u32 utcr3;
 
 	utcr3 = UART_GET_UTCR3(sport);
@@ -168,7 +170,8 @@ static void sa1100_start_tx(struct uart_port *port)
  */
 static void sa1100_stop_rx(struct uart_port *port)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 	u32 utcr3;
 
 	utcr3 = UART_GET_UTCR3(sport);
@@ -180,7 +183,8 @@ static void sa1100_stop_rx(struct uart_port *port)
  */
 static void sa1100_enable_ms(struct uart_port *port)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 
 	mod_timer(&sport->timer, jiffies);
 }
@@ -323,7 +327,8 @@ static irqreturn_t sa1100_int(int irq, void *dev_id)
  */
 static unsigned int sa1100_tx_empty(struct uart_port *port)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 
 	return UART_GET_UTSR1(sport) & UTSR1_TBY ? 0 : TIOCSER_TEMT;
 }
@@ -342,7 +347,8 @@ static void sa1100_set_mctrl(struct uart_port *port, unsigned int mctrl)
  */
 static void sa1100_break_ctl(struct uart_port *port, int break_state)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 	unsigned long flags;
 	unsigned int utcr3;
 
@@ -358,7 +364,8 @@ static void sa1100_break_ctl(struct uart_port *port, int break_state)
 
 static int sa1100_startup(struct uart_port *port)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 	int retval;
 
 	/*
@@ -387,7 +394,8 @@ static int sa1100_startup(struct uart_port *port)
 
 static void sa1100_shutdown(struct uart_port *port)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 
 	/*
 	 * Stop our timer.
@@ -409,7 +417,8 @@ static void
 sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
 		   struct ktermios *old)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 	unsigned long flags;
 	unsigned int utcr0, old_utcr3, baud, quot;
 	unsigned int old_csize = old ? old->c_cflag & CSIZE : CS8;
@@ -512,7 +521,8 @@ sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
 
 static const char *sa1100_type(struct uart_port *port)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 
 	return sport->port.type == PORT_SA1100 ? "SA1100" : NULL;
 }
@@ -522,7 +532,8 @@ static const char *sa1100_type(struct uart_port *port)
  */
 static void sa1100_release_port(struct uart_port *port)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 
 	release_mem_region(sport->port.mapbase, UART_PORT_SIZE);
 }
@@ -532,7 +543,8 @@ static void sa1100_release_port(struct uart_port *port)
  */
 static int sa1100_request_port(struct uart_port *port)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 
 	return request_mem_region(sport->port.mapbase, UART_PORT_SIZE,
 			"sa11x0-uart") != NULL ? 0 : -EBUSY;
@@ -543,7 +555,8 @@ static int sa1100_request_port(struct uart_port *port)
  */
 static void sa1100_config_port(struct uart_port *port, int flags)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 
 	if (flags & UART_CONFIG_TYPE &&
 	    sa1100_request_port(&sport->port) == 0)
@@ -558,7 +571,8 @@ static void sa1100_config_port(struct uart_port *port, int flags)
 static int
 sa1100_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 	int ret = 0;
 
 	if (ser->type != PORT_UNKNOWN && ser->type != PORT_SA1100)
@@ -691,7 +705,8 @@ void __init sa1100_register_uart(int idx, int port)
 #ifdef CONFIG_SERIAL_SA1100_CONSOLE
 static void sa1100_console_putchar(struct uart_port *port, int ch)
 {
-	struct sa1100_port *sport = (struct sa1100_port *)port;
+	struct sa1100_port *sport =
+		container_of(port, struct sa1100_port, port);
 
 	while (!(UART_GET_UTSR1(sport) & UTSR1_TNF))
 		barrier();
-- 
1.9.1

