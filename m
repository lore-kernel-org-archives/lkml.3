Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbaJPTtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:49:13 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:50025 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752393AbaJPTtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:49:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 10/10] tty: Update code comment in __proc_set_tty()
Date: Thu, 16 Oct 2014 14:59:50 -0400
Message-Id: <1413485990-16855-11-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
References: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The session and foreground process group pid references will be
non-NULL if tiocsctty() is stealing the controlling tty from another
session (ie., arg == 1 in tiocsctty()).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 7def510..e18491a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -516,8 +516,11 @@ static void __proc_set_tty(struct tty_struct *tty)
 {
 	unsigned long flags;
 
-	/* We should not have a session or pgrp to put here but.... */
 	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	/*
+	 * The session and fg pgrp references will be non-NULL if
+	 * tiocsctty() is stealing the controlling tty
+	 */
 	put_pid(tty->session);
 	put_pid(tty->pgrp);
 	tty->pgrp = get_pid(task_pgrp(current));
-- 
2.1.1

