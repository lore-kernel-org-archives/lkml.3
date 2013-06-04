Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897Ab3FDHI6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:08:58 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:23530 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834Ab3FDHI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:08:56 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>,
        Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        <linux-wireless@vger.kernel.org>
Subject: [RESEND][PATCH 3/7] net, ipw2x00: remove redundant D0 power state set
Date: Tue, 4 Jun 2013 15:07:54 +0800
Message-ID: <1370329674-8360-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci_enable_device() will set device power state to D0,
so it's no need to do it again in ipw2100_pci_init_one().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>
Cc: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ipw2x00/ipw2100.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
index 15920aa..f8ab193 100644
--- a/drivers/net/wireless/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/ipw2x00/ipw2100.c
@@ -6242,8 +6242,6 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pci_dev, 0x40, val & 0xffff00ff);
 
-	pci_set_power_state(pci_dev, PCI_D0);
-
 	if (!ipw2100_hw_is_adapter_in_system(dev)) {
 		printk(KERN_WARNING DRV_NAME
 		       "Device not found via register read.\n");
-- 
1.7.1


