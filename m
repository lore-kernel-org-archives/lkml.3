Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030369Ab3E3KTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 06:19:08 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:37487 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab3E3KS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 06:18:56 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <liuj97@gmail.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 1/7] usb, chipidea: remove redundant D0 power state set
Date: Thu, 30 May 2013 18:18:00 +0800
Message-ID: <1369909080-38272-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci_enable_device() will set device power state to D0,
so it's no need to do it again in ci13xxx_pci_probe().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/usb/chipidea/ci13xxx_pci.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/chipidea/ci13xxx_pci.c b/drivers/usb/chipidea/ci13xxx_pci.c
index 4e1fc61..a2a6ac8 100644
--- a/drivers/usb/chipidea/ci13xxx_pci.c
+++ b/drivers/usb/chipidea/ci13xxx_pci.c
@@ -71,7 +71,6 @@ static int ci13xxx_pci_probe(struct pci_dev *pdev,
 		goto disable_device;
 	}
 
-	pci_set_power_state(pdev, PCI_D0);
 	pci_set_master(pdev);
 	pci_try_set_mwi(pdev);
 
-- 
1.7.1


