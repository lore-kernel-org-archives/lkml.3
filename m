Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaBCXbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:31:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59578 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753741AbaBCX22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:28 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 7/24][Resend] ACPI / hotplug / PCI: Proper kerneldoc comments for enumeration/removal
Date: Tue, 04 Feb 2014 00:21:09 +0100
Message-ID: <1440107.UAdRzE8vMj@vostro.rjw.lan>
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

Add proper kerneldoc comments describing acpiphp_enumerate_slots()
and acpiphp_remove_slots().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -1001,9 +1001,12 @@ static void handle_hotplug_event(acpi_ha
 	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
 
-/*
- * Create hotplug slots for the PCI bus.
- * It should always return 0 to avoid skipping following notifiers.
+/**
+ * acpiphp_enumerate_slots - Enumerate PCI slots for a given bus.
+ * @bus: PCI bus to enumerate the slots for.
+ *
+ * A "slot" is an object associated with a PCI device number.  All functions
+ * (PCI devices) with the same bus and device number belong to the same slot.
  */
 void acpiphp_enumerate_slots(struct pci_bus *bus)
 {
@@ -1076,7 +1079,10 @@ void acpiphp_enumerate_slots(struct pci_
 	}
 }
 
-/* Destroy hotplug slots associated with the PCI bus */
+/**
+ * acpiphp_remove_slots - Remove slot objects associated with a given bus.
+ * @bus: PCI bus to remove the slot objects for.
+ */
 void acpiphp_remove_slots(struct pci_bus *bus)
 {
 	struct acpiphp_bridge *bridge;

