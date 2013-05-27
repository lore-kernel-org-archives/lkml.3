Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab3E0C3W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 22:29:22 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:53419 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab3E0C3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 22:29:18 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <richardcochran@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <libo.chen@huawei.com>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 11/24] drivers/ptp/ptp_pch: Convert to module_pci_driver
Date: Mon, 27 May 2013 10:29:03 +0800
Message-ID: <1369621743-7732-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use module_pci_driver instead of init/exit, make code clean

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/ptp/ptp_pch.c |   18 +-----------------
 1 files changed, 1 insertions(+), 17 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index bea9451..e63ca00 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -705,23 +705,7 @@ static struct pci_driver pch_driver = {
 	.resume = pch_resume,
 };
 
-static void __exit ptp_pch_exit(void)
-{
-	pci_unregister_driver(&pch_driver);
-}
-
-static s32 __init ptp_pch_init(void)
-{
-	s32 ret;
-
-	/* register the driver with the pci core */
-	ret = pci_register_driver(&pch_driver);
-
-	return ret;
-}
-
-module_init(ptp_pch_init);
-module_exit(ptp_pch_exit);
+module_pci_driver(pch_driver);
 
 module_param_string(station,
 		    pch_param.station, sizeof(pch_param.station), 0444);
-- 
1.7.1


