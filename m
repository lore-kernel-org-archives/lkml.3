Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab3LCAPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 19:15:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:4610 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab3LCAPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 19:15:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,813,1378882800"; 
   d="scan'208";a="418263452"
From: David Cohen <david.a.cohen@linux.intel.com>
To: matthew.garrett@nebula.com
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH 2/2] ipc: add intel-mid's pci id macros
Date: Mon,  2 Dec 2013 16:20:01 -0800
Message-Id: <1386030001-18348-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1386030001-18348-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1386030001-18348-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For readability matters, this patch replaces the hardcoded pci ids by
human readable macros.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 drivers/platform/x86/intel_scu_ipc.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/intel_scu_ipc.c b/drivers/platform/x86/intel_scu_ipc.c
index 259969d31055..76ca094ed012 100644
--- a/drivers/platform/x86/intel_scu_ipc.c
+++ b/drivers/platform/x86/intel_scu_ipc.c
@@ -62,6 +62,11 @@
 #define IPC_RWBUF_SIZE    20		/* IPC Read buffer Size */
 #define IPC_IOC	          0x100		/* IPC command register IOC bit */
 
+#define PCI_DEVICE_ID_LINCROFT		0x082a
+#define PCI_DEVICE_ID_PENWELL		0x080e
+#define PCI_DEVICE_ID_CLOVERVIEW	0x08ea
+#define PCI_DEVICE_ID_TANGIER		0x11a0
+
 /* intel scu ipc driver data*/
 struct intel_scu_ipc_pdata_t {
 	u32 ipc_base;
@@ -637,16 +642,16 @@ static void ipc_remove(struct pci_dev *pdev)
 
 static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
 	{
-		PCI_VDEVICE(INTEL, 0x082a),
+		PCI_VDEVICE(INTEL, PCI_DEVICE_ID_LINCROFT),
 		(kernel_ulong_t)&intel_scu_ipc_lincroft_pdata,
 	}, {
-		PCI_VDEVICE(INTEL, 0x080e),
+		PCI_VDEVICE(INTEL, PCI_DEVICE_ID_PENWELL),
 		(kernel_ulong_t)&intel_scu_ipc_penwell_pdata,
 	}, {
-		PCI_VDEVICE(INTEL, 0x08ea),
+		PCI_VDEVICE(INTEL, PCI_DEVICE_ID_CLOVERVIEW),
 		(kernel_ulong_t)&intel_scu_ipc_penwell_pdata,
 	}, {
-		PCI_VDEVICE(INTEL, 0x11a0),
+		PCI_VDEVICE(INTEL, PCI_DEVICE_ID_TANGIER),
 		(kernel_ulong_t)&intel_scu_ipc_tangier_pdata,
 	}, {
 		0,
-- 
1.8.4.2

