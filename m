Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3HEUqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:46:24 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50983 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab3HEUnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:43:07 -0400
Message-ID: <dff046ec3c0e00596fa272b86193483b039c5858.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 14/20] tile PCI RC: bomb comments and whitespace format
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is purely stylistic but improves the readability
of the tile PCI RC driver.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci_gx.c | 180 +++++++++++++++-------------------------------
 1 file changed, 56 insertions(+), 124 deletions(-)

diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 6837be2..8352d85 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -108,17 +108,15 @@ static struct pci_ops tile_cfg_ops;
 /* Mask of CPUs that should receive PCIe interrupts. */
 static struct cpumask intr_cpus_map;
 
-/*
- * We don't need to worry about the alignment of resources.
- */
+/* We don't need to worry about the alignment of resources. */
 resource_size_t pcibios_align_resource(void *data, const struct resource *res,
-				resource_size_t size, resource_size_t align)
+				       resource_size_t size,
+				       resource_size_t align)
 {
 	return res->start;
 }
 EXPORT_SYMBOL(pcibios_align_resource);
 
-
 /*
  * Pick a CPU to receive and handle the PCIe interrupts, based on the IRQ #.
  * For now, we simply send interrupts to non-dataplane CPUs.
@@ -146,25 +144,19 @@ static int tile_irq_cpu(int irq)
 	return cpu;
 }
 
-/*
- * Open a file descriptor to the TRIO shim.
- */
+/* Open a file descriptor to the TRIO shim. */
 static int tile_pcie_open(int trio_index)
 {
 	gxio_trio_context_t *context = &trio_contexts[trio_index];
 	int ret;
 	int mac;
 
-	/*
-	 * This opens a file descriptor to the TRIO shim.
-	 */
+	/* This opens a file descriptor to the TRIO shim. */
 	ret = gxio_trio_init(context, trio_index);
 	if (ret < 0)
 		goto gxio_trio_init_failure;
 
-	/*
-	 * Allocate an ASID for the kernel.
-	 */
+	/* Allocate an ASID for the kernel. */
 	ret = gxio_trio_alloc_asids(context, 1, 0, 0);
 	if (ret < 0) {
 		pr_err("PCI: ASID alloc failure on TRIO %d, give up\n",
@@ -285,20 +277,17 @@ static int __init tile_trio_init(void)
 }
 postcore_initcall(tile_trio_init);
 
-static void
-tilegx_legacy_irq_ack(struct irq_data *d)
+static void tilegx_legacy_irq_ack(struct irq_data *d)
 {
 	__insn_mtspr(SPR_IPI_EVENT_RESET_K, 1UL << d->irq);
 }
 
-static void
-tilegx_legacy_irq_mask(struct irq_data *d)
+static void tilegx_legacy_irq_mask(struct irq_data *d)
 {
 	__insn_mtspr(SPR_IPI_MASK_SET_K, 1UL << d->irq);
 }
 
-static void
-tilegx_legacy_irq_unmask(struct irq_data *d)
+static void tilegx_legacy_irq_unmask(struct irq_data *d)
 {
 	__insn_mtspr(SPR_IPI_MASK_RESET_K, 1UL << d->irq);
 }
@@ -319,8 +308,7 @@ static struct irq_chip tilegx_legacy_irq_chip = {
  * to Linux which just calls handle_level_irq() after clearing the
  * MAC INTx Assert status bit associated with this interrupt.
  */
-static void
-trio_handle_level_irq(unsigned int irq, struct irq_desc *desc)
+static void trio_handle_level_irq(unsigned int irq, struct irq_desc *desc)
 {
 	struct pci_controller *controller = irq_desc_get_handler_data(desc);
 	gxio_trio_context_t *trio_context = controller->trio;
@@ -386,9 +374,7 @@ static int tile_init_irqs(struct pci_controller *controller)
 			goto free_irqs;
 		}
 
-		/*
-		 * Register the IRQ handler with the kernel.
-		 */
+		/* Register the IRQ handler with the kernel. */
 		irq_set_chip_and_handler(irq, &tilegx_legacy_irq_chip,
 					trio_handle_level_irq);
 		irq_set_chip_data(irq, (void *)(uint64_t)i);
@@ -471,15 +457,11 @@ int __init tile_pci_init(void)
 		}
 	}
 
-	/*
-	 * Return if no PCIe ports are configured to operate in RC mode.
-	 */
+	/* Return if no PCIe ports are configured to operate in RC mode. */
 	if (num_rc_controllers == 0)
 		return 0;
 
-	/*
-	 * Set the TRIO pointer and MAC index for each PCIe RC port.
-	 */
+	/* Set the TRIO pointer and MAC index for each PCIe RC port. */
 	for (i = 0; i < TILEGX_NUM_TRIO; i++) {
 		for (j = 0; j < TILEGX_TRIO_PCIES; j++) {
 			if (pcie_rc[i][j]) {
@@ -495,14 +477,10 @@ int __init tile_pci_init(void)
 	}
 
 out:
-	/*
-	 * Configure each PCIe RC port.
-	 */
+	/* Configure each PCIe RC port. */
 	for (i = 0; i < num_rc_controllers; i++) {
-		/*
-		 * Configure the PCIe MAC to run in RC mode.
-		 */
 
+		/* Configure the PCIe MAC to run in RC mode. */
 		struct pci_controller *controller = &pci_controllers[i];
 
 		controller->index = i;
@@ -525,7 +503,6 @@ out:
 		 * is in range [3GB, 4GB - 1] of a 4GB space beyond the
 		 * PA space.
 		 */
-
 		controller->mem_offset = TILE_PCI_MEM_START +
 			(i * TILE_PCI_BAR_WINDOW_TOP);
 		controller->mem_space.start = controller->mem_offset +
@@ -553,7 +530,6 @@ static int tile_map_irq(const struct pci_dev *dev, u8 device, u8 pin)
 	return controller->irq_intx_table[pin - 1];
 }
 
-
 static void fixup_read_and_payload_sizes(struct pci_controller *controller)
 {
 	gxio_trio_context_t *trio_context = controller->trio;
@@ -567,9 +543,7 @@ static void fixup_read_and_payload_sizes(struct pci_controller *controller)
 
 	mac = controller->mac;
 
-	/*
-	 * Set our max read request size to be 4KB.
-	 */
+	/* Set our max read request size to be 4KB. */
 	reg_offset =
 		(TRIO_PCIE_RC_DEVICE_CONTROL <<
 			TRIO_CFG_REGION_ADDR__REG_SHIFT) |
@@ -578,10 +552,10 @@ static void fixup_read_and_payload_sizes(struct pci_controller *controller)
 		(mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
 
 	dev_control.word = __gxio_mmio_read32(trio_context->mmio_base_mac +
-						reg_offset);
+					      reg_offset);
 	dev_control.max_read_req_sz = 5;
 	__gxio_mmio_write32(trio_context->mmio_base_mac + reg_offset,
-						dev_control.word);
+			    dev_control.word);
 
 	/*
 	 * Set the max payload size supported by this Gx PCIe MAC.
@@ -597,10 +571,10 @@ static void fixup_read_and_payload_sizes(struct pci_controller *controller)
 		(mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
 
 	rc_dev_cap.word = __gxio_mmio_read32(trio_context->mmio_base_mac +
-						reg_offset);
+					     reg_offset);
 	rc_dev_cap.mps_sup = 1;
 	__gxio_mmio_write32(trio_context->mmio_base_mac + reg_offset,
-						rc_dev_cap.word);
+			    rc_dev_cap.word);
 
 	/* Configure PCI Express MPS setting. */
 	list_for_each_entry(child, &root_bus->children, node) {
@@ -628,7 +602,7 @@ static void fixup_read_and_payload_sizes(struct pci_controller *controller)
 				    dev_control.max_payload_size,
 				    dev_control.max_read_req_sz,
 				    mac);
-        if (err < 0) {
+	if (err < 0) {
 		pr_err("PCI: PCIE_CONFIGURE_MAC_MPS_MRS failure, "
 			"MAC %d on TRIO %d\n",
 			mac, controller->trio_index);
@@ -672,9 +646,7 @@ static int setup_pcie_rc_delay(char *str)
 }
 early_param("pcie_rc_delay", setup_pcie_rc_delay);
 
-/*
- * PCI initialization entry point, called by subsys_initcall.
- */
+/* PCI initialization entry point, called by subsys_initcall. */
 int __init pcibios_init(void)
 {
 	resource_size_t offset;
@@ -744,9 +716,7 @@ int __init pcibios_init(void)
 		pr_info("PCI: Found PCI controller #%d on TRIO %d MAC %d\n", i,
 			trio_index, controller->mac);
 
-		/*
-		 * Delay the bus probe if needed.
-		 */
+		/* Delay the bus probe if needed. */
 		if (rc_delay[trio_index][mac]) {
 			pr_info("Delaying PCIe RC bus enumerating %d sec"
 				" on MAC %d on TRIO %d\n",
@@ -761,9 +731,7 @@ int __init pcibios_init(void)
 			msleep(1000);
 		}
 
-		/*
-		 * Check for PCIe link-up status again.
-		 */
+		/* Check for PCIe link-up status again. */
 		port_status.word =
 			__gxio_mmio_read(trio_context->mmio_base_mac +
 					 reg_offset);
@@ -801,7 +769,6 @@ int __init pcibios_init(void)
 		 * Change the device ID so that Linux bus crawl doesn't confuse
 		 * the internal bridge with any Tilera endpoints.
 		 */
-
 		reg_offset =
 			(TRIO_PCIE_RC_DEVICE_ID_VEN_ID <<
 				TRIO_CFG_REGION_ADDR__REG_SHIFT) |
@@ -814,10 +781,7 @@ int __init pcibios_init(void)
 				    TRIO_PCIE_RC_DEVICE_ID_VEN_ID__DEV_ID_SHIFT) |
 				    TILERA_VENDOR_ID);
 
-		/*
-		 * Set the internal P2P bridge class code.
-		 */
-
+		/* Set the internal P2P bridge class code. */
 		reg_offset =
 			(TRIO_PCIE_RC_REVISION_ID <<
 				TRIO_CFG_REGION_ADDR__REG_SHIFT) |
@@ -828,26 +792,22 @@ int __init pcibios_init(void)
 		class_code_revision =
 			__gxio_mmio_read32(trio_context->mmio_base_mac +
 					   reg_offset);
-		class_code_revision = (class_code_revision & 0xff ) |
-					(PCI_CLASS_BRIDGE_PCI << 16);
+		class_code_revision = (class_code_revision & 0xff) |
+			(PCI_CLASS_BRIDGE_PCI << 16);
 
 		__gxio_mmio_write32(trio_context->mmio_base_mac +
 				    reg_offset, class_code_revision);
 
 #ifdef USE_SHARED_PCIE_CONFIG_REGION
 
-		/*
-		 * Map in the MMIO space for the PIO region.
-		 */
+		/* Map in the MMIO space for the PIO region. */
 		offset = HV_TRIO_PIO_OFFSET(trio_context->pio_cfg_index) |
 			(((unsigned long long)mac) <<
 			TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR__MAC_SHIFT);
 
 #else
 
-		/*
-		 * Alloc a PIO region for PCI config access per MAC.
-		 */
+		/* Alloc a PIO region for PCI config access per MAC. */
 		ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
 		if (ret < 0) {
 			pr_err("PCI: PCI CFG PIO alloc failure for mac %d "
@@ -858,9 +818,7 @@ int __init pcibios_init(void)
 
 		trio_context->pio_cfg_index[mac] = ret;
 
-		/*
-		 * For PIO CFG, the bus_address_hi parameter is 0.
-		 */
+		/* For PIO CFG, the bus_address_hi parameter is 0. */
 		ret = gxio_trio_init_pio_region_aux(trio_context,
 			trio_context->pio_cfg_index[mac],
 			mac, 0, HV_TRIO_PIO_FLAG_CONFIG_SPACE);
@@ -887,9 +845,7 @@ int __init pcibios_init(void)
 			continue;
 		}
 
-		/*
-		 * Initialize the PCIe interrupts.
-		 */
+		/* Initialize the PCIe interrupts. */
 		if (tile_init_irqs(controller)) {
 			pr_err("PCI: IRQs init failure for mac %d on TRIO %d\n",
 				mac, trio_index);
@@ -921,7 +877,6 @@ int __init pcibios_init(void)
 	 * It allocates all of the resources (I/O memory, etc)
 	 * associated with the devices read in above.
 	 */
-
 	pci_assign_unassigned_resources();
 
 	/* Record the I/O resources in the PCI controller structure. */
@@ -942,14 +897,12 @@ int __init pcibios_init(void)
 		/* Configure the max_payload_size values for this domain. */
 		fixup_read_and_payload_sizes(controller);
 
-		/*
-		 * Alloc a PIO region for PCI memory access for each RC port.
-		 */
+		/* Alloc a PIO region for PCI memory access for each RC port. */
 		ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
 		if (ret < 0) {
 			pr_err("PCI: MEM PIO alloc failure on TRIO %d mac %d, "
-				"give up\n", controller->trio_index,
-				controller->mac);
+			       "give up\n", controller->trio_index,
+			       controller->mac);
 
 			continue;
 		}
@@ -967,8 +920,8 @@ int __init pcibios_init(void)
 						    0);
 		if (ret < 0) {
 			pr_err("PCI: MEM PIO init failure on TRIO %d mac %d, "
-				"give up\n", controller->trio_index,
-				controller->mac);
+			       "give up\n", controller->trio_index,
+			       controller->mac);
 
 			continue;
 		}
@@ -980,8 +933,8 @@ int __init pcibios_init(void)
 		ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
 		if (ret < 0) {
 			pr_err("PCI: I/O PIO alloc failure on TRIO %d mac %d, "
-				"give up\n", controller->trio_index,
-				controller->mac);
+			       "give up\n", controller->trio_index,
+			       controller->mac);
 
 			continue;
 		}
@@ -999,8 +952,8 @@ int __init pcibios_init(void)
 						    HV_TRIO_PIO_FLAG_IO_SPACE);
 		if (ret < 0) {
 			pr_err("PCI: I/O PIO init failure on TRIO %d mac %d, "
-				"give up\n", controller->trio_index,
-				controller->mac);
+			       "give up\n", controller->trio_index,
+			       controller->mac);
 
 			continue;
 		}
