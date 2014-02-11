Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360AbaBKAEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:04:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63711 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752889AbaBKAEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:04:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PCI <linux-pci@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 1/2] ACPI / hotplug / PCI: Rename register_slot() to acpiphp_add_context()
Date: Tue, 11 Feb 2014 01:17:54 +0100
Message-ID: <8514198.o2DR6kBoT0@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1461050.jQppMgDSvA@vostro.rjw.lan>
References: <1461050.jQppMgDSvA@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The name of register_slot() doesn't really reflect what the function
is does, so rename it to acpiphp_add_context() and add a proper
kerneldoc comment to it.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -255,9 +255,15 @@ static void acpiphp_dock_release(void *d
 	put_bridge(context->func.parent);
 }
 
-/* callback routine to register each ACPI PCI slot object */
-static acpi_status register_slot(acpi_handle handle, u32 lvl, void *data,
-				 void **rv)
+/**
+ * acpiphp_add_context - Add ACPIPHP context to an ACPI device object.
+ * @handle: ACPI handle of the object to add a context to.
+ * @lvl: Not used.
+ * @data: The object's parent ACPIPHP bridge.
+ * @rv: Not used.
+ */
+static acpi_status acpiphp_add_context(acpi_handle handle, u32 lvl, void *data,
+				       void **rv)
 {
 	struct acpiphp_bridge *bridge = data;
 	struct acpiphp_context *context;
@@ -919,14 +925,14 @@ void acpiphp_enumerate_slots(struct pci_
 		acpi_unlock_hp_context();
 	}
 
-	/* must be added to the list prior to calling register_slot */
+	/* Must be added to the list prior to calling acpiphp_add_context(). */
 	mutex_lock(&bridge_mutex);
 	list_add(&bridge->list, &bridge_list);
 	mutex_unlock(&bridge_mutex);
 
 	/* register all slot objects under this bridge */
 	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
-				     register_slot, NULL, bridge, NULL);
+				     acpiphp_add_context, NULL, bridge, NULL);
 	if (ACPI_FAILURE(status)) {
 		acpi_handle_err(handle, "failed to register slots\n");
 		cleanup_bridge(bridge);

