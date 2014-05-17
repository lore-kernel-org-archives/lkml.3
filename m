Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030246AbaEQQdt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:33:49 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:43725 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030185AbaEQQdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:33:46 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Masaru Nomura <massa.nomura@gmail.com>
Subject: [PATCH 4/4] staging: dgnc: Remove unnecessary braces
Date: Sat, 17 May 2014 17:30:54 +0100
Message-Id: <1400344254-13007-5-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
References: <1400344254-13007-1-git-send-email-massa.nomura@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary braces of if-else statements in dgnc_neo.c and
dgnc_tty.c to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 drivers/staging/dgnc/dgnc_neo.c |   20 ++++++++------------
 drivers/staging/dgnc/dgnc_tty.c |   10 ++++------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index c211f9f..c4ab17b 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -828,11 +828,10 @@ static void neo_param(struct tty_struct *tty)
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
@@ -842,11 +841,10 @@ static void neo_param(struct tty_struct *tty)
 			|| (ch->ch_digi.digi_flags & RTSPACE)
 			|| (ch->ch_c_cflag & CRTSCTS)
 			|| !(ch->ch_digi.digi_flags & DIGI_FORCEDCD)
-			|| !(ch->ch_c_cflag & CLOCAL)) {
+			|| !(ch->ch_c_cflag & CLOCAL))
 		ier |= UART_IER_MSI;
-	} else {
+	else
 		ier &= ~UART_IER_MSI;
-	}
 
 	ier |= UART_IER_THRI;
 
@@ -1216,11 +1214,10 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
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
 
 
@@ -1423,11 +1420,10 @@ static int neo_drain(struct tty_struct *tty, uint seconds)
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
diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index e432c04..cda2254 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -2549,17 +2549,15 @@ static int dgnc_set_modem_info(struct tty_struct *tty, unsigned int command, uns
 
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
 
-- 
1.7.9.5

