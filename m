Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968158Ab3E3KYl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:24:41 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:12474 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968016Ab3E3KYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:24:35 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Paul Zimmerman <paulz@synopsys.com>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 5/7] dwc2: remove redundant D0 power state set
Date: Thu, 30 May 2013 18:24:07 +0800
Message-ID: <1369909447-36368-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci_enable_device() will set device power state to D0,
so it's no need to do it again in dwc2_driver_probe().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/staging/dwc2/pci.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/dwc2/pci.c b/drivers/staging/dwc2/pci.c
index 69c65eb..6a196c2 100644
--- a/drivers/staging/dwc2/pci.c
+++ b/drivers/staging/dwc2/pci.c
@@ -131,8 +131,6 @@ static int dwc2_driver_probe(struct pci_dev *dev,
 	if (!hsotg)
 		return -ENOMEM;
 
-	pci_set_power_state(dev, PCI_D0);
-
 	hsotg->dev = &dev->dev;
 	hsotg->regs = devm_request_and_ioremap(&dev->dev, &dev->resource[0]);
 	if (!hsotg->regs)
-- 
1.7.1


