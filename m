Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967570AbaFTNXB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 09:23:01 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:49143 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966834AbaFTNXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 09:23:00 -0400
From: Vincent Heuken <me@vincentheuken.com>
To: gregkh@linuxfoundation.org, thomas_75@safe-mail.net,
        paul.gortmaker@windriver.com, himangi774@gmail.com, arnd@arndb.de,
        aybuke.147@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Vincent Heuken <me@vincentheuken.com>
Subject: [PATCH] Staging: serqt_usb2: fixed frivolous else statement warnings
Date: Fri, 20 Jun 2014 06:23:17 -0700
Message-Id: <1403270597-21694-1-git-send-email-me@vincentheuken.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the serqt_usb2.c file that fixes two instances
of the following checkpatch.pl warning:
WARNING: else is not generally useful after a break or return

Signed-off-by: Vincent Heuken <me@vincentheuken.com>
---
 drivers/staging/serqt_usb2/serqt_usb2.c | 44 ++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 998c384..c356542 100644
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
 
@@ -1132,25 +1131,24 @@ static int qt_ioctl(struct tty_struct *tty,
 #endif
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
+			char diff = qt_port->diff_status;
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
@@ -1378,8 +1376,8 @@ static inline int qt_real_tiocmset(struct tty_struct *tty,
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

