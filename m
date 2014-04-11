Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066AbaDKXlI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 19:41:08 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:21581 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754159AbaDKXlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 19:41:06 -0400
Message-ID: <1397259661.3328.5.camel@wisdom>
Subject: [PATCH] fwserial: (unexhaustive) coding style review
From: Dominique van den Broeck <domdevlin@free.fr>
Reply-To: domdevlin@free.fr
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Sat, 12 Apr 2014 01:41:01 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dominique van den Broeck <domdevlin@free.fr>
fwserial: (unexhaustive) coding style review

linux-next commit 88a8e0969581869c742a9957ddcfe43063dff687 

Style-only modifications to make checkpatch.pl --file --strict a bit
happier.
I fixed only what was trivial, such as parenthesis alignments (one of
them,
at fwserial.c:1349, couldn't be easily replaced by something better,
though).
However, I did not comment by myself issues regarding spinlocks or
memory
barriers.

This is my very first patch. Please be indulgent and forgive my eventual
mistakes. I did that to start contributing to linux kernel, but also
as task #10 of the Eudyptula Challenge ( http://eudyptula-challenge.org/
).

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
diff -upr a/drivers/staging/fwserial/dma_fifo.c
b/drivers/staging/fwserial/dma_fifo.c
--- a/drivers/staging/fwserial/dma_fifo.c	2014-04-11 20:48:20.813667706
+0200
+++ b/drivers/staging/fwserial/dma_fifo.c	2014-04-11 20:47:49.700058306
+0200
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
@@ -169,9 +165,9 @@ int dma_fifo_in(struct dma_fifo *fifo, c
 	memcpy(fifo->data, src + l, n - l);
 
 	if (FAIL(fifo, addr_check(fifo->done, fifo->in, fifo->in + n) ||
-			fifo->avail < n,
-			"fifo corrupt: in:%u out:%u done:%u n:%d avail:%d",
-			fifo->in, fifo->out, fifo->done, n, fifo->avail))
+		 fifo->avail < n,
+		 "fifo corrupt: in:%u out:%u done:%u n:%d avail:%d",
+		 fifo->in, fifo->out, fifo->done, n, fifo->avail))
 		return -ENXIO;
 
 	fifo->in += n;
@@ -236,12 +232,12 @@ int dma_fifo_out_pend(struct dma_fifo *f
 	++fifo->open;
 
 	if (FAIL(fifo, fifo->open > fifo->open_limit,
-			"past open limit:%d (limit:%d)",
-			fifo->open, fifo->open_limit))
+		 "past open limit:%d (limit:%d)",
+		 fifo->open, fifo->open_limit))
 		return -ENXIO;
 	if (FAIL(fifo, fifo->out & (fifo->align - 1),
-			"fifo out unaligned:%u (align:%u)",
-			fifo->out, fifo->align))
+		 "fifo out unaligned:%u (align:%u)",
+		 fifo->out, fifo->align))
 		return -ENXIO;
 
 	return len - n;
@@ -264,8 +260,8 @@ int dma_fifo_out_complete(struct dma_fif
 		return -EINVAL;
 
 	if (FAIL(fifo, list_empty(&fifo->pending) != (fifo->open == 0),
-			"pending list disagrees with open count:%d",
-			fifo->open))
+		 "pending list disagrees with open count:%d",
+		 fifo->open))
 		return -ENXIO;
 
 	tmp = complete->data;
@@ -282,10 +278,10 @@ int dma_fifo_out_complete(struct dma_fif
 		}
 
 		if (FAIL(fifo, pending->out != fifo->done ||
-				addr_check(fifo->in, fifo->done, pending->next),
-				"in:%u out:%u done:%u saved:%u next:%u",
-				fifo->in, fifo->out, fifo->done, pending->out,
-				pending->next))
+			 addr_check(fifo->in, fifo->done, pending->next),
+			 "in:%u out:%u done:%u saved:%u next:%u",
+			 fifo->in, fifo->out, fifo->done, pending->out,
+			 pending->next))
 			return -ENXIO;
 
 		list_del_init(&pending->link);
@@ -300,7 +296,7 @@ int dma_fifo_out_complete(struct dma_fif
 	if (FAIL(fifo, fifo->open < 0, "open dma:%d < 0", fifo->open))
 		return -ENXIO;
 	if (FAIL(fifo, fifo->avail > fifo->size, "fifo avail:%d > size:%d",
-			fifo->avail, fifo->size))
+		 fifo->avail, fifo->size))
 		return -ENXIO;
 
 	return 0;
