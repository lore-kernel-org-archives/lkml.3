Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbaIZK70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:59:26 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:60484 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaIZK6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:58:36 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4/6] mfd: use mfd_add_hotplug_devices helper
Date: Fri, 26 Sep 2014 12:55:31 +0200
Message-Id: <1411728933-13351-5-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1411728933-13351-1-git-send-email-johan@kernel.org>
References: <1411728933-13351-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mfd_add_hotplug_devices helper to register the subdevices.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/mfd/rtsx_usb.c   | 4 ++--
 drivers/mfd/viperboard.c | 5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
index 78073e4b87e4..5b17339fce7c 100644
--- a/drivers/mfd/rtsx_usb.c
+++ b/drivers/mfd/rtsx_usb.c
@@ -647,8 +647,8 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 	/* initialize USB SG transfer timer */
 	setup_timer(&ucr->sg_timer, rtsx_usb_sg_timed_out, (unsigned long) ucr);
 
-	ret = mfd_add_devices(&intf->dev, PLATFORM_DEVID_AUTO, rtsx_usb_cells,
-			ARRAY_SIZE(rtsx_usb_cells), NULL, 0, NULL);
+	ret = mfd_add_hotplug_devices(&intf->dev, rtsx_usb_cells,
+			ARRAY_SIZE(rtsx_usb_cells));
 	if (ret)
 		goto out_init_fail;
 
diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index 3c2b8f9e3c84..be450ebcb52d 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -93,9 +93,8 @@ static int vprbrd_probe(struct usb_interface *interface,
 		 version >> 8, version & 0xff,
 		 vb->usb_dev->bus->busnum, vb->usb_dev->devnum);
 
-	ret = mfd_add_devices(&interface->dev, PLATFORM_DEVID_AUTO,
-				vprbrd_devs, ARRAY_SIZE(vprbrd_devs), NULL, 0,
-				NULL);
+	ret = mfd_add_hotplug_devices(&interface->dev, vprbrd_devs,
+			ARRAY_SIZE(vprbrd_devs));
 	if (ret != 0) {
 		dev_err(&interface->dev, "Failed to add mfd devices to core.");
 		goto error;
-- 
1.8.5.5

