Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918AbaJERGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:06:40 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:45195 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbaJERGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:06:36 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjsOAJF5MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmmcCfhcBe4QEAQUnLyMQUTkeGYhCAbBLjkcYhiCKJQeESwWGK5cTjFKJLoIggUU7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: [PATCH 04/13 linux-next] serial: mpsc: use container_of to resolve mpsc_port_info from uart_port
Date: Sun,  5 Oct 2014 19:01:05 +0200
Message-Id: <1412528475-1449-5-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412528475-1449-1-git-send-email-fabf@skynet.be>
References: <1412528475-1449-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/tty/serial/mpsc.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/tty/serial/mpsc.c b/drivers/tty/serial/mpsc.c
index ae49856..5d5499b 100644
--- a/drivers/tty/serial/mpsc.c
+++ b/drivers/tty/serial/mpsc.c
@@ -1246,7 +1246,8 @@ static irqreturn_t mpsc_sdma_intr(int irq, void *dev_id)
  */
 static uint mpsc_tx_empty(struct uart_port *port)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 	ulong iflags;
 	uint rc;
 
@@ -1264,7 +1265,8 @@ static void mpsc_set_mctrl(struct uart_port *port, uint mctrl)
 
 static uint mpsc_get_mctrl(struct uart_port *port)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 	u32 mflags, status;
 
 	status = (pi->mirror_regs) ? pi->MPSC_CHR_10_m
@@ -1281,7 +1283,8 @@ static uint mpsc_get_mctrl(struct uart_port *port)
 
 static void mpsc_stop_tx(struct uart_port *port)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 
 	pr_debug("mpsc_stop_tx[%d]\n", port->line);
 
@@ -1290,7 +1293,8 @@ static void mpsc_stop_tx(struct uart_port *port)
 
 static void mpsc_start_tx(struct uart_port *port)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 	unsigned long iflags;
 
 	spin_lock_irqsave(&pi->tx_lock, iflags);
@@ -1316,7 +1320,8 @@ static void mpsc_start_rx(struct mpsc_port_info *pi)
 
 static void mpsc_stop_rx(struct uart_port *port)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 
 	pr_debug("mpsc_stop_rx[%d]: Stopping...\n", port->line);
 
@@ -1338,7 +1343,8 @@ static void mpsc_stop_rx(struct uart_port *port)
 
 static void mpsc_break_ctl(struct uart_port *port, int ctl)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 	ulong	flags;
 	u32	v;
 
@@ -1353,7 +1359,8 @@ static void mpsc_break_ctl(struct uart_port *port, int ctl)
 
 static int mpsc_startup(struct uart_port *port)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 	u32 flag = 0;
 	int rc;
 
@@ -1383,7 +1390,8 @@ static int mpsc_startup(struct uart_port *port)
 
 static void mpsc_shutdown(struct uart_port *port)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 
 	pr_debug("mpsc_shutdown[%d]: Shutting down MPSC\n", port->line);
 
@@ -1394,7 +1402,8 @@ static void mpsc_shutdown(struct uart_port *port)
 static void mpsc_set_termios(struct uart_port *port, struct ktermios *termios,
 		 struct ktermios *old)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 	u32 baud;
 	ulong flags;
 	u32 chr_bits, stop_bits, par;
@@ -1498,7 +1507,8 @@ static int mpsc_request_port(struct uart_port *port)
 
 static void mpsc_release_port(struct uart_port *port)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 
 	if (pi->ready) {
 		mpsc_uninit_rings(pi);
@@ -1513,7 +1523,8 @@ static void mpsc_config_port(struct uart_port *port, int flags)
 
 static int mpsc_verify_port(struct uart_port *port, struct serial_struct *ser)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 	int rc = 0;
 
 	pr_debug("mpsc_verify_port[%d]: Verifying port data\n", pi->port.line);
@@ -1548,7 +1559,8 @@ static void mpsc_put_poll_char(struct uart_port *port,
 
 static int mpsc_get_poll_char(struct uart_port *port)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 	struct mpsc_rx_desc *rxre;
 	u32	cmdstat, bytes_in, i;
 	u8	*bp;
@@ -1648,7 +1660,8 @@ static int mpsc_get_poll_char(struct uart_port *port)
 static void mpsc_put_poll_char(struct uart_port *port,
 			 unsigned char c)
 {
-	struct mpsc_port_info *pi = (struct mpsc_port_info *)port;
+	struct mpsc_port_info *pi =
+		container_of(port, struct mpsc_port_info, port);
 	u32 data;
 
 	data = readl(pi->mpsc_base + MPSC_MPCR);
-- 
1.9.1

