Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756702Ab3BEUn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:43:26 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:39735 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756639Ab3BEUnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:43:23 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 21/23] tty: Re-parent orphaned tty_set_ldisc() comments
Date: Tue,  5 Feb 2013 15:20:36 -0500
Message-Id: <1360095638-6624-22-git-send-email-peter@hurleysoftware.com>
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


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 92629c1..49e4825 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -545,10 +545,18 @@ static int tty_ldisc_halt(struct tty_struct *tty, struct tty_struct *o_tty,
 {
 	int scheduled, o_scheduled, retval;
 
+	/*
+	 *	The TTY_LDISC bit prevents anyone taking an ldisc
+	 *	reference once it is clear.
+	 */
 	clear_bit(TTY_LDISC, &tty->flags);
 	if (o_tty)
 		clear_bit(TTY_LDISC, &o_tty->flags);
 
+	/*
+	 *	Make sure we don't change while someone holds a
+	 *	reference to the line discipline.
+	 */
 	retval = tty_ldisc_wait_idle(tty, timeout);
 	if (!retval && o_tty)
 		retval = tty_ldisc_wait_idle(o_tty, timeout);
@@ -702,13 +710,9 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	o_ldisc = tty->ldisc;
 
 	tty_unlock(tty);
+
 	/*
-	 *	Make sure we don't change while someone holds a
-	 *	reference to the line discipline. The TTY_LDISC bit
-	 *	prevents anyone taking a reference once it is clear.
-	 *	We need the lock to avoid racing reference takers.
-	 *
-	 *	We must clear the TTY_LDISC bit here to avoid a livelock
+	 *	We must halt the line discipline here to avoid a livelock
 	 *	with a userspace app continually trying to use the tty in
 	 *	parallel to the change and re-referencing the tty.
 	 */
-- 
1.8.1.2

