Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbaAGA4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 19:56:10 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:43114 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757770AbaAGA4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 19:56:05 -0500
Subject: [PATCH v7 07/15] agp/intel: Rename gtt_bus_addr to gtt_phys_addr
To: linux-pci@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: David Airlie <airlied@linux.ie>, Yinghai Lu <yinghai@kernel.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Date: Mon, 06 Jan 2014 17:56:02 -0700
Message-ID: <20140107005602.10786.2964.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140107005003.10786.85164.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only use of gtt_bus_addr is as an argument to ioremap(), so it is a CPU
physical address, not a bus address.  Rename it to gtt_phys_addr to reflect
this.

No functional change.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/char/agp/intel-gtt.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index b8e2014cb9cb..54202ffcf467 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -64,7 +64,7 @@ static struct _intel_private {
 	struct pci_dev *pcidev;	/* device one */
 	struct pci_dev *bridge_dev;
 	u8 __iomem *registers;
-	phys_addr_t gtt_bus_addr;
+	phys_addr_t gtt_phys_addr;
 	u32 PGETBL_save;
 	u32 __iomem *gtt;		/* I915G */
 	bool clear_fake_agp; /* on first access via agp, fill with scratch */
@@ -191,7 +191,7 @@ static int i810_setup(void)
 	writel(virt_to_phys(gtt_table) | I810_PGETBL_ENABLED,
 	       intel_private.registers+I810_PGETBL_CTL);
 
-	intel_private.gtt_bus_addr = reg_addr + I810_PTE_BASE;
+	intel_private.gtt_phys_addr = reg_addr + I810_PTE_BASE;
 
 	if ((readl(intel_private.registers+I810_DRAM_CTL)
 		& I810_DRAM_ROW_0) == I810_DRAM_ROW_0_SDRAM) {
@@ -636,10 +636,10 @@ static int intel_gtt_init(void)
 
 	intel_private.gtt = NULL;
 	if (intel_gtt_can_wc())
-		intel_private.gtt = ioremap_wc(intel_private.gtt_bus_addr,
+		intel_private.gtt = ioremap_wc(intel_private.gtt_phys_addr,
 					       gtt_map_size);
 	if (intel_private.gtt == NULL)
-		intel_private.gtt = ioremap(intel_private.gtt_bus_addr,
+		intel_private.gtt = ioremap(intel_private.gtt_phys_addr,
 					    gtt_map_size);
 	if (intel_private.gtt == NULL) {
 		intel_private.driver->cleanup();
@@ -796,7 +796,7 @@ static int i830_setup(void)
 	if (!intel_private.registers)
 		return -ENOMEM;
 
-	intel_private.gtt_bus_addr = reg_addr + I810_PTE_BASE;
+	intel_private.gtt_phys_addr = reg_addr + I810_PTE_BASE;
 
 	return 0;
 }
@@ -1123,13 +1123,13 @@ static int i9xx_setup(void)
 	case 3:
 		pci_read_config_dword(intel_private.pcidev,
 				      I915_PTEADDR, &gtt_addr);
-		intel_private.gtt_bus_addr = gtt_addr;
+		intel_private.gtt_phys_addr = gtt_addr;
 		break;
 	case 5:
-		intel_private.gtt_bus_addr = reg_addr + MB(2);
+		intel_private.gtt_phys_addr = reg_addr + MB(2);
 		break;
 	default:
-		intel_private.gtt_bus_addr = reg_addr + KB(512);
+		intel_private.gtt_phys_addr = reg_addr + KB(512);
 		break;
 	}
 

