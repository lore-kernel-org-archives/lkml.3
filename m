Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3GXOJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:09:11 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:43217 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab3GXOHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:07:01 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <dan.carpenter@oracle.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
Subject: [PATCH] staging: ozwpan: Fix coding style.
Date: Wed, 24 Jul 2013 15:06:46 +0100
Message-ID: <1374674806-7790-1-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes coding style issues reported by Dan here:-
http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/2012-June/027767.html

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozcdev.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/ozwpan/ozcdev.c b/drivers/staging/ozwpan/ozcdev.c
index 3e29760..73b582c 100644
--- a/drivers/staging/ozwpan/ozcdev.c
+++ b/drivers/staging/ozwpan/ozcdev.c
@@ -333,10 +333,11 @@ int oz_cdev_register(void)
 {
 	int err;
 	struct device *dev;
+
 	memset(&g_cdev, 0, sizeof(g_cdev));
 	err = alloc_chrdev_region(&g_cdev.devnum, 0, 1, "ozwpan");
 	if (err < 0)
-		goto out3;
+		return err;
 	oz_dbg(ON, "Alloc dev number %d:%d\n",
 	       MAJOR(g_cdev.devnum), MINOR(g_cdev.devnum));
 	cdev_init(&g_cdev.cdev, &oz_fops);
@@ -347,26 +348,26 @@ int oz_cdev_register(void)
 	err = cdev_add(&g_cdev.cdev, g_cdev.devnum, 1);
 	if (err < 0) {
 		oz_dbg(ON, "Failed to add cdev\n");
-		goto out2;
+		goto unregister;
 	}
 	g_oz_class = class_create(THIS_MODULE, "ozmo_wpan");
 	if (IS_ERR(g_oz_class)) {
 		oz_dbg(ON, "Failed to register ozmo_wpan class\n");
 		err = PTR_ERR(g_oz_class);
-		goto out1;
+		goto delete;
 	}
 	dev = device_create(g_oz_class, NULL, g_cdev.devnum, NULL, "ozwpan");
 	if (IS_ERR(dev)) {
 		oz_dbg(ON, "Failed to create sysfs entry for cdev\n");
 		err = PTR_ERR(dev);
-		goto out1;
+		goto delete;
 	}
 	return 0;
-out1:
+
+delete:
 	cdev_del(&g_cdev.cdev);
-out2:
+unregister:
 	unregister_chrdev_region(g_cdev.devnum, 1);
-out3:
 	return err;
 }
 /*------------------------------------------------------------------------------
-- 
1.7.9.5

