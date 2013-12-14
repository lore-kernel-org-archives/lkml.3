Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3LNRbL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 12:31:11 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53070 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885Ab3LNRah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 12:30:37 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 02/14] i8k: Fix various checkpatch warnings and errors
Date: Sat, 14 Dec 2013 09:30:09 -0800
Message-Id: <1387042221-3671-3-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
References: <1387042221-3671-1-git-send-email-linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix:
WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
WARNING: Use #include <linux/io.h> instead of <asm/io.h>
WARNING: __packed is preferred over __attribute__((packed))
WARNING: externs should be avoided in .c files
ERROR: spaces required around that ':' (ctx:ExV)
ERROR: do not use assignment in if condition
WARNING: line over 80 characters
WARNING: __initdata should be placed after i8k_dmi_table[]
ERROR: code indent should use tabs where possible
WARNING: please, no spaces at the start of a line

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/char/i8k.c |   40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/char/i8k.c b/drivers/char/i8k.c
index 0c48e7f..71da6b7 100644
--- a/drivers/char/i8k.c
+++ b/drivers/char/i8k.c
@@ -31,8 +31,8 @@
 #include <linux/mutex.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
-#include <asm/uaccess.h>
-#include <asm/io.h>
+#include <linux/uaccess.h>
+#include <linux/io.h>
 
 #include <linux/i8k.h>
 
@@ -105,11 +105,11 @@ static const struct file_operations i8k_fops = {
 
 struct smm_regs {
 	unsigned int eax;
-	unsigned int ebx __attribute__ ((packed));
-	unsigned int ecx __attribute__ ((packed));
-	unsigned int edx __attribute__ ((packed));
-	unsigned int esi __attribute__ ((packed));
-	unsigned int edi __attribute__ ((packed));
+	unsigned int ebx __packed;
+	unsigned int ecx __packed;
+	unsigned int edx __packed;
+	unsigned int esi __packed;
+	unsigned int edi __packed;
 };
 
 static inline const char *i8k_get_dmi_data(int field)
@@ -150,7 +150,7 @@ static int i8k_smm(struct smm_regs *regs)
 		"pushfq\n\t"
 		"popq %%rax\n\t"
 		"andl $1,%%eax\n"
-		:"=a"(rc)
+		: "=a"(rc)
 		:    "a"(regs)
 		:    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #else
@@ -176,7 +176,7 @@ static int i8k_smm(struct smm_regs *regs)
 	    "lahf\n\t"
 	    "shrl $8,%%eax\n\t"
 	    "andl $1,%%eax\n"
-	    :"=a"(rc)
+	    : "=a"(rc)
 	    :    "a"(regs)
 	    :    "%ebx", "%ecx", "%edx", "%esi", "%edi", "memory");
 #endif
@@ -205,7 +205,8 @@ static int i8k_get_fn_status(void)
 	struct smm_regs regs = { .eax = I8K_SMM_FN_STATUS, };
 	int rc;
 
-	if ((rc = i8k_smm(&regs)) < 0)
+	rc = i8k_smm(&regs);
+	if (rc < 0)
 		return rc;
 
 	switch ((regs.eax >> I8K_FN_SHIFT) & I8K_FN_MASK) {
@@ -228,7 +229,8 @@ static int i8k_get_power_status(void)
 	struct smm_regs regs = { .eax = I8K_SMM_POWER_STATUS, };
 	int rc;
 
-	if ((rc = i8k_smm(&regs)) < 0)
+	rc = i8k_smm(&regs);
+	if (rc < 0)
 		return rc;
 
 	return (regs.eax & 0xff) == I8K_POWER_AC ? I8K_AC : I8K_BATTERY;
@@ -282,7 +284,8 @@ static int i8k_get_temp(int sensor)
 	static int prev;
 #endif
 	regs.ebx = sensor & 0xff;
-	if ((rc = i8k_smm(&regs)) < 0)
+	rc = i8k_smm(&regs);
+	if (rc < 0)
 		return rc;
 
 	temp = regs.eax & 0xff;
@@ -311,7 +314,8 @@ static int i8k_get_dell_signature(int req_fn)
 	struct smm_regs regs = { .eax = req_fn, };
 	int rc;
 
-	if ((rc = i8k_smm(&regs)) < 0)
+	rc = i8k_smm(&regs);
+	if (rc < 0)
 		return rc;
 
 	return regs.eax == 1145651527 && regs.edx == 1145392204 ? 0 : -1;
@@ -335,7 +339,8 @@ i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 
 	case I8K_MACHINE_ID:
 		memset(buff, 0, 16);
-		strlcpy(buff, i8k_get_dmi_data(DMI_PRODUCT_SERIAL), sizeof(buff));
+		strlcpy(buff, i8k_get_dmi_data(DMI_PRODUCT_SERIAL),
+			sizeof(buff));
 		break;
 
 	case I8K_FN_STATUS:
@@ -609,7 +614,7 @@ static void __exit i8k_exit_hwmon(void)
 	hwmon_device_unregister(i8k_hwmon_dev);
 }
 
-static struct dmi_system_id __initdata i8k_dmi_table[] = {
+static struct dmi_system_id i8k_dmi_table[] __initdata = {
 	{
 		.ident = "Dell Inspiron",
 		.matches = {
@@ -666,7 +671,7 @@ static struct dmi_system_id __initdata i8k_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro"),
 		},
 	},
-        { }
+	{ }
 };
 
 /*
@@ -691,7 +696,8 @@ static int __init i8k_probe(void)
 			i8k_get_dmi_data(DMI_BIOS_VERSION));
 	}
 
-	strlcpy(bios_version, i8k_get_dmi_data(DMI_BIOS_VERSION), sizeof(bios_version));
+	strlcpy(bios_version, i8k_get_dmi_data(DMI_BIOS_VERSION),
+		sizeof(bios_version));
 
 	/*
 	 * Get SMM Dell signature
-- 
1.7.9.7

