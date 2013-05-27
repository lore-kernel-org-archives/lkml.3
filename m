Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab3E0C3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:29:32 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:23370 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756009Ab3E0C33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:29:29 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <davem@davemloft.net>
CC: <linux-ide@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 07/24] drivers/ide/delkin_cb: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:28:46 +0800
Message-ID: <1369621726-13828-1-git-send-email-libo.chen@huawei.com>
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
 drivers/ide/delkin_cb.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/ide/delkin_cb.c b/drivers/ide/delkin_cb.c
index 7e27d32..300daab 100644
--- a/drivers/ide/delkin_cb.c
+++ b/drivers/ide/delkin_cb.c
@@ -173,18 +173,7 @@ static struct pci_driver delkin_cb_pci_driver = {
 	.resume		= delkin_cb_resume,
 };
 
-static int __init delkin_cb_init(void)
-{
-	return pci_register_driver(&delkin_cb_pci_driver);
-}
-
-static void __exit delkin_cb_exit(void)
-{
-	pci_unregister_driver(&delkin_cb_pci_driver);
-}
-
-module_init(delkin_cb_init);
-module_exit(delkin_cb_exit);
+module_pci_driver(delkin_cb_pci_driver);
 
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("Basic support for Delkin/ASKA/Workbit Cardbus IDE");
-- 
1.7.1


