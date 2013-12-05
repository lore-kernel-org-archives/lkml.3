Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131Ab3LELWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 06:22:39 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:3347 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753698Ab3LELWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 06:22:05 -0500
From: Yijing Wang <wangyijing@huawei.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 2/2] uwb: Use dev_is_pci() to check whether it is pci device
Date: Thu, 5 Dec 2013 19:21:42 +0800
Message-ID: <1386242502-29440-1-git-send-email-wangyijing@huawei.com>
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
 drivers/uwb/umc-bus.c   |    2 +-
 include/linux/uwb/umc.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/uwb/umc-bus.c b/drivers/uwb/umc-bus.c
index e3ed6ff..88a290f 100644
--- a/drivers/uwb/umc-bus.c
+++ b/drivers/uwb/umc-bus.c
@@ -85,7 +85,7 @@ int umc_match_pci_id(struct umc_driver *umc_drv, struct umc_dev *umc)
 	const struct pci_device_id *id_table = umc_drv->match_data;
 	struct pci_dev *pci;
 
-	if (umc->dev.parent->bus != &pci_bus_type)
+	if (!dev_is_pci(umc->dev.parent))
 		return 0;
 
 	pci = to_pci_dev(umc->dev.parent);
diff --git a/include/linux/uwb/umc.h b/include/linux/uwb/umc.h
index 891d1d5..ba82f03 100644
--- a/include/linux/uwb/umc.h
+++ b/include/linux/uwb/umc.h
@@ -143,7 +143,7 @@ int umc_match_pci_id(struct umc_driver *umc_drv, struct umc_dev *umc);
 static inline struct pci_dev *umc_parent_pci_dev(struct umc_dev *umc_dev)
 {
 	struct pci_dev *pci_dev = NULL;
-	if (umc_dev->dev.parent->bus == &pci_bus_type)
+	if (dev_is_pci(umc_dev->dev.parent))
 		pci_dev = to_pci_dev(umc_dev->dev.parent);
 	return pci_dev;
 }
-- 
1.7.1


