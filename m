Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab3E0Cch (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:32:37 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41096 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3E0Cca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:32:30 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <mchehab@redhat.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 17/24] drivers/media/pci/dm1105/dm1105: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:31:43 +0800
Message-ID: <1369621903-14768-1-git-send-email-libo.chen@huawei.com>
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
 drivers/media/pci/b2c2/flexcop-pci.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/b2c2/flexcop-pci.c b/drivers/media/pci/b2c2/flexcop-pci.c
index 44f8fb5..447afbd 100644
--- a/drivers/media/pci/b2c2/flexcop-pci.c
+++ b/drivers/media/pci/b2c2/flexcop-pci.c
@@ -432,18 +432,7 @@ static struct pci_driver flexcop_pci_driver = {
 	.remove   = flexcop_pci_remove,
 };
 
-static int __init flexcop_pci_module_init(void)
-{
-	return pci_register_driver(&flexcop_pci_driver);
-}
-
-static void __exit flexcop_pci_module_exit(void)
-{
-	pci_unregister_driver(&flexcop_pci_driver);
-}
-
-module_init(flexcop_pci_module_init);
-module_exit(flexcop_pci_module_exit);
+module_pci_driver(flexcop_pci_driver);
 
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_NAME);
-- 
1.7.1


