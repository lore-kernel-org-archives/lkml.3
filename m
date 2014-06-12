Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933215AbaFLKg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:36:26 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:47168 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932974AbaFLKgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:36:22 -0400
From: Wahib Faizi <wahibfaizi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Wahib Faizi <wahibfaizi@gmail.com>
Subject: [PATCH] drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c: fix coding style
Date: Thu, 12 Jun 2014 14:35:38 +0400
Message-Id: <1402569338-5709-2-git-send-email-wahibfaizi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
References: <Eudyptula Challenge (Task 10)>
 <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style issues detected by checkpatch.pl:
1. do not use assignment in if condition
2. line over 80 characters

Signed-off-by: Wahib Faizi <wahibfaizi@gmail.com>
---
 .../usbip/userspace/libsrc/usbip_host_driver.c     |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
index 92caef7..bef08d5 100644
--- a/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/usbip_host_driver.c
@@ -47,7 +47,8 @@ static int32_t read_attr_usbip_status(struct usbip_usb_device *udev)
 	snprintf(status_attr_path, SYSFS_PATH_MAX, "%s/usbip_status",
 		 udev->path);
 
-	if ((fd = open(status_attr_path, O_RDONLY)) < 0) {
+	fd = open(status_attr_path, O_RDONLY);
+	if (fd < 0) {
 		err("error opening attribute %s", status_attr_path);
 		return -1;
 	}
@@ -87,8 +88,8 @@ struct usbip_exported_device *usbip_exported_device_new(const char *sdevpath)
 		goto err;
 
 	/* reallocate buffer to include usb interface data */
-	size = sizeof(struct usbip_exported_device) + edev->udev.bNumInterfaces *
-		sizeof(struct usbip_usb_interface);
+	size = sizeof(struct usbip_exported_device) +
+		edev->udev.bNumInterfaces * sizeof(struct usbip_usb_interface);
 
 	edev_old = edev;
 	edev = realloc(edev, size);
-- 
1.7.9.5

