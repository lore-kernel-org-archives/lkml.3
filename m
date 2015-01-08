Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbbAHOFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:05:35 -0500
Received: from mout.gmx.net ([212.227.15.15]:53798 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbbAHOFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:05:34 -0500
From: Sven Dziadek <sven.dziadek@gmx.de>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: wlan-ng: hfa384x_usb: Fix else is not useful warning
Date: Thu,  8 Jan 2015 15:01:17 +0100
Message-Id: <1420725677-14766-1-git-send-email-sven.dziadek@gmx.de>
X-Mailer: git-send-email 2.1.4
X-Provags-ID: V03:K0:DGFIhAKtV1W0WwDPMpvGTwQKUI6E44HuzmS6sUf+MKCH3QNNpp/
 F4SviKiuf0EmTpUMBoxRbgMs+YVFIC0OQ/yvdR+3c95kGfaXdZKYmzWeljD3lkDVo+p0bP6
 Eo9FGlHq41GwrLpkwv+1cF9h1PLtjEfAcYTmLvqXwQBSKeK0J+89bED5G33IaMj3OMH5ofX
 +nQGkyEL122383cr7xzcQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following checkpatch.pl warning:
WARNING: else is not generally useful after a break or return

Signed-off-by: Sven Dziadek <sven.dziadek@gmx.de>
---
 drivers/staging/wlan-ng/hfa384x_usb.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 55d2f56..a9a5649 100644
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
+		/* bad code */
+		pr_debug("Encountered unknown PDR#=0x%04x, (>=0x1000), assuming it's bad.\n",
+			pdrcode);
+		return 0;
 	}
 	return 0;		/* avoid compiler warnings */
 }
-- 
2.1.4

