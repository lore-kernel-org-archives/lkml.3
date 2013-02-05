Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3BEVKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:10:15 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:42208 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756073Ab3BEVKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:10:11 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] pty: Remove redundant itty reset
Date: Tue,  5 Feb 2013 16:08:50 -0500
Message-Id: <1360098530-7018-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

port->itty has already been reset by release_tty() before
pty_cleanup() is called.

Call stack:
release_tty()
  tty_kref_put()
    queue_release_one_tty()
      release_one_tty() : workqueue
        tty->ops->cleanup()
          pty_cleanup()

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index c24b4db..71e456a 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -413,7 +413,6 @@ static void pty_unix98_shutdown(struct tty_struct *tty)
 
 static void pty_cleanup(struct tty_struct *tty)
 {
-	tty->port->itty = NULL;
 	tty_port_put(tty->port);
 }
 
-- 
1.8.1.2

