Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114AbaKERut (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:50:49 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53597 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751949AbaKERup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:50:45 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next v2 12/26] tty: Document check_tty_count() requires tty_lock held
Date: Wed,  5 Nov 2014 12:12:55 -0500
Message-Id: <1415207589-15967-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
 <1415207589-15967-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holding the tty_lock() is necessary to prevent concurrent changes
to the tty count that may cause it to differ from the open file
list count. The tty_lock() is already held at all call sites.

NB: Note that the check for the pty master tty count is safe because
the slave's tty_lock() is held while decrementing the pty master
tty count.

Reviewed-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 276d939..41eeee0 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -275,6 +275,7 @@ int tty_paranoia_check(struct tty_struct *tty, struct inode *inode,
 	return 0;
 }
 
+/* Caller must hold tty_lock */
 static int check_tty_count(struct tty_struct *tty, const char *routine)
 {
 #ifdef CHECK_TTY_COUNT
-- 
2.1.3

