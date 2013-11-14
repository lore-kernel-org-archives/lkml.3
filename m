Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3KNWL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 17:11:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:60295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab3KNWKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 17:10:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="435469159"
From: David Cohen <david.a.cohen@linux.intel.com>
To: matthew.garrett@nebula.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        gnomes@lxorguk.ukuu.org.uk, david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, eric.ernst@linux.intel.com
Subject: [PATCH v2 2/4] ipc: Enabled ipc support for additional intel platforms
Date: Thu, 14 Nov 2013 14:15:05 -0800
Message-Id: <1384467307-18556-3-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1384467307-18556-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1384373671-12814-1-git-send-email-david.a.cohen@linux.intel.com>
 <1384467307-18556-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>

Enabled ipc support for penwell, clovertrail & tangier platforms.

Signed-off-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/platform/x86/intel_scu_ipc.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 39ff57bdf18f..86b6ce2a7a47 100644
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
 	{PCI_VDEVICE(INTEL, 0x082a), SCU_IPC_LINCROFT},
+	{PCI_VDEVICE(INTEL, 0x080e), SCU_IPC_PENWELL},
+	{PCI_VDEVICE(INTEL, 0x08ea), SCU_IPC_CLOVERVIEW},
+	{PCI_VDEVICE(INTEL, 0x11a0), SCU_IPC_TANGIER},
 	{ 0,}
 };
 MODULE_DEVICE_TABLE(pci, pci_ids);
-- 
1.8.4.2

