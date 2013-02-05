Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3BEUnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:43:23 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:52144 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756549Ab3BEUnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:43:18 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 19/23] tty: Fix 'deferred reopen' ldisc comment
Date: Tue,  5 Feb 2013 15:20:34 -0500
Message-Id: <1360095638-6624-20-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
 <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This comment is a victim of code migration from
"tty: Fix the ldisc hangup race"; re-parent it.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index f3cbfb3..d7ebe79 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -875,11 +875,12 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 */
 	mutex_lock(&tty->ldisc_mutex);
 
-	/* At this point we have a closed ldisc and we want to
-	   reopen it. We could defer this to the next open but
-	   it means auditing a lot of other paths so this is
-	   a FIXME */
 	if (tty_ldisc_hangup_halt(tty) && !test_bit(TTY_CLOSING, &tty->flags)) {
+
+		/* At this point we have a halted ldisc; we want to close it and
+		   reopen a new ldisc. We could defer the reopen to the next
+		   open but it means auditing a lot of other paths so this is
+		   a FIXME */
 		if (reset == 0) {
 
 			if (!tty_ldisc_reinit(tty, tty->termios.c_line))
-- 
1.8.1.2

