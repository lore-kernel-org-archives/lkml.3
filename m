Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaEQXyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 19:54:52 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:44751 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaEQXyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 19:54:37 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: gregkh@linuxfoundation.org
Cc: lidza.louina@gmail.com, markh@compro.net,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] staging: dgnc: Remove extra curly braces
Date: Sun, 18 May 2014 00:54:31 +0100
Message-Id: <1400370871-26361-4-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400370871-26361-1-git-send-email-massa.nomura@gmail.com>
References: <1400370871-26361-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary curly braces of if statements in dgnc_neo.c and
dgnc_tty.c to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 drivers/staging/dgnc/dgnc_neo.c |   60 ++++++++-------------
 drivers/staging/dgnc/dgnc_tty.c |  110 ++++++++++++++-------------------------
 2 files changed, 61 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index 10b6016..2d472e6 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -434,9 +434,8 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 		isr = readb(&ch->ch_neo_uart->isr_fcr);
 
 		/* Bail if no pending interrupt */
-		if (isr & UART_IIR_NO_INT)  {
+		if (isr & UART_IIR_NO_INT)
 			break;
-		}
 
 		/*
 		 * Yank off the upper 2 bits, which just show that the FIFO's are enabled.
@@ -650,24 +649,20 @@ static void neo_param(struct tty_struct *tty)
 	struct channel_t *ch;
 	struct un_t   *un;
 
-	if (!tty || tty->magic != TTY_MAGIC) {
+	if (!tty || tty->magic != TTY_MAGIC)
 		return;
-	}
 
 	un = (struct un_t *) tty->driver_data;
-	if (!un || un->magic != DGNC_UNIT_MAGIC) {
+	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return;
-	}
 
 	ch = un->un_ch;
-	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC) {
+	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
-	}
 
 	bd = ch->ch_bd;
-	if (!bd || bd->magic != DGNC_BOARD_MAGIC) {
+	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
-	}
 
 	DPR_PARAM(("param start: tdev: %x cflags: %x oflags: %x iflags: %x\n",
 		ch->ch_tun.un_dev, ch->ch_c_cflag, ch->ch_c_oflag, ch->ch_c_iflag));
@@ -773,13 +768,11 @@ static void neo_param(struct tty_struct *tty)
 		}
 	}
 
-	if (ch->ch_c_cflag & PARENB) {
+	if (ch->ch_c_cflag & PARENB)
 		lcr |= UART_LCR_PARITY;
-	}
 
-	if (!(ch->ch_c_cflag & PARODD)) {
+	if (!(ch->ch_c_cflag & PARODD))
 		lcr |= UART_LCR_EPAR;
-	}
 
 	/*
 	 * Not all platforms support mark/space parity,
@@ -828,11 +821,10 @@ static void neo_param(struct tty_struct *tty)
 	if (uart_lcr != lcr)
 		writeb(lcr, &ch->ch_neo_uart->lcr);
 
-	if (ch->ch_c_cflag & CREAD) {
+	if (ch->ch_c_cflag & CREAD)
 		ier |= (UART_IER_RDI | UART_IER_RLSI);
-	} else {
+	else
 		ier &= ~(UART_IER_RDI | UART_IER_RLSI);
-	}
 
 	/*
 	 * Have the UART interrupt on modem signal changes ONLY when
@@ -1215,11 +1207,10 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
 		 * The count can be any where from 0-3 bytes "off".
 		 * Bizarre, but true.
 		 */
-		if ((ch->ch_bd->dvid & 0xf0) >= UART_XR17E158_DVID) {
+		if ((ch->ch_bd->dvid & 0xf0) >= UART_XR17E158_DVID)
 			total -= 1;
-		} else {
+		else
 			total -= 3;
-		}
 	}
 
 
@@ -1263,9 +1254,8 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
 		 * will reset some bits after our read, we need to ensure
 		 * we don't miss our TX FIFO emptys.
 		 */
-		if (linestatus & (UART_LSR_THRE | UART_17158_TX_AND_FIFO_CLR)) {
+		if (linestatus & (UART_LSR_THRE | UART_17158_TX_AND_FIFO_CLR))
 			ch->ch_flags |= (CH_TX_FIFO_EMPTY | CH_TX_FIFO_LWM);
-		}
 
 		linestatus = 0;
 
