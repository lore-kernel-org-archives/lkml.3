Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3E0CcG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:32:06 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:32442 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3E0CcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:32:03 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <matthew.garrett@nebula.com>
CC: <platform-driver-x86@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 14/24] drivers/platform/x86/intel_ips: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:31:33 +0800
Message-ID: <1369621893-11984-1-git-send-email-libo.chen@huawei.com>
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
 drivers/platform/x86/intel_ips.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/platform/x86/intel_ips.c b/drivers/platform/x86/intel_ips.c
index 5051aa9..18dcb58 100644
--- a/drivers/platform/x86/intel_ips.c
+++ b/drivers/platform/x86/intel_ips.c
@@ -1731,18 +1731,7 @@ static struct pci_driver ips_pci_driver = {
 	.shutdown = ips_shutdown,
 };
 
-static int __init ips_init(void)
-{
-	return pci_register_driver(&ips_pci_driver);
-}
-module_init(ips_init);
-
-static void ips_exit(void)
-{
-	pci_unregister_driver(&ips_pci_driver);
-	return;
-}
-module_exit(ips_exit);
+module_pci_driver(ips_pci_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jesse Barnes <jbarnes@virtuousgeek.org>");
-- 
1.7.1


