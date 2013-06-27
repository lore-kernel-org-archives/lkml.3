Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3F0M5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:57:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:57601 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3F0M5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:57:51 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>,
        Jiri Kosina <trivial@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Hanjun Guo <guohanjun@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Devendra Naga <devendra.aaru@gmail.com>,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, <devel@driverdev.osuosl.org>
Subject: [PATCH 4/6] vt6655/trivial: replace numeric with standard PM state macros
Date: Thu, 27 Jun 2013 20:57:23 +0800
Message-ID: <1372337843-24624-1-git-send-email-wangyijing@huawei.com>
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
Cc: Forest Bond <forest@alittletooquiet.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>
Cc :Joe Perches <joe@perches.com>
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/staging/vt6655/device_main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 08b250f..7f36a71 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -3370,8 +3370,8 @@ viawget_resume(struct pci_dev *pcid)
 	PSMgmtObject  pMgmt = pDevice->pMgmt;
 	int power_status;   // to silence the compiler
 
-	power_status = pci_set_power_state(pcid, 0);
-	power_status = pci_enable_wake(pcid, 0, 0);
+	power_status = pci_set_power_state(pcid, PCI_D0);
+	power_status = pci_enable_wake(pcid, PCI_D0, 0);
 	pci_restore_state(pcid);
 	if (netif_running(pDevice->dev)) {
 		spin_lock_irq(&pDevice->lock);
-- 
1.7.1


