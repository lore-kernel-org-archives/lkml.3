Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaBCXfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:35:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62051 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753484AbaBCX2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 15/24][Resend] ACPI / hotplug / PCI: Use acpi_handle_debug() in hotplug_event()
Date: Tue, 04 Feb 2014 00:33:56 +0100
Message-ID: <5322449.ygVERcl5IX@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <7532948.aJNUotNMpR@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <20140203104408.GQ18029@intel.com> <7532948.aJNUotNMpR@vostro.rjw.lan>
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
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -819,9 +819,6 @@ static void hotplug_event(acpi_handle ha
 	struct acpiphp_func *func = &context->func;
 	struct acpiphp_slot *slot = func->slot;
 	struct acpiphp_bridge *bridge;
-	char objname[64];
-	struct acpi_buffer buffer = { .length = sizeof(objname),
-				      .pointer = objname };
 
 	mutex_lock(&acpiphp_context_lock);
 	bridge = context->bridge;
@@ -831,14 +828,11 @@ static void hotplug_event(acpi_handle ha
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
@@ -848,7 +842,7 @@ static void hotplug_event(acpi_handle ha
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		/* device check */
-		pr_debug("%s: Device check notify on %s\n", __func__, objname);
+		acpi_handle_debug(handle, "Device check in %s()\n", __func__);
 		if (bridge) {
 			acpiphp_check_bridge(bridge);
 		} else if (!(slot->flags & SLOT_IS_GOING_AWAY)) {
@@ -863,7 +857,7 @@ static void hotplug_event(acpi_handle ha
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
-		pr_debug("%s: Device eject notify on %s\n", __func__, objname);
+		acpi_handle_debug(handle, "Eject request in %s()\n", __func__);
 		acpiphp_disable_and_eject_slot(slot);
 		break;
 	}
