Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030205AbaEQQdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:33:39 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:38684 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030185AbaEQQdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:33:37 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH 1/4] staging: dgnc: Fix indenting of if-else statement
Date: Sat, 17 May 2014 17:30:51 +0100
Message-Id: <1400344254-13007-2-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
References: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix indenting of if-else statement in dgnc_neo.c and dgnc_tty.c
so that following else-if or else statement meets coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 drivers/staging/dgnc/dgnc_neo.c |   48 +++++++++++++--------------------------
 drivers/staging/dgnc/dgnc_tty.c |   36 ++++++++++-------------------
 2 files changed, 28 insertions(+), 56 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index cf22c7b..e87cf49 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -485,8 +485,7 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 					DGNC_UNLOCK(ch->ch_lock, lock_flags);
 				}
 				DPR_INTR(("Port %d. XON detected in incoming data\n", port));
-			}
-			else if (cause == UART_17158_XOFF_DETECT) {
+			} else if (cause == UART_17158_XOFF_DETECT) {
 				if (!(brd->channels[port]->ch_flags & CH_STOP)) {
 					DGNC_LOCK(ch->ch_lock, lock_flags);
 					ch->ch_flags |= CH_STOP;
@@ -511,8 +510,7 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 					DGNC_LOCK(ch->ch_lock, lock_flags);
 					ch->ch_mostat |= UART_MCR_RTS;
 					DGNC_UNLOCK(ch->ch_lock, lock_flags);
-				}
-				else {
+				} else {
 					DGNC_LOCK(ch->ch_lock, lock_flags);
 					ch->ch_mostat &= ~(UART_MCR_RTS);
 					DGNC_UNLOCK(ch->ch_lock, lock_flags);
@@ -522,8 +520,7 @@ static inline void neo_parse_isr(struct dgnc_board *brd, uint port)
 					DGNC_LOCK(ch->ch_lock, lock_flags);
 					ch->ch_mostat |= UART_MCR_DTR;
 					DGNC_UNLOCK(ch->ch_lock, lock_flags);
-				}
-				else {
+				} else {
 					DGNC_LOCK(ch->ch_lock, lock_flags);
 					ch->ch_mostat &= ~(UART_MCR_DTR);
 					DGNC_UNLOCK(ch->ch_lock, lock_flags);
@@ -624,8 +621,7 @@ static inline void neo_parse_lsr(struct dgnc_board *brd, uint port)
 
 		/* Transfer data (if any) from Write Queue -> UART. */
 		neo_copy_data_from_queue_to_uart(ch);
-	}
-	else if (linestatus & UART_17158_TX_AND_FIFO_CLR) {
+	} else if (linestatus & UART_17158_TX_AND_FIFO_CLR) {
 		brd->intr_tx++;
 		ch->ch_intr_tx++;
 		DGNC_LOCK(ch->ch_lock, lock_flags);
@@ -834,8 +830,7 @@ static void neo_param(struct tty_struct *tty)
 
 	if (ch->ch_c_cflag & CREAD) {
 		ier |= (UART_IER_RDI | UART_IER_RLSI);
-	}
-	else {
+	} else {
 		ier &= ~(UART_IER_RDI | UART_IER_RLSI);
 	}
 
@@ -848,8 +843,7 @@ static void neo_param(struct tty_struct *tty)
 		!(ch->ch_c_cflag & CLOCAL))
 	{
 		ier |= UART_IER_MSI;
-	}
-	else {
+	} else {
 		ier &= ~UART_IER_MSI;
 	}
 
@@ -863,29 +857,25 @@ static void neo_param(struct tty_struct *tty)
 
 	if (ch->ch_digi.digi_flags & CTSPACE || ch->ch_c_cflag & CRTSCTS) {
 		neo_set_cts_flow_control(ch);
-	}
-	else if (ch->ch_c_iflag & IXON) {
+	} else if (ch->ch_c_iflag & IXON) {
 		/* If start/stop is set to disable, then we should disable flow control */
 		if ((ch->ch_startc == _POSIX_VDISABLE) || (ch->ch_stopc == _POSIX_VDISABLE))
 			neo_set_no_output_flow_control(ch);
 		else
 			neo_set_ixon_flow_control(ch);
-	}
-	else {
+	} else {
 		neo_set_no_output_flow_control(ch);
 	}
 
 	if (ch->ch_digi.digi_flags & RTSPACE || ch->ch_c_cflag & CRTSCTS) {
 		neo_set_rts_flow_control(ch);
-	}
-	else if (ch->ch_c_iflag & IXOFF) {
+	} else if (ch->ch_c_iflag & IXOFF) {
 		/* If start/stop is set to disable, then we should disable flow control */
 		if ((ch->ch_startc == _POSIX_VDISABLE) || (ch->ch_stopc == _POSIX_VDISABLE))
 			neo_set_no_input_flow_control(ch);
 		else
 			neo_set_ixoff_flow_control(ch);
-	}
-	else {
+	} else {
 		neo_set_no_input_flow_control(ch);
 	}
 
@@ -1227,8 +1217,7 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
 		 */
 		if ((ch->ch_bd->dvid & 0xf0) >= UART_XR17E158_DVID) {
 			total -= 1;
-		}
-		else {
+		} else {
 			total -= 3;
 		}
 	}
@@ -1435,8 +1424,7 @@ static int neo_drain(struct tty_struct *tty, uint seconds)
 	/* If ret is non-zero, user ctrl-c'ed us */
 	if (rc) {
 		DPR_IOCTL(("%d Drain - User ctrl c'ed\n", __LINE__));
-	}
-	else {
+	} else {
 		DPR_IOCTL(("%d Drain wait finished.\n", __LINE__));
 	}
 
