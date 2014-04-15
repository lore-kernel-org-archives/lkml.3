Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaDOEhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:37:24 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54482 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaDOEhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:37:19 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCHv3] pci: moved EXPORT_SYMBOL so that it immediately followed its         function/variable
Date: Tue, 15 Apr 2014 00:37:06 -0400
Message-Id: <1397536626-9684-1-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve following checkpatch message:
        WARNING: EXPORT_SYMBOL(foo); should immediately follow
                its function/variable
branch: Linux 3.14

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/pci.c       | 75 ++++++++++++++++++++++++-------------------------
 drivers/pci/setup-res.c |  1 +
 2 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index fdbc294..305162b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -226,6 +226,7 @@ int pci_find_capability(struct pci_dev *dev, int cap)
 
 	return pos;
 }
+EXPORT_SYMBOL(pci_find_capability);
 
 /**
  * pci_bus_find_capability - query for devices' capabilities
@@ -253,6 +254,7 @@ int pci_bus_find_capability(struct pci_bus *bus, unsigned int devfn, int cap)
 
 	return pos;
 }
+EXPORT_SYMBOL(pci_bus_find_capability);
 
 /**
  * pci_find_next_ext_capability - Find an extended capability
@@ -429,6 +431,7 @@ pci_find_parent_resource(const struct pci_dev *dev, struct resource *res)
 	}
 	return best;
 }
+EXPORT_SYMBOL(pci_find_parent_resource);
 
 /**
  * pci_wait_for_pending - wait for @mask bit(s) to clear in status word @pos
@@ -839,6 +842,7 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 
 	return error;
 }
+EXPORT_SYMBOL(pci_set_power_state);
 
 /**
  * pci_choose_state - Choose the power state of a PCI device
@@ -877,7 +881,6 @@ pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state)
 	}
 	return PCI_D0;
 }
-
 EXPORT_SYMBOL(pci_choose_state);
 
 #define PCI_EXP_SAVE_REGS	7
@@ -1010,6 +1013,7 @@ pci_save_state(struct pci_dev *dev)
 		return i;
 	return 0;
 }
+EXPORT_SYMBOL(pci_save_state);
 
 static void pci_restore_config_dword(struct pci_dev *pdev, int offset,
 				     u32 saved_val, int retry)
@@ -1080,6 +1084,7 @@ void pci_restore_state(struct pci_dev *dev)
 
 	dev->state_saved = false;
 }
+EXPORT_SYMBOL(pci_restore_state);
 
 struct pci_saved_state {
 	u32 config_space[16];
@@ -1219,6 +1224,7 @@ int pci_reenable_device(struct pci_dev *dev)
 		return do_pci_enable_device(dev, (1 << PCI_NUM_RESOURCES) - 1);
 	return 0;
 }
+EXPORT_SYMBOL(pci_reenable_device);
 
 static void pci_enable_bridge(struct pci_dev *dev)
 {
@@ -1293,6 +1299,7 @@ int pci_enable_device_io(struct pci_dev *dev)
 {
 	return pci_enable_device_flags(dev, IORESOURCE_IO);
 }
+EXPORT_SYMBOL(pci_enable_device_io);
 
 /**
  * pci_enable_device_mem - Initialize a device for use with Memory space
@@ -1306,6 +1313,7 @@ int pci_enable_device_mem(struct pci_dev *dev)
 {
 	return pci_enable_device_flags(dev, IORESOURCE_MEM);
 }
+EXPORT_SYMBOL(pci_enable_device_mem);
 
 /**
  * pci_enable_device - Initialize device before it's used by a driver.
@@ -1322,6 +1330,7 @@ int pci_enable_device(struct pci_dev *dev)
 {
 	return pci_enable_device_flags(dev, IORESOURCE_MEM | IORESOURCE_IO);
 }
+EXPORT_SYMBOL(pci_enable_device);
 
 /*
  * Managed PCI resources.  This manages device on/off, intx/msi/msix
@@ -1404,6 +1413,7 @@ int pcim_enable_device(struct pci_dev *pdev)
 	}
 	return rc;
 }
+EXPORT_SYMBOL(pcim_enable_device);
 
 /**
  * pcim_pin_device - Pin managed PCI device
@@ -1422,6 +1432,7 @@ void pcim_pin_device(struct pci_dev *pdev)
 	if (dr)
 		dr->pinned = 1;
 }
+EXPORT_SYMBOL(pcim_pin_device);
 
 /*
  * pcibios_add_device - provide arch specific hooks when adding device dev
@@ -1511,6 +1522,7 @@ pci_disable_device(struct pci_dev *dev)
 
 	dev->is_busmaster = 0;
 }
+EXPORT_SYMBOL(pci_disable_device);
 
 /**
  * pcibios_set_pcie_reset_state - set reset state for device dev
@@ -1539,6 +1551,7 @@ int pci_set_pcie_reset_state(struct pci_dev *dev, enum pcie_reset_state state)
 {
 	return pcibios_set_pcie_reset_state(dev, state);
 }
+EXPORT_SYMBOL_GPL(pci_set_pcie_reset_state);
 
 /**
  * pci_check_pme_status - Check if given device has generated PME.
@@ -1618,6 +1631,7 @@ bool pci_pme_capable(struct pci_dev *dev, pci_power_t state)
 
 	return !!(dev->pme_support & (1 << state));
 }
+EXPORT_SYMBOL(pci_pme_capable);
 
 static void pci_pme_list_scan(struct work_struct *work)
 {
@@ -1724,6 +1738,7 @@ void pci_pme_active(struct pci_dev *dev, bool enable)
 
 	dev_dbg(&dev->dev, "PME# %s\n", enable ? "enabled" : "disabled");
 }
+EXPORT_SYMBOL(pci_pme_active);
 
 /**
  * __pci_enable_wake - enable PCI device as wakeup event source
@@ -1809,6 +1824,7 @@ int pci_wake_from_d3(struct pci_dev *dev, bool enable)
 			pci_enable_wake(dev, PCI_D3cold, enable) :
 			pci_enable_wake(dev, PCI_D3hot, enable);
 }
+EXPORT_SYMBOL(pci_wake_from_d3);
 
 /**
  * pci_target_state - find an appropriate low power state for a given PCI dev
@@ -1887,6 +1903,7 @@ int pci_prepare_to_sleep(struct pci_dev *dev)
 
 	return error;
 }
+EXPORT_SYMBOL(pci_prepare_to_sleep);
 
 /**
  * pci_back_from_sleep - turn PCI device on during system-wide transition into working state
@@ -1899,6 +1916,7 @@ int pci_back_from_sleep(struct pci_dev *dev)
 	pci_enable_wake(dev, PCI_D0, false);
 	return pci_set_power_state(dev, PCI_D0);
 }
+EXPORT_SYMBOL(pci_back_from_sleep);
 
 /**
  * pci_finish_runtime_suspend - Carry out PCI-specific part of runtime suspend.
@@ -2443,6 +2461,7 @@ void pci_release_region(struct pci_dev *pdev, int bar)
 	if (dr)
 		dr->region_mask &= ~(1 << bar);
 }
+EXPORT_SYMBOL(pci_release_region);
 
 /**
  *	__pci_request_region - Reserved PCI I/O and memory resource
@@ -2513,6 +2532,7 @@ int pci_request_region(struct pci_dev *pdev, int bar, const char *res_name)
 {
 	return __pci_request_region(pdev, bar, res_name, 0);
 }
+EXPORT_SYMBOL(pci_request_region);
 
 /**
  *	pci_request_region_exclusive - Reserved PCI I/O and memory resource
@@ -2536,6 +2556,8 @@ int pci_request_region_exclusive(struct pci_dev *pdev, int bar, const char *res_
 {
 	return __pci_request_region(pdev, bar, res_name, IORESOURCE_EXCLUSIVE);
 }
+EXPORT_SYMBOL(pci_request_region_exclusive);
+
 /**
  * pci_release_selected_regions - Release selected PCI I/O and memory resources
  * @pdev: PCI device whose resources were previously reserved
@@ -2552,6 +2574,7 @@ void pci_release_selected_regions(struct pci_dev *pdev, int bars)
 		if (bars & (1 << i))
 			pci_release_region(pdev, i);
 }
+EXPORT_SYMBOL(pci_release_selected_regions);
 
 static int __pci_request_selected_regions(struct pci_dev *pdev, int bars,
 				 const char *res_name, int excl)
@@ -2584,6 +2607,7 @@ int pci_request_selected_regions(struct pci_dev *pdev, int bars,
 {
 	return __pci_request_selected_regions(pdev, bars, res_name, 0);
 }
+EXPORT_SYMBOL(pci_request_selected_regions);
 
 int pci_request_selected_regions_exclusive(struct pci_dev *pdev,
 				 int bars, const char *res_name)
@@ -2591,6 +2615,7 @@ int pci_request_selected_regions_exclusive(struct pci_dev *pdev,
 	return __pci_request_selected_regions(pdev, bars, res_name,
 			IORESOURCE_EXCLUSIVE);
 }
+EXPORT_SYMBOL(pci_request_selected_regions_exclusive);
 
 /**
  *	pci_release_regions - Release reserved PCI I/O and memory resources
@@ -2605,6 +2630,7 @@ void pci_release_regions(struct pci_dev *pdev)
 {
 	pci_release_selected_regions(pdev, (1 << 6) - 1);
 }
+EXPORT_SYMBOL(pci_release_regions);
 
 /**
  *	pci_request_regions - Reserved PCI I/O and memory resources
@@ -2623,6 +2649,7 @@ int pci_request_regions(struct pci_dev *pdev, const char *res_name)
 {
 	return pci_request_selected_regions(pdev, ((1 << 6) - 1), res_name);
 }
+EXPORT_SYMBOL(pci_request_regions);
 
 /**
  *	pci_request_regions_exclusive - Reserved PCI I/O and memory resources
@@ -2645,6 +2672,7 @@ int pci_request_regions_exclusive(struct pci_dev *pdev, const char *res_name)
 	return pci_request_selected_regions_exclusive(pdev,
 					((1 << 6) - 1), res_name);
 }
+EXPORT_SYMBOL(pci_request_regions_exclusive);
 
 static void __pci_set_master(struct pci_dev *dev, bool enable)
 {
@@ -2714,6 +2742,7 @@ void pci_set_master(struct pci_dev *dev)
 	__pci_set_master(dev, true);
 	pcibios_set_master(dev);
 }
+EXPORT_SYMBOL(pci_set_master);
 
 /**
  * pci_clear_master - disables bus-mastering for device dev
@@ -2723,6 +2752,7 @@ void pci_clear_master(struct pci_dev *dev)
 {
 	__pci_set_master(dev, false);
 }
+EXPORT_SYMBOL(pci_clear_master);
 
 /**
  * pci_set_cacheline_size - ensure the CACHE_LINE_SIZE register is programmed
@@ -2767,6 +2797,7 @@ int pci_set_mwi(struct pci_dev *dev)
 {
 	return 0;
 }
+EXPORT_SYMBOL(pci_set_mwi);
 
 int pci_try_set_mwi(struct pci_dev *dev)
 {
@@ -2821,6 +2852,7 @@ int pci_try_set_mwi(struct pci_dev *dev)
 	int rc = pci_set_mwi(dev);
 	return rc;
 }
+EXPORT_SYMBOL(pci_try_set_mwi);
 
 /**
  * pci_clear_mwi - disables Memory-Write-Invalidate for device dev
@@ -2839,6 +2871,7 @@ pci_clear_mwi(struct pci_dev *dev)
 		pci_write_config_word(dev, PCI_COMMAND, cmd);
 	}
 }
+EXPORT_SYMBOL(pci_clear_mwi);
 #endif /* ! PCI_DISABLE_MWI */
 
 /**
@@ -2873,6 +2906,7 @@ pci_intx(struct pci_dev *pdev, int enable)
 		}
 	}
 }
+EXPORT_SYMBOL_GPL(pci_intx);
 
 /**
  * pci_intx_mask_supported - probe for INTx masking support
@@ -4038,6 +4072,7 @@ int pci_select_bars(struct pci_dev *dev, unsigned long flags)
 			bars |= (1 << i);
 	return bars;
 }
+EXPORT_SYMBOL(pci_select_bars);
 
 /**
  * pci_resource_bar - get position of the BAR associated with a resource
@@ -4388,41 +4423,3 @@ static int __init pci_setup(char *str)
 	return 0;
 }
 early_param("pci", pci_setup);
-
-EXPORT_SYMBOL(pci_reenable_device);
-EXPORT_SYMBOL(pci_enable_device_io);
-EXPORT_SYMBOL(pci_enable_device_mem);
-EXPORT_SYMBOL(pci_enable_device);
-EXPORT_SYMBOL(pcim_enable_device);
-EXPORT_SYMBOL(pcim_pin_device);
-EXPORT_SYMBOL(pci_disable_device);
-EXPORT_SYMBOL(pci_find_capability);
-EXPORT_SYMBOL(pci_bus_find_capability);
-EXPORT_SYMBOL(pci_release_regions);
-EXPORT_SYMBOL(pci_request_regions);
-EXPORT_SYMBOL(pci_request_regions_exclusive);
-EXPORT_SYMBOL(pci_release_region);
-EXPORT_SYMBOL(pci_request_region);
-EXPORT_SYMBOL(pci_request_region_exclusive);
-EXPORT_SYMBOL(pci_release_selected_regions);
-EXPORT_SYMBOL(pci_request_selected_regions);
-EXPORT_SYMBOL(pci_request_selected_regions_exclusive);
-EXPORT_SYMBOL(pci_set_master);
-EXPORT_SYMBOL(pci_clear_master);
-EXPORT_SYMBOL(pci_set_mwi);
-EXPORT_SYMBOL(pci_try_set_mwi);
-EXPORT_SYMBOL(pci_clear_mwi);
-EXPORT_SYMBOL_GPL(pci_intx);
-EXPORT_SYMBOL(pci_assign_resource);
-EXPORT_SYMBOL(pci_find_parent_resource);
-EXPORT_SYMBOL(pci_select_bars);
-
-EXPORT_SYMBOL(pci_set_power_state);
-EXPORT_SYMBOL(pci_save_state);
-EXPORT_SYMBOL(pci_restore_state);
-EXPORT_SYMBOL(pci_pme_capable);
-EXPORT_SYMBOL(pci_pme_active);
-EXPORT_SYMBOL(pci_wake_from_d3);
-EXPORT_SYMBOL(pci_prepare_to_sleep);
-EXPORT_SYMBOL(pci_back_from_sleep);
-EXPORT_SYMBOL_GPL(pci_set_pcie_reset_state);
diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index 5c060b1..4fd92c7 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -289,6 +289,7 @@ int pci_assign_resource(struct pci_dev *dev, int resno)
 	}
 	return ret;
 }
+EXPORT_SYMBOL(pci_assign_resource);
 
 int pci_reassign_resource(struct pci_dev *dev, int resno, resource_size_t addsize,
 			resource_size_t min_align)
-- 
1.9.1

