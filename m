Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724Ab3JPLAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:00:41 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:33107 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760667Ab3JPLAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:00:18 -0400
From: Robert Richter <rric@kernel.org>
To: linux-edac@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH 5/5] edac: Unify reporting of device info for device, mc and pci
Date: Wed, 16 Oct 2013 12:59:38 +0200
Message-Id: <1381921178-28511-6-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381921178-28511-1-git-send-email-rric@kernel.org>
References: <1381921178-28511-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

Log messages slightly differ between edac subsystems. Unifying it.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 drivers/edac/edac_device.c | 9 +++------
 drivers/edac/edac_mc.c     | 6 ++++--
 drivers/edac/edac_pci.c    | 8 +++-----
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/drivers/edac/edac_device.c b/drivers/edac/edac_device.c
index 211021d..1026743 100644
--- a/drivers/edac/edac_device.c
+++ b/drivers/edac/edac_device.c
@@ -530,12 +530,9 @@ int edac_device_add_device(struct edac_device_ctl_info *edac_dev)
 
 	/* Report action taken */
 	edac_device_printk(edac_dev, KERN_INFO,
-				"Giving out device to module '%s' controller "
-				"'%s': DEV '%s' (%s)\n",
-				edac_dev->mod_name,
-				edac_dev->ctl_name,
-				edac_dev_name(edac_dev),
-				edac_op_state_to_string(edac_dev->op_state));
+		"Giving out device to module %s controller %s: DEV %s (%s)\n",
+		edac_dev->mod_name, edac_dev->ctl_name, edac_dev->dev_name,
+		edac_op_state_to_string(edac_dev->op_state));
 
 	mutex_unlock(&device_ctls_mutex);
 	return 0;
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 89e1090..e8c9ef0 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -788,8 +788,10 @@ int edac_mc_add_mc(struct mem_ctl_info *mci)
 	}
 
 	/* Report action taken */
-	edac_mc_printk(mci, KERN_INFO, "Giving out device to '%s' '%s':"
-		" DEV %s\n", mci->mod_name, mci->ctl_name, edac_dev_name(mci));
+	edac_mc_printk(mci, KERN_INFO,
+		"Giving out device to module %s controller %s: DEV %s (%s)\n",
+		mci->mod_name, mci->ctl_name, mci->dev_name,
+		edac_op_state_to_string(mci->op_state));
 
 	edac_mc_owner = mci->mod_name;
 
diff --git a/drivers/edac/edac_pci.c b/drivers/edac/edac_pci.c
index dd370f9..2cf44b4d 100644
--- a/drivers/edac/edac_pci.c
+++ b/drivers/edac/edac_pci.c
@@ -358,11 +358,9 @@ int edac_pci_add_device(struct edac_pci_ctl_info *pci, int edac_idx)
 	}
 
 	edac_pci_printk(pci, KERN_INFO,
-			"Giving out device to module '%s' controller '%s':"
-			" DEV '%s' (%s)\n",
-			pci->mod_name,
-			pci->ctl_name,
-			edac_dev_name(pci), edac_op_state_to_string(pci->op_state));
+		"Giving out device to module %s controller %s: DEV %s (%s)\n",
+		pci->mod_name, pci->ctl_name, pci->dev_name,
+		edac_op_state_to_string(pci->op_state));
 
 	mutex_unlock(&edac_pci_ctls_mutex);
 	return 0;
-- 
1.8.4.rc3

