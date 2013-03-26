Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292Ab3CZJk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:40:59 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:57678 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759191Ab3CZJk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:40:58 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 2/3] driver core: platform.c: fix checkpatch errors and warnings
Date: Tue, 26 Mar 2013 10:35:16 +0100
Message-Id: <1364290517-8094-3-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364290517-8094-1-git-send-email-fabio.porcedda@gmail.com>
References: <1364290517-8094-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/platform.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index ef2afb1..9eda842 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -46,8 +46,8 @@ EXPORT_SYMBOL_GPL(platform_bus);
  * manipulate any relevant information in the pdev_archdata they can do:
  *
  *	platform_device_alloc()
- * 	... manipulate ...
- * 	platform_device_add()
+ *	... manipulate ...
+ *	platform_device_add()
  *
  * And if they don't care they can just call platform_device_register() and
  * everything will just work out.
@@ -326,9 +326,7 @@ int platform_device_add(struct platform_device *pdev)
 		}
 
 		if (p && insert_resource(p, r)) {
-			printk(KERN_ERR
-			       "%s: failed to claim resource %d\n",
-			       dev_name(&pdev->dev), i);
+			dev_err(&pdev->dev, "failed to claim resource %d\n", i);
 			ret = -EBUSY;
 			goto failed;
 		}
@@ -686,7 +684,7 @@ static int platform_uevent(struct device *dev, struct kobj_uevent_env *env)
 	int rc;
 
 	/* Some devices have extra OF data and an OF-style MODALIAS */
-	rc = of_device_uevent_modalias(dev,env);
+	rc = of_device_uevent_modalias(dev, env);
 	if (rc != -ENODEV)
 		return rc;
 
@@ -1130,8 +1128,8 @@ static int __init early_platform_driver_probe_id(char *class_str,
 
 		switch (match_id) {
 		case EARLY_PLATFORM_ID_ERROR:
-			pr_warning("%s: unable to parse %s parameter\n",
-				   class_str, epdrv->pdrv->driver.name);
+			pr_warn("%s: unable to parse %s parameter\n",
+				class_str, epdrv->pdrv->driver.name);
 			/* fall-through */
 		case EARLY_PLATFORM_ID_UNSET:
 			match = NULL;
@@ -1162,8 +1160,8 @@ static int __init early_platform_driver_probe_id(char *class_str,
 			}
 
 			if (epdrv->pdrv->probe(match))
-				pr_warning("%s: unable to probe %s early.\n",
-					   class_str, match->name);
+				pr_warn("%s: unable to probe %s early.\n",
+					class_str, match->name);
 			else
 				n++;
 		}
-- 
1.8.2

