Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab3FZBP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:15:26 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:8697 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FZBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:15:25 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Yijing Wang <wangyijing@huawei.com>,
        Paul Mackerras <paulus@samba.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, <linux-fbdev@vger.kernel.org>
Subject: [PATCH 3/9] aty128fb: use pdev->pm_cap instead of pci_find_capability(..,PCI_CAP_ID_PM)
Date: Wed, 26 Jun 2013 09:13:12 +0800
Message-ID: <1372209192-25380-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pci core has been saved pm cap register offset by pdev->pm_cap in pci_pm_init()
in init path. So we can use pdev->pm_cap instead of using
pci_find_capability(pdev, PCI_CAP_ID_PM) for better performance and simplified code.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org
---
 drivers/video/aty/aty128fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index 8c55011..a4dfe8c 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -2016,7 +2016,7 @@ static int aty128_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	aty128_init_engine(par);
 
-	par->pm_reg = pci_find_capability(pdev, PCI_CAP_ID_PM);
+	par->pm_reg = pdev->pm_cap;
 	par->pdev = pdev;
 	par->asleep = 0;
 	par->lock_blank = 0;
-- 
1.7.1


