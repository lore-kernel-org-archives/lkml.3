Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab3AUW1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 17:27:54 -0500
Received: from gimli.pxnet.com ([89.1.7.7]:45315 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218Ab3AUW0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 17:26:42 -0500
X-Greylist: delayed 1730 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jan 2013 17:26:35 EST
From: Tilman Schmidt <tilman@imap.cc>
To: Karsten Keil <isdn@linux-pingi.de>, David Miller <davem@davemloft.net>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <keil@b1-systems.de>,
        i4ldeveloper@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130121-patch-isdn-03.tilman@imap.cc>
In-Reply-To: <20130121-patch-isdn-00.tilman@imap.cc>
References: <20130121-patch-isdn-00.tilman@imap.cc>
Subject: [PATCH 3/6] isdn/gigaset: beautify interface.c
Date: Mon, 21 Jan 2013 22:57:20 +0100 (CET)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (mail.pxnet.com [89.1.7.7]); Mon, 21 Jan 2013 22:57:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid forward declarations and remove a needless initialization.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/interface.c |   46 ++++++++++++-------------------------
 1 files changed, 15 insertions(+), 31 deletions(-)

diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index 67abf3f..20b7e7a 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -112,36 +112,6 @@ static int if_config(struct cardstate *cs, int *arg)
 }
 
 /*** the terminal driver ***/
-/* stolen from usbserial and some other tty drivers */
-
-static int  if_open(struct tty_struct *tty, struct file *filp);
-static void if_close(struct tty_struct *tty, struct file *filp);
-static int  if_ioctl(struct tty_struct *tty,
-		     unsigned int cmd, unsigned long arg);
-static int  if_write_room(struct tty_struct *tty);
-static int  if_chars_in_buffer(struct tty_struct *tty);
-static void if_throttle(struct tty_struct *tty);
-static void if_unthrottle(struct tty_struct *tty);
-static void if_set_termios(struct tty_struct *tty, struct ktermios *old);
-static int  if_tiocmget(struct tty_struct *tty);
-static int  if_tiocmset(struct tty_struct *tty,
-			unsigned int set, unsigned int clear);
-static int  if_write(struct tty_struct *tty,
-		     const unsigned char *buf, int count);
-
-static const struct tty_operations if_ops = {
-	.open =			if_open,
-	.close =		if_close,
-	.ioctl =		if_ioctl,
-	.write =		if_write,
-	.write_room =		if_write_room,
-	.chars_in_buffer =	if_chars_in_buffer,
-	.set_termios =		if_set_termios,
-	.throttle =		if_throttle,
-	.unthrottle =		if_unthrottle,
-	.tiocmget =		if_tiocmget,
-	.tiocmset =		if_tiocmset,
-};
 
 static int if_open(struct tty_struct *tty, struct file *filp)
 {
@@ -355,7 +325,7 @@ done:
 static int if_write_room(struct tty_struct *tty)
 {
 	struct cardstate *cs = tty->driver_data;
-	int retval = -ENODEV;
+	int retval;
 
 	gig_dbg(DEBUG_IF, "%u: %s()", cs->minor_index, __func__);
 
@@ -498,6 +468,20 @@ out:
 	mutex_unlock(&cs->mutex);
 }
 
+static const struct tty_operations if_ops = {
+	.open =			if_open,
+	.close =		if_close,
+	.ioctl =		if_ioctl,
+	.write =		if_write,
+	.write_room =		if_write_room,
+	.chars_in_buffer =	if_chars_in_buffer,
+	.set_termios =		if_set_termios,
+	.throttle =		if_throttle,
+	.unthrottle =		if_unthrottle,
+	.tiocmget =		if_tiocmget,
+	.tiocmset =		if_tiocmset,
+};
+
 
 /* wakeup tasklet for the write operation */
 static void if_wake(unsigned long data)
-- 
1.7.3.4

