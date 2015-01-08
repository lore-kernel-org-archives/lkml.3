Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbbAHRGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:06:34 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58115 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbbAHRGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:06:31 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: <linux-arm-kernel@lists.infradead.org>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: [PATCH v2 5/8] PCI/MSI: Let pci_msi_get_domain use struct device's msi_domain
Date: Thu,  8 Jan 2015 17:06:09 +0000
Message-Id: <1420736772-11088-6-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com>
References: <1420736772-11088-1-git-send-email-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we can easily find which MSI domain a PCI device is
using, use dev_get_msi_domain as a way to retrieve the information.

The original code is still used as a fallback.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/pci/msi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index fd60806..003040b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -41,7 +41,8 @@ static struct irq_domain *pci_msi_get_domain(struct pci_dev *dev)
 {
 	struct irq_domain *domain = NULL;
 
-	if (dev->bus->msi)
+	domain = dev_get_msi_domain(&dev->dev);
+	if (!domain && dev->bus->msi)
 		domain = dev->bus->msi->domain;
 	if (!domain)
 		domain = arch_get_pci_msi_domain(dev);
-- 
2.1.4

