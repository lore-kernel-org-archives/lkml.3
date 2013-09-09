Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab3IINRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:17:03 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:44878 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab3IINQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:16:58 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>,
        Mike Marciniszyn <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>,
        Roland Dreier <roland@purestorage.com>
CC: <linux-kernel@vger.kernel.org>, Mark Einon <mark.einon@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        <linux-rdma@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 1/6] PCI: Export pcie_set_mps() and pcie_get_mps()
Date: Mon, 9 Sep 2013 21:13:03 +0800
Message-ID: <1378732388-4508-2-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
In-Reply-To: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export pcie_get_mps() and pcie_set_mps() functions,
so driver can use them to simplify code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/pci/pci.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b821a62..e35f7ec 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3972,6 +3972,7 @@ int pcie_get_mps(struct pci_dev *dev)
 
 	return 128 << ((ctl & PCI_EXP_DEVCTL_PAYLOAD) >> 5);
 }
+EXPORT_SYMBOL(pcie_get_mps);
 
 /**
  * pcie_set_mps - set PCI Express maximum payload size
@@ -3996,6 +3997,7 @@ int pcie_set_mps(struct pci_dev *dev, int mps)
 	return pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
 						  PCI_EXP_DEVCTL_PAYLOAD, v);
 }
+EXPORT_SYMBOL(pcie_set_mps);
 
 /**
  * pci_select_bars - Make BAR mask from the type of resource
-- 
1.7.1


