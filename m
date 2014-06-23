Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaFWWg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:36:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbaFWWg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:36:28 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] PCI: Add bridge DMA alias quirk for Intel 82801
To: linux-pci@vger.kernel.org
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Date: Mon, 23 Jun 2014 16:36:25 -0600
Message-ID: <20140623223530.13445.94886.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This bridge sometimes shows up as a root complex device and sometimes
as a discrete PCIe-to-PCI bridge.  Testing indicates that in the
latter case, we need to enable the PCIe bridge DMA alias quirk.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Reported-by: Milos Kaurin <milos.kaurin@gmail.com>
Tested-by: Milos Kaurin <milos.kaurin@gmail.com>
---

 drivers/pci/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 78a7df6..460c354 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3405,6 +3405,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1080,
 DECLARE_PCI_FIXUP_HEADER(0x10e3, 0x8113, quirk_use_pcie_bridge_dma_alias);
 /* ITE 8892, https://bugzilla.kernel.org/show_bug.cgi?id=73551 */
 DECLARE_PCI_FIXUP_HEADER(0x1283, 0x8892, quirk_use_pcie_bridge_dma_alias);
+/* Intel 82801, https://bugzilla.kernel.org/show_bug.cgi?id=44881#c49 */
+DECLARE_PCI_FIXUP_HEADER(0x8086, 0x244e, quirk_use_pcie_bridge_dma_alias);
 
 /*
  * AMD has indicated that the devices below do not support peer-to-peer

