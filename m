Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab3DVCNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:13:43 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:38850 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab3DVCNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:13:40 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Cc: Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 3/5] of: remove of_platform_driver
Date: Sun, 21 Apr 2013 21:13:16 -0500
Message-Id: <1366596798-9457-4-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
References: <1366596798-9457-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

The last user of of_platform_driver is converted to a regular
platform_driver, so of_platform_driver can be removed now.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@linaro.org>
---
 include/linux/of_platform.h |   21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/include/linux/of_platform.h b/include/linux/of_platform.h
index 2a93b64..aa7eb02 100644
--- a/include/linux/of_platform.h
+++ b/include/linux/of_platform.h
@@ -53,27 +53,6 @@ struct of_dev_auxdata {
 	{ .compatible = _compat, .phys_addr = _phys, .name = _name, \
 	  .platform_data = _pdata }
 
-/**
- * of_platform_driver - Legacy of-aware driver for platform devices.
- *
- * An of_platform_driver driver is attached to a basic platform_device on
- * the ibm ebus (ibmebus_bus_type).
- */
-struct of_platform_driver
-{
-	int	(*probe)(struct platform_device* dev,
-			 const struct of_device_id *match);
-	int	(*remove)(struct platform_device* dev);
-
-	int	(*suspend)(struct platform_device* dev, pm_message_t state);
-	int	(*resume)(struct platform_device* dev);
-	int	(*shutdown)(struct platform_device* dev);
-
-	struct device_driver	driver;
-};
-#define	to_of_platform_driver(drv) \
-	container_of(drv,struct of_platform_driver, driver)
-
 extern const struct of_device_id of_default_bus_match_table[];
 
 /* Platform drivers register/unregister */
-- 
1.7.10.4

