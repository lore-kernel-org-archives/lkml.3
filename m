Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab3HWUOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:14:44 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:55749 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab3HWUOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:14:43 -0400
From: Wei Hu <wei@aristanetworks.com>
To: Guenter Roeck <groeck7@gmail.com>, Clemens Ladisch <clemens@ladisch.de>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: Wei Hu <wei@aristanetworks.com>
Subject: [PATCH] hwmon: (k10temp) Add support for Fam16h (Kabini)
Date: Fri, 23 Aug 2013 13:14:03 -0700
Message-Id: <1377288843-18253-1-git-send-email-wei@aristanetworks.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <20130823195810.GA12208@roeck-us.net>
References: <20130823195810.GA12208@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The temperature reporting interface stays the same, so we just
add the PCI-ID to the list.

Verified on AMD Olive Hill.

Signed-off-by: Wei Hu <wei@aristanetworks.com>
---
 Documentation/hwmon/k10temp |    1 +
 drivers/hwmon/Kconfig       |    4 ++--
 drivers/hwmon/k10temp.c     |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/hwmon/k10temp b/Documentation/hwmon/k10temp
index 90956b6..4dfdc8f 100644
--- a/Documentation/hwmon/k10temp
+++ b/Documentation/hwmon/k10temp
@@ -12,6 +12,7 @@ Supported chips:
 * AMD Family 12h processors: "Llano" (E2/A4/A6/A8-Series)
 * AMD Family 14h processors: "Brazos" (C/E/G/Z-Series)
 * AMD Family 15h processors: "Bulldozer" (FX-Series), "Trinity"
+* AMD Family 16h processors: "Kabini"
 
   Prefix: 'k10temp'
   Addresses scanned: PCI space
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index e989f7f..1e27838 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -296,8 +296,8 @@ config SENSORS_K10TEMP
 	  If you say yes here you get support for the temperature
 	  sensor(s) inside your CPU. Supported are later revisions of
 	  the AMD Family 10h and all revisions of the AMD Family 11h,
-	  12h (Llano), 14h (Brazos) and 15h (Bulldozer/Trinity)
-	  microarchitectures.
+	  12h (Llano), 14h (Brazos), 15h (Bulldozer/Trinity) and
+	  16h (Kabini) microarchitectures.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called k10temp.
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index e3b037c..e633856 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -1,5 +1,5 @@
 /*
- * k10temp.c - AMD Family 10h/11h/12h/14h/15h processor hardware monitoring
+ * k10temp.c - AMD Family 10h/11h/12h/14h/15h/16h processor hardware monitoring
  *
  * Copyright (c) 2009 Clemens Ladisch <clemens@ladisch.de>
  *
@@ -211,6 +211,7 @@ static DEFINE_PCI_DEVICE_TABLE(k10temp_id_table) = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, k10temp_id_table);
-- 
1.7.4.4

