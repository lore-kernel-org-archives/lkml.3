Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3LNRar (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:30:47 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45855 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab3LNRaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:35 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 01/14] i8k: Convert to use pr_ functions instead of printk
Date: Sat, 14 Dec 2013 09:30:08 -0800
Message-Id: <1387042221-3671-2-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 40cc0cf2..0c48e7f 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -19,6 +19,8 @@
  * General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/init.h>
@@ -535,7 +537,7 @@ static int __init i8k_init_hwmon(void)
 	if (IS_ERR(i8k_hwmon_dev)) {
 		err = PTR_ERR(i8k_hwmon_dev);
 		i8k_hwmon_dev = NULL;
-		printk(KERN_ERR "i8k: hwmon registration failed (%d)\n", err);
+		pr_err("hwmon registration failed (%d)\n", err);
 		return err;
 	}
 
@@ -682,8 +684,8 @@ static int __init i8k_probe(void)
 		if (!ignore_dmi && !force)
 			return -ENODEV;
 
-		printk(KERN_INFO "i8k: not running on a supported Dell system.\n");
-		printk(KERN_INFO "i8k: vendor=%s, model=%s, version=%s\n",
+		pr_info("not running on a supported Dell system.\n");
+		pr_info("vendor=%s, model=%s, version=%s\n",
 			i8k_get_dmi_data(DMI_SYS_VENDOR),
 			i8k_get_dmi_data(DMI_PRODUCT_NAME),
 			i8k_get_dmi_data(DMI_BIOS_VERSION));
@@ -696,7 +698,7 @@ static int __init i8k_probe(void)
 	 */
 	if (i8k_get_dell_signature(I8K_SMM_GET_DELL_SIG1) &&
 	    i8k_get_dell_signature(I8K_SMM_GET_DELL_SIG2)) {
-		printk(KERN_ERR "i8k: unable to get SMM Dell signature\n");
+		pr_err("unable to get SMM Dell signature\n");
 		if (!force)
 			return -ENODEV;
 	}
@@ -706,7 +708,7 @@ static int __init i8k_probe(void)
 	 */
 	version = i8k_get_bios_version();
 	if (version <= 0) {
-		printk(KERN_WARNING "i8k: unable to get SMM BIOS version\n");
+		pr_warn("unable to get SMM BIOS version\n");
 	} else {
 		buff[0] = (version >> 16) & 0xff;
 		buff[1] = (version >> 8) & 0xff;
@@ -722,7 +724,7 @@ static int __init i8k_probe(void)
 		 * Check if the two versions match.
 		 */
 		if (strncmp(buff, bios_version, sizeof(bios_version)) != 0)
-			printk(KERN_WARNING "i8k: BIOS version mismatch: %s != %s\n",
+			pr_warn("BIOS version mismatch: %s != %s\n",
 				buff, bios_version);
 	}
 
@@ -747,9 +749,8 @@ static int __init i8k_init(void)
 	if (err)
 		goto exit_remove_proc;
 
-	printk(KERN_INFO
-	       "Dell laptop SMM driver v%s Massimo Dal Zotto (dz@debian.org)\n",
-	       I8K_VERSION);
+	pr_info("Dell laptop SMM driver v%s Massimo Dal Zotto (dz@debian.org)\n",
+		I8K_VERSION);
 
 	return 0;
 
-- 
1.7.9.7

