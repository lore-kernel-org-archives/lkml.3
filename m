Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3E0CbP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:31:15 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:23131 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756054Ab3E0C3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:29:13 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <ptyser@xes-inc.com>, <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>, <gregkh@linuxfoundation.org>
Subject: [PATCH 10/24] drivers/mfd/lpc_ich: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:28:56 +0800
Message-ID: <1369621736-34664-1-git-send-email-libo.chen@huawei.com>
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
 drivers/mfd/lpc_ich.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 9f12f91..06431df 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -973,18 +973,7 @@ static struct pci_driver lpc_ich_driver = {
 	.remove		= lpc_ich_remove,
 };
 
-static int __init lpc_ich_init(void)
-{
-	return pci_register_driver(&lpc_ich_driver);
-}
-
-static void __exit lpc_ich_exit(void)
-{
-	pci_unregister_driver(&lpc_ich_driver);
-}
-
-module_init(lpc_ich_init);
-module_exit(lpc_ich_exit);
+module_pci_driver(lpc_ich_driver);
 
 MODULE_AUTHOR("Aaron Sierra <asierra@xes-inc.com>");
 MODULE_DESCRIPTION("LPC interface for Intel ICH");
-- 
1.7.1


