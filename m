Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab3FCCMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:12:33 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:5621 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab3FCCMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:12:24 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Jiang Liu <liuj97@gmail.com>, Yijing Wang <wangyijing@huawei.com>,
        Felipe Balbi <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH 2/7] usb, dwc3: remove redundant D0 power state set
Date: Mon, 3 Jun 2013 10:12:02 +0800
Message-ID: <1370225522-11384-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci_enable_device() will set device power state to D0,
so it's no need to do it again in dwc3_pci_probe().

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: linux-omap@vger.kernel.org
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/dwc3/dwc3-pci.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 227d4a7..c068608 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -133,7 +133,6 @@ static int dwc3_pci_probe(struct pci_dev *pci,
 		return -ENODEV;
 	}
 
-	pci_set_power_state(pci, PCI_D0);
 	pci_set_master(pci);
 
 	ret = dwc3_pci_register_phys(glue);
-- 
1.7.1