@@ -1468,8 +1456,7 @@ static void neo_flush_uart_write(struct channel_t *ch)
 		if (tmp & 4) {
 			DPR_IOCTL(("Still flushing TX UART... i: %d\n", i));
 			udelay(10);
-		}
-		else
+		} else
 			break;
 	}
 
@@ -1501,8 +1488,7 @@ static void neo_flush_uart_read(struct channel_t *ch)
 		if (tmp & 2) {
 			DPR_IOCTL(("Still flushing RX UART... i: %d\n", i));
 			udelay(10);
-		}
-		else
+		} else
 			break;
 	}
 }
@@ -1598,8 +1584,7 @@ static void neo_copy_data_from_queue_to_uart(struct channel_t *ch)
 		}
 
 		n = UART_17158_TX_FIFOSIZE - ch->ch_t_tlevel;
-	}
-	else {
+	} else {
 		n = UART_17158_TX_FIFOSIZE - readb(&ch->ch_neo_uart->tfifo);
 	}
 
@@ -1963,8 +1948,7 @@ static void neo_vpd(struct dgnc_board *brd)
 		||  (brd->vpd[0x7F] != 0x78))   /* small resource end tag */
 	{
 		memset(brd->vpd, '\0', NEO_VPD_IMAGESIZE);
-	}
-	else {
+	} else {
 		/* Search for the serial number */
 		for (i = 0; i < NEO_VPD_IMAGEBYTES - 3; i++) {
 			if (brd->vpd[i] == 'S' && brd->vpd[i + 1] == 'N') {
diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index f0b17c3..e432c04 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -803,8 +803,7 @@ void dgnc_input(struct channel_t *ch)
 				else
 					tty_insert_flip_char(tp->port, *(ch->ch_rqueue + tail + i), TTY_NORMAL);
 			}
-		}
-		else {
+		} else {
 			tty_insert_flip_string(tp->port, ch->ch_rqueue + tail, s);
 		}
 
@@ -1267,12 +1266,10 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 	if (!IS_PRINT(minor)) {
 		un = &brd->channels[PORT_NUM(minor)]->ch_tun;
 		un->un_type = DGNC_SERIAL;
-	}
-	else if (IS_PRINT(minor)) {
+	} else if (IS_PRINT(minor)) {
 		un = &brd->channels[PORT_NUM(minor)]->ch_pun;
 		un->un_type = DGNC_PRINT;
-	}
-	else {
+	} else {
 		DGNC_UNLOCK(ch->ch_lock, lock_flags);
 		DPR_OPEN(("%d Unknown TYPE!\n", __LINE__));
 		return -ENXIO;
@@ -1507,8 +1504,7 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 				DPR_OPEN(("%d: ch_flags: %x\n", __LINE__, ch->ch_flags));
 				break;
 			}
-		}
-		else {
+		} else {
 			sleep_on_un_flags = 1;
 		}
 
@@ -1550,8 +1546,7 @@ static int dgnc_block_til_ready(struct tty_struct *tty, struct file *file, struc
 		if (sleep_on_un_flags) {
 			retval = wait_event_interruptible(un->un_flags_wait,
 				(old_flags != (ch->ch_tun.un_flags | ch->ch_pun.un_flags)));
-		}
-		else {
+		} else {
 			retval = wait_event_interruptible(ch->ch_flags_wait,
 				(old_flags != ch->ch_flags));
 		}
@@ -1748,8 +1743,7 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 
 		/* Turn off UART interrupts for this port */
 		ch->ch_bd->bd_ops->uart_off(ch);
-	}
-	else {
+	} else {
 		/*
 		 * turn off print device when closing print device.
 		 */
@@ -1867,12 +1861,10 @@ static int dgnc_maxcps_room(struct tty_struct *tty, int bytes_available)
 			/* buffer is empty */
 			ch->ch_cpstime = current_time;	    /* reset ch_cpstime */
 			cps_limit = ch->ch_digi.digi_bufsize;
-		}
-		else if (ch->ch_cpstime < buffer_time) {
+		} else if (ch->ch_cpstime < buffer_time) {
 			/* still room in the buffer */
 			cps_limit = ((buffer_time - ch->ch_cpstime) * ch->ch_digi.digi_maxcps) / HZ;
-		}
-		else {
+		} else {
 			/* no room in the buffer */
 			cps_limit = 0;
 		}
@@ -1931,8 +1923,7 @@ static int dgnc_tty_write_room(struct tty_struct *tty)
 		if (!(ch->ch_flags & CH_PRON))
 			ret -= ch->ch_digi.digi_onlen;
 		ret -= ch->ch_digi.digi_offlen;
-	}
-	else {
+	} else {
 		if (ch->ch_flags & CH_PRON)
 			ret -= ch->ch_digi.digi_offlen;
 	}
@@ -2560,15 +2551,13 @@ static int dgnc_set_modem_info(struct tty_struct *tty, unsigned int command, uns
 
 		if (arg & TIOCM_RTS) {
 			ch->ch_mostat |= UART_MCR_RTS;
-		}
-		else {
+		} else {
 			ch->ch_mostat &= ~(UART_MCR_RTS);
 		}
 
 		if (arg & TIOCM_DTR) {
 			ch->ch_mostat |= UART_MCR_DTR;
-		}
-		else {
+		} else {
 			ch->ch_mostat &= ~(UART_MCR_DTR);
 		}
 
@@ -3279,8 +3268,7 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 				return -EINTR;
 			}
 			DGNC_LOCK(ch->ch_lock, lock_flags);
-		}
-		else {
+		} else {
 			tty_ldisc_flush(tty);
 		}
 		/* fall thru */
-- 
1.7.9.5

