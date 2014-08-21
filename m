Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbaHUJrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 05:47:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:14017 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646AbaHUJrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 05:47:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,908,1400050800"; 
   d="scan'208";a="471129937"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2] mfd: lpc_ich: Add PCI ID for Intel Braswell
Date: Thu, 21 Aug 2014 12:46:25 +0300
Message-Id: <1408614385-15333-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is the same as used in Baytrail so add the new PCI ID to the driver's
list of supported IDs.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
Changed the PCI ID to be in lower case letters.

 drivers/mfd/lpc_ich.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 7d8482ff5868..8b8114e19c39 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -216,6 +216,7 @@ enum lpc_chipsets {
 	LPC_BAYTRAIL,   /* Bay Trail SoC */
 	LPC_COLETO,	/* Coleto Creek */
 	LPC_WPT_LP,	/* Wildcat Point-LP */
+	LPC_BRASWELL,	/* Braswell SoC */
 };
 
 static struct lpc_ich_info lpc_chipset_info[] = {
@@ -519,6 +520,10 @@ static struct lpc_ich_info lpc_chipset_info[] = {
 		.name = "Wildcat Point_LP",
 		.iTCO_version = 2,
 	},
+	[LPC_BRASWELL] = {
+		.name = "Braswell SoC",
+		.iTCO_version = 3,
+	},
 };
 
 /*
@@ -745,6 +750,7 @@ static const struct pci_device_id lpc_ich_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0x9cc6), LPC_WPT_LP},
 	{ PCI_VDEVICE(INTEL, 0x9cc7), LPC_WPT_LP},
 	{ PCI_VDEVICE(INTEL, 0x9cc9), LPC_WPT_LP},
+	{ PCI_VDEVICE(INTEL, 0x229c), LPC_BRASWELL},
 	{ 0, },			/* End of list */
 };
 MODULE_DEVICE_TABLE(pci, lpc_ich_ids);
-- 
2.1.0

