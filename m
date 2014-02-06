Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaBFMy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:54:56 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55322 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932516AbaBFMyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:54:54 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [Update][PATCH 22/24] ACPI / hotplug / PCI: Simplify acpi_install_hotplug_notify_handler()
Date: Thu, 06 Feb 2014 14:09:25 +0100
Message-ID: <1570837.kWWUv8FW0Z@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <2300097.5mc1uSoD5p@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <7532948.aJNUotNMpR@vostro.rjw.lan> <2300097.5mc1uSoD5p@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / hotplug / PCI: Simplify acpi_install_hotplug_notify_handler()

Since acpi_hotplug_notify_cb() does not use its data argument any
more, the second argument of acpi_install_hotplug_notify_handler()
can be dropped, so do that and update its callers accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

This one had to be updated after patch [20/24] had been updated.

Thanks,
Rafael

---
 drivers/acpi/scan.c                |    6 +++---
 drivers/pci/hotplug/acpiphp_glue.c |    2 +-
 include/acpi/acpi_bus.h            |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -577,10 +577,10 @@ static void acpi_hotplug_notify_cb(acpi_
 	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
 
-void acpi_install_hotplug_notify_handler(acpi_handle handle, void *data)
+void acpi_install_hotplug_notify_handler(acpi_handle handle)
 {
 	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-				    acpi_hotplug_notify_cb, data);
+				    acpi_hotplug_notify_cb, NULL);
 }
 
 void acpi_remove_hotplug_notify_handler(acpi_handle handle)
@@ -2040,7 +2040,7 @@ static void acpi_scan_init_hotplug(struc
 		if (!handler)
 			continue;
 
-		acpi_install_hotplug_notify_handler(adev->handle, handler);
+		acpi_install_hotplug_notify_handler(adev->handle);
 		adev->flags.hotplug_notify = true;
 		break;
 	}
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -372,7 +372,7 @@ static acpi_status register_slot(acpi_ha
 
 	/* install notify handler */
 	if (!(newfunc->flags & FUNC_HAS_DCK))
-		acpi_install_hotplug_notify_handler(handle, NULL);
+		acpi_install_hotplug_notify_handler(handle);
 
 	return AE_OK;
 }
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -446,7 +446,7 @@ static inline bool acpi_device_enumerate
 typedef void (*acpi_hp_callback)(void *data, u32 src);
 
 acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src);
-void acpi_install_hotplug_notify_handler(acpi_handle handle, void *data);
+void acpi_install_hotplug_notify_handler(acpi_handle handle);
 void acpi_remove_hotplug_notify_handler(acpi_handle handle);
 
 /**

