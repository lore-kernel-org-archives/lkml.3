Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823AbaJERUR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:20:17 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:62025 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648AbaJERUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:20:14 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsOAAt9MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmmcCfhcBe4QEAQUnLyMQRgs5HhmIQgGwTI5HGIYgiiUHhEsFhiuXE4xSiS6CIIFFOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: [PATCH 10/13 linux-next] serial: amba-pl010: use container_of to resolve uart_amba_port from uart_port
Date: Sun,  5 Oct 2014 19:19:46 +0200
Message-Id: <1412529589-1753-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412528475-1449-1-git-send-email-fabf@skynet.be>
References: <1412528475-1449-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/tty/serial/amba-pl010.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/amba-pl010.c b/drivers/tty/serial/amba-pl010.c
index 2064d31..00ae8dc 100644
--- a/drivers/tty/serial/amba-pl010.c
+++ b/drivers/tty/serial/amba-pl010.c
@@ -75,7 +75,8 @@ struct uart_amba_port {
 
 static void pl010_stop_tx(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 	unsigned int cr;
 
 	cr = readb(uap->port.membase + UART010_CR);
@@ -85,7 +86,8 @@ static void pl010_stop_tx(struct uart_port *port)
 
 static void pl010_start_tx(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 	unsigned int cr;
 
 	cr = readb(uap->port.membase + UART010_CR);
@@ -95,7 +97,8 @@ static void pl010_start_tx(struct uart_port *port)
 
 static void pl010_stop_rx(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 	unsigned int cr;
 
 	cr = readb(uap->port.membase + UART010_CR);
@@ -105,7 +108,8 @@ static void pl010_stop_rx(struct uart_port *port)
 
 static void pl010_enable_ms(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 	unsigned int cr;
 
 	cr = readb(uap->port.membase + UART010_CR);
@@ -259,14 +263,16 @@ static irqreturn_t pl010_int(int irq, void *dev_id)
 
 static unsigned int pl010_tx_empty(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 	unsigned int status = readb(uap->port.membase + UART01x_FR);
 	return status & UART01x_FR_BUSY ? 0 : TIOCSER_TEMT;
 }
 
 static unsigned int pl010_get_mctrl(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 	unsigned int result = 0;
 	unsigned int status;
 
@@ -283,7 +289,8 @@ static unsigned int pl010_get_mctrl(struct uart_port *port)
 
 static void pl010_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 
 	if (uap->data)
 		uap->data->set_mctrl(uap->dev, uap->port.membase, mctrl);
@@ -291,7 +298,8 @@ static void pl010_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 static void pl010_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 	unsigned long flags;
 	unsigned int lcr_h;
 
@@ -307,7 +315,8 @@ static void pl010_break_ctl(struct uart_port *port, int break_state)
 
 static int pl010_startup(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 	int retval;
 
 	/*
@@ -347,7 +356,8 @@ static int pl010_startup(struct uart_port *port)
 
 static void pl010_shutdown(struct uart_port *port)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 
 	/*
 	 * Free the interrupt
@@ -374,7 +384,8 @@ static void
 pl010_set_termios(struct uart_port *port, struct ktermios *termios,
 		     struct ktermios *old)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 	unsigned int lcr_h, old_cr;
 	unsigned long flags;
 	unsigned int baud, quot;
@@ -551,7 +562,8 @@ static struct uart_amba_port *amba_ports[UART_NR];
 
 static void pl010_console_putchar(struct uart_port *port, int ch)
 {
-	struct uart_amba_port *uap = (struct uart_amba_port *)port;
+	struct uart_amba_port *uap =
+		container_of(port, struct uart_amba_port, port);
 	unsigned int status;
 
 	do {
-- 
1.9.1

