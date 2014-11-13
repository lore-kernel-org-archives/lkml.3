Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbaKMLky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:40:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:39574 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932583AbaKMLkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:40:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,376,1413270000"; 
   d="scan'208";a="607188062"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Alexander Gordeev <agordeev@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [Patch V1 1/6] PCI, MSI: Fix errors caused by commit e5f1a59c4e12
Date: Thu, 13 Nov 2014 19:43:43 +0800
Message-Id: <1415879029-20098-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415879029-20098-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better to fold into commit e5f1a59c4e12 "PCI/MSI: Rename write_msi_msg()
to pci_write_msi_msg()".

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/pci/msi.c   |    2 +-
 include/linux/msi.h |    2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 564850b1316e..9c53b865cb1b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1084,7 +1084,7 @@ void pci_msi_domain_write_msg(struct irq_data *irq_data, struct msi_msg *msg)
 	 * MSI message denotes a contiguous group of IRQs, written for 0th IRQ.
 	 */
 	if (desc->irq == irq_data->irq)
-		pci_write_msi_msg(desc, msg);
+		__pci_write_msi_msg(desc, msg);
 }
 
 /*
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 8112a17cdca1..190c7abbec84 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -44,11 +44,9 @@ struct msi_desc {
 	struct msi_msg msg;
 };
 
-#ifdef CONFIG_PCI_MSI
 void __pci_read_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void __pci_write_msi_msg(struct msi_desc *entry, struct msi_msg *msg);
 void pci_write_msi_msg(unsigned int irq, struct msi_msg *msg);
-#endif
 
 /*
  * The arch hooks to setup up msi irqs. Those functions are
-- 
1.7.10.4

