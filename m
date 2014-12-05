Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaLEMGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:06:16 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45123 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822AbaLEMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:06:14 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2] dell-smo8800: Add more ACPI ids and change description of driver
Date: Fri,  5 Dec 2014 13:05:46 +0100
Message-Id: <1417781146-6261-1-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20141203134323.GI75099@vmdeb7>
References: <20141203134323.GI75099@vmdeb7>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds other ACPI ids from Windows inf driver which should be handled
by dell-smo8800 driver. ACPI devices have same structure -- one IRQ number.

This patch also updates description of module.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/platform/x86/Kconfig        |    4 ++--
 drivers/platform/x86/dell-smo8800.c |   10 ++++++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 3bbcbf1..4614f35 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -128,10 +128,10 @@ config DELL_WMI_AIO
 	  be called dell-wmi-aio.
 
 config DELL_SMO8800
-	tristate "Dell Latitude freefall driver (ACPI SMO8800/SMO8810)"
+	tristate "Dell Latitude freefall driver (ACPI SMO88XX)"
 	depends on ACPI
 	---help---
-	  Say Y here if you want to support SMO8800/SMO8810 freefall device
+	  Say Y here if you want to support SMO88XX freefall devices
 	  on Dell Latitude laptops.
 
 	  To compile this driver as a module, choose M here: the module will
diff --git a/drivers/platform/x86/dell-smo8800.c b/drivers/platform/x86/dell-smo8800.c
index a653716..0aec4fd 100644
--- a/drivers/platform/x86/dell-smo8800.c
+++ b/drivers/platform/x86/dell-smo8800.c
@@ -1,5 +1,5 @@
 /*
- *  dell-smo8800.c - Dell Latitude ACPI SMO8800/SMO8810 freefall sensor driver
+ *  dell-smo8800.c - Dell Latitude ACPI SMO88XX freefall sensor driver
  *
  *  Copyright (C) 2012 Sonal Santan <sonal.santan@gmail.com>
  *  Copyright (C) 2014 Pali Rohár <pali.rohar@gmail.com>
@@ -209,7 +209,13 @@ static int smo8800_remove(struct acpi_device *device)
 
 static const struct acpi_device_id smo8800_ids[] = {
 	{ "SMO8800", 0 },
+	{ "SMO8801", 0 },
 	{ "SMO8810", 0 },
+	{ "SMO8811", 0 },
+	{ "SMO8820", 0 },
+	{ "SMO8821", 0 },
+	{ "SMO8830", 0 },
+	{ "SMO8831", 0 },
 	{ "", 0 },
 };
 
@@ -228,6 +234,6 @@ static struct acpi_driver smo8800_driver = {
 
 module_acpi_driver(smo8800_driver);
 
-MODULE_DESCRIPTION("Dell Latitude freefall driver (ACPI SMO8800/SMO8810)");
+MODULE_DESCRIPTION("Dell Latitude freefall driver (ACPI SMO88XX)");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sonal Santan, Pali Rohár");
-- 
1.7.9.5

