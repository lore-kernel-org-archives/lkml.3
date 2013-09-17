Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab3IQQyD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 12:54:03 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:48550 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab3IQQx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 12:53:59 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 2/3] n_tty: Remove unnecessary local variable
Date: Tue, 17 Sep 2013 12:53:35 -0400
Message-Id: <1379436816-14740-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379436816-14740-1-git-send-email-peter@hurleysoftware.com>
References: <1379436816-14740-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Flatten conditional evaluation in n_tty_set_termios; remove
canon_change.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 42d7ae7..28c468c 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1752,11 +1752,8 @@ int is_ignored(int sig)
 static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	int canon_change = 1;
 
-	if (old)
-		canon_change = (old->c_lflag ^ tty->termios.c_lflag) & ICANON;
-	if (canon_change) {
+	if (!old || (old->c_lflag ^ tty->termios.c_lflag) & ICANON) {
 		bitmap_zero(ldata->read_flags, N_TTY_BUF_SIZE);
 		ldata->line_start = ldata->canon_head = ldata->read_tail;
 		ldata->erasing = 0;
-- 
1.8.1.2

