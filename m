Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756853Ab3FCCMn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:12:43 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5759 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab3FCCMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:12:33 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <liuj97@gmail.com>, Yijing Wang <wangyijing@huawei.com>,
        Paul Zimmerman <paulz@synopsys.com>, <linux-usb@vger.kernel.org>,
        <devel@driverdev.osuosl.org>
Subject: [PATCH 5/7] dwc2: remove redundant D0 power state set
Date: Mon, 3 Jun 2013 10:12:15 +0800
Message-ID: <1370225535-11388-1-git-send-email-wangyijing@huawei.com>
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

Acked-by: Paul Zimmerman <paulz@synopsys.com>
Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Paul Zimmerman <paulz@synopsys.com>
Cc: linux-usb@vger.kernel.org
Cc: devel@driverdev.osuosl.org
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


