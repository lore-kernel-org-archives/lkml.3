Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaIGSCL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:02:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54546 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010AbaIGSCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:02:09 -0400
Date: Sun, 7 Sep 2014 20:02:04 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] PCI: fix a missing space coding style issue
Message-ID: <20140907180204.GA12386@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified the files in the directory so that they respect
the coding style with regards to parenthesis being
preceded by a space.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/pci/hotplug/acpiphp_ibm.c    |  2 +-
 drivers/pci/hotplug/cpcihp_generic.c | 28 ++++++++++++++--------------
 drivers/pci/hotplug/cpcihp_zt5550.c  | 36 ++++++++++++++++++------------------
 drivers/pci/hotplug/cpqphp.h         |  2 +-
 drivers/pci/hotplug/cpqphp_ctrl.c    |  4 ++--
 5 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
index 8dcccff..6ca2399 100644
--- a/drivers/pci/hotplug/acpiphp_ibm.c
+++ b/drivers/pci/hotplug/acpiphp_ibm.c
@@ -302,7 +302,7 @@ static int ibm_get_table_from_acpi(char **bufp)
 		goto read_table_done;
 	}
 
-	for(size = 0, i = 0; i < package->package.count; i++) {
+	for (size = 0, i = 0; i < package->package.count; i++) {
 		if (package->package.elements[i].type != ACPI_TYPE_BUFFER) {
 			pr_err("%s:  Invalid APCI element %d\n", __func__, i);
 			goto read_table_done;
diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
index 04fcd78..66b7bbe 100644
--- a/drivers/pci/hotplug/cpcihp_generic.c
+++ b/drivers/pci/hotplug/cpcihp_generic.c
@@ -56,7 +56,7 @@
 		if (debug)					\
 			printk (KERN_DEBUG "%s: " format "\n",	\
 				MY_NAME , ## arg);		\
-	} while(0)
+	} while (0)
 #define err(format, arg...) printk(KERN_ERR "%s: " format "\n", MY_NAME , ## arg)
 #define info(format, arg...) printk(KERN_INFO "%s: " format "\n", MY_NAME , ## arg)
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
@@ -82,28 +82,28 @@ static int __init validate_parameters(void)
 	char *p;
 	unsigned long tmp;
 
-	if(!bridge) {
+	if (!bridge) {
 		info("not configured, disabling.");
 		return -EINVAL;
 	}
 	str = bridge;
-	if(!*str)
+	if (!*str)
 		return -EINVAL;
 
 	tmp = simple_strtoul(str, &p, 16);
-	if(p == str || tmp > 0xff) {
+	if (p == str || tmp > 0xff) {
 		err("Invalid hotplug bus bridge device bus number");
 		return -EINVAL;
 	}
 	bridge_busnr = (u8) tmp;
 	dbg("bridge_busnr = 0x%02x", bridge_busnr);
-	if(*p != ':') {
+	if (*p != ':') {
 		err("Invalid hotplug bus bridge device");
 		return -EINVAL;
 	}
 	str = p + 1;
 	tmp = simple_strtoul(str, &p, 16);
-	if(p == str || tmp > 0x1f) {
+	if (p == str || tmp > 0x1f) {
 		err("Invalid hotplug bus bridge device slot number");
 		return -EINVAL;
 	}
@@ -112,18 +112,18 @@ static int __init validate_parameters(void)
 
 	dbg("first_slot = 0x%02x", first_slot);
 	dbg("last_slot = 0x%02x", last_slot);
-	if(!(first_slot && last_slot)) {
+	if (!(first_slot && last_slot)) {
 		err("Need to specify first_slot and last_slot");
 		return -EINVAL;
 	}
-	if(last_slot < first_slot) {
+	if (last_slot < first_slot) {
 		err("first_slot must be less than last_slot");
 		return -EINVAL;
 	}
 
 	dbg("port = 0x%04x", port);
 	dbg("enum_bit = 0x%02x", enum_bit);
-	if(enum_bit > 7) {
+	if (enum_bit > 7) {
 		err("Invalid #ENUM bit");
 		return -EINVAL;
 	}
@@ -151,12 +151,12 @@ static int __init cpcihp_generic_init(void)
 		return status;
 
 	r = request_region(port, 1, "#ENUM hotswap signal register");
-	if(!r)
+	if (!r)
 		return -EBUSY;
 
 	dev = pci_get_domain_bus_and_slot(0, bridge_busnr,
 					  PCI_DEVFN(bridge_slot, 0));
-	if(!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
+	if (!dev || dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
 		err("Invalid bridge device %s", bridge);
 		pci_dev_put(dev);
 		return -EINVAL;
@@ -169,21 +169,21 @@ static int __init cpcihp_generic_init(void)
 	generic_hpc.ops = &generic_hpc_ops;
 
 	status = cpci_hp_register_controller(&generic_hpc);
-	if(status != 0) {
+	if (status != 0) {
 		err("Could not register cPCI hotplug controller");
 		return -ENODEV;
 	}
 	dbg("registered controller");
 
 	status = cpci_hp_register_bus(bus, first_slot, last_slot);
-	if(status != 0) {
+	if (status != 0) {
 		err("Could not register cPCI hotplug bus");
 		goto init_bus_register_error;
 	}
 	dbg("registered bus");
 
 	status = cpci_hp_start();
-	if(status != 0) {
+	if (status != 0) {
 		err("Could not started cPCI hotplug system");
 		goto init_start_error;
 	}
diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
index 6757b3e..e618020 100644
--- a/drivers/pci/hotplug/cpcihp_zt5550.c
+++ b/drivers/pci/hotplug/cpcihp_zt5550.c
@@ -51,7 +51,7 @@
 		if (debug)					\
 			printk (KERN_DEBUG "%s: " format "\n",	\
 				MY_NAME , ## arg);		\
-	} while(0)
+	} while (0)
 #define err(format, arg...) printk(KERN_ERR "%s: " format "\n", MY_NAME , ## arg)
 #define info(format, arg...) printk(KERN_INFO "%s: " format "\n", MY_NAME , ## arg)
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
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
diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index 0450f40..b28b2d2 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -690,7 +690,7 @@ static inline int cpq_get_latch_status(struct controller *ctrl,
 
 	status = (readl(ctrl->hpc_reg + INT_INPUT_CLEAR) & (0x01L << hp_slot));
 
-	return(status == 0) ? 1 : 0;
+	return (status == 0) ? 1 : 0;
 }
 
 
diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index bde47fc..476482e 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -1143,7 +1143,7 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 	/* We don't allow freq/mode changes if we find another adapter running
 	 * in another slot on this controller
 	 */
-	for(slot = ctrl->slot; slot; slot = slot->next) {
+	for (slot = ctrl->slot; slot; slot = slot->next) {
 		if (slot->device == (hp_slot + ctrl->slot_device_offset))
 			continue;
 		if (!slot->hotplug_slot || !slot->hotplug_slot->info)
@@ -1193,7 +1193,7 @@ static u8 set_controller_speed(struct controller *ctrl, u8 adapter_speed, u8 hp_
 
 	reg16 = readw(ctrl->hpc_reg + NEXT_CURR_FREQ);
 	reg16 &= ~0x000F;
-	switch(adapter_speed) {
+	switch (adapter_speed) {
 		case(PCI_SPEED_133MHz_PCIX):
 			reg = 0x75;
 			reg16 |= 0xB;
-- 
1.9.1

