Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaIGSCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 14:02:54 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:44624 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaIGSCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 14:02:51 -0400
Date: Sun, 7 Sep 2014 20:02:47 +0200
From: Quentin Lambert <lambert.quentin@gmail.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Scott Murray <scott@spiteful.org>
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] PCI: fix a simple if coding style issue
Message-ID: <20140907180247.GA12399@greed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing curly braces in simple if cases.

Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
---
 drivers/pci/hotplug/cpci_hotplug_core.c |  4 ++--
 drivers/pci/hotplug/cpcihp_zt5550.c     | 11 +++++------
 drivers/pci/hotplug/cpqphp_core.c       |  3 +--
 drivers/pci/hotplug/cpqphp_ctrl.c       | 15 +++++----------
 drivers/pci/hotplug/cpqphp_nvram.c      | 13 +++++--------
 drivers/pci/hotplug/ibmphp_core.c       |  6 ++----
 drivers/pci/hotplug/ibmphp_ebda.c       |  3 +--
 drivers/pci/hotplug/ibmphp_hpc.c        |  3 +--
 8 files changed, 22 insertions(+), 36 deletions(-)

diff --git a/drivers/pci/hotplug/cpci_hotplug_core.c b/drivers/pci/hotplug/cpci_hotplug_core.c
index e09cf78..8359e29 100644
--- a/drivers/pci/hotplug/cpci_hotplug_core.c
+++ b/drivers/pci/hotplug/cpci_hotplug_core.c
@@ -467,9 +467,9 @@ check_slots(void)
 			    __func__, slot_name(slot), hs_csr);
 
 			if (!slot->extracting) {
-				if (update_latch_status(slot->hotplug_slot, 0)) {
+				if (update_latch_status(slot->hotplug_slot, 0))
 					warn("failure to update latch file");
-				}
+
 				slot->extracting = 1;
 				atomic_inc(&extracting);
 			}
diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
index e618020..cfd01e9 100644
--- a/drivers/pci/hotplug/cpcihp_zt5550.c
+++ b/drivers/pci/hotplug/cpcihp_zt5550.c
@@ -182,9 +182,9 @@ static int zt5550_hc_enable_irq(void)
 {
 	u8 reg;
 
-	if (hc_dev == NULL) {
+	if (hc_dev == NULL)
 		return -ENODEV;
-	}
+
 	reg = readb(csr_int_mask);
 	reg = reg & ~ENUM_INT_MASK;
 	writeb(reg, csr_int_mask);
@@ -195,9 +195,8 @@ static int zt5550_hc_disable_irq(void)
 {
 	u8 reg;
 
-	if (hc_dev == NULL) {
+	if (hc_dev == NULL)
 		return -ENODEV;
-	}
 
 	reg = readb(csr_int_mask);
 	reg = reg | ENUM_INT_MASK;
@@ -210,9 +209,9 @@ static int zt5550_hc_init_one (struct pci_dev *pdev, const struct pci_device_id
 	int status;
 
 	status = zt5550_hc_config(pdev);
-	if (status != 0) {
+	if (status != 0)
 		return status;
-	}
+
 	dbg("returned from zt5550_hc_config");
 
 	memset(&zt5550_hpc, 0, sizeof (struct cpci_hp_controller));
diff --git a/drivers/pci/hotplug/cpqphp_core.c b/drivers/pci/hotplug/cpqphp_core.c
index 4aaee74..a53084d 100644
--- a/drivers/pci/hotplug/cpqphp_core.c
+++ b/drivers/pci/hotplug/cpqphp_core.c
@@ -1096,9 +1096,8 @@ static int cpqhpc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	/* initialize our threads if they haven't already been started up */
 	rc = one_time_init();
-	if (rc) {
+	if (rc)
 		goto err_free_bus;
-	}
 
 	dbg("pdev = %p\n", pdev);
 	dbg("pci resource start %llx\n", (unsigned long long)pci_resource_start(pdev, 0));
diff --git a/drivers/pci/hotplug/cpqphp_ctrl.c b/drivers/pci/hotplug/cpqphp_ctrl.c
index 476482e..c5cbefe 100644
--- a/drivers/pci/hotplug/cpqphp_ctrl.c
+++ b/drivers/pci/hotplug/cpqphp_ctrl.c
@@ -705,9 +705,8 @@ static struct pci_resource *get_max_resource(struct pci_resource **head, u32 siz
 		if (temp == max) {
 			*head = max->next;
 		} else {
-			while (temp && temp->next != max) {
+			while (temp && temp->next != max)
 				temp = temp->next;
-			}
 
 			if (temp)
 				temp->next = max->next;
@@ -903,9 +902,8 @@ irqreturn_t cpqhp_ctrl_intr(int IRQ, void *data)
 	/*
 	 * Check to see if it was our interrupt
 	 */
-	if (!(misc & 0x000C)) {
+	if (!(misc & 0x000C))
 		return IRQ_NONE;
-	}
 
 	if (misc & 0x0004) {
 		/*
@@ -2006,9 +2004,8 @@ int cpqhp_process_SI(struct controller *ctrl, struct pci_func *func)
 	/* Check to see if the interlock is closed */
 	tempdword = readl(ctrl->hpc_reg + INT_INPUT_CLEAR);
 
-	if (tempdword & (0x01 << hp_slot)) {
+	if (tempdword & (0x01 << hp_slot))
 		return 1;
-	}
 
 	if (func->is_a_board) {
 		rc = board_replaced(func, ctrl);
@@ -2070,9 +2067,8 @@ int cpqhp_process_SI(struct controller *ctrl, struct pci_func *func)
 		}
 	}
 
-	if (rc) {
+	if (rc)
 		dbg("%s: rc = %d\n", __func__, rc);
-	}
 
 	if (p_slot)
 		update_slot_info(ctrl, p_slot);
@@ -2095,9 +2091,8 @@ int cpqhp_process_SS(struct controller *ctrl, struct pci_func *func)
 	device = func->device;
 	func = cpqhp_slot_find(ctrl->bus, device, index++);
 	p_slot = cpqhp_find_slot(ctrl, device);
-	if (p_slot) {
+	if (p_slot)
 		physical_slot = p_slot->number;
-	}
 
 	/* Make sure there are no video controllers here */
 	while (func && !rc) {
diff --git a/drivers/pci/hotplug/cpqphp_nvram.c b/drivers/pci/hotplug/cpqphp_nvram.c
index 0968a9b..1e08ff8 100644
--- a/drivers/pci/hotplug/cpqphp_nvram.c
+++ b/drivers/pci/hotplug/cpqphp_nvram.c
@@ -204,9 +204,8 @@ static int load_HRT (void __iomem *rom_start)
 	u8 temp_byte = 0xFF;
 	u32 rc;
 
-	if (!check_for_compaq_ROM(rom_start)) {
+	if (!check_for_compaq_ROM(rom_start))
 		return -ENODEV;
-	}
 
 	available = 1024;
 
@@ -250,9 +249,8 @@ static u32 store_HRT (void __iomem *rom_start)
 
 	available = 1024;
 
-	if (!check_for_compaq_ROM(rom_start)) {
+	if (!check_for_compaq_ROM(rom_start))
 		return(1);
-	}
 
 	buffer = (u32*) evbuffer;
 
@@ -427,9 +425,9 @@ static u32 store_HRT (void __iomem *rom_start)
 
 void compaq_nvram_init (void __iomem *rom_start)
 {
-	if (rom_start) {
+	if (rom_start)
 		compaq_int15_entry_point = (rom_start + ROM_INT15_PHY_ADDR - ROM_PHY_ADDR);
-	}
+
 	dbg("int15 entry  = %p\n", compaq_int15_entry_point);
 
 	/* initialize our int15 lock */
@@ -661,9 +659,8 @@ int compaq_nvram_store (void __iomem *rom_start)
 
 	if (evbuffer_init) {
 		rc = store_HRT(rom_start);
-		if (rc) {
+		if (rc)
 			err(msg_unable_to_save);
-		}
 	}
 	return rc;
 }
diff --git a/drivers/pci/hotplug/ibmphp_core.c b/drivers/pci/hotplug/ibmphp_core.c
index f7b8684..cfe2afe 100644
--- a/drivers/pci/hotplug/ibmphp_core.c
+++ b/drivers/pci/hotplug/ibmphp_core.c
@@ -1199,9 +1199,8 @@ int ibmphp_do_disable_slot(struct slot *slot_cur)
 
 	debug("DISABLING SLOT...\n");
 
-	if ((slot_cur == NULL) || (slot_cur->ctrl == NULL)) {
+	if ((slot_cur == NULL) || (slot_cur->ctrl == NULL))
 		return -ENODEV;
-	}
 
 	flag = slot_cur->flag;
 	slot_cur->flag = 1;
@@ -1355,9 +1354,8 @@ static int __init ibmphp_init(void)
 	}
 
 	ibmphp_print_test();
-	if ((rc = ibmphp_hpc_start_poll_thread())) {
+	if ((rc = ibmphp_hpc_start_poll_thread()))
 		goto error;
-	}
 
 exit:
 	return rc;
diff --git a/drivers/pci/hotplug/ibmphp_ebda.c b/drivers/pci/hotplug/ibmphp_ebda.c
index 0f65ac5..d9b197d 100644
--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -215,9 +215,8 @@ static void __init print_ebda_hpc (void)
 			debug ("%s - cap of the slot: %x\n", __func__, hpc_ptr->slots[index].slot_cap);
 		}
 
-		for (index = 0; index < hpc_ptr->bus_count; index++) {
+		for (index = 0; index < hpc_ptr->bus_count; index++)
 			debug ("%s - bus# of each bus controlled by this ctlr: %x\n", __func__, hpc_ptr->buses[index].bus_num);
-		}
 
 		debug ("%s - type of hpc: %x\n", __func__, hpc_ptr->ctlr_type);
 		switch (hpc_ptr->ctlr_type) {
diff --git a/drivers/pci/hotplug/ibmphp_hpc.c b/drivers/pci/hotplug/ibmphp_hpc.c
index a936022..2208767 100644
--- a/drivers/pci/hotplug/ibmphp_hpc.c
+++ b/drivers/pci/hotplug/ibmphp_hpc.c
@@ -997,9 +997,8 @@ static int process_changeinstatus (struct slot *pslot, struct slot *poldslot)
 		rc = ibmphp_do_disable_slot (pslot);
 	}
 
-	if (update || disable) {
+	if (update || disable)
 		ibmphp_update_slot_info (pslot);
-	}
 
 	debug ("%s - Exit rc[%d] disable[%x] update[%x]\n", __func__, rc, disable, update);
 
-- 
1.9.1

