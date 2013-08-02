Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab3HBRhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:37:01 -0400
Received: from mga03.intel.com ([143.182.124.21]:4521 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab3HBRg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:36:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,802,1367996400"; 
   d="scan'208";a="276900334"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 03/15] NTB: Correct USD/DSD Identification
Date: Fri,  2 Aug 2013 10:35:32 -0700
Message-Id: <1375464944-27914-4-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
References: <1375464944-27914-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to ambiguous documentation, the USD/DSD identification is backward
when compared to the setting in BIOS.  Correct the bits to match the
BIOS setting.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_hw.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 3b0ab50..26b808b 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -531,9 +531,9 @@ static int ntb_xeon_setup(struct ntb_device *ndev)
 	}
 
 	if (val & SNB_PPD_DEV_TYPE)
-		ndev->dev_type = NTB_DEV_DSD;
-	else
 		ndev->dev_type = NTB_DEV_USD;
+	else
+		ndev->dev_type = NTB_DEV_DSD;
 
 	ndev->reg_ofs.pdb = ndev->reg_base + SNB_PDOORBELL_OFFSET;
 	ndev->reg_ofs.pdb_mask = ndev->reg_base + SNB_PDBMSK_OFFSET;
@@ -647,6 +647,9 @@ static int ntb_device_setup(struct ntb_device *ndev)
 	if (rc)
 		return rc;
 
+	dev_info(&ndev->pdev->dev, "Device Type = %s\n",
+		 ndev->dev_type == NTB_DEV_USD ? "USD/DSP" : "DSD/USP");
+
 	/* Enable Bus Master and Memory Space on the secondary side */
 	writew(PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER, ndev->reg_ofs.spci_cmd);
 
-- 
1.7.9.5

