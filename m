Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932590Ab3ICHgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:36:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:18814 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932482Ab3ICHgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:36:05 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 3/7] powerpc/pci: use pci_is_pcie() to simplify code
Date: Tue, 3 Sep 2013 15:35:11 +0800
Message-ID: <1378193715-25328-3-git-send-email-wangyijing@huawei.com>
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

Use pci_is_pcie() to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
---
 arch/powerpc/kernel/eeh.c     |    3 +--
 arch/powerpc/sysdev/fsl_pci.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
index 39954fe..b0bd41a 100644
--- a/arch/powerpc/kernel/eeh.c
+++ b/arch/powerpc/kernel/eeh.c
@@ -189,8 +189,7 @@ static size_t eeh_gather_pci_data(struct eeh_dev *edev, char * buf, size_t len)
 	}
 
 	/* If PCI-E capable, dump PCI-E cap 10, and the AER */
-	cap = pci_find_capability(dev, PCI_CAP_ID_EXP);
-	if (cap) {
+	if (pci_is_pcie(dev)) {
 		n += scnprintf(buf+n, len-n, "pci-e cap10:\n");
 		printk(KERN_WARNING
 		       "EEH: PCI-E capabilities and status follow:\n");
diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 46ac1dd..5402a1d 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -41,7 +41,7 @@ static void quirk_fsl_pcie_header(struct pci_dev *dev)
 	u8 hdr_type;
 
 	/* if we aren't a PCIe don't bother */
-	if (!pci_find_capability(dev, PCI_CAP_ID_EXP))
+	if (!pci_is_pcie(dev))
 		return;
 
 	/* if we aren't in host mode don't bother */
-- 
1.7.1


