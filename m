Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3E0Cv7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:51:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:14842 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab3E0Cv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:51:58 -0400
Message-ID: <51A2CA20.6020505@huawei.com>
Date: Mon, 27 May 2013 10:51:12 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: <JBottomley@parallels.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <gregkh@linuxfoundation.org>,
        Libo Chen <libo.chen@huawei.com>
Subject: [PATCH RESEND 01/24] drivers/scsi/a100u2w: Convert to module_pci_driver
References: <1369621707-6764-1-git-send-email-libo.chen@huawei.com>
In-Reply-To: <1369621707-6764-1-git-send-email-libo.chen@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


use module_pci_driver instead of init/exit, make code clean.

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/scsi/a100u2w.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

* add "Signed-off-by: Libo Chen <libo.chen@huawei.com>"

diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
old mode 100644
new mode 100755
index 0163457..db3710f
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1227,19 +1227,9 @@ static struct pci_driver inia100_pci_driver = {
 	.remove		= inia100_remove_one,
 };

-static int __init inia100_init(void)
-{
-	return pci_register_driver(&inia100_pci_driver);
-}
-
-static void __exit inia100_exit(void)
-{
-	pci_unregister_driver(&inia100_pci_driver);
-}
+module_pci_driver(inia100_pci_driver);

 MODULE_DESCRIPTION("Initio A100U2W SCSI driver");
 MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("Dual BSD/GPL");

-module_init(inia100_init);
-module_exit(inia100_exit);
-- 
1.7.1


