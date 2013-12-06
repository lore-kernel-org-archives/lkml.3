Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab3LFHgd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:36:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:44787 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753205Ab3LFHgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:36:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,839,1378882800"; 
   d="scan'208";a="420332955"
From: Lan Tianyu <tianyu.lan@intel.com>
To: lenb@kernel.org, rjw@rjwysocki.net
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI/Processor: use ACPI_COMPANION to get ACPI device
Date: Fri,  6 Dec 2013 15:36:26 +0800
Message-Id: <1386315386-4650-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using ACPI_COMPANION to get ACPI device instead of acpi_bus_get_device().

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/processor_driver.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 146ab7e..c1c3562 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -224,9 +224,9 @@ static int __acpi_processor_start(struct acpi_device *device)
 
 static int acpi_processor_start(struct device *dev)
 {
-	struct acpi_device *device;
+	struct acpi_device *device = ACPI_COMPANION(dev);
 
-	if (acpi_bus_get_device(ACPI_HANDLE(dev), &device))
+	if (!device)
 		return -ENODEV;
 
 	return __acpi_processor_start(device);
@@ -234,10 +234,10 @@ static int acpi_processor_start(struct device *dev)
 
 static int acpi_processor_stop(struct device *dev)
 {
-	struct acpi_device *device;
+	struct acpi_device *device = ACPI_COMPANION(dev);
 	struct acpi_processor *pr;
 
-	if (acpi_bus_get_device(ACPI_HANDLE(dev), &device))
+	if (!device)
 		return 0;
 
 	acpi_remove_notify_handler(device->handle, ACPI_DEVICE_NOTIFY,
-- 
1.8.2.1

