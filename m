Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3E0C3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:29:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:22924 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3E0C2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:28:54 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <JBottomley@parallels.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 04/24] drivers/scsi/initio: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:28:37 +0800
Message-ID: <1369621717-5860-1-git-send-email-libo.chen@huawei.com>
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
 drivers/scsi/initio.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
old mode 100644
new mode 100755
index 280d5af..1befc26
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2995,19 +2995,8 @@ static struct pci_driver initio_pci_driver = {
 	.remove		= initio_remove_one,
 };
 
-static int __init initio_init_driver(void)
-{
-	return pci_register_driver(&initio_pci_driver);
-}
-
-static void __exit initio_exit_driver(void)
-{
-	pci_unregister_driver(&initio_pci_driver);
-}
+module_pci_driver(initio_pci_driver);
 
 MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
 MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("GPL");
-
-module_init(initio_init_driver);
-module_exit(initio_exit_driver);
-- 
1.7.1


