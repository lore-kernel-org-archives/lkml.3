Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3E0Cc2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:32:28 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:40922 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab3E0CcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:32:24 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <akpm@linux-foundation.org>
CC: <linux-pcmcia@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 24/24] drivers/pcmcia/yenta_socket: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:32:06 +0800
Message-ID: <1369621926-22548-1-git-send-email-libo.chen@huawei.com>
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
 drivers/pcmcia/yenta_socket.c |   16 +---------------
 1 files changed, 1 insertions(+), 15 deletions(-)

diff --git a/drivers/pcmcia/yenta_socket.c b/drivers/pcmcia/yenta_socket.c
index 6b4ff09..dc18a3a 100644
--- a/drivers/pcmcia/yenta_socket.c
+++ b/drivers/pcmcia/yenta_socket.c
@@ -1439,20 +1439,6 @@ static struct pci_driver yenta_cardbus_driver = {
 	.driver.pm	= YENTA_PM_OPS,
 };
 
-
-static int __init yenta_socket_init(void)
-{
-	return pci_register_driver(&yenta_cardbus_driver);
-}
-
-
-static void __exit yenta_socket_exit(void)
-{
-	pci_unregister_driver(&yenta_cardbus_driver);
-}
-
-
-module_init(yenta_socket_init);
-module_exit(yenta_socket_exit);
+module_pci_driver(yenta_cardbus_driver);
 
 MODULE_LICENSE("GPL");
-- 
1.7.1


