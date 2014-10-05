Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaJERVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:21:10 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:7162 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbaJERVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:21:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsOAAt9MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmmcCfhcBe4QEAQUnLyMQUTkeGYhCAbBMjkcYhiCKJQeESwWdPoxSiS6CIIFFOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        sparclinux@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 12/13 linux-next] serial: use container_of to resolve uart_sunzilog_port from uart_port
Date: Sun,  5 Oct 2014 19:19:48 +0200
Message-Id: <1412529589-1753-3-git-send-email-fabf@skynet.be>
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
 drivers/tty/serial/sunzilog.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index 02df394..844aae7 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -644,7 +644,8 @@ static unsigned int sunzilog_get_mctrl(struct uart_port *port)
 /* The port lock is held and interrupts are disabled.  */
 static void sunzilog_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *) port;
+	struct uart_sunzilog_port *up =
+		container_of(port, struct uart_sunzilog_port, port);
 	struct zilog_channel __iomem *channel = ZILOG_CHANNEL_FROM_PORT(port);
 	unsigned char set_bits, clear_bits;
 
@@ -668,7 +669,8 @@ static void sunzilog_set_mctrl(struct uart_port *port, unsigned int mctrl)
 /* The port lock is held and interrupts are disabled.  */
 static void sunzilog_stop_tx(struct uart_port *port)
 {
-	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *) port;
+	struct uart_sunzilog_port *up =
+		container_of(port, struct uart_sunzilog_port, port);
 
 	up->flags |= SUNZILOG_FLAG_TX_STOPPED;
 }
@@ -676,7 +678,8 @@ static void sunzilog_stop_tx(struct uart_port *port)
 /* The port lock is held and interrupts are disabled.  */
 static void sunzilog_start_tx(struct uart_port *port)
 {
-	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *) port;
+	struct uart_sunzilog_port *up =
+		container_of(port, struct uart_sunzilog_port, port);
 	struct zilog_channel __iomem *channel = ZILOG_CHANNEL_FROM_PORT(port);
 	unsigned char status;
 
@@ -736,7 +739,8 @@ static void sunzilog_stop_rx(struct uart_port *port)
 /* The port lock is held.  */
 static void sunzilog_enable_ms(struct uart_port *port)
 {
-	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *) port;
+	struct uart_sunzilog_port *up =
+		container_of(port, struct uart_sunzilog_port, port);
 	struct zilog_channel __iomem *channel = ZILOG_CHANNEL_FROM_PORT(port);
 	unsigned char new_reg;
 
@@ -752,7 +756,8 @@ static void sunzilog_enable_ms(struct uart_port *port)
 /* The port lock is not held.  */
 static void sunzilog_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *) port;
+	struct uart_sunzilog_port *up =
+		container_of(port, struct uart_sunzilog_port, port);
 	struct zilog_channel __iomem *channel = ZILOG_CHANNEL_FROM_PORT(port);
 	unsigned char set_bits, clear_bits, new_reg;
 	unsigned long flags;
@@ -938,7 +943,8 @@ static void
 sunzilog_set_termios(struct uart_port *port, struct ktermios *termios,
 		     struct ktermios *old)
 {
-	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *) port;
+	struct uart_sunzilog_port *up =
+		container_of(port, struct uart_sunzilog_port, port);
 	unsigned long flags;
 	int baud, brg;
 
@@ -998,7 +1004,8 @@ static int sunzilog_verify_port(struct uart_port *port, struct serial_struct *se
 static int sunzilog_get_poll_char(struct uart_port *port)
 {
 	unsigned char ch, r1;
-	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *) port;
+	struct uart_sunzilog_port *up =
+		container_of(port, struct uart_sunzilog_port, port);
 	struct zilog_channel __iomem *channel
 		= ZILOG_CHANNEL_FROM_PORT(&up->port);
 
@@ -1032,7 +1039,8 @@ static int sunzilog_get_poll_char(struct uart_port *port)
 static void sunzilog_put_poll_char(struct uart_port *port,
 			unsigned char ch)
 {
-	struct uart_sunzilog_port *up = (struct uart_sunzilog_port *)port;
+	struct uart_sunzilog_port *up =
+		container_of(port, struct uart_sunzilog_port, port);
 
 	sunzilog_putchar(&up->port, ch);
 }
-- 
1.9.1

