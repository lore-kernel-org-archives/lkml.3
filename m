Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbbA2BeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:34:20 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50733 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbbA2BeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:34:17 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgnc: dgnc_tty: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:41:32 +0100
Message-Id: <1422484892-10146-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/dgnc/dgnc_tty.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index f81a375..bca2c07 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -1386,12 +1386,10 @@ static void dgnc_tty_hangup(struct tty_struct *tty)
  */
 static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 {
-	struct ktermios *ts;
 	struct dgnc_board *bd;
 	struct channel_t *ch;
 	struct un_t *un;
 	unsigned long flags;
-	int rc = 0;
 
 	if (!tty || tty->magic != TTY_MAGIC)
 		return;
@@ -1408,8 +1406,6 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
 
-	ts = &tty->termios;
-
 	spin_lock_irqsave(&ch->ch_lock, flags);
 
 	/*
@@ -1471,7 +1467,7 @@ static void dgnc_tty_close(struct tty_struct *tty, struct file *file)
 		/* wait for output to drain */
 		/* This will also return if we take an interrupt */
 
-		rc = bd->bd_ops->drain(tty, 0);
+		bd->bd_ops->drain(tty, 0);
 
 		dgnc_tty_flush_buffer(tty);
 		tty_ldisc_flush(tty);
@@ -2059,7 +2055,6 @@ static void dgnc_tty_wait_until_sent(struct tty_struct *tty, int timeout)
 	struct dgnc_board *bd;
 	struct channel_t *ch;
 	struct un_t *un;
-	int rc;
 
 	if (!tty || tty->magic != TTY_MAGIC)
 		return;
@@ -2076,7 +2071,7 @@ static void dgnc_tty_wait_until_sent(struct tty_struct *tty, int timeout)
 	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
 
-	rc = bd->bd_ops->drain(tty, 0);
+	bd->bd_ops->drain(tty, 0);
 }
 
 
-- 
1.7.10.4

