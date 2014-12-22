Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934AbaLVB2s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 20:28:48 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:58776 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753734AbaLVB10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 20:27:26 -0500
From: Simone Weiss <simone.weiss@fau.de>
To: simone.weiss@fau.de
Cc: helene.gsaenger@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, markh@compro.net, gregkh@linuxfoundation.org,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] dgnc/dgnc_neo.c: checkpatch: fixed long lines
Date: Mon, 22 Dec 2014 02:17:33 +0100
Message-Id: <1419211054-3052-6-git-send-email-simone.weiss@fau.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
References: <1419211054-3052-1-git-send-email-simone.weiss@fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Simone Weiss <simone.weiss@fau.de>
Signed-off-by: Helene Gsaenger <helene.gsaenger@studium.fau.de>
---
 drivers/staging/dgnc/dgnc_neo.c | 214 ++++++++++++++++++++++++++++------------
 1 file changed, 149 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index c9a8a98..71e062d 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -95,7 +95,8 @@ struct board_ops dgnc_neo_ops = {
 	.send_immediate_char =		neo_send_immediate_char
 };
 
-static uint dgnc_offset_table[8] = { 0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80 };
+static uint dgnc_offset_table[8] = { 0x01, 0x02, 0x04, 0x08,
+				     0x10, 0x20, 0x40, 0x80 };
 
 
 /*
@@ -129,14 +130,18 @@ static inline void neo_set_cts_flow_control(struct channel_t *ch)
 	/* Turn off auto Xon flow control */
 	efr &= ~(UART_17158_EFR_IXON);
 
-	/* Why? Becuz Exar's spec says we have to zero it out before setting it */
+	/*
+	 * Why? Becuz Exar's spec says we have
+	 * to zero it out before setting it
+	 */
 	writeb(0, &ch->ch_neo_uart->efr);
 
 	/* Turn on UART enhanced bits */
 	writeb(efr, &ch->ch_neo_uart->efr);
 
 	/* Turn on table D, with 8 char hi/low watermarks */
-	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_4DELAY), &ch->ch_neo_uart->fctr);
+	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_4DELAY),
+		&ch->ch_neo_uart->fctr);
 
 	/* Feed the UART our trigger levels */
 	writeb(8, &ch->ch_neo_uart->tfifo);
@@ -165,13 +170,17 @@ static inline void neo_set_rts_flow_control(struct channel_t *ch)
 	ier &= ~(UART_17158_IER_XOFF);
 	efr &= ~(UART_17158_EFR_IXOFF);
 
-	/* Why? Becuz Exar's spec says we have to zero it out before setting it */
+	/*
+	 * Why? Becuz Exar's spec says we have to zero it out
+	 * before setting it
+	 */
 	writeb(0, &ch->ch_neo_uart->efr);
 
 	/* Turn on UART enhanced bits */
 	writeb(efr, &ch->ch_neo_uart->efr);
 
-	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_4DELAY), &ch->ch_neo_uart->fctr);
+	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_4DELAY),
+		&ch->ch_neo_uart->fctr);
 	ch->ch_r_watermark = 4;
 
 	writeb(32, &ch->ch_neo_uart->rfifo);
@@ -202,14 +211,18 @@ static inline void neo_set_ixon_flow_control(struct channel_t *ch)
 
 	/* Turn on auto Xon flow control */
 	efr |= (UART_17158_EFR_ECB | UART_17158_EFR_IXON);
+	/*
+	 * Why? Becuz Exar's spec says we have to zero it out
+	 * before setting it
+	 */
 
-	/* Why? Becuz Exar's spec says we have to zero it out before setting it */
 	writeb(0, &ch->ch_neo_uart->efr);
 
 	/* Turn on UART enhanced bits */
 	writeb(efr, &ch->ch_neo_uart->efr);
 
-	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_8DELAY), &ch->ch_neo_uart->fctr);
+	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_8DELAY),
+		&ch->ch_neo_uart->fctr);
 	ch->ch_r_watermark = 4;
 
 	writeb(32, &ch->ch_neo_uart->rfifo);
@@ -241,14 +254,18 @@ static inline void neo_set_ixoff_flow_control(struct channel_t *ch)
 	ier |= (UART_17158_IER_XOFF);
 	efr |= (UART_17158_EFR_ECB | UART_17158_EFR_IXOFF);
 
