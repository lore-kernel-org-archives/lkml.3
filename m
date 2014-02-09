Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaBINXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:23:00 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:65119 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbaBINW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:22:58 -0500
Message-ID: <1391952175.25424.2.camel@x220>
Subject: [PATCH] Drop remaining code for CRISv10 CPU simulator
From: Paul Bolle <pebolle@tiscali.nl>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-cris-kernel@axis.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 14:22:55 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 13:22:56.0114 (UTC) FILETIME=[0B429D20:01CF259A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol SVINTO_SIM got dropped in commit e269a869417c ("Drop
code for CRISv10 CPU simulator"). Now drop the remaining code for that
simulator.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Not even compile tested.

 drivers/tty/serial/crisv10.c | 112 -------------------------------------------
 1 file changed, 112 deletions(-)

diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 690bdea..d567ac5 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -286,7 +286,6 @@ static struct e100_serial rs_table[] = {
 #endif
 
 },  /* ttyS0 */
-#ifndef CONFIG_SVINTO_SIM
 	{ .baud        = DEF_BAUD,
 	  .ioport        = (unsigned char *)R_SERIAL1_CTRL,
 	  .irq         = 1U << 16, /* uses DMA 8 and 9 */
@@ -447,7 +446,6 @@ static struct e100_serial rs_table[] = {
 	  .dma_in_enabled = 0
 #endif
  }   /* ttyS3 */
-#endif
 };
 

@@ -1035,7 +1033,6 @@ cflag_to_etrax_baud(unsigned int cflag)
 static inline void
 e100_dtr(struct e100_serial *info, int set)
 {
-#ifndef CONFIG_SVINTO_SIM
 	unsigned char mask = e100_modem_pins[info->line].dtr_mask;
 
 #ifdef SERIAL_DEBUG_IO
@@ -1060,7 +1057,6 @@ e100_dtr(struct e100_serial *info, int set)
 	       info->line, *e100_modem_pins[info->line].dtr_shadow,
 	       E100_DTR_GET(info));
 #endif
-#endif
 }
 
 /* set = 0 means 3.3V on the pin, bitvalue: 0=active, 1=inactive
@@ -1069,7 +1065,6 @@ e100_dtr(struct e100_serial *info, int set)
 static inline void
 e100_rts(struct e100_serial *info, int set)
 {
-#ifndef CONFIG_SVINTO_SIM
 	unsigned long flags;
 	local_irq_save(flags);
 	info->rx_ctrl &= ~E100_RTS_MASK;
@@ -1079,7 +1074,6 @@ e100_rts(struct e100_serial *info, int set)
 #ifdef SERIAL_DEBUG_IO
 	printk("ser%i rts %i\n", info->line, set);
 #endif
-#endif
 }
 

@@ -1087,7 +1081,6 @@ e100_rts(struct e100_serial *info, int set)
 static inline void
 e100_ri_out(struct e100_serial *info, int set)
 {
-#ifndef CONFIG_SVINTO_SIM
 	/* RI is active low */
 	{
 		unsigned char mask = e100_modem_pins[info->line].ri_mask;
@@ -1099,12 +1092,10 @@ e100_ri_out(struct e100_serial *info, int set)
 		*e100_modem_pins[info->line].ri_port = *e100_modem_pins[info->line].ri_shadow;
 		local_irq_restore(flags);
 	}
-#endif
 }
 static inline void
 e100_cd_out(struct e100_serial *info, int set)
 {
-#ifndef CONFIG_SVINTO_SIM
 	/* CD is active low */
 	{
 		unsigned char mask = e100_modem_pins[info->line].cd_mask;
@@ -1116,27 +1107,22 @@ e100_cd_out(struct e100_serial *info, int set)
 		*e100_modem_pins[info->line].cd_port = *e100_modem_pins[info->line].cd_shadow;
 		local_irq_restore(flags);
 	}
-#endif
 }
 
 static inline void
 e100_disable_rx(struct e100_serial *info)
 {
-#ifndef CONFIG_SVINTO_SIM
 	/* disable the receiver */
 	info->ioport[REG_REC_CTRL] =
 		(info->rx_ctrl &= ~IO_MASK(R_SERIAL0_REC_CTRL, rec_enable));
-#endif
 }
 
 static inline void
 e100_enable_rx(struct e100_serial *info)
 {
-#ifndef CONFIG_SVINTO_SIM
 	/* enable the receiver */
 	info->ioport[REG_REC_CTRL] =
 		(info->rx_ctrl |= IO_MASK(R_SERIAL0_REC_CTRL, rec_enable));
-#endif
 }
 
 /* the rx DMA uses both the dma_descr and the dma_eop interrupts */
@@ -1554,24 +1540,6 @@ transmit_chars_dma(struct e100_serial *info)
 	unsigned int c, sentl;
 	struct etrax_dma_descr *descr;
 
