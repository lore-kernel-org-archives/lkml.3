Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaJPVCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 17:02:01 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54374 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752676AbaJPVCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 17:02:00 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 22/27] tty: Document hangup call tree
Date: Thu, 16 Oct 2014 16:25:20 -0400
Message-Id: <1413491125-20134-23-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add at-a-glance call tree for the various hangup methods.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 25e85b0..8effd44 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -664,6 +664,19 @@ static int tty_signal_session_leader(struct tty_struct *tty, int exit_session)
  *		  termios_rwsem resetting termios data
  *		  tasklist_lock to walk task list for hangup event
  *		    ->siglock to protect ->signal/->sighand
+ *
+ *	Call tree:
+ *	tty_hangup() =>	do_tty_hangup() -+
+ *					 |
+ *	tty_vhangup() ---------+	 |
+ *	tty_vhangup_self() ----+	 |
+ *	tty_vhangup_session() -+---------+
+ *      				 |
+ *				  __tty_hangup() -> __tty_hangup_standard() -+
+ *									     |
+ *      tty_vhangup_slave() ----> __tty_hangup() -> __tty_vhangup_slave() ---+
+ *									     |
+ *								 __tty_hangup_common()
  */
 static void __tty_hangup_common(struct tty_struct *tty, int exit_session)
 {
-- 
2.1.1

