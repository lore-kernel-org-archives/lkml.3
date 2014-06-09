Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753861AbaFISnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:43:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaFISnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:43:32 -0400
Subject: [PATCH] PCI: Add bridge DMA alias quirk for ITE bridge
From: Alex Williamson <alex.williamson@redhat.com>
To: linux-pci@vger.kernel.org
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org, rwarsow@gmx.de
Date: Mon, 09 Jun 2014 12:43:25 -0600
Message-ID: <20140609184157.17500.84469.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Link: https://bugzilla.kernel.org/show_bug.cgi?id=73551
Reported-by: rwarsow@gmx.de
Tested-by: rwarsow@gmx.de
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

One more for the pci/iommu branch

 drivers/pci/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index ab620ac..533cd0d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3407,6 +3407,8 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ASMEDIA, 0x1080,
 			 quirk_use_pcie_bridge_dma_alias);
 /* Tundra 8113, https://bugzilla.kernel.org/show_bug.cgi?id=44881#c43 */
 DECLARE_PCI_FIXUP_HEADER(0x10e3, 0x8113, quirk_use_pcie_bridge_dma_alias);
+/* ITE 8892, https://bugzilla.kernel.org/show_bug.cgi?id=73551 */
+DECLARE_PCI_FIXUP_HEADER(0x1283, 0x8892, quirk_use_pcie_bridge_dma_alias);
 
 static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
 {

