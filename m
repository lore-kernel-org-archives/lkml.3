Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbaBKXz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 18:55:57 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:39848 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaBKXz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 18:55:56 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: n_tty: Simplify input_available_p()
Date: Tue, 11 Feb 2014 18:55:30 -0500
Message-Id: <1392162930-4643-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Please note this patch requires
   n_tty: Fix poll() when TIME_CHAR and MIN_CHAR == 0

Regards,
Peter Hurley

--- >% ---
From: Peter Hurley <peter@hurleysoftware.com>
Date: Tue, 11 Feb 2014 10:19:14 -0500
Subject: [PATCH] n_tty: Simplify input_available_p()

Return the result of the respective boolean evaluation, rather
than evaluating and returning 0 or 1.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---

 drivers/tty/n_tty.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 2747a3b..df6dda6 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1898,13 +1898,10 @@ static inline int input_available_p(struct tty_struct *tty, int poll)
 	struct n_tty_data *ldata = tty->disc_data;
 	int amt = poll && !TIME_CHAR(tty) && MIN_CHAR(tty) ? MIN_CHAR(tty) : 1;
 
-	if (ldata->icanon && !L_EXTPROC(tty)) {
-		if (ldata->canon_head != ldata->read_tail)
-			return 1;
-	} else if (read_cnt(ldata) >= amt)
-		return 1;
-
-	return 0;
+	if (ldata->icanon && !L_EXTPROC(tty))
+		return ldata->canon_head != ldata->read_tail;
+	else
+		return read_cnt(ldata) >= amt;
 }
 
 /**
-- 
1.8.1.2

