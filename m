Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaJEROH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:14:07 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:9966 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbaJEROE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:14:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsOACZ8MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmmcCfhcBe4QEAQUnLyMQUTkeGYhCAbBMjkcYhiCKJQeESwWGK5cTjFKJLoIggUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        sparclinux@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 09/13 linux-next] serial: sunsab: use container_of to resolve uart_sunsu_port from uart_port
Date: Sun,  5 Oct 2014 19:01:10 +0200
Message-Id: <1412528475-1449-10-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412528475-1449-1-git-send-email-fabf@skynet.be>
References: <1412528475-1449-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/tty/serial/sunsab.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index b339fe4..e3b43a4 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -345,7 +345,8 @@ static irqreturn_t sunsab_interrupt(int irq, void *dev_id)
 /* port->lock is not held.  */
 static unsigned int sunsab_tx_empty(struct uart_port *port)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 	int ret;
 
 	/* Do not need a lock for a state test like this.  */
@@ -360,7 +361,8 @@ static unsigned int sunsab_tx_empty(struct uart_port *port)
 /* port->lock held by caller.  */
 static void sunsab_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 
 	if (mctrl & TIOCM_RTS) {
 		up->cached_mode &= ~SAB82532_MODE_FRTS;
@@ -383,7 +385,8 @@ static void sunsab_set_mctrl(struct uart_port *port, unsigned int mctrl)
 /* port->lock is held by caller and interrupts are disabled.  */
 static unsigned int sunsab_get_mctrl(struct uart_port *port)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 	unsigned char val;
 	unsigned int result;
 
@@ -404,7 +407,8 @@ static unsigned int sunsab_get_mctrl(struct uart_port *port)
 /* port->lock held by caller.  */
 static void sunsab_stop_tx(struct uart_port *port)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 
 	up->interrupt_mask1 |= SAB82532_IMR1_XPR;
 	writeb(up->interrupt_mask1, &up->regs->w.imr1);
@@ -432,7 +436,8 @@ static void sunsab_tx_idle(struct uart_sunsab_port *up)
 /* port->lock held by caller.  */
 static void sunsab_start_tx(struct uart_port *port)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 	struct circ_buf *xmit = &up->port.state->xmit;
 	int i;
 
@@ -465,7 +470,8 @@ static void sunsab_start_tx(struct uart_port *port)
 /* port->lock is not held.  */
 static void sunsab_send_xchar(struct uart_port *port, char ch)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 	unsigned long flags;
 
 	if (ch == __DISABLED_CHAR)
@@ -482,7 +488,8 @@ static void sunsab_send_xchar(struct uart_port *port, char ch)
 /* port->lock held by caller.  */
 static void sunsab_stop_rx(struct uart_port *port)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 
 	up->interrupt_mask0 |= SAB82532_IMR0_TCD;
 	writeb(up->interrupt_mask1, &up->regs->w.imr0);
@@ -491,7 +498,8 @@ static void sunsab_stop_rx(struct uart_port *port)
 /* port->lock is not held.  */
 static void sunsab_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 	unsigned long flags;
 	unsigned char val;
 
@@ -514,7 +522,8 @@ static void sunsab_break_ctl(struct uart_port *port, int break_state)
 /* port->lock is not held.  */
 static int sunsab_startup(struct uart_port *port)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 	unsigned long flags;
 	unsigned char tmp;
 	int err = request_irq(up->port.irq, sunsab_interrupt,
@@ -585,7 +594,8 @@ static int sunsab_startup(struct uart_port *port)
 /* port->lock is not held.  */
 static void sunsab_shutdown(struct uart_port *port)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&up->port.lock, flags);
@@ -771,7 +781,8 @@ static void sunsab_convert_to_sab(struct uart_sunsab_port *up, unsigned int cfla
 static void sunsab_set_termios(struct uart_port *port, struct ktermios *termios,
 			       struct ktermios *old)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *) port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 	unsigned long flags;
 	unsigned int baud = uart_get_baud_rate(port, termios, old, 0, 4000000);
 	unsigned int quot = uart_get_divisor(port, baud);
@@ -840,7 +851,8 @@ static struct uart_sunsab_port *sunsab_ports;
 
 static void sunsab_console_putchar(struct uart_port *port, int c)
 {
-	struct uart_sunsab_port *up = (struct uart_sunsab_port *)port;
+	struct uart_sunsab_port *up =
+		container_of(port, struct uart_sunsab_port, port);
 
 	sunsab_tec_wait(up);
 	writeb(c, &up->regs->w.tic);
-- 
1.9.1

