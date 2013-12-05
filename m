Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab3LELeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:34:50 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:7626 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3LELes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:34:48 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        "Yijing Wang" <wangyijing@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH] xen: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 19:34:05 +0800
Message-ID: <1386243245-34280-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI standard marco dev_is_pci() instead of directly compare
pci_bus_type to check whether it is pci device.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/xen/dbgp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/xen/dbgp.c b/drivers/xen/dbgp.c
index f3ccc80..8145a59 100644
--- a/drivers/xen/dbgp.c
+++ b/drivers/xen/dbgp.c
@@ -19,7 +19,7 @@ static int xen_dbgp_op(struct usb_hcd *hcd, int op)
 	dbgp.op = op;
 
 #ifdef CONFIG_PCI
-	if (ctrlr->bus == &pci_bus_type) {
+	if (dev_is_pci(ctrlr)) {
 		const struct pci_dev *pdev = to_pci_dev(ctrlr);
 
 		dbgp.u.pci.seg = pci_domain_nr(pdev->bus);
-- 
1.7.1


