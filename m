Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab3E0CcV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:32:21 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:40829 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3E0CcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:32:16 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <akpm@linux-foundation.org>
CC: <linux-pcmcia@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 23/24] drivers/pcmcia/pd6729: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:32:03 +0800
Message-ID: <1369621923-16368-1-git-send-email-libo.chen@huawei.com>
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
 drivers/pcmcia/pd6729.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/pcmcia/pd6729.c b/drivers/pcmcia/pd6729.c
index b29d97e..9a7fc88 100644
--- a/drivers/pcmcia/pd6729.c
+++ b/drivers/pcmcia/pd6729.c
@@ -775,15 +775,4 @@ static struct pci_driver pd6729_pci_driver = {
 	.remove		= pd6729_pci_remove,
 };
 
-static int pd6729_module_init(void)
-{
-	return pci_register_driver(&pd6729_pci_driver);
-}
-
-static void pd6729_module_exit(void)
-{
-	pci_unregister_driver(&pd6729_pci_driver);
-}
-
-module_init(pd6729_module_init);
-module_exit(pd6729_module_exit);
+module_pci_driver(pd6729_pci_driver);
-- 
1.7.1


