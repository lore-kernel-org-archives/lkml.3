Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab3E0Ccz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:32:55 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41348 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab3E0Ccw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:32:52 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>, <gregkh@linuxfoundation.org>
Subject: [PATCH 15/24] drivers/memstick/host/jmb38x_ms: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:31:36 +0800
Message-ID: <1369621896-6728-1-git-send-email-libo.chen@huawei.com>
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
 drivers/memstick/host/jmb38x_ms.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index c37d375..aeabaa5 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -1046,20 +1046,9 @@ static struct pci_driver jmb38x_ms_driver = {
 	.resume = jmb38x_ms_resume
 };
 
-static int __init jmb38x_ms_init(void)
-{
-	return pci_register_driver(&jmb38x_ms_driver);
-}
-
-static void __exit jmb38x_ms_exit(void)
-{
-	pci_unregister_driver(&jmb38x_ms_driver);
-}
+module_pci_driver(jmb38x_ms_driver);
 
 MODULE_AUTHOR("Alex Dubov");
 MODULE_DESCRIPTION("JMicron jmb38x MemoryStick driver");
 MODULE_LICENSE("GPL");
 MODULE_DEVICE_TABLE(pci, jmb38x_ms_id_tbl);
-
-module_init(jmb38x_ms_init);
-module_exit(jmb38x_ms_exit);
-- 
1.7.1


