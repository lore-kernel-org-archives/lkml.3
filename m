Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab3IINRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:17:06 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:52446 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3IINRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:17:03 -0400
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
Subject: [PATCH 3/6] IB/qib: Use pci_is_root_bus() to check whether it is a root bus
Date: Mon, 9 Sep 2013 21:13:05 +0800
Message-ID: <1378732388-4508-4-git-send-email-wangyijing@huawei.com>
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

Use pci_is_root_bus() instead of "if (bus->parent)" statement
for better readability.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/infiniband/hw/qib/qib_pcie.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_pcie.c b/drivers/infiniband/hw/qib/qib_pcie.c
index c574ec7..3a5b99b 100644
--- a/drivers/infiniband/hw/qib/qib_pcie.c
+++ b/drivers/infiniband/hw/qib/qib_pcie.c
@@ -590,7 +590,7 @@ static int qib_tune_pcie_caps(struct qib_devdata *dd)
 
 	/* Find out supported and configured values for parent (root) */
 	parent = dd->pcidev->bus->self;
-	if (parent->bus->parent) {
+	if (!pci_is_root_bus(parent->bus)) {
 		qib_devinfo(dd->pcidev, "Parent not root\n");
 		goto bail;
 	}
-- 
1.7.1


