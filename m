Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbbARHLq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 02:11:46 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:63690 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbbARHLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 02:11:43 -0500
Date: Sun, 18 Jan 2015 09:11:39 +0200
From: Asaf Vertz <asaf.vertz@tandemg.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: wlan-ng: hfa384x_usb: fix sparse endianness
 warnings
Message-ID: <20150118071139.GA2248@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the following warnings (reported by sparse):
drivers/staging/wlan-ng/hfa384x_usb.c:3828:36: warning: cast to restricted __le16
drivers/staging/wlan-ng/hfa384x_usb.c:3229:16: warning: cast to restricted __le16
drivers/staging/wlan-ng/hfa384x_usb.c:3430:18: warning: cast to restricted __le16
drivers/staging/wlan-ng/hfa384x_usb.c:3349:51: warning: restricted __le16 degrades to integer
drivers/staging/wlan-ng/hfa384x_usb.c:3357:37: warning: cast to restricted __le16
drivers/staging/wlan-ng/hfa384x_usb.c:3358:37: warning: cast to restricted __le16
drivers/staging/wlan-ng/hfa384x_usb.c:3393:36: warning: cast to restricted __le16
drivers/staging/wlan-ng/hfa384x_usb.c:3102:28: warning: cast to restricted __le16
drivers/staging/wlan-ng/hfa384x_usb.c:3004:28: warning: cast to restricted __le16
drivers/staging/wlan-ng/hfa384x_usb.c:1308:37: warning: cast to restricted __le16
drivers/staging/wlan-ng/hfa384x_usb.c:2713:25: warning: incorrect type in assignment (different base types)
drivers/staging/wlan-ng/hfa384x_usb.c:2713:25:    expected unsigned short [unsigned] [usertype] type
drivers/staging/wlan-ng/hfa384x_usb.c:2713:25:    got restricted __le16 [usertype] <noident>

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/staging/wlan-ng/hfa384x.h     |    4 ++--
 drivers/staging/wlan-ng/hfa384x_usb.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wlan-ng/hfa384x.h b/drivers/staging/wlan-ng/hfa384x.h
index 20d146b..964a662 100644
--- a/drivers/staging/wlan-ng/hfa384x.h
+++ b/drivers/staging/wlan-ng/hfa384x.h
@@ -879,7 +879,7 @@ typedef struct hfa384x_usb_error {
 /* Unions for packaging all the known packet types together */
 
 typedef union hfa384x_usbout {
-	u16 type;
+	__le16 type;
 	hfa384x_usb_txfrm_t txfrm;
 	hfa384x_usb_cmdreq_t cmdreq;
 	hfa384x_usb_wridreq_t wridreq;
@@ -889,7 +889,7 @@ typedef union hfa384x_usbout {
 } __packed hfa384x_usbout_t;
 
 typedef union hfa384x_usbin {
-	u16 type;
+	__le16 type;
 	hfa384x_usb_rxfrm_t rxfrm;
 	hfa384x_usb_txfrm_t txfrm;
 	hfa384x_usb_infofrm_t infofrm;
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index 55d2f56..e84ebb9 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -3346,7 +3346,7 @@ retry:
 		if (unlocked_usbctlx_cancel_async(hw, ctlx) == 0)
 			run_queue = 1;
 	} else {
-		const u16 intype = (usbin->type & ~cpu_to_le16(0x8000));
+		const __le16 intype = (usbin->type & ~cpu_to_le16(0x8000));
 
 		/*
 		 * Check that our message is what we're expecting ...
-- 
1.7.0.4

