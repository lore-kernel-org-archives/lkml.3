Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab3E0Cci (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:32:38 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41098 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756252Ab3E0Cca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:32:30 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <mchehab@redhat.com>
CC: <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 21/24] drivers/media/pci/pt1/pt1: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:31:56 +0800
Message-ID: <1369621916-12580-1-git-send-email-libo.chen@huawei.com>
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
 drivers/media/pci/pt1/pt1.c |   15 +--------------
 1 files changed, 1 insertions(+), 14 deletions(-)

diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index e921108..75ce142 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -1225,20 +1225,7 @@ static struct pci_driver pt1_driver = {
 	.id_table	= pt1_id_table,
 };
 
-
-static int __init pt1_init(void)
-{
-	return pci_register_driver(&pt1_driver);
-}
-
-
-static void __exit pt1_cleanup(void)
-{
-	pci_unregister_driver(&pt1_driver);
-}
-
-module_init(pt1_init);
-module_exit(pt1_cleanup);
+module_pci_driver(pt1_driver);
 
 MODULE_AUTHOR("Takahito HIRANO <hiranotaka@zng.info>");
 MODULE_DESCRIPTION("Earthsoft PT1/PT2 Driver");
-- 
1.7.1


