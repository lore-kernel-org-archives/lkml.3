Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3IQQyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:54:24 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:48563 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3IQQyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:54:01 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 3/3] n_tty: Style fix in n_tty_set_termios
Date: Tue, 17 Sep 2013 12:53:36 -0400
Message-Id: <1379436816-14740-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379436816-14740-1-git-send-email-peter@hurleysoftware.com>
References: <1379436816-14740-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove braces from single-statement conditional in
n_tty_set_termios.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 28c468c..09505ff 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1814,9 +1814,8 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 	 * Fix tty hang when I_IXON(tty) is cleared, but the tty
 	 * been stopped by STOP_CHAR(tty) before it.
 	 */
-	if (!I_IXON(tty) && old && (old->c_iflag & IXON) && !tty->flow_stopped) {
+	if (!I_IXON(tty) && old && (old->c_iflag & IXON) && !tty->flow_stopped)
 		start_tty(tty);
-	}
 
 	/* The termios change make the tty ready for I/O */
 	wake_up_interruptible(&tty->write_wait);
-- 
1.8.1.2

