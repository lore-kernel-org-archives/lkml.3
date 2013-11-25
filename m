Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab3KYABu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 19:01:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50639 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752078Ab3KYABo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 19:01:44 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 3/4] ACPI / bind: Redefine acpi_get_child()
Date: Mon, 25 Nov 2013 01:12:45 +0100
Message-ID: <1530243.8AySlVFSvm@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2610478.KxPMyuOMok@vostro.rjw.lan>
References: <2610478.KxPMyuOMok@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since acpi_get_child() is the only user of acpi_find_child() now,
drop the static inline definition of the former and redefine the
latter as new acpi_get_child().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c     |    6 +++---
 include/acpi/acpi_bus.h |    6 +-----
 2 files changed, 4 insertions(+), 8 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -147,16 +147,16 @@ struct acpi_device *acpi_find_child_devi
 	return ret;
 }
 
-acpi_handle acpi_find_child(acpi_handle handle, u64 addr, bool is_bridge)
+acpi_handle acpi_get_child(acpi_handle handle, u64 addr)
 {
 	struct acpi_device *parent;
 
 	if (!handle || acpi_bus_get_device(handle, &parent))
 		return NULL;
 
-	return acpi_find_child_device(parent, addr, is_bridge);
+	return acpi_find_child_device(parent, addr, false);
 }
-EXPORT_SYMBOL_GPL(acpi_find_child);
+EXPORT_SYMBOL_GPL(acpi_get_child);
 
 static void acpi_physnode_link_name(char *buf, unsigned int node_id)
 {
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -436,11 +436,7 @@ struct acpi_pci_root {
 
 struct acpi_device *acpi_find_child_device(struct acpi_device *parent,
 					   u64 address, bool check_children);
-acpi_handle acpi_find_child(acpi_handle, u64, bool);
-static inline acpi_handle acpi_get_child(acpi_handle handle, u64 addr)
-{
-	return acpi_find_child(handle, addr, false);
-}
+acpi_handle acpi_get_child(acpi_handle handle, u64 addr);
 void acpi_preset_companion(struct device *dev, acpi_handle parent, u64 addr);
 int acpi_is_root_bridge(acpi_handle);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);

