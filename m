Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaJERDX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:03:23 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:4974 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbaJERDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:03:22 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsOAJ14MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmmcCfhcBe4QEAQUnLyMQUTkeGYhCAbBLjkcYhiCKJQeESwWGK5cTjFKJLoIggUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: [PATCH 01/13 linux-next] serial: use container_of to resolve uart_sio_port from uart_port
Date: Sun,  5 Oct 2014 19:01:02 +0200
Message-Id: <1412528475-1449-2-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412528475-1449-1-git-send-email-fabf@skynet.be>
References: <1412528475-1449-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/tty/serial/m32r_sio.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
index 5702828..8f7f83a 100644
--- a/drivers/tty/serial/m32r_sio.c
+++ b/drivers/tty/serial/m32r_sio.c
@@ -249,7 +249,8 @@ static void serial_out(struct uart_sio_port *up, int offset, int value)
 
 static void m32r_sio_stop_tx(struct uart_port *port)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 
 	if (up->ier & UART_IER_THRI) {
 		up->ier &= ~UART_IER_THRI;
@@ -260,7 +261,8 @@ static void m32r_sio_stop_tx(struct uart_port *port)
 static void m32r_sio_start_tx(struct uart_port *port)
 {
 #ifdef CONFIG_SERIAL_M32R_PLDSIO
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 	struct circ_buf *xmit = &up->port.state->xmit;
 
 	if (!(up->ier & UART_IER_THRI)) {
@@ -274,7 +276,8 @@ static void m32r_sio_start_tx(struct uart_port *port)
 	}
 	while((serial_in(up, UART_LSR) & UART_EMPTY) != UART_EMPTY);
 #else
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 
 	if (!(up->ier & UART_IER_THRI)) {
 		up->ier |= UART_IER_THRI;
@@ -285,7 +288,8 @@ static void m32r_sio_start_tx(struct uart_port *port)
 
 static void m32r_sio_stop_rx(struct uart_port *port)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 
 	up->ier &= ~UART_IER_RLSI;
 	up->port.read_status_mask &= ~UART_LSR_DR;
@@ -294,7 +298,8 @@ static void m32r_sio_stop_rx(struct uart_port *port)
 
 static void m32r_sio_enable_ms(struct uart_port *port)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 
 	up->ier |= UART_IER_MSI;
 	serial_out(up, UART_IER, up->ier);
@@ -581,7 +586,8 @@ static void m32r_sio_timeout(unsigned long data)
 
 static unsigned int m32r_sio_tx_empty(struct uart_port *port)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 	unsigned long flags;
 	unsigned int ret;
 
@@ -609,7 +615,8 @@ static void m32r_sio_break_ctl(struct uart_port *port, int break_state)
 
 static int m32r_sio_startup(struct uart_port *port)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 	int retval;
 
 	sio_init();
@@ -652,7 +659,8 @@ static int m32r_sio_startup(struct uart_port *port)
 
 static void m32r_sio_shutdown(struct uart_port *port)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 
 	/*
 	 * Disable interrupts from this port
@@ -681,7 +689,8 @@ static unsigned int m32r_sio_get_divisor(struct uart_port *port,
 static void m32r_sio_set_termios(struct uart_port *port,
 	struct ktermios *termios, struct ktermios *old)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 	unsigned char cval = 0;
 	unsigned long flags;
 	unsigned int baud, quot;
@@ -780,7 +789,8 @@ static void m32r_sio_set_termios(struct uart_port *port,
 static void m32r_sio_pm(struct uart_port *port, unsigned int state,
 	unsigned int oldstate)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 
 	if (up->pm)
 		up->pm(port, state, oldstate);
@@ -825,7 +835,8 @@ m32r_sio_request_std_resource(struct uart_sio_port *up, struct resource **res)
 
 static void m32r_sio_release_port(struct uart_port *port)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 	unsigned long start, offset = 0, size = 0;
 
 	size <<= up->port.regshift;
@@ -862,7 +873,8 @@ static void m32r_sio_release_port(struct uart_port *port)
 
 static int m32r_sio_request_port(struct uart_port *port)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 	struct resource *res = NULL;
 	int ret = 0;
 
@@ -889,7 +901,8 @@ static int m32r_sio_request_port(struct uart_port *port)
 
 static void m32r_sio_config_port(struct uart_port *port, int unused)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&up->port.lock, flags);
@@ -1000,7 +1013,8 @@ static inline void wait_for_xmitr(struct uart_sio_port *up)
 
 static void m32r_sio_console_putchar(struct uart_port *port, int ch)
 {
-	struct uart_sio_port *up = (struct uart_sio_port *)port;
+	struct uart_sio_port *up =
+		container_of(port, struct uart_sio_port, port);
 
 	wait_for_xmitr(up);
 	sio_out(up, SIOTXB, ch);
-- 
1.9.1

