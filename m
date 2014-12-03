Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaLCXO5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 18:14:57 -0500
Received: from mail-bn1on0133.outbound.protection.outlook.com ([157.56.110.133]:17888
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752569AbaLCXOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 18:14:54 -0500
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>, <bhamciu1@freescale.com>,
        <R89243@freescale.com>, <Geoff.Thorpe@freescale.com>,
        <bhupesh.sharma@freescale.com>, <nir.erez@freescale.com>,
        <richard.schmitt@freescale.com>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [PATCH 2/3 v5] drivers/bus: Freescale Management Complex (fsl-mc) bus driver
Date: Wed, 3 Dec 2014 17:12:58 -0600
Message-ID: <1417648379-12518-3-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 2.2.0
In-Reply-To: <1417648379-12518-1-git-send-email-German.Rivera@freescale.com>
References: <1417648379-12518-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(86362001)(47776003)(20776003)(93916002)(62966003)(64706001)(92726001)(2201001)(87286001)(92566001)(88136002)(87936001)(31966008)(89996001)(81156004)(77096005)(68736005)(36756003)(99396003)(106466001)(104166001)(104016003)(77156002)(50466002)(120916001)(48376002)(107046002)(229853001)(84676001)(95666004)(50986999)(21056001)(105606002)(102836001)(19580395003)(69596002)(19580405001)(76176999)(44976005)(6806004)(97736003)(50226001)(4396001)(46102003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR03MB432;H:az84smr01.freescale.net;FPR:;SPF:Fail;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB432;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB432;
X-Forefront-PRVS: 0414DF926F
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB432;
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platform device driver that sets up the basic bus infrastructure
for the fsl-mc bus type, including support for adding/removing
fsl-mc devices, register/unregister of fsl-mc drivers, and bus
match support to bind devices to drivers.

Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
---
Changes addressed in v5:
- Addressed comments from Alex Graf:
  * Renamed dprc_get_container_id() call as dpmng_get_container_id().
  * Added TODO comment to use the 'ranges' property of the
    fsl-mc DT node.

Changes addressed in v4:
- Addressed comments from Alex Graf:
  * Added missing scope limitations and more descriptive help
    text for the FSL_MC_BUS config option.
- Fixed bug related to setting fsl_mc_bus_type.dev_root too
  late.

Changes in v3:
- Addressed changes from Kim Phillips:
  * Renamed files:
	drivers/bus/fsl-mc/fsl_mc_bus.c -> drivers/bus/fsl-mc/mc-bus.c
	include/linux/fsl_mc.h -> include/linux/fsl/mc.h
	include/linux/fsl_mc_private.h -> include/linux/fsl/mc-private.h

- Addressed comments from Timur Tabi:
  * Changed all functions that had goto out/error when no common cleanup
    was done, to just have multiple return points.
  * Replaced error cleanup boolean flags with multiple exit points.

Changes in v2:
- Addressed comment from Joe Perches:
  * Changed pr_debug to dev_dbg in fsl_mc_bus_match

- Addressed comments from Kim Phillips and Alex Graf:
  * Changed version check to allow the driver to run with MC
    firmware that has major version number greater than or equal
    to the driver's major version number.
  * Removed minor version check

- Removed unused variable parent_dev in fsl_mc_device_remove

 drivers/bus/Kconfig            |   3 +
 drivers/bus/Makefile           |   3 +
 drivers/bus/fsl-mc/Kconfig     |  24 ++
 drivers/bus/fsl-mc/Makefile    |  14 +
 drivers/bus/fsl-mc/mc-bus.c    | 588 +++++++++++++++++++++++++++++++++++++++++
 include/linux/fsl/mc-private.h |  33 +++
 include/linux/fsl/mc.h         | 137 ++++++++++
 7 files changed, 802 insertions(+)
 create mode 100644 drivers/bus/fsl-mc/Kconfig
 create mode 100644 drivers/bus/fsl-mc/Makefile
 create mode 100644 drivers/bus/fsl-mc/mc-bus.c
 create mode 100644 include/linux/fsl/mc-private.h
 create mode 100644 include/linux/fsl/mc.h

diff --git a/drivers/bus/Kconfig b/drivers/bus/Kconfig
index 603eb1b..2fbb1fd 100644
--- a/drivers/bus/Kconfig
+++ b/drivers/bus/Kconfig
@@ -67,4 +67,7 @@ config VEXPRESS_CONFIG
 	help
 	  Platform configuration infrastructure for the ARM Ltd.
 	  Versatile Express.
+
+source "drivers/bus/fsl-mc/Kconfig"
+
 endmenu
diff --git a/drivers/bus/Makefile b/drivers/bus/Makefile
index 2973c18..6abcab1 100644
--- a/drivers/bus/Makefile
+++ b/drivers/bus/Makefile
@@ -15,3 +15,6 @@ obj-$(CONFIG_ARM_CCI)		+= arm-cci.o
 obj-$(CONFIG_ARM_CCN)		+= arm-ccn.o

 obj-$(CONFIG_VEXPRESS_CONFIG)	+= vexpress-config.o
+
+# Freescale Management Complex (MC) bus drivers
+obj-$(CONFIG_FSL_MC_BUS)	+= fsl-mc/
diff --git a/drivers/bus/fsl-mc/Kconfig b/drivers/bus/fsl-mc/Kconfig
new file mode 100644
index 0000000..0d779d9
--- /dev/null
+++ b/drivers/bus/fsl-mc/Kconfig
@@ -0,0 +1,24 @@
+#
+# Freescale Management Complex (MC) bus drivers
+#
+# Copyright (C) 2014 Freescale Semiconductor, Inc.
+#
+# This file is released under the GPLv2
+#
+
+config FSL_MC_BUS
+	tristate "Freescale Management Complex (MC) bus driver"
+	depends on OF && ARM64
+	help
+	  Driver to enable the bus infrastructure for the Freescale
+          QorIQ Management Complex (fsl-mc). The fsl-mc is a hardware
+	  module of the QorIQ LS2 SoCs, that does resource management
+	  for hardware building-blocks in the SoC that can be used
+	  to dynamically create networking hardware objects such as
+	  network interfaces (NICs), crypto accelerator instances,
+	  or L2 switches.
+
+	  Only enable this option when building the kernel for
+	  Freescale QorQIQ LS2xxxx SoCs.
+
+
diff --git a/drivers/bus/fsl-mc/Makefile b/drivers/bus/fsl-mc/Makefile
new file mode 100644
index 0000000..decd339
--- /dev/null
+++ b/drivers/bus/fsl-mc/Makefile
@@ -0,0 +1,14 @@
+#
+# Freescale Management Complex (MC) bus drivers
+#
+# Copyright (C) 2014 Freescale Semiconductor, Inc.
+#
+# This file is released under the GPLv2
+#
+obj-$(CONFIG_FSL_MC_BUS) += mc-bus-driver.o
+
+mc-bus-driver-objs := mc-bus.o \
+		      mc-sys.o \
+		      dprc.o \
+		      dpmng.o
+
diff --git a/drivers/bus/fsl-mc/mc-bus.c b/drivers/bus/fsl-mc/mc-bus.c
new file mode 100644
index 0000000..3db8a73
--- /dev/null
+++ b/drivers/bus/fsl-mc/mc-bus.c
@@ -0,0 +1,588 @@
+/*
+ * Freescale Management Complex (MC) bus driver
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ * Author: German Rivera <German.Rivera@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+
+#include <linux/fsl/mc-private.h>
+#include <linux/module.h>
+#include <linux/of_device.h>
+#include <linux/of_address.h>
+#include <linux/ioport.h>
+#include <linux/slab.h>
+#include <linux/limits.h>
+#include <linux/fsl/dpmng.h>
+#include <linux/fsl/mc-sys.h>
+#include "dprc-cmd.h"
+
+static struct kmem_cache *mc_dev_cache;
+
+/**
+ * fsl_mc_bus_match - device to driver matching callback
+ * @dev: the MC object device structure to match against
+ * @drv: the device driver to search for matching MC object device id
+ * structures
+ *
+ * Returns 1 on success, 0 otherwise.
+ */
+static int fsl_mc_bus_match(struct device *dev, struct device_driver *drv)
+{
+	const struct fsl_mc_device_match_id *id;
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(drv);
+	bool found = false;
+
+	if (mc_drv->match_id_table == NULL)
+		goto out;
+
+	if (WARN_ON(fsl_mc_bus_type.dev_root == NULL))
+		goto out;
+
+	/*
+	 * If the object is not 'plugged' don't match.
+	 * Only exception is the root DPRC, which is a special case.
+	 */
+	if ((mc_dev->obj_desc.state & DPRC_OBJ_STATE_PLUGGED) == 0 &&
+	    &mc_dev->dev != fsl_mc_bus_type.dev_root)
+		goto out;
+
+	/*
+	 * Traverse the match_id table of the given driver, trying to find
+	 * a matching for the given MC object device.
+	 */
+	for (id = mc_drv->match_id_table; id->vendor != 0x0; id++) {
+		if (id->vendor == mc_dev->obj_desc.vendor &&
+		    strcmp(id->obj_type, mc_dev->obj_desc.type) == 0 &&
+		    id->ver_major == mc_dev->obj_desc.ver_major &&
+		    id->ver_minor == mc_dev->obj_desc.ver_minor) {
+			found = true;
+			break;
+		}
+	}
+
+out:
+	dev_dbg(dev, "%smatched\n", found ? "" : "not ");
+	return found;
+}
+
+/**
+ * fsl_mc_bus_uevent - callback invoked when a device is added
+ */
+static int fsl_mc_bus_uevent(struct device *dev, struct kobj_uevent_env *env)
+{
+	pr_debug("%s invoked\n", __func__);
+	return 0;
+}
+
+struct bus_type fsl_mc_bus_type = {
+	.name = "fsl-mc",
+	.match = fsl_mc_bus_match,
+	.uevent = fsl_mc_bus_uevent,
+};
+EXPORT_SYMBOL_GPL(fsl_mc_bus_type);
+
+static int fsl_mc_driver_probe(struct device *dev)
+{
+	struct fsl_mc_driver *mc_drv;
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	int error;
+
+	if (WARN_ON(dev->driver == NULL))
+		return -EINVAL;
+
+	mc_drv = to_fsl_mc_driver(dev->driver);
+	if (WARN_ON(mc_drv->probe == NULL))
+		return -EINVAL;
+
+	error = mc_drv->probe(mc_dev);
+	if (error < 0) {
+		dev_err(dev, "MC object device probe callback failed: %d\n",
+			error);
+		return error;
+	}
+
+	return 0;
+}
+
+static int fsl_mc_driver_remove(struct device *dev)
+{
+	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+	int error;
+
+	if (WARN_ON(dev->driver == NULL))
+		return -EINVAL;
+
+	error = mc_drv->remove(mc_dev);
+	if (error < 0) {
+		dev_err(dev,
+			"MC object device remove callback failed: %d\n",
+			error);
+		return error;
+	}
+
+	return 0;
+}
+
+static void fsl_mc_driver_shutdown(struct device *dev)
+{
+	struct fsl_mc_driver *mc_drv = to_fsl_mc_driver(dev->driver);
+	struct fsl_mc_device *mc_dev = to_fsl_mc_device(dev);
+
+	mc_drv->shutdown(mc_dev);
+}
+
+/**
+ * __fsl_mc_driver_register - registers a child device driver with the
+ * MC bus
+ *
+ * This function is implicitly invoked from the registration function of
+ * fsl_mc device drivers, which is generated by the
+ * module_fsl_mc_driver() macro.
+ */
+int __fsl_mc_driver_register(struct fsl_mc_driver *mc_driver,
+			     struct module *owner)
+{
+	int error;
+
+	mc_driver->driver.owner = owner;
+	mc_driver->driver.bus = &fsl_mc_bus_type;
+
+	/*
+	 * Set default driver callbacks, if not set by the child driver:
+	 */
+	if (mc_driver->probe != NULL)
+		mc_driver->driver.probe = fsl_mc_driver_probe;
+
+	if (mc_driver->remove != NULL)
+		mc_driver->driver.remove = fsl_mc_driver_remove;
+
+	if (mc_driver->shutdown != NULL)
+		mc_driver->driver.shutdown = fsl_mc_driver_shutdown;
+
+	error = driver_register(&mc_driver->driver);
+	if (error < 0) {
+		pr_err("driver_register() failed for %s: %d\n",
+		       mc_driver->driver.name, error);
+		return error;
+	}
+
+	pr_info("MC object device driver %s registered\n",
+		mc_driver->driver.name);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__fsl_mc_driver_register);
+
+/**
+ * fsl_mc_driver_unregister - unregisters a device driver from the
+ * MC bus
+ */
+void fsl_mc_driver_unregister(struct fsl_mc_driver *mc_driver)
+{
+	driver_unregister(&mc_driver->driver);
+}
+EXPORT_SYMBOL_GPL(fsl_mc_driver_unregister);
+
+static int get_dprc_icid(struct fsl_mc_io *mc_io,
+			 int container_id, uint16_t *icid)
+{
+	uint16_t dprc_handle;
+	struct dprc_attributes attr;
+	int error;
+
+	error = dprc_open(mc_io, container_id, &dprc_handle);
+	if (error < 0) {
+		pr_err("dprc_open() failed: %d\n", error);
+		return error;
+	}
+
+	memset(&attr, 0, sizeof(attr));
+	error = dprc_get_attributes(mc_io, dprc_handle, &attr);
+	if (error < 0) {
+		pr_err("dprc_get_attributes() failed: %d\n", error);
+		goto common_cleanup;
+	}
+
+	*icid = attr.icid;
+	error = 0;
+
+common_cleanup:
+	(void)dprc_close(mc_io, dprc_handle);
+	return error;
+}
+
+static int fsl_mc_device_get_mmio_regions(struct fsl_mc_device *mc_dev,
+					  struct fsl_mc_device *mc_bus_dev)
+{
+	int i;
+	int error;
+	struct resource *regions;
+	struct dprc_obj_desc *obj_desc = &mc_dev->obj_desc;
+	struct device *parent_dev = mc_dev->dev.parent;
+
+	regions = kmalloc_array(obj_desc->region_count,
+				sizeof(regions[0]), GFP_KERNEL);
+	if (regions == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < obj_desc->region_count; i++) {
+		struct dprc_region_desc region_desc;
+
+		error = dprc_get_obj_region(mc_bus_dev->mc_io,
+					    mc_bus_dev->mc_handle,
+					    obj_desc->type,
+					    obj_desc->id, i, &region_desc);
+		if (error < 0) {
+			dev_err(parent_dev,
+				"dprc_get_obj_region() failed: %d\n", error);
+			goto error_cleanup_regions;
+		}
+
+		WARN_ON(region_desc.base_paddr == 0x0);
+		WARN_ON(region_desc.size == 0);
+		regions[i].start = region_desc.base_paddr;
+		regions[i].end = region_desc.base_paddr + region_desc.size - 1;
+		regions[i].name = "fsl-mc object MMIO region";
+		regions[i].flags = IORESOURCE_IO;
+	}
+
+	mc_dev->regions = regions;
+	return 0;
+
+error_cleanup_regions:
+	kfree(regions);
+	return error;
+}
+
+/**
+ * Add a newly discovered MC object device to be visible in Linux
+ */
+int fsl_mc_device_add(struct dprc_obj_desc *obj_desc,
+		      struct fsl_mc_io *mc_io,
+		      struct device *parent_dev,
+		      struct fsl_mc_device **new_mc_dev)
+{
+	int error;
+	struct fsl_mc_device *mc_dev = NULL;
+	struct fsl_mc_device *parent_mc_dev;
+
+	if (parent_dev->bus == &fsl_mc_bus_type)
+		parent_mc_dev = to_fsl_mc_device(parent_dev);
+	else
+		parent_mc_dev = NULL;
+
+	/*
+	 * DPRC devices must have a dedicated MC portal
+	 */
+	if (WARN_ON(strcmp(obj_desc->type, "dprc") == 0 && mc_io == NULL))
+		return -EINVAL;
+
+	mc_dev = kmem_cache_zalloc(mc_dev_cache, GFP_KERNEL);
+	if (mc_dev == NULL) {
+		dev_err(parent_dev,
+			"No memory to allocate fsl_mc_device\n");
+		return -ENOMEM;
+	}
+
+	mc_dev->obj_desc = *obj_desc;
+	mc_dev->mc_io = mc_io;
+	device_initialize(&mc_dev->dev);
+	mc_dev->dev.parent = parent_dev;
+	mc_dev->dev.bus = &fsl_mc_bus_type;
+	dev_set_name(&mc_dev->dev, "%s.%x", obj_desc->type, obj_desc->id);
+
+	if (strcmp(obj_desc->type, "dprc") == 0) {
+		struct fsl_mc_io *mc_io2;
+
+		mc_dev->flags |= FSL_MC_IS_DPRC;
+
+		/*
+		 * To get the DPRC's ICID, we need to open the DPRC
+		 * in get_dprc_icid(). For child DPRCs, we do so using the
+		 * parent DPRC's MC portal instead of the child DPRC's MC
+		 * portal, in case the child DPRC is already opened with
+		 * its own portal (e.g., the DPRC used by AIOP).
+		 *
+		 * NOTE: There cannot be more than one active open for a
+		 * given MC object, using the same MC portal.
+		 */
+		if (parent_mc_dev != NULL) {
+			/*
+			 * device being added is a child DPRC device
+			 */
+			mc_io2 = parent_mc_dev->mc_io;
+		} else {
+			/*
+			 * device being added is the root DPRC device
+			 */
+			mc_io2 = mc_io;
+
+			if (fsl_mc_bus_type.dev_root == NULL)
+				fsl_mc_bus_type.dev_root = &mc_dev->dev;
+		}
+
+		error = get_dprc_icid(mc_io2, obj_desc->id, &mc_dev->icid);
+		if (error < 0)
+			goto error_cleanup_dev;
+	} else {
+		/*
+		 * A non-DPRC MC object device has to be a child of another
+		 * MC object (specifically a DPRC object)
+		 */
+		mc_dev->icid = parent_mc_dev->icid;
+		mc_dev->dma_mask = FSL_MC_DEFAULT_DMA_MASK;
+		mc_dev->dev.dma_mask = &mc_dev->dma_mask;
+		if (obj_desc->region_count != 0) {
+			error = fsl_mc_device_get_mmio_regions(mc_dev,
+							       parent_mc_dev);
+			if (error < 0)
+				goto error_cleanup_dev;
+		}
+	}
+
+	/*
+	 * The device-specific probe callback will get invoked by device_add()
+	 */
+	error = device_add(&mc_dev->dev);
+	if (error < 0) {
+		dev_err(parent_dev,
+			"device_add() failed for device %s: %d\n",
+			dev_name(&mc_dev->dev), error);
+		goto error_cleanup_dev;
+	}
+
+	(void)get_device(&mc_dev->dev);
+	dev_dbg(parent_dev, "Added MC object device %s\n",
+		dev_name(&mc_dev->dev));
+
+	*new_mc_dev = mc_dev;
+	return 0;
+
+error_cleanup_dev:
+	if (mc_dev->regions != NULL)
+		kfree(mc_dev->regions);
+
+	kmem_cache_free(mc_dev_cache, mc_dev);
+	return error;
+}
+EXPORT_SYMBOL_GPL(fsl_mc_device_add);
+
+/**
+ * fsl_mc_device_remove - Remove a MC object device from being visible to
+ * Linux
+ *
+ * @mc_dev: Pointer to a MC object device object
+ */
+void fsl_mc_device_remove(struct fsl_mc_device *mc_dev)
+{
+	if (mc_dev->regions != NULL)
+		kfree(mc_dev->regions);
+
+	/*
+	 * The device-specific remove callback will get invoked by device_del()
+	 */
+	device_del(&mc_dev->dev);
+	put_device(&mc_dev->dev);
+
+	if (strcmp(mc_dev->obj_desc.type, "dprc") == 0) {
+		fsl_destroy_mc_io(mc_dev->mc_io);
+		if (&mc_dev->dev == fsl_mc_bus_type.dev_root)
+			fsl_mc_bus_type.dev_root = NULL;
+	}
+
+	mc_dev->mc_io = NULL;
+	kmem_cache_free(mc_dev_cache, mc_dev);
+}
+EXPORT_SYMBOL_GPL(fsl_mc_device_remove);
+
+/**
+ * fsl_mc_bus_probe - callback invoked when the root MC bus is being
+ * added
+ */
+static int fsl_mc_bus_probe(struct platform_device *pdev)
+{
+	struct dprc_obj_desc obj_desc;
+	int error;
+	struct fsl_mc_device *mc_bus_dev = NULL;
+	struct fsl_mc_io *mc_io = NULL;
+	int container_id;
+	phys_addr_t mc_portal_phys_addr;
+	uint32_t mc_portal_size;
+	struct mc_version mc_version;
+	struct resource res;
+
+	dev_info(&pdev->dev, "Root MC bus device probed");
+
+	/*
+	 * TODO: When the 'ranges' property gets added to the fsl-mc
+	 * node in the device tree, we need to use it here, to validate
+	 * the MC portal base address. For example, given the following
+	 * ranges property:
+	 *	ranges = <0x8 0x0 0x8 0x0 0x20000000>;
+	 *
+	 * we could check that the portal address  falls in the
+	 * 512MiB region that starts at 0x8_0000_0000 in the physical
+	 * address map.  Also, we can use the 'range' property to translate
+	 * the MC portal address from the 'reg' propertu, into a physical,
+	 * if in the future the MC portal address specified specified
+	 * in the 'reg' property becomes an MC-relative address (offset).
+	 */
+	error = of_address_to_resource(pdev->dev.of_node, 0, &res);
+	if (error < 0) {
+		dev_err(&pdev->dev,
+			"of_address_to_resource() failed for %s\n",
+			pdev->dev.of_node->full_name);
+		return error;
+	}
+
+	mc_portal_phys_addr = res.start;
+	mc_portal_size = resource_size(&res);
+	error = fsl_create_mc_io(&pdev->dev, mc_portal_phys_addr,
+				 mc_portal_size, 0, &mc_io);
+	if (error < 0)
+		return error;
+
+	error = mc_get_version(mc_io, &mc_version);
+	if (error != 0) {
+		dev_err(&pdev->dev,
+			"mc_get_version() failed with error %d\n", error);
+		goto error_cleanup_mc_io;
+	}
+
+	dev_info(&pdev->dev,
+		 "Freescale Management Complex Firmware version: %u.%u.%u\n",
+		 mc_version.major, mc_version.minor, mc_version.revision);
+
+	if (mc_version.major < MC_VER_MAJOR) {
+		dev_err(&pdev->dev,
+			"ERROR: MC firmware version not supported by driver (driver version: %u.%u)\n",
+			MC_VER_MAJOR, MC_VER_MINOR);
+		error = -ENOTSUPP;
+		goto error_cleanup_mc_io;
+	}
+
+	if (mc_version.major > MC_VER_MAJOR) {
+		dev_warn(&pdev->dev,
+			 "WARNING: driver may not support newer MC firmware features (driver version: %u.%u)\n",
+			 MC_VER_MAJOR, MC_VER_MINOR);
+	}
+
+	error = dpmng_get_container_id(mc_io, &container_id);
+	if (error < 0) {
+		dev_err(&pdev->dev,
+			"dpmng_get_container_id() failed: %d\n", error);
+		goto error_cleanup_mc_io;
+	}
+
+	obj_desc.vendor = FSL_MC_VENDOR_FREESCALE;
+	strcpy(obj_desc.type, "dprc");
+	obj_desc.id = container_id;
+	obj_desc.ver_major = DPRC_VER_MAJOR;
+	obj_desc.ver_minor = DPRC_VER_MINOR;
+	obj_desc.region_count = 0;
+
+	error = fsl_mc_device_add(&obj_desc, mc_io, &pdev->dev, &mc_bus_dev);
+	if (error < 0)
+		goto error_cleanup_mc_io;
+
+	platform_set_drvdata(pdev, mc_bus_dev);
+	return 0;
+
+error_cleanup_mc_io:
+	fsl_destroy_mc_io(mc_io);
+	return error;
+}
+
+/**
+ * fsl_mc_bus_remove - callback invoked when the root MC bus is being
+ * removed
+ */
+static int fsl_mc_bus_remove(struct platform_device *pdev)
+{
+	struct fsl_mc_device *mc_bus_dev = platform_get_drvdata(pdev);
+
+	if (WARN_ON(&mc_bus_dev->dev != fsl_mc_bus_type.dev_root))
+		return -EINVAL;
+
+	fsl_mc_device_remove(mc_bus_dev);
+	dev_info(&pdev->dev, "Root MC bus device removed");
+	return 0;
+}
+
+static const struct of_device_id fsl_mc_bus_match_table[] = {
+	{.compatible = "fsl,qoriq-mc",},
+	{},
+};
+
+MODULE_DEVICE_TABLE(of, fsl_mc_bus_match_table);
+
+static struct platform_driver fsl_mc_bus_driver = {
+	.driver = {
+		   .name = "fsl_mc_bus",
+		   .owner = THIS_MODULE,
+		   .pm = NULL,
+		   .of_match_table = fsl_mc_bus_match_table,
+		   },
+	.probe = fsl_mc_bus_probe,
+	.remove = fsl_mc_bus_remove,
+};
+
+static int __init fsl_mc_bus_driver_init(void)
+{
+	int error;
+
+	mc_dev_cache = kmem_cache_create("fsl_mc_device",
+					 sizeof(struct fsl_mc_device), 0, 0,
+					 NULL);
+	if (mc_dev_cache == NULL) {
+		pr_err("Could not create fsl_mc_device cache\n");
+		return -ENOMEM;
+	}
+
+	error = bus_register(&fsl_mc_bus_type);
+	if (error < 0) {
+		pr_err("fsl-mc bus type registration failed: %d\n", error);
+		goto error_cleanup_cache;
+	}
+
+	pr_info("fsl-mc bus type registered\n");
+
+	error = platform_driver_register(&fsl_mc_bus_driver);
+	if (error < 0) {
+		pr_err("platform_driver_register() failed: %d\n", error);
+		goto error_cleanup_bus;
+	}
+
+	return 0;
+
+error_cleanup_bus:
+	bus_unregister(&fsl_mc_bus_type);
+
+error_cleanup_cache:
+	kmem_cache_destroy(mc_dev_cache);
+	return error;
+}
+
+postcore_initcall(fsl_mc_bus_driver_init);
+
+static void __exit fsl_mc_bus_driver_exit(void)
+{
+	if (WARN_ON(mc_dev_cache == NULL))
+		return;
+
+	platform_driver_unregister(&fsl_mc_bus_driver);
+	bus_unregister(&fsl_mc_bus_type);
+	kmem_cache_destroy(mc_dev_cache);
+	pr_info("MC bus unregistered\n");
+}
+
+module_exit(fsl_mc_bus_driver_exit);
+
+MODULE_AUTHOR("Freescale Semiconductor Inc.");
+MODULE_DESCRIPTION("Freescale Management Complex (MC) bus driver");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/fsl/mc-private.h b/include/linux/fsl/mc-private.h
new file mode 100644
index 0000000..604832a
--- /dev/null
+++ b/include/linux/fsl/mc-private.h
@@ -0,0 +1,33 @@
+/*
+ * Freescale Management Complex (MC) bus private declarations
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ * Author: German Rivera <German.Rivera@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef _FSL_MC_PRIVATE_H_
+#define _FSL_MC_PRIVATE_H_
+
+#include <linux/fsl/mc.h>
+#include <linux/mutex.h>
+#include <linux/stringify.h>
+
+#define FSL_MC_DEVICE_MATCH(_mc_dev, _obj_desc) \
+	(strcmp((_mc_dev)->obj_desc.type, (_obj_desc)->type) == 0 && \
+	 (_mc_dev)->obj_desc.id == (_obj_desc)->id)
+
+#define FSL_MC_IS_ALLOCATABLE(_obj_type) \
+	(strcmp(_obj_type, "dpbp") == 0 || \
+	 strcmp(_obj_type, "dpcon") == 0)
+
+int __must_check fsl_mc_device_add(struct dprc_obj_desc *obj_desc,
+				   struct fsl_mc_io *mc_io,
+				   struct device *parent_dev,
+				   struct fsl_mc_device **new_mc_dev);
+
+void fsl_mc_device_remove(struct fsl_mc_device *mc_dev);
+
+#endif /* _FSL_MC_PRIVATE_H_ */
diff --git a/include/linux/fsl/mc.h b/include/linux/fsl/mc.h
new file mode 100644
index 0000000..5d89d1bf
--- /dev/null
+++ b/include/linux/fsl/mc.h
@@ -0,0 +1,137 @@
+/*
+ * Freescale Management Complex (MC) bus public interface
+ *
+ * Copyright (C) 2014 Freescale Semiconductor, Inc.
+ * Author: German Rivera <German.Rivera@freescale.com>
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#ifndef _FSL_MC_H_
+#define _FSL_MC_H_
+
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/fsl/dprc.h>
+
+#define FSL_MC_VENDOR_FREESCALE	0x1957
+
+struct fsl_mc_device;
+struct fsl_mc_io;
+
+/**
+ * struct fsl_mc_driver - MC object device driver object
+ * @driver: Generic device driver
+ * @match_id_table: table of supported device matching Ids
+ * @probe: Function called when a device is added
+ * @remove: Function called when a device is removed
+ * @shutdown: Function called at shutdown time to quiesce the device
+ * @suspend: Function called when a device is stopped
+ * @resume: Function called when a device is resumed
+ *
+ * Generic DPAA device driver object for device drivers that are registered
+ * with a DPRC bus. This structure is to be embedded in each device-specific
+ * driver structure.
+ */
+struct fsl_mc_driver {
+	struct device_driver driver;
+	const struct fsl_mc_device_match_id *match_id_table;
+	int (*probe)(struct fsl_mc_device *dev);
+	int (*remove)(struct fsl_mc_device *dev);
+	void (*shutdown)(struct fsl_mc_device *dev);
+	int (*suspend)(struct fsl_mc_device *dev, pm_message_t state);
+	int (*resume)(struct fsl_mc_device *dev);
+};
+
+#define to_fsl_mc_driver(_drv) \
+	container_of(_drv, struct fsl_mc_driver, driver)
+
+/**
+ * struct fsl_mc_device_match_id - MC object device Id entry for driver matching
+ * @vendor: vendor ID
+ * @obj_type: MC object type
+ * @ver_major: MC object version major number
+ * @ver_minor: MC object version minor number
+ *
+ * Type of entries in the "device Id" table for MC object devices supported by
+ * a MC object device driver. The last entry of the table has vendor set to 0x0
+ */
+struct fsl_mc_device_match_id {
+	uint16_t vendor;
+	const char obj_type[16];
+	uint32_t ver_major;
+	uint32_t ver_minor;
+};
+
+/**
+ * Bit masks for a MC object device (struct fsl_mc_device) flags
+ */
+#define FSL_MC_IS_DPRC	0x0001
+
+/**
+ * Default DMA mask for devices on a fsl-mc bus
+ */
+#define FSL_MC_DEFAULT_DMA_MASK	(~0ULL)
+
+/**
+ * struct fsl_mc_device - MC object device object
+ * @dev: Linux driver model device object
+ * @dma_mask: Default DMA mask
+ * @flags: MC object device flags
+ * @icid: Isolation context ID for the device
+ * @mc_handle: MC handle for the corresponding MC object opened
+ * @mc_io: Pointer to MC IO object assigned to this device or
+ * NULL if none.
+ * @obj_desc: MC description of the DPAA device
+ * @regions: pointer to array of MMIO region entries
+ *
+ * Generic device object for MC object devices that are "attached" to a
+ * MC bus.
+ *
+ * NOTES:
+ * - For a non-DPRC object its icid is the same as its parent DPRC's icid.
+ * - The SMMU notifier callback gets invoked after device_add() has been
+ *   called for an MC object device, but before the device-specific probe
+ *   callback gets called.
+ */
+struct fsl_mc_device {
+	struct device dev;
+	uint64_t dma_mask;
+	uint16_t flags;
+	uint16_t icid;
+	uint16_t mc_handle;
+	struct fsl_mc_io *mc_io;
+	struct dprc_obj_desc obj_desc;
+	struct resource *regions;
+};
+
+#define to_fsl_mc_device(_dev) \
+	container_of(_dev, struct fsl_mc_device, dev)
+
+/*
+ * module_fsl_mc_driver() - Helper macro for drivers that don't do
+ * anything special in module init/exit.  This eliminates a lot of
+ * boilerplate.  Each module may only use this macro once, and
+ * calling it replaces module_init() and module_exit()
+ */
+#define module_fsl_mc_driver(__fsl_mc_driver) \
+	module_driver(__fsl_mc_driver, fsl_mc_driver_register, \
+		      fsl_mc_driver_unregister)
+
+/*
+ * Macro to avoid include chaining to get THIS_MODULE
+ */
+#define fsl_mc_driver_register(drv) \
+	__fsl_mc_driver_register(drv, THIS_MODULE)
+
+int __must_check __fsl_mc_driver_register(struct fsl_mc_driver *fsl_mc_driver,
+					  struct module *owner);
+
+void fsl_mc_driver_unregister(struct fsl_mc_driver *driver);
+
+extern struct bus_type fsl_mc_bus_type;
+
+#endif /* _FSL_MC_H_ */
--
2.2.0

