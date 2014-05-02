Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbaEBQ2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:28:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43675 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbaEBPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 004/151] [3.13-stable] Revert "PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled"
Date: Fri,  2 May 2014 08:36:32 -0700
Message-Id: <1399045139-4531-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

This reverts commit 16d36cdf2bd2b8e821ea1286dd3e8b2d657e6b3c.

... which was applied to 3.13-stable twice, first as:
        bb7048ea362773c2b53ee410a69ff60a029c71ef
and then again as:
        16d36cdf2bd2b8e821ea1286dd3e8b2d657e6b3c

This revert relates only to 3.13-stable, and the fix itself remains in 3.13.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/pci.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6f01c74..1a8a4fd 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1134,9 +1134,6 @@ static int do_pci_enable_device(struct pci_dev *dev, int bars)
 	if (dev->msi_enabled || dev->msix_enabled)
 		return 0;
 
-	if (dev->msi_enabled || dev->msix_enabled)
-		return 0;
-
 	pci_read_config_byte(dev, PCI_INTERRUPT_PIN, &pin);
 	if (pin) {
 		pci_read_config_word(dev, PCI_COMMAND, &cmd);
-- 
1.9.1

