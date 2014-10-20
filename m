Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaJTTIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 15:08:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37557 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaJTTI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 15:08:29 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kamal Mostafa <kamal@canonical.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] Revert duplicate "PCI: pciehp: Prevent NULL dereference during probe"
Date: Mon, 20 Oct 2014 12:08:10 -0700
Message-Id: <1413832091-28752-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit bceee4a97eb58bd0e80e39eff11b506ddd9e7ad3.

This patch was applied twice (identical patch, different descriptions):
    62e4492 PCI: Prevent NULL dereference during pciehp probe
    bceee4a PCI: pciehp: Prevent NULL dereference during probe

Revert the latter to dispose of the duplicated code block.

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Cc: Andreas Noever <andreas.noever@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org  # v3.2+
---
 drivers/pci/hotplug/pciehp_core.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/pci/hotplug/pciehp_core.c b/drivers/pci/hotplug/pciehp_core.c
index 3a5e7e2..07aa722 100644
--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -262,13 +262,6 @@ static int pciehp_probe(struct pcie_device *dev)
 		goto err_out_none;
 	}
 
-	if (!dev->port->subordinate) {
-		/* Can happen if we run out of bus numbers during probe */
-		dev_err(&dev->device,
-			"Hotplug bridge without secondary bus, ignoring\n");
-		goto err_out_none;
-	}
-
 	ctrl = pcie_init(dev);
 	if (!ctrl) {
 		dev_err(&dev->device, "Controller initialization failed\n");
-- 
1.9.1

