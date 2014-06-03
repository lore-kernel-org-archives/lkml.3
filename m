Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbaFCSXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:23:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:15343 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012AbaFCSX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:23:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,967,1392192000"; 
   d="scan'208";a="549200878"
Date: Tue, 3 Jun 2014 11:23:19 -0700
From: Tadeusz Struk <tadeusz.struk@intel.com>
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, john.griffin@intel.com, bruce.w.allan@intel.com,
        karen.xiang@intel.com, pingchaox.yang@intel.com, bo.cui@intel.com,
        davem@davemloft.net, qat-linux@intel.com, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, ben@decadent.org.uk
Subject: [RFC][PATCH 1/4] crypto: Intel QAT driver driver framework
Message-ID: <20140603182319.GA18675@gitlad.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a common infractructure that will be used by all QAT devices.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Acked-by: John Griffin <john.griffin@intel.com>
Reviewed-by: Bruce W. Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/Makefile             |   11 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h  |  204 ++++
 drivers/crypto/qat/qat_common/adf_accel_engine.c   |  168 ++++
 drivers/crypto/qat/qat_common/adf_aer.c            |  258 +++++
 drivers/crypto/qat/qat_common/adf_cfg.c            |  359 +++++++
 drivers/crypto/qat/qat_common/adf_cfg.h            |   87 ++
 drivers/crypto/qat/qat_common/adf_cfg_common.h     |  100 ++
 drivers/crypto/qat/qat_common/adf_cfg_strings.h    |   83 ++
 drivers/crypto/qat/qat_common/adf_cfg_user.h       |   94 ++
 drivers/crypto/qat/qat_common/adf_common_drv.h     |  192 ++++
 drivers/crypto/qat/qat_common/adf_ctl_drv.c        |  490 ++++++++++
 drivers/crypto/qat/qat_common/adf_dev_mgr.c        |  215 ++++
 drivers/crypto/qat/qat_common/adf_init.c           |  388 ++++++++
 drivers/crypto/qat/qat_common/adf_transport.c      |  565 +++++++++++
 drivers/crypto/qat/qat_common/adf_transport.h      |   63 ++
 .../qat/qat_common/adf_transport_access_macros.h   |  160 +++
 .../crypto/qat/qat_common/adf_transport_debug.c    |  301 ++++++
 .../crypto/qat/qat_common/adf_transport_internal.h |  115 +++
 drivers/crypto/qat/qat_common/icp_qat_fw.h         |  316 ++++++
 .../crypto/qat/qat_common/icp_qat_fw_init_admin.h  |  131 +++
 drivers/crypto/qat/qat_common/icp_qat_fw_la.h      |  403 ++++++++
 drivers/crypto/qat/qat_common/icp_qat_hw.h         |  305 ++++++
 drivers/crypto/qat/qat_common/qat_algs.c           | 1033 ++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_crypto.c         |  284 ++++++
 drivers/crypto/qat/qat_common/qat_crypto.h         |   83 ++
 25 files changed, 6408 insertions(+)
 create mode 100644 drivers/crypto/qat/qat_common/Makefile
 create mode 100644 drivers/crypto/qat/qat_common/adf_accel_devices.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_accel_engine.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_aer.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_cfg.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_cfg.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_cfg_common.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_cfg_strings.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_cfg_user.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_common_drv.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_ctl_drv.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_dev_mgr.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_init.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_transport.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_transport.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_transport_access_macros.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_transport_debug.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_transport_internal.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_la.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_hw.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_algs.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_crypto.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_crypto.h

diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
new file mode 100644
index 0000000..a0c21ea
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -0,0 +1,11 @@
+obj-$(CONFIG_CRYPTO_DEV_QAT) += intel_qat.o
+intel_qat-objs := adf_cfg.o \
+	adf_ctl_drv.o \
+	adf_dev_mgr.o \
+	adf_init.o \
+	adf_accel_engine.o \
+	adf_aer.o \
+	adf_transport.o \
+	adf_transport_debug.o \
+	qat_crypto.o \
+	qat_algs.o
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
new file mode 100644
index 0000000..f3206d9
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -0,0 +1,204 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_ACCEL_DEVICES_H_
+#define ADF_ACCEL_DEVICES_H_
+#include <linux/module.h>
+#include <linux/atomic.h>
+#include <linux/list.h>
+#include <linux/proc_fs.h>
+#include "adf_cfg_common.h"
+
+#define PCI_VENDOR_ID_INTEL 0x8086
+#define ADF_DH895XCC_DEVICE_NAME "dh895xcc"
+#define ADF_DH895XCC_PCI_DEVICE_ID 0x435
+#define ADF_DH895XCC_PMISC_BAR 1
+#define ADF_DH895XCC_ETR_BAR 2
+#define ADF_PCI_MAX_BARS 3
+#define ADF_DEVICE_NAME_LENGTH 32
+#define ADF_ETR_MAX_RINGS_PER_BANK 16
+#define ADF_MAX_MSIX_VECTOR_NAME 16
+#define ADF_DEVICE_NAME_PREFIX "qat_"
+
+enum adf_accel_capabilities {
+	ADF_ACCEL_CAPABILITIES_NULL = 0,
+	ADF_ACCEL_CAPABILITIES_CRYPTO_SYMMETRIC = 1,
+	ADF_ACCEL_CAPABILITIES_CRYPTO_ASYMMETRIC = 2,
+	ADF_ACCEL_CAPABILITIES_CIPHER = 4,
+	ADF_ACCEL_CAPABILITIES_AUTHENTICATION = 8,
+	ADF_ACCEL_CAPABILITIES_COMPRESSION = 32,
+	ADF_ACCEL_CAPABILITIES_LZS_COMPRESSION = 64,
+	ADF_ACCEL_CAPABILITIES_RANDOM_NUMBER = 128
+};
+
+struct adf_bar {
+	resource_size_t base_addr;
+	void __iomem *virt_addr;
+	resource_size_t size;
+} __packed;
+
+struct adf_accel_msix {
+	struct msix_entry *entries;
+	char **names;
+} __packed;
+
+struct adf_accel_pci {
+	struct pci_dev *pci_dev;
+	struct adf_accel_msix msix_entries;
+	struct adf_bar pci_bars[ADF_PCI_MAX_BARS];
+	uint8_t revid;
+	uint8_t sku;
+} __packed;
+
+enum dev_state {
+	DEV_DOWN = 0,
+	DEV_UP
+};
+
+enum dev_sku_info {
+	DEV_SKU_1 = 0,
+	DEV_SKU_2,
+	DEV_SKU_3,
+	DEV_SKU_4,
+	DEV_SKU_UNKNOWN,
+};
+
+static inline const char *get_sku_info(enum dev_sku_info info)
+{
+	switch (info) {
+	case DEV_SKU_1:
+		return "SKU1";
+	case DEV_SKU_2:
+		return "SKU2";
+	case DEV_SKU_3:
+		return "SKU3";
+	case DEV_SKU_4:
+		return "SKU4";
+	case DEV_SKU_UNKNOWN:
+	default:
+		break;
+	}
+	return "Unknown SKU";
+}
+
+struct adf_hw_device_class {
+	const char *name;
+	const enum adf_device_type type;
+	uint32_t instances;
+} __packed;
+
+struct adf_cfg_device_data;
+struct adf_accel_dev;
+struct adf_etr_data;
+struct adf_etr_ring_data;
+
+struct adf_hw_device_data {
+	struct adf_hw_device_class *dev_class;
+	uint32_t (*get_accel_mask)(uint32_t fuse);
+	uint32_t (*get_ae_mask)(uint32_t fuse);
+	uint32_t (*get_misc_bar_id)(struct adf_hw_device_data *self);
+	uint32_t (*get_etr_bar_id)(struct adf_hw_device_data *self);
+	uint32_t (*get_num_aes)(struct adf_hw_device_data *self);
+	uint32_t (*get_num_accels)(struct adf_hw_device_data *self);
+	enum dev_sku_info (*get_sku)(struct adf_hw_device_data *self);
+	void (*hw_arb_ring_enable)(struct adf_etr_ring_data *ring);
+	void (*hw_arb_ring_disable)(struct adf_etr_ring_data *ring);
+	int (*alloc_irq)(struct adf_accel_dev *accel_dev);
+	void (*free_irq)(struct adf_accel_dev *accel_dev);
+	void (*enable_error_correction)(struct adf_accel_dev *accel_dev);
+	const char *fw_name;
+	uint32_t pci_dev_id;
+	uint32_t fuses;
+	uint32_t accel_capabilities_mask;
+	uint16_t accel_mask;
+	uint16_t ae_mask;
+	uint16_t tx_rings_mask;
+	uint8_t tx_rx_gap;
+	uint8_t instance_id;
+	uint8_t num_banks;
+	uint8_t num_accel;
+	uint8_t num_logical_accel;
+	uint8_t num_engines;
+} __packed;
+
+/* CSR write macro */
+#define ADF_CSR_WR(csr_base, csr_offset, val) \
+	__raw_writel(val, csr_base + csr_offset)
+
+/* CSR read macro */
+#define ADF_CSR_RD(csr_base, csr_offset) __raw_readl(csr_base + csr_offset)
+
+#define GET_DEV(accel_dev) ((accel_dev)->accel_pci_dev.pci_dev->dev)
+#define GET_BARS(accel_dev) ((accel_dev)->accel_pci_dev.pci_bars)
+#define GET_HW_DATA(accel_dev) (accel_dev->hw_device)
+#define GET_MAX_BANKS(accel_dev) (GET_HW_DATA(accel_dev)->num_banks)
+#define GET_MAX_ACCELENGINES(accel_dev) (GET_HW_DATA(accel_dev)->num_engines)
+#define accel_to_pci_dev(accel_ptr) accel_ptr->accel_pci_dev.pci_dev
+
+struct adf_admin_comms;
+struct icp_qat_fw_loader_handle;
+struct adf_fw_loader_data {
+	struct icp_qat_fw_loader_handle *fw_loader;
+	const struct firmware *uof_fw;
+};
+
+struct adf_accel_dev {
+	struct adf_etr_data *transport;
+	struct adf_hw_device_data *hw_device;
+	struct adf_cfg_device_data *cfg;
+	struct adf_fw_loader_data *fw_loader;
+	struct adf_admin_comms *admin;
+	struct list_head crypto_list;
+	unsigned long status;
+	atomic_t ref_count;
+	struct dentry *debugfs_dir;
+	struct list_head list;
+	struct module *owner;
+	uint8_t accel_id;
+	uint8_t numa_node;
+	struct adf_accel_pci accel_pci_dev;
+} __packed;
+#endif
diff --git a/drivers/crypto/qat/qat_common/adf_accel_engine.c b/drivers/crypto/qat/qat_common/adf_accel_engine.c
new file mode 100644
index 0000000..25801fe
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_accel_engine.c
@@ -0,0 +1,168 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/firmware.h>
+#include <linux/pci.h>
+#include "adf_cfg.h"
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "icp_qat_uclo.h"
+
+int adf_ae_fw_load(struct adf_accel_dev *accel_dev)
+{
+	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+	struct adf_hw_device_data *hw_device = accel_dev->hw_device;
+	void *uof_addr;
+	uint32_t uof_size;
+
+	if (request_firmware(&loader_data->uof_fw, hw_device->fw_name,
+			     &accel_dev->accel_pci_dev.pci_dev->dev)) {
+		pr_err("QAT: Failed to load firmware %s\n", hw_device->fw_name);
+		return -EFAULT;
+	}
+
+	uof_size = loader_data->uof_fw->size;
+	uof_addr = (void *)loader_data->uof_fw->data;
+	if (qat_uclo_map_uof_obj(loader_data->fw_loader, uof_addr, uof_size)) {
+		pr_err("QAT: Failed to map uof\n");
+		goto out_err;
+	}
+	if (qat_uclo_wr_all_uimage(loader_data->fw_loader)) {
+		pr_err("QAT: Failed to map uof\n");
+		goto out_err;
+	}
+	return 0;
+
+out_err:
+	release_firmware(loader_data->uof_fw);
+	return -EFAULT;
+}
+
+int adf_ae_fw_release(struct adf_accel_dev *accel_dev)
+{
+	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+
+	release_firmware(loader_data->uof_fw);
+	qat_uclo_del_uof_obj(loader_data->fw_loader);
+	qat_hal_deinit(loader_data->fw_loader);
+	loader_data->fw_loader = NULL;
+	return 0;
+}
+
+int adf_ae_start(struct adf_accel_dev *accel_dev)
+{
+	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	uint32_t ae_ctr, ae, max_aes = GET_MAX_ACCELENGINES(accel_dev);
+
+	for (ae = 0, ae_ctr = 0; ae < max_aes; ae++) {
+		if (hw_data->ae_mask & (1 << ae)) {
+			qat_hal_start(loader_data->fw_loader, ae, 0xFF);
+			ae_ctr++;
+		}
+	}
+	pr_info("QAT: qat_dev%d started %d acceleration engines\n",
+		accel_dev->accel_id, ae_ctr);
+	return 0;
+}
+
+int adf_ae_stop(struct adf_accel_dev *accel_dev)
+{
+	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	uint32_t ae_ctr, ae, max_aes = GET_MAX_ACCELENGINES(accel_dev);
+
+	for (ae = 0, ae_ctr = 0; ae < max_aes; ae++) {
+		if (hw_data->ae_mask & (1 << ae)) {
+			qat_hal_stop(loader_data->fw_loader, ae, 0xFF);
+			ae_ctr++;
+		}
+	}
+	pr_info("QAT: qat_dev%d stopped %d acceleration engines\n",
+		accel_dev->accel_id, ae_ctr);
+	return 0;
+}
+
+static int adf_ae_reset(struct adf_accel_dev *accel_dev, int ae)
+{
+	struct adf_fw_loader_data *loader_data = accel_dev->fw_loader;
+
+	qat_hal_reset(loader_data->fw_loader);
+	if (qat_hal_clr_reset(loader_data->fw_loader))
+		return -EFAULT;
+
+	return 0;
+}
+
+int adf_ae_init(struct adf_accel_dev *accel_dev)
+{
+	struct adf_fw_loader_data *loader_data;
+
+	loader_data = kzalloc(sizeof(*loader_data), GFP_KERNEL);
+	if (!loader_data)
+		return -ENOMEM;
+
+	accel_dev->fw_loader = loader_data;
+	if (qat_hal_init(accel_dev)) {
+		pr_err("QAT: Failed to init the AEs\n");
+		kfree(loader_data);
+		return -EFAULT;
+	}
+	if (adf_ae_reset(accel_dev, 0)) {
+		pr_err("QAT: Failed to reset the AEs\n");
+		qat_hal_deinit(loader_data->fw_loader);
+		kfree(loader_data);
+		return -EFAULT;
+	}
+	return 0;
+}
+
+int adf_ae_shutdown(struct adf_accel_dev *accel_dev)
+{
+	kfree(accel_dev->fw_loader);
+	accel_dev->fw_loader = NULL;
+	return 0;
+}
diff --git a/drivers/crypto/qat/qat_common/adf_aer.c b/drivers/crypto/qat/qat_common/adf_aer.c
new file mode 100644
index 0000000..0651678
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_aer.c
@@ -0,0 +1,258 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/aer.h>
+#include <linux/completion.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+
+static struct workqueue_struct *device_reset_wq;
+
+static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
+					   pci_channel_state_t state)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	pr_info("QAT: Acceleration driver hardware error detected.\n");
+	if (!accel_dev) {
+		pr_err("QAT: Can't find acceleration device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	if (state == pci_channel_io_perm_failure) {
+		pr_err("QAT: Can't recover from device error\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/* reset dev data */
+struct adf_reset_dev_data {
+	int mode;
+	struct adf_accel_dev *accel_dev;
+	struct completion compl;
+	struct work_struct reset_work;
+};
+
+#define PPDSTAT_OFFSET 0x7E
+static void adf_dev_restore(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+	struct pci_dev *parent = pdev->bus->self;
+	uint16_t ppdstat = 0, bridge_ctl = 0;
+	int pending = 0;
+
+	pr_info("QAT: Reseting device qat_dev%d\n", accel_dev->accel_id);
+	pci_read_config_word(pdev, PPDSTAT_OFFSET, &ppdstat);
+	pending = ppdstat & PCI_EXP_DEVSTA_TRPND;
+	if (pending) {
+		int ctr = 0;
+		do {
+			msleep(100);
+			pci_read_config_word(pdev, PPDSTAT_OFFSET, &ppdstat);
+			pending = ppdstat & PCI_EXP_DEVSTA_TRPND;
+		} while (pending && ctr++ < 10);
+	}
+
+	if (pending)
+		pr_info("QAT: Transaction still in progress. Proceeding\n");
+
+	pci_read_config_word(parent, PCI_BRIDGE_CONTROL, &bridge_ctl);
+	bridge_ctl |= PCI_BRIDGE_CTL_BUS_RESET;
+	pci_write_config_word(parent, PCI_BRIDGE_CONTROL, bridge_ctl);
+	msleep(100);
+	bridge_ctl &= ~PCI_BRIDGE_CTL_BUS_RESET;
+	pci_write_config_word(parent, PCI_BRIDGE_CONTROL, bridge_ctl);
+	msleep(100);
+	pci_restore_state(pdev);
+	pci_save_state(pdev);
+}
+
+static void adf_device_reset_worker(struct work_struct *work)
+{
+	struct adf_reset_dev_data *reset_data =
+		  container_of(work, struct adf_reset_dev_data, reset_work);
+	struct adf_accel_dev *accel_dev = reset_data->accel_dev;
+
+	adf_dev_restarting_notify(accel_dev);
+	adf_dev_stop(accel_dev);
+	adf_dev_restore(accel_dev);
+	if (adf_dev_start(accel_dev)) {
+		/* The device hanged and we can't restart it so stop here */
+		dev_err(&GET_DEV(accel_dev), "Restart device failed\n");
+		kfree(reset_data);
+		WARN(1, "QAT: device restart failed. Device is unusable\n");
+		return;
+	}
+	adf_dev_restarted_notify(accel_dev);
+	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
+
+	/* The dev is back alive. Notify the caller if in sync mode */
+	if (reset_data->mode == ADF_DEV_RESET_SYNC)
+		complete(&reset_data->compl);
+	else
+		kfree(reset_data);
+}
+
+static int adf_dev_aer_schedule_reset(struct adf_accel_dev *accel_dev,
+				      enum adf_dev_reset_mode mode)
+{
+	struct adf_reset_dev_data *reset_data;
+
+	if (adf_dev_started(accel_dev) &&
+	    !test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
+		return 0;
+
+	set_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
+	reset_data = kzalloc(sizeof(*reset_data), GFP_ATOMIC);
+	if (!reset_data)
+		return -ENOMEM;
+	reset_data->accel_dev = accel_dev;
+	init_completion(&reset_data->compl);
+	reset_data->mode = mode;
+	INIT_WORK(&reset_data->reset_work, adf_device_reset_worker);
+	queue_work(device_reset_wq, &reset_data->reset_work);
+
+	/* If in sync mode wait for the result */
+	if (mode == ADF_DEV_RESET_SYNC) {
+		int ret = 0;
+		/* Maximum device reset time is 10 seconds */
+		unsigned long wait_jiffies = msecs_to_jiffies(10000);
+		unsigned long timeout = wait_for_completion_timeout(
+				   &reset_data->compl, wait_jiffies);
+		if (!timeout) {
+			pr_err("QAT: Reset device timeout expired\n");
+			ret = -EFAULT;
+		}
+		kfree(reset_data);
+		return ret;
+	}
+	return 0;
+}
+
+static pci_ers_result_t adf_slot_reset(struct pci_dev *pdev)
+{
+	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
+
+	if (!accel_dev) {
+		pr_err("QAT: Can't find acceleration device\n");
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+	pci_cleanup_aer_uncorrect_error_status(pdev);
+	if (adf_dev_aer_schedule_reset(accel_dev, ADF_DEV_RESET_SYNC))
+		return PCI_ERS_RESULT_DISCONNECT;
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+static void adf_resume(struct pci_dev *pdev)
+{
+	pr_info("QAT: Acceleration driver reset completed\n");
+	pr_info("QAT: Device is up and runnig\n");
+}
+
+static struct pci_error_handlers adf_err_handler = {
+	.error_detected = adf_error_detected,
+	.slot_reset = adf_slot_reset,
+	.resume = adf_resume,
+};
+
+/**
+ * adf_enable_aer() - Enable Advance Error Reporting for acceleration device
+ * @accel_dev:  Pointer to acceleration device.
+ * @adf:        PCI device driver owning the given acceleration device.
+ *
+ * Function enables PCI Advance Error Reporting for the
+ * QAT acceleration device accel_dev.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_enable_aer(struct adf_accel_dev *accel_dev, struct pci_driver *adf)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+
+	adf->err_handler = &adf_err_handler;
+	pci_enable_pcie_error_reporting(pdev);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_enable_aer);
+
+/**
+ * adf_disable_aer() - Enable Advance Error Reporting for acceleration device
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function disables PCI Advance Error Reporting for the
+ * QAT acceleration device accel_dev.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: void
+ */
+void adf_disable_aer(struct adf_accel_dev *accel_dev)
+{
+	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
+
+	pci_disable_pcie_error_reporting(pdev);
+}
+EXPORT_SYMBOL_GPL(adf_disable_aer);
+
+int adf_init_aer(void)
+{
+	device_reset_wq = create_workqueue("qat_device_reset_wq");
+	return (device_reset_wq == NULL) ? -EFAULT : 0;
+}
+
+void adf_exit_aer(void)
+{
+	if (device_reset_wq)
+		destroy_workqueue(device_reset_wq);
+	device_reset_wq = NULL;
+}
diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
new file mode 100644
index 0000000..389c0cf
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -0,0 +1,359 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/seq_file.h>
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_cfg.h"
+
+static DEFINE_MUTEX(qat_cfg_read_lock);
+
+static void *qat_dev_cfg_start(struct seq_file *sfile, loff_t *pos)
+{
+	struct adf_cfg_device_data *dev_cfg = sfile->private;
+	mutex_lock(&qat_cfg_read_lock);
+	return seq_list_start(&dev_cfg->sec_list, *pos);
+}
+
+static int qat_dev_cfg_show(struct seq_file *sfile, void *v)
+{
+	struct list_head *list;
+	struct adf_cfg_section *sec =
+				list_entry(v, struct adf_cfg_section, list);
+
+	seq_printf(sfile, "[%s]\n", sec->name);
+	list_for_each(list, &sec->param_head) {
+		struct adf_cfg_key_val *ptr =
+			list_entry(list, struct adf_cfg_key_val, list);
+		seq_printf(sfile, "%s = %s\n", ptr->key, ptr->val);
+	}
+	return 0;
+}
+
+static void *qat_dev_cfg_next(struct seq_file *sfile, void *v, loff_t *pos)
+{
+	struct adf_cfg_device_data *dev_cfg = sfile->private;
+	return seq_list_next(v, &dev_cfg->sec_list, pos);
+}
+
+static void qat_dev_cfg_stop(struct seq_file *sfile, void *v)
+{
+	mutex_unlock(&qat_cfg_read_lock);
+}
+
+static const struct seq_operations qat_dev_cfg_sops = {
+	.start = qat_dev_cfg_start,
+	.next = qat_dev_cfg_next,
+	.stop = qat_dev_cfg_stop,
+	.show = qat_dev_cfg_show
+};
+
+static int qat_dev_cfg_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open(file, &qat_dev_cfg_sops);
+
+	if (!ret) {
+		struct seq_file *seq_f = file->private_data;
+		seq_f->private = inode->i_private;
+	}
+	return ret;
+}
+
+static const struct file_operations qat_dev_cfg_fops = {
+	.open = qat_dev_cfg_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release
+};
+
+/**
+ * adf_cfg_dev_add() - Create an acceleration device configuration table.
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function creates a configuration table for the given acceleration device.
+ * The table stores device specific config values.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_cfg_dev_add(struct adf_accel_dev *accel_dev)
+{
+	struct adf_cfg_device_data *dev_cfg_data;
+
+	dev_cfg_data = kzalloc(sizeof(*dev_cfg_data), GFP_KERNEL);
+	if (!dev_cfg_data)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&dev_cfg_data->sec_list);
+	init_rwsem(&dev_cfg_data->lock);
+	accel_dev->cfg = dev_cfg_data;
+
+	/* accel_dev->debugfs_dir should always be non-NULL here */
+	dev_cfg_data->debug = debugfs_create_file("dev_cfg", S_IRUSR,
+						  accel_dev->debugfs_dir,
+						  dev_cfg_data,
+						  &qat_dev_cfg_fops);
+	if (!dev_cfg_data->debug) {
+		pr_err("QAT: Failed to create qat cfg debugfs entry.\n");
+		kfree(dev_cfg_data);
+		accel_dev->cfg = NULL;
+		return -EFAULT;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_cfg_dev_add);
+
+static void adf_cfg_section_del_all(struct list_head *head);
+
+void adf_cfg_del_all(struct adf_accel_dev *accel_dev)
+{
+	struct adf_cfg_device_data *dev_cfg_data = accel_dev->cfg;
+
+	down_write(&dev_cfg_data->lock);
+	adf_cfg_section_del_all(&dev_cfg_data->sec_list);
+	up_write(&dev_cfg_data->lock);
+}
+
+/**
+ * adf_cfg_dev_remove() - Clears acceleration device configuration table.
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function removes configuration table from the given acceleration device
+ * and frees all allocated memory.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: void
+ */
+void adf_cfg_dev_remove(struct adf_accel_dev *accel_dev)
+{
+	struct adf_cfg_device_data *dev_cfg_data = accel_dev->cfg;
+
+	down_write(&dev_cfg_data->lock);
+	adf_cfg_section_del_all(&dev_cfg_data->sec_list);
+	up_write(&dev_cfg_data->lock);
+	debugfs_remove(dev_cfg_data->debug);
+	kfree(dev_cfg_data);
+	accel_dev->cfg = NULL;
+}
+EXPORT_SYMBOL_GPL(adf_cfg_dev_remove);
+
+static void adf_cfg_keyval_add(struct adf_cfg_key_val *new,
+			       struct adf_cfg_section *sec)
+{
+	list_add_tail(&new->list, &sec->param_head);
+}
+
+static void adf_cfg_keyval_del_all(struct list_head *head)
+{
+	struct list_head *list_ptr, *tmp;
+
+	list_for_each_prev_safe(list_ptr, tmp, head) {
+		struct adf_cfg_key_val *ptr =
+			list_entry(list_ptr, struct adf_cfg_key_val, list);
+		list_del(list_ptr);
+		kfree(ptr);
+	}
+}
+
+static void adf_cfg_section_del_all(struct list_head *head)
+{
+	struct adf_cfg_section *ptr;
+	struct list_head *list, *tmp;
+
+	list_for_each_prev_safe(list, tmp, head) {
+		ptr = list_entry(list, struct adf_cfg_section, list);
+		adf_cfg_keyval_del_all(&ptr->param_head);
+		list_del(list);
+		kfree(ptr);
+	}
+}
+
+static struct adf_cfg_key_val *adf_cfg_key_value_find(struct adf_cfg_section *s,
+						      const char *key)
+{
+	struct list_head *list;
+
+	list_for_each(list, &s->param_head) {
+		struct adf_cfg_key_val *ptr =
+			list_entry(list, struct adf_cfg_key_val, list);
+		if (!strcmp(ptr->key, key))
+			return ptr;
+	}
+	return NULL;
+}
+
+static struct adf_cfg_section *adf_cfg_sec_find(struct adf_accel_dev *accel_dev,
+						const char *sec_name)
+{
+	struct adf_cfg_device_data *cfg = accel_dev->cfg;
+	struct list_head *list;
+
+	list_for_each(list, &cfg->sec_list) {
+		struct adf_cfg_section *ptr =
+			list_entry(list, struct adf_cfg_section, list);
+		if (!strcmp(ptr->name, sec_name))
+			return ptr;
+	}
+	return NULL;
+}
+
+static int adf_cfg_key_val_get(struct adf_accel_dev *accel_dev,
+			       const char *sec_name,
+			       const char *key_name,
+			       char *val)
+{
+	struct adf_cfg_section *sec = adf_cfg_sec_find(accel_dev, sec_name);
+	struct adf_cfg_key_val *keyval = NULL;
+
+	if (sec)
+		keyval = adf_cfg_key_value_find(sec, key_name);
+	if (keyval) {
+		memcpy(val, keyval->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES);
+		return 0;
+	}
+	return -1;
+}
+
+/**
+ * adf_cfg_add_key_value_param() - Add key-value config entry to config table.
+ * @accel_dev:  Pointer to acceleration device.
+ * @section_name: Name of the section where the param will be added
+ * @key: The key string
+ * @val: Value pain for the given @key
+ * @type: Type - string, int or address
+ *
+ * Function adds configuration key - value entry in the appropriate section
+ * in the given acceleration device
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
+				const char *section_name,
+				const char *key, const void *val,
+				enum adf_cfg_val_type type)
+{
+	struct adf_cfg_device_data *cfg = accel_dev->cfg;
+	struct adf_cfg_key_val *key_val;
+	struct adf_cfg_section *section = adf_cfg_sec_find(accel_dev,
+							   section_name);
+	if (!section)
+		return -EFAULT;
+
+	key_val = kzalloc(sizeof(*key_val), GFP_KERNEL);
+	if (!key_val)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&key_val->list);
+	strlcpy(key_val->key, key, sizeof(key_val->key));
+
+	if (type == ADF_DEC) {
+		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
+			 "%ld", (*((long *)val)));
+	} else if (type == ADF_STR) {
+		strlcpy(key_val->val, (char *)val, sizeof(key_val->val));
+	} else if (type == ADF_HEX) {
+		snprintf(key_val->val, ADF_CFG_MAX_VAL_LEN_IN_BYTES,
+			 "0x%lx", (unsigned long)val);
+	} else {
+		pr_err("QAT: Unknown type given.\n");
+		kfree(key_val);
+		return -1;
+	}
+	key_val->type = type;
+	down_write(&cfg->lock);
+	adf_cfg_keyval_add(key_val, section);
+	up_write(&cfg->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_cfg_add_key_value_param);
+
+/**
+ * adf_cfg_section_add() - Add config section entry to config table.
+ * @accel_dev:  Pointer to acceleration device.
+ * @name: Name of the section
+ *
+ * Function adds configuration section where key - value entries
+ * will be stored.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name)
+{
+	struct adf_cfg_device_data *cfg = accel_dev->cfg;
+	struct adf_cfg_section *sec = adf_cfg_sec_find(accel_dev, name);
+
+	if (sec)
+		return 0;
+
+	sec = kzalloc(sizeof(*sec), GFP_KERNEL);
+	if (!sec)
+		return -ENOMEM;
+
+	strlcpy(sec->name, name, sizeof(sec->name));
+	INIT_LIST_HEAD(&sec->param_head);
+	down_write(&cfg->lock);
+	list_add_tail(&sec->list, &cfg->sec_list);
+	up_write(&cfg->lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_cfg_section_add);
+
+int adf_cfg_get_param_value(struct adf_accel_dev *accel_dev,
+			    const char *section, const char *name,
+			    char *value)
+{
+	struct adf_cfg_device_data *cfg = accel_dev->cfg;
+	int ret;
+
+	down_read(&cfg->lock);
+	ret = adf_cfg_key_val_get(accel_dev, section, name, value);
+	up_read(&cfg->lock);
+	return ret;
+}
diff --git a/drivers/crypto/qat/qat_common/adf_cfg.h b/drivers/crypto/qat/qat_common/adf_cfg.h
new file mode 100644
index 0000000..6a9c6f6
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_cfg.h
@@ -0,0 +1,87 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_CFG_H_
+#define ADF_CFG_H_
+
+#include <linux/list.h>
+#include <linux/rwsem.h>
+#include <linux/debugfs.h>
+#include "adf_accel_devices.h"
+#include "adf_cfg_common.h"
+#include "adf_cfg_strings.h"
+
+struct adf_cfg_key_val {
+	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+	enum adf_cfg_val_type type;
+	struct list_head list;
+};
+
+struct adf_cfg_section {
+	char name[ADF_CFG_MAX_SECTION_LEN_IN_BYTES];
+	struct list_head list;
+	struct list_head param_head;
+};
+
+struct adf_cfg_device_data {
+	struct list_head sec_list;
+	struct dentry *debug;
+	struct rw_semaphore lock;
+};
+
+int adf_cfg_dev_add(struct adf_accel_dev *accel_dev);
+void adf_cfg_dev_remove(struct adf_accel_dev *accel_dev);
+int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name);
+void adf_cfg_del_all(struct adf_accel_dev *accel_dev);
+int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
+				const char *section_name,
+				const char *key, const void *val,
+				enum adf_cfg_val_type type);
+int adf_cfg_get_param_value(struct adf_accel_dev *accel_dev,
+			    const char *section, const char *name, char *value);
+
+#endif
diff --git a/drivers/crypto/qat/qat_common/adf_cfg_common.h b/drivers/crypto/qat/qat_common/adf_cfg_common.h
new file mode 100644
index 0000000..88b8218
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_cfg_common.h
@@ -0,0 +1,100 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_CFG_COMMON_H_
+#define ADF_CFG_COMMON_H_
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+#define ADF_CFG_MAX_STR_LEN 64
+#define ADF_CFG_MAX_KEY_LEN_IN_BYTES ADF_CFG_MAX_STR_LEN
+#define ADF_CFG_MAX_VAL_LEN_IN_BYTES ADF_CFG_MAX_STR_LEN
+#define ADF_CFG_MAX_SECTION_LEN_IN_BYTES ADF_CFG_MAX_STR_LEN
+#define ADF_CFG_BASE_DEC 10
+#define ADF_CFG_BASE_HEX 16
+#define ADF_CFG_ALL_DEVICES 0xFE
+#define ADF_CFG_NO_DEVICE 0xFF
+#define ADF_CFG_AFFINITY_WHATEVER 0xFF
+#define MAX_DEVICE_NAME_SIZE 32
+#define ADF_MAX_DEVICES 32
+
+enum adf_cfg_val_type {
+	ADF_DEC,
+	ADF_HEX,
+	ADF_STR
+};
+
+enum adf_device_type {
+	DEV_UNKNOWN = 0,
+	DEV_DH895XCC,
+};
+
+struct adf_dev_status_info {
+	enum adf_device_type type;
+	uint8_t accel_id;
+	uint8_t instance_id;
+	uint8_t num_ae;
+	uint8_t num_accel;
+	uint8_t num_logical_accel;
+	uint8_t banks_per_accel;
+	uint8_t state;
+	uint8_t bus;
+	uint8_t dev;
+	uint8_t fun;
+	char name[MAX_DEVICE_NAME_SIZE];
+};
+
+#define ADF_CTL_IOC_MAGIC 'a'
+#define IOCTL_CONFIG_SYS_RESOURCE_PARAMETERS _IOW(ADF_CTL_IOC_MAGIC, 0, \
+		struct adf_user_cfg_ctl_data)
+#define IOCTL_STOP_ACCEL_DEV _IOW(ADF_CTL_IOC_MAGIC, 1, \
+		struct adf_user_cfg_ctl_data)
+#define IOCTL_START_ACCEL_DEV _IOW(ADF_CTL_IOC_MAGIC, 2, \
+		struct adf_user_cfg_ctl_data)
+#define IOCTL_STATUS_ACCEL_DEV _IOW(ADF_CTL_IOC_MAGIC, 3, uint32_t)
+#define IOCTL_GET_NUM_DEVICES _IOW(ADF_CTL_IOC_MAGIC, 4, int32_t)
+#endif
diff --git a/drivers/crypto/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
new file mode 100644
index 0000000..c7ac758
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
@@ -0,0 +1,83 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_CFG_STRINGS_H_
+#define ADF_CFG_STRINGS_H_
+
+#define ADF_GENERAL_SEC "GENERAL"
+#define ADF_KERNEL_SEC "KERNEL"
+#define ADF_ACCEL_SEC "Accelerator"
+#define ADF_NUM_CY "NumberCyInstances"
+#define ADF_NUM_DC "NumberDcInstances"
+#define ADF_RING_SYM_SIZE "NumConcurrentSymRequests"
+#define ADF_RING_ASYM_SIZE "NumConcurrentAsymRequests"
+#define ADF_RING_DC_SIZE "NumConcurrentRequests"
+#define ADF_RING_ASYM_TX "RingAsymTx"
+#define ADF_RING_SYM_TX "RingSymTx"
+#define ADF_RING_RND_TX "RingNrbgTx"
+#define ADF_RING_ASYM_RX "RingAsymRx"
+#define ADF_RING_SYM_RX "RinSymRx"
+#define ADF_RING_RND_RX "RingNrbgRx"
+#define ADF_RING_DC_TX "RingTx"
+#define ADF_RING_DC_RX "RingRx"
+#define ADF_ETRMGR_BANK "Bank"
+#define ADF_RING_BANK_NUM "BankNumber"
+#define ADF_CY "Cy"
+#define ADF_DC "Dc"
+#define ADF_ETRMGR_COALESCING_ENABLED "InterruptCoalescingEnabled"
+#define ADF_ETRMGR_COALESCING_ENABLED_FORMAT \
+	ADF_ETRMGR_BANK"%d"ADF_ETRMGR_COALESCING_ENABLED
+#define ADF_ETRMGR_COALESCE_TIMER "InterruptCoalescingTimerNs"
+#define ADF_ETRMGR_COALESCE_TIMER_FORMAT \
+	ADF_ETRMGR_BANK"%d"ADF_ETRMGR_COALESCE_TIMER
+#define ADF_ETRMGR_COALESCING_MSG_ENABLED "InterruptCoalescingNumResponses"
+#define ADF_ETRMGR_COALESCING_MSG_ENABLED_FORMAT \
+	ADF_ETRMGR_BANK"%d"ADF_ETRMGR_COALESCING_MSG_ENABLED
+#define ADF_ETRMGR_CORE_AFFINITY "CoreAffinity"
+#define ADF_ETRMGR_CORE_AFFINITY_FORMAT \
+	ADF_ETRMGR_BANK"%d"ADF_ETRMGR_CORE_AFFINITY
+#define ADF_ACCEL_STR "Accelerator%d"
+#endif
diff --git a/drivers/crypto/qat/qat_common/adf_cfg_user.h b/drivers/crypto/qat/qat_common/adf_cfg_user.h
new file mode 100644
index 0000000..0c38a15
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_cfg_user.h
@@ -0,0 +1,94 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_CFG_USER_H_
+#define ADF_CFG_USER_H_
+
+#include "adf_cfg_common.h"
+#include "adf_cfg_strings.h"
+
+struct adf_user_cfg_key_val {
+	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+	union {
+		char *user_val_ptr;
+		uint64_t padding1;
+	};
+	union {
+		struct adf_user_cfg_key_val *prev;
+		uint64_t padding2;
+	};
+	union {
+		struct adf_user_cfg_key_val *next;
+		uint64_t padding3;
+	};
+	enum adf_cfg_val_type type;
+};
+
+struct adf_user_cfg_section {
+	char name[ADF_CFG_MAX_SECTION_LEN_IN_BYTES];
+	union {
+		struct adf_user_cfg_key_val *params;
+		uint64_t padding1;
+	};
+	union {
+		struct adf_user_cfg_section *prev;
+		uint64_t padding2;
+	};
+	union {
+		struct adf_user_cfg_section *next;
+		uint64_t padding3;
+	};
+};
+
+struct adf_user_cfg_ctl_data {
+	union {
+		struct adf_user_cfg_section *config_section;
+		uint64_t padding;
+	};
+	uint8_t device_id;
+};
+#endif
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
new file mode 100644
index 0000000..3cea9fa
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -0,0 +1,192 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_DRV_H
+#define ADF_DRV_H
+
+#include <linux/list.h>
+#include <linux/pci.h>
+#include "adf_accel_devices.h"
+#include "icp_qat_fw_loader_handle.h"
+#include "icp_qat_hal.h"
+
+#define ADF_STATUS_RESTARTING 0
+#define ADF_STATUS_STARTING 1
+#define ADF_STATUS_CONFIGURED 2
+#define ADF_STATUS_STARTED 3
+#define ADF_STATUS_AE_INITIALISED 4
+#define ADF_STATUS_AE_UCODE_LOADED 5
+#define ADF_STATUS_AE_STARTED 6
+#define ADF_STATUS_ORPHAN_TH_RUNNING 7
+#define ADF_STATUS_IRQ_ALLOCATED 8
+
+enum adf_dev_reset_mode {
+	ADF_DEV_RESET_ASYNC = 0,
+	ADF_DEV_RESET_SYNC
+};
+
+enum adf_event {
+	ADF_EVENT_INIT = 0,
+	ADF_EVENT_START,
+	ADF_EVENT_STOP,
+	ADF_EVENT_SHUTDOWN,
+	ADF_EVENT_RESTARTING,
+	ADF_EVENT_RESTARTED,
+};
+
+struct service_hndl {
+	int (*event_hld)(struct adf_accel_dev *accel_dev,
+			 enum adf_event event);
+	unsigned long init_status;
+	unsigned long start_status;
+	char *name;
+	struct list_head list;
+	int admin;
+};
+
+int adf_service_register(struct service_hndl *service);
+int adf_service_unregister(struct service_hndl *service);
+
+int adf_dev_init(struct adf_accel_dev *accel_dev);
+int adf_dev_start(struct adf_accel_dev *accel_dev);
+int adf_dev_stop(struct adf_accel_dev *accel_dev);
+int adf_dev_shutdown(struct adf_accel_dev *accel_dev);
+
+int adf_ctl_dev_register(void);
+void adf_ctl_dev_unregister(void);
+int adf_processes_dev_register(void);
+void adf_processes_dev_unregister(void);
+
+int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev);
+void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev);
+struct list_head *adf_devmgr_get_head(void);
+struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id);
+struct adf_accel_dev *adf_devmgr_get_first(void);
+struct adf_accel_dev *adf_devmgr_pci_to_accel_dev(struct pci_dev *pci_dev);
+int adf_devmgr_verify_id(uint32_t id);
+void adf_devmgr_get_num_dev(uint32_t *num);
+int adf_devmgr_in_reset(struct adf_accel_dev *accel_dev);
+int adf_dev_started(struct adf_accel_dev *accel_dev);
+int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev);
+int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev);
+int adf_ae_init(struct adf_accel_dev *accel_dev);
+int adf_ae_shutdown(struct adf_accel_dev *accel_dev);
+int adf_ae_fw_load(struct adf_accel_dev *accel_dev);
+int adf_ae_fw_release(struct adf_accel_dev *accel_dev);
+int adf_ae_start(struct adf_accel_dev *accel_dev);
+int adf_ae_stop(struct adf_accel_dev *accel_dev);
+
+int adf_enable_aer(struct adf_accel_dev *accel_dev, struct pci_driver *adf);
+void adf_disable_aer(struct adf_accel_dev *accel_dev);
+int adf_init_aer(void);
+void adf_exit_aer(void);
+
+int adf_dev_get(struct adf_accel_dev *accel_dev);
+void adf_dev_put(struct adf_accel_dev *accel_dev);
+int adf_dev_in_use(struct adf_accel_dev *accel_dev);
+int adf_init_etr_data(struct adf_accel_dev *accel_dev);
+void adf_cleanup_etr_data(struct adf_accel_dev *accel_dev);
+int qat_crypto_register(void);
+int qat_crypto_unregister(void);
+struct qat_crypto_instance *qat_crypto_get_instance_node(int node);
+void qat_crypto_put_instance(struct qat_crypto_instance *inst);
+void qat_alg_callback(void *resp);
+int qat_algs_init(void);
+void qat_algs_exit(void);
+int qat_algs_register(void);
+int qat_algs_unregister(void);
+
+int qat_hal_init(struct adf_accel_dev *accel_dev);
+void qat_hal_deinit(struct icp_qat_fw_loader_handle *handle);
+void qat_hal_start(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
+		   unsigned int ctx_mask);
+void qat_hal_stop(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
+		  unsigned int ctx_mask);
+void qat_hal_reset(struct icp_qat_fw_loader_handle *handle);
+int qat_hal_clr_reset(struct icp_qat_fw_loader_handle *handle);
+void qat_hal_set_live_ctx(struct icp_qat_fw_loader_handle *handle,
+			  unsigned char ae, unsigned int ctx_mask);
+int qat_hal_set_ae_lm_mode(struct icp_qat_fw_loader_handle *handle,
+			   unsigned char ae, enum icp_qat_uof_regtype lm_type,
+			   unsigned char mode);
+int qat_hal_set_ae_ctx_mode(struct icp_qat_fw_loader_handle *handle,
+			    unsigned char ae, unsigned char mode);
+int qat_hal_set_ae_nn_mode(struct icp_qat_fw_loader_handle *handle,
+			   unsigned char ae, unsigned char mode);
+void qat_hal_set_pc(struct icp_qat_fw_loader_handle *handle,
+		    unsigned char ae, unsigned int ctx_mask, unsigned int upc);
+void qat_hal_wr_uwords(struct icp_qat_fw_loader_handle *handle,
+		       unsigned char ae, unsigned int uaddr,
+		       unsigned int words_num, uint64_t *uword);
+void qat_hal_wr_umem(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
+		     unsigned int uword_addr, unsigned int words_num,
+		     unsigned int *data);
+int qat_hal_get_ins_num(void);
+int qat_hal_batch_wr_lm(struct icp_qat_fw_loader_handle *handle,
+			unsigned char ae,
+			struct icp_qat_uof_batch_init *lm_init_header);
+int qat_hal_init_gpr(struct icp_qat_fw_loader_handle *handle,
+		     unsigned char ae, unsigned char ctx_mask,
+		     enum icp_qat_uof_regtype reg_type,
+		     unsigned short reg_num, unsigned int regdata);
+int qat_hal_init_wr_xfer(struct icp_qat_fw_loader_handle *handle,
+			 unsigned char ae, unsigned char ctx_mask,
+			 enum icp_qat_uof_regtype reg_type,
+			 unsigned short reg_num, unsigned int regdata);
+int qat_hal_init_rd_xfer(struct icp_qat_fw_loader_handle *handle,
+			 unsigned char ae, unsigned char ctx_mask,
+			 enum icp_qat_uof_regtype reg_type,
+			 unsigned short reg_num, unsigned int regdata);
+int qat_hal_init_nn(struct icp_qat_fw_loader_handle *handle,
+		    unsigned char ae, unsigned char ctx_mask,
+		    unsigned short reg_num, unsigned int regdata);
+int qat_hal_wr_lm(struct icp_qat_fw_loader_handle *handle,
+		  unsigned char ae, unsigned short lm_addr, unsigned int value);
+int qat_uclo_wr_all_uimage(struct icp_qat_fw_loader_handle *handle);
+int qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle);
+int qat_uclo_map_uof_obj(struct icp_qat_fw_loader_handle *handle,
+			 void *addr_ptr, int mem_size);
+#endif
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
new file mode 100644
index 0000000..141df84
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -0,0 +1,490 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/bitops.h>
+#include <linux/pci.h>
+#include <linux/cdev.h>
+#include <linux/uaccess.h>
+
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_cfg.h"
+#include "adf_cfg_common.h"
+#include "adf_cfg_user.h"
+
+#define DEVICE_NAME "qat_adf_ctl"
+
+static DEFINE_MUTEX(adf_ctl_lock);
+static long adf_ctl_ioctl(struct file *fp, unsigned int cmd, unsigned long arg);
+
+static const struct file_operations adf_ctl_ops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = adf_ctl_ioctl,
+	.compat_ioctl = adf_ctl_ioctl,
+};
+
+struct adf_ctl_drv_info {
+	unsigned int major;
+	struct cdev drv_cdev;
+	struct class *drv_class;
+};
+
+static struct adf_ctl_drv_info adt_ctl_drv;
+
+static void adf_chr_drv_destroy(void)
+{
+	device_destroy(adt_ctl_drv.drv_class, MKDEV(adt_ctl_drv.major, 0));
+	cdev_del(&adt_ctl_drv.drv_cdev);
+	class_destroy(adt_ctl_drv.drv_class);
+	unregister_chrdev_region(MKDEV(adt_ctl_drv.major, 0), 1);
+}
+
+static int adf_chr_drv_create(void)
+{
+	dev_t dev_id;
+	struct device *drv_device;
+
+	if (alloc_chrdev_region(&dev_id, 0, 1, DEVICE_NAME)) {
+		pr_err("QAT: unable to allocate chrdev region\n");
+		return -EFAULT;
+	}
+
+	adt_ctl_drv.drv_class = class_create(THIS_MODULE, DEVICE_NAME);
+	if (IS_ERR(adt_ctl_drv.drv_class)) {
+		pr_err("QAT: class_create failed for adf_ctl\n");
+		goto err_chrdev_unreg;
+	}
+	adt_ctl_drv.major = MAJOR(dev_id);
+	cdev_init(&adt_ctl_drv.drv_cdev, &adf_ctl_ops);
+	if (cdev_add(&adt_ctl_drv.drv_cdev, dev_id, 1)) {
+		pr_err("QAT: cdev add failed\n");
+		goto err_class_destr;
+	}
+
+	drv_device = device_create(adt_ctl_drv.drv_class, NULL,
+				   MKDEV(adt_ctl_drv.major, 0),
+				   NULL, DEVICE_NAME);
+	if (!drv_device) {
+		pr_err("QAT: failed to create device\n");
+		goto err_cdev_del;
+	}
+	return 0;
+err_cdev_del:
+	cdev_del(&adt_ctl_drv.drv_cdev);
+err_class_destr:
+	class_destroy(adt_ctl_drv.drv_class);
+err_chrdev_unreg:
+	unregister_chrdev_region(dev_id, 1);
+	return -EFAULT;
+}
+
+static int adf_ctl_alloc_resources(struct adf_user_cfg_ctl_data **ctl_data,
+				   unsigned long arg)
+{
+	struct adf_user_cfg_ctl_data *cfg_data;
+
+	cfg_data = kzalloc(sizeof(*cfg_data), GFP_KERNEL);
+	if (!cfg_data)
+		return -ENOMEM;
+
+	/* Initialize device id to NO DEVICE as 0 is a valid device id */
+	cfg_data->device_id = ADF_CFG_NO_DEVICE;
+
+	if (copy_from_user(cfg_data, (void __user *)arg, sizeof(*cfg_data))) {
+		pr_err("QAT: failed to copy from user cfg_data.\n");
+		kfree(cfg_data);
+		return -EIO;
+	}
+
+	*ctl_data = cfg_data;
+	return 0;
+}
+
+static int adf_add_key_value_data(struct adf_accel_dev *accel_dev,
+				  const char *section,
+				  const struct adf_user_cfg_key_val *key_val)
+{
+	if (key_val->type == ADF_HEX) {
+		long *ptr = (long *)key_val->val;
+		long val = *ptr;
+
+		if (adf_cfg_add_key_value_param(accel_dev, section,
+						key_val->key, (void *)val,
+						key_val->type)) {
+			pr_err("QAT: failed to add keyvalue.\n");
+			return -EFAULT;
+		}
+	} else {
+		if (adf_cfg_add_key_value_param(accel_dev, section,
+						key_val->key, key_val->val,
+						key_val->type)) {
+			pr_err("QAT: failed to add keyvalue.\n");
+			return -EFAULT;
+		}
+	}
+	return 0;
+}
+
+static int adf_copy_key_value_data(struct adf_accel_dev *accel_dev,
+				   struct adf_user_cfg_ctl_data *ctl_data)
+{
+	struct adf_user_cfg_key_val key_val;
+	struct adf_user_cfg_key_val *params_head;
+	struct adf_user_cfg_section section, *section_head;
+
+	section_head = ctl_data->config_section;
+
+	while (section_head) {
+		if (copy_from_user(&section, (void __user *)section_head,
+				   sizeof(*section_head))) {
+			pr_err("QAT: failed to copy section info\n");
+			goto out_err;
+		}
+
+		if (adf_cfg_section_add(accel_dev, section.name)) {
+			pr_err("QAT: failed to add section.\n");
+			goto out_err;
+		}
+
+		params_head = section_head->params;
+
+		while (params_head) {
+			if (copy_from_user(&key_val, (void __user *)params_head,
+					   sizeof(key_val))) {
+				pr_err("QAT: Failed to copy keyvalue.\n");
+				goto out_err;
+			}
+			if (adf_add_key_value_data(accel_dev, section.name,
+						   &key_val)) {
+				goto out_err;
+			}
+			params_head = key_val.next;
+		}
+		section_head = section.next;
+	}
+	return 0;
+out_err:
+	adf_cfg_del_all(accel_dev);
+	return -EFAULT;
+}
+
+static int adf_ctl_ioctl_dev_config(struct file *fp, unsigned int cmd,
+				    unsigned long arg)
+{
+	int ret;
+	struct adf_user_cfg_ctl_data *ctl_data;
+	struct adf_accel_dev *accel_dev;
+
+	ret = adf_ctl_alloc_resources(&ctl_data, arg);
+	if (ret)
+		return ret;
+
+	accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
+	if (!accel_dev) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (adf_dev_started(accel_dev)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (adf_copy_key_value_data(accel_dev, ctl_data)) {
+		ret = -EFAULT;
+		goto out;
+	}
+	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
+out:
+	kfree(ctl_data);
+	return ret;
+}
+
+static int adf_ctl_is_device_in_use(int id)
+{
+	struct list_head *itr, *head = adf_devmgr_get_head();
+
+	list_for_each(itr, head) {
+		struct adf_accel_dev *dev =
+				list_entry(itr, struct adf_accel_dev, list);
+
+		if (id == dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
+			if (adf_devmgr_in_reset(dev) || adf_dev_in_use(dev)) {
+				pr_info("QAT: device qat_dev%d is busy\n",
+					dev->accel_id);
+				return -EBUSY;
+			}
+		}
+	}
+	return 0;
+}
+
+static int adf_ctl_stop_devices(uint32_t id)
+{
+	struct list_head *itr, *head = adf_devmgr_get_head();
+	int ret = 0;
+
+	list_for_each(itr, head) {
+		struct adf_accel_dev *accel_dev =
+				list_entry(itr, struct adf_accel_dev, list);
+		if (id == accel_dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
+			if (!adf_dev_started(accel_dev))
+				continue;
+
+			if (adf_dev_stop(accel_dev)) {
+				pr_err("QAT: Failed to stop qat_dev%d\n", id);
+				ret = -EFAULT;
+			}
+		}
+	}
+	return ret;
+}
+
+static int adf_ctl_ioctl_dev_stop(struct file *fp, unsigned int cmd,
+				  unsigned long arg)
+{
+	int ret;
+	struct adf_user_cfg_ctl_data *ctl_data;
+
+	ret = adf_ctl_alloc_resources(&ctl_data, arg);
+	if (ret)
+		return ret;
+
+	if (adf_devmgr_verify_id(ctl_data->device_id)) {
+		pr_err("QAT: Device %d not found\n", ctl_data->device_id);
+		ret = -ENODEV;
+		goto out;
+	}
+
+	ret = adf_ctl_is_device_in_use(ctl_data->device_id);
+	if (ret)
+		goto out;
+
+	if (ctl_data->device_id == ADF_CFG_ALL_DEVICES)
+		pr_info("QAT: Stopping all acceleration devices.\n");
+	else
+		pr_info("QAT: Stopping acceleration device qat_dev%d.\n",
+			ctl_data->device_id);
+
+	ret = adf_ctl_stop_devices(ctl_data->device_id);
+	if (ret)
+		pr_err("QAT: failed to stop device.\n");
+out:
+	kfree(ctl_data);
+	return ret;
+}
+
+static int adf_ctl_ioctl_dev_start(struct file *fp, unsigned int cmd,
+				   unsigned long arg)
+{
+	int ret;
+	struct adf_user_cfg_ctl_data *ctl_data;
+	struct adf_accel_dev *accel_dev;
+
+	ret = adf_ctl_alloc_resources(&ctl_data, arg);
+	if (ret)
+		return ret;
+
+	accel_dev = adf_devmgr_get_dev_by_id(ctl_data->device_id);
+	if (!accel_dev) {
+		pr_err("QAT: Device %d not found\n", ctl_data->device_id);
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (!adf_dev_started(accel_dev)) {
+		pr_info("QAT: Starting acceleration device qat_dev%d.\n",
+			ctl_data->device_id);
+		ret = adf_dev_start(accel_dev);
+	} else {
+		pr_info("QAT: Acceleration device qat_dev%d already started.\n",
+			ctl_data->device_id);
+	}
+	if (ret) {
+		pr_err("QAT: Failed to start qat_dev%d\n", ctl_data->device_id);
+		adf_dev_stop(accel_dev);
+	}
+out:
+	kfree(ctl_data);
+	return ret;
+}
+
+static int adf_ctl_ioctl_get_num_devices(struct file *fp, unsigned int cmd,
+					 unsigned long arg)
+{
+	uint32_t num_devices = 0;
+
+	adf_devmgr_get_num_dev(&num_devices);
+	if (copy_to_user((void __user *)arg, &num_devices, sizeof(num_devices)))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int adf_ctl_ioctl_get_status(struct file *fp, unsigned int cmd,
+				    unsigned long arg)
+{
+	struct adf_hw_device_data *hw_data;
+	struct adf_dev_status_info dev_info;
+	struct adf_accel_dev *accel_dev;
+
+	if (copy_from_user(&dev_info, (void __user *)arg,
+			   sizeof(struct adf_dev_status_info))) {
+		pr_err("QAT: failed to copy from user.\n");
+		return -EFAULT;
+	}
+
+	accel_dev = adf_devmgr_get_dev_by_id(dev_info.accel_id);
+	if (!accel_dev) {
+		pr_err("QAT: Device %d not found\n", dev_info.accel_id);
+		return -ENODEV;
+	}
+	hw_data = accel_dev->hw_device;
+	dev_info.state = adf_dev_started(accel_dev) ? DEV_UP : DEV_DOWN;
+	dev_info.num_ae = hw_data->get_num_aes(hw_data);
+	dev_info.num_accel = hw_data->get_num_accels(hw_data);
+	dev_info.num_logical_accel = hw_data->num_logical_accel;
+	dev_info.banks_per_accel = hw_data->num_banks
+					/ hw_data->num_logical_accel;
+	strlcpy(dev_info.name, hw_data->dev_class->name, sizeof(dev_info.name));
+	dev_info.instance_id = hw_data->instance_id;
+	dev_info.type = hw_data->dev_class->type;
+	dev_info.bus = accel_to_pci_dev(accel_dev)->bus->number;
+	dev_info.dev = PCI_SLOT(accel_to_pci_dev(accel_dev)->devfn);
+	dev_info.fun = PCI_FUNC(accel_to_pci_dev(accel_dev)->devfn);
+
+	if (copy_to_user((void __user *)arg, &dev_info,
+			 sizeof(struct adf_dev_status_info))) {
+		pr_err("QAT: failed to copy status.\n");
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static long adf_ctl_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	if (mutex_lock_interruptible(&adf_ctl_lock))
+		return -EFAULT;
+
+	switch (cmd) {
+	case IOCTL_CONFIG_SYS_RESOURCE_PARAMETERS:
+		ret = adf_ctl_ioctl_dev_config(fp, cmd, arg);
+		break;
+
+	case IOCTL_STOP_ACCEL_DEV:
+		ret = adf_ctl_ioctl_dev_stop(fp, cmd, arg);
+		break;
+
+	case IOCTL_START_ACCEL_DEV:
+		ret = adf_ctl_ioctl_dev_start(fp, cmd, arg);
+		break;
+
+	case IOCTL_GET_NUM_DEVICES:
+		ret = adf_ctl_ioctl_get_num_devices(fp, cmd, arg);
+		break;
+
+	case IOCTL_STATUS_ACCEL_DEV:
+		ret = adf_ctl_ioctl_get_status(fp, cmd, arg);
+		break;
+	default:
+		pr_err("QAT: Invalid ioclt\n");
+		ret = -EFAULT;
+		break;
+	}
+	mutex_unlock(&adf_ctl_lock);
+	return ret;
+}
+
+static int __init adf_register_ctl_device_driver(void)
+{
+	mutex_init(&adf_ctl_lock);
+
+	if (qat_algs_init())
+		goto err_algs_init;
+
+	if (adf_chr_drv_create())
+		goto err_chr_dev;
+
+	if (adf_init_aer())
+		goto err_aer;
+
+	if (qat_crypto_register())
+		goto err_crypto_register;
+
+	return 0;
+
+err_crypto_register:
+	adf_exit_aer();
+err_aer:
+	adf_chr_drv_destroy();
+err_chr_dev:
+	qat_algs_exit();
+err_algs_init:
+	mutex_destroy(&adf_ctl_lock);
+	return -EFAULT;
+}
+
+static void __exit adf_unregister_ctl_device_driver(void)
+{
+	adf_chr_drv_destroy();
+	adf_exit_aer();
+	qat_crypto_unregister();
+	qat_algs_exit();
+	mutex_destroy(&adf_ctl_lock);
+}
+
+module_init(adf_register_ctl_device_driver);
+module_exit(adf_unregister_ctl_device_driver);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Intel");
+MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
+MODULE_ALIAS("intel_qat");
diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
new file mode 100644
index 0000000..ae71555
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -0,0 +1,215 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include "adf_cfg.h"
+#include "adf_common_drv.h"
+
+static LIST_HEAD(accel_table);
+static DEFINE_MUTEX(table_lock);
+static uint32_t num_devices;
+
+/**
+ * adf_devmgr_add_dev() - Add accel_dev to the acceleration framework
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function adds acceleration device to the acceleration framework.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev)
+{
+	struct list_head *itr;
+
+	if (num_devices == ADF_MAX_DEVICES) {
+		pr_err("QAT: Only support up to %d devices\n", ADF_MAX_DEVICES);
+		return -EFAULT;
+	}
+
+	mutex_lock(&table_lock);
+	list_for_each(itr, &accel_table) {
+		struct adf_accel_dev *ptr =
+				list_entry(itr, struct adf_accel_dev, list);
+
+		if (ptr == accel_dev) {
+			mutex_unlock(&table_lock);
+			return -EEXIST;
+		}
+	}
+	atomic_set(&accel_dev->ref_count, 0);
+	list_add_tail(&accel_dev->list, &accel_table);
+	accel_dev->accel_id = num_devices++;
+	mutex_unlock(&table_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_devmgr_add_dev);
+
+struct list_head *adf_devmgr_get_head(void)
+{
+	return &accel_table;
+}
+
+/**
+ * adf_devmgr_rm_dev() - Remove accel_dev from the acceleration framework.
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function removes acceleration device from the acceleration framework.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: void
+ */
+void adf_devmgr_rm_dev(struct adf_accel_dev *accel_dev)
+{
+	mutex_lock(&table_lock);
+	list_del(&accel_dev->list);
+	num_devices--;
+	mutex_unlock(&table_lock);
+}
+EXPORT_SYMBOL_GPL(adf_devmgr_rm_dev);
+
+struct adf_accel_dev *adf_devmgr_get_first(void)
+{
+	struct adf_accel_dev *dev = NULL;
+
+	if (!list_empty(&accel_table))
+		dev = list_first_entry(&accel_table, struct adf_accel_dev,
+				       list);
+	return dev;
+}
+
+/**
+ * adf_devmgr_pci_to_accel_dev() - Get accel_dev associated with the pci_dev.
+ * @accel_dev:  Pointer to pci device.
+ *
+ * Function returns acceleration device associated with the given pci device.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: pinter to accel_dev or NULL if not found.
+ */
+struct adf_accel_dev *adf_devmgr_pci_to_accel_dev(struct pci_dev *pci_dev)
+{
+	struct list_head *itr;
+
+	list_for_each(itr, &accel_table) {
+		struct adf_accel_dev *ptr =
+				list_entry(itr, struct adf_accel_dev, list);
+
+		if (ptr->accel_pci_dev.pci_dev == pci_dev) {
+			mutex_unlock(&table_lock);
+			return ptr;
+		}
+	}
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(adf_devmgr_pci_to_accel_dev);
+
+struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id)
+{
+	struct list_head *itr;
+
+	list_for_each(itr, &accel_table) {
+		struct adf_accel_dev *ptr =
+				list_entry(itr, struct adf_accel_dev, list);
+
+		if (ptr->accel_id == id) {
+			mutex_unlock(&table_lock);
+			return ptr;
+		}
+	}
+	return NULL;
+}
+
+int adf_devmgr_verify_id(uint32_t id)
+{
+	if (id == ADF_CFG_ALL_DEVICES)
+		return 0;
+
+	if (adf_devmgr_get_dev_by_id(id))
+		return 0;
+
+	return -ENODEV;
+}
+
+void adf_devmgr_get_num_dev(uint32_t *num)
+{
+	struct list_head *itr;
+
+	*num = 0;
+	list_for_each(itr, &accel_table) {
+		(*num)++;
+	}
+}
+
+int adf_dev_in_use(struct adf_accel_dev *accel_dev)
+{
+	return atomic_read(&accel_dev->ref_count) != 0;
+}
+
+int adf_dev_get(struct adf_accel_dev *accel_dev)
+{
+	if (atomic_add_return(1, &accel_dev->ref_count) == 1)
+		if (!try_module_get(accel_dev->owner))
+			return -EFAULT;
+	return 0;
+}
+
+void adf_dev_put(struct adf_accel_dev *accel_dev)
+{
+	if (atomic_sub_return(1, &accel_dev->ref_count) == 0)
+		module_put(accel_dev->owner);
+}
+
+int adf_devmgr_in_reset(struct adf_accel_dev *accel_dev)
+{
+	return test_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
+}
+
+int adf_dev_started(struct adf_accel_dev *accel_dev)
+{
+	return test_bit(ADF_STATUS_STARTED, &accel_dev->status);
+}
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
new file mode 100644
index 0000000..5c3d6f1
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -0,0 +1,388 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include "adf_accel_devices.h"
+#include "adf_cfg.h"
+#include "adf_common_drv.h"
+
+static LIST_HEAD(service_table);
+static DEFINE_MUTEX(service_lock);
+
+static void adf_service_add(struct service_hndl *service)
+{
+	mutex_lock(&service_lock);
+	list_add(&service->list, &service_table);
+	mutex_unlock(&service_lock);
+}
+
+/**
+ * adf_service_register() - Register acceleration service in the accel framework
+ * @service:    Pointer to the service
+ *
+ * Function adds the acceleration service to the acceleration framework.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_service_register(struct service_hndl *service)
+{
+	service->init_status = 0;
+	service->start_status = 0;
+	adf_service_add(service);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_service_register);
+
+static void adf_service_remove(struct service_hndl *service)
+{
+	mutex_lock(&service_lock);
+	list_del(&service->list);
+	mutex_unlock(&service_lock);
+}
+
+/**
+ * adf_service_unregister() - Unregister acceleration service from the framework
+ * @service:    Pointer to the service
+ *
+ * Function remove the acceleration service from the acceleration framework.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_service_unregister(struct service_hndl *service)
+{
+	if (service->init_status || service->start_status) {
+		pr_err("QAT: Could not remove active service\n");
+		return -EFAULT;
+	}
+	adf_service_remove(service);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_service_unregister);
+
+/**
+ * adf_dev_start() - Start acceleration service for the given accel device
+ * @accel_dev:    Pointer to acceleration device.
+ *
+ * Function notifies all the registered services that the acceleration device
+ * is ready to be used.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_dev_start(struct adf_accel_dev *accel_dev)
+{
+	struct service_hndl *service;
+	struct list_head *list_itr;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+
+	if (!test_bit(ADF_STATUS_CONFIGURED, &accel_dev->status)) {
+		pr_info("QAT: Device not configured\n");
+		return -EFAULT;
+	}
+	set_bit(ADF_STATUS_STARTING, &accel_dev->status);
+
+	if (adf_ae_init(accel_dev)) {
+		pr_err("QAT: Failed to initialise Acceleration Engine\n");
+		return -EFAULT;
+	}
+	set_bit(ADF_STATUS_AE_INITIALISED, &accel_dev->status);
+
+	if (adf_ae_fw_load(accel_dev)) {
+		pr_err("Failed to load acceleration FW\n");
+		adf_ae_fw_release(accel_dev);
+		return -EFAULT;
+	}
+	set_bit(ADF_STATUS_AE_UCODE_LOADED, &accel_dev->status);
+
+	if (hw_data->alloc_irq(accel_dev)) {
+		pr_err("QAT: Failed to allocate interrupts\n");
+		return -EFAULT;
+	}
+	set_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
+
+	/*
+	 * Subservice initialisation is divided into two stages: init and start.
+	 * This is to facilitate any ordering dependencies between services
+	 * prior to starting any of the accelerators.
+	 */
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (!service->admin)
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_INIT)) {
+			pr_err("QAT: Failed to initialise service %s\n",
+			       service->name);
+			return -EFAULT;
+		}
+		set_bit(accel_dev->accel_id, &service->init_status);
+	}
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (service->admin)
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_INIT)) {
+			pr_err("QAT: Failed to initialise service %s\n",
+			       service->name);
+			return -EFAULT;
+		}
+		set_bit(accel_dev->accel_id, &service->init_status);
+	}
+
+	hw_data->enable_error_correction(accel_dev);
+
+	if (adf_ae_start(accel_dev)) {
+		pr_err("QAT: AE Start Failed\n");
+		return -EFAULT;
+	}
+	set_bit(ADF_STATUS_AE_STARTED, &accel_dev->status);
+
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (!service->admin)
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
+			pr_err("QAT: Failed to start service %s\n",
+			       service->name);
+			return -EFAULT;
+		}
+		set_bit(accel_dev->accel_id, &service->start_status);
+	}
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (service->admin)
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
+			pr_err("QAT: Failed to start service %s\n",
+			       service->name);
+			return -EFAULT;
+		}
+		set_bit(accel_dev->accel_id, &service->start_status);
+	}
+
+	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
+	set_bit(ADF_STATUS_STARTED, &accel_dev->status);
+
+	if (qat_algs_register()) {
+		pr_err("QAT: Failed to register crypto algs\n");
+		set_bit(ADF_STATUS_STARTING, &accel_dev->status);
+		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
+		return -EFAULT;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_dev_start);
+
+/**
+ * adf_dev_stop() - Stop acceleration service for the given accel device
+ * @accel_dev:    Pointer to acceleration device.
+ *
+ * Function notifies all the registered services that the acceleration device
+ * is shuting down.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_dev_stop(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct service_hndl *service;
+	struct list_head *list_itr;
+	int ret, wait = 0;
+
+	if (!adf_dev_started(accel_dev) &&
+	    !test_bit(ADF_STATUS_STARTING, &accel_dev->status)) {
+		return 0;
+	}
+	clear_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
+	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
+	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
+
+	if (qat_algs_unregister())
+		pr_err("QAT: Failed to unregister crypto algs\n");
+
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (service->admin)
+			continue;
+		if (!test_bit(accel_dev->accel_id, &service->start_status))
+			continue;
+		ret = service->event_hld(accel_dev, ADF_EVENT_STOP);
+		if (!ret) {
+			clear_bit(accel_dev->accel_id, &service->start_status);
+		} else if (ret == -EAGAIN) {
+			wait = 1;
+			clear_bit(accel_dev->accel_id, &service->start_status);
+		}
+	}
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (!service->admin)
+			continue;
+		if (!test_bit(accel_dev->accel_id, &service->start_status))
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_STOP))
+			pr_err("QAT: Failed to shutdown service %s\n",
+			       service->name);
+		else
+			clear_bit(accel_dev->accel_id, &service->start_status);
+	}
+
+	if (wait)
+		msleep(100);
+
+	if (adf_dev_started(accel_dev)) {
+		if (adf_ae_stop(accel_dev))
+			pr_err("QAT: failed to stop AE\n");
+		else
+			clear_bit(ADF_STATUS_AE_STARTED, &accel_dev->status);
+	}
+
+	if (test_bit(ADF_STATUS_AE_UCODE_LOADED, &accel_dev->status)) {
+		if (adf_ae_fw_release(accel_dev))
+			pr_err("QAT: Failed to release the ucode\n");
+		else
+			clear_bit(ADF_STATUS_AE_UCODE_LOADED,
+				  &accel_dev->status);
+	}
+
+	if (test_bit(ADF_STATUS_AE_INITIALISED, &accel_dev->status)) {
+		if (adf_ae_shutdown(accel_dev))
+			pr_err("QAT: Failed to shutdown Accel Engine\n");
+		else
+			clear_bit(ADF_STATUS_AE_INITIALISED,
+				  &accel_dev->status);
+	}
+
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (service->admin)
+			continue;
+		if (!test_bit(accel_dev->accel_id, &service->init_status))
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_SHUTDOWN))
+			pr_err("QAT: Failed to shutdown service %s\n",
+			       service->name);
+		else
+			clear_bit(accel_dev->accel_id, &service->init_status);
+	}
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (!service->admin)
+			continue;
+		if (!test_bit(accel_dev->accel_id, &service->init_status))
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_SHUTDOWN))
+			pr_err("QAT: Failed to shutdown service %s\n",
+			       service->name);
+		else
+			clear_bit(accel_dev->accel_id, &service->init_status);
+	}
+
+	if (test_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status)) {
+		hw_data->free_irq(accel_dev);
+		clear_bit(ADF_STATUS_IRQ_ALLOCATED, &accel_dev->status);
+	}
+
+	/* Delete configuration only if not restarting */
+	if (!test_bit(ADF_STATUS_RESTARTING, &accel_dev->status))
+		adf_cfg_del_all(accel_dev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_dev_stop);
+
+int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
+{
+	struct service_hndl *service;
+	struct list_head *list_itr;
+
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (service->admin)
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
+			pr_err("QAT: Failed to restart service %s.\n",
+			       service->name);
+	}
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (!service->admin)
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
+			pr_err("QAT: Failed to restart service %s.\n",
+			       service->name);
+	}
+	return 0;
+}
+
+int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
+{
+	struct service_hndl *service;
+	struct list_head *list_itr;
+
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (service->admin)
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
+			pr_err("QAT: Failed to restart service %s.\n",
+			       service->name);
+	}
+	list_for_each(list_itr, &service_table) {
+		service = list_entry(list_itr, struct service_hndl, list);
+		if (!service->admin)
+			continue;
+		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
+			pr_err("QAT: Failed to restart service %s.\n",
+			       service->name);
+	}
+	return 0;
+}
diff --git a/drivers/crypto/qat/qat_common/adf_transport.c b/drivers/crypto/qat/qat_common/adf_transport.c
new file mode 100644
index 0000000..b213010
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_transport.c
@@ -0,0 +1,565 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/delay.h>
+#include "adf_accel_devices.h"
+#include "adf_transport_internal.h"
+#include "adf_transport_access_macros.h"
+#include "adf_cfg.h"
+#include "adf_common_drv.h"
+
+static inline uint32_t adf_modulo(uint32_t data, uint32_t shift)
+{
+	uint32_t div = data >> shift;
+	uint32_t mult = div << shift;
+	return data - mult;
+}
+
+static inline int adf_check_ring_alignment(uint64_t addr, uint64_t size)
+{
+	if (((size - 1) & addr) != 0)
+		return -EFAULT;
+	return 0;
+}
+
+static int adf_verify_ring_size(uint32_t msg_size, uint32_t msg_num)
+{
+	int i = ADF_MIN_RING_SIZE;
+	for (; i <= ADF_MAX_RING_SIZE; i++)
+		if ((msg_size * msg_num) == ADF_SIZE_TO_RING_SIZE_IN_BYTES(i))
+			return i;
+
+	return ADF_DEFAULT_RING_SIZE;
+}
+
+static int adf_reserve_ring(struct adf_etr_bank_data *bank, uint32_t ring)
+{
+	spin_lock(&bank->lock);
+	if (bank->ring_mask & (1 << ring)) {
+		spin_unlock(&bank->lock);
+		return -EFAULT;
+	}
+	bank->ring_mask |= (1 << ring);
+	spin_unlock(&bank->lock);
+	return 0;
+}
+
+static void adf_unreserve_ring(struct adf_etr_bank_data *bank, uint32_t ring)
+{
+	spin_lock(&bank->lock);
+	bank->ring_mask &= ~(1 << ring);
+	spin_unlock(&bank->lock);
+}
+
+static void adf_enable_ring_irq(struct adf_etr_bank_data *bank, uint32_t ring)
+{
+	spin_lock_bh(&bank->lock);
+	bank->irq_mask |= (1 << ring);
+	spin_unlock_bh(&bank->lock);
+	WRITE_CSR_INT_COL_EN(bank->csr_addr, bank->bank_number, bank->irq_mask);
+	WRITE_CSR_INT_COL_CTL(bank->csr_addr, bank->bank_number,
+			      bank->irq_coalesc_timer);
+}
+
+static void adf_disable_ring_irq(struct adf_etr_bank_data *bank, uint32_t ring)
+{
+	spin_lock_bh(&bank->lock);
+	bank->irq_mask &= ~(1 << ring);
+	spin_unlock_bh(&bank->lock);
+	WRITE_CSR_INT_COL_EN(bank->csr_addr, bank->bank_number, bank->irq_mask);
+}
+
+int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg)
+{
+	if (atomic_add_return(1, ring->inflights) >
+	    ADF_MAX_INFLIGHTS(ring->ring_size, ring->msg_size)) {
+		atomic_dec(ring->inflights);
+		return -EAGAIN;
+	}
+	spin_lock_bh(&ring->lock);
+	memcpy(ring->base_addr + ring->tail, msg,
+	       ADF_MSG_SIZE_TO_BYTES(ring->msg_size));
+
+	ring->tail = adf_modulo(ring->tail +
+				ADF_MSG_SIZE_TO_BYTES(ring->msg_size),
+				ADF_RING_SIZE_MODULO(ring->ring_size));
+	WRITE_CSR_RING_TAIL(ring->bank->csr_addr, ring->bank->bank_number,
+			    ring->ring_number, ring->tail);
+	spin_unlock_bh(&ring->lock);
+	return 0;
+}
+
+static int adf_handle_response(struct adf_etr_ring_data *ring)
+{
+	uint32_t msg_counter = 0;
+	uint32_t *msg = (uint32_t *)(ring->base_addr + ring->head);
+
+	while (*msg != ADF_RING_EMPTY_SIG) {
+		ring->callback((uint32_t *)msg);
+		*msg = ADF_RING_EMPTY_SIG;
+		ring->head = adf_modulo(ring->head +
+					ADF_MSG_SIZE_TO_BYTES(ring->msg_size),
+					ADF_RING_SIZE_MODULO(ring->ring_size));
+		msg_counter++;
+		msg = (uint32_t *)(ring->base_addr + ring->head);
+	}
+	if (msg_counter > 0) {
+		WRITE_CSR_RING_HEAD(ring->bank->csr_addr,
+				    ring->bank->bank_number,
+				    ring->ring_number, ring->head);
+		atomic_sub(msg_counter, ring->inflights);
+	}
+	return 0;
+}
+
+static void adf_configure_tx_ring(struct adf_etr_ring_data *ring)
+{
+	uint32_t ring_config = BUILD_RING_CONFIG(ring->ring_size);
+
+	WRITE_CSR_RING_CONFIG(ring->bank->csr_addr, ring->bank->bank_number,
+			      ring->ring_number, ring_config);
+}
+
+static void adf_configure_rx_ring(struct adf_etr_ring_data *ring)
+{
+	uint32_t ring_config =
+			BUILD_RESP_RING_CONFIG(ring->ring_size,
+					       ADF_RING_NEAR_WATERMARK_512,
+					       ADF_RING_NEAR_WATERMARK_0);
+
+	WRITE_CSR_RING_CONFIG(ring->bank->csr_addr, ring->bank->bank_number,
+			      ring->ring_number, ring_config);
+}
+
+static int adf_init_ring(struct adf_etr_ring_data *ring)
+{
+	struct adf_etr_bank_data *bank = ring->bank;
+	struct adf_accel_dev *accel_dev = bank->accel_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	uint64_t ring_base;
+	uint32_t ring_size_bytes =
+			ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size);
+
+	ring_size_bytes = ADF_RING_SIZE_BYTES_MIN(ring_size_bytes);
+	ring->base_addr = dma_alloc_coherent(&GET_DEV(accel_dev),
+					     ring_size_bytes, &ring->dma_addr,
+					     GFP_KERNEL);
+	if (!ring->base_addr)
+		return -ENOMEM;
+
+	memset(ring->base_addr, 0x7F, ring_size_bytes);
+	/* The base_addr has to be aligned to the size of the buffer */
+	if (adf_check_ring_alignment(ring->dma_addr, ring_size_bytes)) {
+		pr_err("QAT: Ring address not aligned\n");
+		dma_free_coherent(&GET_DEV(accel_dev), ring_size_bytes,
+				  ring->base_addr, ring->dma_addr);
+		return -EFAULT;
+	}
+
+	if (hw_data->tx_rings_mask & (1 << ring->ring_number))
+		adf_configure_tx_ring(ring);
+
+	else
+		adf_configure_rx_ring(ring);
+
+	ring_base = BUILD_RING_BASE_ADDR(ring->dma_addr, ring->ring_size);
+	WRITE_CSR_RING_BASE(ring->bank->csr_addr, ring->bank->bank_number,
+			    ring->ring_number, ring_base);
+	spin_lock_init(&ring->lock);
+	return 0;
+}
+
+static void adf_cleanup_ring(struct adf_etr_ring_data *ring)
+{
+	uint32_t ring_size_bytes =
+			ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size);
+	ring_size_bytes = ADF_RING_SIZE_BYTES_MIN(ring_size_bytes);
+
+	if (ring->base_addr) {
+		memset(ring->base_addr, 0x7F, ring_size_bytes);
+		dma_free_coherent(&GET_DEV(ring->bank->accel_dev),
+				  ring_size_bytes, ring->base_addr,
+				  ring->dma_addr);
+	}
+}
+
+int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
+		    uint32_t bank_num, uint32_t num_msgs,
+		    uint32_t msg_size, const char *ring_name,
+		    adf_callback_fn callback, int poll_mode,
+		    struct adf_etr_ring_data **ring_ptr)
+{
+	struct adf_etr_data *transport_data = accel_dev->transport;
+	struct adf_etr_bank_data *bank;
+	struct adf_etr_ring_data *ring;
+	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+	uint32_t ring_num;
+	int ret;
+
+	if (bank_num >= GET_MAX_BANKS(accel_dev)) {
+		pr_err("QAT: Invalid bank number\n");
+		return -EFAULT;
+	}
+	if (msg_size > ADF_MSG_SIZE_TO_BYTES(ADF_MAX_MSG_SIZE)) {
+		pr_err("QAT: Invalid msg size\n");
+		return -EFAULT;
+	}
+	if (ADF_MAX_INFLIGHTS(adf_verify_ring_size(msg_size, num_msgs),
+			      ADF_BYTES_TO_MSG_SIZE(msg_size)) < 2) {
+		pr_err("QAT: Invalid ring size for given msg size\n");
+		return -EFAULT;
+	}
+	if (adf_cfg_get_param_value(accel_dev, section, ring_name, val)) {
+		pr_err("QAT: Section %s, no such entry : %s\n",
+		       section, ring_name);
+		return -EFAULT;
+	}
+	if (kstrtouint(val, 10, &ring_num)) {
+		pr_err("QAT: Can't get ring number\n");
+		return -EFAULT;
+	}
+
+	bank = &transport_data->banks[bank_num];
+	if (adf_reserve_ring(bank, ring_num)) {
+		pr_err("QAT: Ring %d, %s already exists.\n",
+		       ring_num, ring_name);
+		return -EFAULT;
+	}
+	ring = &bank->rings[ring_num];
+	ring->ring_number = ring_num;
+	ring->bank = bank;
+	ring->callback = callback;
+	ring->msg_size = ADF_BYTES_TO_MSG_SIZE(msg_size);
+	ring->ring_size = adf_verify_ring_size(msg_size, num_msgs);
+	ring->head = 0;
+	ring->tail = 0;
+	atomic_set(ring->inflights, 0);
+	ret = adf_init_ring(ring);
+	if (ret)
+		goto err;
+
+	/* Enable HW arbitration for the given ring */
+	accel_dev->hw_device->hw_arb_ring_enable(ring);
+
+	if (adf_ring_debugfs_add(ring, ring_name)) {
+		pr_err("QAT: Couldn't add ring debugfs entry\n");
+		ret = -EFAULT;
+		goto err;
+	}
+
+	/* Enable interrupts if needed */
+	if (callback && (!poll_mode))
+		adf_enable_ring_irq(bank, ring->ring_number);
+	*ring_ptr = ring;
+	return 0;
+err:
+	adf_cleanup_ring(ring);
+	adf_unreserve_ring(bank, ring_num);
+	accel_dev->hw_device->hw_arb_ring_disable(ring);
+	return ret;
+}
+
+void adf_remove_ring(struct adf_etr_ring_data *ring)
+{
+	struct adf_etr_bank_data *bank = ring->bank;
+	struct adf_accel_dev *accel_dev = bank->accel_dev;
+
+	/* Disable interrupts for the given ring */
+	adf_disable_ring_irq(bank, ring->ring_number);
+
+	/* Clear PCI config space */
+	WRITE_CSR_RING_CONFIG(bank->csr_addr, bank->bank_number,
+			      ring->ring_number, 0);
+	WRITE_CSR_RING_BASE(bank->csr_addr, bank->bank_number,
+			    ring->ring_number, 0);
+	adf_ring_debugfs_rm(ring);
+	adf_unreserve_ring(bank, ring->ring_number);
+	/* Disable HW arbitration for the given ring */
+	accel_dev->hw_device->hw_arb_ring_disable(ring);
+	adf_cleanup_ring(ring);
+}
+
+static void adf_ring_response_handler(struct adf_etr_bank_data *bank)
+{
+	uint32_t empty_rings, i;
+
+	empty_rings = READ_CSR_E_STAT(bank->csr_addr, bank->bank_number);
+	empty_rings = ~empty_rings & bank->irq_mask;
+
+	for (i = 0; i < ADF_ETR_MAX_RINGS_PER_BANK; ++i) {
+		if (empty_rings & (1 << i))
+			adf_handle_response(&bank->rings[i]);
+	}
+}
+
+/**
+ * adf_response_handler() - Bottom half handler response handler
+ * @bank_addr:  Address of a ring bank for with the BH was scheduled.
+ *
+ * Function is the bottom half handler for the response from acceleration
+ * device. There is one handler for every ring bank. Function checks all
+ * communication rings in the bank.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: void
+ */
+void adf_response_handler(unsigned long bank_addr)
+{
+	struct adf_etr_bank_data *bank = (void *)bank_addr;
+
+	/* Handle all the responses nad reenable IRQs */
+	adf_ring_response_handler(bank);
+	WRITE_CSR_INT_FLAG_AND_COL(bank->csr_addr, bank->bank_number,
+				   bank->irq_mask);
+}
+EXPORT_SYMBOL_GPL(adf_response_handler);
+
+static inline int adf_get_cfg_int(struct adf_accel_dev *accel_dev,
+				  const char *section, const char *format,
+				  uint32_t key, uint32_t *value)
+{
+	char key_buf[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+	char val_buf[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+
+	snprintf(key_buf, ADF_CFG_MAX_KEY_LEN_IN_BYTES, format, key);
+
+	if (adf_cfg_get_param_value(accel_dev, section, key_buf, val_buf))
+		return -EFAULT;
+
+	if (kstrtouint(val_buf, 10, value))
+		return -EFAULT;
+	return 0;
+}
+
+static void adf_enable_coalesc(struct adf_etr_bank_data *bank,
+			       const char *section, uint32_t bank_num_in_accel)
+{
+	if (adf_get_cfg_int(bank->accel_dev, section,
+			    ADF_ETRMGR_COALESCE_TIMER_FORMAT,
+			    bank_num_in_accel, &bank->irq_coalesc_timer))
+		bank->irq_coalesc_timer = ADF_COALESCING_DEF_TIME;
+
+	if (ADF_COALESCING_MAX_TIME < bank->irq_coalesc_timer ||
+	    ADF_COALESCING_MIN_TIME > bank->irq_coalesc_timer)
+		bank->irq_coalesc_timer = ADF_COALESCING_DEF_TIME;
+}
+
+static int adf_init_bank(struct adf_accel_dev *accel_dev,
+			 struct adf_etr_bank_data *bank,
+			 uint32_t bank_num, void __iomem *csr_addr)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_etr_ring_data *ring;
+	struct adf_etr_ring_data *tx_ring;
+	uint32_t i, coalesc_enabled;
+
+	memset(bank, 0, sizeof(*bank));
+	bank->bank_number = bank_num;
+	bank->csr_addr = csr_addr;
+	bank->accel_dev = accel_dev;
+	spin_lock_init(&bank->lock);
+
+	/* Enable IRQ coalescing always. This will allow to use
+	 * the optimised flag and coalesc register.
+	 * If it is disabled in the config file just use min time value */
+	if (adf_get_cfg_int(accel_dev, "Accelerator0",
+			    ADF_ETRMGR_COALESCING_ENABLED_FORMAT,
+			    bank_num, &coalesc_enabled) && coalesc_enabled)
+		adf_enable_coalesc(bank, "Accelerator0", bank_num);
+	else
+		bank->irq_coalesc_timer = ADF_COALESCING_MIN_TIME;
+
+	for (i = 0; i < ADF_ETR_MAX_RINGS_PER_BANK; i++) {
+		WRITE_CSR_RING_CONFIG(csr_addr, bank_num, i, 0);
+		WRITE_CSR_RING_BASE(csr_addr, bank_num, i, 0);
+		ring = &bank->rings[i];
+		if (hw_data->tx_rings_mask & (1 << i)) {
+			ring->inflights = kzalloc_node(sizeof(atomic_t),
+						       GFP_KERNEL,
+						       accel_dev->numa_node);
+			if (!ring->inflights)
+				goto err;
+		} else {
+			if (i < hw_data->tx_rx_gap) {
+				pr_err("QAT: Invalid tx rings mask config\n");
+				goto err;
+			}
+			tx_ring = &bank->rings[i - hw_data->tx_rx_gap];
+			ring->inflights = tx_ring->inflights;
+		}
+	}
+	if (adf_bank_debugfs_add(bank)) {
+		pr_err("QAT: Failed to add bank debugfs entry\n");
+		goto err;
+	}
+
+	WRITE_CSR_INT_SRCSEL(csr_addr, bank_num);
+	return 0;
+err:
+	for (i = 0; i < ADF_ETR_MAX_RINGS_PER_BANK; i++) {
+		ring = &bank->rings[i];
+		if (hw_data->tx_rings_mask & (1 << i) && ring->inflights)
+			kfree(ring->inflights);
+	}
+	return -ENOMEM;
+}
+
+/**
+ * adf_init_etr_data() - Initialize transport rings for acceleration device
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function is the initializes the communications channels (rings) to the
+ * acceleration device accel_dev.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int adf_init_etr_data(struct adf_accel_dev *accel_dev)
+{
+	struct adf_etr_data *etr_data;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	void __iomem *csr_addr;
+	uint32_t size;
+	uint32_t num_banks = 0;
+	int i, ret;
+
+	etr_data = kzalloc_node(sizeof(*etr_data), GFP_KERNEL,
+				accel_dev->numa_node);
+	if (!etr_data)
+		return -ENOMEM;
+
+	num_banks = GET_MAX_BANKS(accel_dev);
+	size = num_banks * sizeof(struct adf_etr_bank_data);
+	etr_data->banks = kzalloc_node(size, GFP_KERNEL, accel_dev->numa_node);
+	if (!etr_data->banks) {
+		ret = -ENOMEM;
+		goto err_bank;
+	}
+
+	accel_dev->transport = etr_data;
+	i = hw_data->get_etr_bar_id(hw_data);
+	csr_addr = accel_dev->accel_pci_dev.pci_bars[i].virt_addr;
+
+	/* accel_dev->debugfs_dir should always be non-NULL here */
+	etr_data->debug = debugfs_create_dir("transport",
+					     accel_dev->debugfs_dir);
+	if (!etr_data->debug) {
+		pr_err("QAT: Unable to create transport debugfs entry\n");
+		ret = -ENOENT;
+		goto err_bank_debug;
+	}
+
+	for (i = 0; i < num_banks; i++) {
+		ret = adf_init_bank(accel_dev, &etr_data->banks[i], i,
+				    csr_addr);
+		if (ret)
+			goto err_bank_all;
+	}
+
+	return 0;
+
+err_bank_all:
+	debugfs_remove(etr_data->debug);
+err_bank_debug:
+	kfree(etr_data->banks);
+err_bank:
+	kfree(etr_data);
+	accel_dev->transport = NULL;
+	return ret;
+}
+EXPORT_SYMBOL_GPL(adf_init_etr_data);
+
+static void cleanup_bank(struct adf_etr_bank_data *bank)
+{
+	uint32_t i;
+
+	for (i = 0; i < ADF_ETR_MAX_RINGS_PER_BANK; i++) {
+		struct adf_accel_dev *accel_dev = bank->accel_dev;
+		struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+		struct adf_etr_ring_data *ring = &bank->rings[i];
+
+		if (bank->ring_mask & (1 << i))
+			adf_cleanup_ring(ring);
+
+		if (hw_data->tx_rings_mask & (1 << i))
+			kfree(ring->inflights);
+	}
+	adf_bank_debugfs_rm(bank);
+	memset(bank, 0, sizeof(*bank));
+}
+
+static void adf_cleanup_etr_handles(struct adf_accel_dev *accel_dev)
+{
+	struct adf_etr_data *etr_data = accel_dev->transport;
+	uint32_t i, num_banks = GET_MAX_BANKS(accel_dev);
+
+	for (i = 0; i < num_banks; i++)
+		cleanup_bank(&etr_data->banks[i]);
+}
+
+/**
+ * adf_cleanup_etr_data() - Clear transport rings for acceleration device
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * Function is the clears the communications channels (rings) of the
+ * acceleration device accel_dev.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: void
+ */
+void adf_cleanup_etr_data(struct adf_accel_dev *accel_dev)
+{
+	struct adf_etr_data *etr_data = accel_dev->transport;
+
+	if (etr_data) {
+		adf_cleanup_etr_handles(accel_dev);
+		debugfs_remove(etr_data->debug);
+		kfree(etr_data->banks);
+		kfree(etr_data);
+		accel_dev->transport = NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(adf_cleanup_etr_data);
diff --git a/drivers/crypto/qat/qat_common/adf_transport.h b/drivers/crypto/qat/qat_common/adf_transport.h
new file mode 100644
index 0000000..386485b
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_transport.h
@@ -0,0 +1,63 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_TRANSPORT_H
+#define ADF_TRANSPORT_H
+
+#include "adf_accel_devices.h"
+
+struct adf_etr_ring_data;
+
+typedef void (*adf_callback_fn)(void *resp_msg);
+
+int adf_create_ring(struct adf_accel_dev *accel_dev, const char *section,
+		    uint32_t bank_num, uint32_t num_mgs, uint32_t msg_size,
+		    const char *ring_name, adf_callback_fn callback,
+		    int poll_mode, struct adf_etr_ring_data **ring_ptr);
+
+int adf_send_message(struct adf_etr_ring_data *ring, uint32_t *msg);
+void adf_remove_ring(struct adf_etr_ring_data *ring);
+#endif
diff --git a/drivers/crypto/qat/qat_common/adf_transport_access_macros.h b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
new file mode 100644
index 0000000..91d88d6
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_transport_access_macros.h
@@ -0,0 +1,160 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_TRANSPORT_ACCESS_MACROS_H
+#define ADF_TRANSPORT_ACCESS_MACROS_H
+
+#include "adf_accel_devices.h"
+#define ADF_BANK_INT_SRC_SEL_MASK_0 0x4444444CUL
+#define ADF_BANK_INT_SRC_SEL_MASK_X 0x44444444UL
+#define ADF_RING_CSR_RING_CONFIG 0x000
+#define ADF_RING_CSR_RING_LBASE 0x040
+#define ADF_RING_CSR_RING_UBASE 0x080
+#define ADF_RING_CSR_RING_HEAD 0x0C0
+#define ADF_RING_CSR_RING_TAIL 0x100
+#define ADF_RING_CSR_E_STAT 0x14C
+#define ADF_RING_CSR_INT_SRCSEL 0x174
+#define ADF_RING_CSR_INT_SRCSEL_2 0x178
+#define ADF_RING_CSR_INT_COL_EN 0x17C
+#define ADF_RING_CSR_INT_COL_CTL 0x180
+#define ADF_RING_CSR_INT_FLAG_AND_COL 0x184
+#define ADF_RING_CSR_INT_COL_CTL_ENABLE	0x80000000
+#define ADF_RING_BUNDLE_SIZE 0x1000
+#define ADF_RING_CONFIG_NEAR_FULL_WM 0x0A
+#define ADF_RING_CONFIG_NEAR_EMPTY_WM 0x05
+#define ADF_COALESCING_MIN_TIME 0x1FF
+#define ADF_COALESCING_MAX_TIME 0xFFFFF
+#define ADF_COALESCING_DEF_TIME 0x27FF
+#define ADF_RING_NEAR_WATERMARK_512 0x08
+#define ADF_RING_NEAR_WATERMARK_0 0x00
+#define ADF_RING_EMPTY_SIG 0x7F7F7F7F
+
+/* Valid internal ring size values */
+#define ADF_RING_SIZE_128 0x01
+#define ADF_RING_SIZE_256 0x02
+#define ADF_RING_SIZE_512 0x03
+#define ADF_RING_SIZE_4K 0x06
+#define ADF_RING_SIZE_16K 0x08
+#define ADF_RING_SIZE_4M 0x10
+#define ADF_MIN_RING_SIZE ADF_RING_SIZE_128
+#define ADF_MAX_RING_SIZE ADF_RING_SIZE_4M
+#define ADF_DEFAULT_RING_SIZE ADF_RING_SIZE_16K
+
+/* Valid internal msg size values internal */
+#define ADF_MSG_SIZE_32 0x01
+#define ADF_MSG_SIZE_64 0x02
+#define ADF_MSG_SIZE_128 0x04
+#define ADF_MIN_MSG_SIZE ADF_MSG_SIZE_32
+#define ADF_MAX_MSG_SIZE ADF_MSG_SIZE_128
+
+/* Size to bytes conversion macros for ring and msg values */
+#define ADF_MSG_SIZE_TO_BYTES(SIZE) (SIZE << 5)
+#define ADF_BYTES_TO_MSG_SIZE(SIZE) (SIZE >> 5)
+#define ADF_SIZE_TO_RING_SIZE_IN_BYTES(SIZE) ((1 << (SIZE - 1)) << 7)
+#define ADF_RING_SIZE_IN_BYTES_TO_SIZE(SIZE) ((1 << (SIZE - 1)) >> 7)
+
+/* Minimum ring bufer size for memory allocation */
+#define ADF_RING_SIZE_BYTES_MIN(SIZE) ((SIZE < ADF_RING_SIZE_4K) ? \
+				ADF_RING_SIZE_4K : SIZE)
+#define ADF_RING_SIZE_MODULO(SIZE) (SIZE + 0x6)
+#define ADF_MAX_INFLIGHTS(RING_SIZE, MSG_SIZE) \
+	((((1 << (RING_SIZE - 1)) << 4) >> MSG_SIZE) - 1)
+#define BUILD_RING_CONFIG(size)	\
+	((ADF_RING_NEAR_WATERMARK_0 << ADF_RING_CONFIG_NEAR_FULL_WM) \
+	| (ADF_RING_NEAR_WATERMARK_0 << ADF_RING_CONFIG_NEAR_EMPTY_WM) \
+	| size)
+#define BUILD_RESP_RING_CONFIG(size, watermark_nf, watermark_ne) \
+	((watermark_nf << ADF_RING_CONFIG_NEAR_FULL_WM)	\
+	| (watermark_ne << ADF_RING_CONFIG_NEAR_EMPTY_WM) \
+	| size)
+#define BUILD_RING_BASE_ADDR(addr, size) \
+	((addr >> 6) & (0xFFFFFFFFFFFFFFFFULL << size))
+#define READ_CSR_RING_HEAD(csr_base_addr, bank, ring) \
+	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+			ADF_RING_CSR_RING_HEAD + (ring << 2))
+#define READ_CSR_RING_TAIL(csr_base_addr, bank, ring) \
+	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+			ADF_RING_CSR_RING_TAIL + (ring << 2))
+#define READ_CSR_E_STAT(csr_base_addr, bank) \
+	ADF_CSR_RD(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+			ADF_RING_CSR_E_STAT)
+#define WRITE_CSR_RING_CONFIG(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+		ADF_RING_CSR_RING_CONFIG + (ring << 2), value)
+#define WRITE_CSR_RING_BASE(csr_base_addr, bank, ring, value) \
+do { \
+	uint32_t l_base = 0, u_base = 0; \
+	l_base = (uint32_t)(value & 0xFFFFFFFF); \
+	u_base = (uint32_t)((value & 0xFFFFFFFF00000000ULL) >> 32); \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+		ADF_RING_CSR_RING_LBASE + (ring << 2), l_base);	\
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+		ADF_RING_CSR_RING_UBASE + (ring << 2), u_base);	\
+} while (0)
+#define WRITE_CSR_RING_HEAD(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+		ADF_RING_CSR_RING_HEAD + (ring << 2), value)
+#define WRITE_CSR_RING_TAIL(csr_base_addr, bank, ring, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+		ADF_RING_CSR_RING_TAIL + (ring << 2), value)
+#define WRITE_CSR_INT_SRCSEL(csr_base_addr, bank) \
+do { \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+	ADF_RING_CSR_INT_SRCSEL, ADF_BANK_INT_SRC_SEL_MASK_0);	\
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+	ADF_RING_CSR_INT_SRCSEL_2, ADF_BANK_INT_SRC_SEL_MASK_X); \
+} while (0)
+#define WRITE_CSR_INT_COL_EN(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+			ADF_RING_CSR_INT_COL_EN, value)
+#define WRITE_CSR_INT_COL_CTL(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+			ADF_RING_CSR_INT_COL_CTL, \
+			ADF_RING_CSR_INT_COL_CTL_ENABLE | value)
+#define WRITE_CSR_INT_FLAG_AND_COL(csr_base_addr, bank, value) \
+	ADF_CSR_WR(csr_base_addr, (ADF_RING_BUNDLE_SIZE * bank) + \
+			ADF_RING_CSR_INT_FLAG_AND_COL, value)
+#endif
diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
new file mode 100644
index 0000000..d83a581
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -0,0 +1,301 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/mutex.h>
+#include <linux/slab.h>
+#include <linux/seq_file.h>
+#include "adf_accel_devices.h"
+#include "adf_transport_internal.h"
+#include "adf_transport_access_macros.h"
+
+static DEFINE_MUTEX(ring_read_lock);
+static DEFINE_MUTEX(bank_read_lock);
+
+static void *adf_ring_start(struct seq_file *sfile, loff_t *pos)
+{
+	struct adf_etr_ring_data *ring = sfile->private;
+	mutex_lock(&ring_read_lock);
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
+	if (*pos >= (ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size) /
+		     ADF_MSG_SIZE_TO_BYTES(ring->msg_size)))
+		return NULL;
+
+	return ring->base_addr +
+		(ADF_MSG_SIZE_TO_BYTES(ring->msg_size) * (*pos)++);
+}
+
+static void *adf_ring_next(struct seq_file *sfile, void *v, loff_t *pos)
+{
+	struct adf_etr_ring_data *ring = sfile->private;
+
+	if (*pos >= (ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size) /
+		     ADF_MSG_SIZE_TO_BYTES(ring->msg_size)))
+		return NULL;
+
+	return ring->base_addr +
+		(ADF_MSG_SIZE_TO_BYTES(ring->msg_size) * (*pos)++);
+}
+
+static int adf_ring_show(struct seq_file *sfile, void *v)
+{
+	struct adf_etr_ring_data *ring = sfile->private;
+	struct adf_etr_bank_data *bank = ring->bank;
+	uint32_t *msg = v;
+	void __iomem *csr = ring->bank->csr_addr;
+	int i, x;
+
+	if (v == SEQ_START_TOKEN) {
+		int head, tail, empty;
+
+		head = READ_CSR_RING_HEAD(csr, bank->bank_number,
+					  ring->ring_number);
+		tail = READ_CSR_RING_TAIL(csr, bank->bank_number,
+					  ring->ring_number);
+		empty = READ_CSR_E_STAT(csr, bank->bank_number);
+
+		seq_puts(sfile, "------- Ring configuration -------\n");
+		seq_printf(sfile, "ring num %d, bank num %d\n",
+			   ring->ring_number, ring->bank->bank_number);
+		seq_printf(sfile, "head %x, tail %x, empty: %d\n",
+			   head, tail, (empty & 1 << ring->ring_number)
+			   >> ring->ring_number);
+		seq_printf(sfile, "ring size %d, msg size %d\n",
+			   ADF_SIZE_TO_RING_SIZE_IN_BYTES(ring->ring_size),
+			   ADF_MSG_SIZE_TO_BYTES(ring->msg_size));
+		seq_puts(sfile, "----------- Ring data ------------\n");
+		return 0;
+	}
+	seq_printf(sfile, "%p:", msg);
+	x = 0;
+	i = 0;
+	for (; i < (ADF_MSG_SIZE_TO_BYTES(ring->msg_size) >> 2); i++) {
+		seq_printf(sfile, " %08X", *(msg + i));
+		if ((ADF_MSG_SIZE_TO_BYTES(ring->msg_size) >> 2) != i + 1 &&
+		    (++x == 8)) {
+			seq_printf(sfile, "\n%p:", msg + i + 1);
+			x = 0;
+		}
+	}
+	seq_puts(sfile, "\n");
+	return 0;
+}
+
+static void adf_ring_stop(struct seq_file *sfile, void *v)
+{
+	mutex_unlock(&ring_read_lock);
+}
+
+static const struct seq_operations adf_ring_sops = {
+	.start = adf_ring_start,
+	.next = adf_ring_next,
+	.stop = adf_ring_stop,
+	.show = adf_ring_show
+};
+
+static int adf_ring_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open(file, &adf_ring_sops);
+
+	if (!ret) {
+		struct seq_file *seq_f = file->private_data;
+		seq_f->private = inode->i_private;
+	}
+	return ret;
+}
+
+static const struct file_operations adf_ring_debug_fops = {
+	.open = adf_ring_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release
+};
+
+int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name)
+{
+	struct adf_etr_ring_debug_entry *ring_debug;
+	char entry_name[8];
+
+	ring_debug = kzalloc(sizeof(*ring_debug), GFP_KERNEL);
+	if (!ring_debug)
+		return -ENOMEM;
+
+	strlcpy(ring_debug->ring_name, name, sizeof(ring_debug->ring_name));
+	snprintf(entry_name, sizeof(entry_name), "ring_%02d",
+		 ring->ring_number);
+
+	ring_debug->debug = debugfs_create_file(entry_name, S_IRUSR,
+						ring->bank->bank_debug_dir,
+						ring, &adf_ring_debug_fops);
+	if (!ring_debug->debug) {
+		pr_err("QAT: Failed to create ring debug entry.\n");
+		kfree(ring_debug);
+		return -EFAULT;
+	}
+	ring->ring_debug = ring_debug;
+	return 0;
+}
+
+void adf_ring_debugfs_rm(struct adf_etr_ring_data *ring)
+{
+	if (ring->ring_debug) {
+		debugfs_remove(ring->ring_debug->debug);
+		kfree(ring->ring_debug);
+		ring->ring_debug = NULL;
+	}
+}
+
+static void *adf_bank_start(struct seq_file *sfile, loff_t *pos)
+{
+	mutex_lock(&bank_read_lock);
+	if (*pos == 0)
+		return SEQ_START_TOKEN;
+
+	if (*pos >= ADF_ETR_MAX_RINGS_PER_BANK)
+		return NULL;
+
+	return pos;
+}
+
+static void *adf_bank_next(struct seq_file *sfile, void *v, loff_t *pos)
+{
+	if (++(*pos) >= ADF_ETR_MAX_RINGS_PER_BANK)
+		return NULL;
+
+	return pos;
+}
+
+static int adf_bank_show(struct seq_file *sfile, void *v)
+{
+	struct adf_etr_bank_data *bank = sfile->private;
+
+	if (v == SEQ_START_TOKEN) {
+		seq_printf(sfile, "------- Bank %d configuration -------\n",
+			   bank->bank_number);
+	} else {
+		int ring_id = *((int *)v) - 1;
+		struct adf_etr_ring_data *ring = &bank->rings[ring_id];
+		void __iomem *csr = bank->csr_addr;
+		int head, tail, empty;
+
+		if (!(bank->ring_mask & 1 << ring_id))
+			return 0;
+
+		head = READ_CSR_RING_HEAD(csr, bank->bank_number,
+					  ring->ring_number);
+		tail = READ_CSR_RING_TAIL(csr, bank->bank_number,
+					  ring->ring_number);
+		empty = READ_CSR_E_STAT(csr, bank->bank_number);
+
+		seq_printf(sfile,
+			   "ring num %02d, head %04x, tail %04x, empty: %d\n",
+			   ring->ring_number, head, tail,
+			   (empty & 1 << ring->ring_number) >>
+			   ring->ring_number);
+	}
+	return 0;
+}
+
+static void adf_bank_stop(struct seq_file *sfile, void *v)
+{
+	mutex_unlock(&bank_read_lock);
+}
+
+static const struct seq_operations adf_bank_sops = {
+	.start = adf_bank_start,
+	.next = adf_bank_next,
+	.stop = adf_bank_stop,
+	.show = adf_bank_show
+};
+
+static int adf_bank_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open(file, &adf_bank_sops);
+
+	if (!ret) {
+		struct seq_file *seq_f = file->private_data;
+		seq_f->private = inode->i_private;
+	}
+	return ret;
+}
+
+static const struct file_operations adf_bank_debug_fops = {
+	.open = adf_bank_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release
+};
+
+int adf_bank_debugfs_add(struct adf_etr_bank_data *bank)
+{
+	struct adf_accel_dev *accel_dev = bank->accel_dev;
+	struct dentry *parent = accel_dev->transport->debug;
+	char name[8];
+
+	snprintf(name, sizeof(name), "bank_%02d", bank->bank_number);
+	bank->bank_debug_dir = debugfs_create_dir(name, parent);
+	if (!bank->bank_debug_dir) {
+		pr_err("QAT: Failed to create bank debug dir.\n");
+		return -EFAULT;
+	}
+
+	bank->bank_debug_cfg = debugfs_create_file("config", S_IRUSR,
+						   bank->bank_debug_dir, bank,
+						   &adf_bank_debug_fops);
+	if (!bank->bank_debug_cfg) {
+		pr_err("QAT: Failed to create bank debug entry.\n");
+		debugfs_remove(bank->bank_debug_dir);
+		return -EFAULT;
+	}
+	return 0;
+}
+
+void adf_bank_debugfs_rm(struct adf_etr_bank_data *bank)
+{
+	debugfs_remove(bank->bank_debug_cfg);
+	debugfs_remove(bank->bank_debug_dir);
+}
diff --git a/drivers/crypto/qat/qat_common/adf_transport_internal.h b/drivers/crypto/qat/qat_common/adf_transport_internal.h
new file mode 100644
index 0000000..4eb8969
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_transport_internal.h
@@ -0,0 +1,115 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef ADF_TRANSPORT_INTRN_H
+#define ADF_TRANSPORT_INTRN_H
+
+#include <linux/interrupt.h>
+#include <linux/atomic.h>
+#include <linux/spinlock_types.h>
+#include "adf_transport.h"
+
+struct adf_etr_ring_debug_entry {
+	char ring_name[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+	struct dentry *debug;
+};
+
+struct adf_etr_ring_data {
+	void *base_addr;
+	atomic_t *inflights;
+	spinlock_t lock;	/* protects ring data struct */
+	adf_callback_fn callback;
+	struct adf_etr_bank_data *bank;
+	dma_addr_t dma_addr;
+	uint16_t head;
+	uint16_t tail;
+	uint8_t ring_number;
+	uint8_t ring_size;
+	uint8_t msg_size;
+	uint8_t reserved;
+	struct adf_etr_ring_debug_entry *ring_debug;
+} __packed;
+
+struct adf_etr_bank_data {
+	struct adf_etr_ring_data rings[ADF_ETR_MAX_RINGS_PER_BANK];
+	struct tasklet_struct resp_hanlder;
+	void __iomem *csr_addr;
+	struct adf_accel_dev *accel_dev;
+	uint32_t irq_coalesc_timer;
+	uint16_t ring_mask;
+	uint16_t irq_mask;
+	spinlock_t lock;	/* protects bank data struct */
+	struct dentry *bank_debug_dir;
+	struct dentry *bank_debug_cfg;
+	uint32_t bank_number;
+} __packed;
+
+struct adf_etr_data {
+	struct adf_etr_bank_data *banks;
+	struct dentry *debug;
+};
+
+void adf_response_handler(unsigned long bank_addr);
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+int adf_bank_debugfs_add(struct adf_etr_bank_data *bank);
+void adf_bank_debugfs_rm(struct adf_etr_bank_data *bank);
+int adf_ring_debugfs_add(struct adf_etr_ring_data *ring, const char *name);
+void adf_ring_debugfs_rm(struct adf_etr_ring_data *ring);
+#else
+static inline int adf_bank_debugfs_add(struct adf_etr_bank_data *bank)
+{
+	return 0;
+}
+#define adf_bank_debugfs_rm(bank) do {} while (0)
+static inline int adf_ring_debugfs_add(struct adf_etr_ring_data *ring,
+				       const char *name)
+{
+	return 0;
+}
+#define adf_ring_debugfs_rm(ring) do {} while (0)
+#endif
+#endif
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw.h b/drivers/crypto/qat/qat_common/icp_qat_fw.h
new file mode 100644
index 0000000..f1e30e2
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw.h
@@ -0,0 +1,316 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef _ICP_QAT_FW_H_
+#define _ICP_QAT_FW_H_
+#include <linux/types.h>
+#include "icp_qat_hw.h"
+
+#define QAT_FIELD_SET(flags, val, bitpos, mask) \
+{ (flags) = (((flags) & (~((mask) << (bitpos)))) | \
+		(((val) & (mask)) << (bitpos))) ; }
+
+#define QAT_FIELD_GET(flags, bitpos, mask) \
+	(((flags) >> (bitpos)) & (mask))
+
+#define ICP_QAT_FW_REQ_DEFAULT_SZ 128
+#define ICP_QAT_FW_RESP_DEFAULT_SZ 32
+#define ICP_QAT_FW_COMN_ONE_BYTE_SHIFT 8
+#define ICP_QAT_FW_COMN_SINGLE_BYTE_MASK 0xFF
+#define ICP_QAT_FW_NUM_LONGWORDS_1 1
+#define ICP_QAT_FW_NUM_LONGWORDS_2 2
+#define ICP_QAT_FW_NUM_LONGWORDS_3 3
+#define ICP_QAT_FW_NUM_LONGWORDS_4 4
+#define ICP_QAT_FW_NUM_LONGWORDS_5 5
+#define ICP_QAT_FW_NUM_LONGWORDS_6 6
+#define ICP_QAT_FW_NUM_LONGWORDS_7 7
+#define ICP_QAT_FW_NUM_LONGWORDS_10 10
+#define ICP_QAT_FW_NUM_LONGWORDS_13 13
+#define ICP_QAT_FW_NULL_REQ_SERV_ID 1
+
+enum icp_qat_fw_comn_resp_serv_id {
+	ICP_QAT_FW_COMN_RESP_SERV_NULL,
+	ICP_QAT_FW_COMN_RESP_SERV_CPM_FW,
+	ICP_QAT_FW_COMN_RESP_SERV_DELIMITER
+};
+
+enum icp_qat_fw_comn_request_id {
+	ICP_QAT_FW_COMN_REQ_NULL = 0,
+	ICP_QAT_FW_COMN_REQ_CPM_FW_PKE = 3,
+	ICP_QAT_FW_COMN_REQ_CPM_FW_LA = 4,
+	ICP_QAT_FW_COMN_REQ_CPM_FW_DMA = 7,
+	ICP_QAT_FW_COMN_REQ_CPM_FW_COMP = 9,
+	ICP_QAT_FW_COMN_REQ_DELIMITER
+};
+
+struct icp_qat_fw_comn_req_hdr_cd_pars {
+	union {
+		struct {
+			uint64_t content_desc_addr;
+			uint16_t content_desc_resrvd1;
+			uint8_t content_desc_params_sz;
+			uint8_t content_desc_hdr_resrvd2;
+			uint32_t content_desc_resrvd3;
+		} s;
+		struct {
+			uint32_t serv_specif_fields[4];
+		} s1;
+	} u;
+};
+
+struct icp_qat_fw_comn_req_mid {
+	uint64_t opaque_data;
+	uint64_t src_data_addr;
+	uint64_t dest_data_addr;
+	uint32_t src_length;
+	uint32_t dst_length;
+};
+
+struct icp_qat_fw_comn_req_cd_ctrl {
+	uint32_t content_desc_ctrl_lw[ICP_QAT_FW_NUM_LONGWORDS_5];
+};
+
+struct icp_qat_fw_comn_req_hdr {
+	uint8_t resrvd1;
+	uint8_t service_cmd_id;
+	uint8_t service_type;
+	uint8_t hdr_flags;
+	uint16_t serv_specif_flags;
+	uint16_t comn_req_flags;
+};
+
+struct icp_qat_fw_comn_req_rqpars {
+	uint32_t serv_specif_rqpars_lw[ICP_QAT_FW_NUM_LONGWORDS_13];
+};
+
+struct icp_qat_fw_comn_req {
+	struct icp_qat_fw_comn_req_hdr comn_hdr;
+	struct icp_qat_fw_comn_req_hdr_cd_pars cd_pars;
+	struct icp_qat_fw_comn_req_mid comn_mid;
+	struct icp_qat_fw_comn_req_rqpars serv_specif_rqpars;
+	struct icp_qat_fw_comn_req_cd_ctrl cd_ctrl;
+};
+
+struct icp_qat_fw_comn_error {
+	uint8_t xlat_err_code;
+	uint8_t cmp_err_code;
+};
+
+struct icp_qat_fw_comn_resp_hdr {
+	uint8_t resrvd1;
+	uint8_t service_id;
+	uint8_t response_type;
+	uint8_t hdr_flags;
+	struct icp_qat_fw_comn_error comn_error;
+	uint8_t comn_status;
+	uint8_t cmd_id;
+};
+
+struct icp_qat_fw_comn_resp {
+	struct icp_qat_fw_comn_resp_hdr comn_hdr;
+	uint64_t opaque_data;
+	uint32_t resrvd[ICP_QAT_FW_NUM_LONGWORDS_4];
+};
+
+#define ICP_QAT_FW_COMN_REQ_FLAG_SET 1
+#define ICP_QAT_FW_COMN_REQ_FLAG_CLR 0
+#define ICP_QAT_FW_COMN_VALID_FLAG_BITPOS 7
+#define ICP_QAT_FW_COMN_VALID_FLAG_MASK 0x1
+#define ICP_QAT_FW_COMN_HDR_RESRVD_FLD_MASK 0x7F
+
+#define ICP_QAT_FW_COMN_OV_SRV_TYPE_GET(icp_qat_fw_comn_req_hdr_t) \
+	icp_qat_fw_comn_req_hdr_t.service_type
+
+#define ICP_QAT_FW_COMN_OV_SRV_TYPE_SET(icp_qat_fw_comn_req_hdr_t, val) \
+	icp_qat_fw_comn_req_hdr_t.service_type = val
+
+#define ICP_QAT_FW_COMN_OV_SRV_CMD_ID_GET(icp_qat_fw_comn_req_hdr_t) \
+	icp_qat_fw_comn_req_hdr_t.service_cmd_id
+
+#define ICP_QAT_FW_COMN_OV_SRV_CMD_ID_SET(icp_qat_fw_comn_req_hdr_t, val) \
+	icp_qat_fw_comn_req_hdr_t.service_cmd_id = val
+
+#define ICP_QAT_FW_COMN_HDR_VALID_FLAG_GET(hdr_t) \
+	ICP_QAT_FW_COMN_VALID_FLAG_GET(hdr_t.hdr_flags)
+
+#define ICP_QAT_FW_COMN_HDR_VALID_FLAG_SET(hdr_t, val) \
+	ICP_QAT_FW_COMN_VALID_FLAG_SET(hdr_t, val)
+
+#define ICP_QAT_FW_COMN_VALID_FLAG_GET(hdr_flags) \
+	QAT_FIELD_GET(hdr_flags, \
+	ICP_QAT_FW_COMN_VALID_FLAG_BITPOS, \
+	ICP_QAT_FW_COMN_VALID_FLAG_MASK)
+
+#define ICP_QAT_FW_COMN_HDR_RESRVD_FLD_GET(hdr_flags) \
+	(hdr_flags & ICP_QAT_FW_COMN_HDR_RESRVD_FLD_MASK)
+
+#define ICP_QAT_FW_COMN_VALID_FLAG_SET(hdr_t, val) \
+	QAT_FIELD_SET((hdr_t.hdr_flags), (val), \
+	ICP_QAT_FW_COMN_VALID_FLAG_BITPOS, \
+	ICP_QAT_FW_COMN_VALID_FLAG_MASK)
+
+#define ICP_QAT_FW_COMN_HDR_FLAGS_BUILD(valid) \
+	(((valid) & ICP_QAT_FW_COMN_VALID_FLAG_MASK) << \
+	 ICP_QAT_FW_COMN_VALID_FLAG_BITPOS)
+
+#define QAT_COMN_PTR_TYPE_BITPOS 0
+#define QAT_COMN_PTR_TYPE_MASK 0x1
+#define QAT_COMN_CD_FLD_TYPE_BITPOS 1
+#define QAT_COMN_CD_FLD_TYPE_MASK 0x1
+#define QAT_COMN_PTR_TYPE_FLAT 0x0
+#define QAT_COMN_PTR_TYPE_SGL 0x1
+#define QAT_COMN_CD_FLD_TYPE_64BIT_ADR 0x0
+#define QAT_COMN_CD_FLD_TYPE_16BYTE_DATA 0x1
+
+#define ICP_QAT_FW_COMN_FLAGS_BUILD(cdt, ptr) \
+	((((cdt) & QAT_COMN_CD_FLD_TYPE_MASK) << QAT_COMN_CD_FLD_TYPE_BITPOS) \
+	 | (((ptr) & QAT_COMN_PTR_TYPE_MASK) << QAT_COMN_PTR_TYPE_BITPOS))
+
+#define ICP_QAT_FW_COMN_PTR_TYPE_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_COMN_PTR_TYPE_BITPOS, QAT_COMN_PTR_TYPE_MASK)
+
+#define ICP_QAT_FW_COMN_CD_FLD_TYPE_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_COMN_CD_FLD_TYPE_BITPOS, \
+			QAT_COMN_CD_FLD_TYPE_MASK)
+
+#define ICP_QAT_FW_COMN_PTR_TYPE_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_COMN_PTR_TYPE_BITPOS, \
+			QAT_COMN_PTR_TYPE_MASK)
+
+#define ICP_QAT_FW_COMN_CD_FLD_TYPE_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_COMN_CD_FLD_TYPE_BITPOS, \
+			QAT_COMN_CD_FLD_TYPE_MASK)
+
+#define ICP_QAT_FW_COMN_NEXT_ID_BITPOS 4
+#define ICP_QAT_FW_COMN_NEXT_ID_MASK 0xF0
+#define ICP_QAT_FW_COMN_CURR_ID_BITPOS 0
+#define ICP_QAT_FW_COMN_CURR_ID_MASK 0x0F
+
+#define ICP_QAT_FW_COMN_NEXT_ID_GET(cd_ctrl_hdr_t) \
+	((((cd_ctrl_hdr_t)->next_curr_id) & ICP_QAT_FW_COMN_NEXT_ID_MASK) \
+	>> (ICP_QAT_FW_COMN_NEXT_ID_BITPOS))
+
+#define ICP_QAT_FW_COMN_NEXT_ID_SET(cd_ctrl_hdr_t, val) \
+	{ ((cd_ctrl_hdr_t)->next_curr_id) = ((((cd_ctrl_hdr_t)->next_curr_id) \
+	& ICP_QAT_FW_COMN_CURR_ID_MASK) | \
+	((val << ICP_QAT_FW_COMN_NEXT_ID_BITPOS) \
+	 & ICP_QAT_FW_COMN_NEXT_ID_MASK)); }
+
+#define ICP_QAT_FW_COMN_CURR_ID_GET(cd_ctrl_hdr_t) \
+	(((cd_ctrl_hdr_t)->next_curr_id) & ICP_QAT_FW_COMN_CURR_ID_MASK)
+
+#define ICP_QAT_FW_COMN_CURR_ID_SET(cd_ctrl_hdr_t, val) \
+	{ ((cd_ctrl_hdr_t)->next_curr_id) = ((((cd_ctrl_hdr_t)->next_curr_id) \
+	& ICP_QAT_FW_COMN_NEXT_ID_MASK) | \
+	((val) & ICP_QAT_FW_COMN_CURR_ID_MASK)); }
+
+#define QAT_COMN_RESP_CRYPTO_STATUS_BITPOS 7
+#define QAT_COMN_RESP_CRYPTO_STATUS_MASK 0x1
+#define QAT_COMN_RESP_CMP_STATUS_BITPOS 5
+#define QAT_COMN_RESP_CMP_STATUS_MASK 0x1
+#define QAT_COMN_RESP_XLAT_STATUS_BITPOS 4
+#define QAT_COMN_RESP_XLAT_STATUS_MASK 0x1
+#define QAT_COMN_RESP_CMP_END_OF_LAST_BLK_BITPOS 3
+#define QAT_COMN_RESP_CMP_END_OF_LAST_BLK_MASK 0x1
+
+#define ICP_QAT_FW_COMN_RESP_STATUS_BUILD(crypto, comp, xlat, eolb) \
+	((((crypto) & QAT_COMN_RESP_CRYPTO_STATUS_MASK) << \
+	QAT_COMN_RESP_CRYPTO_STATUS_BITPOS) | \
+	(((comp) & QAT_COMN_RESP_CMP_STATUS_MASK) << \
+	QAT_COMN_RESP_CMP_STATUS_BITPOS) | \
+	(((xlat) & QAT_COMN_RESP_XLAT_STATUS_MASK) << \
+	QAT_COMN_RESP_XLAT_STATUS_BITPOS) | \
+	(((eolb) & QAT_COMN_RESP_CMP_END_OF_LAST_BLK_MASK) << \
+	QAT_COMN_RESP_CMP_END_OF_LAST_BLK_BITPOS))
+
+#define ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(status) \
+	QAT_FIELD_GET(status, QAT_COMN_RESP_CRYPTO_STATUS_BITPOS, \
+	QAT_COMN_RESP_CRYPTO_STATUS_MASK)
+
+#define ICP_QAT_FW_COMN_RESP_CMP_STAT_GET(status) \
+	QAT_FIELD_GET(status, QAT_COMN_RESP_CMP_STATUS_BITPOS, \
+	QAT_COMN_RESP_CMP_STATUS_MASK)
+
+#define ICP_QAT_FW_COMN_RESP_XLAT_STAT_GET(status) \
+	QAT_FIELD_GET(status, QAT_COMN_RESP_XLAT_STATUS_BITPOS, \
+	QAT_COMN_RESP_XLAT_STATUS_MASK)
+
+#define ICP_QAT_FW_COMN_RESP_CMP_END_OF_LAST_BLK_FLAG_GET(status) \
+	QAT_FIELD_GET(status, QAT_COMN_RESP_CMP_END_OF_LAST_BLK_BITPOS, \
+	QAT_COMN_RESP_CMP_END_OF_LAST_BLK_MASK)
+
+#define ICP_QAT_FW_COMN_STATUS_FLAG_OK 0
+#define ICP_QAT_FW_COMN_STATUS_FLAG_ERROR 1
+#define ICP_QAT_FW_COMN_STATUS_CMP_END_OF_LAST_BLK_FLAG_CLR 0
+#define ICP_QAT_FW_COMN_STATUS_CMP_END_OF_LAST_BLK_FLAG_SET 1
+#define ERR_CODE_NO_ERROR 0
+#define ERR_CODE_INVALID_BLOCK_TYPE -1
+#define ERR_CODE_NO_MATCH_ONES_COMP -2
+#define ERR_CODE_TOO_MANY_LEN_OR_DIS -3
+#define ERR_CODE_INCOMPLETE_LEN -4
+#define ERR_CODE_RPT_LEN_NO_FIRST_LEN -5
+#define ERR_CODE_RPT_GT_SPEC_LEN -6
+#define ERR_CODE_INV_LIT_LEN_CODE_LEN -7
+#define ERR_CODE_INV_DIS_CODE_LEN -8
+#define ERR_CODE_INV_LIT_LEN_DIS_IN_BLK -9
+#define ERR_CODE_DIS_TOO_FAR_BACK -10
+#define ERR_CODE_OVERFLOW_ERROR -11
+#define ERR_CODE_SOFT_ERROR -12
+#define ERR_CODE_FATAL_ERROR -13
+#define ERR_CODE_SSM_ERROR -14
+#define ERR_CODE_ENDPOINT_ERROR -15
+
+enum icp_qat_fw_slice {
+	ICP_QAT_FW_SLICE_NULL = 0,
+	ICP_QAT_FW_SLICE_CIPHER = 1,
+	ICP_QAT_FW_SLICE_AUTH = 2,
+	ICP_QAT_FW_SLICE_DRAM_RD = 3,
+	ICP_QAT_FW_SLICE_DRAM_WR = 4,
+	ICP_QAT_FW_SLICE_COMP = 5,
+	ICP_QAT_FW_SLICE_XLAT = 6,
+	ICP_QAT_FW_SLICE_DELIMITER
+};
+#endif
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h b/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
new file mode 100644
index 0000000..72a59fa
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_init_admin.h
@@ -0,0 +1,131 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef _ICP_QAT_FW_INIT_ADMIN_H_
+#define _ICP_QAT_FW_INIT_ADMIN_H_
+
+#include "icp_qat_fw.h"
+
+enum icp_qat_fw_init_admin_cmd_id {
+	ICP_QAT_FW_INIT_ME = 0,
+	ICP_QAT_FW_TRNG_ENABLE = 1,
+	ICP_QAT_FW_TRNG_DISABLE = 2,
+	ICP_QAT_FW_CONSTANTS_CFG = 3,
+	ICP_QAT_FW_STATUS_GET = 4,
+	ICP_QAT_FW_COUNTERS_GET = 5,
+	ICP_QAT_FW_LOOPBACK = 6,
+	ICP_QAT_FW_HEARTBEAT_SYNC = 7,
+	ICP_QAT_FW_HEARTBEAT_GET = 8
+};
+
+enum icp_qat_fw_init_admin_resp_status {
+	ICP_QAT_FW_INIT_RESP_STATUS_SUCCESS = 0,
+	ICP_QAT_FW_INIT_RESP_STATUS_FAIL
+};
+
+struct icp_qat_fw_init_admin_req {
+	uint16_t init_cfg_sz;
+	uint8_t resrvd1;
+	uint8_t init_admin_cmd_id;
+	uint32_t resrvd2;
+	uint64_t opaque_data;
+	uint64_t init_cfg_ptr;
+	uint64_t resrvd3;
+};
+
+struct icp_qat_fw_init_admin_resp_hdr {
+	uint8_t flags;
+	uint8_t resrvd1;
+	uint8_t status;
+	uint8_t init_admin_cmd_id;
+};
+
+struct icp_qat_fw_init_admin_resp_pars {
+	union {
+		uint32_t resrvd1[ICP_QAT_FW_NUM_LONGWORDS_4];
+		struct {
+			uint32_t version_patch_num;
+			uint8_t context_id;
+			uint8_t ae_id;
+			uint16_t resrvd1;
+			uint64_t resrvd2;
+		} s1;
+		struct {
+			uint64_t req_rec_count;
+			uint64_t resp_sent_count;
+		} s2;
+	} u;
+};
+
+struct icp_qat_fw_init_admin_resp {
+	struct icp_qat_fw_init_admin_resp_hdr init_resp_hdr;
+	union {
+		uint32_t resrvd2;
+		struct {
+			uint16_t version_minor_num;
+			uint16_t version_major_num;
+		} s;
+	} u;
+	uint64_t opaque_data;
+	struct icp_qat_fw_init_admin_resp_pars init_resp_pars;
+};
+
+#define ICP_QAT_FW_COMN_HEARTBEAT_OK 0
+#define ICP_QAT_FW_COMN_HEARTBEAT_BLOCKED 1
+#define ICP_QAT_FW_COMN_HEARTBEAT_FLAG_BITPOS 0
+#define ICP_QAT_FW_COMN_HEARTBEAT_FLAG_MASK 0x1
+#define ICP_QAT_FW_COMN_STATUS_RESRVD_FLD_MASK 0xFE
+#define ICP_QAT_FW_COMN_HEARTBEAT_HDR_FLAG_GET(hdr_t) \
+	ICP_QAT_FW_COMN_HEARTBEAT_FLAG_GET(hdr_t.flags)
+
+#define ICP_QAT_FW_COMN_HEARTBEAT_HDR_FLAG_SET(hdr_t, val) \
+	ICP_QAT_FW_COMN_HEARTBEAT_FLAG_SET(hdr_t, val)
+
+#define ICP_QAT_FW_COMN_HEARTBEAT_FLAG_GET(flags) \
+	QAT_FIELD_GET(flags, \
+		 ICP_QAT_FW_COMN_HEARTBEAT_FLAG_BITPOS, \
+		 ICP_QAT_FW_COMN_HEARTBEAT_FLAG_MASK)
+#endif
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_la.h b/drivers/crypto/qat/qat_common/icp_qat_fw_la.h
new file mode 100644
index 0000000..d1d4802
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_la.h
@@ -0,0 +1,403 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef _ICP_QAT_FW_LA_H_
+#define _ICP_QAT_FW_LA_H_
+#include "icp_qat_fw.h"
+
+enum icp_qat_fw_la_cmd_id {
+	ICP_QAT_FW_LA_CMD_CIPHER = 0,
+	ICP_QAT_FW_LA_CMD_AUTH = 1,
+	ICP_QAT_FW_LA_CMD_CIPHER_HASH = 2,
+	ICP_QAT_FW_LA_CMD_HASH_CIPHER = 3,
+	ICP_QAT_FW_LA_CMD_TRNG_GET_RANDOM = 4,
+	ICP_QAT_FW_LA_CMD_TRNG_TEST = 5,
+	ICP_QAT_FW_LA_CMD_SSL3_KEY_DERIVE = 6,
+	ICP_QAT_FW_LA_CMD_TLS_V1_1_KEY_DERIVE = 7,
+	ICP_QAT_FW_LA_CMD_TLS_V1_2_KEY_DERIVE = 8,
+	ICP_QAT_FW_LA_CMD_MGF1 = 9,
+	ICP_QAT_FW_LA_CMD_AUTH_PRE_COMP = 10,
+	ICP_QAT_FW_LA_CMD_CIPHER_PRE_COMP = 11,
+	ICP_QAT_FW_LA_CMD_DELIMITER = 12
+};
+
+#define ICP_QAT_FW_LA_ICV_VER_STATUS_PASS ICP_QAT_FW_COMN_STATUS_FLAG_OK
+#define ICP_QAT_FW_LA_ICV_VER_STATUS_FAIL ICP_QAT_FW_COMN_STATUS_FLAG_ERROR
+#define ICP_QAT_FW_LA_TRNG_STATUS_PASS ICP_QAT_FW_COMN_STATUS_FLAG_OK
+#define ICP_QAT_FW_LA_TRNG_STATUS_FAIL ICP_QAT_FW_COMN_STATUS_FLAG_ERROR
+
+struct icp_qat_fw_la_bulk_req {
+	struct icp_qat_fw_comn_req_hdr comn_hdr;
+	struct icp_qat_fw_comn_req_hdr_cd_pars cd_pars;
+	struct icp_qat_fw_comn_req_mid comn_mid;
+	struct icp_qat_fw_comn_req_rqpars serv_specif_rqpars;
+	struct icp_qat_fw_comn_req_cd_ctrl cd_ctrl;
+};
+
+#define ICP_QAT_FW_LA_GCM_IV_LEN_12_OCTETS 1
+#define ICP_QAT_FW_LA_GCM_IV_LEN_NOT_12_OCTETS 0
+#define QAT_FW_LA_ZUC_3G_PROTO_FLAG_BITPOS 12
+#define ICP_QAT_FW_LA_ZUC_3G_PROTO 1
+#define QAT_FW_LA_ZUC_3G_PROTO_FLAG_MASK 0x1
+#define QAT_LA_GCM_IV_LEN_FLAG_BITPOS 11
+#define QAT_LA_GCM_IV_LEN_FLAG_MASK 0x1
+#define ICP_QAT_FW_LA_DIGEST_IN_BUFFER 1
+#define ICP_QAT_FW_LA_NO_DIGEST_IN_BUFFER 0
+#define QAT_LA_DIGEST_IN_BUFFER_BITPOS	10
+#define QAT_LA_DIGEST_IN_BUFFER_MASK 0x1
+#define ICP_QAT_FW_LA_SNOW_3G_PROTO 4
+#define ICP_QAT_FW_LA_GCM_PROTO	2
+#define ICP_QAT_FW_LA_CCM_PROTO	1
+#define ICP_QAT_FW_LA_NO_PROTO 0
+#define QAT_LA_PROTO_BITPOS 7
+#define QAT_LA_PROTO_MASK 0x7
+#define ICP_QAT_FW_LA_CMP_AUTH_RES 1
+#define ICP_QAT_FW_LA_NO_CMP_AUTH_RES 0
+#define QAT_LA_CMP_AUTH_RES_BITPOS 6
+#define QAT_LA_CMP_AUTH_RES_MASK 0x1
+#define ICP_QAT_FW_LA_RET_AUTH_RES 1
+#define ICP_QAT_FW_LA_NO_RET_AUTH_RES 0
+#define QAT_LA_RET_AUTH_RES_BITPOS 5
+#define QAT_LA_RET_AUTH_RES_MASK 0x1
+#define ICP_QAT_FW_LA_UPDATE_STATE 1
+#define ICP_QAT_FW_LA_NO_UPDATE_STATE 0
+#define QAT_LA_UPDATE_STATE_BITPOS 4
+#define QAT_LA_UPDATE_STATE_MASK 0x1
+#define ICP_QAT_FW_CIPH_AUTH_CFG_OFFSET_IN_CD_SETUP 0
+#define ICP_QAT_FW_CIPH_AUTH_CFG_OFFSET_IN_SHRAM_CP 1
+#define QAT_LA_CIPH_AUTH_CFG_OFFSET_BITPOS 3
+#define QAT_LA_CIPH_AUTH_CFG_OFFSET_MASK 0x1
+#define ICP_QAT_FW_CIPH_IV_64BIT_PTR 0
+#define ICP_QAT_FW_CIPH_IV_16BYTE_DATA 1
+#define QAT_LA_CIPH_IV_FLD_BITPOS 2
+#define QAT_LA_CIPH_IV_FLD_MASK   0x1
+#define ICP_QAT_FW_LA_PARTIAL_NONE 0
+#define ICP_QAT_FW_LA_PARTIAL_START 1
+#define ICP_QAT_FW_LA_PARTIAL_MID 3
+#define ICP_QAT_FW_LA_PARTIAL_END 2
+#define QAT_LA_PARTIAL_BITPOS 0
+#define QAT_LA_PARTIAL_MASK 0x3
+#define ICP_QAT_FW_LA_FLAGS_BUILD(zuc_proto, gcm_iv_len, auth_rslt, proto, \
+	cmp_auth, ret_auth, update_state, \
+	ciph_iv, ciphcfg, partial) \
+	(((zuc_proto & QAT_FW_LA_ZUC_3G_PROTO_FLAG_MASK) << \
+	QAT_FW_LA_ZUC_3G_PROTO_FLAG_BITPOS) | \
+	((gcm_iv_len & QAT_LA_GCM_IV_LEN_FLAG_MASK) << \
+	QAT_LA_GCM_IV_LEN_FLAG_BITPOS) | \
+	((auth_rslt & QAT_LA_DIGEST_IN_BUFFER_MASK) << \
+	QAT_LA_DIGEST_IN_BUFFER_BITPOS) | \
+	((proto & QAT_LA_PROTO_MASK) << \
+	QAT_LA_PROTO_BITPOS)	| \
+	((cmp_auth & QAT_LA_CMP_AUTH_RES_MASK) << \
+	QAT_LA_CMP_AUTH_RES_BITPOS) | \
+	((ret_auth & QAT_LA_RET_AUTH_RES_MASK) << \
+	QAT_LA_RET_AUTH_RES_BITPOS) | \
+	((update_state & QAT_LA_UPDATE_STATE_MASK) << \
+	QAT_LA_UPDATE_STATE_BITPOS) | \
+	((ciph_iv & QAT_LA_CIPH_IV_FLD_MASK) << \
+	QAT_LA_CIPH_IV_FLD_BITPOS) | \
+	((ciphcfg & QAT_LA_CIPH_AUTH_CFG_OFFSET_MASK) << \
+	QAT_LA_CIPH_AUTH_CFG_OFFSET_BITPOS) | \
+	((partial & QAT_LA_PARTIAL_MASK) << \
+	QAT_LA_PARTIAL_BITPOS))
+
+#define ICP_QAT_FW_LA_CIPH_IV_FLD_FLAG_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_LA_CIPH_IV_FLD_BITPOS, \
+	QAT_LA_CIPH_IV_FLD_MASK)
+
+#define ICP_QAT_FW_LA_CIPH_AUTH_CFG_OFFSET_FLAG_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_LA_CIPH_AUTH_CFG_OFFSET_BITPOS, \
+	QAT_LA_CIPH_AUTH_CFG_OFFSET_MASK)
+
+#define ICP_QAT_FW_LA_ZUC_3G_PROTO_FLAG_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_FW_LA_ZUC_3G_PROTO_FLAG_BITPOS, \
+	QAT_FW_LA_ZUC_3G_PROTO_FLAG_MASK)
+
+#define ICP_QAT_FW_LA_GCM_IV_LEN_FLAG_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_LA_GCM_IV_LEN_FLAG_BITPOS, \
+	QAT_LA_GCM_IV_LEN_FLAG_MASK)
+
+#define ICP_QAT_FW_LA_PROTO_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_LA_PROTO_BITPOS, QAT_LA_PROTO_MASK)
+
+#define ICP_QAT_FW_LA_CMP_AUTH_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_LA_CMP_AUTH_RES_BITPOS, \
+	QAT_LA_CMP_AUTH_RES_MASK)
+
+#define ICP_QAT_FW_LA_RET_AUTH_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_LA_RET_AUTH_RES_BITPOS, \
+	QAT_LA_RET_AUTH_RES_MASK)
+
+#define ICP_QAT_FW_LA_DIGEST_IN_BUFFER_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_LA_DIGEST_IN_BUFFER_BITPOS, \
+	QAT_LA_DIGEST_IN_BUFFER_MASK)
+
+#define ICP_QAT_FW_LA_UPDATE_STATE_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_LA_UPDATE_STATE_BITPOS, \
+	QAT_LA_UPDATE_STATE_MASK)
+
+#define ICP_QAT_FW_LA_PARTIAL_GET(flags) \
+	QAT_FIELD_GET(flags, QAT_LA_PARTIAL_BITPOS, \
+	QAT_LA_PARTIAL_MASK)
+
+#define ICP_QAT_FW_LA_CIPH_IV_FLD_FLAG_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_LA_CIPH_IV_FLD_BITPOS, \
+	QAT_LA_CIPH_IV_FLD_MASK)
+
+#define ICP_QAT_FW_LA_CIPH_AUTH_CFG_OFFSET_FLAG_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_LA_CIPH_AUTH_CFG_OFFSET_BITPOS, \
+	QAT_LA_CIPH_AUTH_CFG_OFFSET_MASK)
+
+#define ICP_QAT_FW_LA_ZUC_3G_PROTO_FLAG_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_FW_LA_ZUC_3G_PROTO_FLAG_BITPOS, \
+	QAT_FW_LA_ZUC_3G_PROTO_FLAG_MASK)
+
+#define ICP_QAT_FW_LA_GCM_IV_LEN_FLAG_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_LA_GCM_IV_LEN_FLAG_BITPOS, \
+	QAT_LA_GCM_IV_LEN_FLAG_MASK)
+
+#define ICP_QAT_FW_LA_PROTO_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_LA_PROTO_BITPOS, \
+	QAT_LA_PROTO_MASK)
+
+#define ICP_QAT_FW_LA_CMP_AUTH_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_LA_CMP_AUTH_RES_BITPOS, \
+	QAT_LA_CMP_AUTH_RES_MASK)
+
+#define ICP_QAT_FW_LA_RET_AUTH_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_LA_RET_AUTH_RES_BITPOS, \
+	QAT_LA_RET_AUTH_RES_MASK)
+
+#define ICP_QAT_FW_LA_DIGEST_IN_BUFFER_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_LA_DIGEST_IN_BUFFER_BITPOS, \
+	QAT_LA_DIGEST_IN_BUFFER_MASK)
+
+#define ICP_QAT_FW_LA_UPDATE_STATE_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_LA_UPDATE_STATE_BITPOS, \
+	QAT_LA_UPDATE_STATE_MASK)
+
+#define ICP_QAT_FW_LA_PARTIAL_SET(flags, val) \
+	QAT_FIELD_SET(flags, val, QAT_LA_PARTIAL_BITPOS, \
+	QAT_LA_PARTIAL_MASK)
+
+struct icp_qat_fw_cipher_req_hdr_cd_pars {
+	union {
+		struct {
+			uint64_t content_desc_addr;
+			uint16_t content_desc_resrvd1;
+			uint8_t content_desc_params_sz;
+			uint8_t content_desc_hdr_resrvd2;
+			uint32_t content_desc_resrvd3;
+		} s;
+		struct {
+			uint32_t cipher_key_array[ICP_QAT_FW_NUM_LONGWORDS_4];
+		} s1;
+	} u;
+};
+
+struct icp_qat_fw_cipher_auth_req_hdr_cd_pars {
+	union {
+		struct {
+			uint64_t content_desc_addr;
+			uint16_t content_desc_resrvd1;
+			uint8_t content_desc_params_sz;
+			uint8_t content_desc_hdr_resrvd2;
+			uint32_t content_desc_resrvd3;
+		} s;
+		struct {
+			uint32_t cipher_key_array[ICP_QAT_FW_NUM_LONGWORDS_4];
+		} sl;
+	} u;
+};
+
+struct icp_qat_fw_cipher_cd_ctrl_hdr {
+	uint8_t cipher_state_sz;
+	uint8_t cipher_key_sz;
+	uint8_t cipher_cfg_offset;
+	uint8_t next_curr_id;
+	uint8_t cipher_padding_sz;
+	uint8_t resrvd1;
+	uint16_t resrvd2;
+	uint32_t resrvd3[ICP_QAT_FW_NUM_LONGWORDS_3];
+};
+
+struct icp_qat_fw_auth_cd_ctrl_hdr {
+	uint32_t resrvd1;
+	uint8_t resrvd2;
+	uint8_t hash_flags;
+	uint8_t hash_cfg_offset;
+	uint8_t next_curr_id;
+	uint8_t resrvd3;
+	uint8_t outer_prefix_sz;
+	uint8_t final_sz;
+	uint8_t inner_res_sz;
+	uint8_t resrvd4;
+	uint8_t inner_state1_sz;
+	uint8_t inner_state2_offset;
+	uint8_t inner_state2_sz;
+	uint8_t outer_config_offset;
+	uint8_t outer_state1_sz;
+	uint8_t outer_res_sz;
+	uint8_t outer_prefix_offset;
+};
+
+struct icp_qat_fw_cipher_auth_cd_ctrl_hdr {
+	uint8_t cipher_state_sz;
+	uint8_t cipher_key_sz;
+	uint8_t cipher_cfg_offset;
+	uint8_t next_curr_id_cipher;
+	uint8_t cipher_padding_sz;
+	uint8_t hash_flags;
+	uint8_t hash_cfg_offset;
+	uint8_t next_curr_id_auth;
+	uint8_t resrvd1;
+	uint8_t outer_prefix_sz;
+	uint8_t final_sz;
+	uint8_t inner_res_sz;
+	uint8_t resrvd2;
+	uint8_t inner_state1_sz;
+	uint8_t inner_state2_offset;
+	uint8_t inner_state2_sz;
+	uint8_t outer_config_offset;
+	uint8_t outer_state1_sz;
+	uint8_t outer_res_sz;
+	uint8_t outer_prefix_offset;
+};
+
+#define ICP_QAT_FW_AUTH_HDR_FLAG_DO_NESTED 1
+#define ICP_QAT_FW_AUTH_HDR_FLAG_NO_NESTED 0
+#define ICP_QAT_FW_CCM_GCM_AAD_SZ_MAX	240
+#define ICP_QAT_FW_HASH_REQUEST_PARAMETERS_OFFSET \
+	(sizeof(struct icp_qat_fw_la_cipher_req_params_t))
+#define ICP_QAT_FW_CIPHER_REQUEST_PARAMETERS_OFFSET (0)
+
+struct icp_qat_fw_la_cipher_req_params {
+	uint32_t cipher_offset;
+	uint32_t cipher_length;
+	union {
+		uint32_t cipher_IV_array[ICP_QAT_FW_NUM_LONGWORDS_4];
+		struct {
+			uint64_t cipher_IV_ptr;
+			uint64_t resrvd1;
+		} s;
+	} u;
+};
+
+struct icp_qat_fw_la_auth_req_params {
+	uint32_t auth_off;
+	uint32_t auth_len;
+	union {
+		uint64_t auth_partial_st_prefix;
+		uint64_t aad_adr;
+	} u1;
+	uint64_t auth_res_addr;
+	union {
+		uint8_t inner_prefix_sz;
+		uint8_t aad_sz;
+	} u2;
+	uint8_t resrvd1;
+	uint8_t hash_state_sz;
+	uint8_t auth_res_sz;
+} __packed;
+
+struct icp_qat_fw_la_auth_req_params_resrvd_flds {
+	uint32_t resrvd[ICP_QAT_FW_NUM_LONGWORDS_6];
+	union {
+		uint8_t inner_prefix_sz;
+		uint8_t aad_sz;
+	} u2;
+	uint8_t resrvd1;
+	uint16_t resrvd2;
+};
+
+struct icp_qat_fw_la_resp {
+	struct icp_qat_fw_comn_resp_hdr comn_resp;
+	uint64_t opaque_data;
+	uint32_t resrvd[ICP_QAT_FW_NUM_LONGWORDS_4];
+};
+#define ICP_QAT_FW_CIPHER_NEXT_ID_GET(cd_ctrl_hdr_t) \
+	((((cd_ctrl_hdr_t)->next_curr_id_cipher) & \
+	  ICP_QAT_FW_COMN_NEXT_ID_MASK) >> (ICP_QAT_FW_COMN_NEXT_ID_BITPOS))
+
+#define ICP_QAT_FW_CIPHER_NEXT_ID_SET(cd_ctrl_hdr_t, val) \
+{ (cd_ctrl_hdr_t)->next_curr_id_cipher = \
+	((((cd_ctrl_hdr_t)->next_curr_id_cipher) \
+	& ICP_QAT_FW_COMN_CURR_ID_MASK) | \
+	((val << ICP_QAT_FW_COMN_NEXT_ID_BITPOS) \
+	& ICP_QAT_FW_COMN_NEXT_ID_MASK)) }
+
+#define ICP_QAT_FW_CIPHER_CURR_ID_GET(cd_ctrl_hdr_t) \
+	(((cd_ctrl_hdr_t)->next_curr_id_cipher) \
+	& ICP_QAT_FW_COMN_CURR_ID_MASK)
+
+#define ICP_QAT_FW_CIPHER_CURR_ID_SET(cd_ctrl_hdr_t, val) \
+{ (cd_ctrl_hdr_t)->next_curr_id_cipher = \
+	((((cd_ctrl_hdr_t)->next_curr_id_cipher) \
+	& ICP_QAT_FW_COMN_NEXT_ID_MASK) | \
+	((val) & ICP_QAT_FW_COMN_CURR_ID_MASK)) }
+
+#define ICP_QAT_FW_AUTH_NEXT_ID_GET(cd_ctrl_hdr_t) \
+	((((cd_ctrl_hdr_t)->next_curr_id_auth) & ICP_QAT_FW_COMN_NEXT_ID_MASK) \
+	>> (ICP_QAT_FW_COMN_NEXT_ID_BITPOS))
+
+#define ICP_QAT_FW_AUTH_NEXT_ID_SET(cd_ctrl_hdr_t, val) \
+{ (cd_ctrl_hdr_t)->next_curr_id_auth = \
+	((((cd_ctrl_hdr_t)->next_curr_id_auth) \
+	& ICP_QAT_FW_COMN_CURR_ID_MASK) | \
+	((val << ICP_QAT_FW_COMN_NEXT_ID_BITPOS) \
+	& ICP_QAT_FW_COMN_NEXT_ID_MASK)) }
+
+#define ICP_QAT_FW_AUTH_CURR_ID_GET(cd_ctrl_hdr_t) \
+	(((cd_ctrl_hdr_t)->next_curr_id_auth) \
+	& ICP_QAT_FW_COMN_CURR_ID_MASK)
+
+#define ICP_QAT_FW_AUTH_CURR_ID_SET(cd_ctrl_hdr_t, val) \
+{ (cd_ctrl_hdr_t)->next_curr_id_auth = \
+	((((cd_ctrl_hdr_t)->next_curr_id_auth) \
+	& ICP_QAT_FW_COMN_NEXT_ID_MASK) | \
+	((val) & ICP_QAT_FW_COMN_CURR_ID_MASK)) }
+
+#endif
diff --git a/drivers/crypto/qat/qat_common/icp_qat_hw.h b/drivers/crypto/qat/qat_common/icp_qat_hw.h
new file mode 100644
index 0000000..cc7ec40
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/icp_qat_hw.h
@@ -0,0 +1,305 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef _ICP_QAT_HW_H_
+#define _ICP_QAT_HW_H_
+
+enum icp_qat_hw_ae_id {
+	ICP_QAT_HW_AE_0 = 0,
+	ICP_QAT_HW_AE_1 = 1,
+	ICP_QAT_HW_AE_2 = 2,
+	ICP_QAT_HW_AE_3 = 3,
+	ICP_QAT_HW_AE_4 = 4,
+	ICP_QAT_HW_AE_5 = 5,
+	ICP_QAT_HW_AE_6 = 6,
+	ICP_QAT_HW_AE_7 = 7,
+	ICP_QAT_HW_AE_8 = 8,
+	ICP_QAT_HW_AE_9 = 9,
+	ICP_QAT_HW_AE_10 = 10,
+	ICP_QAT_HW_AE_11 = 11,
+	ICP_QAT_HW_AE_DELIMITER = 12
+};
+
+enum icp_qat_hw_qat_id {
+	ICP_QAT_HW_QAT_0 = 0,
+	ICP_QAT_HW_QAT_1 = 1,
+	ICP_QAT_HW_QAT_2 = 2,
+	ICP_QAT_HW_QAT_3 = 3,
+	ICP_QAT_HW_QAT_4 = 4,
+	ICP_QAT_HW_QAT_5 = 5,
+	ICP_QAT_HW_QAT_DELIMITER = 6
+};
+
+enum icp_qat_hw_auth_algo {
+	ICP_QAT_HW_AUTH_ALGO_NULL = 0,
+	ICP_QAT_HW_AUTH_ALGO_SHA1 = 1,
+	ICP_QAT_HW_AUTH_ALGO_MD5 = 2,
+	ICP_QAT_HW_AUTH_ALGO_SHA224 = 3,
+	ICP_QAT_HW_AUTH_ALGO_SHA256 = 4,
+	ICP_QAT_HW_AUTH_ALGO_SHA384 = 5,
+	ICP_QAT_HW_AUTH_ALGO_SHA512 = 6,
+	ICP_QAT_HW_AUTH_ALGO_AES_XCBC_MAC = 7,
+	ICP_QAT_HW_AUTH_ALGO_AES_CBC_MAC = 8,
+	ICP_QAT_HW_AUTH_ALGO_AES_F9 = 9,
+	ICP_QAT_HW_AUTH_ALGO_GALOIS_128 = 10,
+	ICP_QAT_HW_AUTH_ALGO_GALOIS_64 = 11,
+	ICP_QAT_HW_AUTH_ALGO_KASUMI_F9 = 12,
+	ICP_QAT_HW_AUTH_ALGO_SNOW_3G_UIA2 = 13,
+	ICP_QAT_HW_AUTH_ALGO_ZUC_3G_128_EIA3 = 14,
+	ICP_QAT_HW_AUTH_RESERVED_1 = 15,
+	ICP_QAT_HW_AUTH_RESERVED_2 = 16,
+	ICP_QAT_HW_AUTH_ALGO_SHA3_256 = 17,
+	ICP_QAT_HW_AUTH_RESERVED_3 = 18,
+	ICP_QAT_HW_AUTH_ALGO_SHA3_512 = 19,
+	ICP_QAT_HW_AUTH_ALGO_DELIMITER = 20
+};
+
+enum icp_qat_hw_auth_mode {
+	ICP_QAT_HW_AUTH_MODE0 = 0,
+	ICP_QAT_HW_AUTH_MODE1 = 1,
+	ICP_QAT_HW_AUTH_MODE2 = 2,
+	ICP_QAT_HW_AUTH_MODE_DELIMITER = 3
+};
+
+struct icp_qat_hw_auth_config {
+	uint32_t config;
+	uint32_t reserved;
+};
+
+#define QAT_AUTH_MODE_BITPOS 4
+#define QAT_AUTH_MODE_MASK 0xF
+#define QAT_AUTH_ALGO_BITPOS 0
+#define QAT_AUTH_ALGO_MASK 0xF
+#define QAT_AUTH_CMP_BITPOS 8
+#define QAT_AUTH_CMP_MASK 0x7F
+#define QAT_AUTH_SHA3_PADDING_BITPOS 16
+#define QAT_AUTH_SHA3_PADDING_MASK 0x1
+#define QAT_AUTH_ALGO_SHA3_BITPOS 22
+#define QAT_AUTH_ALGO_SHA3_MASK 0x3
+#define ICP_QAT_HW_AUTH_CONFIG_BUILD(mode, algo, cmp_len) \
+	((((mode) & QAT_AUTH_MODE_MASK) << QAT_AUTH_MODE_BITPOS) | \
+	(((algo) & QAT_AUTH_ALGO_MASK) << QAT_AUTH_ALGO_BITPOS) | \
+	(((algo >> 4) & QAT_AUTH_ALGO_SHA3_MASK) << \
+	 QAT_AUTH_ALGO_SHA3_BITPOS) | \
+	 (((((algo == ICP_QAT_HW_AUTH_ALGO_SHA3_256) || \
+	(algo == ICP_QAT_HW_AUTH_ALGO_SHA3_512)) ? 1 : 0) \
+	& QAT_AUTH_SHA3_PADDING_MASK) << QAT_AUTH_SHA3_PADDING_BITPOS) | \
+	(((cmp_len) & QAT_AUTH_CMP_MASK) << QAT_AUTH_CMP_BITPOS))
+
+struct icp_qat_hw_auth_counter {
+	__be32 counter;
+	uint32_t reserved;
+};
+
+#define QAT_AUTH_COUNT_MASK 0xFFFFFFFF
+#define QAT_AUTH_COUNT_BITPOS 0
+#define ICP_QAT_HW_AUTH_COUNT_BUILD(val) \
+	(((val) & QAT_AUTH_COUNT_MASK) << QAT_AUTH_COUNT_BITPOS)
+
+struct icp_qat_hw_auth_setup {
+	struct icp_qat_hw_auth_config auth_config;
+	struct icp_qat_hw_auth_counter auth_counter;
+};
+
+#define QAT_HW_DEFAULT_ALIGNMENT 8
+#define QAT_HW_ROUND_UP(val, n) (((val) + ((n)-1)) & (~(n-1)))
+#define ICP_QAT_HW_NULL_STATE1_SZ 32
+#define ICP_QAT_HW_MD5_STATE1_SZ 16
+#define ICP_QAT_HW_SHA1_STATE1_SZ 20
+#define ICP_QAT_HW_SHA224_STATE1_SZ 32
+#define ICP_QAT_HW_SHA256_STATE1_SZ 32
+#define ICP_QAT_HW_SHA3_256_STATE1_SZ 32
+#define ICP_QAT_HW_SHA384_STATE1_SZ 64
+#define ICP_QAT_HW_SHA512_STATE1_SZ 64
+#define ICP_QAT_HW_SHA3_512_STATE1_SZ 64
+#define ICP_QAT_HW_SHA3_224_STATE1_SZ 28
+#define ICP_QAT_HW_SHA3_384_STATE1_SZ 48
+#define ICP_QAT_HW_AES_XCBC_MAC_STATE1_SZ 16
+#define ICP_QAT_HW_AES_CBC_MAC_STATE1_SZ 16
+#define ICP_QAT_HW_AES_F9_STATE1_SZ 32
+#define ICP_QAT_HW_KASUMI_F9_STATE1_SZ 16
+#define ICP_QAT_HW_GALOIS_128_STATE1_SZ 16
+#define ICP_QAT_HW_SNOW_3G_UIA2_STATE1_SZ 8
+#define ICP_QAT_HW_ZUC_3G_EIA3_STATE1_SZ 8
+#define ICP_QAT_HW_NULL_STATE2_SZ 32
+#define ICP_QAT_HW_MD5_STATE2_SZ 16
+#define ICP_QAT_HW_SHA1_STATE2_SZ 20
+#define ICP_QAT_HW_SHA224_STATE2_SZ 32
+#define ICP_QAT_HW_SHA256_STATE2_SZ 32
+#define ICP_QAT_HW_SHA3_256_STATE2_SZ 0
+#define ICP_QAT_HW_SHA384_STATE2_SZ 64
+#define ICP_QAT_HW_SHA512_STATE2_SZ 64
+#define ICP_QAT_HW_SHA3_512_STATE2_SZ 0
+#define ICP_QAT_HW_SHA3_224_STATE2_SZ 0
+#define ICP_QAT_HW_SHA3_384_STATE2_SZ 0
+#define ICP_QAT_HW_AES_XCBC_MAC_KEY_SZ 16
+#define ICP_QAT_HW_AES_CBC_MAC_KEY_SZ 16
+#define ICP_QAT_HW_AES_CCM_CBC_E_CTR0_SZ 16
+#define ICP_QAT_HW_F9_IK_SZ 16
+#define ICP_QAT_HW_F9_FK_SZ 16
+#define ICP_QAT_HW_KASUMI_F9_STATE2_SZ (ICP_QAT_HW_F9_IK_SZ + \
+	ICP_QAT_HW_F9_FK_SZ)
+#define ICP_QAT_HW_AES_F9_STATE2_SZ ICP_QAT_HW_KASUMI_F9_STATE2_SZ
+#define ICP_QAT_HW_SNOW_3G_UIA2_STATE2_SZ 24
+#define ICP_QAT_HW_ZUC_3G_EIA3_STATE2_SZ 32
+#define ICP_QAT_HW_GALOIS_H_SZ 16
+#define ICP_QAT_HW_GALOIS_LEN_A_SZ 8
+#define ICP_QAT_HW_GALOIS_E_CTR0_SZ 16
+
+struct icp_qat_hw_auth_sha512 {
+	struct icp_qat_hw_auth_setup inner_setup;
+	uint8_t state1[ICP_QAT_HW_SHA512_STATE1_SZ];
+	struct icp_qat_hw_auth_setup outer_setup;
+	uint8_t state2[ICP_QAT_HW_SHA512_STATE2_SZ];
+};
+
+struct icp_qat_hw_auth_algo_blk {
+	struct icp_qat_hw_auth_sha512 sha;
+};
+
+#define ICP_QAT_HW_GALOIS_LEN_A_BITPOS 0
+#define ICP_QAT_HW_GALOIS_LEN_A_MASK 0xFFFFFFFF
+
+enum icp_qat_hw_cipher_algo {
+	ICP_QAT_HW_CIPHER_ALGO_NULL = 0,
+	ICP_QAT_HW_CIPHER_ALGO_DES = 1,
+	ICP_QAT_HW_CIPHER_ALGO_3DES = 2,
+	ICP_QAT_HW_CIPHER_ALGO_AES128 = 3,
+	ICP_QAT_HW_CIPHER_ALGO_AES192 = 4,
+	ICP_QAT_HW_CIPHER_ALGO_AES256 = 5,
+	ICP_QAT_HW_CIPHER_ALGO_ARC4 = 6,
+	ICP_QAT_HW_CIPHER_ALGO_KASUMI = 7,
+	ICP_QAT_HW_CIPHER_ALGO_SNOW_3G_UEA2 = 8,
+	ICP_QAT_HW_CIPHER_ALGO_ZUC_3G_128_EEA3 = 9,
+	ICP_QAT_HW_CIPHER_DELIMITER = 10
+};
+
+enum icp_qat_hw_cipher_mode {
+	ICP_QAT_HW_CIPHER_ECB_MODE = 0,
+	ICP_QAT_HW_CIPHER_CBC_MODE = 1,
+	ICP_QAT_HW_CIPHER_CTR_MODE = 2,
+	ICP_QAT_HW_CIPHER_F8_MODE = 3,
+	ICP_QAT_HW_CIPHER_XTS_MODE = 6,
+	ICP_QAT_HW_CIPHER_MODE_DELIMITER = 7
+};
+
+struct icp_qat_hw_cipher_config {
+	uint32_t val;
+	uint32_t reserved;
+};
+
+enum icp_qat_hw_cipher_dir {
+	ICP_QAT_HW_CIPHER_ENCRYPT = 0,
+	ICP_QAT_HW_CIPHER_DECRYPT = 1,
+};
+
+enum icp_qat_hw_cipher_convert {
+	ICP_QAT_HW_CIPHER_NO_CONVERT = 0,
+	ICP_QAT_HW_CIPHER_KEY_CONVERT = 1,
+};
+
+#define QAT_CIPHER_MODE_BITPOS 4
+#define QAT_CIPHER_MODE_MASK 0xF
+#define QAT_CIPHER_ALGO_BITPOS 0
+#define QAT_CIPHER_ALGO_MASK 0xF
+#define QAT_CIPHER_CONVERT_BITPOS 9
+#define QAT_CIPHER_CONVERT_MASK 0x1
+#define QAT_CIPHER_DIR_BITPOS 8
+#define QAT_CIPHER_DIR_MASK 0x1
+#define QAT_CIPHER_MODE_F8_KEY_SZ_MULT 2
+#define QAT_CIPHER_MODE_XTS_KEY_SZ_MULT 2
+#define ICP_QAT_HW_CIPHER_CONFIG_BUILD(mode, algo, convert, dir) \
+	(((mode & QAT_CIPHER_MODE_MASK) << QAT_CIPHER_MODE_BITPOS) | \
+	((algo & QAT_CIPHER_ALGO_MASK) << QAT_CIPHER_ALGO_BITPOS) | \
+	((convert & QAT_CIPHER_CONVERT_MASK) << QAT_CIPHER_CONVERT_BITPOS) | \
+	((dir & QAT_CIPHER_DIR_MASK) << QAT_CIPHER_DIR_BITPOS))
+#define ICP_QAT_HW_DES_BLK_SZ 8
+#define ICP_QAT_HW_3DES_BLK_SZ 8
+#define ICP_QAT_HW_NULL_BLK_SZ 8
+#define ICP_QAT_HW_AES_BLK_SZ 16
+#define ICP_QAT_HW_KASUMI_BLK_SZ 8
+#define ICP_QAT_HW_SNOW_3G_BLK_SZ 8
+#define ICP_QAT_HW_ZUC_3G_BLK_SZ 8
+#define ICP_QAT_HW_NULL_KEY_SZ 256
+#define ICP_QAT_HW_DES_KEY_SZ 8
+#define ICP_QAT_HW_3DES_KEY_SZ 24
+#define ICP_QAT_HW_AES_128_KEY_SZ 16
+#define ICP_QAT_HW_AES_192_KEY_SZ 24
+#define ICP_QAT_HW_AES_256_KEY_SZ 32
+#define ICP_QAT_HW_AES_128_F8_KEY_SZ (ICP_QAT_HW_AES_128_KEY_SZ * \
+	QAT_CIPHER_MODE_F8_KEY_SZ_MULT)
+#define ICP_QAT_HW_AES_192_F8_KEY_SZ (ICP_QAT_HW_AES_192_KEY_SZ * \
+	QAT_CIPHER_MODE_F8_KEY_SZ_MULT)
+#define ICP_QAT_HW_AES_256_F8_KEY_SZ (ICP_QAT_HW_AES_256_KEY_SZ * \
+	QAT_CIPHER_MODE_F8_KEY_SZ_MULT)
+#define ICP_QAT_HW_AES_128_XTS_KEY_SZ (ICP_QAT_HW_AES_128_KEY_SZ * \
+	QAT_CIPHER_MODE_XTS_KEY_SZ_MULT)
+#define ICP_QAT_HW_AES_256_XTS_KEY_SZ (ICP_QAT_HW_AES_256_KEY_SZ * \
+	QAT_CIPHER_MODE_XTS_KEY_SZ_MULT)
+#define ICP_QAT_HW_KASUMI_KEY_SZ 16
+#define ICP_QAT_HW_KASUMI_F8_KEY_SZ (ICP_QAT_HW_KASUMI_KEY_SZ * \
+	QAT_CIPHER_MODE_F8_KEY_SZ_MULT)
+#define ICP_QAT_HW_AES_128_XTS_KEY_SZ (ICP_QAT_HW_AES_128_KEY_SZ * \
+	QAT_CIPHER_MODE_XTS_KEY_SZ_MULT)
+#define ICP_QAT_HW_AES_256_XTS_KEY_SZ (ICP_QAT_HW_AES_256_KEY_SZ * \
+	QAT_CIPHER_MODE_XTS_KEY_SZ_MULT)
+#define ICP_QAT_HW_ARC4_KEY_SZ 256
+#define ICP_QAT_HW_SNOW_3G_UEA2_KEY_SZ 16
+#define ICP_QAT_HW_SNOW_3G_UEA2_IV_SZ 16
+#define ICP_QAT_HW_ZUC_3G_EEA3_KEY_SZ 16
+#define ICP_QAT_HW_ZUC_3G_EEA3_IV_SZ 16
+#define ICP_QAT_HW_MODE_F8_NUM_REG_TO_CLEAR 2
+#define INIT_SHRAM_CONSTANTS_TABLE_SZ 1024
+
+struct icp_qat_hw_cipher_aes256_f8 {
+	struct icp_qat_hw_cipher_config cipher_config;
+	uint8_t key[ICP_QAT_HW_AES_256_F8_KEY_SZ];
+};
+
+struct icp_qat_hw_cipher_algo_blk {
+	struct icp_qat_hw_cipher_aes256_f8 aes;
+};
+#endif
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
new file mode 100644
index 0000000..2779e5e
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -0,0 +1,1033 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/crypto.h>
+#include <crypto/aead.h>
+#include <crypto/aes.h>
+#include <crypto/sha.h>
+#include <crypto/hash.h>
+#include <crypto/algapi.h>
+#include <crypto/authenc.h>
+#include <crypto/rng.h>
+#include <linux/dma-mapping.h>
+#include "adf_accel_devices.h"
+#include "adf_transport.h"
+#include "adf_common_drv.h"
+#include "qat_crypto.h"
+#include "icp_qat_hw.h"
+#include "icp_qat_fw.h"
+#include "icp_qat_fw_la.h"
+
+#define QAT_AES_HW_CONFIG_ENC(alg) \
+	ICP_QAT_HW_CIPHER_CONFIG_BUILD(ICP_QAT_HW_CIPHER_CBC_MODE, alg, \
+			ICP_QAT_HW_CIPHER_NO_CONVERT, \
+			ICP_QAT_HW_CIPHER_ENCRYPT)
+
+#define QAT_AES_HW_CONFIG_DEC(alg) \
+	ICP_QAT_HW_CIPHER_CONFIG_BUILD(ICP_QAT_HW_CIPHER_CBC_MODE, alg, \
+			ICP_QAT_HW_CIPHER_KEY_CONVERT, \
+			ICP_QAT_HW_CIPHER_DECRYPT)
+
+static atomic_t active_dev;
+
+struct qat_alg_buf {
+	uint32_t len;
+	uint32_t resrvd;
+	uint64_t addr;
+} __packed;
+
+struct qat_alg_buf_list {
+	uint64_t resrvd;
+	uint32_t num_bufs;
+	uint32_t num_mapped_bufs;
+	struct qat_alg_buf bufers[];
+} __packed __aligned(64);
+
+/* Common content descriptor */
+struct qat_alg_cd {
+	union {
+		struct qat_enc { /* Encrypt content desc */
+			struct icp_qat_hw_cipher_algo_blk cipher;
+			struct icp_qat_hw_auth_algo_blk hash;
+		} qat_enc_cd;
+		struct qat_dec { /* Decrytp content desc */
+			struct icp_qat_hw_auth_algo_blk hash;
+			struct icp_qat_hw_cipher_algo_blk cipher;
+		} qat_dec_cd;
+	};
+} __aligned(64);
+
+#define MAX_AUTH_STATE_SIZE sizeof(struct icp_qat_hw_auth_algo_blk)
+
+struct qat_auth_state {
+	uint8_t data[MAX_AUTH_STATE_SIZE];
+} __aligned(64);
+
+struct qat_alg_session_ctx {
+	struct qat_alg_cd *enc_cd;
+	dma_addr_t enc_cd_paddr;
+	struct qat_alg_cd *dec_cd;
+	dma_addr_t dec_cd_paddr;
+	struct qat_auth_state *auth_hw_state_enc;
+	dma_addr_t auth_state_enc_paddr;
+	struct qat_auth_state *auth_hw_state_dec;
+	dma_addr_t auth_state_dec_paddr;
+	struct icp_qat_fw_la_bulk_req enc_fw_req_tmpl;
+	struct icp_qat_fw_la_bulk_req dec_fw_req_tmpl;
+	struct qat_crypto_instance *inst;
+	struct crypto_tfm *tfm;
+	struct crypto_shash *hash_tfm;
+	enum icp_qat_hw_auth_algo qat_hash_alg;
+	uint8_t salt[AES_BLOCK_SIZE];
+	spinlock_t lock;	/* protects qat_alg_session_ctx struct */
+};
+
+static int get_current_node(void)
+{
+	return cpu_data(current_thread_info()->cpu).phys_proc_id;
+}
+
+static int qat_get_inter_state_size(enum icp_qat_hw_auth_algo qat_hash_alg)
+{
+	switch (qat_hash_alg) {
+	case ICP_QAT_HW_AUTH_ALGO_SHA1:
+		return ICP_QAT_HW_SHA1_STATE1_SZ;
+	case ICP_QAT_HW_AUTH_ALGO_SHA256:
+		return ICP_QAT_HW_SHA256_STATE1_SZ;
+	case ICP_QAT_HW_AUTH_ALGO_SHA512:
+		return ICP_QAT_HW_SHA512_STATE1_SZ;
+	default:
+		return -EFAULT;
+	};
+	return -EFAULT;
+}
+
+static int qat_alg_do_precomputes(struct icp_qat_hw_auth_algo_blk *hash,
+				  struct qat_alg_session_ctx *ctx,
+				  const uint8_t *auth_key,
+				  unsigned int auth_keylen, uint8_t *auth_state)
+{
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(ctx->hash_tfm)];
+	} desc;
+	struct sha1_state sha1;
+	struct sha256_state sha256;
+	struct sha512_state sha512;
+	int block_size = crypto_shash_blocksize(ctx->hash_tfm);
+	int digest_size = crypto_shash_digestsize(ctx->hash_tfm);
+	uint8_t *ipad = auth_state;
+	uint8_t *opad = ipad + block_size;
+	__be32 *hash_state_out;
+	__be64 *hash512_state_out;
+	int i, offset;
+
+	desc.shash.tfm = ctx->hash_tfm;
+	desc.shash.flags = 0x0;
+
+	if (auth_keylen > block_size) {
+		char buff[SHA512_BLOCK_SIZE];
+		int ret = crypto_shash_digest(&desc.shash, auth_key,
+					      auth_keylen, buff);
+		if (ret)
+			return ret;
+
+		memcpy(ipad, buff, digest_size);
+		memcpy(opad, buff, digest_size);
+		memset(ipad + digest_size, 0, block_size - digest_size);
+		memset(opad + digest_size, 0, block_size - digest_size);
+	} else {
+		memcpy(ipad, auth_key, auth_keylen);
+		memcpy(opad, auth_key, auth_keylen);
+		memset(ipad + auth_keylen, 0, block_size - auth_keylen);
+		memset(opad + auth_keylen, 0, block_size - auth_keylen);
+	}
+
+	for (i = 0; i < block_size; i++) {
+		char *ipad_ptr = ipad + i;
+		char *opad_ptr = opad + i;
+		*ipad_ptr ^= 0x36;
+		*opad_ptr ^= 0x5C;
+	}
+
+	if (crypto_shash_init(&desc.shash))
+		return -EFAULT;
+
+	if (crypto_shash_update(&desc.shash, ipad, block_size))
+		return -EFAULT;
+
+	hash_state_out = (__be32 *)hash->sha.state1;
+	hash512_state_out = (__be64 *)hash_state_out;
+
+	switch (ctx->qat_hash_alg) {
+	case ICP_QAT_HW_AUTH_ALGO_SHA1:
+		if (crypto_shash_export(&desc.shash, &sha1))
+			return -EFAULT;
+		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
+			*hash_state_out = cpu_to_be32(*(sha1.state + i));
+		break;
+	case ICP_QAT_HW_AUTH_ALGO_SHA256:
+		if (crypto_shash_export(&desc.shash, &sha256))
+			return -EFAULT;
+		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
+			*hash_state_out = cpu_to_be32(*(sha256.state + i));
+		break;
+	case ICP_QAT_HW_AUTH_ALGO_SHA512:
+		if (crypto_shash_export(&desc.shash, &sha512))
+			return -EFAULT;
+		for (i = 0; i < digest_size >> 3; i++, hash512_state_out++)
+			*hash512_state_out = cpu_to_be64(*(sha512.state + i));
+		break;
+	default:
+		return -EFAULT;
+	}
+
+	if (crypto_shash_init(&desc.shash))
+		return -EFAULT;
+
+	if (crypto_shash_update(&desc.shash, opad, block_size))
+		return -EFAULT;
+
+	offset = round_up(qat_get_inter_state_size(ctx->qat_hash_alg), 8);
+	hash_state_out = (__be32 *)(hash->sha.state1 + offset);
+	hash512_state_out = (__be64 *)hash_state_out;
+
+	switch (ctx->qat_hash_alg) {
+	case ICP_QAT_HW_AUTH_ALGO_SHA1:
+		if (crypto_shash_export(&desc.shash, &sha1))
+			return -EFAULT;
+		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
+			*hash_state_out = cpu_to_be32(*(sha1.state + i));
+		break;
+	case ICP_QAT_HW_AUTH_ALGO_SHA256:
+		if (crypto_shash_export(&desc.shash, &sha256))
+			return -EFAULT;
+		for (i = 0; i < digest_size >> 2; i++, hash_state_out++)
+			*hash_state_out = cpu_to_be32(*(sha256.state + i));
+		break;
+	case ICP_QAT_HW_AUTH_ALGO_SHA512:
+		if (crypto_shash_export(&desc.shash, &sha512))
+			return -EFAULT;
+		for (i = 0; i < digest_size >> 3; i++, hash512_state_out++)
+			*hash512_state_out = cpu_to_be64(*(sha512.state + i));
+		break;
+	default:
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static void qat_alg_init_common_hdr(struct icp_qat_fw_comn_req_hdr *header)
+{
+	header->hdr_flags =
+		ICP_QAT_FW_COMN_HDR_FLAGS_BUILD(ICP_QAT_FW_COMN_REQ_FLAG_SET);
+	header->service_type = ICP_QAT_FW_COMN_REQ_CPM_FW_LA;
+	header->comn_req_flags =
+		ICP_QAT_FW_COMN_FLAGS_BUILD(QAT_COMN_CD_FLD_TYPE_64BIT_ADR,
+					    QAT_COMN_PTR_TYPE_SGL);
+	ICP_QAT_FW_LA_DIGEST_IN_BUFFER_SET(header->serv_specif_flags,
+					   ICP_QAT_FW_LA_DIGEST_IN_BUFFER);
+	ICP_QAT_FW_LA_PARTIAL_SET(header->serv_specif_flags,
+				  ICP_QAT_FW_LA_PARTIAL_NONE);
+	ICP_QAT_FW_LA_CIPH_IV_FLD_FLAG_SET(header->serv_specif_flags,
+					   ICP_QAT_FW_CIPH_IV_16BYTE_DATA);
+	ICP_QAT_FW_LA_PROTO_SET(header->serv_specif_flags,
+				ICP_QAT_FW_LA_NO_PROTO);
+	ICP_QAT_FW_LA_UPDATE_STATE_SET(header->serv_specif_flags,
+				       ICP_QAT_FW_LA_NO_UPDATE_STATE);
+}
+
+static int qat_alg_init_enc_session(struct qat_alg_session_ctx *ctx,
+				    int alg, struct crypto_authenc_keys *keys)
+{
+	struct crypto_aead *aead_tfm = __crypto_aead_cast(ctx->tfm);
+	unsigned int digestsize = crypto_aead_crt(aead_tfm)->authsize;
+	struct qat_enc *enc_ctx = &ctx->enc_cd->qat_enc_cd;
+	struct icp_qat_hw_cipher_algo_blk *cipher = &enc_ctx->cipher;
+	struct icp_qat_hw_auth_algo_blk *hash =
+		(struct icp_qat_hw_auth_algo_blk *)((char *)enc_ctx +
+		sizeof(struct icp_qat_hw_auth_setup) + keys->enckeylen);
+	struct icp_qat_fw_la_bulk_req *req_tmpl = &ctx->enc_fw_req_tmpl;
+	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req_tmpl->cd_pars;
+	struct icp_qat_fw_comn_req_hdr *header = &req_tmpl->comn_hdr;
+	void *ptr = &req_tmpl->cd_ctrl;
+	struct icp_qat_fw_cipher_cd_ctrl_hdr *cipher_cd_ctrl = ptr;
+	struct icp_qat_fw_auth_cd_ctrl_hdr *hash_cd_ctrl = ptr;
+	struct icp_qat_fw_la_auth_req_params *auth_param =
+		(struct icp_qat_fw_la_auth_req_params *)
+		((char *)&req_tmpl->serv_specif_rqpars +
+		 sizeof(struct icp_qat_fw_la_cipher_req_params));
+
+	/* CD setup */
+	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_ENC(alg);
+	memcpy(cipher->aes.key, keys->enckey, keys->enckeylen);
+	hash->sha.inner_setup.auth_config.config =
+		ICP_QAT_HW_AUTH_CONFIG_BUILD(ICP_QAT_HW_AUTH_MODE1,
+					     ctx->qat_hash_alg, digestsize);
+	hash->sha.inner_setup.auth_counter.counter =
+		cpu_to_be32(crypto_shash_blocksize(ctx->hash_tfm));
+
+	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen,
+				   (uint8_t *)ctx->auth_hw_state_enc))
+		return -EFAULT;
+
+	/* Request setup */
+	qat_alg_init_common_hdr(header);
+	header->service_cmd_id = ICP_QAT_FW_LA_CMD_CIPHER_HASH;
+	ICP_QAT_FW_LA_RET_AUTH_SET(header->serv_specif_flags,
+				   ICP_QAT_FW_LA_RET_AUTH_RES);
+	ICP_QAT_FW_LA_CMP_AUTH_SET(header->serv_specif_flags,
+				   ICP_QAT_FW_LA_NO_CMP_AUTH_RES);
+	cd_pars->u.s.content_desc_addr = ctx->enc_cd_paddr;
+	cd_pars->u.s.content_desc_params_sz = sizeof(struct qat_alg_cd) >> 3;
+
+	/* Cipher CD config setup */
+	cipher_cd_ctrl->cipher_key_sz = keys->enckeylen >> 3;
+	cipher_cd_ctrl->cipher_state_sz = AES_BLOCK_SIZE >> 3;
+	cipher_cd_ctrl->cipher_cfg_offset = 0;
+	ICP_QAT_FW_COMN_CURR_ID_SET(cipher_cd_ctrl, ICP_QAT_FW_SLICE_CIPHER);
+	ICP_QAT_FW_COMN_NEXT_ID_SET(cipher_cd_ctrl, ICP_QAT_FW_SLICE_AUTH);
+	/* Auth CD config setup */
+	hash_cd_ctrl->hash_cfg_offset = ((char *)hash - (char *)cipher) >> 3;
+	hash_cd_ctrl->hash_flags = ICP_QAT_FW_AUTH_HDR_FLAG_NO_NESTED;
+	hash_cd_ctrl->inner_res_sz = digestsize;
+	hash_cd_ctrl->final_sz = digestsize;
+
+	switch (ctx->qat_hash_alg) {
+	case ICP_QAT_HW_AUTH_ALGO_SHA1:
+		hash_cd_ctrl->inner_state1_sz =
+			round_up(ICP_QAT_HW_SHA1_STATE1_SZ, 8);
+		hash_cd_ctrl->inner_state2_sz =
+			round_up(ICP_QAT_HW_SHA1_STATE2_SZ, 8);
+		break;
+	case ICP_QAT_HW_AUTH_ALGO_SHA256:
+		hash_cd_ctrl->inner_state1_sz = ICP_QAT_HW_SHA256_STATE1_SZ;
+		hash_cd_ctrl->inner_state2_sz = ICP_QAT_HW_SHA256_STATE2_SZ;
+		break;
+	case ICP_QAT_HW_AUTH_ALGO_SHA512:
+		hash_cd_ctrl->inner_state1_sz = ICP_QAT_HW_SHA512_STATE1_SZ;
+		hash_cd_ctrl->inner_state2_sz = ICP_QAT_HW_SHA512_STATE2_SZ;
+		break;
+	default:
+		break;
+	}
+	hash_cd_ctrl->inner_state2_offset = hash_cd_ctrl->hash_cfg_offset +
+			((sizeof(struct icp_qat_hw_auth_setup) +
+			 round_up(hash_cd_ctrl->inner_state1_sz, 8)) >> 3);
+	auth_param->u1.auth_partial_st_prefix = ctx->auth_state_enc_paddr +
+			sizeof(struct icp_qat_hw_auth_counter) +
+			round_up(hash_cd_ctrl->inner_state1_sz, 8);
+	ICP_QAT_FW_COMN_CURR_ID_SET(hash_cd_ctrl, ICP_QAT_FW_SLICE_AUTH);
+	ICP_QAT_FW_COMN_NEXT_ID_SET(hash_cd_ctrl, ICP_QAT_FW_SLICE_DRAM_WR);
+	return 0;
+}
+
+static int qat_alg_init_dec_session(struct qat_alg_session_ctx *ctx,
+				    int alg, struct crypto_authenc_keys *keys)
+{
+	struct crypto_aead *aead_tfm = __crypto_aead_cast(ctx->tfm);
+	unsigned int digestsize = crypto_aead_crt(aead_tfm)->authsize;
+	struct qat_dec *dec_ctx = &ctx->dec_cd->qat_dec_cd;
+	struct icp_qat_hw_auth_algo_blk *hash = &dec_ctx->hash;
+	struct icp_qat_hw_cipher_algo_blk *cipher =
+		(struct icp_qat_hw_cipher_algo_blk *)((char *)dec_ctx +
+		sizeof(struct icp_qat_hw_auth_setup) +
+		roundup(crypto_shash_digestsize(ctx->hash_tfm), 8) * 2);
+	struct icp_qat_fw_la_bulk_req *req_tmpl = &ctx->dec_fw_req_tmpl;
+	struct icp_qat_fw_comn_req_hdr_cd_pars *cd_pars = &req_tmpl->cd_pars;
+	struct icp_qat_fw_comn_req_hdr *header = &req_tmpl->comn_hdr;
+	void *ptr = &req_tmpl->cd_ctrl;
+	struct icp_qat_fw_cipher_cd_ctrl_hdr *cipher_cd_ctrl = ptr;
+	struct icp_qat_fw_auth_cd_ctrl_hdr *hash_cd_ctrl = ptr;
+	struct icp_qat_fw_la_auth_req_params *auth_param =
+		(struct icp_qat_fw_la_auth_req_params *)
+		((char *)&req_tmpl->serv_specif_rqpars +
+		sizeof(struct icp_qat_fw_la_cipher_req_params));
+
+	/* CD setup */
+	cipher->aes.cipher_config.val = QAT_AES_HW_CONFIG_DEC(alg);
+	memcpy(cipher->aes.key, keys->enckey, keys->enckeylen);
+	hash->sha.inner_setup.auth_config.config =
+		ICP_QAT_HW_AUTH_CONFIG_BUILD(ICP_QAT_HW_AUTH_MODE1,
+					     ctx->qat_hash_alg,
+					     digestsize);
+	hash->sha.inner_setup.auth_counter.counter =
+		cpu_to_be32(crypto_shash_blocksize(ctx->hash_tfm));
+
+	if (qat_alg_do_precomputes(hash, ctx, keys->authkey, keys->authkeylen,
+				   (uint8_t *)ctx->auth_hw_state_dec))
+		return -EFAULT;
+
+	/* Request setup */
+	qat_alg_init_common_hdr(header);
+	header->service_cmd_id = ICP_QAT_FW_LA_CMD_HASH_CIPHER;
+	ICP_QAT_FW_LA_RET_AUTH_SET(header->serv_specif_flags,
+				   ICP_QAT_FW_LA_NO_RET_AUTH_RES);
+	ICP_QAT_FW_LA_CMP_AUTH_SET(header->serv_specif_flags,
+				   ICP_QAT_FW_LA_CMP_AUTH_RES);
+	cd_pars->u.s.content_desc_addr = ctx->dec_cd_paddr;
+	cd_pars->u.s.content_desc_params_sz = sizeof(struct qat_alg_cd) >> 3;
+
+	/* Cipher CD config setup */
+	cipher_cd_ctrl->cipher_key_sz = keys->enckeylen >> 3;
+	cipher_cd_ctrl->cipher_state_sz = AES_BLOCK_SIZE >> 3;
+	cipher_cd_ctrl->cipher_cfg_offset =
+		(sizeof(struct icp_qat_hw_auth_setup) +
+		 roundup(crypto_shash_digestsize(ctx->hash_tfm), 8) * 2) >> 3;
+	ICP_QAT_FW_COMN_CURR_ID_SET(cipher_cd_ctrl, ICP_QAT_FW_SLICE_CIPHER);
+	ICP_QAT_FW_COMN_NEXT_ID_SET(cipher_cd_ctrl, ICP_QAT_FW_SLICE_DRAM_WR);
+
+	/* Auth CD config setup */
+	hash_cd_ctrl->hash_cfg_offset = 0;
+	hash_cd_ctrl->hash_flags = ICP_QAT_FW_AUTH_HDR_FLAG_NO_NESTED;
+	hash_cd_ctrl->inner_res_sz = digestsize;
+	hash_cd_ctrl->final_sz = digestsize;
+
+	switch (ctx->qat_hash_alg) {
+	case ICP_QAT_HW_AUTH_ALGO_SHA1:
+		hash_cd_ctrl->inner_state1_sz =
+			round_up(ICP_QAT_HW_SHA1_STATE1_SZ, 8);
+		hash_cd_ctrl->inner_state2_sz =
+			round_up(ICP_QAT_HW_SHA1_STATE2_SZ, 8);
+		break;
+	case ICP_QAT_HW_AUTH_ALGO_SHA256:
+		hash_cd_ctrl->inner_state1_sz = ICP_QAT_HW_SHA256_STATE1_SZ;
+		hash_cd_ctrl->inner_state2_sz = ICP_QAT_HW_SHA256_STATE2_SZ;
+		break;
+	case ICP_QAT_HW_AUTH_ALGO_SHA512:
+		hash_cd_ctrl->inner_state1_sz = ICP_QAT_HW_SHA512_STATE1_SZ;
+		hash_cd_ctrl->inner_state2_sz = ICP_QAT_HW_SHA512_STATE2_SZ;
+		break;
+	default:
+		break;
+	}
+
+	hash_cd_ctrl->inner_state2_offset = hash_cd_ctrl->hash_cfg_offset +
+			((sizeof(struct icp_qat_hw_auth_setup) +
+			 round_up(hash_cd_ctrl->inner_state1_sz, 8)) >> 3);
+	auth_param->u1.auth_partial_st_prefix = ctx->auth_state_enc_paddr +
+			sizeof(struct icp_qat_hw_auth_counter) +
+			round_up(hash_cd_ctrl->inner_state1_sz, 8);
+	auth_param->auth_res_sz = digestsize;
+	ICP_QAT_FW_COMN_CURR_ID_SET(hash_cd_ctrl, ICP_QAT_FW_SLICE_AUTH);
+	ICP_QAT_FW_COMN_NEXT_ID_SET(hash_cd_ctrl, ICP_QAT_FW_SLICE_CIPHER);
+	return 0;
+}
+
+static int qat_alg_init_sessions(struct qat_alg_session_ctx *ctx,
+				 const uint8_t *key, unsigned int keylen)
+{
+	struct crypto_authenc_keys keys;
+	int alg;
+
+	if (crypto_rng_get_bytes(crypto_default_rng, ctx->salt, AES_BLOCK_SIZE))
+		return -EFAULT;
+
+	if (crypto_authenc_extractkeys(&keys, key, keylen))
+		goto bad_key;
+
+	switch (keys.enckeylen) {
+	case AES_KEYSIZE_128:
+		alg = ICP_QAT_HW_CIPHER_ALGO_AES128;
+		break;
+	case AES_KEYSIZE_192:
+		alg = ICP_QAT_HW_CIPHER_ALGO_AES192;
+		break;
+	case AES_KEYSIZE_256:
+		alg = ICP_QAT_HW_CIPHER_ALGO_AES256;
+		break;
+	default:
+		goto bad_key;
+		break;
+	}
+
+	if (qat_alg_init_enc_session(ctx, alg, &keys))
+		goto error;
+
+	if (qat_alg_init_dec_session(ctx, alg, &keys))
+		goto error;
+
+	return 0;
+bad_key:
+	crypto_tfm_set_flags(ctx->tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+	return -EINVAL;
+error:
+	return -EFAULT;
+}
+
+static int qat_alg_setkey(struct crypto_aead *tfm, const uint8_t *key,
+			  unsigned int keylen)
+{
+	struct qat_alg_session_ctx *ctx = crypto_aead_ctx(tfm);
+	struct device *dev;
+
+	spin_lock(&ctx->lock);
+	if (ctx->enc_cd) {
+		/* rekeying */
+		dev = &GET_DEV(ctx->inst->accel_dev);
+		memset(ctx->enc_cd, 0, sizeof(struct qat_alg_cd));
+		memset(ctx->dec_cd, 0, sizeof(struct qat_alg_cd));
+		memset(ctx->auth_hw_state_enc, 0,
+		       sizeof(struct qat_auth_state));
+		memset(ctx->auth_hw_state_dec, 0,
+		       sizeof(struct qat_auth_state));
+		memset(&ctx->enc_fw_req_tmpl, 0,
+		       sizeof(struct icp_qat_fw_la_bulk_req));
+		memset(&ctx->dec_fw_req_tmpl, 0,
+		       sizeof(struct icp_qat_fw_la_bulk_req));
+	} else {
+		/* new key */
+		int node = get_current_node();
+		struct qat_crypto_instance *inst =
+				qat_crypto_get_instance_node(node);
+		if (!inst) {
+			spin_unlock(&ctx->lock);
+			return -EINVAL;
+		}
+
+		dev = &GET_DEV(inst->accel_dev);
+		ctx->inst = inst;
+		ctx->enc_cd = dma_zalloc_coherent(dev,
+						  sizeof(struct qat_alg_cd),
+						  &ctx->enc_cd_paddr,
+						  GFP_ATOMIC);
+		if (!ctx->enc_cd) {
+			spin_unlock(&ctx->lock);
+			return -ENOMEM;
+		}
+		ctx->dec_cd = dma_zalloc_coherent(dev,
+						  sizeof(struct qat_alg_cd),
+						  &ctx->dec_cd_paddr,
+						  GFP_ATOMIC);
+		if (!ctx->dec_cd) {
+			spin_unlock(&ctx->lock);
+			goto out_free_enc;
+		}
+		ctx->auth_hw_state_enc =
+			dma_zalloc_coherent(dev, sizeof(struct qat_auth_state),
+					    &ctx->auth_state_enc_paddr,
+					    GFP_ATOMIC);
+		if (!ctx->auth_hw_state_enc) {
+			spin_unlock(&ctx->lock);
+			goto out_free_dec;
+		}
+		ctx->auth_hw_state_dec =
+			dma_zalloc_coherent(dev, sizeof(struct qat_auth_state),
+					    &ctx->auth_state_dec_paddr,
+					    GFP_ATOMIC);
+		if (!ctx->auth_hw_state_dec) {
+			spin_unlock(&ctx->lock);
+			goto out_free_auth_enc;
+		}
+	}
+	spin_unlock(&ctx->lock);
+	if (qat_alg_init_sessions(ctx, key, keylen))
+		goto out_free_all;
+
+	return 0;
+
+out_free_all:
+	dma_free_coherent(dev, sizeof(struct qat_auth_state),
+			  ctx->auth_hw_state_dec, ctx->auth_state_dec_paddr);
+	ctx->auth_hw_state_dec = NULL;
+out_free_auth_enc:
+	dma_free_coherent(dev, sizeof(struct qat_auth_state),
+			  ctx->auth_hw_state_enc, ctx->auth_state_enc_paddr);
+	ctx->auth_hw_state_enc = NULL;
+out_free_dec:
+	dma_free_coherent(dev, sizeof(struct qat_alg_cd),
+			  ctx->dec_cd, ctx->dec_cd_paddr);
+	ctx->dec_cd = NULL;
+out_free_enc:
+	dma_free_coherent(dev, sizeof(struct qat_alg_cd),
+			  ctx->enc_cd, ctx->enc_cd_paddr);
+	ctx->enc_cd = NULL;
+	return -ENOMEM;
+}
+
+static void qat_alg_free_bufl(struct qat_crypto_instance *inst,
+			      struct qat_crypto_request *qat_req)
+{
+	struct device *dev = &GET_DEV(inst->accel_dev);
+	struct qat_alg_buf_list *bl = qat_req->buf.bl;
+	struct qat_alg_buf_list *blout = qat_req->buf.blout;
+	dma_addr_t blp = qat_req->buf.blp;
+	dma_addr_t blpout = qat_req->buf.bloutp;
+	size_t sz = qat_req->buf.sz;
+	int i, bufs = bl->num_bufs;
+
+	for (i = 0; i < bl->num_bufs; i++)
+		dma_unmap_single(dev, bl->bufers[i].addr,
+				 bl->bufers[i].len, DMA_BIDIRECTIONAL);
+
+	dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
+	kfree(bl);
+	if (blp != blpout) {
+		/* If out of place operation dma unmap only data */
+		int bufless = bufs - blout->num_mapped_bufs;
+		for (i = bufless; i < bufs; i++) {
+			dma_unmap_single(dev, blout->bufers[i].addr,
+					 blout->bufers[i].len,
+					 DMA_BIDIRECTIONAL);
+		}
+		dma_unmap_single(dev, blpout, sz, DMA_TO_DEVICE);
+		kfree(blout);
+	}
+}
+
+static int qat_alg_sgl_to_bufl(struct qat_crypto_instance *inst,
+			       struct scatterlist *assoc,
+			       struct scatterlist *sgl,
+			       struct scatterlist *sglout, uint8_t *iv,
+			       uint8_t ivlen,
+			       struct qat_crypto_request *qat_req)
+{
+	struct device *dev = &GET_DEV(inst->accel_dev);
+	int i, bufs = 0, n = sg_nents(sgl), assoc_n = sg_nents(assoc);
+	struct qat_alg_buf_list *bufl;
+	struct qat_alg_buf_list *buflout = NULL;
+	dma_addr_t blp;
+	dma_addr_t bloutp = 0;
+	struct scatterlist *sg;
+	size_t sz = sizeof(struct qat_alg_buf_list) +
+			((1 + n + assoc_n) * sizeof(struct qat_alg_buf));
+
+	if (unlikely(!n))
+		return -EINVAL;
+
+	bufl = kmalloc(sz, GFP_ATOMIC);
+	if (unlikely(!bufl))
+		return -ENOMEM;
+
+	blp = dma_map_single(dev, bufl, sz, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(dev, blp)))
+		goto err;
+
+	for_each_sg(assoc, sg, assoc_n, i) {
+		bufl->bufers[bufs].addr = dma_map_single(dev,
+							 sg_virt(sg),
+							 sg->length,
+							 DMA_BIDIRECTIONAL);
+		bufl->bufers[bufs].len = sg->length;
+		if (unlikely(dma_mapping_error(dev, bufl->bufers[bufs].addr)))
+			goto err;
+		bufs++;
+	}
+	bufl->bufers[bufs].addr = dma_map_single(dev, iv, ivlen,
+						 DMA_BIDIRECTIONAL);
+	bufl->bufers[bufs].len = ivlen;
+	if (unlikely(dma_mapping_error(dev, bufl->bufers[bufs].addr)))
+		goto err;
+	bufs++;
+
+	for_each_sg(sgl, sg, n, i) {
+		int y = i + bufs;
+		bufl->bufers[y].addr = dma_map_single(dev, sg_virt(sg),
+						      sg->length,
+						      DMA_BIDIRECTIONAL);
+		bufl->bufers[y].len = sg->length;
+		if (unlikely(dma_mapping_error(dev, bufl->bufers[y].addr)))
+			goto err;
+	}
+	bufl->num_bufs = n + bufs;
+	qat_req->buf.bl = bufl;
+	qat_req->buf.blp = blp;
+	qat_req->buf.sz = sz;
+	/* Handle out of place operation */
+	if (sgl != sglout) {
+		struct qat_alg_buf *bufers;
+
+		buflout = kmalloc(sz, GFP_ATOMIC);
+		if (unlikely(!buflout))
+			goto err;
+		bloutp = dma_map_single(dev, buflout, sz, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(dev, bloutp)))
+			goto err;
+		bufers = buflout->bufers;
+		/* For out of place operation dma map only data and
+		 * reuse assoc mapping and iv */
+		for (i = 0; i < bufs; i++) {
+			bufers[i].len = bufl->bufers[i].len;
+			bufers[i].addr = bufl->bufers[i].addr;
+		}
+		for_each_sg(sglout, sg, n, i) {
+			int y = i + bufs;
+			bufers[y].addr = dma_map_single(dev, sg_virt(sg),
+							sg->length,
+							DMA_BIDIRECTIONAL);
+			buflout->bufers[y].len = sg->length;
+			if (unlikely(dma_mapping_error(dev, bufers[y].addr)))
+				goto err;
+		}
+		buflout->num_bufs = n + bufs;
+		buflout->num_mapped_bufs = n;
+		qat_req->buf.blout = buflout;
+		qat_req->buf.bloutp = bloutp;
+	} else {
+		/* Otherwise set the src and dst to the same address */
+		qat_req->buf.bloutp = qat_req->buf.blp;
+	}
+	return 0;
+err:
+	dev_err(dev, "Failed to map buf for dma\n");
+	for_each_sg(sgl, sg, n + bufs, i) {
+		if (!dma_mapping_error(dev, bufl->bufers[i].addr)) {
+			dma_unmap_single(dev, bufl->bufers[i].addr,
+					 bufl->bufers[i].len,
+					 DMA_BIDIRECTIONAL);
+		}
+	}
+	if (!dma_mapping_error(dev, blp))
+		dma_unmap_single(dev, blp, sz, DMA_TO_DEVICE);
+	kfree(bufl);
+	if (sgl != sglout && buflout) {
+		for_each_sg(sglout, sg, n, i) {
+			int y = i + bufs;
+			if (!dma_mapping_error(dev, buflout->bufers[y].addr))
+				dma_unmap_single(dev, buflout->bufers[y].addr,
+						 buflout->bufers[y].len,
+						 DMA_BIDIRECTIONAL);
+		}
+		if (!dma_mapping_error(dev, bloutp))
+			dma_unmap_single(dev, bloutp, sz, DMA_TO_DEVICE);
+		kfree(buflout);
+	}
+	return -ENOMEM;
+}
+
+void qat_alg_callback(void *resp)
+{
+	struct icp_qat_fw_la_resp *qat_resp = resp;
+	struct qat_crypto_request *qat_req =
+			(void *)(dma_addr_t)qat_resp->opaque_data;
+	struct qat_alg_session_ctx *ctx = qat_req->ctx;
+	struct qat_crypto_instance *inst = ctx->inst;
+	struct aead_request *areq = qat_req->areq;
+	uint8_t stat_filed = qat_resp->comn_resp.comn_status;
+	int res = 0, qat_res = ICP_QAT_FW_COMN_RESP_CRYPTO_STAT_GET(stat_filed);
+
+	qat_alg_free_bufl(inst, qat_req);
+	if (unlikely(qat_res != ICP_QAT_FW_COMN_STATUS_FLAG_OK))
+		res = -EBADMSG;
+	areq->base.complete(&(areq->base), res);
+}
+
+static int qat_alg_dec(struct aead_request *areq)
+{
+	struct crypto_aead *aead_tfm = crypto_aead_reqtfm(areq);
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead_tfm);
+	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_crypto_request *qat_req = aead_request_ctx(areq);
+	struct icp_qat_fw_la_cipher_req_params *cipher_param;
+	struct icp_qat_fw_la_auth_req_params *auth_param;
+	struct icp_qat_fw_la_bulk_req *msg;
+	int digst_size = crypto_aead_crt(aead_tfm)->authsize;
+	int ret, ctr = 0;
+
+	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->assoc, areq->src, areq->dst,
+				  areq->iv, AES_BLOCK_SIZE, qat_req);
+	if (unlikely(ret))
+		return ret;
+
+	msg = &qat_req->req;
+	*msg = ctx->dec_fw_req_tmpl;
+	qat_req->ctx = ctx;
+	qat_req->areq = areq;
+	qat_req->req.comn_mid.opaque_data = (uint64_t)(dma_addr_t)qat_req;
+	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
+	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
+	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
+	cipher_param->cipher_length = areq->cryptlen - digst_size;
+	cipher_param->cipher_offset = areq->assoclen + AES_BLOCK_SIZE;
+	memcpy(cipher_param->u.cipher_IV_array, areq->iv, AES_BLOCK_SIZE);
+	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
+	auth_param->auth_off = 0;
+	auth_param->auth_len = areq->assoclen +
+				cipher_param->cipher_length + AES_BLOCK_SIZE;
+	do {
+		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
+	} while (ret == -EAGAIN && ctr++ < 10);
+
+	if (ret == -EAGAIN) {
+		qat_alg_free_bufl(ctx->inst, qat_req);
+		return -EBUSY;
+	}
+	return -EINPROGRESS;
+}
+
+static int qat_alg_enc_internal(struct aead_request *areq, uint8_t *iv,
+				int enc_iv)
+{
+	struct crypto_aead *aead_tfm = crypto_aead_reqtfm(areq);
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead_tfm);
+	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_crypto_request *qat_req = aead_request_ctx(areq);
+	struct icp_qat_fw_la_cipher_req_params *cipher_param;
+	struct icp_qat_fw_la_auth_req_params *auth_param;
+	struct icp_qat_fw_la_bulk_req *msg;
+	int ret, ctr = 0;
+
+	ret = qat_alg_sgl_to_bufl(ctx->inst, areq->assoc, areq->src, areq->dst,
+				  iv, AES_BLOCK_SIZE, qat_req);
+	if (unlikely(ret))
+		return ret;
+
+	msg = &qat_req->req;
+	*msg = ctx->enc_fw_req_tmpl;
+	qat_req->ctx = ctx;
+	qat_req->areq = areq;
+	qat_req->req.comn_mid.opaque_data = (uint64_t)(dma_addr_t)qat_req;
+	qat_req->req.comn_mid.src_data_addr = qat_req->buf.blp;
+	qat_req->req.comn_mid.dest_data_addr = qat_req->buf.bloutp;
+	cipher_param = (void *)&qat_req->req.serv_specif_rqpars;
+	auth_param = (void *)((uint8_t *)cipher_param + sizeof(*cipher_param));
+
+	if (enc_iv) {
+		cipher_param->cipher_length = areq->cryptlen + AES_BLOCK_SIZE;
+		cipher_param->cipher_offset = areq->assoclen;
+	} else {
+		memcpy(cipher_param->u.cipher_IV_array, iv, AES_BLOCK_SIZE);
+		cipher_param->cipher_length = areq->cryptlen;
+		cipher_param->cipher_offset = areq->assoclen + AES_BLOCK_SIZE;
+	}
+	auth_param->auth_off = 0;
+	auth_param->auth_len = areq->assoclen + areq->cryptlen + AES_BLOCK_SIZE;
+
+	do {
+		ret = adf_send_message(ctx->inst->sym_tx, (uint32_t *)msg);
+	} while (ret == -EAGAIN && ctr++ < 10);
+
+	if (ret == -EAGAIN) {
+		qat_alg_free_bufl(ctx->inst, qat_req);
+		return -EBUSY;
+	}
+	return -EINPROGRESS;
+}
+
+static int qat_alg_enc(struct aead_request *areq)
+{
+	return qat_alg_enc_internal(areq, areq->iv, 0);
+}
+
+static int qat_alg_genivenc(struct aead_givcrypt_request *req)
+{
+	struct crypto_aead *aead_tfm = crypto_aead_reqtfm(&req->areq);
+	struct crypto_tfm *tfm = crypto_aead_tfm(aead_tfm);
+	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
+	__be64 seq;
+
+	memcpy(req->giv, ctx->salt, AES_BLOCK_SIZE);
+	seq = cpu_to_be64(req->seq);
+	memcpy(req->giv + AES_BLOCK_SIZE - sizeof(uint64_t),
+	       &seq, sizeof(uint64_t));
+	return qat_alg_enc_internal(&req->areq, req->giv, 1);
+}
+
+static int qat_alg_init(struct crypto_tfm *tfm,
+			enum icp_qat_hw_auth_algo hash, const char *hash_name)
+{
+	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	memset(ctx, '\0', sizeof(*ctx));
+	ctx->hash_tfm = crypto_alloc_shash(hash_name, 0, 0);
+	if (IS_ERR(ctx->hash_tfm))
+		return -EFAULT;
+	spin_lock_init(&ctx->lock);
+	ctx->qat_hash_alg = hash;
+	tfm->crt_aead.reqsize = sizeof(struct aead_request) +
+				sizeof(struct qat_crypto_request);
+	ctx->tfm = tfm;
+	return 0;
+}
+
+static int qat_alg_sha1_init(struct crypto_tfm *tfm)
+{
+	return qat_alg_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA1, "sha1");
+}
+
+static int qat_alg_sha256_init(struct crypto_tfm *tfm)
+{
+	return qat_alg_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA256, "sha256");
+}
+
+static int qat_alg_sha512_init(struct crypto_tfm *tfm)
+{
+	return qat_alg_init(tfm, ICP_QAT_HW_AUTH_ALGO_SHA512, "sha512");
+}
+
+static void qat_alg_exit(struct crypto_tfm *tfm)
+{
+	struct qat_alg_session_ctx *ctx = crypto_tfm_ctx(tfm);
+	struct qat_crypto_instance *inst = ctx->inst;
+	struct device *dev;
+
+	if (!IS_ERR(ctx->hash_tfm))
+		crypto_free_shash(ctx->hash_tfm);
+
+	if (!inst)
+		return;
+
+	dev = &GET_DEV(inst->accel_dev);
+	if (ctx->enc_cd)
+		dma_free_coherent(dev, sizeof(struct qat_alg_cd),
+				  ctx->enc_cd, ctx->enc_cd_paddr);
+	if (ctx->dec_cd)
+		dma_free_coherent(dev, sizeof(struct qat_alg_cd),
+				  ctx->dec_cd, ctx->dec_cd_paddr);
+	if (ctx->auth_hw_state_enc)
+		dma_free_coherent(dev, sizeof(struct qat_auth_state),
+				  ctx->auth_hw_state_enc,
+				  ctx->auth_state_enc_paddr);
+
+	if (ctx->auth_hw_state_dec)
+		dma_free_coherent(dev, sizeof(struct qat_auth_state),
+				  ctx->auth_hw_state_dec,
+				  ctx->auth_state_dec_paddr);
+
+	qat_crypto_put_instance(inst);
+}
+
+static struct crypto_alg qat_algs[] = { {
+	.cra_name = "authenc(hmac(sha1),cbc(aes))",
+	.cra_driver_name = "qat_aes_cbc_hmac_sha1",
+	.cra_priority = 4001,
+	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct qat_alg_session_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_aead_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = qat_alg_sha1_init,
+	.cra_exit = qat_alg_exit,
+	.cra_u = {
+		.aead = {
+			.setkey = qat_alg_setkey,
+			.decrypt = qat_alg_dec,
+			.encrypt = qat_alg_enc,
+			.givencrypt = qat_alg_genivenc,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA1_DIGEST_SIZE,
+		},
+	},
+}, {
+	.cra_name = "authenc(hmac(sha256),cbc(aes))",
+	.cra_driver_name = "qat_aes_cbc_hmac_sha256",
+	.cra_priority = 4001,
+	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct qat_alg_session_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_aead_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = qat_alg_sha256_init,
+	.cra_exit = qat_alg_exit,
+	.cra_u = {
+		.aead = {
+			.setkey = qat_alg_setkey,
+			.decrypt = qat_alg_dec,
+			.encrypt = qat_alg_enc,
+			.givencrypt = qat_alg_genivenc,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA256_DIGEST_SIZE,
+		},
+	},
+}, {
+	.cra_name = "authenc(hmac(sha512),cbc(aes))",
+	.cra_driver_name = "qat_aes_cbc_hmac_sha512",
+	.cra_priority = 4001,
+	.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC,
+	.cra_blocksize = AES_BLOCK_SIZE,
+	.cra_ctxsize = sizeof(struct qat_alg_session_ctx),
+	.cra_alignmask = 0,
+	.cra_type = &crypto_aead_type,
+	.cra_module = THIS_MODULE,
+	.cra_init = qat_alg_sha512_init,
+	.cra_exit = qat_alg_exit,
+	.cra_u = {
+		.aead = {
+			.setkey = qat_alg_setkey,
+			.decrypt = qat_alg_dec,
+			.encrypt = qat_alg_enc,
+			.givencrypt = qat_alg_genivenc,
+			.ivsize = AES_BLOCK_SIZE,
+			.maxauthsize = SHA512_DIGEST_SIZE,
+		},
+	},
+} };
+
+int qat_algs_register(void)
+{
+	if (atomic_add_return(1, &active_dev) == 1) {
+		int i;
+
+		for (i = 0; i < ARRAY_SIZE(qat_algs); i++)
+			qat_algs[i].cra_flags =	CRYPTO_ALG_TYPE_AEAD |
+						CRYPTO_ALG_ASYNC;
+		return crypto_register_algs(qat_algs, ARRAY_SIZE(qat_algs));
+	}
+	return 0;
+}
+
+int qat_algs_unregister(void)
+{
+	if (atomic_sub_return(1, &active_dev) == 0)
+		return crypto_unregister_algs(qat_algs, ARRAY_SIZE(qat_algs));
+	return 0;
+}
+
+int qat_algs_init(void)
+{
+	atomic_set(&active_dev, 0);
+	crypto_get_default_rng();
+	return 0;
+}
+
+void qat_algs_exit(void)
+{
+	crypto_put_default_rng();
+}
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
new file mode 100644
index 0000000..cc562cb
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -0,0 +1,284 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_transport.h"
+#include "adf_cfg.h"
+#include "adf_cfg_strings.h"
+#include "qat_crypto.h"
+#include "icp_qat_fw.h"
+
+#define SEC ADF_KERNEL_SEC
+
+static struct service_hndl qat_crypto;
+
+void qat_crypto_put_instance(struct qat_crypto_instance *inst)
+{
+	if (atomic_sub_return(1, &inst->refctr) == 0)
+		adf_dev_put(inst->accel_dev);
+}
+
+static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
+{
+	struct qat_crypto_instance *inst;
+	struct list_head *list_ptr, *tmp;
+	int i;
+
+	list_for_each_safe(list_ptr, tmp, &accel_dev->crypto_list) {
+		inst = list_entry(list_ptr, struct qat_crypto_instance, list);
+
+		for (i = 0; i < atomic_read(&inst->refctr); i++)
+			qat_crypto_put_instance(inst);
+
+		if (inst->sym_tx)
+			adf_remove_ring(inst->sym_tx);
+
+		if (inst->sym_rx)
+			adf_remove_ring(inst->sym_rx);
+
+		if (inst->pke_tx)
+			adf_remove_ring(inst->pke_tx);
+
+		if (inst->pke_rx)
+			adf_remove_ring(inst->pke_rx);
+
+		if (inst->rnd_tx)
+			adf_remove_ring(inst->rnd_tx);
+
+		if (inst->rnd_rx)
+			adf_remove_ring(inst->rnd_rx);
+
+		list_del(list_ptr);
+		kfree(inst);
+	}
+	return 0;
+}
+
+struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
+{
+	struct adf_accel_dev *accel_dev = NULL;
+	struct qat_crypto_instance *inst_best = NULL;
+	struct list_head *itr;
+	unsigned long best = ~0;
+
+	list_for_each(itr, adf_devmgr_get_head()) {
+		accel_dev = list_entry(itr, struct adf_accel_dev, list);
+		if (accel_dev->numa_node == node && adf_dev_started(accel_dev))
+			break;
+		accel_dev = NULL;
+	}
+	if (!accel_dev) {
+		pr_err("QAT: Could not find device on give node\n");
+		accel_dev = adf_devmgr_get_first();
+	}
+	if (!accel_dev || !adf_dev_started(accel_dev))
+		return NULL;
+
+	list_for_each(itr, &accel_dev->crypto_list) {
+		struct qat_crypto_instance *inst;
+		unsigned long cur;
+
+		inst = list_entry(itr, struct qat_crypto_instance, list);
+		cur = atomic_read(&inst->refctr);
+		if (best > cur) {
+			inst_best = inst;
+			best = cur;
+		}
+	}
+	if (inst_best) {
+		if (atomic_add_return(1, &inst_best->refctr) == 1) {
+			if (adf_dev_get(accel_dev)) {
+				atomic_dec(&inst_best->refctr);
+				pr_err("QAT: Could increment dev refctr\n");
+				return NULL;
+			}
+		}
+	}
+	return inst_best;
+}
+
+static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
+{
+	int i;
+	long unsigned int bank;
+	long unsigned int num_inst, num_msg_sym, num_msg_asym;
+	int msg_size;
+	struct qat_crypto_instance *inst;
+	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+
+	INIT_LIST_HEAD(&accel_dev->crypto_list);
+	strlcpy(key, ADF_NUM_CY, sizeof(key));
+
+	if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
+		return -EFAULT;
+
+	if (kstrtoul(val, 0, &num_inst))
+		return -EFAULT;
+
+	for (i = 0; i < num_inst; i++) {
+		inst = kzalloc_node(sizeof(*inst), GFP_KERNEL,
+				    accel_dev->numa_node);
+		if (!inst)
+			goto err;
+
+		list_add_tail(&inst->list, &accel_dev->crypto_list);
+		inst->id = i;
+		atomic_set(&inst->refctr, 0);
+		inst->accel_dev = accel_dev;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
+		if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
+			goto err;
+
+		if (kstrtoul(val, 10, &bank))
+			goto err;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
+		if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
+			goto err;
+
+		if (kstrtoul(val, 10, &num_msg_sym))
+			goto err;
+		num_msg_sym = num_msg_sym >> 1;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
+		if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
+			goto err;
+
+		if (kstrtoul(val, 10, &num_msg_asym))
+			goto err;
+		num_msg_asym = num_msg_asym >> 1;
+
+		msg_size = ICP_QAT_FW_REQ_DEFAULT_SZ;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
+		if (adf_create_ring(accel_dev, SEC, bank, num_msg_sym,
+				    msg_size, key, NULL, 0, &inst->sym_tx))
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_RND_TX, i);
+		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
+				    msg_size, key, NULL, 0, &inst->rnd_tx))
+			goto err;
+
+		msg_size = msg_size >> 1;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
+		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
+				    msg_size, key, NULL, 0, &inst->pke_tx))
+			goto err;
+
+		msg_size = ICP_QAT_FW_RESP_DEFAULT_SZ;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
+		if (adf_create_ring(accel_dev, SEC, bank, num_msg_sym,
+				    msg_size, key, qat_alg_callback, 0,
+				    &inst->sym_rx))
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_RND_RX, i);
+		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
+				    msg_size, key, qat_alg_callback, 0,
+				    &inst->rnd_rx))
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
+		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
+				    msg_size, key, qat_alg_callback, 0,
+				    &inst->pke_rx))
+			goto err;
+	}
+	return 0;
+err:
+	qat_crypto_free_instances(accel_dev);
+	return -ENOMEM;
+}
+
+static int qat_crypto_init(struct adf_accel_dev *accel_dev)
+{
+	if (qat_crypto_create_instances(accel_dev))
+		return -EFAULT;
+
+	return 0;
+}
+
+static int qat_crypto_shutdown(struct adf_accel_dev *accel_dev)
+{
+	return qat_crypto_free_instances(accel_dev);
+}
+
+static int qat_crypto_event_handler(struct adf_accel_dev *accel_dev,
+				    enum adf_event event)
+{
+	int ret;
+
+	switch (event) {
+	case ADF_EVENT_INIT:
+		ret = qat_crypto_init(accel_dev);
+		break;
+	case ADF_EVENT_SHUTDOWN:
+		ret = qat_crypto_shutdown(accel_dev);
+		break;
+	case ADF_EVENT_RESTARTING:
+	case ADF_EVENT_RESTARTED:
+	case ADF_EVENT_START:
+	case ADF_EVENT_STOP:
+	default:
+		ret = 0;
+	}
+	return ret;
+}
+
+int qat_crypto_register(void)
+{
+	memset(&qat_crypto, 0, sizeof(qat_crypto));
+	qat_crypto.event_hld = qat_crypto_event_handler;
+	qat_crypto.name = "qat_crypto";
+	return adf_service_register(&qat_crypto);
+}
+
+int qat_crypto_unregister(void)
+{
+	return adf_service_unregister(&qat_crypto);
+}
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.h b/drivers/crypto/qat/qat_common/qat_crypto.h
new file mode 100644
index 0000000..ab8468d
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_crypto.h
@@ -0,0 +1,83 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef _QAT_CRYPTO_INSTANCE_H_
+#define _QAT_CRYPTO_INSTANCE_H_
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include "adf_accel_devices.h"
+#include "icp_qat_fw_la.h"
+
+struct qat_crypto_instance {
+	struct adf_etr_ring_data *sym_tx;
+	struct adf_etr_ring_data *sym_rx;
+	struct adf_etr_ring_data *pke_tx;
+	struct adf_etr_ring_data *pke_rx;
+	struct adf_etr_ring_data *rnd_tx;
+	struct adf_etr_ring_data *rnd_rx;
+	struct adf_accel_dev *accel_dev;
+	struct list_head list;
+	unsigned long state;
+	int id;
+	atomic_t refctr;
+};
+
+struct qat_crypto_request_buffs {
+	struct qat_alg_buf_list *bl;
+	dma_addr_t blp;
+	struct qat_alg_buf_list *blout;
+	dma_addr_t bloutp;
+	size_t sz;
+};
+
+struct qat_crypto_request {
+	struct icp_qat_fw_la_bulk_req req;
+	struct qat_alg_session_ctx *ctx;
+	struct aead_request *areq;
+	struct qat_crypto_request_buffs buf;
+};
+#endif
-- 
1.8.5.rc2.6.gc6f1b92.dirty

