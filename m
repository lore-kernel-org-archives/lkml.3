Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752441AbaHDTCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:02:00 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48383 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbaHDTB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:01:58 -0400
Date: Mon, 4 Aug 2014 21:01:53 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] PCI hotplug: remove assignement from if conditions
Message-ID: <20140804190153.GA4257@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following Coccinelle semantic patch was used to
find and correct cases of assignements in if conditions:

@ifassign@
expression var, expr;
statement S;
@@

- if(!(var = expr)) S
+ var = expr;
+ if(!var) S

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/pci/hotplug/acpi_pcihp.c    | 3 ++-
 drivers/pci/hotplug/cpcihp_zt5550.c | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index a94d850..2cac548 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -433,7 +433,8 @@ int acpi_pci_check_ejectable(struct pci_bus *pbus, acpi_handle handle)
 {
 	acpi_handle bridge_handle, parent_handle;
 
-	if (!(bridge_handle = acpi_pci_get_bridge_handle(pbus)))
+	bridge_handle = acpi_pci_get_bridge_handle(pbus);
+	if (!bridge_handle)
 		return 0;
 	if ((ACPI_FAILURE(acpi_get_parent(handle, &parent_handle))))
 		return 0;
diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
index 2b222fc..4d0cf3f 100644
--- a/drivers/pci/hotplug/cpcihp_zt5550.c
+++ b/drivers/pci/hotplug/cpcihp_zt5550.c
@@ -237,8 +237,9 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 	dbg("registered controller");
 
 	/* Look for first device matching cPCI bus's bridge vendor and device IDs */
-	if (!(bus0_dev = pci_get_device(PCI_VENDOR_ID_DEC,
-					 PCI_DEVICE_ID_DEC_21154, NULL))) {
+	bus0_dev = pci_get_device(PCI_VENDOR_ID_DEC,
+				  PCI_DEVICE_ID_DEC_21154, NULL);
+	if (!bus0_dev) {
 		status = -ENODEV;
 		goto init_register_error;
 	}
-- 
1.9.1

