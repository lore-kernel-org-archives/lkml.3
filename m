Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbaGZCoF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 22:44:05 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:6660 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaGZCnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 22:43:49 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: <linux-kernel@vger.kernel.org>
CC: Xinwei Hu <huxinwei@huawei.com>, Wuyun <wuyun.wu@huawei.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <Paul.Mundt@huawei.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        "Marc Zyngier" <marc.zyngier@arm.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, <linux-arch@vger.kernel.org>,
        <arnab.basu@freescale.com>,
        <virtualization@lists.linux-foundation.org>,
        Hanjun Guo <guohanjun@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [RFC PATCH 06/11] PCI/MSI: Save MSI irq in PCI MSI layer
Date: Sat, 26 Jul 2014 11:08:43 +0800
Message-ID: <1406344128-27055-7-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
References: <1406344128-27055-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.166]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save MSI irq in PCI MSI layer, this is preparation
for generic MSI.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/msi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 21b16e0..f96dd38 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -650,8 +650,6 @@ static int msi_capability_init(struct pci_dev *dev, int nvec)
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, 1);
 	dev->msi_enabled = 1;
-
-	dev->irq = entry->irq;
 	return 0;
 }
 
@@ -1059,6 +1057,7 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 {
 	int nvec;
 	int rc;
+	struct msi_desc *entry;
 
 	if (dev->current_state != PCI_D0)
 		return -EINVAL;
@@ -1114,6 +1113,8 @@ int pci_enable_msi_range(struct pci_dev *dev, int minvec, int maxvec)
 		return rc;
 	}
 
+	entry = list_entry(dev->msi_list.next, struct msi_desc, list);
+	dev->irq = entry->irq;
 	return nvec;
 }
 EXPORT_SYMBOL(pci_enable_msi_range);
-- 
1.7.1