@@ -1020,9 +973,9 @@ int __init pcibios_init(void)
 							  0);
 			if (ret < 0) {
 				pr_err("PCI: Mem-Map alloc failure on TRIO %d "
-					"mac %d for MC %d, give up\n",
-					controller->trio_index,
-					controller->mac, j);
+				       "mac %d for MC %d, give up\n",
+				       controller->trio_index,
+				       controller->mac, j);
 
 				goto alloc_mem_map_failed;
 			}
@@ -1053,9 +1006,9 @@ int __init pcibios_init(void)
 				GXIO_TRIO_ORDER_MODE_UNORDERED);
 			if (ret < 0) {
 				pr_err("PCI: Mem-Map init failure on TRIO %d "
-					"mac %d for MC %d, give up\n",
-					controller->trio_index,
-					controller->mac, j);
+				       "mac %d for MC %d, give up\n",
+				       controller->trio_index,
+				       controller->mac, j);
 
 				goto alloc_mem_map_failed;
 			}
@@ -1064,22 +1017,18 @@ int __init pcibios_init(void)
 alloc_mem_map_failed:
 			break;
 		}
-
 	}
 
 	return 0;
 }
 subsys_initcall(pcibios_init);
 
-/* Note: to be deleted after Linux 3.6 merge. */
+/* No bus fixups needed. */
 void pcibios_fixup_bus(struct pci_bus *bus)
 {
 }
 
