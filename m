Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab3E0C30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:29:26 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:23264 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098Ab3E0C3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:29:23 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <maximlevitsky@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>, <gregkh@linuxfoundation.org>
Subject: [PATCH 12/24] drivers/memstick/host/r592: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:29:07 +0800
Message-ID: <1369621747-6628-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/memstick/host/r592.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index 9718661..1b6e913 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -884,18 +884,7 @@ static struct pci_driver r852_pci_driver = {
 	.driver.pm	= &r592_pm_ops,
 };
 
-static __init int r592_module_init(void)
-{
-	return pci_register_driver(&r852_pci_driver);
-}
-
-static void __exit r592_module_exit(void)
-{
-	pci_unregister_driver(&r852_pci_driver);
-}
-
-module_init(r592_module_init);
-module_exit(r592_module_exit);
+module_pci_driver(r852_pci_driver);
 
 module_param_named(enable_dma, r592_enable_dma, bool, S_IRUGO);
 MODULE_PARM_DESC(enable_dma, "Enable usage of the DMA (default)");
-- 
1.7.1


