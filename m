Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab3DVCNl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:13:41 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:44539 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3DVCNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:13:39 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 2/5] driver core: move to_platform_driver to platform_device.h
Date: Sun, 21 Apr 2013 21:13:15 -0500
Message-Id: <1366596798-9457-3-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

In converting the last remaining of_platform_driver (ibmebus) to a regular
platform driver, to_platform_driver is needed to replace
to_of_platform_driver.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grant Likely <grant.likely@linaro.org>
---
 drivers/base/platform.c         |    3 ---
 include/linux/platform_device.h |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c0b8df3..819ecb0 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -29,9 +29,6 @@
 /* For automatically allocated device IDs */
 static DEFINE_IDA(platform_devid_ida);
 
-#define to_platform_driver(drv)	(container_of((drv), struct platform_driver, \
-				 driver))
-
 struct device platform_bus = {
 	.init_name	= "platform",
 };
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index c082c71..6e4e096 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -176,6 +176,9 @@ struct platform_driver {
 	const struct platform_device_id *id_table;
 };
 
+#define to_platform_driver(drv)	(container_of((drv), struct platform_driver, \
+				 driver))
+
 extern int platform_driver_register(struct platform_driver *);
 extern void platform_driver_unregister(struct platform_driver *);
 
-- 
1.7.10.4