-#ifdef CONFIG_SVINTO_SIM
-	/* This will output too little if tail is not 0 always since
-	 * we don't reloop to send the other part. Anyway this SHOULD be a
-	 * no-op - transmit_chars_dma would never really be called during sim
-	 * since rs_write does not write into the xmit buffer then.
-	 */
-	if (info->xmit.tail)
-		printk("Error in serial.c:transmit_chars-dma(), tail!=0\n");
-	if (info->xmit.head != info->xmit.tail) {
-		SIMCOUT(info->xmit.buf + info->xmit.tail,
-			CIRC_CNT(info->xmit.head,
-				 info->xmit.tail,
-				 SERIAL_XMIT_SIZE));
-		info->xmit.head = info->xmit.tail;  /* move back head */
-		info->tr_running = 0;
-	}
-	return;
-#endif
 	/* acknowledge both dma_descr and dma_eop irq in R_DMA_CHx_CLR_INTR */
 	*info->oclrintradr =
 		IO_STATE(R_DMA_CH6_CLR_INTR, clr_descr, do) |
@@ -1842,13 +1810,6 @@ static void receive_chars_dma(struct e100_serial *info)
 	struct tty_struct *tty;
 	unsigned char rstat;
 
-#ifdef CONFIG_SVINTO_SIM
-	/* No receive in the simulator.  Will probably be when the rest of
-	 * the serial interface works, and this piece will just be removed.
-	 */
-	return;
-#endif
-
 	/* Acknowledge both dma_descr and dma_eop irq in R_DMA_CHx_CLR_INTR */
 	*info->iclrintradr =
 		IO_STATE(R_DMA_CH6_CLR_INTR, clr_descr, do) |
