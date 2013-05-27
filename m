Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab3E0Cd6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:33:58 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41903 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756332Ab3E0Cdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:33:41 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <mchehab@redhat.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 19/24] drivers/media/pci/dm1105/dm1105: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:31:49 +0800
Message-ID: <1369621909-38264-1-git-send-email-libo.chen@huawei.com>
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
 drivers/media/pci/dm1105/dm1105.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 026767b..ab797fe 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1241,18 +1241,7 @@ static struct pci_driver dm1105_driver = {
 	.remove = dm1105_remove,
 };
 
-static int __init dm1105_init(void)
-{
-	return pci_register_driver(&dm1105_driver);
-}
-
-static void __exit dm1105_exit(void)
-{
-	pci_unregister_driver(&dm1105_driver);
-}
-
-module_init(dm1105_init);
-module_exit(dm1105_exit);
+module_pci_driver(dm1105_driver);
 
 MODULE_AUTHOR("Igor M. Liplianin <liplianin@me.by>");
 MODULE_DESCRIPTION("SDMC DM1105 DVB driver");
-- 
1.7.1


