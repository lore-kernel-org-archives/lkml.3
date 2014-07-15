Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965029AbaGOW15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:27:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53893 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758074AbaGOVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:31:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 020/198] PCI: Add new ID for Intel GPU "spurious interrupt" quirk
Date: Tue, 15 Jul 2014 14:28:10 -0700
Message-Id: <1405459868-15089-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3a02717..fbc066d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2949,6 +2949,7 @@ static void disable_igfx_irq(struct pci_dev *dev)
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0102, disable_igfx_irq);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x010a, disable_igfx_irq);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_INTEL, 0x0152, disable_igfx_irq);
 
 /*
  * PCI devices which are on Intel chips can skip the 10ms delay
-- 
1.9.1

