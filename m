Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab3F0Mw7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:52:59 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:23299 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab3F0Mw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:52:56 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: David Airlie <airlied@linux.ie>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH 1/6] char/agp: replace numeric with standard PM state macros
Date: Thu, 27 Jun 2013 20:52:36 +0800
Message-ID: <1372337556-28448-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use standard PM state macros PCI_Dx instead of numeric 0/1/2..

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
---
 drivers/char/agp/ati-agp.c    |    4 ++--
 drivers/char/agp/nvidia-agp.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/agp/ati-agp.c b/drivers/char/agp/ati-agp.c
index 0628d7b..03c1dc1 100644
--- a/drivers/char/agp/ati-agp.c
+++ b/drivers/char/agp/ati-agp.c
@@ -236,14 +236,14 @@ static int ati_configure(void)
 static int agp_ati_suspend(struct pci_dev *dev, pm_message_t state)
 {
 	pci_save_state(dev);
-	pci_set_power_state(dev, 3);
+	pci_set_power_state(dev, PCI_D3hot);
 
 	return 0;
 }
 
 static int agp_ati_resume(struct pci_dev *dev)
 {
-	pci_set_power_state(dev, 0);
+	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
 
 	return ati_configure();
diff --git a/drivers/char/agp/nvidia-agp.c b/drivers/char/agp/nvidia-agp.c
index 62be3ec..be42a23 100644
--- a/drivers/char/agp/nvidia-agp.c
+++ b/drivers/char/agp/nvidia-agp.c
@@ -399,8 +399,8 @@ static void agp_nvidia_remove(struct pci_dev *pdev)
 #ifdef CONFIG_PM
 static int agp_nvidia_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	pci_save_state (pdev);
-	pci_set_power_state (pdev, 3);
+	pci_save_state(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
 
 	return 0;
 }
@@ -408,7 +408,7 @@ static int agp_nvidia_suspend(struct pci_dev *pdev, pm_message_t state)
 static int agp_nvidia_resume(struct pci_dev *pdev)
 {
 	/* set power state 0 and restore PCI space */
-	pci_set_power_state (pdev, 0);
+	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
 	/* reconfigure AGP hardware again */
-- 
1.7.1


