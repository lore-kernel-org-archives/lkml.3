Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965105Ab3HHNeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 09:34:46 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:11449 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951Ab3HHNep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:34:45 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: "David S. Miller" <davem@davemloft.net>
CC: Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        Michael Chan <mchan@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 16/16] tg3: clean up unnecessary MSI/MSI-X capability find
Date: Thu, 8 Aug 2013 21:03:12 +0800
Message-ID: <1375966992-33236-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI core will initialize device MSI/MSI-X capability in
pci_msi_init_pci_dev(). So device driver should use
pci_dev->msi_cap/msix_cap to determine whether the device
support MSI/MSI-X instead of using
pci_find_capability(pci_dev, PCI_CAP_ID_MSI/MSIX).
Access to PCIe device config space again will consume more time.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/broadcom/tg3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index ddebc7a..11cad77 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -15917,7 +15917,7 @@ static int tg3_get_invariants(struct tg3 *tp, const struct pci_device_id *ent)
 	 */
 	if (tg3_flag(tp, 5780_CLASS)) {
 		tg3_flag_set(tp, 40BIT_DMA_BUG);
-		tp->msi_cap = pci_find_capability(tp->pdev, PCI_CAP_ID_MSI);
+		tp->msi_cap = tp->pdev->msi_cap;
 	} else {
 		struct pci_dev *bridge = NULL;
 
-- 
1.7.1


