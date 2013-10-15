Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3JOEHB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 00:07:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:56768 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3JOEG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 00:06:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,496,1378882800"; 
   d="scan'208";a="392987155"
From: Kuppuswamy Sathyanarayanan 
	<sathyanarayanan.kuppuswamy@linux.intel.com>
To: platform-driver-x86@vger.kernel.org
Cc: matthew.garrett@nebula.com, linux-kernel@vger.kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com
Subject: [PATCH v2 2/3] ipc: Enabled ipc support for additional intel platforms
Date: Mon, 14 Oct 2013 21:06:23 -0700
Message-Id: <f4285b32f4b0e8a89a65dd47ea764f6c3b6cbf47.1381809435.git.sathyanarayanan.kuppuswamy@linux.intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1381809435.git.sathyanarayanan.kuppuswamy@linux.intel.com>
References: <cover.1381809435.git.sathyanarayanan.kuppuswamy@linux.intel.com>
In-Reply-To: <cover.1381809435.git.sathyanarayanan.kuppuswamy@linux.intel.com>
References: <cover.1381809435.git.sathyanarayanan.kuppuswamy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabled ipc support for penwell, clovertrail & tangier platforms.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 drivers/platform/x86/intel_scu_ipc.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 93c1b57..aaaf1c1 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -63,6 +63,9 @@
 
 enum {
 	SCU_IPC_LINCROFT,
+	SCU_IPC_PENWELL,
+	SCU_IPC_CLOVERVIEW,
+	SCU_IPC_TANGIER,
 };
 
 /* intel scu ipc driver data*/
@@ -80,6 +83,24 @@ static struct intel_scu_ipc_pdata_t intel_scu_ipc_pdata[] = {
 		.ipc_len = 0x100,
 		.i2c_len = 0x10,
 	},
+	[SCU_IPC_PENWELL] = {
+		.ipc_base = 0xff11c000,
+		.i2c_base = 0xff12b000,
+		.ipc_len = 0x100,
+		.i2c_len = 0x10,
+	},
+	[SCU_IPC_CLOVERVIEW] = {
+		.ipc_base = 0xff11c000,
+		.i2c_base = 0xff12b000,
+		.ipc_len = 0x100,
+		.i2c_len = 0x10,
+	},
+	[SCU_IPC_TANGIER] = {
+		.ipc_base = 0xff009000,
+		.i2c_base  = 0xff00d000,
+		.ipc_len  = 0x100,
+		.i2c_len = 0x10,
+	},
 };
 
 static int ipc_probe(struct pci_dev *dev, const struct pci_device_id *id);
@@ -586,6 +607,9 @@ static void ipc_remove(struct pci_dev *pdev)
 
 static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x082a), SCU_IPC_LINCROFT},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x080e), SCU_IPC_PENWELL},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x08ea), SCU_IPC_CLOVERVIEW},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x11a0), SCU_IPC_TANGIER},
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, pci_ids);
-- 
1.7.9.5

