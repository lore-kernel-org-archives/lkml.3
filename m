Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab3CGL6N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:58:13 -0500
Received: from zoidberg.rfc1149.net ([88.190.27.159]:39394 "EHLO
	zoidberg.rfc1149.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3CGL6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:58:11 -0500
From: Samuel Tardieu <sam@rfc1149.net>
To: Oliver Neukum <oliver@neukum.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org (open list:USB ACM DRIVER),
        linux-kernel@vger.kernel.org (open list)
Cc: Samuel Tardieu <sam@rfc1149.net>
Subject: [PATCH v2] USB: cdc-acm: Remove obsolete predefined speeds array
Date: Thu,  7 Mar 2013 12:57:58 +0100
Message-Id: <1362657478-29602-1-git-send-email-sam@rfc1149.net>
X-Mailer: git-send-email 1.8.1.5
Organisation: RFC1149 (see http://www.rfc1149.net/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern speed handling has been introduced in 2009 by commit
9b80fee149a875a6292b2556ab2c64dc7ab7d6f5 (cdc_acm: Fix to use modern
speed interfaces) and the acm_tty_speed array has been unused since.

Signed-off-by: Samuel Tardieu <sam@rfc1149.net>
Acked-by: Oliver Neukum <oliver@neukum.org>
---
 drivers/usb/class/cdc-acm.c | 8 --------
 1 file changed, 8 deletions(-)

Here is a new one (code unchanged) with an updated commit message as per
Sergei request.

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 8ac25ad..d003c8c 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -840,14 +840,6 @@ static int acm_tty_ioctl(struct tty_struct *tty,
 	return rv;
 }
 
-static const __u32 acm_tty_speed[] = {
-	0, 50, 75, 110, 134, 150, 200, 300, 600,
-	1200, 1800, 2400, 4800, 9600, 19200, 38400,
-	57600, 115200, 230400, 460800, 500000, 576000,
-	921600, 1000000, 1152000, 1500000, 2000000,
-	2500000, 3000000, 3500000, 4000000
-};
-
 static void acm_tty_set_termios(struct tty_struct *tty,
 						struct ktermios *termios_old)
 {
-- 
1.8.1.5

