Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbaJERFk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:05:40 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:50677 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751662AbaJERFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:05:37 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsOAJF5MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmmcCfhcBe4QEAQUnLyMQUTkeGYhCAbBLjkcYhiCKJQeESwWdPoxSiS6CIIFFOy+CSgEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: [PATCH 03/13 linux-next] serial: use container_of to resolve uart_ip22zilog_port from uart_port
Date: Sun,  5 Oct 2014 19:01:04 +0200
Message-Id: <1412528475-1449-4-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412528475-1449-1-git-send-email-fabf@skynet.be>
References: <1412528475-1449-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/tty/serial/ip22zilog.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/ip22zilog.c b/drivers/tty/serial/ip22zilog.c
index 99b7b86..991e6dc 100644
--- a/drivers/tty/serial/ip22zilog.c
+++ b/drivers/tty/serial/ip22zilog.c
@@ -544,7 +544,8 @@ static unsigned int ip22zilog_get_mctrl(struct uart_port *port)
 /* The port lock is held and interrupts are disabled.  */
 static void ip22zilog_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_ip22zilog_port *up = (struct uart_ip22zilog_port *) port;
+	struct uart_ip22zilog_port *up =
+		container_of(port, struct uart_ip22zilog_port, port);
 	struct zilog_channel *channel = ZILOG_CHANNEL_FROM_PORT(port);
 	unsigned char set_bits, clear_bits;
 
@@ -568,7 +569,8 @@ static void ip22zilog_set_mctrl(struct uart_port *port, unsigned int mctrl)
 /* The port lock is held and interrupts are disabled.  */
 static void ip22zilog_stop_tx(struct uart_port *port)
 {
-	struct uart_ip22zilog_port *up = (struct uart_ip22zilog_port *) port;
+	struct uart_ip22zilog_port *up =
+		container_of(port, struct uart_ip22zilog_port, port);
 
 	up->flags |= IP22ZILOG_FLAG_TX_STOPPED;
 }
@@ -576,7 +578,8 @@ static void ip22zilog_stop_tx(struct uart_port *port)
 /* The port lock is held and interrupts are disabled.  */
 static void ip22zilog_start_tx(struct uart_port *port)
 {
-	struct uart_ip22zilog_port *up = (struct uart_ip22zilog_port *) port;
+	struct uart_ip22zilog_port *up =
+		container_of(port, struct uart_ip22zilog_port, port);
 	struct zilog_channel *channel = ZILOG_CHANNEL_FROM_PORT(port);
 	unsigned char status;
 
@@ -636,7 +639,8 @@ static void ip22zilog_stop_rx(struct uart_port *port)
 /* The port lock is held.  */
 static void ip22zilog_enable_ms(struct uart_port *port)
 {
-	struct uart_ip22zilog_port *up = (struct uart_ip22zilog_port *) port;
+	struct uart_ip22zilog_port *up =
+		container_of(port, struct uart_ip22zilog_port, port);
 	struct zilog_channel *channel = ZILOG_CHANNEL_FROM_PORT(port);
 	unsigned char new_reg;
 
@@ -652,7 +656,8 @@ static void ip22zilog_enable_ms(struct uart_port *port)
 /* The port lock is not held.  */
 static void ip22zilog_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_ip22zilog_port *up = (struct uart_ip22zilog_port *) port;
+	struct uart_ip22zilog_port *up =
+		container_of(port, struct uart_ip22zilog_port, port);
 	struct zilog_channel *channel = ZILOG_CHANNEL_FROM_PORT(port);
 	unsigned char set_bits, clear_bits, new_reg;
 	unsigned long flags;
@@ -873,7 +878,8 @@ static void
 ip22zilog_set_termios(struct uart_port *port, struct ktermios *termios,
 		      struct ktermios *old)
 {
-	struct uart_ip22zilog_port *up = (struct uart_ip22zilog_port *) port;
+	struct uart_ip22zilog_port *up =
+		container_of(port, struct uart_ip22zilog_port, port);
 	unsigned long flags;
 	int baud, brg;
 
-- 
1.9.1

