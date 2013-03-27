Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3C0O7X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:59:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:29553 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793Ab3C0O7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:59:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,919,1355126400"; 
   d="scan'208";a="276679477"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 4/5] mei: prefix me hardware specific functions with mei_me_
Date: Wed, 27 Mar 2013 16:58:29 +0200
Message-Id: <1364396310-10718-5-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
References: <1364396310-10718-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/hw-me.c  | 36 ++++++++++++++++++------------------
 drivers/misc/mei/pci-me.c | 36 ++++++++++++++++++------------------
 2 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 12c2fa1..5ad53eb 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -26,14 +26,14 @@
 
 
 /**
- * mei_reg_read - Reads 32bit data from the mei device
+ * mei_me_reg_read - Reads 32bit data from the mei device
  *
  * @dev: the device structure
  * @offset: offset from which to read the data
  *
  * returns register value (u32)
  */
-static inline u32 mei_reg_read(const struct mei_me_hw *hw,
+static inline u32 mei_me_reg_read(const struct mei_me_hw *hw,
 			       unsigned long offset)
 {
 	return ioread32(hw->mem_addr + offset);
@@ -41,20 +41,20 @@ static inline u32 mei_reg_read(const struct mei_me_hw *hw,
 
 
 /**
- * mei_reg_write - Writes 32bit data to the mei device
+ * mei_me_reg_write - Writes 32bit data to the mei device
  *
  * @dev: the device structure
  * @offset: offset from which to write the data
  * @value: register value to write (u32)
  */
-static inline void mei_reg_write(const struct mei_me_hw *hw,
+static inline void mei_me_reg_write(const struct mei_me_hw *hw,
 				 unsigned long offset, u32 value)
 {
 	iowrite32(value, hw->mem_addr + offset);
 }
 
 /**
- * mei_mecbrw_read - Reads 32bit data from ME circular buffer
+ * mei_me_mecbrw_read - Reads 32bit data from ME circular buffer
  *  read window register
  *
  * @dev: the device structure
@@ -63,18 +63,18 @@ static inline void mei_reg_write(const struct mei_me_hw *hw,
  */
 static u32 mei_me_mecbrw_read(const struct mei_device *dev)
 {
-	return mei_reg_read(to_me_hw(dev), ME_CB_RW);
+	return mei_me_reg_read(to_me_hw(dev), ME_CB_RW);
 }
 /**
- * mei_mecsr_read - Reads 32bit data from the ME CSR
+ * mei_me_mecsr_read - Reads 32bit data from the ME CSR
  *
  * @dev: the device structure
  *
  * returns ME_CSR_HA register value (u32)
  */
-static inline u32 mei_mecsr_read(const struct mei_me_hw *hw)
+static inline u32 mei_me_mecsr_read(const struct mei_me_hw *hw)
 {
-	return mei_reg_read(hw, ME_CSR_HA);
+	return mei_me_reg_read(hw, ME_CSR_HA);
 }
 
 /**
@@ -86,7 +86,7 @@ static inline u32 mei_mecsr_read(const struct mei_me_hw *hw)
  */
 static inline u32 mei_hcsr_read(const struct mei_me_hw *hw)
 {
-	return mei_reg_read(hw, H_CSR);
+	return mei_me_reg_read(hw, H_CSR);
 }
 
 /**
@@ -98,7 +98,7 @@ static inline u32 mei_hcsr_read(const struct mei_me_hw *hw)
 static inline void mei_hcsr_set(struct mei_me_hw *hw, u32 hcsr)
 {
 	hcsr &= ~H_IS;
-	mei_reg_write(hw, H_CSR, hcsr);
+	mei_me_reg_write(hw, H_CSR, hcsr);
 }
 
 
@@ -123,7 +123,7 @@ static void mei_me_intr_clear(struct mei_device *dev)
 	struct mei_me_hw *hw = to_me_hw(dev);
 	u32 hcsr = mei_hcsr_read(hw);
 	if ((hcsr & H_IS) == H_IS)
-		mei_reg_write(hw, H_CSR, hcsr);
+		mei_me_reg_write(hw, H_CSR, hcsr);
 }
 /**
  * mei_me_intr_enable - enables mei device interrupts
@@ -228,7 +228,7 @@ static bool mei_me_host_is_ready(struct mei_device *dev)
 static bool mei_me_hw_is_ready(struct mei_device *dev)
 {
 	struct mei_me_hw *hw = to_me_hw(dev);
-	hw->me_hw_state = mei_mecsr_read(hw);
+	hw->me_hw_state = mei_me_mecsr_read(hw);
 	return (hw->me_hw_state & ME_RDY_HRA) == ME_RDY_HRA;
 }
 
@@ -354,16 +354,16 @@ static int mei_me_write_message(struct mei_device *dev,
 	if (empty_slots < 0 || dw_cnt > empty_slots)
 		return -EIO;
 
-	mei_reg_write(hw, H_CB_WW, *((u32 *) header));
+	mei_me_reg_write(hw, H_CB_WW, *((u32 *) header));
 
 	for (i = 0; i < length / 4; i++)
-		mei_reg_write(hw, H_CB_WW, reg_buf[i]);
+		mei_me_reg_write(hw, H_CB_WW, reg_buf[i]);
 
 	rem = length & 0x3;
 	if (rem > 0) {
 		u32 reg = 0;
 		memcpy(&reg, &buf[length - rem], rem);
-		mei_reg_write(hw, H_CB_WW, reg);
+		mei_me_reg_write(hw, H_CB_WW, reg);
 	}
 
 	hcsr = mei_hcsr_read(hw) | H_IG;
@@ -387,7 +387,7 @@ static int mei_me_count_full_read_slots(struct mei_device *dev)
 	char read_ptr, write_ptr;
 	unsigned char buffer_depth, filled_slots;
 
-	hw->me_hw_state = mei_mecsr_read(hw);
+	hw->me_hw_state = mei_me_mecsr_read(hw);
 	buffer_depth = (unsigned char)((hw->me_hw_state & ME_CBD_HRA) >> 24);
 	read_ptr = (char) ((hw->me_hw_state & ME_CBRP_HRA) >> 8);
 	write_ptr = (char) ((hw->me_hw_state & ME_CBWP_HRA) >> 16);
@@ -447,7 +447,7 @@ irqreturn_t mei_me_irq_quick_handler(int irq, void *dev_id)
 		return IRQ_NONE;
 
 	/* clear H_IS bit in H_CSR */
-	mei_reg_write(hw, H_CSR, csr_reg);
+	mei_me_reg_write(hw, H_CSR, csr_reg);
 
 	return IRQ_WAKE_THREAD;
 }
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 985afd0..178928e 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -47,7 +47,7 @@
 static struct pci_dev *mei_pdev;
 
 /* mei_pci_tbl - PCI Device ID Table */
-static DEFINE_PCI_DEVICE_TABLE(mei_pci_tbl) = {
+static DEFINE_PCI_DEVICE_TABLE(mei_me_pci_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82946GZ)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G35)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82Q965)},
@@ -86,7 +86,7 @@ static DEFINE_PCI_DEVICE_TABLE(mei_pci_tbl) = {
 	{0, }
 };
 
-MODULE_DEVICE_TABLE(pci, mei_pci_tbl);
+MODULE_DEVICE_TABLE(pci, mei_me_pci_tbl);
 
 static DEFINE_MUTEX(mei_mutex);
 
@@ -97,7 +97,7 @@ static DEFINE_MUTEX(mei_mutex);
  *
  * returns true if ME Interface is valid, false otherwise
  */
-static bool mei_quirk_probe(struct pci_dev *pdev,
+static bool mei_me_quirk_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
 	u32 reg;
@@ -119,7 +119,7 @@ static bool mei_quirk_probe(struct pci_dev *pdev,
  *
  * returns 0 on success, <0 on failure.
  */
-static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int mei_me_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct mei_device *dev;
 	struct mei_me_hw *hw;
@@ -127,7 +127,7 @@ static int mei_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	mutex_lock(&mei_mutex);
 
-	if (!mei_quirk_probe(pdev, ent)) {
+	if (!mei_me_quirk_probe(pdev, ent)) {
 		err = -ENODEV;
 		goto end;
 	}
@@ -233,7 +233,7 @@ end:
  * mei_remove is called by the PCI subsystem to alert the driver
  * that it should release a PCI device.
  */
-static void mei_remove(struct pci_dev *pdev)
+static void mei_me_remove(struct pci_dev *pdev)
 {
 	struct mei_device *dev;
 	struct mei_me_hw *hw;
@@ -272,7 +272,7 @@ static void mei_remove(struct pci_dev *pdev)
 
 }
 #ifdef CONFIG_PM
-static int mei_pci_suspend(struct device *device)
+static int mei_me_pci_suspend(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct mei_device *dev = pci_get_drvdata(pdev);
@@ -292,7 +292,7 @@ static int mei_pci_suspend(struct device *device)
 	return 0;
 }
 
-static int mei_pci_resume(struct device *device)
+static int mei_me_pci_resume(struct device *device)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct mei_device *dev;
@@ -332,24 +332,24 @@ static int mei_pci_resume(struct device *device)
 
 	return err;
 }
-static SIMPLE_DEV_PM_OPS(mei_pm_ops, mei_pci_suspend, mei_pci_resume);
-#define MEI_PM_OPS	(&mei_pm_ops)
+static SIMPLE_DEV_PM_OPS(mei_me_pm_ops, mei_me_pci_suspend, mei_me_pci_resume);
+#define MEI_ME_PM_OPS	(&mei_me_pm_ops)
 #else
-#define MEI_PM_OPS	NULL
+#define MEI_ME_PM_OPS	NULL
 #endif /* CONFIG_PM */
 /*
  *  PCI driver structure
  */
-static struct pci_driver mei_driver = {
+static struct pci_driver mei_me_driver = {
 	.name = KBUILD_MODNAME,
-	.id_table = mei_pci_tbl,
-	.probe = mei_probe,
-	.remove = mei_remove,
-	.shutdown = mei_remove,
-	.driver.pm = MEI_PM_OPS,
+	.id_table = mei_me_pci_tbl,
+	.probe = mei_me_probe,
+	.remove = mei_me_remove,
+	.shutdown = mei_me_remove,
+	.driver.pm = MEI_ME_PM_OPS,
 };
 
-module_pci_driver(mei_driver);
+module_pci_driver(mei_me_driver);
 
 MODULE_AUTHOR("Intel Corporation");
 MODULE_DESCRIPTION("Intel(R) Management Engine Interface");
-- 
1.7.11.7