-/*
- * This can be called from the generic PCI layer, but doesn't need to
- * do anything.
- */
+/* Process any "pci=" kernel boot arguments. */
 char *pcibios_setup(char *str)
 {
 	if (!strcmp(str, "off")) {
@@ -1130,7 +1079,6 @@ void __iomem *ioremap(resource_size_t phys_addr, unsigned long size)
 	 * By searching phys_addr in each controller's mem_space, we can
 	 * determine the controller that should accept the PCI memory access.
 	 */
-
 	for (i = 0; i < num_rc_controllers; i++) {
 		/*
 		 * Skip controllers that are not properly initialized or
@@ -1158,9 +1106,7 @@ void __iomem *ioremap(resource_size_t phys_addr, unsigned long size)
 
 	offset = HV_TRIO_PIO_OFFSET(controller->pio_mem_index) + start;
 
-	/*
-	 * We need to keep the PCI bus address's in-page offset in the VA.
-	 */
+	/* We need to keep the PCI bus address's in-page offset in the VA. */
 	return iorpc_ioremap(trio_fd, offset, size) +
 		(start & (PAGE_SIZE - 1));
 }
@@ -1186,7 +1132,6 @@ void __iomem *ioport_map(unsigned long port, unsigned int size)
 	 * By searching the port in each controller's io_space, we can
 	 * determine the controller that should accept the PCI I/O access.
 	 */
-
 	for (i = 0; i < num_rc_controllers; i++) {
 		/*
 		 * Skip controllers that are not properly initialized or
@@ -1214,9 +1159,7 @@ void __iomem *ioport_map(unsigned long port, unsigned int size)
 
 	offset = HV_TRIO_PIO_OFFSET(controller->pio_io_index) + port;
 
-	/*
-	 * We need to keep the PCI bus address's in-page offset in the VA.
-	 */
+	/* We need to keep the PCI bus address's in-page offset in the VA. */
 	return iorpc_ioremap(trio_fd, offset, size) + (port & (PAGE_SIZE - 1));
 }
 EXPORT_SYMBOL(ioport_map);
@@ -1249,7 +1192,6 @@ EXPORT_SYMBOL(pci_iounmap);
  * offset is in bytes, from the start of config space for the
  * specified bus & device.
  */
-
 static int tile_cfg_read(struct pci_bus *bus, unsigned int devfn, int offset,
 			 int size, u32 *val)
 {
@@ -1299,7 +1241,6 @@ static int tile_cfg_read(struct pci_bus *bus, unsigned int devfn, int offset,
 	 * Accesses to the directly attached device have to be
 	 * sent as type-0 configs.
 	 */
-
 	if (busnum == (controller->first_busno + 1)) {
 		/*
 		 * There is only one device off of our built-in P2P bridge.
@@ -1321,9 +1262,8 @@ static int tile_cfg_read(struct pci_bus *bus, unsigned int devfn, int offset,
 	 * Note that we don't set the mac field in cfg_addr because the
 	 * mapping is per port.
 	 */
-
 	mmio_addr = trio_context->mmio_base_pio_cfg[controller->mac] +
-			cfg_addr.word;
+		cfg_addr.word;
 
 valid_device:
 
@@ -1427,7 +1367,6 @@ static int tile_cfg_write(struct pci_bus *bus, unsigned int devfn, int offset,
 	 * Accesses to the directly attached device have to be
 	 * sent as type-0 configs.
 	 */
-
 	if (busnum == (controller->first_busno + 1)) {
 		/*
 		 * There is only one device off of our built-in P2P bridge.
@@ -1449,7 +1388,6 @@ static int tile_cfg_write(struct pci_bus *bus, unsigned int devfn, int offset,
 	 * Note that we don't set the mac field in cfg_addr because the
 	 * mapping is per port.
 	 */
-
 	mmio_addr = trio_context->mmio_base_pio_cfg[controller->mac] +
 			cfg_addr.word;
 
@@ -1487,11 +1425,8 @@ static struct pci_ops tile_cfg_ops = {
 };
 
 
-/*
- * MSI support starts here.
- */
-static unsigned int
-tilegx_msi_startup(struct irq_data *d)
+/* MSI support starts here. */
+static unsigned int tilegx_msi_startup(struct irq_data *d)
 {
 	if (d->msi_desc)
 		unmask_msi_irq(d);
@@ -1499,21 +1434,18 @@ tilegx_msi_startup(struct irq_data *d)
 	return 0;
 }
 
-static void
-tilegx_msi_ack(struct irq_data *d)
+static void tilegx_msi_ack(struct irq_data *d)
 {
 	__insn_mtspr(SPR_IPI_EVENT_RESET_K, 1UL << d->irq);
 }
 
-static void
-tilegx_msi_mask(struct irq_data *d)
+static void tilegx_msi_mask(struct irq_data *d)
 {
 	mask_msi_irq(d);
 	__insn_mtspr(SPR_IPI_MASK_SET_K, 1UL << d->irq);
 }
 
-static void
-tilegx_msi_unmask(struct irq_data *d)
+static void tilegx_msi_unmask(struct irq_data *d)
 {
 	__insn_mtspr(SPR_IPI_MASK_RESET_K, 1UL << d->irq);
 	unmask_msi_irq(d);
-- 
1.8.3.1

