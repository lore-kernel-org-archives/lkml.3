Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab3E0CcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:32:19 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:32719 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab3E0CcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:32:16 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <akpm@linux-foundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 13/24] drivers/uwb/whci: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:31:29 +0800
Message-ID: <1369621889-26536-1-git-send-email-libo.chen@huawei.com>
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
 drivers/uwb/whci.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/uwb/whci.c b/drivers/uwb/whci.c
index f48093e..deeeba4 100644
--- a/drivers/uwb/whci.c
+++ b/drivers/uwb/whci.c
@@ -253,18 +253,7 @@ static struct pci_driver whci_driver = {
 	.remove   = whci_remove,
 };
 
-static int __init whci_init(void)
-{
-	return pci_register_driver(&whci_driver);
-}
-
-static void __exit whci_exit(void)
-{
-	pci_unregister_driver(&whci_driver);
-}
-
-module_init(whci_init);
-module_exit(whci_exit);
+module_pci_driver(whci_driver);
 
 MODULE_DESCRIPTION("WHCI UWB Multi-interface Controller enumerator");
 MODULE_AUTHOR("Cambridge Silicon Radio Ltd.");
-- 
1.7.1


