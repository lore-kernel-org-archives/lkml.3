Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaETNJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:09:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:58251 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaETNJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:09:38 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2014 09:09:38 EDT
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,874,1392192000"; 
   d="scan'208";a="534814096"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, rjw@rjwysocki.net, mika.westerberg@linux.intel.com,
        awilliam@redhat.com, lenb@kernel.org
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [Patch V3 3/5] ACPI/Thermal: Use acpi_bus_attach_private_data() to attach private data
Date: Tue, 20 May 2014 20:59:22 +0800
Message-Id: <1400590764-11108-4-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400590764-11108-1-git-send-email-tianyu.lan@intel.com>
References: <1400590764-11108-1-git-send-email-tianyu.lan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use acpi_bus_attach_private_data() to attach private data
instead of acpi_attach_data().

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/acpi/thermal.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index c1e31a4..ae195fd 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -925,13 +925,10 @@ static int acpi_thermal_register_thermal_zone(struct acpi_thermal *tz)
 	if (result)
 		return result;
 
-	status = acpi_attach_data(tz->device->handle,
-				  acpi_bus_private_data_handler,
-				  tz->thermal_zone);
-	if (ACPI_FAILURE(status)) {
-		pr_err(PREFIX "Error attaching device data\n");
+	status =  acpi_bus_attach_private_data(tz->device->handle,
+					       tz->thermal_zone);
+	if (ACPI_FAILURE(status))
 		return -ENODEV;
-	}
 
 	tz->tz_enabled = 1;
 
@@ -946,7 +943,7 @@ static void acpi_thermal_unregister_thermal_zone(struct acpi_thermal *tz)
 	sysfs_remove_link(&tz->thermal_zone->device.kobj, "device");
 	thermal_zone_device_unregister(tz->thermal_zone);
 	tz->thermal_zone = NULL;
-	acpi_detach_data(tz->device->handle, acpi_bus_private_data_handler);
+	acpi_bus_detach_private_data(tz->device->handle);
 }
 
 
-- 
1.8.3.1

