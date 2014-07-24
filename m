Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935143AbaGXKSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:18:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54762 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934350AbaGXJrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:47:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 042/128] PCI: Fix incorrect vgaarb conditional in WARN_ON()
Date: Thu, 24 Jul 2014 10:44:51 +0100
Message-Id: <1406195177-8656-43-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 67ebd8140dc8923c65451fa0f6a8eee003c4dcd3 upstream.

3448a19da479 "vgaarb: use bridges to control VGA routing where possible"
added the "flags & PCI_VGA_STATE_CHANGE_DECODES" condition to an existing
WARN_ON(), but used bitwise AND (&) instead of logical AND (&&), so the
condition is never true.  Replace with logical AND.

Found by Coverity (CID 142811).

Fixes: 3448a19da479 "vgaarb: use bridges to control VGA routing where possible"
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: David Airlie <airlied@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b5352fcf5df7..b25b53e41a7e 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3669,7 +3669,7 @@ int pci_set_vga_state(struct pci_dev *dev, bool decode,
 	u16 cmd;
 	int rc;
 
-	WARN_ON((flags & PCI_VGA_STATE_CHANGE_DECODES) & (command_bits & ~(PCI_COMMAND_IO|PCI_COMMAND_MEMORY)));
+	WARN_ON((flags & PCI_VGA_STATE_CHANGE_DECODES) && (command_bits & ~(PCI_COMMAND_IO|PCI_COMMAND_MEMORY)));
 
 	/* ARCH specific VGA enables */
 	rc = pci_set_vga_state_arch(dev, decode, command_bits, flags);
-- 
1.9.1

