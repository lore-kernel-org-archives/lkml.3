Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519Ab3ICHgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 03:36:06 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:18808 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab3ICHgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 03:36:02 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 6/7] PCI: use pci_is_pcie() to simplify code
Date: Tue, 3 Sep 2013 15:35:14 +0800
Message-ID: <1378193715-25328-6-git-send-email-wangyijing@huawei.com>
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

Use pci_is_pcie() instead of pci_find_capability
to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/probe.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index eeb50bd..0fa9075 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -641,8 +641,7 @@ static void pci_set_bus_speed(struct pci_bus *bus)
 		return;
 	}
 
-	pos = pci_find_capability(bridge, PCI_CAP_ID_EXP);
-	if (pos) {
+	if (pci_is_pcie(bridge)) {
 		u32 linkcap;
 		u16 linksta;
 
-- 
1.7.1


