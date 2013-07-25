Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3GYDfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 23:35:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:39483 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab3GYDfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 23:35:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,740,1367996400"; 
   d="scan'208";a="376039745"
From: Sudeep Dutt <sudeep.dutt@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org
Cc: Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>
Subject: [PATCH 1/5] Intel MIC Host Driver for X100 family.
Date: Wed, 24 Jul 2013 20:31:32 -0700
Message-Id: <be8c714ed743143c427058fc0b75722f2eeeee1c.1374717252.git.sudeep.dutt@intel.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1374717252.git.sudeep.dutt@intel.com>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
In-Reply-To: <cover.1374717252.git.sudeep.dutt@intel.com>
References: <cover.1374717252.git.sudeep.dutt@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the following:
a) Initializes the Intel MIC X100 PCIe devices.
b) Boots and shuts down the card via sysfs entries.
c) Allocates and maps a device page for communication with the
card driver and updates the device page address via scratchpad
registers.
d) Provides sysfs entries for family, stepping, state, shutdown
status, kernel command line, IP address, ramdisk and log buffer
information.

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
 drivers/misc/Kconfig                 |    1 +
 drivers/misc/Makefile                |    1 +
 drivers/misc/mic/Kconfig             |   19 +
 drivers/misc/mic/Makefile            |    5 +
 drivers/misc/mic/common/mic_device.h |   81 +++
 drivers/misc/mic/host/Makefile       |   11 +
 drivers/misc/mic/host/mic_boot.c     |  179 ++++++
 drivers/misc/mic/host/mic_common.h   |   37 ++
 drivers/misc/mic/host/mic_debugfs.c  |  366 ++++++++++++
 drivers/misc/mic/host/mic_debugfs.h  |   34 ++
 drivers/misc/mic/host/mic_device.h   |  280 +++++++++
 drivers/misc/mic/host/mic_main.c     | 1095 ++++++++++++++++++++++++++++++++++
 drivers/misc/mic/host/mic_smpt.c     |  441 ++++++++++++++
 drivers/misc/mic/host/mic_smpt.h     |  103 ++++
 drivers/misc/mic/host/mic_sysfs.c    |  360 +++++++++++
 drivers/misc/mic/host/mic_x100.c     |  665 +++++++++++++++++++++
 drivers/misc/mic/host/mic_x100.h     |  112 ++++
 include/uapi/linux/Kbuild            |    1 +
 include/uapi/linux/mic_common.h      |   79 +++
 19 files changed, 3870 insertions(+)
 create mode 100644 drivers/misc/mic/Kconfig
 create mode 100644 drivers/misc/mic/Makefile
 create mode 100644 drivers/misc/mic/common/mic_device.h
 create mode 100644 drivers/misc/mic/host/Makefile
 create mode 100644 drivers/misc/mic/host/mic_boot.c
 create mode 100644 drivers/misc/mic/host/mic_common.h
 create mode 100644 drivers/misc/mic/host/mic_debugfs.c
 create mode 100644 drivers/misc/mic/host/mic_debugfs.h
 create mode 100644 drivers/misc/mic/host/mic_device.h
 create mode 100644 drivers/misc/mic/host/mic_main.c
 create mode 100644 drivers/misc/mic/host/mic_smpt.c
 create mode 100644 drivers/misc/mic/host/mic_smpt.h
 create mode 100644 drivers/misc/mic/host/mic_sysfs.c
 create mode 100644 drivers/misc/mic/host/mic_x100.c
 create mode 100644 drivers/misc/mic/host/mic_x100.h
 create mode 100644 include/uapi/linux/mic_common.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index c002d86..09fcca9 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -536,4 +536,5 @@ source "drivers/misc/carma/Kconfig"
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
index 0000000..24934b1
--- /dev/null
+++ b/drivers/misc/mic/common/mic_device.h
@@ -0,0 +1,81 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Disclaimer: The codes contained in these modules may be specific to
+ * the Intel Software Development Platform codenamed: Knights Ferry, and
+ * the Intel product codenamed: Knights Corner, and are not backward
+ * compatible with other Intel products. Additionally, Intel will NOT
+ * support the codes or instruction set in future products.
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
+/**
+ * mic_mmio_read() - read from an MMIO register.
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
+ * mic_mmio_write() - write to an MMIO register.
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
+/*
+ * Scratch pad register offsets used by the host to communicate
+ * device page DMA address to the card.
+ */
+#define MIC_DPLO_SPAD 14
+#define MIC_DPHI_SPAD 15
+
+#endif
diff --git a/drivers/misc/mic/host/Makefile b/drivers/misc/mic/host/Makefile
new file mode 100644
index 0000000..0608bbb
--- /dev/null
+++ b/drivers/misc/mic/host/Makefile
@@ -0,0 +1,11 @@
+#
+# Makefile - Intel MIC Linux driver.
+# Copyright(c) 2013, Intel Corporation.
+#
+obj-$(CONFIG_INTEL_MIC_HOST) += mic_host.o
+mic_host-objs := mic_main.o
+mic_host-objs += mic_x100.o
+mic_host-objs += mic_sysfs.o
+mic_host-objs += mic_boot.o
+mic_host-objs += mic_smpt.o
+mic_host-objs += mic_debugfs.o
diff --git a/drivers/misc/mic/host/mic_boot.c b/drivers/misc/mic/host/mic_boot.c
new file mode 100644
index 0000000..6485a87
--- /dev/null
+++ b/drivers/misc/mic/host/mic_boot.c
@@ -0,0 +1,179 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
+
+#include "mic_common.h"
+
+/**
+ * mic_reset - Reset the MIC device.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_reset(struct mic_device *mdev)
+{
+	int i;
+
+#define MIC_RESET_TO (45)
+
+	mdev->ops->reset_fw_ready(mdev);
+	mdev->ops->reset(mdev);
+
+	for (i = 0; i < MIC_RESET_TO; i++) {
+		if (mdev->ops->is_fw_ready(mdev))
+			return;
+		/*
+		 * Resets typically take 10s of seconds to complete.
+		 * Since an MMIO read is required to check if the
+		 * firmware is ready or not, a 1 second delay works nicely.
+		 */
+		msleep(1000);
+	}
+	mic_set_state(mdev, MIC_RESET_FAILED);
+}
+
+/* Initialize the MIC bootparams */
+void mic_bootparam_init(struct mic_device *mdev)
+{
+	struct mic_bootparam *bootparam = mdev->dp;
+
+	bootparam->magic = MIC_MAGIC;
+	bootparam->c2h_shutdown_db = mdev->shutdown_db;
+	bootparam->h2c_shutdown_db = -1;
+	bootparam->h2c_config_db = -1;
+	bootparam->shutdown_status = 0;
+	bootparam->shutdown_card = 0;
+}
+
+/**
+ * mic_start - Start the MIC.
+ * @mdev: pointer to mic_device instance
+ * @buf: buffer containing boot string including firmware/ramdisk path.
+ *
+ * This function prepares an MIC for boot and initiates boot.
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+int mic_start(struct mic_device *mdev, const char *buf)
+{
+	int rc;
+	mutex_lock(&mdev->mic_mutex);
+	if (MIC_OFFLINE != mdev->state) {
+		rc = -EINVAL;
+		goto unlock_ret;
+	}
+	rc = mdev->ops->load_mic_fw(mdev, buf);
+	if (rc)
+		goto unlock_ret;
+	mic_smpt_restore(mdev);
+	mic_intr_restore(mdev);
+	mdev->intr_ops->enable_interrupts(mdev);
+	mdev->ops->write_spad(mdev, MIC_DPLO_SPAD, mdev->dp_dma_addr);
+	mdev->ops->write_spad(mdev, MIC_DPHI_SPAD, mdev->dp_dma_addr >> 32);
+	mdev->ops->send_firmware_intr(mdev);
+	mic_set_state(mdev, MIC_ONLINE);
+unlock_ret:
+	mutex_unlock(&mdev->mic_mutex);
+	return rc;
+}
+
+/**
+ * mic_stop - Prepare the MIC for reset and trigger reset.
+ * @mdev: pointer to mic_device instance
+ * @force: force a MIC to reset even if it is already offline.
+ *
+ * RETURNS: None.
+ */
+void mic_stop(struct mic_device *mdev, bool force)
+{
+	mutex_lock(&mdev->mic_mutex);
+	if (MIC_OFFLINE != mdev->state || force) {
+		mic_bootparam_init(mdev);
+		mic_reset(mdev);
+		if (MIC_RESET_FAILED == mdev->state)
+			goto unlock;
+		mic_set_shutdown_status(mdev, MIC_NOP);
+		mic_set_state(mdev, MIC_OFFLINE);
+	}
+unlock:
+	mutex_unlock(&mdev->mic_mutex);
+}
+
+/**
+ * mic_shutdown - Initiate MIC shutdown.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: None.
+ */
+void mic_shutdown(struct mic_device *mdev)
+{
+	struct mic_bootparam *bootparam = mdev->dp;
+	s8 db = bootparam->h2c_shutdown_db;
+
+	mutex_lock(&mdev->mic_mutex);
+	if (MIC_ONLINE == mdev->state && db != -1) {
+		bootparam->shutdown_card = 1;
+		mdev->ops->send_intr(mdev, db);
+		mic_set_state(mdev, MIC_SHUTTING_DOWN);
+	}
+	mutex_unlock(&mdev->mic_mutex);
+}
+
+/**
+ * mic_shutdown_work - Handle shutdown interrupt from MIC.
+ * @work: The work structure.
+ *
+ * This work is scheduled whenever the host has received a shutdown
+ * interrupt from the MIC.
+ */
+void mic_shutdown_work(struct work_struct *work)
+{
+	struct mic_device *mdev = container_of(work, struct mic_device,
+			shutdown_work);
+	struct mic_bootparam *bootparam = mdev->dp;
+
+	mutex_lock(&mdev->mic_mutex);
+	mic_set_shutdown_status(mdev, bootparam->shutdown_status);
+	bootparam->shutdown_status = 0;
+	if (MIC_SHUTTING_DOWN != mdev->state)
+		mic_set_state(mdev, MIC_SHUTTING_DOWN);
+	mutex_unlock(&mdev->mic_mutex);
+}
+
+/**
+ * mic_reset_trigger_work - Trigger MIC reset.
+ * @work: The work structure.
+ *
+ * This work is scheduled whenever the host wants to reset the MIC.
+ */
+void mic_reset_trigger_work(struct work_struct *work)
+{
+	struct mic_device *mdev = container_of(work, struct mic_device,
+			reset_trigger_work);
+
+	mic_stop(mdev, false);
+}
diff --git a/drivers/misc/mic/host/mic_common.h b/drivers/misc/mic/host/mic_common.h
new file mode 100644
index 0000000..e0bf3a8
--- /dev/null
+++ b/drivers/misc/mic/host/mic_common.h
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#ifndef _MIC_HOST_COMMON_H_
+#define _MIC_HOST_COMMON_H_
+
+#include <linux/cdev.h>
+#include <linux/mic_common.h>
+
+#include "../common/mic_device.h"
+#include "mic_device.h"
+#include "mic_x100.h"
+#include "mic_smpt.h"
+
+#endif
diff --git a/drivers/misc/mic/host/mic_debugfs.c b/drivers/misc/mic/host/mic_debugfs.c
new file mode 100644
index 0000000..5b7697e
--- /dev/null
+++ b/drivers/misc/mic/host/mic_debugfs.c
@@ -0,0 +1,366 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+
+#include "mic_common.h"
+#include "mic_debugfs.h"
+
+/* Debugfs parent dir */
+static struct dentry *mic_dbg;
+
+/**
+ * log_buf_seq_show - Display MIC kernel log buffer.
+ *
+ * log_buf addr/len is read from System.map by user space
+ * and populated in sysfs entries.
+ */
+static int log_buf_seq_show(struct seq_file *s, void *unused)
+{
+	void __iomem *log_buf_va;
+	int __iomem *log_buf_len_va;
+	struct mic_device *mdev = s->private;
+	void *kva;
+	int size;
+	unsigned long aper_offset;
+
+	if (!mdev || !mdev->log_buf_addr || !mdev->log_buf_len)
+		goto done;
+	/*
+	 * Card kernel will never be relocated and any kernel text/data mapping
+	 * can be translated to phys address by subtracting __START_KERNEL_map.
+	 */
+	aper_offset = (unsigned long)mdev->log_buf_len - __START_KERNEL_map;
+	log_buf_len_va = mdev->aper.va + aper_offset;
+	aper_offset = (unsigned long)mdev->log_buf_addr - __START_KERNEL_map;
+	log_buf_va = mdev->aper.va + aper_offset;
+	size = ioread32(log_buf_len_va);
+
+	kva = kmalloc(size, GFP_KERNEL);
+	if (!kva)
+		goto done;
+	mutex_lock(&mdev->mic_mutex);
+	memcpy_fromio(kva, log_buf_va, size);
+	switch (mdev->state) {
+	case MIC_ONLINE:
+		/* Fall through */
+	case MIC_SHUTTING_DOWN:
+		seq_write(s, kva, size);
+		break;
+	default:
+		break;
+	}
+	mutex_unlock(&mdev->mic_mutex);
+	kfree(kva);
+done:
+	return 0;
+}
+
+static int log_buf_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, log_buf_seq_show, inode->i_private);
+}
+
+static int log_buf_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations log_buf_ops = {
+	.owner   = THIS_MODULE,
+	.open    = log_buf_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = log_buf_release
+};
+
+static int smpt_seq_show(struct seq_file *s, void *pos)
+{
+	int i;
+	struct mic_device *mdev = s->private;
+	unsigned long flags;
+
+	seq_printf(s, "MIC %-2d |%-10s| %-14s %-10s %-10s %-10s %-10s\n",
+		mdev->id, "SMPT entry", "SW DMA addr",
+		"RefCount", "Register", "Snoop", "RegDMAAddr");
+	seq_puts(s, "====================================================\n");
+
+	if (mdev->smpt) {
+		struct mic_smpt_info *smpt_info = mdev->smpt;
+		spin_lock_irqsave(&smpt_info->smpt_lock, flags);
+		for (i = 0; i < smpt_info->info.num_reg; i++) {
+			u32 val = mic_mmio_read(&mdev->mmio,
+				MIC_X100_SBOX_BASE_ADDRESS +
+				MIC_X100_SBOX_SMPT00 + (4 * i));
+			seq_printf(s, "%9s|%-10d| %-#14llx %-10lld %-#10x",
+				" ",  i, smpt_info->entry[i].dma_addr,
+				smpt_info->entry[i].ref_count, val);
+			seq_printf(s, " %-10s 0x%llx\n",
+				(val & 0x1) ? "OFF" : "ON",
+				((u64)val >> 2ULL) <<
+				smpt_info->info.page_shift);
+		}
+		spin_unlock_irqrestore(&smpt_info->smpt_lock, flags);
+	}
+	seq_puts(s, "====================================================\n");
+	return 0;
+}
+
+static int smpt_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, smpt_seq_show, inode->i_private);
+}
+
+static int smpt_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations smpt_file_ops = {
+	.owner   = THIS_MODULE,
+	.open    = smpt_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = smpt_debug_release
+};
+
+static int soft_reset_seq_show(struct seq_file *s, void *pos)
+{
+	struct mic_device *mdev = s->private;
+
+	mic_stop(mdev, true);
+	return 0;
+}
+
+static int soft_reset_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, soft_reset_seq_show, inode->i_private);
+}
+
+static int soft_reset_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations soft_reset_ops = {
+	.owner   = THIS_MODULE,
+	.open    = soft_reset_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = soft_reset_debug_release
+};
+
+static int post_code_seq_show(struct seq_file *s, void *pos)
+{
+	struct mic_device *mdev = s->private;
+	u32 reg = mdev->ops->get_postcode(mdev);
+
+	seq_printf(s, "%c%c", reg & 0xff, (reg >> 8) & 0xff);
+	return 0;
+}
+
+static int post_code_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, post_code_seq_show, inode->i_private);
+}
+
+static int post_code_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations post_code_ops = {
+	.owner   = THIS_MODULE,
+	.open    = post_code_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = post_code_debug_release
+};
+
+static int dp_seq_show(struct seq_file *s, void *pos)
+{
+	struct mic_device *mdev = s->private;
+	struct mic_bootparam *bootparam = mdev->dp;
+
+	seq_printf(s, "Bootparam: magic 0x%x\n",
+		bootparam->magic);
+	seq_printf(s, "Bootparam: h2c_shutdown_db %d\n",
+		bootparam->h2c_shutdown_db);
+	seq_printf(s, "Bootparam: h2c_config_db %d\n",
+		bootparam->h2c_config_db);
+	seq_printf(s, "Bootparam: c2h_shutdown_db %d\n",
+		bootparam->c2h_shutdown_db);
+	seq_printf(s, "Bootparam: shutdown_status %d\n",
+		bootparam->shutdown_status);
+	seq_printf(s, "Bootparam: shutdown_card %d\n",
+		bootparam->shutdown_card);
+
+	return 0;
+}
+
+static int dp_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dp_seq_show, inode->i_private);
+}
+
+static int dp_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations dp_ops = {
+	.owner   = THIS_MODULE,
+	.open    = dp_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = dp_debug_release
+};
+
+static int msi_irq_info_seq_show(struct seq_file *s, void *pos)
+{
+	struct mic_device *mdev  = s->private;
+	int reg;
+	int i, j;
+	u16 entry;
+	u16 vector;
+
+	if (pci_dev_msi_enabled(mdev->pdev)) {
+		for (i = 0; i < mdev->irq_info.num_vectors; i++) {
+			if (mdev->pdev->msix_enabled) {
+				entry = mdev->irq_info.msix_entries[i].entry;
+				vector = mdev->irq_info.msix_entries[i].vector;
+			} else {
+				entry = 0;
+				vector = mdev->pdev->irq;
+			}
+
+			reg = mdev->intr_ops->read_msi_to_src_map(mdev, entry);
+
+			seq_printf(s, "%s %-10d %s %-10d MXAR[%d]: %08X\n",
+				"IRQ:", vector, "Entry:", entry, i, reg);
+
+			seq_printf(s, "%-10s", "offset:");
+			for (j = (MIC_NUM_OFFSETS - 1); j >= 0; j--)
+				seq_printf(s, "%4d ", j);
+			seq_puts(s, "\n");
+
+
+			seq_printf(s, "%-10s", "count:");
+			for (j = (MIC_NUM_OFFSETS - 1); j >= 0; j--)
+				seq_printf(s, "%4d ",
+				(mdev->irq_info.mic_msi_map[i] & BIT(j)) ?
+					1 : 0);
+			seq_puts(s, "\n\n");
+		}
+	} else {
+		seq_puts(s, "MSI/MSIx interrupts not enabled\n");
+	}
+
+	return 0;
+
+}
+
+static int msi_irq_info_debug_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, msi_irq_info_seq_show, inode->i_private);
+}
+
+static int msi_irq_info_debug_release(struct inode *inode, struct file *file)
+{
+	return single_release(inode, file);
+}
+
+static const struct file_operations msi_irq_info_ops = {
+	.owner   = THIS_MODULE,
+	.open    = msi_irq_info_debug_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = msi_irq_info_debug_release
+};
+
+/**
+ * mic_create_debug_dir - Initialize MIC debugfs entries.
+ */
+void __init mic_create_debug_dir(struct mic_device *mdev)
+{
+	if (!mic_dbg)
+		return;
+
+	mdev->dbg_dir = debugfs_create_dir(mdev->name, mic_dbg);
+	if (!mdev->dbg_dir)
+		return;
+
+	debugfs_create_file("log_buf", 0444, mdev->dbg_dir,
+		mdev, &log_buf_ops);
+
+	debugfs_create_file("smpt", 0444, mdev->dbg_dir,
+		mdev, &smpt_file_ops);
+
+	debugfs_create_file("soft_reset", 0444, mdev->dbg_dir,
+		mdev, &soft_reset_ops);
+
+	debugfs_create_file("post_code", 0444, mdev->dbg_dir,
+		mdev, &post_code_ops);
+
+	debugfs_create_file("dp", 0444, mdev->dbg_dir,
+		mdev, &dp_ops);
+
+	debugfs_create_file("msi_irq_info", 0444, mdev->dbg_dir,
+		mdev, &msi_irq_info_ops);
+}
+
+/**
+ * mic_delete_debug_dir - Uninitialize MIC debugfs entries.
+ */
+void mic_delete_debug_dir(struct mic_device *mdev)
+{
+	if (!mdev->dbg_dir)
+		return;
+
+	debugfs_remove_recursive(mdev->dbg_dir);
+}
+
+/**
+ * mic_init_debugfs - Initialize global debugfs entry.
+ */
+void __init mic_init_debugfs(void)
+{
+	mic_dbg = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	if (!mic_dbg)
+		pr_err("can't create debugfs dir\n");
+}
+
+/**
+ * mic_exit_debugfs - Uninitialize global debugfs entry
+ */
+void mic_exit_debugfs(void)
+{
+	debugfs_remove(mic_dbg);
+}
diff --git a/drivers/misc/mic/host/mic_debugfs.h b/drivers/misc/mic/host/mic_debugfs.h
new file mode 100644
index 0000000..ee9241c
--- /dev/null
+++ b/drivers/misc/mic/host/mic_debugfs.h
@@ -0,0 +1,34 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#ifndef _MIC_DEBUGFS_H_
+#define _MIC_DEBUGFS_H_
+
+void __init mic_create_debug_dir(struct mic_device *dev);
+void mic_delete_debug_dir(struct mic_device *dev);
+void __init mic_init_debugfs(void);
+void mic_exit_debugfs(void);
+
+#endif
diff --git a/drivers/misc/mic/host/mic_device.h b/drivers/misc/mic/host/mic_device.h
new file mode 100644
index 0000000..dd15837
--- /dev/null
+++ b/drivers/misc/mic/host/mic_device.h
@@ -0,0 +1,280 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
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
+#define MIC_MAX_NUM_DEVS 256
+#define MIC_NUM_INTR_TYPES 3
+#define MIC_SHUTDOWN_TIMEOUT (60 * HZ)
+#define MIC_MUTEX_HELD	true
+
+/* The minimum number of msix vectors required
+ * for normal operation */
+#define MIC_MIN_MSIX 5
+
+/**
+ * struct mic_intr_info - Contains h/w specific interrupt sources info
+ *
+ * @intr_start_idx: Contains the starting indexes of the
+ * interrupt types.
+ * @intr_len: Contains the length of the interrupt types.
+ */
+struct mic_intr_info {
+	u16 intr_start_idx[MIC_NUM_INTR_TYPES];
+	u16 intr_len[MIC_NUM_INTR_TYPES];
+};
+
+/**
+ * mic_intr_source - The type of source that will generate
+ * the interrupt.The number of types needs to be in sync with
+ * MIC_NUM_INTR_TYPES
+ *
+ * MIC_INTR_DB: The source is a doorbell
+ * MIC_INTR_DMA: The source is a DMA channel
+ * MIC_INTR_ERR: The source is an error interrupt e.g. SBOX ERR
+ */
+enum mic_intr_type {
+	MIC_INTR_DB = 0,
+	MIC_INTR_DMA,
+	MIC_INTR_ERR,
+};
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
+ * struct mic_irq_info - OS specific irq information
+ *
+ * @next_avail_src: next available doorbell that can be assigned.
+ * @msix_entries: msix entries allocated while setting up MSI-x
+ * @mic_msi_map: The MSI/MSI-x mapping information.
+ * @num_vectors: The number of MSI/MSI-x vectors that have been allocated.
+ * @cb_id: Running count of the number of callbacks registered.
+ * @mic_intr_lock: spinlock to protect the interrupt callback list.
+ * @cb_list: Array of callback lists one for each source.
+ */
+struct mic_irq_info {
+	int next_avail_src;
+	struct msix_entry *msix_entries;
+	u32 *mic_msi_map;
+	u16 num_vectors;
+	u32 cb_id;
+	spinlock_t mic_intr_lock;
+	struct list_head *cb_list;
+};
+
+/**
+ * struct mic_intr_cb - Interrupt callback structure.
+ *
+ * @func: The callback function
+ * @data: Private data of the requester.
+ * @cb_id: The callback id. Identifies this callback.
+ * @list: list head pointing to the next callback structure.
+ */
+struct mic_intr_cb {
+	irqreturn_t (*func) (int irq, void *data);
+	void *data;
+	u32 cb_id;
+	struct list_head list;
+};
+
+/**
+ * struct mic_irq - opaque pointer used as cookie
+ */
+struct mic_irq;
+
+/**
+ * struct mic_device -  MIC device information for each card.
+ *
+ * @name: Unique name for this MIC device.
+ * @mmio: MMIO bar information.
+ * @dbg_dir: debugfs directory of this MIC device.
+ * @pdev: The PCI device structure.
+ * @mic_mutex: Mutex for synchronizing access to mic_device.
+ * @family: The MIC family to which this device belongs.
+ * @ops: MIC HW specific operations.
+ * @intr_ops: HW specific interrupt operations.
+ * @smpt_ops: Hardware specific SMPT operations.
+ * @id: The unique device id for this MIC device.
+ * @stepping: Stepping ID.
+ * @attr_group: Sysfs attribute group.
+ * @dev: Device for sysfs entries.
+ * @aper: Aperture bar information.
+ * @smpt: MIC SMPT information.
+ * @intr_info: H/W specific interrupt information.
+ * @cmdline: Kernel command line.
+ * @ipaddr: IP address for this device.
+ * @firmware: Firmware file name.
+ * @ramdisk: Ramdisk file name.
+ * @bootaddr: MIC boot address.
+ * @reset_trigger_work: Work for triggering reset requests.
+ * @shutdown_work: Work for handling shutdown interrupts.
+ * @state: MIC state.
+ * @shutdown_status: MIC status reported by card for shutdown/crashes.
+ * @state_sysfs: Sysfs dirent for notifying ring 3 about MIC state changes.
+ * @reset_wait: Waitqueue for sleeping while reset completes.
+ * @log_buf_addr: Log buffer address for MIC.
+ * @log_buf_len: Log buffer length address for MIC.
+ * @dp: virtio device page
+ * @dp_dma_addr: virtio device page DMA address.
+ * @vdev_list: list of virtio devices.
+ * @default_attrs: Sysfs attributes.
+ * @cdev: Character device for MIC.
+ * @irq_info: The OS specific irq information
+ * @shutdown_db: shutdown doorbell.
+ * @shutdown_cookie: shutdown cookie.
+ */
+struct mic_device {
+	char name[20];
+	struct mic_mw mmio;
+	struct dentry *dbg_dir;
+	struct pci_dev *pdev;
+	struct mutex mic_mutex;
+	enum mic_hw_family family;
+	struct mic_hw_ops *ops;
+	struct mic_hw_intr_ops *intr_ops;
+	struct mic_smpt_ops *smpt_ops;
+	int id;
+	enum mic_stepping stepping;
+	struct attribute_group attr_group;
+	struct device *dev;
+	struct mic_mw aper;
+	struct mic_smpt_info *smpt;
+	struct mic_intr_info *intr_info;
+	char *cmdline;
+	char *ipaddr;
+	char *firmware;
+	char *ramdisk;
+	u32 bootaddr;
+	struct work_struct reset_trigger_work;
+	struct work_struct shutdown_work;
+	u8 state;
+	u8 shutdown_status;
+	struct sysfs_dirent *state_sysfs;
+	struct completion reset_wait;
+	void *log_buf_addr;
+	int *log_buf_len;
+	void *dp;
+	dma_addr_t dp_dma_addr;
+	struct list_head vdev_list;
+	struct attribute **default_attrs;
+	struct cdev cdev;
+	struct mic_irq_info irq_info;
+	int shutdown_db;
+	struct mic_irq *shutdown_cookie;
+};
+
+/**
+ * struct mic_hw_intr_ops: MIC HW specific interrupt operations
+ * @intr_init: Initialize H/W specific interrupt information.
+ * @enable_interrupts: Enable interrupts from the hardware.
+ * @disable_interrupts: Disable interrupts from the hardware.
+ * @program_msi_to_src_map: Update MSI mapping registers with
+ * irq information.
+ * @read_msi_to_src_map: Read MSI mapping registers containing
+ * irq information.
+ */
+struct mic_hw_intr_ops {
+	void (*intr_init)(struct mic_device *mdev);
+	void (*enable_interrupts)(struct mic_device *mdev);
+	void (*disable_interrupts)(struct mic_device *mdev);
+	void (*program_msi_to_src_map) (struct mic_device *mdev,
+			int idx, int intr_src, bool set);
+	u32 (*read_msi_to_src_map) (struct mic_device *mdev,
+			int idx);
+};
+
+/**
+ * struct mic_hw_ops - MIC HW specific operations.
+ * @aper_bar: Aperture bar resource number.
+ * @mmio_bar: MMIO bar resource number.
+ * @init: Initialize the MIC HW information.
+ * @read_spad: Read from scratch pad register.
+ * @write_spad: Write to scratch pad register.
+ * @reset: Reset the remote processor.
+ * @reset_fw_ready: Reset firmware ready field.
+ * @is_fw_ready: Check if firmware is ready for OS download.
+ * @send_firmware_intr: Send an interrupt to the card firmware.
+ * @send_intr: Send an interrupt for a particular doorbell on the card.
+ * @ack_interrupt: Hardware specific operations to ack the h/w on
+ * receipt of an interrupt.
+ * @load_mic_fw: Load firmware segments required to boot the card
+ * into card memory. This includes the kernel, command line, ramdisk etc.
+ * @get_postcode: Get post code status from firmware.
+ */
+struct mic_hw_ops {
+	u8 aper_bar;
+	u8 mmio_bar;
+	void (*init)(struct mic_device *mdev);
+	u32 (*read_spad)(struct mic_device *mdev, unsigned int idx);
+	void (*write_spad)(struct mic_device *mdev, u32 idx, u32 val);
+	void (*reset)(struct mic_device *mdev);
+	void (*reset_fw_ready)(struct mic_device *mdev);
+	bool (*is_fw_ready)(struct mic_device *mdev);
+	void (*send_firmware_intr)(struct mic_device *mdev);
+	void (*send_intr)(struct mic_device *mdev, int doorbell);
+	u32 (*ack_interrupt)(struct mic_device *mdev);
+	int (*load_mic_fw)(struct mic_device *mdev, const char *buf);
+	u32 (*get_postcode)(struct mic_device *mdev);
+};
+
+int mic_start(struct mic_device *mdev, const char *buf);
+void mic_stop(struct mic_device *mdev, bool force);
+void mic_shutdown(struct mic_device *mdev);
+void mic_reset_delayed_work(struct work_struct *work);
+void mic_reset_trigger_work(struct work_struct *work);
+void mic_shutdown_work(struct work_struct *work);
+
+int mic_next_db(struct mic_device *mdev);
+struct mic_irq *mic_request_irq(struct mic_device *mdev,
+	irqreturn_t (*func)(int irq, void *data),
+	const char *name, void *data, int intr_src,
+	enum mic_intr_type type);
+
+void mic_free_irq(struct mic_device *mdev,
+		struct mic_irq *cookie, void *data);
+void mic_intr_restore(struct mic_device *mdev);
+
+void mic_sysfs_init(struct mic_device *mdev);
+void mic_bootparam_init(struct mic_device *mdev);
+void mic_set_state(struct mic_device *mdev, u8 state);
+void mic_set_shutdown_status(struct mic_device *mdev, u8 status);
+#endif
diff --git a/drivers/misc/mic/host/mic_main.c b/drivers/misc/mic/host/mic_main.c
new file mode 100644
index 0000000..70cc235
--- /dev/null
+++ b/drivers/misc/mic/host/mic_main.c
@@ -0,0 +1,1095 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
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
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <linux/firmware.h>
+#include <linux/completion.h>
+#include <linux/poll.h>
+
+#include "mic_common.h"
+#include "mic_debugfs.h"
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
+/**
+ * struct mic_info -  Global information about all MIC devices.
+ *
+ * @next_id: Next available MIC device id.
+ * @mic_class: Class of MIC devices for sysfs accessibility.
+ * @dev: Range for device node numbers.
+ */
+struct mic_info {
+	int next_id;
+	struct class *mic_class;
+	dev_t dev;
+};
+
+/* g_mic - Global information about all MIC devices. */
+static struct mic_info g_mic;
+
+/* Initialize the device page */
+static int mic_dp_init(struct mic_device *mdev)
+{
+	mdev->dp = kzalloc(MIC_DP_SIZE, GFP_KERNEL);
+	if (!mdev->dp) {
+		dev_err(&mdev->pdev->dev, "%s %d err %d\n",
+			__func__, __LINE__, -ENOMEM);
+		return -ENOMEM;
+	}
+
+	mdev->dp_dma_addr = mic_map_single(mdev,
+		mdev->dp, MIC_DP_SIZE);
+	if (mic_map_error(mdev->dp_dma_addr)) {
+		kfree(mdev->dp);
+		dev_err(&mdev->pdev->dev, "%s %d err %d\n",
+			__func__, __LINE__, -ENOMEM);
+		return -ENOMEM;
+	}
+	mdev->ops->write_spad(mdev, MIC_DPLO_SPAD, mdev->dp_dma_addr);
+	mdev->ops->write_spad(mdev, MIC_DPHI_SPAD, mdev->dp_dma_addr >> 32);
+	return 0;
+}
+
+/* Uninitialize the device page */
+static void mic_dp_uninit(struct mic_device *mdev)
+{
+	mic_unmap_single(mdev, mdev->dp_dma_addr, MIC_DP_SIZE);
+	kfree(mdev->dp);
+}
+
+/**
+ * mic_shutdown_db - Shutdown doorbell interrupt handler.
+ */
+static irqreturn_t mic_shutdown_db(int irq, void *data)
+{
+	struct mic_device *mdev = data;
+	struct mic_bootparam *bootparam = mdev->dp;
+
+	mdev->ops->ack_interrupt(mdev);
+
+	switch (bootparam->shutdown_status) {
+	case MIC_HALTED:
+	case MIC_POWER_OFF:
+	case MIC_RESTART:
+		/* Fall through */
+	case MIC_CRASHED:
+		schedule_work(&mdev->shutdown_work);
+		break;
+	default:
+		break;
+	};
+	return IRQ_HANDLED;
+}
+
+/*
+ * mic_invoke_callback - Invoke callback functions registered for
+ * the corresponding source id.
+ *
+ * @mdev: pointer to the mic_device instance
+ * @idx: The interrupt source id.
+ *
+ * Returns none.
+ */
+static inline void mic_invoke_callback(struct mic_device *mdev, int idx)
+{
+	struct mic_intr_cb *intr_cb;
+
+	spin_lock(&mdev->irq_info.mic_intr_lock);
+	list_for_each_entry(intr_cb, &mdev->irq_info.cb_list[idx], list)
+		if (intr_cb->func)
+			intr_cb->func(mdev->pdev->irq, intr_cb->data);
+	spin_unlock(&mdev->irq_info.mic_intr_lock);
+}
+
+/**
+ * mic_interrupt - Generic interrupt handler for
+ * MSI and INTx based interrupts.
+ */
+static irqreturn_t mic_interrupt(int irq, void *dev)
+{
+	struct mic_device *mdev = dev;
+	struct mic_intr_info *info = mdev->intr_info;
+	u32 mask;
+	int i;
+
+	mask = mdev->ops->ack_interrupt(mdev);
+	if (!mask)
+		return IRQ_NONE;
+
+	for (i = info->intr_start_idx[MIC_INTR_DB];
+			i < info->intr_len[MIC_INTR_DB]; i++)
+		if (mask & BIT(i))
+			mic_invoke_callback(mdev, i);
+
+	return IRQ_HANDLED;
+}
+
+/* Retrieve the next doorbell interrupt source. */
+int mic_next_db(struct mic_device *mdev)
+{
+	int next_db;
+
+	next_db = mdev->irq_info.next_avail_src %
+		mdev->intr_info->intr_len[MIC_INTR_DB];
+	mdev->irq_info.next_avail_src++;
+	return next_db;
+}
+
+/* Return the interrupt offset from the index. Index is 0 based. */
+static u16 map_src_to_offset(struct mic_device *mdev,
+		int intr_src, enum mic_intr_type type) {
+
+	if (type >= MIC_NUM_INTR_TYPES)
+		return MIC_NUM_OFFSETS;
+
+	if (intr_src >= mdev->intr_info->intr_len[type])
+		return MIC_NUM_OFFSETS;
+
+	return mdev->intr_info->intr_start_idx[type] + intr_src;
+}
+
+/* Return next available msix_entry. */
+static struct msix_entry *mic_get_available_vector(struct mic_device *mdev)
+{
+	int i;
+	struct mic_irq_info *info = &mdev->irq_info;
+
+	for (i = 0; i < info->num_vectors; i++) {
+		if (!info->mic_msi_map[i])
+			return &info->msix_entries[i];
+	}
+	return NULL;
+}
+
+/**
+ * mic_intr_restore - Restore h/w specific interrupt
+ * registers after a card reset. mic_mutex needs to be
+ * held before calling this function.
+ *
+ */
+void mic_intr_restore(struct mic_device *mdev)
+{
+	int entry, offset;
+
+	if (!pci_dev_msi_enabled(mdev->pdev))
+		return;
+
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+	for (entry = 0; entry < mdev->irq_info.num_vectors; entry++) {
+		for (offset = 0; offset < MIC_NUM_OFFSETS; offset++) {
+			if (mdev->irq_info.mic_msi_map[entry] & BIT(offset))
+				mdev->intr_ops->program_msi_to_src_map(mdev,
+					entry, offset, true);
+		}
+	}
+}
+
+/**
+ * mic_register_intr_callback - Register a callback handler for the
+ * given source id.
+ *
+ * @mdev: pointer to the mic_device instance
+ * @idx: The source id to be registered.
+ * @func: The function to be called when the source id receives
+ * the interrupt.
+ * @data: Private data of the requester.
+ * Return the callback structure that was registered or an
+ * appropriate error on failure.
+ */
+static struct mic_intr_cb *mic_register_intr_callback(struct mic_device *mdev,
+			u8 idx, irqreturn_t (*func) (int irq, void *dev),
+			void *data)
+{
+	struct mic_intr_cb *intr_cb;
+	unsigned long flags;
+	intr_cb = kmalloc(sizeof(struct mic_intr_cb), GFP_KERNEL);
+
+	if (!intr_cb)
+		return ERR_PTR(-ENOMEM);
+
+	intr_cb->func = func;
+	intr_cb->data = data;
+	intr_cb->cb_id = mdev->irq_info.cb_id++;
+
+	spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
+	list_add_tail(&intr_cb->list, &mdev->irq_info.cb_list[idx]);
+	spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
+
+	return intr_cb;
+}
+
+/**
+ * mic_unregister_intr_callback - Unregister the callback handler
+ * identified by its callback id.
+ *
+ * @mdev: pointer to the mic_device instance
+ * @idx: The callback structure id to be unregistered.
+ * Return the source id that was unregistered or MIC_NUM_OFFSETS if no
+ * such callback handler was found.
+ */
+static u8 mic_unregister_intr_callback(struct mic_device *mdev, u32 idx)
+{
+	struct list_head *pos, *tmp;
+	struct mic_intr_cb *intr_cb;
+	unsigned long flags;
+	int i;
+
+	for (i = 0;  i < MIC_NUM_OFFSETS; i++) {
+		spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
+		list_for_each_safe(pos, tmp, &mdev->irq_info.cb_list[i]) {
+			intr_cb = list_entry(pos, struct mic_intr_cb, list);
+			if (intr_cb->cb_id == idx) {
+				list_del(pos);
+				kfree(intr_cb);
+				spin_unlock_irqrestore(
+					&mdev->irq_info.mic_intr_lock, flags);
+				return i;
+			}
+		}
+		spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
+	}
+
+	return MIC_NUM_OFFSETS;
+}
+
+/**
+ * mic_alloc_msi_map - Allocate mapping information for MSI
+ * and MSI-x interrupts.
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ * 0 on success. Appropriate error on failure.
+ */
+static int mic_alloc_msi_map(struct mic_device *mdev)
+{
+	mdev->irq_info.mic_msi_map = kzalloc((sizeof(u32) *
+		mdev->irq_info.num_vectors), GFP_KERNEL);
+
+	if (!mdev->irq_info.mic_msi_map)
+		return -ENOMEM;
+	return 0;
+}
+
+/**
+ * mic_free_msi_map - Free mapping information for MSI
+ * and MSI-x interrupts.
+ *
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_free_msi_map(struct mic_device *mdev)
+{
+	kfree(mdev->irq_info.mic_msi_map);
+}
+
+
+#define COOKIE_ID_SHIFT 16
+#define GET_ENTRY(cookie) ((cookie) & 0xFFFF)
+#define GET_OFFSET(cookie) ((cookie) >> COOKIE_ID_SHIFT)
+#define MK_COOKIE(x, y) ((x) | (y) << COOKIE_ID_SHIFT)
+
+/**
+ * mic_request_irq - request an irq. mic_mutex needs
+ * to be held before calling this function.
+ *
+ * @mdev: pointer to mic_device instance
+ * @func: The callback function that handles the interrupt.
+ * The function needs to call ack_interrupts
+ * (mdev->ops->ack_interrupt(mdev)) when handling the interrupts.
+ * @name: The ASCII name of the callee requesting the irq.
+ * @data: private data that is returned back when calling the
+ * function handler.
+ * @intr_src: The source id of the requester. Its the doorbell id
+ * for Doorbell interrupts and DMA channel id for DMA interrupts.
+ * @type: The type of interrupt. Values defined in mic_intr_type
+ *
+ * returns: The cookie that is transparent to the caller. Passed
+ * back when calling mic_free_irq. An appropriate error code
+ * is returned on failure. Caller needs to use IS_ERR(return_val)
+ * to check for failure and PTR_ERR(return_val) to obtained the
+ * error code.
+ *
+ */
+struct mic_irq *mic_request_irq(struct mic_device *mdev,
+	irqreturn_t (*func)(int irq, void *dev),
+	const char *name, void *data, int intr_src,
+	enum mic_intr_type type) {
+
+	u16 offset;
+	int rc = 0;
+	struct msix_entry *msix = NULL;
+	unsigned long cookie = 0;
+	u16 entry;
+	struct mic_intr_cb *intr_cb;
+
+	if (!mdev) {
+		rc = -EINVAL;
+		goto err;
+	}
+
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+	offset = map_src_to_offset(mdev, intr_src, type);
+	if (offset >= MIC_NUM_OFFSETS) {
+		dev_err(&mdev->pdev->dev,
+				"Error mapping index %d to a valid source id.\n",
+				intr_src);
+		rc = -EINVAL;
+		goto err;
+	}
+
+	if (mdev->irq_info.num_vectors > 1) {
+		msix = mic_get_available_vector(mdev);
+		if (!msix) {
+			dev_err(&mdev->pdev->dev,
+			"No MSIx vectors available for use.\n");
+			rc = -ENOSPC;
+			goto err;
+		}
+
+		rc = request_irq(msix->vector, func, 0, name, data);
+		if (rc) {
+			dev_dbg(&mdev->pdev->dev,
+				"request irq failed rc = %d\n", rc);
+			goto err;
+		}
+
+		entry = msix->entry;
+		mdev->irq_info.mic_msi_map[entry] |= BIT(offset);
+		mdev->intr_ops->program_msi_to_src_map(mdev,
+				entry, offset, true);
+		cookie = MK_COOKIE(entry, offset);
+		dev_dbg(&mdev->pdev->dev, "irq: %d assigned for src: %d\n",
+			msix->vector, intr_src);
+	} else {
+		intr_cb = mic_register_intr_callback(mdev,
+				offset, func, data);
+		if (IS_ERR(intr_cb)) {
+			dev_err(&mdev->pdev->dev,
+			"No available callback entries for use\n");
+			rc = PTR_ERR(intr_cb);
+			goto err;
+		}
+
+		entry = 0;
+		if (pci_dev_msi_enabled(mdev->pdev)) {
+			mdev->irq_info.mic_msi_map[entry] |= (1 << offset);
+			mdev->intr_ops->program_msi_to_src_map(mdev,
+				entry, offset, true);
+		}
+		cookie = MK_COOKIE(entry, intr_cb->cb_id);
+		dev_dbg(&mdev->pdev->dev, "callback %d registered for src: %d\n",
+			intr_cb->cb_id, intr_src);
+	}
+
+	return (struct mic_irq *)cookie;
+err:
+	return ERR_PTR(rc);
+}
+
+/**
+ * mic_free_irq - free irq. mic_mutex
+ *  needs to be held before calling this function.
+ *
+ * @mdev: pointer to mic_device instance
+ * @cookie: cookie obtained during a successful call to mic_request_irq
+ * @data: private data specified by the calling function during the
+ * mic_request_irq
+ *
+ * returns: none.
+ */
+void mic_free_irq(struct mic_device *mdev,
+		struct mic_irq *cookie, void *data)
+{
+	u32 offset;
+	u32 entry;
+	u8 src_id;
+	unsigned int irq;
+
+	if (!mdev)
+		return;
+
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+
+	entry = GET_ENTRY((unsigned long)cookie);
+	offset = GET_OFFSET((unsigned long)cookie);
+	if (mdev->irq_info.num_vectors > 1) {
+		if (entry >= mdev->irq_info.num_vectors) {
+			dev_warn(&mdev->pdev->dev,
+				"entry %d should be < num_irq %d\n",
+				entry, mdev->irq_info.num_vectors);
+			return;
+		}
+		irq = mdev->irq_info.msix_entries[entry].vector;
+		free_irq(irq, data);
+		mdev->irq_info.mic_msi_map[entry] &= ~(BIT(offset));
+		mdev->intr_ops->program_msi_to_src_map(mdev,
+			entry, offset, false);
+
+		dev_dbg(&mdev->pdev->dev, "irq: %d freed\n", irq);
+	} else {
+		irq = mdev->pdev->irq;
+		src_id = mic_unregister_intr_callback(mdev, offset);
+		if (src_id >= MIC_NUM_OFFSETS) {
+			dev_warn(&mdev->pdev->dev, "Error unregistering callback\n");
+			return;
+		}
+		if (pci_dev_msi_enabled(mdev->pdev)) {
+			mdev->irq_info.mic_msi_map[entry] &= ~(BIT(src_id));
+			mdev->intr_ops->program_msi_to_src_map(mdev,
+				entry, src_id, false);
+		}
+		dev_dbg(&mdev->pdev->dev, "callback %d unregistered for src: %d\n",
+			offset, src_id);
+	}
+}
+
+/**
+ * mic_setup_msix - Initializes MSIx interrupts.
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int mic_setup_msix(struct mic_device *mdev)
+{
+	struct pci_dev *pdev = mdev->pdev;
+	int rc, i;
+
+	mdev->irq_info.msix_entries = kmalloc(sizeof(struct msix_entry) *
+			MIC_MIN_MSIX, GFP_KERNEL);
+	if (!mdev->irq_info.msix_entries) {
+		rc = -ENOMEM;
+		goto err_nomem1;
+	}
+
+	for (i = 0; i < MIC_MIN_MSIX; i++)
+		mdev->irq_info.msix_entries[i].entry = i;
+
+	rc = pci_enable_msix(pdev, mdev->irq_info.msix_entries,
+		MIC_MIN_MSIX);
+	if (rc) {
+		dev_dbg(&pdev->dev, "Error enabling MSIx. rc = %d\n", rc);
+		goto err_enable_msix;
+	}
+
+	mdev->irq_info.num_vectors = MIC_MIN_MSIX;
+	rc = mic_alloc_msi_map(mdev);
+	if (rc)
+		goto err_nomem2;
+
+	dev_dbg(&mdev->pdev->dev,
+		"%d MSIx irqs setup\n", mdev->irq_info.num_vectors);
+	return 0;
+
+err_nomem2:
+	pci_disable_msix(pdev);
+err_enable_msix:
+	kfree(mdev->irq_info.msix_entries);
+err_nomem1:
+	mdev->irq_info.num_vectors = 0;
+	return rc;
+}
+
+
+/**
+ * mic_setup_callbacks - Initialize data structures needed
+ * to handle callbacks.
+ *
+ * @mdev: pointer to mic_device instance
+ */
+static int mic_setup_callbacks(struct mic_device *mdev)
+{
+	int i;
+
+	mdev->irq_info.cb_list = kmalloc(sizeof(struct list_head) *
+		MIC_NUM_OFFSETS, GFP_KERNEL);
+	if (!mdev->irq_info.cb_list)
+		return -ENOMEM;
+
+	for (i = 0; i < MIC_NUM_OFFSETS; i++)
+		INIT_LIST_HEAD(&mdev->irq_info.cb_list[i]);
+
+	spin_lock_init(&mdev->irq_info.mic_intr_lock);
+	return 0;
+}
+
+/**
+ * mic_release_callbacks - Uninitialize data structures needed
+ * to handle callbacks.
+ *
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_release_callbacks(struct mic_device *mdev)
+{
+	unsigned long flags;
+	struct list_head *pos, *tmp;
+	struct mic_intr_cb *intr_cb;
+	int i;
+
+	for (i = 0; i < MIC_NUM_OFFSETS; i++) {
+		spin_lock_irqsave(&mdev->irq_info.mic_intr_lock, flags);
+
+		if (!list_empty(&mdev->irq_info.cb_list[i])) {
+			dev_warn(&mdev->pdev->dev,
+			"irq %d may still be in use.\n", mdev->pdev->irq);
+		} else {
+			spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock,
+				flags);
+			break;
+		}
+
+		list_for_each_safe(pos, tmp, &mdev->irq_info.cb_list[i]) {
+			intr_cb = list_entry(pos, struct mic_intr_cb, list);
+			list_del(pos);
+			kfree(intr_cb);
+		}
+		spin_unlock_irqrestore(&mdev->irq_info.mic_intr_lock, flags);
+	}
+
+	kfree(mdev->irq_info.cb_list);
+}
+
+/**
+ * mic_setup_msi - Initializes MSI interrupts.
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int mic_setup_msi(struct mic_device *mdev)
+{
+	struct pci_dev *pdev = mdev->pdev;
+	int rc;
+
+	rc = pci_enable_msi(pdev);
+	if (rc) {
+		dev_dbg(&pdev->dev, "Error enabling MSI. rc = %d\n", rc);
+		return rc;
+	}
+
+	mdev->irq_info.num_vectors = 1;
+	rc = mic_alloc_msi_map(mdev);
+	if (rc)
+		goto err_nomem1;
+
+	rc = mic_setup_callbacks(mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "Error setting up callbacks\n");
+		goto err_nomem2;
+	}
+
+	rc = request_irq(pdev->irq, mic_interrupt, 0 , "mic-msi", mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "Error allocating MSI interrupt\n");
+		goto err_irq_req_fail;
+	}
+
+	dev_dbg(&pdev->dev, "%d MSI irqs setup\n", mdev->irq_info.num_vectors);
+	return 0;
+
+err_irq_req_fail:
+	mic_release_callbacks(mdev);
+err_nomem2:
+	mic_free_msi_map(mdev);
+err_nomem1:
+	pci_disable_msi(pdev);
+	mdev->irq_info.num_vectors = 0;
+	return rc;
+}
+
+/**
+ * mic_setup_intx - Initializes legacy interrupts.
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int mic_setup_intx(struct mic_device *mdev)
+{
+	struct pci_dev *pdev = mdev->pdev;
+	int rc;
+
+	pci_msi_off(pdev);
+
+	/* Enable intx */
+	pci_intx(pdev, 1);
+
+	rc = mic_setup_callbacks(mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "Error setting up callbacks\n");
+		goto err_nomem;
+	}
+
+	rc = request_irq(pdev->irq, mic_interrupt,
+		IRQF_SHARED, "mic-intx", mdev);
+	if (rc)
+		goto err;
+
+	dev_dbg(&pdev->dev, "intx irq setup\n");
+
+	return 0;
+err:
+	mic_release_callbacks(mdev);
+err_nomem:
+	return rc;
+
+}
+
+/**
+ * mic_setup_interrupts - Initializes interrupts.
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int mic_setup_interrupts(struct mic_device *mdev)
+{
+	int rc;
+
+	rc = mic_setup_msix(mdev);
+	if (!rc)
+		goto done;
+
+	rc = mic_setup_msi(mdev);
+	if (!rc)
+		goto done;
+
+	rc = mic_setup_intx(mdev);
+	if (rc) {
+		dev_err(&mdev->pdev->dev, "no usable interrupts\n");
+		return rc;
+	}
+done:
+	mdev->intr_ops->enable_interrupts(mdev);
+	return 0;
+}
+
+/**
+ * mic_free_interrupts - Frees interrupts setup by mic_setup_interrupts
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ * returns none.
+ */
+static void mic_free_interrupts(struct mic_device *mdev)
+{
+	struct pci_dev *pdev = mdev->pdev;
+	int i;
+
+	mdev->intr_ops->disable_interrupts(mdev);
+	if (mdev->irq_info.num_vectors > 1) {
+		for (i = 0; i < mdev->irq_info.num_vectors; i++) {
+			if (mdev->irq_info.mic_msi_map[i])
+				dev_warn(&pdev->dev, "irq %d may still be in use.\n",
+					mdev->irq_info.msix_entries[i].vector);
+		}
+		mic_free_msi_map(mdev);
+		kfree(mdev->irq_info.msix_entries);
+		pci_disable_msix(pdev);
+	} else {
+		if (pci_dev_msi_enabled(mdev->pdev)) {
+			free_irq(mdev->pdev->irq, mdev);
+			mic_free_msi_map(mdev);
+			pci_disable_msi(pdev);
+		} else {
+			free_irq(mdev->pdev->irq, mdev);
+		}
+		mic_release_callbacks(mdev);
+	}
+}
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
+		mdev->intr_ops = &mic_x100_intr_ops;
+		mdev->smpt_ops = &mic_x100_smpt_ops;
+		break;
+	default:
+		break;
+	}
+}
+
+/**
+ * mic_get_family - Determine hardware family to which this MIC belongs.
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ * returns family.
+ */
+static enum mic_hw_family mic_get_family(struct mic_device *mdev)
+{
+	int dev_id = mdev->pdev->device;
+	enum mic_hw_family family;
+
+	switch (dev_id) {
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
+	mdev->pdev = pdev;
+	INIT_LIST_HEAD(&mdev->vdev_list);
+	mutex_init(&mdev->mic_mutex);
+	mdev->family = mic_get_family(mdev);
+	mic_ops_init(mdev);
+	mic_sysfs_init(mdev);
+	INIT_WORK(&mdev->reset_trigger_work, mic_reset_trigger_work);
+	INIT_WORK(&mdev->shutdown_work, mic_shutdown_work);
+	init_completion(&mdev->reset_wait);
+	mdev->irq_info.next_avail_src = 0;
+}
+
+/**
+ * mic_device_uninit - Frees resources allocated during mic_device_init(..)
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ * returns none
+ */
+static void mic_device_uninit(struct mic_device *mdev)
+{
+	/* The cmdline sysfs entry might have allocated cmdline */
+	kfree(mdev->cmdline);
+	kfree(mdev->ipaddr);
+	kfree(mdev->firmware);
+	flush_work(&mdev->reset_trigger_work);
+	flush_work(&mdev->shutdown_work);
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
+static int mic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	int rc;
+	struct mic_device *mdev;
+	char name[20];
+
+	rc = g_mic.next_id++;
+
+	snprintf(name, sizeof(name), "mic%d", rc);
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev) {
+		rc = -ENOMEM;
+		dev_err(&pdev->dev, "dev kmalloc failed rc %d\n", rc);
+		goto dec_num_dev;
+	}
+	strncpy(mdev->name, name, sizeof(name));
+	mdev->id = rc;
+
+	mic_device_init(mdev, pdev);
+
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to enable pci device.\n");
+		goto uninit_device;
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
+	mdev->ops->init(mdev);
+	mdev->intr_ops->intr_init(mdev);
+	rc = mic_setup_interrupts(mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "mic_setup_interrupts failed %d\n", rc);
+		goto unmap_aper;
+	}
+	rc = mic_smpt_init(mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "smpt_init failed %d\n", rc);
+		goto free_interrupts;
+	}
+
+	pci_set_drvdata(pdev, mdev);
+
+	mdev->dev = device_create(g_mic.mic_class, &pdev->dev,
+		MKDEV(MAJOR(g_mic.dev), mdev->id), NULL, "%s", mdev->name);
+	if (IS_ERR(mdev->dev)) {
+		rc = PTR_ERR(mdev->dev);
+		dev_err(&pdev->dev, "device_create failed rc %d\n", rc);
+		goto smpt_uninit;
+	}
+
+	rc = sysfs_create_group(&mdev->dev->kobj, &mdev->attr_group);
+	if (rc) {
+		dev_err(&pdev->dev, "sysfs_create_group failed rc %d\n", rc);
+		goto destroy_device;
+	}
+	mdev->state_sysfs = sysfs_get_dirent(mdev->dev->kobj.sd,
+		NULL, "state");
+	if (!mdev->state_sysfs) {
+		rc = -ENODEV;
+		dev_err(&pdev->dev, "sysfs_get_dirent failed rc %d\n", rc);
+		goto destroy_group;
+	}
+
+	rc = mic_dp_init(mdev);
+	if (rc) {
+		dev_err(&pdev->dev, "mic_dp_init failed rc %d\n", rc);
+		goto sysfs_put;
+	}
+	mutex_lock(&mdev->mic_mutex);
+
+	mdev->shutdown_db = mic_next_db(mdev);
+	mdev->shutdown_cookie = mic_request_irq(mdev, mic_shutdown_db,
+		"shutdown-interrupt", mdev, mdev->shutdown_db, MIC_INTR_DB);
+	if (IS_ERR(mdev->shutdown_cookie)) {
+		rc = PTR_ERR(mdev->shutdown_cookie);
+		mutex_unlock(&mdev->mic_mutex);
+		goto dp_uninit;
+	}
+	mutex_unlock(&mdev->mic_mutex);
+	mic_bootparam_init(mdev);
+
+	mic_create_debug_dir(mdev);
+	dev_info(&pdev->dev, "Probe successful for %s\n", mdev->name);
+	return 0;
+dp_uninit:
+	mic_dp_uninit(mdev);
+sysfs_put:
+	sysfs_put(mdev->state_sysfs);
+destroy_group:
+	sysfs_remove_group(&mdev->dev->kobj, &mdev->attr_group);
+destroy_device:
+	device_destroy(g_mic.mic_class, MKDEV(MAJOR(g_mic.dev), mdev->id));
+smpt_uninit:
+	mic_smpt_uninit(mdev);
+free_interrupts:
+	mic_free_interrupts(mdev);
+unmap_aper:
+	iounmap(mdev->mmio.va);
+unmap_mmio:
+	iounmap(mdev->aper.va);
+release_regions:
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+uninit_device:
+	mic_device_uninit(mdev);
+	kfree(mdev);
+dec_num_dev:
+	g_mic.next_id--;
+	dev_err(&pdev->dev, "Probe failed rc %d\n", rc);
+	return rc;
+}
+
+/**
+ * mic_remove - Device Removal Routine
+ *
+ * @pdev: PCI device structure
+ *
+ * mic_remove is called by the PCI subsystem to alert the driver
+ * that it should release a PCI device.
+ */
+static void mic_remove(struct pci_dev *pdev)
+{
+	struct mic_device *mdev;
+	int id;
+
+	mdev = pci_get_drvdata(pdev);
+	if (!mdev)
+		return;
+
+	id = mdev->id;
+
+	mic_stop(mdev, false);
+	mic_delete_debug_dir(mdev);
+	mutex_lock(&mdev->mic_mutex);
+	mic_free_irq(mdev, mdev->shutdown_cookie, mdev);
+	mutex_unlock(&mdev->mic_mutex);
+	flush_work(&mdev->shutdown_work);
+	mic_dp_uninit(mdev);
+	sysfs_put(mdev->state_sysfs);
+	sysfs_remove_group(&mdev->dev->kobj, &mdev->attr_group);
+	device_destroy(g_mic.mic_class, MKDEV(MAJOR(g_mic.dev), mdev->id));
+	mic_smpt_uninit(mdev);
+	mic_free_interrupts(mdev);
+	iounmap(mdev->mmio.va);
+	iounmap(mdev->aper.va);
+	mic_device_uninit(mdev);
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+	kfree(mdev);
+	dev_dbg(&pdev->dev, "Removed mic%d\n", id);
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
+	ret = alloc_chrdev_region(&g_mic.dev, 0,
+		MIC_MAX_NUM_DEVS, mic_driver_name);
+	if (ret) {
+		pr_err("alloc_chrdev_region failed ret %d\n", ret);
+		goto error;
+	}
+
+	g_mic.mic_class = class_create(THIS_MODULE, mic_driver_name);
+	if (IS_ERR(g_mic.mic_class)) {
+		ret = PTR_ERR(g_mic.mic_class);
+		pr_err("class_create failed ret %d\n", ret);
+		goto cleanup_chrdev;
+	}
+
+	mic_init_debugfs();
+	ret = pci_register_driver(&mic_driver);
+	if (ret) {
+		pr_err("pci_register_driver failed ret %d\n", ret);
+		goto cleanup_debugfs;
+	}
+	return ret;
+cleanup_debugfs:
+	mic_exit_debugfs();
+	class_destroy(g_mic.mic_class);
+cleanup_chrdev:
+	unregister_chrdev_region(g_mic.dev, MIC_MAX_NUM_DEVS);
+error:
+	return ret;
+}
+
+static void __exit mic_exit(void)
+{
+	pci_unregister_driver(&mic_driver);
+	mic_exit_debugfs();
+	class_destroy(g_mic.mic_class);
+	unregister_chrdev_region(g_mic.dev, MIC_MAX_NUM_DEVS);
+}
+
+module_init(mic_init);
+module_exit(mic_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) MIC X100 Host driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/mic/host/mic_smpt.c b/drivers/misc/mic/host/mic_smpt.c
new file mode 100644
index 0000000..459303a
--- /dev/null
+++ b/drivers/misc/mic/host/mic_smpt.c
@@ -0,0 +1,441 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+
+#include "mic_common.h"
+
+static inline u64 mic_system_page_mask(struct mic_device *mdev)
+{
+	return (1ULL << mdev->smpt->info.page_shift) - 1ULL;
+}
+
+static inline u64 mic_sys_addr_to_smpt(struct mic_device *mdev, dma_addr_t pa)
+{
+	return (pa - mdev->smpt->info.base) >> mdev->smpt->info.page_shift;
+}
+
+static inline u64 mic_smpt_to_pa(struct mic_device *mdev, u64 index)
+{
+	return mdev->smpt->info.base + (index * mdev->smpt->info.page_size);
+}
+
+static inline u64 mic_smpt_offset(struct mic_device *mdev, dma_addr_t pa)
+{
+	return pa & mic_system_page_mask(mdev);
+}
+
+static inline u64 mic_smpt_align_low(struct mic_device *mdev, dma_addr_t pa)
+{
+	return ALIGN(pa - mic_system_page_mask(mdev),
+		mdev->smpt->info.page_size);
+}
+
+static inline u64 mic_smpt_align_high(struct mic_device *mdev, dma_addr_t pa)
+{
+	return ALIGN(pa, mdev->smpt->info.page_size);
+}
+
+/* Total Cumulative system memory accessible by MIC across all SMPT entries */
+static inline u64 mic_max_system_memory(struct mic_device *mdev)
+{
+	return mdev->smpt->info.num_reg * mdev->smpt->info.page_size;
+}
+
+/* Maximum system memory address accessible by MIC */
+static inline u64 mic_max_system_addr(struct mic_device *mdev)
+{
+	return mdev->smpt->info.base + mic_max_system_memory(mdev) - 1ULL;
+}
+
+/* Check if the DMA address is a MIC system memory address */
+static inline bool
+mic_is_system_addr(struct mic_device *mdev, dma_addr_t pa)
+{
+	return pa >= mdev->smpt->info.base && pa <= mic_max_system_addr(mdev);
+}
+
+/* Populate an SMPT entry and update the reference counts. */
+static void add_smpt_entry(int spt, s64 *ref, u64 addr,
+		int entries, struct mic_device *mdev)
+{
+	struct mic_smpt_info *smpt_info = mdev->smpt;
+	int i;
+
+	for (i = spt; i < spt + entries; i++,
+		addr += smpt_info->info.page_size) {
+		if (!smpt_info->entry[i].ref_count &&
+			(smpt_info->entry[i].dma_addr != addr)) {
+			mdev->smpt_ops->set(mdev, addr, i);
+			smpt_info->entry[i].dma_addr = addr;
+		}
+		smpt_info->entry[i].ref_count += ref[i - spt];
+	}
+}
+
+/*
+ * Find an available MIC address in MIC SMPT address space
+ * for a given DMA address and size.
+ */
+static dma_addr_t smpt_op(struct mic_device *mdev, u64 dma_addr,
+				int entries, s64 *ref, size_t size)
+{
+	int spt = -1;   /* smpt index */
+	int ee = 0;	/* existing entries */
+	int fe = 0;	/* free entries */
+	int i;
+	unsigned long flags;
+	dma_addr_t mic_addr = 0;
+	dma_addr_t addr = dma_addr;
+	struct mic_smpt_info *smpt_info = mdev->smpt;
+
+	spin_lock_irqsave(&smpt_info->smpt_lock, flags);
+
+	/* find existing entries */
+	for (i = 0; i < smpt_info->info.num_reg; i++) {
+		if (smpt_info->entry[i].dma_addr == addr) {
+			ee++;
+			addr += smpt_info->info.page_size;
+		} else if (ee) /* cannot find contiguous entries */
+			goto not_found;
+
+		if (ee == entries)
+			goto found;
+	}
+
+	/* find free entry */
+	for (i = 0; i < smpt_info->info.num_reg; i++) {
+		fe = (smpt_info->entry[i].ref_count == 0) ? fe + 1 : 0;
+		if (fe == entries)
+			goto found;
+	}
+
+not_found:
+	spin_unlock_irqrestore(&smpt_info->smpt_lock, flags);
+	return mic_addr;
+
+found:
+	spt = i - entries + 1;
+	mic_addr = mic_smpt_to_pa(mdev, spt);
+	add_smpt_entry(spt, ref, dma_addr, entries, mdev);
+	smpt_info->map_count++;
+	smpt_info->ref_count += (s64)size;
+	spin_unlock_irqrestore(&smpt_info->smpt_lock, flags);
+	return mic_addr;
+}
+
+/*
+ * Returns number of smpt entries needed for dma_addr to dma_addr + size
+ * also returns the reference count array for each of those entries
+ * and the starting smpt address
+ */
+static int get_smpt_ref_count(s64 *ref, dma_addr_t dma_addr, size_t size,
+				u64 *smpt_start, struct mic_device *mdev)
+{
+	u64 start =  dma_addr;
+	u64 end = dma_addr + size;
+	int i = 0;
+
+	while (start < end) {
+		ref[i++] = min(mic_smpt_align_high(mdev, start + 1),
+			end) - start;
+		start = mic_smpt_align_high(mdev, start + 1);
+	}
+
+	if (smpt_start)
+		*smpt_start = mic_smpt_align_low(mdev, dma_addr);
+
+	return i;
+}
+
+/*
+ * mic_to_dma_addr - Converts a MIC address to a DMA address.
+ *
+ * @mdev: pointer to mic_device instance.
+ * @mic_address: MIC address.
+ *
+ * returns a DMA address.
+ */
+static dma_addr_t
+mic_to_dma_addr(struct mic_device *mdev, dma_addr_t mic_addr)
+{
+	struct mic_smpt_info *smpt_info = mdev->smpt;
+	int spt;
+	dma_addr_t dma_addr;
+
+	if (!mic_is_system_addr(mdev, mic_addr)) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	spt = mic_sys_addr_to_smpt(mdev, mic_addr);
+	dma_addr = smpt_info->entry[spt].dma_addr +
+		mic_smpt_offset(mdev, mic_addr);
+	return dma_addr;
+}
+
+/**
+ * mic_map - Maps a DMA address to a MIC physical address.
+ *
+ * @mdev: pointer to mic_device instance.
+ * @dma_address: DMA address.
+ * @size: Size of the region to be mapped.
+ *
+ * This API converts the DMA address provided to a DMA address understood
+ * by MIC. Callee should check for errors by called mic_map_error(..).
+ *
+ * returns DMA address as required by MIC.
+ */
+dma_addr_t mic_map(struct mic_device *mdev, dma_addr_t dma_addr, size_t size)
+{
+	dma_addr_t mic_addr = 0;
+	int entries;
+	s64 *ref;
+	u64 smpt_start;
+
+	if (!size || size > mic_max_system_memory(mdev))
+		return mic_addr;
+
+	ref = kmalloc(mdev->smpt->info.num_reg * sizeof(s64), GFP_KERNEL);
+	if (!ref)
+		return mic_addr;
+
+	/*
+	 * Get number of smpt entries to be mapped, ref count array
+	 * and the starting smpt address to start the search for
+	 * free or existing smpt entries.
+	 */
+	entries = get_smpt_ref_count(ref, dma_addr, size, &smpt_start, mdev);
+
+	/* Set the smpt table appropriately and get 16G aligned mic address */
+	mic_addr = smpt_op(mdev, smpt_start, entries, ref, size);
+
+	kfree(ref);
+
+	/*
+	 * If mic_addr is zero then its an error case
+	 * since mic_addr can never be zero.
+	 * else generate mic_addr by adding the 16G offset in dma_addr
+	 */
+	if (!mic_addr && MIC_FAMILY_X100 == mdev->family) {
+		WARN_ON(1);
+		return mic_addr;
+	} else {
+		return mic_addr + (dma_addr & mic_system_page_mask(mdev));
+	}
+}
+
+/**
+ * mic_unmap - Unmaps a MIC physical address.
+ *
+ * @mdev: pointer to mic_device instance.
+ * @mic_addr: MIC physical address.
+ * @size: Size of the region to be unmapped.
+ *
+ * This API unmaps the mappings created by mic_map(..).
+ *
+ * returns None.
+ */
+void mic_unmap(struct mic_device *mdev, dma_addr_t mic_addr, size_t size)
+{
+	struct mic_smpt_info *smpt_info = mdev->smpt;
+	s64 *ref;
+	int num_smpt;
+	int spt;
+	int i;
+	unsigned long flags;
+
+	if (!size)
+		return;
+
+	if (!mic_is_system_addr(mdev, mic_addr)) {
+		WARN_ON(1);
+		return;
+	}
+
+	spt = mic_sys_addr_to_smpt(mdev, mic_addr);
+	ref = kmalloc(mdev->smpt->info.num_reg * sizeof(s64), GFP_KERNEL);
+	if (!ref)
+		return;
+
+	/* Get number of smpt entries to be mapped, ref count array */
+	num_smpt = get_smpt_ref_count(ref, mic_addr, size, NULL, mdev);
+
+	spin_lock_irqsave(&smpt_info->smpt_lock, flags);
+	smpt_info->unmap_count++;
+	smpt_info->ref_count -= (s64)size;
+
+	for (i = spt; i < spt + num_smpt; i++) {
+		smpt_info->entry[i].ref_count -= ref[i - spt];
+		WARN_ON(smpt_info->entry[i].ref_count < 0);
+	}
+	spin_unlock_irqrestore(&smpt_info->smpt_lock, flags);
+	kfree(ref);
+}
+
+/**
+ * mic_map_single - Maps a virtual address to a MIC physical address.
+ *
+ * @mdev: pointer to mic_device instance.
+ * @va: Kernel direct mapped virtual address.
+ * @size: Size of the region to be mapped.
+ *
+ * This API calls pci_map_single(..) for the direct mapped virtual address
+ * and then converts the DMA address provided to a DMA address understood
+ * by MIC. Callee should check for errors by called mic_map_error(..).
+ *
+ * returns DMA address as required by MIC.
+ */
+dma_addr_t mic_map_single(struct mic_device *mdev, void *va, size_t size)
+{
+	dma_addr_t mic_addr = 0;
+	dma_addr_t dma_addr =
+		pci_map_single(mdev->pdev, va, size, PCI_DMA_BIDIRECTIONAL);
+
+	if (!pci_dma_mapping_error(mdev->pdev, dma_addr)) {
+		mic_addr = mic_map(mdev, dma_addr, size);
+		if (!mic_addr) {
+			dev_err(&mdev->pdev->dev,
+				"mic_map failed dma_addr 0x%llx size 0x%lx\n",
+				dma_addr, size);
+			pci_unmap_single(mdev->pdev, dma_addr,
+				size, PCI_DMA_BIDIRECTIONAL);
+		}
+	}
+	return mic_addr;
+}
+
+/**
+ * mic_unmap_single - Unmaps a MIC physical address.
+ *
+ * @mdev: pointer to mic_device instance.
+ * @mic_addr: MIC physical address.
+ * @size: Size of the region to be unmapped.
+ *
+ * This API unmaps the mappings created by mic_map_single(..).
+ *
+ * returns None.
+ */
+void
+mic_unmap_single(struct mic_device *mdev, dma_addr_t mic_addr, size_t size)
+{
+	dma_addr_t dma_addr = mic_to_dma_addr(mdev, mic_addr);
+	mic_unmap(mdev, mic_addr, size);
+	pci_unmap_single(mdev->pdev, dma_addr, size, PCI_DMA_BIDIRECTIONAL);
+}
+
+/**
+ * mic_smpt_init - Initialize MIC System Memory Page Tables.
+ *
+ * @mdev: pointer to mic_device instance.
+ *
+ * returns 0 for success and -errno for error.
+ */
+int mic_smpt_init(struct mic_device *mdev)
+{
+	int i, err = 0;
+	dma_addr_t dma_addr;
+	struct mic_smpt_info *smpt_info;
+
+	mdev->smpt = kmalloc(sizeof(*mdev->smpt), GFP_KERNEL);
+	if (!mdev->smpt)
+		return -ENOMEM;
+
+	smpt_info = mdev->smpt;
+	mdev->smpt_ops->init(mdev);
+	smpt_info->entry = kmalloc(sizeof(struct mic_smpt)
+			* smpt_info->info.num_reg, GFP_KERNEL);
+	if (!smpt_info->entry) {
+		err = -ENOMEM;
+		goto free_smpt;
+	}
+	spin_lock_init(&smpt_info->smpt_lock);
+	for (i = 0; i < smpt_info->info.num_reg; i++) {
+		dma_addr = i * smpt_info->info.page_size;
+		smpt_info->entry[i].dma_addr = dma_addr;
+		smpt_info->entry[i].ref_count = 0;
+		mdev->smpt_ops->set(mdev, dma_addr, i);
+	}
+	smpt_info->ref_count = 0;
+	smpt_info->map_count = 0;
+	smpt_info->unmap_count = 0;
+	return 0;
+free_smpt:
+	kfree(smpt_info);
+	return err;
+}
+
+/**
+ * mic_smpt_uninit - UnInitialize MIC System Memory Page Tables.
+ *
+ * @mdev: pointer to mic_device instance.
+ *
+ * returns None.
+ */
+void mic_smpt_uninit(struct mic_device *mdev)
+{
+	struct mic_smpt_info *smpt_info = mdev->smpt;
+	int i;
+
+	dev_dbg(&mdev->pdev->dev,
+		"nodeid %d SMPT ref count %lld map %lld unmap %lld\n",
+		mdev->id, smpt_info->ref_count,
+		smpt_info->map_count, smpt_info->unmap_count);
+
+	for (i = 0; i < smpt_info->info.num_reg; i++) {
+		dev_dbg(&mdev->pdev->dev,
+			"SMPT entry[%d] dma_addr = 0x%llx ref_count = %lld\n",
+			i, smpt_info->entry[i].dma_addr,
+			smpt_info->entry[i].ref_count);
+		WARN_ON(smpt_info->entry[i].ref_count);
+	}
+	kfree(smpt_info->entry);
+	kfree(smpt_info);
+}
+
+/**
+ * mic_smpt_restore - Restore MIC System Memory Page Tables.
+ *
+ * @mdev: pointer to mic_device instance.
+ *
+ * Restore the SMPT registers to values previously stored in the
+ * SW data structures. Some MIC steppings lose register state
+ * across resets and this API should be called for performing
+ * a restore operation if required.
+ *
+ * returns None.
+ */
+void mic_smpt_restore(struct mic_device *mdev)
+{
+	int i;
+	dma_addr_t dma_addr;
+
+	for (i = 0; i < mdev->smpt->info.num_reg; i++) {
+		dma_addr = mdev->smpt->entry[i].dma_addr;
+		mdev->smpt_ops->set(mdev, dma_addr, i);
+	}
+}
+
diff --git a/drivers/misc/mic/host/mic_smpt.h b/drivers/misc/mic/host/mic_smpt.h
new file mode 100644
index 0000000..9dc1d4c
--- /dev/null
+++ b/drivers/misc/mic/host/mic_smpt.h
@@ -0,0 +1,103 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#ifndef MIC_SMPT_H
+#define MIC_SMPT_H
+/**
+ * struct mic_smpt_ops - MIC HW specific SMPT operations.
+ * @init: Initialize hardware specific SMPT information in mic_smpt_hw_info.
+ * @set: Set the value for a particular SMPT entry.
+ */
+struct mic_smpt_ops {
+	void (*init)(struct mic_device *mdev);
+	void (*set)(struct mic_device *mdev, dma_addr_t dma_addr, u8 index);
+};
+
+/**
+ * struct mic_smpt - MIC SMPT entry information.
+ * @dma_addr: Base DMA address for this SMPT entry.
+ * @ref_count: Number of active mappings for this SMPT entry in bytes.
+ */
+struct mic_smpt {
+	dma_addr_t dma_addr;
+	s64 ref_count;
+};
+
+/**
+ * struct mic_smpt_hw_info - MIC SMPT hardware specific information.
+ * @num_reg: Number of SMPT registers.
+ * @page_shift: System memory page shift.
+ * @page_size: System memory page size.
+ * @base: System address base.
+ */
+struct mic_smpt_hw_info {
+	u8 num_reg;
+	u8 page_shift;
+	u64 page_size;
+	u64 base;
+};
+
+/**
+ * struct mic_smpt_info - MIC SMPT information.
+ * @entry: Array of SMPT entries.
+ * @smpt_lock: Spin lock protecting access to SMPT data structures.
+ * @info: Hardware specific SMPT information.
+ * @ref_count: Number of active SMPT mappings (for debug).
+ * @map_count: Number of SMPT mappings created (for debug).
+ * @unmap_count: Number of SMPT mappings destroyed (for debug).
+ */
+struct mic_smpt_info {
+	struct mic_smpt *entry;
+	spinlock_t smpt_lock;
+	struct mic_smpt_hw_info info;
+	s64 ref_count;
+	s64 map_count;
+	s64 unmap_count;
+};
+
+dma_addr_t mic_map_single(struct mic_device *mdev, void *va, size_t size);
+void mic_unmap_single(struct mic_device *mdev,
+	dma_addr_t mic_addr, size_t size);
+dma_addr_t mic_map(struct mic_device *mdev,
+	dma_addr_t dma_addr, size_t size);
+void mic_unmap(struct mic_device *mdev, dma_addr_t mic_addr, size_t size);
+
+/**
+ * mic_map_error - Check a MIC address for errors.
+ *
+ * @mdev: pointer to mic_device instance.
+ *
+ * returns Whether there was an error during mic_map..(..) APIs.
+ */
+static inline bool mic_map_error(dma_addr_t mic_addr)
+{
+	return !mic_addr;
+}
+
+int mic_smpt_init(struct mic_device *mdev);
+void mic_smpt_uninit(struct mic_device *mdev);
+void mic_smpt_restore(struct mic_device *mdev);
+
+#endif
diff --git a/drivers/misc/mic/host/mic_sysfs.c b/drivers/misc/mic/host/mic_sysfs.c
new file mode 100644
index 0000000..d4d8ee6
--- /dev/null
+++ b/drivers/misc/mic/host/mic_sysfs.c
@@ -0,0 +1,360 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/module.h>
+#include <linux/pci.h>
+
+#include "mic_common.h"
+
+/*
+ * A state-to-string lookup table, for exposing a human readable state
+ * via sysfs. Always keep in sync with enum mic_states
+ */
+static const char * const mic_state_string[] = {
+	[MIC_OFFLINE] = "offline",
+	[MIC_ONLINE] = "online",
+	[MIC_SHUTTING_DOWN] = "shutting_down",
+	[MIC_RESET_FAILED] = "reset_failed",
+};
+
+/*
+ * A shutdown-status-to-string lookup table, for exposing a human
+ * readable state via sysfs. Always keep in sync with enum mic_shutdown_status
+ */
+static const char * const mic_shutdown_status_string[] = {
+	[MIC_NOP] = "nop",
+	[MIC_CRASHED] = "crashed",
+	[MIC_HALTED] = "halted",
+	[MIC_POWER_OFF] = "poweroff",
+	[MIC_RESTART] = "restart",
+};
+
+void mic_set_shutdown_status(struct mic_device *mdev, u8 shutdown_status)
+{
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+	dev_info(&mdev->pdev->dev, "Shutdown Status %s -> %s\n",
+		mic_shutdown_status_string[mdev->shutdown_status],
+		mic_shutdown_status_string[shutdown_status]);
+	mdev->shutdown_status = shutdown_status;
+}
+
+void mic_set_state(struct mic_device *mdev, u8 state)
+{
+	WARN_ON(!mutex_is_locked(&mdev->mic_mutex));
+	dev_info(&mdev->pdev->dev, "State %s -> %s\n",
+		mic_state_string[mdev->state],
+		mic_state_string[state]);
+	mdev->state = state;
+	sysfs_notify_dirent(mdev->state_sysfs);
+}
+
+static ssize_t
+show_family(struct device *dev, struct device_attribute *attr, char *buf)
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
+	return snprintf(buf, PAGE_SIZE, "%s\n", card);
+}
+static DEVICE_ATTR(family, S_IRUGO, show_family, NULL);
+
+static ssize_t
+show_stepping(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	char *string = "??";
+
+	if (!mdev)
+		return -EINVAL;
+
+	switch (mdev->family) {
+	case MIC_FAMILY_X100:
+		switch (mdev->stepping) {
+		case MIC_A0_STEP:
+			string = "A0";
+			break;
+		case MIC_B0_STEP:
+			string = "B0";
+			break;
+		case MIC_B1_STEP:
+			string = "B1";
+			break;
+		case MIC_C0_STEP:
+			string = "C0";
+			break;
+		default:
+			break;
+		}
+		break;
+	default:
+		break;
+	}
+	return snprintf(buf, PAGE_SIZE, "%s\n", string);
+}
+static DEVICE_ATTR(stepping, S_IRUGO, show_stepping, NULL);
+
+static ssize_t
+show_micstate(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev || mdev->state >= MIC_LAST)
+		return -EINVAL;
+
+	return snprintf(buf, PAGE_SIZE, "%s",
+		mic_state_string[mdev->state]);
+}
+
+static ssize_t
+set_micstate(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	int rc = 0;
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	if (!mdev)
+		return -EINVAL;
+	if (!strncmp(buf, "boot", strlen("boot"))) {
+		rc = mic_start(mdev, buf);
+		if (rc) {
+			dev_err(&mdev->pdev->dev,
+				"mic_boot failed rc %d\n", rc);
+			count = rc;
+		}
+		goto done;
+	}
+
+	if (sysfs_streq(buf, "reset")) {
+		schedule_work(&mdev->reset_trigger_work);
+		goto done;
+	}
+
+	if (sysfs_streq(buf, "shutdown")) {
+		mic_shutdown(mdev);
+		goto done;
+	}
+
+	count = -EINVAL;
+done:
+	return count;
+}
+static DEVICE_ATTR(state, S_IRUGO|S_IWUSR, show_micstate, set_micstate);
+
+static ssize_t show_mic_shutdown_status(struct device *dev,
+	struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev || mdev->shutdown_status >= MIC_STATUS_LAST)
+		return -EINVAL;
+
+	return snprintf(buf, PAGE_SIZE, "%s",
+		mic_shutdown_status_string[mdev->shutdown_status]);
+}
+static DEVICE_ATTR(shutdown_status, S_IRUGO|S_IWUSR,
+	show_mic_shutdown_status, NULL);
+
+static ssize_t
+show_ipaddr(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	char *ipaddr;
+
+	if (!mdev)
+		return -EINVAL;
+
+	ipaddr = mdev->ipaddr;
+
+	if (ipaddr)
+		return snprintf(buf, PAGE_SIZE, "%s\n", ipaddr);
+	return 0;
+}
+
+static ssize_t
+set_ipaddr(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	kfree(mdev->ipaddr);
+
+	mdev->ipaddr = kzalloc(count + 1, GFP_KERNEL);
+	if (!mdev->ipaddr)
+		return -ENOMEM;
+
+	strncpy(mdev->ipaddr, buf, count);
+
+	if (mdev->ipaddr[count - 1] == '\n')
+		mdev->ipaddr[count - 1] = '\0';
+	else
+		mdev->ipaddr[count] = '\0';
+	return count;
+}
+static DEVICE_ATTR(ipaddr, S_IRUGO | S_IWUSR, show_ipaddr, set_ipaddr);
+
+static ssize_t
+show_cmdline(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	char *cmdline;
+
+	if (!mdev)
+		return -EINVAL;
+
+	cmdline = mdev->cmdline;
+
+	if (cmdline)
+		return snprintf(buf, PAGE_SIZE, "%s\n", cmdline);
+	return 0;
+}
+
+static ssize_t
+set_cmdline(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	kfree(mdev->cmdline);
+
+	mdev->cmdline = kmalloc(count + 1, GFP_KERNEL);
+	if (!mdev->cmdline)
+		return -ENOMEM;
+
+	strncpy(mdev->cmdline, buf, count);
+
+	if (mdev->cmdline[count - 1] == '\n')
+		mdev->cmdline[count - 1] = '\0';
+	else
+		mdev->cmdline[count] = '\0';
+
+	return count;
+}
+static DEVICE_ATTR(cmdline, S_IRUGO | S_IWUSR, show_cmdline, set_cmdline);
+
+static ssize_t
+show_log_buf_addr(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	return snprintf(buf, PAGE_SIZE, "%p\n", mdev->log_buf_addr);
+}
+
+static ssize_t
+store_log_buf_addr(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	int ret;
+	unsigned long addr;
+
+	if (!mdev)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 16, &addr);
+	if (ret)
+		goto exit;
+
+	mdev->log_buf_addr = (void *)addr;
+	ret = count;
+exit:
+	return ret;
+}
+static DEVICE_ATTR(log_buf_addr, S_IRUGO | S_IWUSR,
+	show_log_buf_addr, store_log_buf_addr);
+
+static ssize_t
+show_log_buf_len(struct device *dev, struct device_attribute *attr,
+	char *buf)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+
+	if (!mdev)
+		return -EINVAL;
+
+	return snprintf(buf, PAGE_SIZE, "%p\n", mdev->log_buf_len);
+}
+
+static ssize_t
+store_log_buf_len(struct device *dev, struct device_attribute *attr,
+	const char *buf, size_t count)
+{
+	struct mic_device *mdev = dev_get_drvdata(dev->parent);
+	int ret;
+	unsigned long addr;
+
+	if (!mdev)
+		return -EINVAL;
+
+	ret = kstrtoul(buf, 16, &addr);
+	if (ret)
+		goto exit;
+
+	mdev->log_buf_len = (int *)addr;
+	ret = count;
+exit:
+	return ret;
+}
+static DEVICE_ATTR(log_buf_len, S_IRUGO | S_IWUSR,
+	show_log_buf_len, store_log_buf_len);
+
+static struct attribute *default_attrs[] = {
+	&dev_attr_family.attr,
+	&dev_attr_stepping.attr,
+	&dev_attr_state.attr,
+	&dev_attr_shutdown_status.attr,
+	&dev_attr_cmdline.attr,
+	&dev_attr_ipaddr.attr,
+	&dev_attr_log_buf_addr.attr,
+	&dev_attr_log_buf_len.attr,
+
+	NULL
+};
+
+void mic_sysfs_init(struct mic_device *mdev)
+{
+	mdev->attr_group.attrs = default_attrs;
+}
diff --git a/drivers/misc/mic/host/mic_x100.c b/drivers/misc/mic/host/mic_x100.c
new file mode 100644
index 0000000..41ca272
--- /dev/null
+++ b/drivers/misc/mic/host/mic_x100.c
@@ -0,0 +1,665 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC Host driver.
+ *
+ */
+#include <linux/fs.h>
+#include <linux/pci.h>
+#include <linux/sched.h>
+#include <linux/firmware.h>
+#include <linux/delay.h>
+
+#include "mic_common.h"
+
+/*
+ * mic_x100_hw_init - Initialize hardware information.
+ *
+ * @mdev: pointer to mic_device instance
+ *
+ * returns none:
+ */
+static void mic_x100_hw_init(struct mic_device *mdev)
+{
+	mdev->stepping = mdev->pdev->revision;
+}
+
+/**
+ * mic_x100_write_spad() - write to the scratchpad register
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
+	dev_dbg(&mdev->pdev->dev, "Writing 0x%x to scratch pad index %d\n",
+		val, idx);
+	mic_mmio_write(&mdev->mmio, val,
+		MIC_X100_SBOX_BASE_ADDRESS +
+		MIC_X100_SBOX_SPAD0 + idx * 4);
+}
+
+/**
+ * mic_x100_read_spad() - read from the scratchpad register
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
+	dev_dbg(&mdev->pdev->dev,
+		"Reading 0x%x from scratch pad index %d\n", val, idx);
+	return val;
+}
+
+/*
+ * mic_x100_reset_fw_ready - Reset Firmware ready status field.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_reset_fw_ready(struct mic_device *mdev)
+{
+	mdev->ops->write_spad(mdev, MIC_X100_DOWNLOAD_INFO, 0);
+}
+
+/*
+ * mic_x100_is_fw_ready - Check if firmware is ready.
+ * @mdev: pointer to mic_device instance
+ */
+static bool mic_x100_is_fw_ready(struct mic_device *mdev)
+{
+	u32 scratch2 = mdev->ops->read_spad(mdev, MIC_X100_DOWNLOAD_INFO);
+	return MIC_X100_SPAD2_DOWNLOAD_STATUS(scratch2) ? true : false;
+}
+
+/**
+ * mic_x100_hw_reset - Reset the MIC device.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_hw_reset(struct mic_device *mdev)
+{
+	u32 reset_reg;
+	u32 rgcr = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_RGCR;
+	struct mic_mw *mw = &mdev->mmio;
+
+	/* Ensure all loads and stores have completed */
+	mb();
+	/* Trigger reset */
+	reset_reg = mic_mmio_read(mw, rgcr);
+	reset_reg |= 0x1;
+	mic_mmio_write(mw, reset_reg, rgcr);
+	/*
+	 * It seems we really want to delay at least 1 second
+	 * after touching reset to prevent a lot of problems.
+	 */
+	msleep(1000);
+}
+
+/**
+ * mic_x100_enable_interrupts - Enable interrupts.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_enable_interrupts(struct mic_device *mdev)
+{
+	u32 reg;
+	struct mic_mw *mw = &mdev->mmio;
+	u32 sice0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SICE0;
+	u32 siac0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SIAC0;
+
+	reg = mic_mmio_read(mw, sice0);
+	reg |= MIC_X100_SBOX_DBR_BITS(0xf) | MIC_X100_SBOX_DMA_BITS(0xff);
+	mic_mmio_write(mw, reg, sice0);
+
+	/* Enable auto-clear when enabling interrupts.
+	 * Applicable only for MSI-x interrupts. Legacy
+	 * and MSI mode cannot have auto-clear enabled */
+	if (mdev->irq_info.num_vectors > 1) {
+		reg = mic_mmio_read(mw, siac0);
+		reg |= MIC_X100_SBOX_DBR_BITS(0xf) |
+			MIC_X100_SBOX_DMA_BITS(0xff);
+		mic_mmio_write(mw, reg, siac0);
+	}
+}
+
+/**
+ * mic_x100_disable_interrupts - Disable interrupts.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_disable_interrupts(struct mic_device *mdev)
+{
+	u32 reg;
+	struct mic_mw *mw = &mdev->mmio;
+	u32 sice0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SICE0;
+	u32 siac0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SIAC0;
+	u32 sicc0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SICC0;
+
+	reg = mic_mmio_read(mw, sice0);
+	mic_mmio_write(mw, reg, sicc0);
+
+	if (mdev->irq_info.num_vectors > 1) {
+		reg = mic_mmio_read(mw, siac0);
+		reg &= ~(MIC_X100_SBOX_DBR_BITS(0xf) |
+			MIC_X100_SBOX_DMA_BITS(0xff));
+		mic_mmio_write(mw, reg, siac0);
+	}
+}
+
+/**
+ * mic_x100_get_apic_id - Get bootstrap APIC ID.
+ * @mdev: pointer to mic_device instance
+ */
+static u32 mic_x100_get_apic_id(struct mic_device *mdev)
+{
+	u32 scratch2 = 0;
+
+	scratch2 = mdev->ops->read_spad(mdev, MIC_X100_DOWNLOAD_INFO);
+	return MIC_X100_SPAD2_APIC_ID(scratch2);
+}
+
+/**
+ * mic_x100_send_firmware_intr - Send an interrupt to the firmware on MIC.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_send_firmware_intr(struct mic_device *mdev)
+{
+	u32 apicicr_low;
+	u64 apic_icr_offset = MIC_X100_SBOX_APICICR7;
+	int vector = MIC_X100_BSP_INTERRUPT_VECTOR;
+	struct mic_mw *mw = &mdev->mmio;
+
+	/*
+	 * For MIC we need to make sure we "hit"
+	 * the send_icr bit (13).
+	 */
+	apicicr_low = (vector | (1 << 13));
+
+	mic_mmio_write(mw, mic_x100_get_apic_id(mdev),
+		MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset + 4);
+
+	/* Ensure all stores have been completed before informing card */
+	wmb();
+
+	/*
+	 * MIC card interrupt triggers only when we write
+	 * the lower part of the address (upper bits).
+	 */
+	mic_mmio_write(mw, apicicr_low,
+		MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
+}
+
+/**
+ * mic_x100_send_sbox_intr - Send an MIC_X100_SBOX interrupt to MIC.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_send_sbox_intr(struct mic_device *mdev,
+			int doorbell)
+{
+	struct mic_mw *mw = &mdev->mmio;
+	u64 apic_icr_offset = MIC_X100_SBOX_APICICR0 + doorbell * 8;
+	u32 apicicr_low = mic_mmio_read(mw,
+			MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
+
+	/* for MIC we need to make sure we "hit" the send_icr bit (13) */
+	apicicr_low = (apicicr_low | (1 << 13));
+
+	/* Ensure all stores have been completed before sending an interrupt */
+	wmb();
+	/* MIC card only triggers when we write the lower part of the
+	 * address (upper bits)
+	 */
+	mic_mmio_write(mw, apicicr_low,
+		MIC_X100_SBOX_BASE_ADDRESS + apic_icr_offset);
+}
+
+/**
+ * mic_x100_send_rdmasr_intr - Send an RDMASR interrupt to MIC.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_send_rdmasr_intr(struct mic_device *mdev,
+			int doorbell)
+{
+	int rdmasr_offset = MIC_X100_SBOX_RDMASR0 + (doorbell << 2);
+	mic_mmio_write(&mdev->mmio, 0,
+		MIC_X100_SBOX_BASE_ADDRESS + rdmasr_offset);
+}
+
+/**
+ * __mic_x100_send_intr - Send interrupt to MIC.
+ * @mdev: pointer to mic_device instance
+ * @doorbell: doorbell number.
+ */
+static void mic_x100_send_intr(struct mic_device *mdev, int doorbell)
+{
+	int rdmasr_db;
+	if (doorbell < MIC_X100_NUM_SBOX_IRQ) {
+		mic_x100_send_sbox_intr(mdev, doorbell);
+	} else {
+		rdmasr_db = doorbell - MIC_X100_NUM_SBOX_IRQ +
+			MIC_X100_RDMASR_IRQ_BASE;
+		mic_x100_send_rdmasr_intr(mdev, rdmasr_db);
+	}
+}
+
+/**
+ * mic_ack_interrupt - Device specific interrupt handling.
+ * @mdev: pointer to mic_device instance
+ *
+ * Returns: bitmask of doorbell events triggered.
+ */
+static u32 mic_x100_ack_interrupt(struct mic_device *mdev)
+{
+	u32 reg = 0;
+	struct mic_mw *mw = &mdev->mmio;
+	u32 sicr0 = MIC_X100_SBOX_BASE_ADDRESS + MIC_X100_SBOX_SICR0;
+
+	/* Clear pending bit array. */
+	if (MIC_A0_STEP == mdev->stepping)
+		mic_mmio_write(mw, 1, MIC_X100_SBOX_BASE_ADDRESS +
+			MIC_X100_SBOX_MSIXPBACR_K1OM);
+
+	if (mdev->irq_info.num_vectors <= 1) {
+		reg = mic_mmio_read(mw, sicr0);
+
+		if (unlikely(!reg))
+			goto done;
+
+		mic_mmio_write(mw, reg, sicr0);
+	}
+
+	if (mdev->stepping >= MIC_B0_STEP)
+		mdev->intr_ops->enable_interrupts(mdev);
+done:
+	return reg;
+}
+
+/**
+ * mic_x100_hw_intr_init() - Initialize h/w specific interrupt
+ * information.
+ * @mdev: pointer to mic_device instance
+ */
+static void mic_x100_hw_intr_init(struct mic_device *mdev)
+{
+	mdev->intr_info = (struct mic_intr_info *) mic_x100_intr_init;
+}
+
+/**
+ * mic_x100_read_msi_to_src_map() - read from the MSI mapping registers
+ * @mdev: pointer to mic_device instance
+ * @idx: index to the mapping register, 0 based
+ *
+ * This function allows reading of the 32bit MSI mapping register.
+ *
+ * RETURNS: The value in the register.
+ */
+static u32
+mic_x100_read_msi_to_src_map(struct mic_device *mdev, int idx)
+{
+	return mic_mmio_read(&mdev->mmio,
+		MIC_X100_SBOX_BASE_ADDRESS +
+		MIC_X100_SBOX_MXAR0_K1OM + idx * 4);
+}
+
+/**
+ * mic_x100_program_msi_to_src_map() - program the MSI mapping registers
+ * @mdev: pointer to mic_device instance
+ * @idx: index to the mapping register, 0 based
+ * @offset: The bit offset in the register that needs to be updated.
+ * @set: boolean specifying if the bit in the specified offset needs
+ * to be set or cleared.
+ *
+ * RETURNS: None.
+ */
+static void
+mic_x100_program_msi_to_src_map(struct mic_device *mdev,
+			int idx, int offset, bool set)
+{
+	unsigned long reg;
+	struct mic_mw *mw = &mdev->mmio;
+	u32 mxar = MIC_X100_SBOX_BASE_ADDRESS +
+		MIC_X100_SBOX_MXAR0_K1OM + idx * 4;
+
+	reg = mic_mmio_read(mw, mxar);
+	if (set)
+		__set_bit(offset, &reg);
+	else
+		__clear_bit(offset, &reg);
+	mic_mmio_write(mw, reg, mxar);
+}
+
+/**
+ * mic_x100_load_command_line() - Load command line to MIC.
+ * @mdev: pointer to mic_device instance
+ * @fw: the firmware image
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int
+mic_x100_load_command_line(struct mic_device *mdev, const struct firmware *fw)
+{
+	u32 len = 0;
+	u32 boot_mem;
+	char *buf;
+	void __iomem *cmd_line_va = mdev->aper.va + mdev->bootaddr + fw->size;
+#define CMDLINE_SIZE 2048
+
+	boot_mem = mdev->aper.len >> 20;
+	buf = kzalloc(CMDLINE_SIZE, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&mdev->pdev->dev,
+			"%s %d allocation failed\n", __func__, __LINE__);
+		return -ENOMEM;
+	}
+	len += snprintf(buf, CMDLINE_SIZE - len,
+		" mem=%dM crashkernel=1M@80M", boot_mem);
+	if (mdev->cmdline)
+		snprintf(buf + len, CMDLINE_SIZE - len,
+				" %s", mdev->cmdline);
+	memcpy_toio(cmd_line_va, buf, strlen(buf) + 1);
+	kfree(buf);
+	return 0;
+}
+
+/**
+ * mic_x100_load_ramdisk() - Load ramdisk to MIC.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int
+mic_x100_load_ramdisk(struct mic_device *mdev)
+{
+	const struct firmware *fw;
+	int rc;
+	struct boot_params __iomem *bp = mdev->aper.va + mdev->bootaddr;
+
+	rc = request_firmware(&fw,
+			mdev->ramdisk, &mdev->pdev->dev);
+	if (rc < 0) {
+		dev_err(&mdev->pdev->dev,
+			"ramdisk request_firmware failed: %d %s\n",
+			rc, mdev->ramdisk);
+		goto error;
+	}
+	/*
+	 * Typically the bootaddr for card OS is 64M
+	 * so copy over the ramdisk @ 128M.
+	 */
+	memcpy_toio(mdev->aper.va + (mdev->bootaddr << 1),
+		fw->data, fw->size);
+	iowrite32(cpu_to_le32(mdev->bootaddr << 1), &bp->hdr.ramdisk_image);
+	iowrite32(cpu_to_le32(fw->size), &bp->hdr.ramdisk_size);
+	release_firmware(fw);
+error:
+	return rc;
+}
+
+/**
+ * mic_x100_get_boot_addr() - Get MIC boot address.
+ * @mdev: pointer to mic_device instance
+ *
+ * This function is called during firmware load to determine
+ * the address at which the OS should be downloaded in card
+ * memory i.e. GDDR.
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int
+mic_x100_get_boot_addr(struct mic_device *mdev)
+{
+	u32 scratch2, boot_addr;
+	int rc = 0;
+
+	scratch2 = mdev->ops->read_spad(mdev, MIC_X100_DOWNLOAD_INFO);
+	boot_addr = MIC_X100_SPAD2_DOWNLOAD_ADDR(scratch2);
+	dev_dbg(&mdev->pdev->dev, "%s %d boot_addr 0x%x\n",
+		__func__, __LINE__, boot_addr);
+	if (boot_addr > (1 << 31)) {
+		dev_err(&mdev->pdev->dev,
+			"incorrect bootaddr 0x%x\n",
+			boot_addr);
+		rc = -EINVAL;
+		goto error;
+	}
+	mdev->bootaddr = boot_addr;
+error:
+	return rc;
+}
+
+/* Either a Linux OS or an ELF for flash updates is currently supported */
+enum mic_mode {
+	MIC_LINUX = 0,
+	MIC_ELF,
+};
+
+static const char * const mic_boot_str[] = {
+	[MIC_LINUX] = "boot:linux:",
+	[MIC_ELF] = "boot:elf:",
+};
+
+/*
+ * mic_x100_parse_fw_path() - Parse firmware/ramdisk path.
+ * @mdev: pointer to mic_device instance
+ * @buf: buffer containing boot string.
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or mode on success.
+ */
+static int mic_parse_fw_path(struct mic_device *mdev, const char *buf)
+{
+	enum mic_mode mode;
+	char *firmware, *ramdisk = NULL;
+	const char *default_mm_image = "mic/RASMM.elf";
+	int len;
+
+	if (!strncmp(buf, mic_boot_str[MIC_LINUX],
+		strlen(mic_boot_str[MIC_LINUX]))) {
+		mode = MIC_LINUX;
+		len = strlen(mic_boot_str[MIC_LINUX]);
+	} else if (!strncmp(buf, mic_boot_str[MIC_ELF],
+		strlen(mic_boot_str[MIC_ELF]))) {
+		mode = MIC_ELF;
+		len = strlen(mic_boot_str[MIC_ELF]);
+	} else {
+		dev_err(&mdev->pdev->dev,
+			"incorrect boot string %s\n", buf);
+		return -EINVAL;
+	}
+	buf += len;
+	len = strlen(buf);
+	if (!(len - 1) && mode == MIC_ELF) {
+		buf = default_mm_image;
+		len = strlen(default_mm_image);
+	}
+	firmware = kmalloc(len + 1, GFP_KERNEL);
+	if (!firmware)
+		return -ENOMEM;
+	memcpy(firmware, buf, len);
+	if ('\n' == firmware[len - 1])
+		firmware[len - 1] = '\0';
+	else
+		firmware[len] = '\0';
+	if (MIC_LINUX == mode) {
+		/*
+		 * if booting linux, the ramdisk image will likely follow.
+		 * The format is "boot:linux:<fw_path>:<ramdisk_path>"
+		 */
+		ramdisk = strchr(firmware, ':');
+		if (ramdisk)
+			*ramdisk++ = '\0';
+	}
+	kfree(mdev->firmware);
+	mdev->firmware = firmware;
+	mdev->ramdisk = ramdisk;
+	return mode;
+}
+
+/**
+ * mic_x100_load_firmware() - Load firmware to MIC.
+ * @mdev: pointer to mic_device instance
+ * @buf: buffer containing boot string including firmware/ramdisk path.
+ *
+ * RETURNS: An appropriate -ERRNO error value on error, or zero for success.
+ */
+static int
+mic_x100_load_firmware(struct mic_device *mdev, const char *buf)
+{
+	int rc, mode;
+	const struct firmware *fw;
+
+	rc = mic_x100_get_boot_addr(mdev);
+	if (rc)
+		goto error;
+	mode = mic_parse_fw_path(mdev, buf);
+	if (mode < 0) {
+		rc = mode;
+		goto error;
+	}
+	/* load OS */
+	rc = request_firmware(&fw, mdev->firmware, &mdev->pdev->dev);
+	if (rc < 0) {
+		dev_err(&mdev->pdev->dev,
+			"ramdisk request_firmware failed: %d %s\n",
+			rc, mdev->firmware);
+		goto error;
+	}
+	if (mdev->bootaddr > mdev->aper.len - fw->size) {
+		rc = -EINVAL;
+		dev_err(&mdev->pdev->dev, "%s %d rc %d bootaddr 0x%x\n",
+			__func__, __LINE__, rc, mdev->bootaddr);
+		release_firmware(fw);
+		goto error;
+	}
+	memcpy_toio(mdev->aper.va + mdev->bootaddr, fw->data, fw->size);
+	mdev->ops->write_spad(mdev, MIC_X100_FW_SIZE, fw->size);
+	if (MIC_ELF == mode)
+		goto done;
+	/* load command line */
+	rc = mic_x100_load_command_line(mdev, fw);
+	if (rc) {
+		dev_err(&mdev->pdev->dev, "%s %d rc %d\n",
+			__func__, __LINE__, rc);
+		goto error;
+	}
+	release_firmware(fw);
+	/* load ramdisk */
+	if (mdev->ramdisk)
+		rc = mic_x100_load_ramdisk(mdev);
+error:
+	dev_dbg(&mdev->pdev->dev, "%s %d rc %d\n",
+			__func__, __LINE__, rc);
+done:
+	return rc;
+}
+
+/**
+ * mic_x100_get_postcode() - Get postcode status from firmware.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: postcode.
+ */
+static u32 mic_x100_get_postcode(struct mic_device *mdev)
+{
+	return mic_mmio_read(&mdev->mmio, MIC_X100_POSTCODE);
+}
+
+/**
+ * mic_x100_smpt_set() - Update an SMPT entry with a DMA address.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: none.
+ */
+static void
+mic_x100_smpt_set(struct mic_device *mdev, dma_addr_t dma_addr, u8 index)
+{
+#define SNOOP_ON	(0 << 0)
+#define SNOOP_OFF	(1 << 0)
+/*
+ * Sbox Smpt Reg Bits:
+ * Bits	31:2	Host address
+ * Bits	1	RSVD
+ * Bits	0	No snoop
+ */
+#define BUILD_SMPT(NO_SNOOP, HOST_ADDR)  \
+	(u32)(((((HOST_ADDR) << 2) & (~0x03)) | ((NO_SNOOP) & (0x01))))
+
+	uint32_t smpt_reg_val = BUILD_SMPT(SNOOP_ON,
+			dma_addr >> mdev->smpt->info.page_shift);
+	mic_mmio_write(&mdev->mmio, smpt_reg_val,
+		MIC_X100_SBOX_BASE_ADDRESS +
+		MIC_X100_SBOX_SMPT00 + (4 * index));
+}
+
+/**
+ * mic_x100_smpt_hw_init() - Initialize SMPT X100 specific fields.
+ * @mdev: pointer to mic_device instance
+ *
+ * RETURNS: none.
+ */
+static void mic_x100_smpt_hw_init(struct mic_device *mdev)
+{
+	struct mic_smpt_hw_info *info = &mdev->smpt->info;
+
+	info->num_reg = 32;
+	info->page_shift = 34;
+	info->page_size = (1ULL << info->page_shift);
+	info->base = 0x8000000000ULL;
+}
+
+struct mic_smpt_ops mic_x100_smpt_ops = {
+	.init = mic_x100_smpt_hw_init,
+	.set = mic_x100_smpt_set,
+};
+
+struct mic_hw_ops mic_x100_ops = {
+	.aper_bar = MIC_X100_APER_BAR,
+	.mmio_bar = MIC_X100_MMIO_BAR,
+	.init = mic_x100_hw_init,
+	.read_spad = mic_x100_read_spad,
+	.write_spad = mic_x100_write_spad,
+	.reset = mic_x100_hw_reset,
+	.reset_fw_ready = mic_x100_reset_fw_ready,
+	.is_fw_ready = mic_x100_is_fw_ready,
+	.send_firmware_intr = mic_x100_send_firmware_intr,
+	.send_intr = mic_x100_send_intr,
+	.ack_interrupt = mic_x100_ack_interrupt,
+	.load_mic_fw = mic_x100_load_firmware,
+	.get_postcode = mic_x100_get_postcode,
+};
+
+struct mic_hw_intr_ops mic_x100_intr_ops = {
+	.intr_init = mic_x100_hw_intr_init,
+	.enable_interrupts = mic_x100_enable_interrupts,
+	.disable_interrupts = mic_x100_disable_interrupts,
+	.program_msi_to_src_map = mic_x100_program_msi_to_src_map,
+	.read_msi_to_src_map = mic_x100_read_msi_to_src_map,
+};
diff --git a/drivers/misc/mic/host/mic_x100.h b/drivers/misc/mic/host/mic_x100.h
new file mode 100644
index 0000000..102fdb8
--- /dev/null
+++ b/drivers/misc/mic/host/mic_x100.h
@@ -0,0 +1,112 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
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
+
+#define MIC_X100_SPAD2_DOWNLOAD_STATUS(x) ((x) & 0x1)
+#define MIC_X100_SPAD2_APIC_ID(x)	(((x) >> 1) & 0x1ff)
+#define MIC_X100_SPAD2_DOWNLOAD_ADDR(x) ((x) & 0xfffff000)
+
+#define MIC_X100_SBOX_SICR0_DBR(x) ((x) & 0xf)
+#define MIC_X100_SBOX_SICR0_DMA(x) (((x) >> 8) & 0xff)
+
+#define MIC_X100_SBOX_SICE0_DBR(x) ((x) & 0xf)
+#define MIC_X100_SBOX_DBR_BITS(x) ((x) & 0xf)
+#define MIC_X100_SBOX_SICE0_DMA(x) (((x) >> 8) & 0xff)
+#define MIC_X100_SBOX_DMA_BITS(x) (((x) & 0xff) << 8)
+
+#define MIC_X100_DOWNLOAD_INFO 2
+#define MIC_X100_FW_SIZE 5
+
+#define MIC_X100_SBOX_SPAD0 0x0000AB20
+#define MIC_X100_SBOX_APICICR0 0x0000A9D0
+#define MIC_X100_SBOX_APICICR7 0x0000AA08
+#define MIC_X100_SBOX_RGCR 0x00004010
+#define MIC_X100_SBOX_SICR0 0x00009004
+#define MIC_X100_SBOX_SICE0 0x0000900C
+#define MIC_X100_SBOX_SICC0 0x00009010
+#define MIC_X100_SBOX_SIAC0 0x00009014
+#define MIC_X100_SBOX_MSIXPBACR_K1OM 0x00009084
+#define MIC_X100_SBOX_MXAR0 0x00009040
+#define MIC_X100_SBOX_MXAR0_K1OM 0x00009044
+#define MIC_X100_SBOX_SDBIC3 0x0000CC9C
+#define MIC_X100_SBOX_SDBIC0 0x0000CC90
+#define MIC_X100_SBOX_SMPT00 0x00003100
+#define MIC_X100_SBOX_RDMASR0 0x0000B180
+
+#define MIC_X100_POSTCODE 0x242c
+
+#define MIC_X100_DOORBELL_IDX_START 0
+#define MIC_X100_NUM_DOORBELL 4
+#define MIC_X100_DMA_IDX_START 8
+#define MIC_X100_NUM_DMA 8
+#define MIC_X100_ERR_IDX_START 30
+#define MIC_X100_NUM_ERR 1
+
+#define MIC_X100_NUM_SBOX_IRQ 8
+#define MIC_X100_NUM_RDMASR_IRQ 8
+#define MIC_X100_RDMASR_IRQ_BASE 17
+
+#define MIC_NUM_OFFSETS 32
+
+static const u16 mic_x100_intr_init[] = {
+		MIC_X100_DOORBELL_IDX_START,
+		MIC_X100_DMA_IDX_START,
+		MIC_X100_ERR_IDX_START,
+		MIC_X100_NUM_DOORBELL,
+		MIC_X100_NUM_DMA,
+		MIC_X100_NUM_ERR,
+};
+
+/* Host->Card(bootstrap) Interrupt Vector */
+#define MIC_X100_BSP_INTERRUPT_VECTOR 229
+
+extern struct mic_hw_ops mic_x100_ops;
+extern struct mic_smpt_ops mic_x100_smpt_ops;
+extern struct mic_hw_intr_ops mic_x100_intr_ops;
+
+#endif
diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
index bdc6e87..8f985dd 100644
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -239,6 +239,7 @@ header-y += media.h
 header-y += mei.h
 header-y += mempolicy.h
 header-y += meye.h
