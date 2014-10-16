Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaJPTAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:00:35 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:41299 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751854AbaJPTAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:00:01 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 01/10] tty: Remove tty_pair_get_tty()/tty_pair_get_pty() api
Date: Thu, 16 Oct 2014 14:59:41 -0400
Message-Id: <1413485990-16855-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
References: <1413485990-16855-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_pair_get_pty() has no in-tree users and tty_pair_get_tty()
has only one file-local user. Remove the external declarations,
the export declarations, and declare tty_pair_get_tty() static.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 16 +++++-----------
 include/linux/tty.h  |  3 ---
 2 files changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 8cce5ab..274e386 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2710,23 +2710,17 @@ static int tty_tiocgicount(struct tty_struct *tty, void __user *arg)
 	return 0;
 }
 
-struct tty_struct *tty_pair_get_tty(struct tty_struct *tty)
+/*
+ * if pty, return the slave side (real_tty)
+ * otherwise, return self
+ */
+static struct tty_struct *tty_pair_get_tty(struct tty_struct *tty)
 {
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
 		tty = tty->link;
 	return tty;
 }
-EXPORT_SYMBOL(tty_pair_get_tty);
-
-struct tty_struct *tty_pair_get_pty(struct tty_struct *tty)
-{
-	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
-	    tty->driver->subtype == PTY_TYPE_MASTER)
-	    return tty;
-	return tty->link;
-}
-EXPORT_SYMBOL(tty_pair_get_pty);
 
 /*
  * Split this up, as gcc can choke on it otherwise..
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5171ef8..b36b0b4 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -498,9 +498,6 @@ extern int tty_init_termios(struct tty_struct *tty);
 extern int tty_standard_install(struct tty_driver *driver,
 		struct tty_struct *tty);
 
-extern struct tty_struct *tty_pair_get_tty(struct tty_struct *tty);
-extern struct tty_struct *tty_pair_get_pty(struct tty_struct *tty);
-
 extern struct mutex tty_mutex;
 extern spinlock_t tty_files_lock;
 
-- 
2.1.1

