Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaDLNTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 09:19:23 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:59170 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaDLNTV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 09:19:21 -0400
From: Dominique van den Broeck <domdevlin@free.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dominique van den Broeck <domdevlin@free.fr>
Subject: [PATCH v2 1/4] fwserial: (coding style) open parenthesis alignments
Date: Sat, 12 Apr 2014 15:18:12 +0200
Message-Id: <1397308695-30779-1-git-send-email-domdevlin@free.fr>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140412010411.GA29370@kroah.com>
References: <20140412010411.GA29370@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style-only modifications to make checkpatch.pl --file --strict a bit happier.
Open parenthesis alignments.

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
diff -upr a/drivers/staging/fwserial/dma_fifo.c b/drivers/staging/fwserial/dma_fifo.c
--- a/drivers/staging/fwserial/dma_fifo.c	2014-04-11 20:48:20.813667706 +0200
+++ b/drivers/staging/fwserial/dma_fifo.c	2014-04-11 20:47:49.700058306 +0200
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
diff -upr a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
--- a/drivers/staging/fwserial/fwserial.c	2014-04-11 20:48:20.813667706 +0200
+++ b/drivers/staging/fwserial/fwserial.c	2014-04-11 20:47:49.701058326 +0200
@@ -530,7 +526,7 @@ static void fwtty_emit_breaks(struct wor
 	while (n) {
 		t = min(n, 16);
 		c = tty_insert_flip_string_fixed_flag(&port->port, buf,
-				TTY_BREAK, t);
+						      TTY_BREAK, t);
 		n -= c;
 		brk += c;
 		if (c < t)
@@ -741,7 +737,7 @@ static int fwtty_tx(struct fwtty_port *p
 	/* try to write as many dma transactions out as possible */
 	n = -EAGAIN;
 	while (!tty->stopped && !tty->hw_stopped &&
-			!test_bit(STOP_TX, &port->flags)) {
+	       !test_bit(STOP_TX, &port->flags)) {
 		txn = kmem_cache_alloc(fwtty_txn_cache, GFP_ATOMIC);
 		if (!txn) {
 			n = -ENOMEM;
@@ -884,7 +880,7 @@ static void fwserial_destroy(struct kref
 	for (j = 0; j < num_ports; ++i, ++j) {
 		port_table_corrupt |= port_table[i] != ports[j];
 		WARN_ONCE(port_table_corrupt, "port_table[%d]: %p != ports[%d]: %p",
-		     i, port_table[i], j, ports[j]);
+			  i, port_table[i], j, ports[j]);
 
 		port_table[i] = NULL;
 	}
@@ -1257,7 +1253,7 @@ static int set_serial_info(struct fwtty_
 		return -EFAULT;
 
 	if (tmp.irq != 0 || tmp.port != 0 || tmp.custom_divisor != 0 ||
-			tmp.baud_base != 400000000)
+	    tmp.baud_base != 400000000)
 		return -EPERM;
 
 	if (!capable(CAP_SYS_ADMIN)) {
