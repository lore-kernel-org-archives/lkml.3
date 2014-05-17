Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068AbaEQARL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 20:17:11 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:45544 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaEQARK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 20:17:10 -0400
From: Masaru Nomura <massa.nomura@gmail.com>
To: lidza.louina@gmail.com, markh@compro.net
Cc: gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: dgnc: dgnc_tty: Add a required space
Date: Sat, 17 May 2014 01:17:07 +0100
Message-Id: <1400285827-6501-1-git-send-email-massa.nomura@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a required space before an open parenthesis of if statement
to meet kernel coding style.

Signed-off-by: Masaru Nomura <massa.nomura@gmail.com>
---
 drivers/staging/dgnc/dgnc_tty.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgnc/dgnc_tty.c b/drivers/staging/dgnc/dgnc_tty.c
index f0b17c3..c63c355 100644
--- a/drivers/staging/dgnc/dgnc_tty.c
+++ b/drivers/staging/dgnc/dgnc_tty.c
@@ -661,7 +661,7 @@ void dgnc_input(struct channel_t *ch)
 	tp = ch->ch_tun.un_tty;
 
 	bd = ch->ch_bd;
-	if(!bd || bd->magic != DGNC_BOARD_MAGIC)
+	if (!bd || bd->magic != DGNC_BOARD_MAGIC)
 		return;
 
 	DGNC_LOCK(ch->ch_lock, lock_flags);
@@ -1044,7 +1044,7 @@ void dgnc_check_queue_flow_control(struct channel_t *ch)
 	if (qleft < 256) {
 		/* HWFLOW */
 		if (ch->ch_digi.digi_flags & CTSPACE || ch->ch_c_cflag & CRTSCTS) {
-			if(!(ch->ch_flags & CH_RECEIVER_OFF)) {
+			if (!(ch->ch_flags & CH_RECEIVER_OFF)) {
 				ch->ch_bd->bd_ops->disable_receiver(ch);
 				ch->ch_flags |= (CH_RECEIVER_OFF);
 				DPR_READ(("Internal queue hit hilevel mark (%d)! Turning off interrupts.\n",
@@ -3061,7 +3061,7 @@ static int dgnc_tty_ioctl(struct tty_struct *tty, unsigned int cmd,
 
 		DGNC_LOCK(ch->ch_lock, lock_flags);
 
-		if(((cmd == TCSBRK) && (!arg)) || (cmd == TCSBRKP)) {
+		if (((cmd == TCSBRK) && (!arg)) || (cmd == TCSBRKP)) {
 			ch->ch_bd->bd_ops->send_break(ch, 250);
 		}
 
-- 
1.7.9.5

