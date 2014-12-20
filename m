Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbaLTBfF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 20:35:05 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:51132 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaLTBfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 20:35:03 -0500
From: Eduardo Barretto <edusbarretto@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] Staging: wlan-ng: hfa384x_usb: fixed an 'else' statement coding style issue
Date: Fri, 19 Dec 2014 23:34:33 -0200
Message-Id: <1419039273-30153-1-git-send-email-edusbarretto@gmail.com>
X-Mailer: git-send-email 2.2.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed useless 'else' statement that followed an 'if' statement that
had a return 1 and moved all the content from the 'else' to outside of
the switch case, this way if any case is sufficient it returns '1',
otherwise it will return 0.

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

