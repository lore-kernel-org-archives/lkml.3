Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbaBBASV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 19:18:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54475 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754524AbaBBASR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 19:18:17 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 12/13] ACPI / hotplug / PCI: Use acpi_handle_debug() in hotplug_event()
Date: Sun, 02 Feb 2014 01:31:04 +0100
Message-ID: <6471909.WrxDdSLtfn@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1935791.liE9ZlzmO9@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1935791.liE9ZlzmO9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make hotplug_event() use acpi_handle_debug() instead of an open-coded
debug message printing and clean up the messages printed by it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -794,9 +794,6 @@ static void hotplug_event(acpi_handle ha
 	struct acpiphp_func *func = &context->func;
 	struct acpiphp_slot *slot = func->slot;
 	struct acpiphp_bridge *bridge;
-	char objname[64];
-	struct acpi_buffer buffer = { .length = sizeof(objname),
-				      .pointer = objname };
 
 	mutex_lock(&acpiphp_context_lock);
 	bridge = context->bridge;
@@ -806,14 +803,11 @@ static void hotplug_event(acpi_handle ha
 	mutex_unlock(&acpiphp_context_lock);
 
 	pci_lock_rescan_remove();
-	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* bus re-enumerate */
-		pr_debug("%s: Bus check notify on %s\n", __func__, objname);
-		pr_debug("%s: re-enumerating slots under %s\n",
-			 __func__, objname);
+		acpi_handle_debug(handle, "Bus check in %s()\n", __func__);
 		if (bridge)
 			acpiphp_check_bridge(bridge);
 		else if (!(slot->flags & SLOT_IS_GOING_AWAY))
@@ -823,7 +817,7 @@ static void hotplug_event(acpi_handle ha
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		/* device check */
-		pr_debug("%s: Device check notify on %s\n", __func__, objname);
+		acpi_handle_debug(handle, "Device check in %s()\n", __func__);
 		if (bridge) {
 			acpiphp_check_bridge(bridge);
 		} else if (!(slot->flags & SLOT_IS_GOING_AWAY)) {
@@ -838,7 +832,7 @@ static void hotplug_event(acpi_handle ha
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
-		pr_debug("%s: Device eject notify on %s\n", __func__, objname);
+		acpi_handle_debug(handle, "Eject request in %s()\n", __func__);
 		acpiphp_disable_and_eject_slot(slot);
 		break;
 	}

