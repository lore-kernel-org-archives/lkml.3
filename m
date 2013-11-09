Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654Ab3KIGxX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:53:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932949Ab3KIGxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:53:00 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jon Mason <jon.mason@intel.com>
Subject: [PATCH 3.11 93/94] NTB: Correct USD/DSD Identification
Date: Fri,  8 Nov 2013 22:52:39 -0800
Message-Id: <20131109065210.810451658@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Mason <jon.mason@intel.com>

commit b6750cfe0710a14fd147ba27fddbecae8ba88c77 upstream.

Due to ambiguous documentation, the USD/DSD identification is backward
when compared to the setting in BIOS.  Correct the bits to match the
BIOS setting.

Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ntb/ntb_hw.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -531,9 +531,9 @@ static int ntb_xeon_setup(struct ntb_dev
 	}
 
 	if (val & SNB_PPD_DEV_TYPE)
-		ndev->dev_type = NTB_DEV_DSD;
-	else
 		ndev->dev_type = NTB_DEV_USD;
+	else
+		ndev->dev_type = NTB_DEV_DSD;
 
 	ndev->reg_ofs.pdb = ndev->reg_base + SNB_PDOORBELL_OFFSET;
 	ndev->reg_ofs.pdb_mask = ndev->reg_base + SNB_PDBMSK_OFFSET;
@@ -647,6 +647,9 @@ static int ntb_device_setup(struct ntb_d
 	if (rc)
 		return rc;
 
+	dev_info(&ndev->pdev->dev, "Device Type = %s\n",
+		 ndev->dev_type == NTB_DEV_USD ? "USD/DSP" : "DSD/USP");
+
 	/* Enable Bus Master and Memory Space on the secondary side */
 	writew(PCI_COMMAND_MEMORY | PCI_COMMAND_MASTER, ndev->reg_ofs.spci_cmd);
 


