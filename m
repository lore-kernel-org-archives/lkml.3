Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab3HURux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:50:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:2663 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253Ab3HURuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:50:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,929,1367996400"; 
   d="scan'208";a="366351295"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        Asias He <asias@redhat.com>
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH v3 1/7] Intel MIC Host Driver for X100 family.
Date: Wed, 21 Aug 2013 10:50:09 -0700
Message-Id: <eb37195f5b9391cf1261bede517b9daf15c1b04e.1377104309.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1377104309.git.sudeep.dutt@intel.com>
References: <cover.1377104309.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the following:
a) Initializes the Intel MIC X100 PCIe devices.
b) Provides sysfs entries for family and stepping information.

Co-author: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Signed-off-by: Caz Yokoyama <Caz.Yokoyama@intel.com>
Signed-off-by: Dasaratharaman Chandramouli <dasaratharaman.chandramouli@intel.com>
Signed-off-by: Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>
Signed-off-by: Nikhil Rao <nikhil.rao@intel.com>
Signed-off-by: Sudeep Dutt <sudeep.dutt@intel.com>
Acked-by: Yaozu (Eddie) Dong <eddie.dong@intel.com>
Reviewed-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
---
 Documentation/ABI/testing/sysfs-class-mic.txt |  34 +++
 drivers/misc/Kconfig                          |   1 +
 drivers/misc/Makefile                         |   1 +
 drivers/misc/mic/Kconfig                      |  19 ++
 drivers/misc/mic/Makefile                     |   5 +
 drivers/misc/mic/common/mic_device.h          |  37 +++
 drivers/misc/mic/host/Makefile                |   8 +
 drivers/misc/mic/host/mic_device.h            | 109 +++++++++
 drivers/misc/mic/host/mic_main.c              | 309 ++++++++++++++++++++++++++
 drivers/misc/mic/host/mic_sysfs.c             |  97 ++++++++
 drivers/misc/mic/host/mic_x100.c              |  75 +++++++
 drivers/misc/mic/host/mic_x100.h              |  47 ++++
 12 files changed, 742 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-mic.txt
 create mode 100644 drivers/misc/mic/Kconfig
 create mode 100644 drivers/misc/mic/Makefile
 create mode 100644 drivers/misc/mic/common/mic_device.h
 create mode 100644 drivers/misc/mic/host/Makefile
 create mode 100644 drivers/misc/mic/host/mic_device.h
 create mode 100644 drivers/misc/mic/host/mic_main.c
 create mode 100644 drivers/misc/mic/host/mic_sysfs.c
 create mode 100644 drivers/misc/mic/host/mic_x100.c
 create mode 100644 drivers/misc/mic/host/mic_x100.h

diff --git a/Documentation/ABI/testing/sysfs-class-mic.txt b/Documentation/ABI/testing/sysfs-class-mic.txt
new file mode 100644
index 0000000..09eb3c6
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-mic.txt
@@ -0,0 +1,34 @@
+What:		/sys/class/mic/
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		The mic class directory belongs to Intel MIC devices and
+		provides information per MIC device. An Intel MIC device is a
+		PCIe form factor add-in Coprocessor card based on the Intel Many
+		Integrated Core (MIC) architecture that runs a Linux OS.
+
+What:		/sys/class/mic/mic(x)
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		The directories /sys/class/mic/mic0, /sys/class/mic/mic1 etc.,
+		represent MIC devices (0,1,..etc). Each directory has
+		information specific to that MIC device.
+
+What:		/sys/class/mic/mic(x)/family
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		Provides information about the Coprocessor family for an Intel
+		MIC device. For example - "x100"
+
+What:		/sys/class/mic/mic(x)/stepping
+Date:		August 2013
+KernelVersion:	3.11
+Contact:	Sudeep Dutt <sudeep.dutt@intel.com>
+Description:
+		Provides information about the silicon stepping for an Intel
+		MIC device. For example - "A0" or "B0"
diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 8dacd4c..e760715 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -537,4 +537,5 @@ source "drivers/misc/carma/Kconfig"
 source "drivers/misc/altera-stapl/Kconfig"
 source "drivers/misc/mei/Kconfig"
 source "drivers/misc/vmw_vmci/Kconfig"
