Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987Ab3DOPcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:32:46 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45882 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600Ab3DOPcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:32:42 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 15/24] n_tty: Reset lnext if canonical mode changes
Date: Mon, 15 Apr 2013 11:19:19 -0400
Message-Id: <1366039168-8510-16-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lnext escapes the next input character as a literal, and must
be reset when canonical mode changes (to avoid misinterpreting
a special character as a literal if canonical mode is changed
back again).

lnext is specifically not reset on a buffer flush so as to avoid
misinterpreting the next input character as a special character.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 6691920..98bc9df 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1575,6 +1575,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
 		ldata->canon_head = ldata->read_tail;
 		ldata->erasing = 0;
+		ldata->lnext = 0;
 	}
 
 	if (canon_change && !L_ICANON(tty) && read_cnt(ldata))
-- 
1.8.1.2

