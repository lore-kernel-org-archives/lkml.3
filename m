Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaJERHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 13:07:54 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:12217 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbaJERHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 13:07:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkIOAJF5MVRbsHoL/2dsb2JhbABegw6BK7d1AQEBAQEBBQFzmSmBPgJ+FwF7hAQBBScvIxBROR4ZiEIBsEuORxiGIIolB4RLBYYrlxOMUokugiCBRTsvgkoBAQE
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabian Frederick <fabf@skynet.be>, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org
Subject: [PATCH 05/13 linux-next] serial: cpm_uart: use container_of to resolve uart_cpm_port from uart_port
Date: Sun,  5 Oct 2014 19:01:06 +0200
Message-Id: <1412528475-1449-6-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412528475-1449-1-git-send-email-fabf@skynet.be>
References: <1412528475-1449-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use container_of instead of casting first structure member.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/tty/serial/cpm_uart/cpm_uart_core.c | 48 +++++++++++++++++++----------
 1 file changed, 32 insertions(+), 16 deletions(-)

diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index 533852e..638afd3 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -80,7 +80,8 @@ static void cpm_uart_initbd(struct uart_cpm_port *pinfo);
 */
 static unsigned int cpm_uart_tx_empty(struct uart_port *port)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 	cbd_t __iomem *bdp = pinfo->tx_bd_base;
 	int ret = 0;
 
@@ -102,7 +103,8 @@ static unsigned int cpm_uart_tx_empty(struct uart_port *port)
 
 static void cpm_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 
 	if (pinfo->gpios[GPIO_RTS] >= 0)
 		gpio_set_value(pinfo->gpios[GPIO_RTS], !(mctrl & TIOCM_RTS));
@@ -113,7 +115,8 @@ static void cpm_uart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 static unsigned int cpm_uart_get_mctrl(struct uart_port *port)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 	unsigned int mctrl = TIOCM_CTS | TIOCM_DSR | TIOCM_CAR;
 
 	if (pinfo->gpios[GPIO_CTS] >= 0) {
@@ -144,7 +147,8 @@ static unsigned int cpm_uart_get_mctrl(struct uart_port *port)
  */
 static void cpm_uart_stop_tx(struct uart_port *port)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 	smc_t __iomem *smcp = pinfo->smcp;
 	scc_t __iomem *sccp = pinfo->sccp;
 
@@ -161,7 +165,8 @@ static void cpm_uart_stop_tx(struct uart_port *port)
  */
 static void cpm_uart_start_tx(struct uart_port *port)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 	smc_t __iomem *smcp = pinfo->smcp;
 	scc_t __iomem *sccp = pinfo->sccp;
 
@@ -189,7 +194,8 @@ static void cpm_uart_start_tx(struct uart_port *port)
  */
 static void cpm_uart_stop_rx(struct uart_port *port)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 	smc_t __iomem *smcp = pinfo->smcp;
 	scc_t __iomem *sccp = pinfo->sccp;
 
@@ -206,7 +212,8 @@ static void cpm_uart_stop_rx(struct uart_port *port)
  */
 static void cpm_uart_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 
 	pr_debug("CPM uart[%d]:break ctrl, break_state: %d\n", port->line,
 		break_state);
@@ -240,7 +247,8 @@ static void cpm_uart_int_rx(struct uart_port *port)
 	unsigned char ch;
 	u8 *cp;
 	struct tty_port *tport = &port->state->port;
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 	cbd_t __iomem *bdp;
 	u16 status;
 	unsigned int flg;
@@ -397,7 +405,8 @@ static irqreturn_t cpm_uart_int(int irq, void *data)
 static int cpm_uart_startup(struct uart_port *port)
 {
 	int retval;
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 
 	pr_debug("CPM uart[%d]:startup\n", port->line);
 
@@ -442,7 +451,8 @@ inline void cpm_uart_wait_until_send(struct uart_cpm_port *pinfo)
  */
 static void cpm_uart_shutdown(struct uart_port *port)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 
 	pr_debug("CPM uart[%d]:shutdown\n", port->line);
 
@@ -492,7 +502,8 @@ static void cpm_uart_set_termios(struct uart_port *port,
 	unsigned long flags;
 	u16 cval, scval, prev_mode;
 	int bits, sbits;
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 	smc_t __iomem *smcp = pinfo->smcp;
 	scc_t __iomem *sccp = pinfo->sccp;
 	int maxidl;
@@ -675,7 +686,8 @@ static int cpm_uart_tx_pump(struct uart_port *port)
 	cbd_t __iomem *bdp;
 	u8 *p;
 	int count;
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 	struct circ_buf *xmit = &port->state->xmit;
 
 	/* Handle xon/xoff */
@@ -906,7 +918,8 @@ static void cpm_uart_init_smc(struct uart_cpm_port *pinfo)
  */
 static int cpm_uart_request_port(struct uart_port *port)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 	int ret;
 
 	pr_debug("CPM uart[%d]:request port\n", port->line);
@@ -938,7 +951,8 @@ static int cpm_uart_request_port(struct uart_port *port)
 
 static void cpm_uart_release_port(struct uart_port *port)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 
 	if (!(pinfo->flags & FLAG_CONSOLE))
 		cpm_uart_freebuf(pinfo);
@@ -1082,7 +1096,8 @@ static int poll_wait_key(char *obuf, struct uart_cpm_port *pinfo)
 
 static int cpm_get_poll_char(struct uart_port *port)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 
 	if (!serial_polled) {
 		serial_polled = 1;
@@ -1099,7 +1114,8 @@ static int cpm_get_poll_char(struct uart_port *port)
 static void cpm_put_poll_char(struct uart_port *port,
 			 unsigned char c)
 {
-	struct uart_cpm_port *pinfo = (struct uart_cpm_port *)port;
+	struct uart_cpm_port *pinfo =
+		container_of(port, struct uart_cpm_port, port);
 	static char ch[2];
 
 	ch[0] = (char)c;
-- 
1.9.1

