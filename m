Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab3B0Vad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:30:33 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:53454 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3B0Vab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:30:31 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: Daniel Mack <zonque@gmail.com>, Larry Finger <Larry.Finger@lwfinger.net>,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] TTY: disable debugging warning
Date: Wed, 27 Feb 2013 22:30:24 +0100
Message-Id: <1362000624-18155-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We added a warning to flush_to_ldisc to report cases when it is called
with a NULL tty. It was for debugging purposes and it lead to a
patchset from Peter Hurley. The patchset however did not make it to
3.9, so disable the warning now to not disturb people.

We can re-add it when the series is in and we are hunting for another
bugs.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index bb11993..578aa75 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -425,7 +425,7 @@ static void flush_to_ldisc(struct work_struct *work)
 	struct tty_ldisc *disc;
 
 	tty = port->itty;
-	if (WARN_RATELIMIT(tty == NULL, "tty is NULL\n"))
+	if (tty == NULL)
 		return;
 
 	disc = tty_ldisc_ref(tty);
-- 
1.8.1.4