@@ -1393,19 +1383,16 @@ static int neo_drain(struct tty_struct *tty, uint seconds)
 	struct un_t *un;
 	int rc = 0;
 
-	if (!tty || tty->magic != TTY_MAGIC) {
+	if (!tty || tty->magic != TTY_MAGIC)
 		return -ENXIO;
-	}
 
 	un = (struct un_t *) tty->driver_data;
-	if (!un || un->magic != DGNC_UNIT_MAGIC) {
+	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return -ENXIO;
-	}
 
 	ch = un->un_ch;
-	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC) {
+	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return -ENXIO;
-	}
 
 	DPR_IOCTL(("%d Drain wait started.\n", __LINE__));
 
@@ -1422,11 +1409,10 @@ static int neo_drain(struct tty_struct *tty, uint seconds)
 	rc = wait_event_interruptible(un->un_flags_wait, ((un->un_flags & UN_EMPTY) == 0));
 
 	/* If ret is non-zero, user ctrl-c'ed us */
-	if (rc) {
+	if (rc)
 		DPR_IOCTL(("%d Drain - User ctrl c'ed\n", __LINE__));
-	} else {
+	else
 		DPR_IOCTL(("%d Drain wait finished.\n", __LINE__));
-	}
 
 	return rc;
 }
@@ -1442,9 +1428,8 @@ static void neo_flush_uart_write(struct channel_t *ch)
 	uchar tmp = 0;
 	int i = 0;
 
-	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC) {
+	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
-	}
 
 	writeb((UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_XMIT), &ch->ch_neo_uart->isr_fcr);
 	neo_pci_posting_flush(ch->ch_bd);
@@ -1474,9 +1459,8 @@ static void neo_flush_uart_read(struct channel_t *ch)
 	uchar tmp = 0;
 	int i = 0;
 
-	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC) {
+	if (!ch || ch->magic != DGNC_CHANNEL_MAGIC)
 		return;
-	}
 
 	writeb((UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR), &ch->ch_neo_uart->isr_fcr);
 	neo_pci_posting_flush(ch->ch_bd);
@@ -1950,10 +1934,8 @@ static void neo_vpd(struct dgnc_board *brd)
 		memset(brd->vpd, '\0', NEO_VPD_IMAGESIZE);
 	} else {
 		/* Search for the serial number */
-		for (i = 0; i < NEO_VPD_IMAGEBYTES - 3; i++) {
-			if (brd->vpd[i] == 'S' && brd->vpd[i + 1] == 'N') {
+		for (i = 0; i < NEO_VPD_IMAGEBYTES - 3; i++)
+			if (brd->vpd[i] == 'S' && brd->vpd[i + 1] == 'N')
 				strncpy(brd->serial_num, &(brd->vpd[i + 3]), 9);
-			}
-		}
 	}
 }
diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index e432c04..e3001b5 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -533,9 +533,8 @@ void dgnc_sniff_nowait_nolock(struct channel_t *ch, uchar *text, uchar *buf, int
 			 * We *cannot* sleep here waiting for space, because this
 			 * function was probably called by the interrupt/timer routines!
 			 */
-			if (n == 0) {
+			if (n == 0)
 				return;
-			}
 
 			/*
 			 * Copy as much data as will fit.
@@ -856,14 +855,11 @@ void dgnc_carrier(struct channel_t *ch)
 		phys_carrier = 1;
 	}
 
-	if (ch->ch_digi.digi_flags & DIGI_FORCEDCD) {
+	if (ch->ch_digi.digi_flags & DIGI_FORCEDCD)
 		virt_carrier = 1;
-	}
 
-	if (ch->ch_c_cflag & CLOCAL) {
+	if (ch->ch_c_cflag & CLOCAL)
 		virt_carrier = 1;
-	}
-
 
 	DPR_CARR(("DCD: physical: %d virt: %d\n", phys_carrier, virt_carrier));
 
@@ -1004,11 +1000,10 @@ static void dgnc_set_custom_speed(struct channel_t *ch, uint newrate)
 			deltahigh = testrate_high - newrate;
 			deltalow = newrate - testrate_low;
 
-			if (deltahigh < deltalow) {
+			if (deltahigh < deltalow)
 				newrate = testrate_high;
-			} else {
+			else
 				newrate = testrate_low;
-			}
 		}
 	}
 
@@ -1221,15 +1216,13 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 	major = MAJOR(tty_devnum(tty));
 	minor = MINOR(tty_devnum(tty));
 
-	if (major > 255) {
+	if (major > 255)
 		return -ENXIO;
-	}
 
 	/* Get board pointer from our array of majors we have allocated */
 	brd = dgnc_BoardsByMajor[major];
-	if (!brd) {
+	if (!brd)
 		return -ENXIO;
-	}
 
 	/*
 	 * If board is not yet up to a state of READY, go to
@@ -1238,9 +1231,8 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 	rc = wait_event_interruptible(brd->state_wait,
 		(brd->state & BOARD_READY));
 
-	if (rc) {
+	if (rc)
 		return rc;
-	}
 
 	DGNC_LOCK(brd->bd_lock, lock_flags);
 
@@ -1406,10 +1398,9 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 
 	rc = dgnc_block_til_ready(tty, file, ch);
 
-	if (rc) {
+	if (rc)
 		DPR_OPEN(("dgnc_tty_open returning after dgnc_block_til_ready "
 			"with %d\n", rc));
-	}
 
 	/* No going back now, increment our unit and channel counters */
 	DGNC_LOCK(ch->ch_lock, lock_flags);
@@ -1441,9 +1432,8 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 	}
 
 	un = tty->driver_data;