+header-y += mic_common.h
 header-y += mii.h
 header-y += minix_fs.h
 header-y += mman.h
diff --git a/include/uapi/linux/mic_common.h b/include/uapi/linux/mic_common.h
new file mode 100644
index 0000000..b8edede
--- /dev/null
+++ b/include/uapi/linux/mic_common.h
@@ -0,0 +1,79 @@
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301
+ * USA.
+ *
+ * The full GNU General Public License is included in this distribution in
+ * the file called "COPYING".
+ *
+ * Intel MIC driver.
+ *
+ */
+#ifndef __MIC_COMMON_H_
+#define __MIC_COMMON_H_
+
+#include <linux/types.h>
+
+/**
+ * struct mic_bootparam: Virtio device independent information in device page
+ *
+ * @magic: A magic value used by the card to ensure it can see the host
+ * @c2h_shutdown_db: Card to Host shutdown doorbell set by host
+ * @h2c_shutdown_db: Host to Card shutdown doorbell set by card
+ * @h2c_config_db: Host to Card Virtio config doorbell set by card
+ * @shutdown_status: Card shutdown status set by card
+ * @shutdown_card: Set to 1 by the host when a card shutdown is initiated
+ */
+struct mic_bootparam {
+	__u32 magic;
+	__s8 c2h_shutdown_db;
+	__s8 h2c_shutdown_db;
+	__s8 h2c_config_db;
+	__u8 shutdown_status;
+	__u8 shutdown_card;
+} __aligned(8);
+
+/* Device page size */
+#define MIC_DP_SIZE 4096
+
+#define MIC_MAGIC 0xc0ffee00
+
+/**
+ * enum mic_states - MIC states.
+ */
+enum mic_states {
+	MIC_OFFLINE = 0,
+	MIC_ONLINE,
+	MIC_SHUTTING_DOWN,
+	MIC_RESET_FAILED,
+	MIC_LAST
+};
+
+/**
+ * enum mic_status - MIC status reported by card after
+ * a host or card initiated shutdown or a card crash.
+ */
+enum mic_status {
+	MIC_NOP = 0,
+	MIC_CRASHED,
+	MIC_HALTED,
+	MIC_POWER_OFF,
+	MIC_RESTART,
+	MIC_STATUS_LAST
+};
+
+#endif
-- 
1.8.2.1

