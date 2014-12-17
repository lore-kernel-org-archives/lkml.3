Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaLQKBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:01:12 -0500
Received: from bay004-omc1s24.hotmail.com ([65.54.190.35]:58830 "EHLO
	BAY004-OMC1S24.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751986AbaLQKBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:01:06 -0500
X-TMN: [eRoAQlLnDzFHi4YVwmbSKSYvvNcA3l8g]
X-Originating-Email: [dudlx@outlook.com]
Message-ID: <BAY407-EAS367C15504A914875665B34FBD6D0@phx.gbl>
From: Dudley Du <dudlx@outlook.com>
To: <dmitry.torokhov@gmail.com>, <jmmahler@gmail.com>, <rydberg@euromail.se>
CC: <bleung@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v16 12/12] input: cyapa: add acpi device id support
Date: Wed, 17 Dec 2014 17:58:04 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AdAZ34AwMsEeAifSTziogTS9Y+++Jg==
Content-Language: zh-cn
X-OriginalArrivalTime: 17 Dec 2014 09:58:06.0172 (UTC) FILETIME=[F45A89C0:01D019DF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add acpi device tree support.
acpi device id "CYAP0000" is for old gen3 trackpad devices.
acpi device id "CYAP0001" is for new gen5 trackpad devices.
TEST=test on Chromebooks.

Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
---
 drivers/input/mouse/cyapa.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 406f38b..62ef19a 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/pm_runtime.h>
+#include <linux/acpi.h>
 #include "cyapa.h"
 
 
@@ -1315,11 +1316,23 @@ static const struct i2c_device_id cyapa_id_table[] = {
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

