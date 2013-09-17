Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab3IQQyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:54:40 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:48532 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3IQQx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:53:58 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 1/3] n_tty: Remove superfluous reader wakeup
Date: Tue, 17 Sep 2013 12:53:34 -0400
Message-Id: <1379436816-14740-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379436816-14740-1-git-send-email-peter@hurleysoftware.com>
References: <1379436816-14740-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n_tty's .set_termios method unconditionally performs reader wakeup;
remove extra reader wakeup for canonical mode changes.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 01bf5eb..42d7ae7 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1763,9 +1763,6 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 		ldata->lnext = 0;
 	}
 
-	if (canon_change && !L_ICANON(tty) && read_cnt(ldata))
-		wake_up_interruptible(&tty->read_wait);
-
 	ldata->icanon = (L_ICANON(tty) != 0);
 
 	if (I_ISTRIP(tty) || I_IUCLC(tty) || I_IGNCR(tty) ||
-- 
1.8.1.2