-	/* Why? Becuz Exar's spec says we have to zero it out before setting it */
+	/*
+	 * Why? Becuz Exar's spec says we have to zero it out
+	 * before setting it
+	 */
 	writeb(0, &ch->ch_neo_uart->efr);
 
 	/* Turn on UART enhanced bits */
 	writeb(efr, &ch->ch_neo_uart->efr);
 
 	/* Turn on table D, with 8 char hi/low watermarks */
-	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_8DELAY), &ch->ch_neo_uart->fctr);
+	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_8DELAY),
+		&ch->ch_neo_uart->fctr);
 
 	writeb(8, &ch->ch_neo_uart->tfifo);
 	ch->ch_t_tlevel = 8;
@@ -282,15 +299,18 @@ static inline void neo_set_no_input_flow_control(struct channel_t *ch)
 	else
 		efr &= ~(UART_17158_EFR_ECB | UART_17158_EFR_IXOFF);
 
-
-	/* Why? Becuz Exar's spec says we have to zero it out before setting it */
+	/*
+	 * Why? Becuz Exar's spec says we have to zero it out
+	 * before setting it
+	 */
 	writeb(0, &ch->ch_neo_uart->efr);
 
 	/* Turn on UART enhanced bits */
 	writeb(efr, &ch->ch_neo_uart->efr);
 
 	/* Turn on table D, with 8 char hi/low watermarks */
-	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_8DELAY), &ch->ch_neo_uart->fctr);
+	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_8DELAY),
+		&ch->ch_neo_uart->fctr);
 
 	ch->ch_r_watermark = 0;
 
@@ -321,14 +341,18 @@ static inline void neo_set_no_output_flow_control(struct channel_t *ch)
 	else
 		efr &= ~(UART_17158_EFR_ECB | UART_17158_EFR_IXON);
 
-	/* Why? Becuz Exar's spec says we have to zero it out before setting it */
+	/*
+	 * Why? Becuz Exar's spec says we have to zero it out
+	 * before setting it
+	 */
 	writeb(0, &ch->ch_neo_uart->efr);
 
 	/* Turn on UART enhanced bits */
 	writeb(efr, &ch->ch_neo_uart->efr);
 
 	/* Turn on table D, with 8 char hi/low watermarks */
-	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_8DELAY), &ch->ch_neo_uart->fctr);
+	writeb((UART_17158_FCTR_TRGD | UART_17158_FCTR_RTS_8DELAY),
+		&ch->ch_neo_uart->fctr);
 
 	ch->ch_r_watermark = 0;
 
