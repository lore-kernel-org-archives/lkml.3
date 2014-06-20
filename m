Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935066AbaFTQbM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:31:12 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35171 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934714AbaFTQbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:31:09 -0400
From: Vincent Heuken <me@vincentheuken.com>
To: gregkh@linuxfoundation.org, thomas_75@safe-mail.net, himangi774@gmail.com,
        paul.gortmaker@windriver.com, aybuke.147@gmail.com, arnd@arndb.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Vincent Heuken <me@vincentheuken.com>
Subject: [PATCH] Staging: serqt_usb2: fixed frivolous else statement warnings
Date: Fri, 20 Jun 2014 09:31:28 -0700
Message-Id: <1403281888-12873-1-git-send-email-me@vincentheuken.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the serqt_usb2.c file that fixes two instances
of the following checkpatch.pl warning:
WARNING: else is not generally useful after a break or return

Signed-off-by: Vincent Heuken <me@vincentheuken.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 47 +++++++++++++++++----------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 998c384..98e9736 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -981,9 +981,8 @@ static void qt_block_until_empty(struct tty_struct *tty,
 		if (wait == 0) {
 			dev_dbg(&qt_port->port->dev, "%s - TIMEOUT", __func__);
 			return;
-		} else {
-			wait = 30;
 		}
+		wait = 30;
 	}
 }
 
@@ -1130,27 +1129,29 @@ static int qt_ioctl(struct tty_struct *tty,
 			/* this never wakes up */
 			interruptible_sleep_on(&qt_port->msr_wait);
 #endif
+
+			char diff;
+
 			if (signal_pending(current))
 				return -ERESTARTSYS;
-			else {
-				char diff = qt_port->diff_status;
-
-				if (diff == 0)
-					return -EIO;	/* no change => error */
-
-				/* Consume all events */
-				qt_port->diff_status = 0;
-
-				if (((arg & TIOCM_RNG)
-				     && (diff & SERIAL_MSR_RI))
-				    || ((arg & TIOCM_DSR)
-					&& (diff & SERIAL_MSR_DSR))
-				    || ((arg & TIOCM_CD)
-					&& (diff & SERIAL_MSR_CD))
-				    || ((arg & TIOCM_CTS)
-					&& (diff & SERIAL_MSR_CTS))) {
-					return 0;
-				}
+
+			diff = qt_port->diff_status;
+
+			if (diff == 0)
+				return -EIO;	/* no change => error */
+
+			/* Consume all events */
+			qt_port->diff_status = 0;
+
+			if (((arg & TIOCM_RNG)
+			     && (diff & SERIAL_MSR_RI))
+			    || ((arg & TIOCM_DSR)
+				&& (diff & SERIAL_MSR_DSR))
+			    || ((arg & TIOCM_CD)
+				&& (diff & SERIAL_MSR_CD))
+			    || ((arg & TIOCM_CTS)
+				&& (diff & SERIAL_MSR_CTS))) {
+				return 0;
 			}
 		}
 		return 0;
@@ -1378,8 +1379,8 @@ static inline int qt_real_tiocmset(struct tty_struct *tty,
 	    box_set_register(port->serial, index, MODEM_CONTROL_REGISTER, mcr);
 	if (status < 0)
 		return -ESPIPE;
-	else
-		return 0;
+
+	return 0;
 }
 
 static int qt_tiocmget(struct tty_struct *tty)
-- 
2.0.0

