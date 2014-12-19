Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaLSCTH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:19:07 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:49111 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaLSCTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:19:05 -0500
From: Eduardo Barretto <edusbarretto@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] Staging: wlan-ng: hfa384x_usb: fixed an 'else' statement coding style issue
Date: Fri, 19 Dec 2014 00:18:26 -0200
Message-Id: <1418955506-30099-1-git-send-email-edusbarretto@gmail.com>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch was complaining about the else statement because the if statement had a return '1' call. Taking a look at the function which this else statement belongs, you can see that it has an switch case statement.
The main idea of the function is to return '1' if you get into any of the cases (including the default case where the "problematic" if/else statement is declared).
If any of the cases is not sufficient the function should return '0', so the else statement that checkpath was complaining could be removed, and what was done inside this else statement can be done outside the switch case statement and then we return '0'.
This way we have a cleaner code and no checkpatch error complaints.

Signed-off-by: Eduardo Barretto <edusbarretto@gmail.com>
---
 drivers/staging/wlan-ng/hfa384x_usb.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 55d2f56..de33a07 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -4123,12 +4123,11 @@ static int hfa384x_isgood_pdrcode(u16 pdrcode)
 			pr_debug("Encountered unknown PDR#=0x%04x, assuming it's ok.\n",
 				 pdrcode);
 			return 1;
-		} else {
-			/* bad code */
-			pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
-				 pdrcode);
-			return 0;
 		}
+		break;
 	}
-	return 0;		/* avoid compiler warnings */
+	/* bad code */
+	pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
+		 pdrcode);
+	return 0;
 }
--
2.2.0

