Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbaIANrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 09:47:24 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57687 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbaIANrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 09:47:23 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Seunghun Lee <waydi1@gmail.com>, Lidza Louina <lidza.louina@gmail.com>,
        Mark Hounschell <markh@compro.net>
Subject: [PATCH] staging: dgnc: split two assignments into the two assignments on two lines.
Date: Mon,  1 Sep 2014 22:46:59 +0900
Message-Id: <1409579219-5956-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

split two assignments into the two assignments on two lines.

CC: Lidza Louina <lidza.louina@gmail.com>
CC: Mark Hounschell <markh@compro.net>
Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/dgnc/TODO          |    2 --
 drivers/staging/dgnc/dgnc_cls.c    |   15 ++++++++++-----
 drivers/staging/dgnc/dgnc_driver.c |   10 ++++++----
 drivers/staging/dgnc/dgnc_neo.c    |   16 +++++++++++-----
 drivers/staging/dgnc/dgnc_tty.c    |    9 ++++++---
 5 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/dgnc/TODO b/drivers/staging/dgnc/TODO
index d2828c7..22adff1 100644
--- a/drivers/staging/dgnc/TODO
+++ b/drivers/staging/dgnc/TODO
@@ -1,6 +1,4 @@
 * checkpatch fixes
-* split two assignments into the two assignments on two lines;
-  don't use two equals signs
 * remove unecessary comments
 * remove unecessary error messages. Example kzalloc() has its 
   own error message. Adding an extra one is useless.
diff --git a/drivers/staging/dgnc/dgnc_cls.c b/drivers/staging/dgnc/dgnc_cls.c
index 84b1377..0393d6d 100644
--- a/drivers/staging/dgnc/dgnc_cls.c
+++ b/drivers/staging/dgnc/dgnc_cls.c
@@ -493,9 +493,12 @@ static void cls_param(struct tty_struct *tty)
 	 * If baud rate is zero, flush queues, and set mval to drop DTR.
 	 */
 	if ((ch->ch_c_cflag & (CBAUD)) == 0) {
-		ch->ch_r_head = ch->ch_r_tail = 0;
-		ch->ch_e_head = ch->ch_e_tail = 0;
-		ch->ch_w_head = ch->ch_w_tail = 0;
+		ch->ch_r_head = 0;
+		ch->ch_r_tail = 0;
+		ch->ch_e_head = 0;
+		ch->ch_e_tail = 0;
+		ch->ch_w_head = 0;
+		ch->ch_w_tail = 0;
 
 		cls_flush_uart_write(ch);
 		cls_flush_uart_read(ch);
@@ -627,7 +630,8 @@ static void cls_param(struct tty_struct *tty)
 		break;
 	}
 
-	ier = uart_ier = readb(&ch->ch_cls_uart->ier);
+	uart_ier = readb(&ch->ch_cls_uart->ier);
+	ier =  uart_ier;
 	uart_lcr = readb(&ch->ch_cls_uart->lcr);
 
 	if (baud == 0)
@@ -915,7 +919,8 @@ static void cls_copy_data_from_uart_to_queue(struct channel_t *ch)
 		 * I hope thats okay with everyone? Yes? Good.
 		 */
 		while (qleft < 1) {
-			ch->ch_r_tail = tail = (tail + 1) & RQUEUEMASK;
+			tail = (tail + 1) & RQUEUEMASK;
+			ch->ch_r_tail = tail;
 			ch->ch_err_overrun++;
 			qleft++;
 		}
diff --git a/drivers/staging/dgnc/dgnc_driver.c b/drivers/staging/dgnc/dgnc_driver.c
index 11bed56..2cc02c9 100644
--- a/drivers/staging/dgnc/dgnc_driver.c
+++ b/drivers/staging/dgnc/dgnc_driver.c
@@ -410,14 +410,16 @@ static int dgnc_found_board(struct pci_dev *pdev, int id)
 	unsigned long flags;
 
 	/* get the board structure and prep it */
-	brd = dgnc_Board[dgnc_NumBoards] =
-		kzalloc(sizeof(*brd), GFP_KERNEL);
+	dgnc_Board[dgnc_NumBoards] = kzalloc(sizeof(*brd), GFP_KERNEL);
+	brd = dgnc_Board[dgnc_NumBoards];
+
 	if (!brd)
 		return -ENOMEM;
 
 	/* make a temporary message buffer for the boot messages */
-	brd->msgbuf = brd->msgbuf_head =
-		kzalloc(sizeof(u8) * 8192, GFP_KERNEL);
+	brd->msgbuf_head = kzalloc(sizeof(u8) * 8192, GFP_KERNEL);
+	brd->msgbuf = brd->msgbuf_head;
+
 	if (!brd->msgbuf) {
 		kfree(brd);
 		return -ENOMEM;
diff --git a/drivers/staging/dgnc/dgnc_neo.c b/drivers/staging/dgnc/dgnc_neo.c
index 920ce2d..d6f4a80 100644
--- a/drivers/staging/dgnc/dgnc_neo.c
+++ b/drivers/staging/dgnc/dgnc_neo.c
@@ -626,9 +626,12 @@ static void neo_param(struct tty_struct *tty)
 	 * If baud rate is zero, flush queues, and set mval to drop DTR.
 	 */
 	if ((ch->ch_c_cflag & (CBAUD)) == 0) {
-		ch->ch_r_head = ch->ch_r_tail = 0;
-		ch->ch_e_head = ch->ch_e_tail = 0;
-		ch->ch_w_head = ch->ch_w_tail = 0;
+		ch->ch_r_head = 0;
+		ch->ch_r_tail = 0;
+		ch->ch_e_head = 0;
+		ch->ch_e_tail = 0;
+		ch->ch_w_head = 0;
+		ch->ch_w_tail = 0;
 
 		neo_flush_uart_write(ch);
 		neo_flush_uart_read(ch);
@@ -754,7 +757,9 @@ static void neo_param(struct tty_struct *tty)
 		break;
 	}
 
-	ier = uart_ier = readb(&ch->ch_neo_uart->ier);
+	uart_ier = readb(&ch->ch_neo_uart->ier);
+	ier = uart_ier;
+
 	uart_lcr = readb(&ch->ch_neo_uart->lcr);
 
 	if (baud == 0)
@@ -1285,7 +1290,8 @@ static void neo_copy_data_from_uart_to_queue(struct channel_t *ch)
 		 * I hope thats okay with everyone? Yes? Good.
 		 */
 		while (qleft < 1) {
-			ch->ch_r_tail = tail = (tail + 1) & RQUEUEMASK;
+			tail = (tail + 1) & RQUEUEMASK;
+			ch->ch_r_tail = tail;
 			ch->ch_err_overrun++;
 			qleft++;
 		}
diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index afb20a3..5cbec57 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -1293,9 +1293,12 @@ static int dgnc_tty_open(struct tty_struct *tty, struct file *file)
 		/*
 		 * Flush input queues.
 		 */
-		ch->ch_r_head = ch->ch_r_tail = 0;
-		ch->ch_e_head = ch->ch_e_tail = 0;
-		ch->ch_w_head = ch->ch_w_tail = 0;
+		ch->ch_r_head = 0;
+		ch->ch_r_tail = 0;
+		ch->ch_e_head = 0;
+		ch->ch_e_tail = 0;
+		ch->ch_w_head = 0;
+		ch->ch_w_tail = 0;
 
 		brd->bd_ops->flush_uart_write(ch);
 		brd->bd_ops->flush_uart_read(ch);
-- 
1.7.9.5

