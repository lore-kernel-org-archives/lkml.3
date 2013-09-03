Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab3ICHgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:36:20 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:46176 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab3ICHgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:36:07 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        <e1000-devel@lists.sourceforge.net>, <netdev@vger.kernel.org>
Subject: [PATCH 5/7] ixgbe: use pcie_capability_read_word() to simplify code
Date: Tue, 3 Sep 2013 15:35:13 +0800
Message-ID: <1378193715-25328-5-git-send-email-wangyijing@huawei.com>
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

use pcie_capability_read_word() to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: e1000-devel@lists.sourceforge.net
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index bad8f14..bfa0b06 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -152,7 +152,6 @@ MODULE_VERSION(DRV_VERSION);
 static int ixgbe_read_pci_cfg_word_parent(struct ixgbe_adapter *adapter,
 					  u32 reg, u16 *value)
 {
-	int pos = 0;
 	struct pci_dev *parent_dev;
 	struct pci_bus *parent_bus;
 
@@ -164,11 +163,10 @@ static int ixgbe_read_pci_cfg_word_parent(struct ixgbe_adapter *adapter,
 	if (!parent_dev)
 		return -1;
 
-	pos = pci_find_capability(parent_dev, PCI_CAP_ID_EXP);
-	if (!pos)
+	if (!pci_is_pcie(parent_dev))
 		return -1;
 
-	pci_read_config_word(parent_dev, pos + reg, value);
+	pcie_capability_read_word(parent_dev, reg, value);
 	return 0;
 }
 
-- 
1.7.1