+source "drivers/misc/mic/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index c235d5b..0b7ea3e 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -53,3 +53,4 @@ obj-$(CONFIG_INTEL_MEI)		+= mei/
 obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
 obj-$(CONFIG_LATTICE_ECP3_CONFIG)	+= lattice-ecp3-config.o
 obj-$(CONFIG_SRAM)		+= sram.o
+obj-y				+= mic/
diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
new file mode 100644
index 0000000..aaefd0c
--- /dev/null
+++ b/drivers/misc/mic/Kconfig
@@ -0,0 +1,19 @@
+comment "Intel MIC Host Driver"
+
+config INTEL_MIC_HOST
+	tristate "Intel MIC Host Driver"
+	depends on 64BIT && PCI
+	default N
+	help
+	  This enables Host Driver support for the Intel Many Integrated
+	  Core (MIC) family of PCIe form factor coprocessor devices that
+	  run a 64 bit Linux OS. The driver manages card OS state and
+	  enables communication between host and card. Intel MIC X100
+	  devices are currently supported.
+
+	  If you are building a host kernel with an Intel MIC device then
+	  say M (recommended) or Y, else say N. If unsure say N.
+
+	  More information about the Intel MIC family as well as the Linux
+	  OS and tools for MIC to use with this driver are available from
+	  <http://software.intel.com/en-us/mic-developer>.
diff --git a/drivers/misc/mic/Makefile b/drivers/misc/mic/Makefile
new file mode 100644
index 0000000..8e72421
--- /dev/null
+++ b/drivers/misc/mic/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile - Intel MIC Linux driver.
+# Copyright(c) 2013, Intel Corporation.
+#
+obj-$(CONFIG_INTEL_MIC_HOST) += host/
diff --git a/drivers/misc/mic/common/mic_device.h b/drivers/misc/mic/common/mic_device.h
new file mode 100644
index 0000000..f02262e
--- /dev/null
+++ b/drivers/misc/mic/common/mic_device.h
@@ -0,0 +1,37 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC driver.
+ *
+ */
+#ifndef __MIC_COMMON_DEVICE_H_
+#define __MIC_COMMON_DEVICE_H_
+
+/**
+ * struct mic_mw - MIC memory window
+ *
+ * @pa: Base physical address.
+ * @va: Base ioremap'd virtual address.
+ * @len: Size of the memory window.
+ */
+struct mic_mw {
+	phys_addr_t pa;
+	void __iomem *va;
+	resource_size_t len;
+};
+
+#endif
diff --git a/drivers/misc/mic/host/Makefile b/drivers/misc/mic/host/Makefile
new file mode 100644
index 0000000..93b9d25
--- /dev/null
+++ b/drivers/misc/mic/host/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile - Intel MIC Linux driver.
+# Copyright(c) 2013, Intel Corporation.
+#
+obj-$(CONFIG_INTEL_MIC_HOST) += mic_host.o
+mic_host-objs := mic_main.o
+mic_host-objs += mic_x100.o
+mic_host-objs += mic_sysfs.o
diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
new file mode 100644
index 0000000..6cd904c
--- /dev/null
+++ b/drivers/misc/mic/host/mic_device.h
@@ -0,0 +1,109 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#ifndef _MIC_DEVICE_H_
+#define _MIC_DEVICE_H_
+
+/* The maximum number of MIC devices supported in a single host system. */
+#define MIC_MAX_NUM_DEVS 256
+
+/**
+ * enum mic_hw_family - The hardware family to which a device belongs.
+ */
+enum mic_hw_family {
+	MIC_FAMILY_X100 = 0,
+	MIC_FAMILY_UNKNOWN
+};
+
+/**
+ * enum mic_stepping - MIC stepping ids.
+ */
+enum mic_stepping {
+	MIC_A0_STEP = 0x0,
+	MIC_B0_STEP = 0x10,
+	MIC_B1_STEP = 0x11,
+	MIC_C0_STEP = 0x20,
+};
+
+/**
+ * struct mic_device -  MIC device information for each card.
+ *
+ * @mmio: MMIO bar information.
+ * @aper: Aperture bar information.
+ * @family: The MIC family to which this device belongs.
+ * @ops: MIC HW specific operations.
+ * @id: The unique device id for this MIC device.
+ * @stepping: Stepping ID.
+ * @attr_group: Pointer to list of sysfs attribute groups.
+ * @sdev: Device for sysfs entries.
+ */
+struct mic_device {
+	struct mic_mw mmio;
+	struct mic_mw aper;
+	enum mic_hw_family family;
+	struct mic_hw_ops *ops;
+	int id;
+	enum mic_stepping stepping;
+	const struct attribute_group **attr_group;
+	struct device *sdev;
+};
+
+/**
+ * struct mic_hw_ops - MIC HW specific operations.
+ * @aper_bar: Aperture bar resource number.
+ * @mmio_bar: MMIO bar resource number.
+ * @read_spad: Read from scratch pad register.
+ * @write_spad: Write to scratch pad register.
+ */
+struct mic_hw_ops {
+	u8 aper_bar;
+	u8 mmio_bar;
+	u32 (*read_spad)(struct mic_device *mdev, unsigned int idx);
+	void (*write_spad)(struct mic_device *mdev, unsigned int idx, u32 val);
+};
+
+/**
+ * mic_mmio_read - read from an MMIO register.
+ * @mw: MMIO register base virtual address.
+ * @offset: register offset.
+ *
+ * RETURNS: register value.
+ */
+static inline u32 mic_mmio_read(struct mic_mw *mw, u32 offset)
+{
+	return ioread32(mw->va + offset);
+}
+
+/**
+ * mic_mmio_write - write to an MMIO register.
+ * @mw: MMIO register base virtual address.
+ * @val: the data value to put into the register
+ * @offset: register offset.
+ *
+ * RETURNS: none.
+ */
+static inline void
+mic_mmio_write(struct mic_mw *mw, u32 val, u32 offset)
+{
+	iowrite32(val, mw->va + offset);
+}
+
+void mic_sysfs_init(struct mic_device *mdev);
+#endif
diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_main.c
new file mode 100644
index 0000000..228c96c
--- /dev/null
+++ b/drivers/misc/mic/host/mic_main.c
@@ -0,0 +1,309 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ * Global TODO's across the driver to be added after initial base
+ * patches are accepted upstream:
+ * 1) Enable DMA support.
+ * 2) Enable per vring interrupt support.
+ */
+#include <linux/fs.h>
+#include <linux/idr.h>
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "../common/mic_device.h"
+#include "mic_device.h"
+#include "mic_x100.h"
+
+static const char mic_driver_name[] = "mic";
+
+static DEFINE_PCI_DEVICE_TABLE(mic_pci_tbl) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2250)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2251)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2252)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2253)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2254)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2255)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2256)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2257)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2258)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_2259)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_225a)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_225b)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_225c)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_225d)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MIC_X100_PCI_DEVICE_225e)},
+
+	/* required last entry */
+	{ 0, }
+};
+
+MODULE_DEVICE_TABLE(pci, mic_pci_tbl);
+
+/* ID allocator for MIC devices */
+static struct ida g_mic_ida;
+/* Class of MIC devices for sysfs accessibility. */
+static struct class *g_mic_class;
+/* Base device node number for MIC devices */
+static dev_t g_mic_devno;
+
+/**
+ * mic_ops_init: Initialize HW specific operation tables.
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ * returns none.
+ */
+static void mic_ops_init(struct mic_device *mdev)
+{
+	switch (mdev->family) {
+	case MIC_FAMILY_X100:
+		mdev->ops = &mic_x100_ops;
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * mic_get_family - Determine hardware family to which this MIC belongs.
+ *
+ * @pdev: The pci device structure
+ *
+ * returns family.
+ */
+static enum mic_hw_family mic_get_family(struct pci_dev *pdev)
+{
+	enum mic_hw_family family;
+
+	switch (pdev->device) {
+	case MIC_X100_PCI_DEVICE_2250:
+	case MIC_X100_PCI_DEVICE_2251:
+	case MIC_X100_PCI_DEVICE_2252:
+	case MIC_X100_PCI_DEVICE_2253:
+	case MIC_X100_PCI_DEVICE_2254:
+	case MIC_X100_PCI_DEVICE_2255:
+	case MIC_X100_PCI_DEVICE_2256:
+	case MIC_X100_PCI_DEVICE_2257:
+	case MIC_X100_PCI_DEVICE_2258:
+	case MIC_X100_PCI_DEVICE_2259:
+	case MIC_X100_PCI_DEVICE_225a:
+	case MIC_X100_PCI_DEVICE_225b:
+	case MIC_X100_PCI_DEVICE_225c:
+	case MIC_X100_PCI_DEVICE_225d:
+	case MIC_X100_PCI_DEVICE_225e:
+		family = MIC_FAMILY_X100;
+		break;
+	default:
+		family = MIC_FAMILY_UNKNOWN;
+		break;
+	}
+	return family;
+}
+
+/**
+ * mic_device_init - Allocates and initializes the MIC device structure
+ *
+ * @mdev: pointer to mic_device instance
+ * @pdev: The pci device structure
+ *
+ * returns none.
+ */
+static void
+mic_device_init(struct mic_device *mdev, struct pci_dev *pdev)
+{
+	mdev->family = mic_get_family(pdev);
+	mdev->stepping = pdev->revision;
+	mic_ops_init(mdev);
+	mic_sysfs_init(mdev);
+}
+
+/**
+ * mic_probe - Device Initialization Routine
+ *
+ * @pdev: PCI device structure
+ * @ent: entry in mic_pci_tbl
+ *
+ * returns 0 on success, < 0 on failure.
+ */
+static int mic_probe(struct pci_dev *pdev,
+		const struct pci_device_id *ent)
+{
+	int rc;
+	struct mic_device *mdev;
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev) {
+		rc = -ENOMEM;
+		dev_err(&pdev->dev, "mdev kmalloc failed rc %d\n", rc);
+		goto mdev_alloc_fail;
+	}
+	mdev->id = ida_simple_get(&g_mic_ida, 0, MIC_MAX_NUM_DEVS, GFP_KERNEL);
+	if (mdev->id < 0) {
+		rc = mdev->id;
+		dev_err(&pdev->dev, "ida_simple_get failed rc %d\n", rc);
+		goto ida_fail;
+	}
+
+	mic_device_init(mdev, pdev);
+
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to enable pci device.\n");
+		goto ida_remove;
+	}
+
+	pci_set_master(pdev);
+
+	rc = pci_request_regions(pdev, mic_driver_name);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to get pci regions.\n");
+		goto disable_device;
+	}
+
+	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+	if (rc) {
+		dev_err(&pdev->dev, "Cannot set DMA mask\n");
+		goto release_regions;
+	}
+
+	mdev->mmio.pa = pci_resource_start(pdev, mdev->ops->mmio_bar);
+	mdev->mmio.len = pci_resource_len(pdev, mdev->ops->mmio_bar);
+	mdev->mmio.va = pci_ioremap_bar(pdev, mdev->ops->mmio_bar);
+	if (!mdev->mmio.va) {
+		dev_err(&pdev->dev, "Cannot remap MMIO BAR\n");
+		rc = -EIO;
+		goto release_regions;
+	}
+
+	mdev->aper.pa = pci_resource_start(pdev, mdev->ops->aper_bar);
+	mdev->aper.len = pci_resource_len(pdev, mdev->ops->aper_bar);
+	mdev->aper.va = ioremap_wc(mdev->aper.pa, mdev->aper.len);
+	if (!mdev->aper.va) {
+		dev_err(&pdev->dev, "Cannot remap Aperture BAR\n");
+		rc = -EIO;
+		goto unmap_mmio;
+	}
+
+	pci_set_drvdata(pdev, mdev);
+
+	mdev->sdev = device_create_with_groups(g_mic_class, &pdev->dev,
+		MKDEV(MAJOR(g_mic_devno), mdev->id), NULL,
+		mdev->attr_group, "mic%d", mdev->id);
+	if (IS_ERR(mdev->sdev)) {
+		rc = PTR_ERR(mdev->sdev);
+		dev_err(&pdev->dev,
+			"device_create_with_groups failed rc %d\n", rc);
+		goto unmap_aper;
+	}
+	return 0;
+unmap_aper:
+	iounmap(mdev->aper.va);
+unmap_mmio:
+	iounmap(mdev->mmio.va);
+release_regions:
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+ida_remove:
+	ida_simple_remove(&g_mic_ida, mdev->id);
+ida_fail:
+	kfree(mdev);
+mdev_alloc_fail:
+	dev_err(&pdev->dev, "Probe failed rc %d\n", rc);
+	return rc;
+}
+
+/**
+ * mic_remove - Device Removal Routine
+ * mic_remove is called by the PCI subsystem to alert the driver
+ * that it should release a PCI device.
+ *
+ * @pdev: PCI device structure
+ */
+static void mic_remove(struct pci_dev *pdev)
+{
+	struct mic_device *mdev;
+
+	mdev = pci_get_drvdata(pdev);
+	if (!mdev)
+		return;
+
+	device_destroy(g_mic_class, MKDEV(MAJOR(g_mic_devno), mdev->id));
+	iounmap(mdev->mmio.va);
+	iounmap(mdev->aper.va);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	ida_simple_remove(&g_mic_ida, mdev->id);
+	kfree(mdev);
+}
+static struct pci_driver mic_driver = {
+	.name = mic_driver_name,
+	.id_table = mic_pci_tbl,
+	.probe = mic_probe,
+	.remove = mic_remove
+};
+
+static int __init mic_init(void)
+{
+	int ret;
+
+	ret = alloc_chrdev_region(&g_mic_devno, 0,
+		MIC_MAX_NUM_DEVS, mic_driver_name);
+	if (ret) {
+		pr_err("alloc_chrdev_region failed ret %d\n", ret);
+		goto error;
+	}
+
+	g_mic_class = class_create(THIS_MODULE, mic_driver_name);
+	if (IS_ERR(g_mic_class)) {
+		ret = PTR_ERR(g_mic_class);
+		pr_err("class_create failed ret %d\n", ret);
+		goto cleanup_chrdev;
+	}
+
+	ida_init(&g_mic_ida);
+	ret = pci_register_driver(&mic_driver);
+	if (ret) {
+		pr_err("pci_register_driver failed ret %d\n", ret);
+		goto class_destroy;
+	}
+	return ret;
+class_destroy:
+	class_destroy(g_mic_class);
+cleanup_chrdev:
+	unregister_chrdev_region(g_mic_devno, MIC_MAX_NUM_DEVS);
+error:
+	return ret;
+}
+
+static void __exit mic_exit(void)
+{
+	pci_unregister_driver(&mic_driver);
+	ida_destroy(&g_mic_ida);
+	class_destroy(g_mic_class);
+	unregister_chrdev_region(g_mic_devno, MIC_MAX_NUM_DEVS);
+}
+
+module_init(mic_init);
+module_exit(mic_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) MIC X100 Host driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/misc/mic/host/mic_sysfs.c b/drivers/misc/mic/host/mic_sysfs.c
new file mode 100644
index 0000000..972c182
--- /dev/null
+++ b/drivers/misc/mic/host/mic_sysfs.c
@@ -0,0 +1,97 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/pci.h>
+
+#include "../common/mic_device.h"
+#include "mic_device.h"
+
+static ssize_t
+mic_show_family(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	static const char x100[] = "x100";
+	static const char unknown[] = "Unknown";
+	const char *card = NULL;
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	switch (mdev->family) {
+	case MIC_FAMILY_X100:
+		card = x100;
+		break;
+	default:
+		card = unknown;
+		break;
+	}
+	return scnprintf(buf, PAGE_SIZE, "%s\n", card);
+}
+static DEVICE_ATTR(family, S_IRUGO, mic_show_family, NULL);
+
+static ssize_t
+mic_show_stepping(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	char *string = "??";
+
+	if (!mdev)
+		return -EINVAL;
+
+	switch (mdev->stepping) {
+	case MIC_A0_STEP:
+		string = "A0";
+		break;
+	case MIC_B0_STEP:
+		string = "B0";
+		break;
+	case MIC_B1_STEP:
+		string = "B1";
+		break;
+	case MIC_C0_STEP:
+		string = "C0";
+		break;
+	default:
+		break;
+	}
+	return scnprintf(buf, PAGE_SIZE, "%s\n", string);
+}
+static DEVICE_ATTR(stepping, S_IRUGO, mic_show_stepping, NULL);
+
+static struct attribute *mic_default_attrs[] = {
+	&dev_attr_family.attr,
+	&dev_attr_stepping.attr,
+
+	NULL
+};
+
+static struct attribute_group mic_attr_group = {
+	.attrs = mic_default_attrs,
+};
+
+static const struct attribute_group *__mic_attr_group[] = {
+	&mic_attr_group,
+	NULL
+};
+
+void mic_sysfs_init(struct mic_device *mdev)
+{
+	mdev->attr_group = __mic_attr_group;
+}
diff --git a/drivers/misc/mic/host/mic_x100.c b/drivers/misc/mic/host/mic_x100.c
new file mode 100644
index 0000000..da481b1
--- /dev/null
+++ b/drivers/misc/mic/host/mic_x100.c
@@ -0,0 +1,75 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/fs.h>
+#include <linux/pci.h>
+
+#include "../common/mic_device.h"
+#include "mic_device.h"
+#include "mic_x100.h"
+
+/**
+ * mic_x100_write_spad - write to the scratchpad register
+ * @mdev: pointer to mic_device instance
+ * @idx: index to the scratchpad register, 0 based
+ * @val: the data value to put into the register
+ *
+ * This function allows writing of a 32bit value to the indexed scratchpad
+ * register.
+ *
+ * RETURNS: none.
+ */
+static void
+mic_x100_write_spad(struct mic_device *mdev, unsigned int idx, u32 val)
+{
+	dev_dbg(mdev->sdev->parent, "Writing 0x%x to scratch pad index %d\n",
+		val, idx);
+	mic_mmio_write(&mdev->mmio, val,
+		MIC_X100_SBOX_BASE_ADDRESS +
+		MIC_X100_SBOX_SPAD0 + idx * 4);
+}
+
+/**
+ * mic_x100_read_spad - read from the scratchpad register
+ * @mdev: pointer to mic_device instance
+ * @idx: index to scratchpad register, 0 based
+ *
+ * This function allows reading of the 32bit scratchpad register.
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static u32
+mic_x100_read_spad(struct mic_device *mdev, unsigned int idx)
+{
+	u32 val = mic_mmio_read(&mdev->mmio,
+		MIC_X100_SBOX_BASE_ADDRESS +
+		MIC_X100_SBOX_SPAD0 + idx * 4);
+
+	dev_dbg(mdev->sdev->parent,
+		"Reading 0x%x from scratch pad index %d\n", val, idx);
+	return val;
+}
+
+struct mic_hw_ops mic_x100_ops = {
+	.aper_bar = MIC_X100_APER_BAR,
+	.mmio_bar = MIC_X100_MMIO_BAR,
+	.read_spad = mic_x100_read_spad,
+	.write_spad = mic_x100_write_spad,
+};
diff --git a/drivers/misc/mic/host/mic_x100.h b/drivers/misc/mic/host/mic_x100.h
new file mode 100644
index 0000000..1f4e630
--- /dev/null
+++ b/drivers/misc/mic/host/mic_x100.h
@@ -0,0 +1,47 @@
+/*
+ * Intel MIC Platform Software Stack (MPSS)
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#ifndef _MIC_X100_HW_H_
+#define _MIC_X100_HW_H_
+
+#define MIC_X100_PCI_DEVICE_2250 0x2250
+#define MIC_X100_PCI_DEVICE_2251 0x2251
+#define MIC_X100_PCI_DEVICE_2252 0x2252
+#define MIC_X100_PCI_DEVICE_2253 0x2253
+#define MIC_X100_PCI_DEVICE_2254 0x2254
+#define MIC_X100_PCI_DEVICE_2255 0x2255
+#define MIC_X100_PCI_DEVICE_2256 0x2256
+#define MIC_X100_PCI_DEVICE_2257 0x2257
+#define MIC_X100_PCI_DEVICE_2258 0x2258
+#define MIC_X100_PCI_DEVICE_2259 0x2259
+#define MIC_X100_PCI_DEVICE_225a 0x225a
+#define MIC_X100_PCI_DEVICE_225b 0x225b
+#define MIC_X100_PCI_DEVICE_225c 0x225c
+#define MIC_X100_PCI_DEVICE_225d 0x225d
+#define MIC_X100_PCI_DEVICE_225e 0x225e
+
+#define MIC_X100_APER_BAR 0
+#define MIC_X100_MMIO_BAR 4
+
+#define MIC_X100_SBOX_BASE_ADDRESS 0x00010000
+#define MIC_X100_SBOX_SPAD0 0x0000AB20
+extern struct mic_hw_ops mic_x100_ops;
+
+#endif
-- 
1.8.2.1

