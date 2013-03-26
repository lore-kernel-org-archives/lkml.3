Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934170Ab3CZNRj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 09:17:39 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:57092 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab3CZNRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 09:17:36 -0400
From: =?UTF-8?q?Nick=20=C3=98stergaard?= <oe.nick@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Nick=20=C3=98stergaard?= <oe.nick@gmail.com>
Subject: [PATCH] staging: wlan-ng: prism2usb.c: fix printk(KERN_ERR... to dev_err(dev, ...
Date: Tue, 26 Mar 2013 14:17:10 +0100
Message-Id: <1364303830-13149-1-git-send-email-oe.nick@gmail.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <20130325191732.GA22609@kroah.com>
References: <20130325191732.GA22609@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning. Change printk(KERN_ERR ... to dev_err(dev ...

Signed-off-by: Nick Østergaard <oe.nick@gmail.com>
---
 drivers/staging/wlan-ng/prism2usb.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlan-ng/prism2usb.c b/drivers/staging/wlan-ng/prism2usb.c
index b1aed1f..b401974 100644
--- a/drivers/staging/wlan-ng/prism2usb.c
+++ b/drivers/staging/wlan-ng/prism2usb.c
@@ -113,14 +113,14 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 	dev = interface_to_usbdev(interface);
 	wlandev = create_wlan();
 	if (wlandev == NULL) {
-		printk(KERN_ERR "%s: Memory allocation failure.\n", dev_info);
+		dev_err(&interface->dev, "Memory allocation failure.\n");
 		result = -EIO;
 		goto failed;
 	}
 	hw = wlandev->priv;
 
 	if (wlan_setup(wlandev, &(interface->dev)) != 0) {
-		printk(KERN_ERR "%s: wlan_setup() failed.\n", dev_info);
+		dev_err(&interface->dev, "wlan_setup() failed.\n");
 		result = -EIO;
 		goto failed;
 	}
@@ -143,8 +143,7 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 			unregister_wlandev(wlandev);
 			hfa384x_destroy(hw);
 			result = -EIO;
-			printk(KERN_ERR
-			       "%s: hfa384x_corereset() failed.\n", dev_info);
+			dev_err(&interface->dev, "hfa384x_corereset() failed.\n");
 			goto failed;
 		}
 	}
@@ -158,7 +157,7 @@ static int prism2sta_probe_usb(struct usb_interface *interface,
 	prism2sta_ifstate(wlandev, P80211ENUM_ifstate_enable);
 
 	if (register_wlandev(wlandev) != 0) {
-		printk(KERN_ERR "%s: register_wlandev() failed.\n", dev_info);
+		dev_err(&interface->dev, "register_wlandev() failed.\n");
 		result = -EIO;
 		goto failed;
 	}
@@ -329,8 +328,7 @@ static int prism2sta_resume(struct usb_interface *interface)
 		if (result != 0) {
 			unregister_wlandev(wlandev);
 			hfa384x_destroy(hw);
-			printk(KERN_ERR
-			       "%s: hfa384x_corereset() failed.\n", dev_info);
+			dev_err(&interface->dev, "hfa384x_corereset() failed.\n");
 			kfree(wlandev);
 			kfree(hw);
 			wlandev = NULL;
-- 
1.8.2