@@ -349,7 +373,8 @@ static inline void neo_set_new_start_stop_chars(struct channel_t *ch)
 {
 
 	/* if hardware flow control is set, then skip this whole thing */
-	if (ch->ch_digi.digi_flags & (CTSPACE | RTSPACE) || ch->ch_c_cflag & CRTSCTS)
+	if (ch->ch_digi.digi_flags & (CTSPACE | RTSPACE)
+	    || ch->ch_c_cflag & CRTSCTS)
 		return;
 
 	/* Tell UART what start/stop chars it should be looking for */
@@ -424,7 +449,8 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 			break;
 
 		/*
-		 * Yank off the upper 2 bits, which just show that the FIFO's are enabled.
+		 * Yank off the upper 2 bits,
+		 * which just show that the FIFO's are enabled.
 		 */
 		isr &= ~(UART_17158_IIR_FIFO_ENABLED);
 
@@ -434,7 +460,10 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 			ch->ch_intr_rx++;
 			neo_copy_data_from_uart_to_queue(ch);
 
-			/* Call our tty layer to enforce queue flow control if needed. */
+			/*
+			 * Call our tty layer to enforce queue
+			 * flow control if needed.
+			 */
 			spin_lock_irqsave(&ch->ch_lock, flags);
 			dgnc_check_queue_flow_control(ch);
 			spin_unlock_irqrestore(&ch->ch_lock, flags);
@@ -459,7 +488,10 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 			 * one it was, so we can suspend or resume data flow.
 			 */
 			if (cause == UART_17158_XON_DETECT) {
-				/* Is output stopped right now, if so, resume it */
+				/*
+				 * Is output stopped right now,
+				 * if so, resume it
+				 */
 				if (brd->channels[port]->ch_flags & CH_STOP) {
 					spin_lock_irqsave(&ch->ch_lock,
 							  flags);
@@ -467,8 +499,8 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 					spin_unlock_irqrestore(&ch->ch_lock,
 							       flags);
 				}
-			} else if (cause == UART_17158_XOFF_DETECT) {
-				if (!(brd->channels[port]->ch_flags & CH_STOP)) {
+		} else if (cause == UART_17158_XOFF_DETECT) {
+				if (!brd->channels[port]->ch_flags & CH_STOP) {
 					spin_lock_irqsave(&ch->ch_lock,
 							  flags);
 					ch->ch_flags |= CH_STOP;
@@ -480,8 +512,9 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 
 		if (isr & UART_17158_IIR_HWFLOW_STATE_CHANGE) {
 			/*
-			 * If we get here, this means the hardware is doing auto flow control.
-			 * Check to see whether RTS/DTR or CTS/DSR caused this interrupt.
+			 * If we get here, this means the hardware is doing
+			 * auto flow control. Check to see whether RTS/DTR
+			 * or CTS/DSR caused this interrupt.
 			 */
 			brd->intr_modem++;
 			ch->ch_intr_modem++;
@@ -577,7 +610,8 @@ static inline void neo_parse_lsr(struct dgnc_board *brd, uint port)
 		 * Rx Oruns. Exar says that an orun will NOT corrupt
 		 * the FIFO. It will just replace the holding register
 		 * with this new data byte. So basically just ignore this.
-		 * Probably we should eventually have an orun stat in our driver...
+		 * Probably we should eventually have an orun
+		 * stat in our driver...
 		 */
 		ch->ch_err_overrun++;
 	}
@@ -699,8 +733,12 @@ static void neo_param(struct tty_struct *tty)
 				4800,   9600,   19200,  38400 }
 		};
 
-		/* Only use the TXPrint baud rate if the terminal unit is NOT open */
-		if (!(ch->ch_tun.un_flags & UN_ISOPEN) && (un->un_type == DGNC_PRINT))
+		/*
+		 * Only use the TXPrint baud rate if the terminal unit is
+		 * NOT open
+		*/
+		if (!(ch->ch_tun.un_flags & UN_ISOPEN)
+		    && (un->un_type == DGNC_PRINT))
 			baud = C_BAUD(ch->ch_pun.un_tty) & 0xff;
 		else
 			baud = C_BAUD(ch->ch_tun.un_tty) & 0xff;
@@ -713,7 +751,8 @@ static void neo_param(struct tty_struct *tty)
 
 		jindex = baud;
 
-		if ((iindex >= 0) && (iindex < 4) && (jindex >= 0) && (jindex < 16))
+		if ((iindex >= 0) && (iindex < 4)
+		    && (jindex >= 0) && (jindex < 16))
 			baud = bauds[iindex][jindex];
 		else
 			baud = 0;
@@ -820,8 +859,12 @@ static void neo_param(struct tty_struct *tty)
 	if (ch->ch_digi.digi_flags & CTSPACE || ch->ch_c_cflag & CRTSCTS) {
 		neo_set_cts_flow_control(ch);
 	} else if (ch->ch_c_iflag & IXON) {
-		/* If start/stop is set to disable, then we should disable flow control */
-		if ((ch->ch_startc == _POSIX_VDISABLE) || (ch->ch_stopc == _POSIX_VDISABLE))
+		/*
+		 * If start/stop is set to disable,
+		 * then we should disable flow control
+		 */
+		if ((ch->ch_startc == _POSIX_VDISABLE)
+		    || (ch->ch_stopc == _POSIX_VDISABLE))
 			neo_set_no_output_flow_control(ch);
 		else
 			neo_set_ixon_flow_control(ch);
@@ -832,8 +875,12 @@ static void neo_param(struct tty_struct *tty)
 	if (ch->ch_digi.digi_flags & RTSPACE || ch->ch_c_cflag & CRTSCTS) {
 		neo_set_rts_flow_control(ch);
 	} else if (ch->ch_c_iflag & IXOFF) {
-		/* If start/stop is set to disable, then we should disable flow control */
-		if ((ch->ch_startc == _POSIX_VDISABLE) || (ch->ch_stopc == _POSIX_VDISABLE))
+		/*
+		 * If start/stop is set to disable,
+		 * then we should disable flow control
+		 */
+		if ((ch->ch_startc == _POSIX_VDISABLE)
+		    || (ch->ch_stopc == _POSIX_VDISABLE))
 			neo_set_no_input_flow_control(ch);
 		else
 			neo_set_ixoff_flow_control(ch);
@@ -975,14 +1022,18 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 
 	/*
 	 * If 0, no interrupts pending.
-	 * This can happen if the IRQ is shared among a couple Neo/Classic boards.
+	 * This can happen if the IRQ is shared among a couple
+	 * Neo/Classic boards.
 	 */
 	if (!uart_poll) {
 		spin_unlock_irqrestore(&brd->bd_intr_lock, flags);
 		return IRQ_NONE;
 	}
 
-	/* At this point, we have at least SOMETHING to service, dig further... */
+	/*
+	 * At this point, we have at least SOMETHING to service,
+	 * dig further...
+	*/
 
 	current_port = 0;
 
@@ -1005,7 +1056,10 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 		uart_poll &= ~(dgnc_offset_table[port]);
 
 		if (!type) {
-			/* If no type, just ignore it, and move onto next port */
+			/*
+			 * If no type, just ignore it,
+			 * and move onto next port
+			 */
 			continue;
 		}
 
@@ -1025,7 +1079,10 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 			ch = brd->channels[port];
 			neo_copy_data_from_uart_to_queue(ch);
 
-			/* Call our tty layer to enforce queue flow control if needed. */
+			/*
+			 * Call our tty layer to enforce queue flow control if
+			 * needed.
+			 */
 			spin_lock_irqsave(&ch->ch_lock, flags2);
 			dgnc_check_queue_flow_control(ch);
 			spin_unlock_irqrestore(&ch->ch_lock, flags2);
@@ -1041,16 +1098,18 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 
 		case UART_17158_TXRDY:
 			/*
-			 * TXRDY interrupt clears after reading ISR register for the UART channel.
+			 * TXRDY interrupt clears after reading ISR register
+			 * for the UART channel.
 			 */
 
 			/*
 			 * Yes, this is odd...
 			 * Why would I check EVERY possibility of type of
 			 * interrupt, when we know its TXRDY???
-			 * Becuz for some reason, even tho we got triggered for TXRDY,
-			 * it seems to be occasionally wrong. Instead of TX, which
-			 * it should be, I was getting things like RXDY too. Weird.
+			 * Becuz for some reason, even tho we got triggered for
+			 * TXRDY, it seems to be occasionally wrong.
+			 * Instead of TX, which it should be,
+			 * I was getting things like RXDY too. Weird.
 			 */
 			neo_parse_isr(brd, port);
 			continue;
@@ -1065,8 +1124,8 @@ static irqreturn_t neo_intr(int irq, void *voidbrd)
 		default:
 			/*
 			 * The UART triggered us with a bogus interrupt type.
-			 * It appears the Exar chip, when REALLY bogged down, will throw
-			 * these once and awhile.
+			 * It appears the Exar chip, when REALLY bogged down,
+			 * will throw these once and awhile.
 			 * Its harmless, just ignore it and move on.
 			 */
 			continue;
@@ -1216,7 +1275,8 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
 		linestatus = 0;
 
 		/* Copy data from uart to the queue */
-		memcpy_fromio(ch->ch_rqueue + head, &ch->ch_neo_uart->txrxburst, n);
+		memcpy_fromio(ch->ch_rqueue + head,
+			      &ch->ch_neo_uart->txrxburst, n);
 
 		/*
 		 * Since RX_FIFO_DATA_ERROR was 0, we are guarenteed
@@ -1270,7 +1330,8 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
 		 * we don't miss our TX FIFO emptys.
 		 */
 		if (linestatus & (UART_LSR_THRE | UART_17158_TX_AND_FIFO_CLR)) {
-			linestatus &= ~(UART_LSR_THRE | UART_17158_TX_AND_FIFO_CLR);
+			linestatus &= ~(UART_LSR_THRE |
+					UART_17158_TX_AND_FIFO_CLR);
 			ch->ch_flags |= (CH_TX_FIFO_EMPTY | CH_TX_FIFO_LWM);
 		}
 
@@ -1286,9 +1347,9 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
 		}
 
 		/*
-		 * If our queue is full, we have no choice but to drop some data.
-		 * The assumption is that HWFLOW or SWFLOW should have stopped
-		 * things way way before we got to this point.
+		 * If our queue is full, we have no choice but to drop some
+		 * data. The assumption is that HWFLOW or SWFLOW should have
+		 * stopped things way way before we got to this point.
 		 *
 		 * I decided that I wanted to ditch the oldest data first,
 		 * I hope thats okay with everyone? Yes? Good.
@@ -1300,7 +1361,8 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
 			qleft++;
 		}
 
-		memcpy_fromio(ch->ch_rqueue + head, &ch->ch_neo_uart->txrxburst, 1);
+		memcpy_fromio(ch->ch_rqueue + head,
+			      &ch->ch_neo_uart->txrxburst, 1);
 		ch->ch_equeue[head] = (unsigned char) linestatus;
 
 		/* Ditch any remaining linestatus value. */
@@ -1355,7 +1417,8 @@ static int neo_drain(struct tty_struct *tty, uint seconds)
 	 *
 	 * NOTE: TODO: Do something with time passed in.
 	 */
-	rc = wait_event_interruptible(un->un_flags_wait, ((un->un_flags & UN_EMPTY) == 0));
+	rc = wait_event_interruptible(un->un_flags_wait,
+				      ((un->un_flags & UN_EMPTY) == 0));
 
 	/* If ret is non-zero, user ctrl-c'ed us */
 	return rc;
@@ -1375,12 +1438,16 @@ static void neo_flush_uart_write(struct channel_t *ch)
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
 
-	writeb((UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_XMIT), &ch->ch_neo_uart->isr_fcr);
+	writeb((UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_XMIT),
+		&ch->ch_neo_uart->isr_fcr);
 	neo_pci_posting_flush(ch->ch_bd);
 
 	for (i = 0; i < 10; i++) {
 
-		/* Check to see if the UART feels it completely flushed the FIFO. */
+		/*
+		 * Check to see if the UART feels it
+		 * completely flushed the FIFO.
+		 */
 		tmp = readb(&ch->ch_neo_uart->isr_fcr);
 		if (tmp & 4)
 			udelay(10);
@@ -1405,12 +1472,16 @@ static void neo_flush_uart_read(struct channel_t *ch)
 	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
 
-	writeb((UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR), &ch->ch_neo_uart->isr_fcr);
+	writeb((UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR),
+		&ch->ch_neo_uart->isr_fcr);
 	neo_pci_posting_flush(ch->ch_bd);
 
 	for (i = 0; i < 10; i++) {
 
-		/* Check to see if the UART feels it completely flushed the FIFO. */
+		/*
+		 * Check to see if the UART feels it
+		 * completely flushed the FIFO.
+		 */
 		tmp = readb(&ch->ch_neo_uart->isr_fcr);
 		if (tmp & 2)
 			udelay(10);
@@ -1442,7 +1513,8 @@ static void neo_copy_data_from_queue_to_uart(struct channel_t *ch)
 	}
 
 	/* If port is "stopped", don't send any data to the UART */
-	if ((ch->ch_flags & CH_FORCED_STOP) || (ch->ch_flags & CH_BREAK_SENDING)) {
+	if ((ch->ch_flags & CH_FORCED_STOP)
+	    || (ch->ch_flags & CH_BREAK_SENDING)) {
 		spin_unlock_irqrestore(&ch->ch_lock, flags);
 		return;
 	}
@@ -1459,8 +1531,9 @@ static void neo_copy_data_from_queue_to_uart(struct channel_t *ch)
 			ch->ch_cached_lsr &= ~(UART_LSR_THRE);
 
 			/*
-			 * If RTS Toggle mode is on, turn on RTS now if not already set,
-			 * and make sure we get an event when the data transfer has completed.
+			 * If RTS Toggle mode is on, turn on RTS now if not
+			 * already set, and make sure we get an event when the
+			 * data transfer has completed.
 			 */
 			if (ch->ch_digi.digi_flags & DIGI_RTS_TOGGLE) {
 				if (!(ch->ch_mostat & UART_MCR_RTS)) {
@@ -1470,8 +1543,9 @@ static void neo_copy_data_from_queue_to_uart(struct channel_t *ch)
 				ch->ch_tun.un_flags |= (UN_EMPTY);
 			}
 			/*
-			 * If DTR Toggle mode is on, turn on DTR now if not already set,
-			 * and make sure we get an event when the data transfer has completed.
+			 * If DTR Toggle mode is on, turn on DTR now if not
+			 * already set, and make sure we get an event when the
+			 * data transfer has completed.
 			 */
 			if (ch->ch_digi.digi_flags & DIGI_DTR_TOGGLE) {
 				if (!(ch->ch_mostat & UART_MCR_DTR)) {
@@ -1481,7 +1555,8 @@ static void neo_copy_data_from_queue_to_uart(struct channel_t *ch)
 				ch->ch_tun.un_flags |= (UN_EMPTY);
 			}
 
-			writeb(ch->ch_wqueue[ch->ch_w_tail], &ch->ch_neo_uart->txrx);
+			writeb(ch->ch_wqueue[ch->ch_w_tail],
+			       &ch->ch_neo_uart->txrx);
 			ch->ch_w_tail++;
 			ch->ch_w_tail &= WQUEUEMASK;
 			ch->ch_txcount++;
@@ -1531,7 +1606,8 @@ static void neo_copy_data_from_queue_to_uart(struct channel_t *ch)
 
 		/*
 		 * If RTS Toggle mode is on, turn on RTS now if not already set,
-		 * and make sure we get an event when the data transfer has completed.
+		 * and make sure we get an event when the data transfer has
+		 * completed.
 		 */
 		if (ch->ch_digi.digi_flags & DIGI_RTS_TOGGLE) {
 			if (!(ch->ch_mostat & UART_MCR_RTS)) {
@@ -1543,7 +1619,8 @@ static void neo_copy_data_from_queue_to_uart(struct channel_t *ch)
 
 		/*
 		 * If DTR Toggle mode is on, turn on DTR now if not already set,
-		 * and make sure we get an event when the data transfer has completed.
+		 * and make sure we get an event when the data transfer has
+		 * completed.
 		 */
 		if (ch->ch_digi.digi_flags & DIGI_DTR_TOGGLE) {
 			if (!(ch->ch_mostat & UART_MCR_DTR)) {
@@ -1553,7 +1630,8 @@ static void neo_copy_data_from_queue_to_uart(struct channel_t *ch)
 			ch->ch_tun.un_flags |= (UN_EMPTY);
 		}
 
-		memcpy_toio(&ch->ch_neo_uart->txrxburst, ch->ch_wqueue + tail, s);
+		memcpy_toio(&ch->ch_neo_uart->txrxburst,
+			    ch->ch_wqueue + tail, s);
 
 		/* Add and flip queue if needed */
 		tail = (tail + s) & WQUEUEMASK;
@@ -1606,7 +1684,10 @@ static void neo_parse_modem(struct channel_t *ch, unsigned char signals)
 		}
 	}
 
-	/* Scrub off lower bits. They signify delta's, which I don't care about */
+	/*
+	 * Scrub off lower bits.
+	 * They signify delta's, which I don't care about
+	 */
 	msignals &= 0xf0;
 
 	if (msignals & UART_MSR_DCD)
@@ -1693,7 +1774,8 @@ static void neo_uart_init(struct channel_t *ch)
 
 	/* Clear out UART and FIFO */
 	readb(&ch->ch_neo_uart->txrx);
-	writeb((UART_FCR_ENABLE_FIFO|UART_FCR_CLEAR_RCVR|UART_FCR_CLEAR_XMIT), &ch->ch_neo_uart->isr_fcr);
+	writeb((UART_FCR_ENABLE_FIFO|UART_FCR_CLEAR_RCVR|UART_FCR_CLEAR_XMIT),
+	       &ch->ch_neo_uart->isr_fcr);
 	readb(&ch->ch_neo_uart->lsr);
 	readb(&ch->ch_neo_uart->msr);
 
@@ -1795,7 +1877,8 @@ static void neo_send_immediate_char(struct channel_t *ch, unsigned char c)
 }
 
 
-static unsigned int neo_read_eeprom(unsigned char __iomem *base, unsigned int address)
+static unsigned int neo_read_eeprom(unsigned char __iomem *base,
+				    unsigned int address)
 {
 	unsigned int enable;
 	unsigned int bits;
@@ -1855,8 +1938,9 @@ static void neo_vpd(struct dgnc_board *brd)
 	}
 
 	if  (((brd->vpd[0x08] != 0x82)	   /* long resource name tag */
-		&&  (brd->vpd[0x10] != 0x82))   /* long resource name tag (PCI-66 files)*/
-		||  (brd->vpd[0x7F] != 0x78)) { /* small resource end tag */
+	     &&  (brd->vpd[0x10] != 0x82))   /* long resource name tag
+					      * (PCI-66 files)*/
+	     ||  (brd->vpd[0x7F] != 0x78)) { /* small resource end tag */
 
 		memset(brd->vpd, '\0', NEO_VPD_IMAGESIZE);
 	} else {
-- 
1.9.1

