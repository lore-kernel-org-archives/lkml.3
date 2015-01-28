Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbbA2Bfy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:35:54 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41771 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbbA2Bfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:35:52 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Lidza Louina <lidza.louina@gmail.com>, Mark Hounschell <markh@compro.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Daeseok Youn <daeseok.youn@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgap: dgap: Removed variables that is never used
Date: Wed, 28 Jan 2015 23:40:20 +0100
Message-Id: <1422484820-9913-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/staging/dgap/dgap.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index bdb5317..f8a8c0a 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -3715,7 +3715,7 @@ static int dgap_tty_write(struct tty_struct *tty, const unsigned char *buf,
 		} else {
 			dgap_wmove(ch, ch->ch_digi.digi_offstr,
 				(int) ch->ch_digi.digi_offlen);
-			head = readw(&(bs->tx_head)) & tmask;
+			readw(&(bs->tx_head)) & tmask;
 			ch->ch_flags &= ~CH_PRON;
 		}
 	}
@@ -4586,7 +4586,6 @@ static int dgap_tty_open(struct tty_struct *tty, struct file *file)
  */
 static void dgap_tty_close(struct tty_struct *tty, struct file *file)
 {
-	struct ktermios *ts;
 	struct board_t *bd;
 	struct channel_t *ch;
 	struct un_t *un;
@@ -4607,8 +4606,6 @@ static void dgap_tty_close(struct tty_struct *tty, struct file *file)
 	if (!bd || bd->magic != DGAP_BOARD_MAGIC)
 		return;
 
-	ts = &tty->termios;
-
 	spin_lock_irqsave(&ch->ch_lock, lock_flags);
 
 	/*
-- 
1.7.10.4