diff -upr a/drivers/staging/fwserial/dma_fifo.h
b/drivers/staging/fwserial/dma_fifo.h
--- a/drivers/staging/fwserial/dma_fifo.h	2014-04-11 20:48:20.813667706
+0200
+++ b/drivers/staging/fwserial/dma_fifo.h	2014-04-11 20:47:49.700058306
+0200
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #ifndef _DMA_FIFO_H_
@@ -85,15 +81,15 @@ static inline bool dp_is_completed(struc
 	return (unsigned long)dp->data & 1UL;
 }
 
-extern void dma_fifo_init(struct dma_fifo *fifo);
-extern int dma_fifo_alloc(struct dma_fifo *fifo, int size, unsigned
align,
-			  int tx_limit, int open_limit, gfp_t gfp_mask);
-extern void dma_fifo_free(struct dma_fifo *fifo);
-extern void dma_fifo_reset(struct dma_fifo *fifo);
-extern int dma_fifo_in(struct dma_fifo *fifo, const void *src, int n);
-extern int dma_fifo_out_pend(struct dma_fifo *fifo, struct dma_pending
*pended);
-extern int dma_fifo_out_complete(struct dma_fifo *fifo,
-				 struct dma_pending *complete);
+void dma_fifo_init(struct dma_fifo *fifo);
+int dma_fifo_alloc(struct dma_fifo *fifo, int size, unsigned align,
+		   int tx_limit, int open_limit, gfp_t gfp_mask);
+void dma_fifo_free(struct dma_fifo *fifo);
+void dma_fifo_reset(struct dma_fifo *fifo);
+int dma_fifo_in(struct dma_fifo *fifo, const void *src, int n);
+int dma_fifo_out_pend(struct dma_fifo *fifo, struct dma_pending
*pended);
+int dma_fifo_out_complete(struct dma_fifo *fifo,
+			  struct dma_pending *complete);
 
 /* returns the # of used bytes in the fifo */
 static inline int dma_fifo_level(struct dma_fifo *fifo)
diff -upr a/drivers/staging/fwserial/fwserial.c
b/drivers/staging/fwserial/fwserial.c
--- a/drivers/staging/fwserial/fwserial.c	2014-04-11 20:48:20.813667706
+0200
+++ b/drivers/staging/fwserial/fwserial.c	2014-04-11 20:47:49.701058326
+0200
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -530,7 +526,7 @@ static void fwtty_emit_breaks(struct wor
 	while (n) {
 		t = min(n, 16);
 		c = tty_insert_flip_string_fixed_flag(&port->port, buf,
-				TTY_BREAK, t);
+						      TTY_BREAK, t);
 		n -= c;
 		brk += c;
 		if (c < t)
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
@@ -741,7 +737,7 @@ static int fwtty_tx(struct fwtty_port *p
 	/* try to write as many dma transactions out as possible */
 	n = -EAGAIN;
 	while (!tty->stopped && !tty->hw_stopped &&
-			!test_bit(STOP_TX, &port->flags)) {
+	       !test_bit(STOP_TX, &port->flags)) {
 		txn = kmem_cache_alloc(fwtty_txn_cache, GFP_ATOMIC);
 		if (!txn) {
 			n = -ENOMEM;
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
@@ -884,7 +880,7 @@ static void fwserial_destroy(struct kref
 	for (j = 0; j < num_ports; ++i, ++j) {
 		port_table_corrupt |= port_table[i] != ports[j];
 		WARN_ONCE(port_table_corrupt, "port_table[%d]: %p != ports[%d]: %p",
-		     i, port_table[i], j, ports[j]);
+			  i, port_table[i], j, ports[j]);
 
 		port_table[i] = NULL;
 	}
@@ -1257,15 +1253,16 @@ static int set_serial_info(struct fwtty_
 		return -EFAULT;
 
 	if (tmp.irq != 0 || tmp.port != 0 || tmp.custom_divisor != 0 ||
-			tmp.baud_base != 400000000)
+	    tmp.baud_base != 400000000)
 		return -EPERM;
 
 	if (!capable(CAP_SYS_ADMIN)) {
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
@@ -1818,7 +1816,7 @@ static void fwserial_release_port(struct
 
 static void fwserial_plug_timeout(unsigned long data)
 {
-	struct fwtty_peer *peer = (struct fwtty_peer *) data;
+	struct fwtty_peer *peer = (struct fwtty_peer *)data;
 	struct fwtty_port *port;
 
 	spin_lock_bh(&peer->lock);
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


