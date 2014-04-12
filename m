Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbaDLNT2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 09:19:28 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:59312 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaDLNTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 09:19:24 -0400
From: Dominique van den Broeck <domdevlin@free.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dominique van den Broeck <domdevlin@free.fr>
Subject: [PATCH v2 2/4] fwserial: (coding style) if/else bracket matching
Date: Sat, 12 Apr 2014 15:18:13 +0200
Message-Id: <1397308695-30779-2-git-send-email-domdevlin@free.fr>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397308695-30779-1-git-send-email-domdevlin@free.fr>
References: <20140412010411.GA29370@kroah.com>
 <1397308695-30779-1-git-send-email-domdevlin@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style-only modifications to make checkpatch.pl --file --strict a bit happier.
if/else bracket matching (either none or both options should be bracketed).

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
diff -upr a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
--- a/drivers/staging/fwserial/fwserial.c	2014-04-11 20:48:20.813667706 +0200
+++ b/drivers/staging/fwserial/fwserial.c	2014-04-11 20:47:49.701058326 +0200
@@ -638,9 +634,9 @@ static void fwtty_port_handler(struct fw
 
 	switch (tcode) {
 	case TCODE_WRITE_QUADLET_REQUEST:
-		if (addr != port->rx_handler.offset || len != 4)
+		if (addr != port->rx_handler.offset || len != 4) {
 			rcode = RCODE_ADDRESS_ERROR;
-		else {
+		} else {
 			fwtty_update_port_status(port, *(unsigned *)data);
 			rcode = RCODE_COMPLETE;
 		}
@@ -756,11 +752,11 @@ static int fwtty_tx(struct fwtty_port *p
 
 		if (n < 0) {
 			kmem_cache_free(fwtty_txn_cache, txn);
-			if (n == -EAGAIN)
+			if (n == -EAGAIN) {
 				++port->stats.tx_stall;
-			else if (n == -ENODATA)
+			} else if (n == -ENODATA) {
 				fwtty_profile_data(port->stats.txns, 0);
-			else {
+			} else {
 				++port->stats.fifo_errs;
 				fwtty_err_ratelimited(port, "fifo err: %d\n",
 						      n);
@@ -1264,8 +1260,9 @@ static int set_serial_info(struct fwtty_
 		if (((tmp.flags & ~ASYNC_USR_MASK) !=
 		     (port->port.flags & ~ASYNC_USR_MASK)))
 			return -EPERM;
-	} else
+	} else {
 		port->port.close_delay = tmp.close_delay * HZ / 100;
+	}
 
 	return 0;
 }
@@ -1308,9 +1305,9 @@ static void fwtty_set_termios(struct tty
 	spin_lock_bh(&port->lock);
 	baud = set_termios(port, tty);
 
-	if ((baud == 0) && (old->c_cflag & CBAUD))
+	if ((baud == 0) && (old->c_cflag & CBAUD)) {
 		port->mctrl &= ~(TIOCM_DTR | TIOCM_RTS);
-	else if ((baud != 0) && !(old->c_cflag & CBAUD)) {
+	} else if ((baud != 0) && !(old->c_cflag & CBAUD)) {
 		if (C_CRTSCTS(tty) || !test_bit(TTY_THROTTLED, &tty->flags))
 			port->mctrl |= TIOCM_DTR | TIOCM_RTS;
 		else
@@ -1733,8 +1730,9 @@ static inline int fwserial_send_mgmt_syn
 		    rcode == RCODE_GENERATION) {
 			fwtty_dbg(&peer->unit, "mgmt write error: %d\n", rcode);
 			continue;
-		} else
+		} else {
 			break;
+		}
 	} while (--tries > 0);
 	return rcode;
 }
@@ -2744,9 +2742,9 @@ static int fwserial_parse_mgmt_write(str
 		break;
 
 	case FWSC_VIRT_CABLE_UNPLUG_RSP:
-		if (peer->state != FWPS_UNPLUG_PENDING)
+		if (peer->state != FWPS_UNPLUG_PENDING) {
 			rcode = RCODE_CONFLICT_ERROR;
-		else {
+		} else {
 			if (be16_to_cpu(pkt->hdr.code) & FWSC_RSP_NACK)
 				fwtty_notice(&peer->unit, "NACK unplug?\n");
 			port = peer_revert_state(peer);
