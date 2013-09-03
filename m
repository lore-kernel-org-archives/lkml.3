Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab3ICHiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:38:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:18811 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab3ICHgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:36:03 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 4/7] x86/pci: use pcie_cap to simplify code
Date: Tue, 3 Sep 2013 15:35:12 +0800
Message-ID: <1378193715-25328-4-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1378193715-25328-1-git-send-email-wangyijing@huawei.com>
References: <1378193715-25328-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI core saves PCIe Cap offset in pcie_cap,
use pcie_cap to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 arch/x86/pci/fixup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index f5809fa..ee8330d 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -288,7 +288,7 @@ static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
 		 */
 		list_for_each_entry(dev, &pbus->devices, bus_list) {
 			/* There are 0 to 8 devices attached to this bus */
-			cap_base = pci_find_capability(dev, PCI_CAP_ID_EXP);
+			cap_base = dev->pcie_cap;
 			quirk_aspm_offset[GET_INDEX(pdev->device, dev->devfn)] = cap_base + 0x10;
 		}
 		pbus->ops = &quirk_pcie_aspm_ops;
-- 
1.7.1


