Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217Ab3KMXOv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:14:51 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64750 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751563Ab3KMXOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:14:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH 1/2] ACPI: Eliminate the DEVICE_ACPI_HANDLE() macro
Date: Thu, 14 Nov 2013 00:26 +0100
Message-ID: <5216191.8B6uiYXXe4@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1803808.ghCmmaO2Cj@vostro.rjw.lan>
References: <3268437.YsusHvklcv@vostro.rjw.lan> <1803808.ghCmmaO2Cj@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since DEVICE_ACPI_HANDLE() is now literally identical to
ACPI_HANDLE(), replace it with the latter everywhere and drop its
definition from include/acpi.h.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c                       |    8 ++++----
 drivers/gpu/drm/i915/intel_acpi.c              |    2 +-
 drivers/gpu/drm/i915/intel_opregion.c          |    2 +-
 drivers/gpu/drm/nouveau/core/subdev/mxm/base.c |    2 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c         |    6 +++---
 drivers/gpu/drm/radeon/radeon_acpi.c           |    8 ++++----
 drivers/gpu/drm/radeon/radeon_atpx_handler.c   |    4 ++--
 drivers/gpu/drm/radeon/radeon_bios.c           |    2 +-
 drivers/ide/ide-acpi.c                         |    2 +-
 drivers/pci/hotplug/acpi_pcihp.c               |    2 +-
 drivers/pci/hotplug/pciehp_acpi.c              |    4 ++--
 drivers/pci/ioapic.c                           |    2 +-
 drivers/pci/pci-acpi.c                         |    6 +++---
 drivers/pci/pci-label.c                        |    6 +++---
 drivers/platform/x86/apple-gmux.c              |    2 +-
 drivers/pnp/pnpacpi/core.c                     |   10 +++++-----
 drivers/usb/core/hub.c                         |    2 +-
 drivers/usb/core/usb-acpi.c                    |    4 ++--
 drivers/xen/pci.c                              |    6 +++---
 include/linux/acpi.h                           |    2 --
 include/linux/pci-acpi.h                       |    4 ++--
 21 files changed, 42 insertions(+), 44 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -544,7 +544,7 @@ static int acpi_dev_pm_get_state(struct
  */
 int acpi_pm_device_sleep_state(struct device *dev, int *d_min_p, int d_max_in)
 {
-	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
+	acpi_handle handle = ACPI_HANDLE(dev);
 	struct acpi_device *adev;
 	int ret, d_min, d_max;
 
@@ -652,7 +652,7 @@ int acpi_pm_device_run_wake(struct devic
 	if (!device_run_wake(phys_dev))
 		return -EINVAL;
 
-	handle = DEVICE_ACPI_HANDLE(phys_dev);
+	handle = ACPI_HANDLE(phys_dev);
 	if (!handle || acpi_bus_get_device(handle, &adev)) {
 		dev_dbg(phys_dev, "ACPI handle without context in %s!\n",
 			__func__);
@@ -696,7 +696,7 @@ int acpi_pm_device_sleep_wake(struct dev
 	if (!device_can_wakeup(dev))
 		return -EINVAL;
 
-	handle = DEVICE_ACPI_HANDLE(dev);
+	handle = ACPI_HANDLE(dev);
 	if (!handle || acpi_bus_get_device(handle, &adev)) {
 		dev_dbg(dev, "ACPI handle without context in %s!\n", __func__);
 		return -ENODEV;
@@ -718,7 +718,7 @@ int acpi_pm_device_sleep_wake(struct dev
  */
 struct acpi_device *acpi_dev_pm_get_node(struct device *dev)
 {
-	acpi_handle handle = DEVICE_ACPI_HANDLE(dev);
+	acpi_handle handle = ACPI_HANDLE(dev);
 	struct acpi_device *adev;
 
 	return handle && !acpi_bus_get_device(handle, &adev) ? adev : NULL;
Index: linux-pm/drivers/gpu/drm/i915/intel_acpi.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/i915/intel_acpi.c
+++ linux-pm/drivers/gpu/drm/i915/intel_acpi.c
@@ -196,7 +196,7 @@ static bool intel_dsm_pci_probe(struct p
 	acpi_handle dhandle;
 	int ret;
 
-	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
+	dhandle = ACPI_HANDLE(&pdev->dev);
 	if (!dhandle)
 		return false;
 
Index: linux-pm/drivers/gpu/drm/i915/intel_opregion.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/i915/intel_opregion.c
+++ linux-pm/drivers/gpu/drm/i915/intel_opregion.c
@@ -289,7 +289,7 @@ static void intel_didl_outputs(struct dr
 	u32 temp;
 	int i = 0;
 
-	handle = DEVICE_ACPI_HANDLE(&dev->pdev->dev);
+	handle = ACPI_HANDLE(&dev->pdev->dev);
 	if (!handle || acpi_bus_get_device(handle, &acpi_dev))
 		return;
 
Index: linux-pm/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
+++ linux-pm/drivers/gpu/drm/nouveau/core/subdev/mxm/base.c
@@ -116,7 +116,7 @@ mxm_shadow_dsm(struct nouveau_mxm *mxm,
 	acpi_handle handle;
 	int ret;
 
-	handle = DEVICE_ACPI_HANDLE(&device->pdev->dev);
+	handle = ACPI_HANDLE(&device->pdev->dev);
 	if (!handle)
 		return false;
 
Index: linux-pm/drivers/gpu/drm/nouveau/nouveau_acpi.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/nouveau/nouveau_acpi.c
+++ linux-pm/drivers/gpu/drm/nouveau/nouveau_acpi.c
@@ -256,7 +256,7 @@ static int nouveau_dsm_pci_probe(struct
 	acpi_handle dhandle;
 	int retval = 0;
 
-	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
+	dhandle = ACPI_HANDLE(&pdev->dev);
 	if (!dhandle)
 		return false;
 
@@ -404,7 +404,7 @@ bool nouveau_acpi_rom_supported(struct p
 	if (!nouveau_dsm_priv.dsm_detected && !nouveau_dsm_priv.optimus_detected)
 		return false;
 
-	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
+	dhandle = ACPI_HANDLE(&pdev->dev);
 	if (!dhandle)
 		return false;
 
@@ -438,7 +438,7 @@ nouveau_acpi_edid(struct drm_device *dev
 		return NULL;
 	}
 
-	handle = DEVICE_ACPI_HANDLE(&dev->pdev->dev);
+	handle = ACPI_HANDLE(&dev->pdev->dev);
 	if (!handle)
 		return NULL;
 
Index: linux-pm/drivers/gpu/drm/radeon/radeon_acpi.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/radeon/radeon_acpi.c
+++ linux-pm/drivers/gpu/drm/radeon/radeon_acpi.c
@@ -369,7 +369,7 @@ int radeon_atif_handler(struct radeon_de
 		return NOTIFY_DONE;
 
 	/* Check pending SBIOS requests */
-	handle = DEVICE_ACPI_HANDLE(&rdev->pdev->dev);
+	handle = ACPI_HANDLE(&rdev->pdev->dev);
 	count = radeon_atif_get_sbios_requests(handle, &req);
 
 	if (count <= 0)
@@ -556,7 +556,7 @@ int radeon_acpi_pcie_notify_device_ready
 	struct radeon_atcs *atcs = &rdev->atcs;
 
 	/* Get the device handle */
-	handle = DEVICE_ACPI_HANDLE(&rdev->pdev->dev);
+	handle = ACPI_HANDLE(&rdev->pdev->dev);
 	if (!handle)
 		return -EINVAL;
 
@@ -596,7 +596,7 @@ int radeon_acpi_pcie_performance_request
 	u32 retry = 3;
 
 	/* Get the device handle */
-	handle = DEVICE_ACPI_HANDLE(&rdev->pdev->dev);
+	handle = ACPI_HANDLE(&rdev->pdev->dev);
 	if (!handle)
 		return -EINVAL;
 
@@ -699,7 +699,7 @@ int radeon_acpi_init(struct radeon_devic
 	int ret;
 
 	/* Get the device handle */
-	handle = DEVICE_ACPI_HANDLE(&rdev->pdev->dev);
+	handle = ACPI_HANDLE(&rdev->pdev->dev);
 
 	/* No need to proceed if we're sure that ATIF is not supported */
 	if (!ASIC_IS_AVIVO(rdev) || !rdev->bios || !handle)
Index: linux-pm/drivers/gpu/drm/radeon/radeon_atpx_handler.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ linux-pm/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -442,7 +442,7 @@ static bool radeon_atpx_pci_probe_handle
 	acpi_handle dhandle, atpx_handle;
 	acpi_status status;
 
-	dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
+	dhandle = ACPI_HANDLE(&pdev->dev);
 	if (!dhandle)
 		return false;
 
@@ -488,7 +488,7 @@ static int radeon_atpx_init(void)
  */
 static int radeon_atpx_get_client_id(struct pci_dev *pdev)
 {
-	if (radeon_atpx_priv.dhandle == DEVICE_ACPI_HANDLE(&pdev->dev))
+	if (radeon_atpx_priv.dhandle == ACPI_HANDLE(&pdev->dev))
 		return VGA_SWITCHEROO_IGD;
 	else
 		return VGA_SWITCHEROO_DIS;
Index: linux-pm/drivers/gpu/drm/radeon/radeon_bios.c
===================================================================
--- linux-pm.orig/drivers/gpu/drm/radeon/radeon_bios.c
+++ linux-pm/drivers/gpu/drm/radeon/radeon_bios.c
@@ -185,7 +185,7 @@ static bool radeon_atrm_get_bios(struct
 		return false;
 
 	while ((pdev = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, pdev)) != NULL) {
-		dhandle = DEVICE_ACPI_HANDLE(&pdev->dev);
+		dhandle = ACPI_HANDLE(&pdev->dev);
 		if (!dhandle)
 			continue;
 
Index: linux-pm/drivers/ide/ide-acpi.c
===================================================================
--- linux-pm.orig/drivers/ide/ide-acpi.c
+++ linux-pm/drivers/ide/ide-acpi.c
@@ -127,7 +127,7 @@ static int ide_get_dev_handle(struct dev
 
 	DEBPRINT("ENTER: pci %02x:%02x.%01x\n", bus, devnum, func);
 
-	dev_handle = DEVICE_ACPI_HANDLE(dev);
+	dev_handle = ACPI_HANDLE(dev);
 	if (!dev_handle) {
 		DEBPRINT("no acpi handle for device\n");
 		goto err;
Index: linux-pm/drivers/pci/hotplug/acpi_pcihp.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpi_pcihp.c
+++ linux-pm/drivers/pci/hotplug/acpi_pcihp.c
@@ -367,7 +367,7 @@ int acpi_get_hp_hw_control_from_firmware
 		string = (struct acpi_buffer){ ACPI_ALLOCATE_BUFFER, NULL };
 	}
 
-	handle = DEVICE_ACPI_HANDLE(&pdev->dev);
+	handle = ACPI_HANDLE(&pdev->dev);
 	if (!handle) {
 		/*
 		 * This hotplug controller was not listed in the ACPI name
Index: linux-pm/drivers/pci/hotplug/pciehp_acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/pciehp_acpi.c
+++ linux-pm/drivers/pci/hotplug/pciehp_acpi.c
@@ -54,7 +54,7 @@ int pciehp_acpi_slot_detection_check(str
 {
 	if (slot_detection_mode != PCIEHP_DETECT_ACPI)
 		return 0;
-	if (acpi_pci_detect_ejectable(DEVICE_ACPI_HANDLE(&dev->dev)))
+	if (acpi_pci_detect_ejectable(ACPI_HANDLE(&dev->dev)))
 		return 0;
 	return -ENODEV;
 }
@@ -96,7 +96,7 @@ static int __init dummy_probe(struct pci
 			dup_slot_id++;
 	}
 	list_add_tail(&slot->list, &dummy_slots);
-	handle = DEVICE_ACPI_HANDLE(&pdev->dev);
+	handle = ACPI_HANDLE(&pdev->dev);
 	if (!acpi_slot_detected && acpi_pci_detect_ejectable(handle))
 		acpi_slot_detected = 1;
 	return -ENODEV;         /* dummy driver always returns error */
Index: linux-pm/drivers/pci/ioapic.c
===================================================================
--- linux-pm.orig/drivers/pci/ioapic.c
+++ linux-pm/drivers/pci/ioapic.c
@@ -37,7 +37,7 @@ static int ioapic_probe(struct pci_dev *
 	char *type;
 	struct resource *res;
 
-	handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	handle = ACPI_HANDLE(&dev->dev);
 	if (!handle)
 		return -EINVAL;
 
Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -173,14 +173,14 @@ static pci_power_t acpi_pci_choose_state
 
 static bool acpi_pci_power_manageable(struct pci_dev *dev)
 {
-	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	acpi_handle handle = ACPI_HANDLE(&dev->dev);
 
 	return handle ? acpi_bus_power_manageable(handle) : false;
 }
 
 static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
-	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	acpi_handle handle = ACPI_HANDLE(&dev->dev);
 	static const u8 state_conv[] = {
 		[PCI_D0] = ACPI_STATE_D0,
 		[PCI_D1] = ACPI_STATE_D1,
@@ -217,7 +217,7 @@ static int acpi_pci_set_power_state(stru
 
 static bool acpi_pci_can_wakeup(struct pci_dev *dev)
 {
-	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	acpi_handle handle = ACPI_HANDLE(&dev->dev);
 
 	return handle ? acpi_bus_can_wakeup(handle) : false;
 }
Index: linux-pm/drivers/pci/pci-label.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-label.c
+++ linux-pm/drivers/pci/pci-label.c
@@ -263,7 +263,7 @@ device_has_dsm(struct device *dev)
 	acpi_handle handle;
 	struct acpi_buffer output = {ACPI_ALLOCATE_BUFFER, NULL};
 
-	handle = DEVICE_ACPI_HANDLE(dev);
+	handle = ACPI_HANDLE(dev);
 
 	if (!handle)
 		return FALSE;
@@ -295,7 +295,7 @@ acpilabel_show(struct device *dev, struc
 	acpi_handle handle;
 	int length;
 
-	handle = DEVICE_ACPI_HANDLE(dev);
+	handle = ACPI_HANDLE(dev);
 
 	if (!handle)
 		return -1;
@@ -316,7 +316,7 @@ acpiindex_show(struct device *dev, struc
 	acpi_handle handle;
 	int length;
 
-	handle = DEVICE_ACPI_HANDLE(dev);
+	handle = ACPI_HANDLE(dev);
 
 	if (!handle)
 		return -1;
Index: linux-pm/drivers/platform/x86/apple-gmux.c
===================================================================
--- linux-pm.orig/drivers/platform/x86/apple-gmux.c
+++ linux-pm/drivers/platform/x86/apple-gmux.c
@@ -519,7 +519,7 @@ static int gmux_probe(struct pnp_dev *pn
 
 	gmux_data->power_state = VGA_SWITCHEROO_ON;
 
-	gmux_data->dhandle = DEVICE_ACPI_HANDLE(&pnp->dev);
+	gmux_data->dhandle = ACPI_HANDLE(&pnp->dev);
 	if (!gmux_data->dhandle) {
 		pr_err("Cannot find acpi handle for pnp device %s\n",
 		       dev_name(&pnp->dev));
Index: linux-pm/drivers/pnp/pnpacpi/core.c
===================================================================
--- linux-pm.orig/drivers/pnp/pnpacpi/core.c
+++ linux-pm/drivers/pnp/pnpacpi/core.c
@@ -89,7 +89,7 @@ static int pnpacpi_set_resources(struct
 
 	pnp_dbg(&dev->dev, "set resources\n");
 
-	handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	handle = ACPI_HANDLE(&dev->dev);
 	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
 		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
 		return -ENODEV;
@@ -122,7 +122,7 @@ static int pnpacpi_disable_resources(str
 
 	dev_dbg(&dev->dev, "disable resources\n");
 
-	handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	handle = ACPI_HANDLE(&dev->dev);
 	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
 		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
 		return 0;
@@ -144,7 +144,7 @@ static bool pnpacpi_can_wakeup(struct pn
 	struct acpi_device *acpi_dev;
 	acpi_handle handle;
 
-	handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	handle = ACPI_HANDLE(&dev->dev);
 	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
 		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
 		return false;
@@ -159,7 +159,7 @@ static int pnpacpi_suspend(struct pnp_de
 	acpi_handle handle;
 	int error = 0;
 
-	handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	handle = ACPI_HANDLE(&dev->dev);
 	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
 		dev_dbg(&dev->dev, "ACPI device not found in %s!\n", __func__);
 		return 0;
@@ -194,7 +194,7 @@ static int pnpacpi_suspend(struct pnp_de
 static int pnpacpi_resume(struct pnp_dev *dev)
 {
 	struct acpi_device *acpi_dev;
-	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
+	acpi_handle handle = ACPI_HANDLE(&dev->dev);
 	int error = 0;
 
 	if (!handle || acpi_bus_get_device(handle, &acpi_dev)) {
Index: linux-pm/drivers/usb/core/hub.c
===================================================================
--- linux-pm.orig/drivers/usb/core/hub.c
+++ linux-pm/drivers/usb/core/hub.c
@@ -5461,6 +5461,6 @@ acpi_handle usb_get_hub_port_acpi_handle
 	if (!hub)
 		return NULL;
 
-	return DEVICE_ACPI_HANDLE(&hub->ports[port1 - 1]->dev);
+	return ACPI_HANDLE(&hub->ports[port1 - 1]->dev);
 }
 #endif
Index: linux-pm/drivers/usb/core/usb-acpi.c
===================================================================
--- linux-pm.orig/drivers/usb/core/usb-acpi.c
+++ linux-pm/drivers/usb/core/usb-acpi.c
@@ -173,7 +173,7 @@ static int usb_acpi_find_device(struct d
 		}
 
 		/* root hub's parent is the usb hcd. */
-		parent_handle = DEVICE_ACPI_HANDLE(dev->parent);
+		parent_handle = ACPI_HANDLE(dev->parent);
 		*handle = acpi_get_child(parent_handle, udev->portnum);
 		if (!*handle)
 			return -ENODEV;
@@ -194,7 +194,7 @@ static int usb_acpi_find_device(struct d
 
 			raw_port_num = usb_hcd_find_raw_port_number(hcd,
 				port_num);
-			*handle = acpi_get_child(DEVICE_ACPI_HANDLE(&udev->dev),
+			*handle = acpi_get_child(ACPI_HANDLE(&udev->dev),
 				raw_port_num);
 			if (!*handle)
 				return -ENODEV;
Index: linux-pm/drivers/xen/pci.c
===================================================================
--- linux-pm.orig/drivers/xen/pci.c
+++ linux-pm/drivers/xen/pci.c
@@ -58,12 +58,12 @@ static int xen_add_device(struct device
 			add.flags = XEN_PCI_DEV_EXTFN;
 
 #ifdef CONFIG_ACPI
-		handle = DEVICE_ACPI_HANDLE(&pci_dev->dev);
+		handle = ACPI_HANDLE(&pci_dev->dev);
 		if (!handle && pci_dev->bus->bridge)
-			handle = DEVICE_ACPI_HANDLE(pci_dev->bus->bridge);
+			handle = ACPI_HANDLE(pci_dev->bus->bridge);
 #ifdef CONFIG_PCI_IOV
 		if (!handle && pci_dev->is_virtfn)
-			handle = DEVICE_ACPI_HANDLE(physfn->bus->bridge);
+			handle = ACPI_HANDLE(physfn->bus->bridge);
 #endif
 		if (handle) {
 			acpi_status status;
Index: linux-pm/include/linux/acpi.h
===================================================================
--- linux-pm.orig/include/linux/acpi.h
+++ linux-pm/include/linux/acpi.h
@@ -488,8 +488,6 @@ static inline bool acpi_driver_match_dev
 
 #endif	/* !CONFIG_ACPI */
 
-#define DEVICE_ACPI_HANDLE(dev)	ACPI_HANDLE(dev)
-
 #ifdef CONFIG_ACPI
 void acpi_os_set_prepare_sleep(int (*func)(u8 sleep_state,
 			       u32 pm1a_ctrl,  u32 pm1b_ctrl));
Index: linux-pm/include/linux/pci-acpi.h
===================================================================
--- linux-pm.orig/include/linux/pci-acpi.h
+++ linux-pm/include/linux/pci-acpi.h
@@ -27,7 +27,7 @@ static inline acpi_handle acpi_find_root
 	while (!pci_is_root_bus(pbus))
 		pbus = pbus->parent;
 
-	return DEVICE_ACPI_HANDLE(pbus->bridge);
+	return ACPI_HANDLE(pbus->bridge);
 }
 
 static inline acpi_handle acpi_pci_get_bridge_handle(struct pci_bus *pbus)
@@ -39,7 +39,7 @@ static inline acpi_handle acpi_pci_get_b
 	else
 		dev = &pbus->self->dev;
 
-	return DEVICE_ACPI_HANDLE(dev);
+	return ACPI_HANDLE(dev);
 }
 
 void acpi_pci_add_bus(struct pci_bus *bus);