-	if (!un || un->magic != DGNC_UNIT_MAGIC) {
+	if (!un || un->magic != DGNC_UNIT_MAGIC)
 		return -ENXIO;
-	}
 
 	DPR_OPEN(("dgnc_block_til_ready - before block.\n"));
 
@@ -1486,9 +1476,8 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 			 * 3) DCD (fake or real) is active.
 			 */
 
-			if (file->f_flags & O_NONBLOCK) {
+			if (file->f_flags & O_NONBLOCK)
 				break;
-			}
 
 			if (tty->flags & (1 << TTY_IO_ERROR)) {
 				retval = -EIO;
@@ -1543,13 +1532,12 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 		/*
 		 * Wait for something in the flags to change from the current value.
 		 */
-		if (sleep_on_un_flags) {
+		if (sleep_on_un_flags)
 			retval = wait_event_interruptible(un->un_flags_wait,
 				(old_flags != (ch->ch_tun.un_flags | ch->ch_pun.un_flags)));
-		} else {
+		else
 			retval = wait_event_interruptible(ch->ch_flags_wait,
 				(old_flags != ch->ch_flags));
-		}
 
 		DPR_OPEN(("After sleep... retval: %x\n", retval));
 
@@ -1703,9 +1691,8 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 
 		DPR_CLOSE(("After calling wait_for_drain\n"));
 
-		if (rc) {
+		if (rc)
 			DPR_BASIC(("dgnc_tty_close - bad return: %d ", rc));
-		}
 
 		dgnc_tty_flush_buffer(tty);
 		tty_ldisc_flush(tty);
@@ -2077,9 +2064,8 @@ static int dgnc_tty_write(struct tty_struct *tty,
 		 * the board.
 		 */
 		/* we're allowed to block if it's from_user */
-		if (down_interruptible(&dgnc_TmpWriteSem)) {
+		if (down_interruptible(&dgnc_TmpWriteSem))
 			return -EINTR;
-		}
 
 		/*
 		 * copy_from_user() returns the number
@@ -2262,21 +2248,17 @@ static int dgnc_tty_tiocmset(struct tty_struct *tty,
 
 	DGNC_LOCK(ch->ch_lock, lock_flags);
 
-	if (set & TIOCM_RTS) {
+	if (set & TIOCM_RTS)
 		ch->ch_mostat |= UART_MCR_RTS;
-	}
 
-	if (set & TIOCM_DTR) {
+	if (set & TIOCM_DTR)
 		ch->ch_mostat |= UART_MCR_DTR;
-	}
 
-	if (clear & TIOCM_RTS) {
+	if (clear & TIOCM_RTS)
 		ch->ch_mostat &= ~(UART_MCR_RTS);
-	}
 
-	if (clear & TIOCM_DTR) {
+	if (clear & TIOCM_DTR)
 		ch->ch_mostat &= ~(UART_MCR_DTR);
-	}
 
 	ch->ch_bd->bd_ops->assert_modem_signals(ch);
 
@@ -2526,40 +2508,34 @@ static int dgnc_set_modem_info(struct tty_struct *tty, unsigned int command, uns
 
 	switch (command) {
 	case TIOCMBIS:
-		if (arg & TIOCM_RTS) {
+		if (arg & TIOCM_RTS)
 			ch->ch_mostat |= UART_MCR_RTS;
-		}
 
-		if (arg & TIOCM_DTR) {
+		if (arg & TIOCM_DTR)
 			ch->ch_mostat |= UART_MCR_DTR;
-		}
 
 		break;
 
 	case TIOCMBIC:
-		if (arg & TIOCM_RTS) {
+		if (arg & TIOCM_RTS)
 			ch->ch_mostat &= ~(UART_MCR_RTS);
-		}
 
-		if (arg & TIOCM_DTR) {
+		if (arg & TIOCM_DTR)
 			ch->ch_mostat &= ~(UART_MCR_DTR);
-		}
 
 		break;
 
 	case TIOCMSET:
 
-		if (arg & TIOCM_RTS) {
+		if (arg & TIOCM_RTS)
 			ch->ch_mostat |= UART_MCR_RTS;
-		} else {
+		else
 			ch->ch_mostat &= ~(UART_MCR_RTS);
-		}
 
-		if (arg & TIOCM_DTR) {
+		if (arg & TIOCM_DTR)
 			ch->ch_mostat |= UART_MCR_DTR;
-		} else {
+		else
 			ch->ch_mostat &= ~(UART_MCR_DTR);
-		}
 
 		break;
 
@@ -3037,9 +3013,8 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		 */
 		rc = tty_check_change(tty);
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
-		if (rc) {
+		if (rc)
 			return rc;
-		}
 
 		rc = ch->ch_bd->bd_ops->drain(tty, 0);
 
@@ -3070,9 +3045,8 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		 */
 		rc = tty_check_change(tty);
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
-		if (rc) {
+		if (rc)
 			return rc;
-		}
 
 		rc = ch->ch_bd->bd_ops->drain(tty, 0);
 		if (rc) {
@@ -3094,9 +3068,8 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 	case TIOCSBRK:
 		rc = tty_check_change(tty);
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
-		if (rc) {
+		if (rc)
 			return rc;
-		}
 
 		rc = ch->ch_bd->bd_ops->drain(tty, 0);
 		if (rc) {
@@ -3358,9 +3331,9 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-		if (copy_to_user(uarg, &buf, sizeof(buf))) {
+		if (copy_to_user(uarg, &buf, sizeof(buf)))
 			return -EFAULT;
-		}
+
 		return 0;
 	}
 
@@ -3377,9 +3350,9 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		/* NOTE: MORE EVENTS NEEDS TO BE ADDED HERE */
 		if (ch->ch_flags & CH_BREAK_SENDING)
 			events |= EV_TXB;
-		if ((ch->ch_flags & CH_STOP) || (ch->ch_flags & CH_FORCED_STOP)) {
+		if ((ch->ch_flags & CH_STOP) || (ch->ch_flags & CH_FORCED_STOP))
 			events |= (EV_OPU | EV_OPS);
-		}
+
 		if ((ch->ch_flags & CH_STOPI) || (ch->ch_flags & CH_FORCED_STOPI)) {
 			events |= (EV_IPU | EV_IPS);
 		}
@@ -3406,9 +3379,8 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		/*
 		 * Get data from user first.
 		 */
-		if (copy_from_user(&buf, uarg, sizeof(buf))) {
+		if (copy_from_user(&buf, uarg, sizeof(buf)))
 			return -EFAULT;
-		}
 
 		DGNC_LOCK(ch->ch_lock, lock_flags);
 
@@ -3437,24 +3409,22 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 		 * insert more characters into our queue for OPOST processing
 		 * that the RealPort Server doesn't know about.
 		 */
-		if (buf.txbuf > tdist) {
+		if (buf.txbuf > tdist)
 			buf.txbuf = tdist;
-		}
 
 		/*
 		 * Report whether our queue and UART TX are completely empty.
 		 */
-		if (count) {
+		if (count)
 			buf.txdone = 0;
-		} else {
+		else
 			buf.txdone = 1;
-		}
 
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 
-		if (copy_to_user(uarg, &buf, sizeof(buf))) {
+		if (copy_to_user(uarg, &buf, sizeof(buf)))
 			return -EFAULT;
-		}
+
 		return 0;
 	}
 	default:
-- 
1.7.9.5

