Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097AbaKDMDX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:03:23 -0500
Received: from mga11.intel.com ([192.55.52.93]:60231 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069AbaKDMDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:03:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616767282"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [Patch Part2 v4 20/31] PCI/MSI: Kill redundant calling for irq_set_msi_desc() for MSIx interrupts
Date: Tue,  4 Nov 2014 20:01:54 +0800
Message-Id: <1415102525-9898-21-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's arch_setup_msi_irq()/arch_setup_msi_irqs()'s responsibility to call
irq_set_msi_desc() to associate IRQ descriptors and MSI descriptors,
so kill the redundant call of irq_set_msi_desc() for MSIx interrupts
in PCI MSI core.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/pci/msi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index afe974600c7d..da181c59394b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -685,7 +685,6 @@ static void msix_program_entries(struct pci_dev *dev,
 						PCI_MSIX_ENTRY_VECTOR_CTRL;
 
 		entries[i].vector = entry->irq;
-		irq_set_msi_desc(entry->irq, entry);
 		entry->masked = readl(entry->mask_base + offset);
 		msix_mask_irq(entry, 1);
 		i++;
-- 
1.7.10.4

