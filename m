Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab3CKVPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:15:38 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33462 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab3CKVP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:28 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 33/44] tty: Clarify multiple-references comment in TIOCSETD ioctl
Date: Mon, 11 Mar 2013 16:44:53 -0400
Message-Id: <1363034704-28036-34-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 84ba790..9725c94 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -567,13 +567,15 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		tty_ldisc_restore(tty, old_ldisc);
 	}
 
-	/* At this point we hold a reference to the new ldisc and a
-	   a reference to the old ldisc. If we ended up flipping back
-	   to the existing ldisc we have two references to it */
-
 	if (tty->ldisc->ops->num != old_ldisc->ops->num && tty->ops->set_ldisc)
 		tty->ops->set_ldisc(tty);
 
+	/* At this point we hold a reference to the new ldisc and a
+	   reference to the old ldisc, or we hold two references to
+	   the old ldisc (if it was restored as part of error cleanup
+	   above). In either case, releasing a single reference from
+	   the old ldisc is correct. */
+
 	tty_ldisc_put(old_ldisc);
 
 	/*
-- 
1.8.1.2

