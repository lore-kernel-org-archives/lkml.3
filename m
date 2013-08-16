Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3HQDtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 23:49:46 -0400
Received: from userp1050.oracle.com ([156.151.31.82]:37160 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab3HQDtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 23:49:45 -0400
X-Greylist: delayed 5348 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Aug 2013 23:49:44 EDT
From: Jerry Snitselaar <jerry.snitselaar@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org, mika.westerberg@linux.intel.com, rjw@sisk.pl
Subject: [PATCH] acpi_i2c: set MODULE_LICENSE, MODULE_AUTHOR, and  MODULE_DESCRIPTION
Date: Fri, 16 Aug 2013 14:40:51 -0700
Message-Id: <1376689251-18511-1-git-send-email-jerry.snitselaar@oracle.com>
X-Mailer: git-send-email 1.8.4.rc3.2.g2c2b664
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without MODULE_LICENSE get, I get the following with modprobe:

acpi_i2c: module license 'unspecified' taints kernel.
acpi_i2c: Unknown symbol i2c_new_device (err 0)
acpi_i2c: Unknown symbol acpi_dev_get_resources (err 0)
acpi_i2c: Unknown symbol acpi_dev_resource_interrupt (err 0)
acpi_i2c: Unknown symbol acpi_dev_free_resource_list (err 0)

Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
---
 drivers/acpi/acpi_i2c.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/acpi/acpi_i2c.c b/drivers/acpi/acpi_i2c.c
index 82045e3..2c5c65d 100644
--- a/drivers/acpi/acpi_i2c.c
+++ b/drivers/acpi/acpi_i2c.c
@@ -14,9 +14,14 @@
 #include <linux/export.h>
 #include <linux/i2c.h>
 #include <linux/ioport.h>
+#include <linux/module.h>
 
 ACPI_MODULE_NAME("i2c");
 
+MODULE_DESCRIPTION("ACPI I2C enumeration support");
+MODULE_AUTHOR("Mika Westerberg");
+MODULE_LICENSE("GPL");
+
 static int acpi_i2c_add_resource(struct acpi_resource *ares, void *data)
 {
 	struct i2c_board_info *info = data;
-- 
1.8.4.rc3.2.g2c2b664

