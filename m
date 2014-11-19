Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbaKSImY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:42:24 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:34488 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbaKSImU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:42:20 -0500
From: Dudley Du <dudley.dulixin@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: Dudley Du <dudley.dulixin@gmail.com>, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v11 19/19] input: cyapa: add acpi device id supported
Date: Wed, 19 Nov 2014 16:37:51 +0800
Message-Id: <1416386271-28167-20-git-send-email-dudley.dulixin@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
References: <1416386271-28167-1-git-send-email-dudley.dulixin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add acpi device tree supported.
acpi device id "CYAP0000" is for old gen3 trackpad devices.
acpi device id "CYAP0001" is for new gen5 trackpad devices.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index ca31119..eb53aa0 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/pm_runtime.h>
+#include <linux/acpi.h>
 #include "cyapa.h"
 
 
@@ -1501,11 +1502,23 @@ static const struct i2c_device_id cyapa_id_table[] = {
 };
 MODULE_DEVICE_TABLE(i2c, cyapa_id_table);
 
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id cyapa_acpi_id[] = {
+	{ "CYAP0000", 0 },  /* Gen3 trackpad with 0x67 I2C address. */
+	{ "CYAP0001", 0 },  /* Gen5 trackpad with 0x24 I2C address. */
+	{ }
+};
+MODULE_DEVICE_TABLE(acpi, cyapa_acpi_id);
+#endif
+
 static struct i2c_driver cyapa_driver = {
 	.driver = {
 		.name = "cyapa",
 		.owner = THIS_MODULE,
 		.pm = &cyapa_pm_ops,
+#ifdef CONFIG_ACPI
+		.acpi_match_table = ACPI_PTR(cyapa_acpi_id),
+#endif
 	},
 
 	.probe = cyapa_probe,
-- 
1.9.1

