Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3E0CcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:32:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:40747 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779Ab3E0CcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:32:08 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <mchehab@redhat.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 20/24] drivers/media/pci/pluto2/pluto2: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:31:53 +0800
Message-ID: <1369621913-30532-1-git-send-email-libo.chen@huawei.com>
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
 drivers/media/pci/pluto2/pluto2.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
index 2290fae..4938285 100644
--- a/drivers/media/pci/pluto2/pluto2.c
+++ b/drivers/media/pci/pluto2/pluto2.c
@@ -796,18 +796,7 @@ static struct pci_driver pluto2_driver = {
 	.remove = pluto2_remove,
 };
 
-static int __init pluto2_init(void)
-{
-	return pci_register_driver(&pluto2_driver);
-}
-
-static void __exit pluto2_exit(void)
-{
-	pci_unregister_driver(&pluto2_driver);
-}
-
-module_init(pluto2_init);
-module_exit(pluto2_exit);
+module_pci_driver(pluto2_driver);
 
 MODULE_AUTHOR("Andreas Oberritter <obi@linuxtv.org>");
 MODULE_DESCRIPTION("Pluto2 driver");
-- 
1.7.1


