Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab3C0LuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 07:50:06 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:54546 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab3C0LsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 07:48:10 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Min Zhang <mzhang@mvista.com>, Ilya Zykov <linux@izyk.ru>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 15/18] n_tty: Reset lnext if canonical mode changes
Date: Wed, 27 Mar 2013 07:44:05 -0400
Message-Id: <1364384648-6636-16-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
References: <1363724513-15604-1-git-send-email-peter@hurleysoftware.com>
 <1364384648-6636-1-git-send-email-peter@hurleysoftware.com>
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
index b1b934c..9d7badc 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1577,6 +1577,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
 		ldata->canon_head = ldata->read_tail;
 		ldata->erasing = 0;
+		ldata->lnext = 0;
 	}
 
 	if (canon_change && !L_ICANON(tty) && read_cnt(ldata))
-- 
1.8.1.2

