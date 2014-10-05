Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaJERKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:10:34 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:21930 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbaJERKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:10:30 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsOAMV6MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmmcCfhcBe4QEAQUnLyMQUTkeGYhCAbBMjkgYhiCKJQeESwWGK5cTjFKJLoIggUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Subject: [PATCH 06/13 linux-next] TTY: jsm: use container_of to resolve jsm_channel from uart_port
Date: Sun,  5 Oct 2014 19:01:07 +0200
Message-Id: <1412528475-1449-7-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412528475-1449-1-git-send-email-fabf@skynet.be>
References: <1412528475-1449-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/tty/serial/jsm/jsm_tty.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index 3e5c156..8814680 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -77,7 +77,8 @@ static unsigned int jsm_tty_tx_empty(struct uart_port *port)
 static unsigned int jsm_tty_get_mctrl(struct uart_port *port)
 {
 	int result;
-	struct jsm_channel *channel = (struct jsm_channel *)port;
+	struct jsm_channel *channel =
+		container_of(port, struct jsm_channel, uart_port);
 
 	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "start\n");
 
@@ -98,7 +99,8 @@ static unsigned int jsm_tty_get_mctrl(struct uart_port *port)
  */
 static void jsm_tty_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct jsm_channel *channel = (struct jsm_channel *)port;
+	struct jsm_channel *channel =
+		container_of(port, struct jsm_channel, uart_port);
 
 	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "start\n");
 
@@ -133,7 +135,8 @@ static void jsm_tty_write(struct uart_port *port)
 
 static void jsm_tty_start_tx(struct uart_port *port)
 {
-	struct jsm_channel *channel = (struct jsm_channel *)port;
+	struct jsm_channel *channel =
+		container_of(port, struct jsm_channel, uart_port);
 
 	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "start\n");
 
@@ -145,7 +148,8 @@ static void jsm_tty_start_tx(struct uart_port *port)
 
 static void jsm_tty_stop_tx(struct uart_port *port)
 {
-	struct jsm_channel *channel = (struct jsm_channel *)port;
+	struct jsm_channel *channel =
+		container_of(port, struct jsm_channel, uart_port);
 
 	jsm_dbg(IOCTL, &channel->ch_bd->pci_dev, "start\n");
 
@@ -157,7 +161,8 @@ static void jsm_tty_stop_tx(struct uart_port *port)
 static void jsm_tty_send_xchar(struct uart_port *port, char ch)
 {
 	unsigned long lock_flags;
-	struct jsm_channel *channel = (struct jsm_channel *)port;
+	struct jsm_channel *channel =
+		container_of(port, struct jsm_channel, uart_port);
 	struct ktermios *termios;
 
 	spin_lock_irqsave(&port->lock, lock_flags);
@@ -172,7 +177,8 @@ static void jsm_tty_send_xchar(struct uart_port *port, char ch)
 
 static void jsm_tty_stop_rx(struct uart_port *port)
 {
-	struct jsm_channel *channel = (struct jsm_channel *)port;
+	struct jsm_channel *channel =
+		container_of(port, struct jsm_channel, uart_port);
 
 	channel->ch_bd->bd_ops->disable_receiver(channel);
 }
@@ -180,7 +186,8 @@ static void jsm_tty_stop_rx(struct uart_port *port)
 static void jsm_tty_break(struct uart_port *port, int break_state)
 {
 	unsigned long lock_flags;
-	struct jsm_channel *channel = (struct jsm_channel *)port;
+	struct jsm_channel *channel =
+		container_of(port, struct jsm_channel, uart_port);
 
 	spin_lock_irqsave(&port->lock, lock_flags);
 	if (break_state == -1)
@@ -194,7 +201,8 @@ static void jsm_tty_break(struct uart_port *port, int break_state)
 static int jsm_tty_open(struct uart_port *port)
 {
 	struct jsm_board *brd;
-	struct jsm_channel *channel = (struct jsm_channel *)port;
+	struct jsm_channel *channel =
+		container_of(port, struct jsm_channel, uart_port);
 	struct ktermios *termios;
 
 	/* Get board pointer from our array of majors we have allocated */
@@ -273,7 +281,8 @@ static void jsm_tty_close(struct uart_port *port)
 {
 	struct jsm_board *bd;
 	struct ktermios *ts;
-	struct jsm_channel *channel = (struct jsm_channel *)port;
+	struct jsm_channel *channel =
+		container_of(port, struct jsm_channel, uart_port);
 
 	jsm_dbg(CLOSE, &channel->ch_bd->pci_dev, "start\n");
 
@@ -307,7 +316,8 @@ static void jsm_tty_set_termios(struct uart_port *port,
 				 struct ktermios *old_termios)
 {
 	unsigned long lock_flags;
-	struct jsm_channel *channel = (struct jsm_channel *)port;
+	struct jsm_channel *channel =
+		container_of(port, struct jsm_channel, uart_port);
 
 	spin_lock_irqsave(&port->lock, lock_flags);
 	channel->ch_c_cflag	= termios->c_cflag;
-- 
1.9.1

