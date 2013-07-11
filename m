Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757118Ab3GLAEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:04:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39032 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab3GKX65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 17/30] ACPI / hotplug / PCI: Drop handle field from struct acpiphp_bridge
Date: Fri, 12 Jul 2013 01:56:14 +0200
Message-ID: <2667716.Z7hGFDk2mK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The handle field in struct acpiphp_bridge is only used by
acpiphp_enumerate_slots(), but in that function the local handle
variable can be used instead, so make that happen and drop handle
from struct acpiphp_bridge.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    1 -
 drivers/pci/hotplug/acpiphp_glue.c |    5 ++---
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -76,7 +76,6 @@ struct acpiphp_bridge {
 	struct list_head list;
 	struct list_head slots;
 	struct kref ref;
-	acpi_handle handle;
 
 	struct acpiphp_context *context;
 
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -1107,7 +1107,6 @@ void acpiphp_enumerate_slots(struct pci_
 
 	INIT_LIST_HEAD(&bridge->slots);
 	kref_init(&bridge->ref);
-	bridge->handle = handle;
 	bridge->pci_dev = pci_dev_get(bus->self);
 	bridge->pci_bus = bus;
 
@@ -1147,10 +1146,10 @@ void acpiphp_enumerate_slots(struct pci_
 	mutex_unlock(&bridge_mutex);
 
 	/* register all slot objects under this bridge */
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, bridge->handle, 1,
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
 				     register_slot, NULL, bridge, NULL);
 	if (ACPI_FAILURE(status)) {
-		acpi_handle_err(bridge->handle, "failed to register slots\n");
+		acpi_handle_err(handle, "failed to register slots\n");
 		cleanup_bridge(bridge);
 		put_bridge(bridge);
 	}

