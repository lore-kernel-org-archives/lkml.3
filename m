Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025Ab3ASKS6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 05:18:58 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36823 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab3ASKSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 05:18:55 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 2/2] staging: line6: clean up line6_variax_process_message()
Date: Sat, 19 Jan 2013 11:18:44 +0100
Message-Id: <1358590724-30961-3-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358590724-30961-1-git-send-email-stefanha@gmail.com>
References: <1358590724-30961-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previous versions of the line6 driver snooped MIDI traffic in order to
make device state accessible via sysfs attributes.  This involved a lot
of logic in line6_variax_process_message() that has since been removed.

Drop unused conditionals in line6_variax_process_message().

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/variax.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index 4fca58f..bd0f694 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -133,13 +133,6 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 	const unsigned char *buf = variax->line6.buffer_message;
 
 	switch (buf[0]) {
-	case LINE6_PARAM_CHANGE | LINE6_CHANNEL_HOST:
-		break;
-
-	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_DEVICE:
-	case LINE6_PROGRAM_CHANGE | LINE6_CHANNEL_HOST:
-		break;
-
 	case LINE6_RESET:
 		dev_info(variax->line6.ifcdev, "VARIAX reset\n");
 		break;
@@ -154,13 +147,6 @@ void line6_variax_process_message(struct usb_line6_variax *variax)
 			variax_startup4((unsigned long)variax);
 		}
 		break;
-
-	case LINE6_SYSEX_END:
-		break;
-
-	default:
-		dev_dbg(variax->line6.ifcdev,
-			"Variax: unknown message %02X\n", buf[0]);
 	}
 }
 
-- 
1.8.0.2

