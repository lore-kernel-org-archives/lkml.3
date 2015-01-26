Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbbAZLEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:04:43 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:63470 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbbAZLEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:04:22 -0500
From: Johan Hovold <johan@kernel.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/2] gpio: sysfs: fix memory leak in gpiod_export_link
Date: Mon, 26 Jan 2015 12:02:45 +0100
Message-Id: <1422270166-17525-2-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 2.0.5
In-Reply-To: <1422270166-17525-1-git-send-email-johan@kernel.org>
References: <1422270166-17525-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix memory leak in the gpio sysfs interface due to failure to drop
reference to device returned by class_find_device when creating a link.

Fixes: a4177ee7f1a8 ("gpiolib: allow exported GPIO nodes to be named
using sysfs links")
Cc: stable <stable@vger.kernel.org>	# v2.6.32
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/gpio/gpiolib-sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpiolib-sysfs.c b/drivers/gpio/gpiolib-sysfs.c
index 14c4f94813eb..820b1e70ddfe 100644
--- a/drivers/gpio/gpiolib-sysfs.c
+++ b/drivers/gpio/gpiolib-sysfs.c
@@ -648,6 +648,7 @@ int gpiod_export_link(struct device *dev, const char *name,
 		if (tdev != NULL) {
 			status = sysfs_create_link(&dev->kobj, &tdev->kobj,
 						name);
+			put_device(tdev);
 		} else {
 			status = -ENODEV;
 		}
-- 
2.0.5

