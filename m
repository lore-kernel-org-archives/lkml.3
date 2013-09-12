Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3ILSQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:16:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab3ILSPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:15:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wei Hu <wei@aristanetworks.com>, Clemens Ladisch <clemens@ladisch.de>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [ 08/16] hwmon: (k10temp) Add support for Fam16h (Kabini)
Date: Thu, 12 Sep 2013 11:15:00 -0700
Message-Id: <20130912181157.116529673@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912181156.173326121@linuxfoundation.org>
References: <20130912181156.173326121@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Hu <wei@aristanetworks.com>

commit 30b146d1cb5e7560192057098eb705118bd5511f upstream.

The temperature reporting interface stays the same, so we just
add the PCI-ID to the list.

Verified on AMD Olive Hill.

Signed-off-by: Wei Hu <wei@aristanetworks.com>
Acked-by: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/hwmon/k10temp |    1 +
 drivers/hwmon/Kconfig       |    4 ++--
 drivers/hwmon/k10temp.c     |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)

--- a/Documentation/hwmon/k10temp
+++ b/Documentation/hwmon/k10temp
@@ -12,6 +12,7 @@ Supported chips:
 * AMD Family 12h processors: "Llano" (E2/A4/A6/A8-Series)
 * AMD Family 14h processors: "Brazos" (C/E/G/Z-Series)
 * AMD Family 15h processors: "Bulldozer" (FX-Series), "Trinity"
+* AMD Family 16h processors: "Kabini"
 
   Prefix: 'k10temp'
   Addresses scanned: PCI space
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
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -1,5 +1,5 @@
 /*
- * k10temp.c - AMD Family 10h/11h/12h/14h/15h processor hardware monitoring
+ * k10temp.c - AMD Family 10h/11h/12h/14h/15h/16h processor hardware monitoring
  *
  * Copyright (c) 2009 Clemens Ladisch <clemens@ladisch.de>
  *
@@ -211,6 +211,7 @@ static DEFINE_PCI_DEVICE_TABLE(k10temp_i
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, k10temp_id_table);


