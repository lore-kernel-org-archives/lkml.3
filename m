Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418Ab3FONZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:25:10 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43147 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab3FONVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:21:41 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 15/24] n_tty: Reset lnext if canonical mode changes
Date: Sat, 15 Jun 2013 09:14:27 -0400
Message-Id: <1371302076-4688-16-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
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
index c7f71cb..e63beab 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1574,6 +1574,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
 		ldata->canon_head = ldata->read_tail;
 		ldata->erasing = 0;
+		ldata->lnext = 0;
 	}
 
 	if (canon_change && !L_ICANON(tty) && read_cnt(ldata))
-- 
1.8.1.2