@@ -1934,12 +1895,6 @@ static int start_recv_dma(struct e100_serial *info)
 static void
 start_receive(struct e100_serial *info)
 {
-#ifdef CONFIG_SVINTO_SIM
-	/* No receive in the simulator.  Will probably be when the rest of
-	 * the serial interface works, and this piece will just be removed.
-	 */
-	return;
-#endif
 	if (info->uses_dma_in) {
 		/* reset the input dma channel to be sure it works */
 
@@ -1972,17 +1927,6 @@ tr_interrupt(int irq, void *dev_id)
 	int i;
 	int handled = 0;
 
-#ifdef CONFIG_SVINTO_SIM
-	/* No receive in the simulator.  Will probably be when the rest of
-	 * the serial interface works, and this piece will just be removed.
-	 */
-	{
-		const char *s = "What? tr_interrupt in simulator??\n";
-		SIMCOUT(s,strlen(s));
-	}
-	return IRQ_HANDLED;
-#endif
-
 	/* find out the line that caused this irq and get it from rs_table */
 
 	ireg = *R_IRQ_MASK2_RD;  /* get the active irq bits for the dma channels */
@@ -2021,17 +1965,6 @@ rec_interrupt(int irq, void *dev_id)
 	int i;
 	int handled = 0;
 
-#ifdef CONFIG_SVINTO_SIM
-	/* No receive in the simulator.  Will probably be when the rest of
-	 * the serial interface works, and this piece will just be removed.
-	 */
-	{
-		const char *s = "What? rec_interrupt in simulator??\n";
-		SIMCOUT(s,strlen(s));
-	}
-	return IRQ_HANDLED;
-#endif
-
 	/* find out the line that caused this irq and get it from rs_table */
 
 	ireg = *R_IRQ_MASK2_RD;  /* get the active irq bits for the dma channels */
@@ -2173,10 +2106,6 @@ timed_flush_handler(unsigned long ptr)
 	struct e100_serial *info;
 	int i;
 
-#ifdef CONFIG_SVINTO_SIM
-	return;
-#endif
-
 	for (i = 0; i < NR_PORTS; i++) {
 		info = rs_table + i;
 		if (info->uses_dma_in)
@@ -2729,25 +2658,6 @@ startup(struct e100_serial * info)
 	printk("starting up ttyS%d (xmit_buf 0x%p)...\n", info->line, info->xmit.buf);
 #endif
 
-#ifdef CONFIG_SVINTO_SIM
-	/* Bits and pieces collected from below.  Better to have them
-	   in one ifdef:ed clause than to mix in a lot of ifdefs,
-	   right? */
-	if (info->port.tty)
-		clear_bit(TTY_IO_ERROR, &info->port.tty->flags);
-
-	info->xmit.head = info->xmit.tail = 0;
-	info->first_recv_buffer = info->last_recv_buffer = NULL;
-	info->recv_cnt = info->max_recv_cnt = 0;
-
-	for (i = 0; i < SERIAL_RECV_DESCRIPTORS; i++)
-		info->rec_descr[i].buf = NULL;
-
-	/* No real action in the simulator, but may set info important
-	   to ioctl. */
-	change_speed(info);
-#else
-
 	/*
 	 * Clear the FIFO buffers and disable them
 	 * (they will be reenabled in change_speed())
@@ -2837,8 +2747,6 @@ startup(struct e100_serial * info)
 	e100_rts(info, 1);
 	e100_dtr(info, 1);
 
-#endif /* CONFIG_SVINTO_SIM */
-
 	info->port.flags |= ASYNC_INITIALIZED;
 
 	local_irq_restore(flags);
@@ -2857,7 +2765,6 @@ shutdown(struct e100_serial * info)
 	struct etrax_recv_buffer *buffer;
 	int i;
 
-#ifndef CONFIG_SVINTO_SIM
 	/* shut down the transmitter and receiver */
 	DFLOW(DEBUG_LOG(info->line, "shutdown %i\n", info->line));
 	e100_disable_rx(info);
@@ -2882,8 +2789,6 @@ shutdown(struct e100_serial * info)
 		info->tr_running = 0;
 	}
 
-#endif /* CONFIG_SVINTO_SIM */
-
 	if (!(info->port.flags & ASYNC_INITIALIZED))
 		return;
 
@@ -2995,17 +2900,12 @@ change_speed(struct e100_serial *info)
 			IO_STATE(R_ALT_SER_BAUDRATE, ser0_tr, normal);
 		r_alt_ser_baudrate_shadow &= ~mask;
 		r_alt_ser_baudrate_shadow |= (alt_source << (info->line*8));
-#ifndef CONFIG_SVINTO_SIM
 		*R_ALT_SER_BAUDRATE = r_alt_ser_baudrate_shadow;
-#endif /* CONFIG_SVINTO_SIM */
 
 		info->baud = cflag_to_baud(cflag);
-#ifndef CONFIG_SVINTO_SIM
 		info->ioport[REG_BAUD] = cflag_to_etrax_baud(cflag);
-#endif /* CONFIG_SVINTO_SIM */
 	}
 
-#ifndef CONFIG_SVINTO_SIM
 	/* start with default settings and then fill in changes */
 	local_irq_save(flags);
 	/* 8 bit, no/even parity */
@@ -3073,7 +2973,6 @@ change_speed(struct e100_serial *info)
 
 	*((unsigned long *)&info->ioport[REG_XOFF]) = xoff;
 	local_irq_restore(flags);
-#endif /* !CONFIG_SVINTO_SIM */
 
 	update_char_time(info);
 
@@ -3122,11 +3021,6 @@ static int rs_raw_write(struct tty_struct *tty,
 		       count, info->ioport[REG_STATUS]);
 #endif
 
-#ifdef CONFIG_SVINTO_SIM
-	/* Really simple.  The output is here and now. */
-	SIMCOUT(buf, count);
-	return count;
-#endif
 	local_save_flags(flags);
 	DFLOW(DEBUG_LOG(info->line, "write count %i ", count));
 	DFLOW(DEBUG_LOG(info->line, "ldisc %i\n", tty->ldisc.chars_in_buffer(tty)));
@@ -3463,7 +3357,6 @@ static int
 get_lsr_info(struct e100_serial * info, unsigned int *value)
 {
 	unsigned int result = TIOCSER_TEMT;
-#ifndef CONFIG_SVINTO_SIM
 	unsigned long curr_time = jiffies;
 	unsigned long curr_time_usec = GET_JIFFIES_USEC();
 	unsigned long elapsed_usec =
@@ -3474,7 +3367,6 @@ get_lsr_info(struct e100_serial * info, unsigned int *value)
 	    elapsed_usec < 2*info->char_time_usec) {
 		result = 0;
 	}
-#endif
 
 	if (copy_to_user(value, &result, sizeof(int)))
 		return -EFAULT;
@@ -3804,7 +3696,6 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	e100_disable_serial_data_irq(info);
 #endif
 
-#ifndef CONFIG_SVINTO_SIM
 	e100_disable_rx(info);
 	e100_disable_rx_irq(info);
 
@@ -3816,7 +3707,6 @@ rs_close(struct tty_struct *tty, struct file * filp)
 		 */
 		rs_wait_until_sent(tty, HZ);
 	}
-#endif
 
 	shutdown(info);
 	rs_flush_buffer(tty);
@@ -4479,7 +4369,6 @@ static int __init rs_init(void)
 	fast_timer_init();
 #endif
 
-#ifndef CONFIG_SVINTO_SIM
 #ifndef CONFIG_ETRAX_KGDB
 	/* Not needed in simulator.  May only complicate stuff. */
 	/* hook the irq's for DMA channel 6 and 7, serial output and input, and some more... */
@@ -4489,7 +4378,6 @@ static int __init rs_init(void)
 		panic("%s: Failed to request irq8", __func__);
 
 #endif
-#endif /* CONFIG_SVINTO_SIM */
 
 	return 0;
 }
-- 
1.8.5.3

