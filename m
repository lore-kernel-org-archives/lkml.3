Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab3KQQ0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:26:07 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58548 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751996Ab3KQQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH 9/10] ACPI / hotplug: Drop unfinished global notification handling routines
Date: Sun, 17 Nov 2013 17:37:21 +0100
Message-ID: <1784391.AAAKirYogC@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1421028.Rsfpmhnym3@vostro.rjw.lan>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There are two global hotplug notification handling routines in bus.c,
acpi_bus_check_device() and acpi_bus_check_scope(), that have never
been finished and don't do anything useful, so drop them.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c |   64 +----------------------------------------------------
 1 file changed, 2 insertions(+), 62 deletions(-)

Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -329,58 +329,6 @@ static void acpi_bus_osc_support(void)
                              Notification Handling
    -------------------------------------------------------------------------- */
 
-static void acpi_bus_check_device(acpi_handle handle)
-{
-	struct acpi_device *device;
-	acpi_status status;
-	struct acpi_device_status old_status;
-
-	if (acpi_bus_get_device(handle, &device))
-		return;
-	if (!device)
-		return;
-
-	old_status = device->status;
-
-	/*
-	 * Make sure this device's parent is present before we go about
-	 * messing with the device.
-	 */
-	if (device->parent && !device->parent->status.present) {
-		device->status = device->parent->status;
-		return;
-	}
-
-	status = acpi_bus_get_status(device);
-	if (ACPI_FAILURE(status))
-		return;
-
-	if (STRUCT_TO_INT(old_status) == STRUCT_TO_INT(device->status))
-		return;
-
-	/*
-	 * Device Insertion/Removal
-	 */
-	if ((device->status.present) && !(old_status.present)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device insertion detected\n"));
-		/* TBD: Handle device insertion */
-	} else if (!(device->status.present) && (old_status.present)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Device removal detected\n"));
-		/* TBD: Handle device removal */
-	}
-}
-
-static void acpi_bus_check_scope(acpi_handle handle)
-{
-	/* Status Change? */
-	acpi_bus_check_device(handle);
-
-	/*
-	 * TBD: Enumerate child devices within this device's scope and
-	 *       run acpi_bus_check_device()'s on them.
-	 */
-}
-
 /**
  * acpi_bus_notify
  * ---------------
@@ -397,19 +345,11 @@ static void acpi_bus_notify(acpi_handle
 	switch (type) {
 
 	case ACPI_NOTIFY_BUS_CHECK:
-		acpi_bus_check_scope(handle);
-		/*
-		 * TBD: We'll need to outsource certain events to non-ACPI
-		 *      drivers via the device manager (device.c).
-		 */
+		/* TBD */
 		break;
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		acpi_bus_check_device(handle);
-		/*
-		 * TBD: We'll need to outsource certain events to non-ACPI
-		 *      drivers via the device manager (device.c).
-		 */
+		/* TBD */
 		break;
 
 	case ACPI_NOTIFY_DEVICE_WAKE:

