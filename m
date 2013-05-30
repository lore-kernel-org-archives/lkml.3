Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968187Ab3E3K0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:26:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:20095 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968055Ab3E3K0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:26:31 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>
CC: <linux-kernel@vger.kernel.org>, <linux-driver@qlogic.com>,
        <netdev@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <liuj97@gmail.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 6/7] qlcnic: remove redundant D0 power state set
Date: Thu, 30 May 2013 18:26:09 +0800
Message-ID: <1369909569-33096-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci_enable_device() will set device power state to D0,
so it's no need to do it again in qlcnic_attach_func().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index aeb26a8..3585c2c 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -3219,7 +3219,6 @@ static int qlcnic_attach_func(struct pci_dev *pdev)
 	if (err)
 		return err;
 
-	pci_set_power_state(pdev, PCI_D0);
 	pci_set_master(pdev);
 	pci_restore_state(pdev);
 
-- 
1.7.1


