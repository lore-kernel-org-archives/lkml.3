Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbaGCJVK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:21:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51407 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647AbaGCJVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:21:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 011/198] PCI: Add new ID for Intel GPU "spurious interrupt" quirk
Date: Thu,  3 Jul 2014 10:17:34 +0100
Message-Id: <1404379241-8590-12-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Jarosch <thomas.jarosch@intra2net.com>

commit 7c82126a94e69bbbac586f0249e7ef11e681246c upstream.

After a CPU upgrade while keeping the same mainboard, we faced "spurious
interrupt" problems again.

It turned out that the new CPU also featured a new GPU with a different PCI
ID.

Add this PCI ID to the quirk table.  Probably all other Intel GPU PCI IDs
are affected, too, but I don't want to add them without a test system.

See f67fd55fa96f ("PCI: Add quirk for still enabled interrupts on Intel
Sandy Bridge GPUs") for some history.

[bhelgaas: add f67fd55fa96f reference, stable tag]
Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e85d23044ae0..176fb76ef4e2 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2953,6 +2953,7 @@ static void disable_igfx_irq(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0152, disable_igfx_irq);
 
 /*
  * Some devices may pass our check in pci_intx_mask_supported if
-- 
1.9.1

