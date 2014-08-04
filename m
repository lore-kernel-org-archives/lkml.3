Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaHDTAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 15:00:32 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:59666 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaHDTAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 15:00:30 -0400
Date: Mon, 4 Aug 2014 21:00:24 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>,
        linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] PCI hotplug: fix a missing space coding style issue
Message-ID: <20140804190024.GA4229@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified the file so that it respects the coding style
with regards to "if"s being followed by a space.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/pci/hotplug/cpcihp_zt5550.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
index 6757b3e..42a61c2 100644
--- a/drivers/pci/hotplug/cpcihp_zt5550.c
+++ b/drivers/pci/hotplug/cpcihp_zt5550.c
@@ -82,13 +82,13 @@ static int zt5550_hc_config(struct pci_dev *pdev)
 	int ret;
 
 	/* Since we know that no boards exist with two HC chips, treat it as an error */
-	if(hc_dev) {
+	if (hc_dev) {
 		err("too many host controller devices?");
 		return -EBUSY;
 	}
 
 	ret = pci_enable_device(pdev);
-	if(ret) {
+	if (ret) {
 		err("cannot enable %s\n", pci_name(pdev));
 		return ret;
 	}
@@ -98,7 +98,7 @@ static int zt5550_hc_config(struct pci_dev *pdev)
 	dbg("pci resource start %llx", (unsigned long long)pci_resource_start(hc_dev, 1));
 	dbg("pci resource len %llx", (unsigned long long)pci_resource_len(hc_dev, 1));
 
-	if(!request_mem_region(pci_resource_start(hc_dev, 1),
+	if (!request_mem_region(pci_resource_start(hc_dev, 1),
 				pci_resource_len(hc_dev, 1), MY_NAME)) {
 		err("cannot reserve MMIO region");
 		ret = -ENOMEM;
@@ -107,7 +107,7 @@ static int zt5550_hc_config(struct pci_dev *pdev)
 
 	hc_registers =
 	    ioremap(pci_resource_start(hc_dev, 1), pci_resource_len(hc_dev, 1));
-	if(!hc_registers) {
+	if (!hc_registers) {
 		err("cannot remap MMIO region %llx @ %llx",
 			(unsigned long long)pci_resource_len(hc_dev, 1),
 			(unsigned long long)pci_resource_start(hc_dev, 1));
@@ -146,7 +146,7 @@ exit_disable_device:
 
 static int zt5550_hc_cleanup(void)
 {
-	if(!hc_dev)
+	if (!hc_dev)
 		return -ENODEV;
 
 	iounmap(hc_registers);
@@ -170,9 +170,9 @@ static int zt5550_hc_check_irq(void *dev_id)
 	u8 reg;
 
 	ret = 0;
-	if(dev_id == zt5550_hpc.dev_id) {
+	if (dev_id == zt5550_hpc.dev_id) {
 		reg = readb(csr_int_status);
-		if(reg)
+		if (reg)
 			ret = 1;
 	}
 	return ret;
@@ -182,7 +182,7 @@ static int zt5550_hc_enable_irq(void)
 {
 	u8 reg;
 
-	if(hc_dev == NULL) {
+	if (hc_dev == NULL) {
 		return -ENODEV;
 	}
 	reg = readb(csr_int_mask);
@@ -195,7 +195,7 @@ static int zt5550_hc_disable_irq(void)
 {
 	u8 reg;
 
-	if(hc_dev == NULL) {
+	if (hc_dev == NULL) {
 		return -ENODEV;
 	}
 
@@ -210,7 +210,7 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 	int status;
 
 	status = zt5550_hc_config(pdev);
-	if(status != 0) {
+	if (status != 0) {
 		return status;
 	}
 	dbg("returned from zt5550_hc_config");
@@ -218,7 +218,7 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 	memset(&zt5550_hpc, 0, sizeof (struct cpci_hp_controller));
 	zt5550_hpc_ops.query_enum = zt5550_hc_query_enum;
 	zt5550_hpc.ops = &zt5550_hpc_ops;
-	if(!poll) {
+	if (!poll) {
 		zt5550_hpc.irq = hc_dev->irq;
 		zt5550_hpc.irq_flags = IRQF_SHARED;
 		zt5550_hpc.dev_id = hc_dev;
@@ -231,14 +231,14 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 	}
 
 	status = cpci_hp_register_controller(&zt5550_hpc);
-	if(status != 0) {
+	if (status != 0) {
 		err("could not register cPCI hotplug controller");
 		goto init_hc_error;
 	}
 	dbg("registered controller");
 
 	/* Look for first device matching cPCI bus's bridge vendor and device IDs */
-	if(!(bus0_dev = pci_get_device(PCI_VENDOR_ID_DEC,
+	if (!(bus0_dev = pci_get_device(PCI_VENDOR_ID_DEC,
 					 PCI_DEVICE_ID_DEC_21154, NULL))) {
 		status = -ENODEV;
 		goto init_register_error;
@@ -247,14 +247,14 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 	pci_dev_put(bus0_dev);
 
 	status = cpci_hp_register_bus(bus0, 0x0a, 0x0f);
-	if(status != 0) {
+	if (status != 0) {
 		err("could not register cPCI hotplug bus");
 		goto init_register_error;
 	}
 	dbg("registered bus");
 
 	status = cpci_hp_start();
-	if(status != 0) {
+	if (status != 0) {
 		err("could not started cPCI hotplug system");
 		cpci_hp_unregister_bus(bus0);
 		goto init_register_error;
@@ -300,11 +300,11 @@ static int __init zt5550_init(void)
 
 	info(DRIVER_DESC " version: " DRIVER_VERSION);
 	r = request_region(ENUM_PORT, 1, "#ENUM hotswap signal register");
-	if(!r)
+	if (!r)
 		return -EBUSY;
 
 	rc = pci_register_driver(&zt5550_hc_driver);
-	if(rc < 0)
+	if (rc < 0)
 		release_region(ENUM_PORT, 1);
 	return rc;
 }
-- 
1.9.1

