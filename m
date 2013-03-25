Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758745Ab3CYTCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 15:02:41 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:48424 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab3CYTCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 15:02:40 -0400
From: =?UTF-8?q?Nick=20=C3=98stergaard?= <oe.nick@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Nick=20=C3=98stergaard?= <oe.nick@gmail.com>
Subject: [PATCH] staging: wlan-ng: prism2usb.c: fix printk(KERN_ERR... to pr_err(...
Date: Mon, 25 Mar 2013 20:02:28 +0100
Message-Id: <1364238148-22329-1-git-send-email-oe.nick@gmail.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed checkpatch.pl warning, changing fix printk(KERN_ERR... to
pr_err(...

Signed-off-by: Nick Østergaard <oe.nick@gmail.com>
---
 drivers/staging/wlan-ng/prism2usb.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index b1aed1f..0f2706a 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -113,14 +113,14 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 	dev = interface_to_usbdev(interface);
 	wlandev = create_wlan();
 	if (wlandev == NULL) {
-		printk(KERN_ERR "%s: Memory allocation failure.\n", dev_info);
+		pr_err("%s: Memory allocation failure.\n", dev_info);
 		result = -EIO;
 		goto failed;
 	}
 	hw = wlandev->priv;
 
 	if (wlan_setup(wlandev, &(interface->dev)) != 0) {
-		printk(KERN_ERR "%s: wlan_setup() failed.\n", dev_info);
+		pr_err("%s: wlan_setup() failed.\n", dev_info);
 		result = -EIO;
 		goto failed;
 	}
@@ -143,8 +143,7 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 			unregister_wlandev(wlandev);
 			hfa384x_destroy(hw);
 			result = -EIO;
-			printk(KERN_ERR
-			       "%s: hfa384x_corereset() failed.\n", dev_info);
+			pr_err("%s: hfa384x_corereset() failed.\n", dev_info);
 			goto failed;
 		}
 	}
@@ -158,7 +157,7 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 	prism2sta_ifstate(wlandev, P80211ENUM_ifstate_enable);
 
 	if (register_wlandev(wlandev) != 0) {
-		printk(KERN_ERR "%s: register_wlandev() failed.\n", dev_info);
+		pr_err("%s: register_wlandev() failed.\n", dev_info);
 		result = -EIO;
 		goto failed;
 	}
@@ -329,8 +328,7 @@ static int prism2sta_resume(struct usb_interface *interface)
 		if (result != 0) {
 			unregister_wlandev(wlandev);
 			hfa384x_destroy(hw);
-			printk(KERN_ERR
-			       "%s: hfa384x_corereset() failed.\n", dev_info);
+			pr_err("%s: hfa384x_corereset() failed.\n", dev_info);
 			kfree(wlandev);
 			kfree(hw);
 			wlandev = NULL;
-- 
1.8.2

