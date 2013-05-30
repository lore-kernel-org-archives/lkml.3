Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab3E3MM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 08:12:57 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16024 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab3E3MMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 08:12:50 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <guohanjun@huawei.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 3/5] scsi: qlogicpti: use module_platform_driver() and platform_{set,get}_drvdata
Date: Thu, 30 May 2013 20:09:44 +0800
Message-ID: <1369915786-2660-4-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
In-Reply-To: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
References: <1369915786-2660-1-git-send-email-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.68.221]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helper macro and wrapper functions to simpily code.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/scsi/qlogicpti.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 6d48d30..1349374 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1367,7 +1367,7 @@ static int qpti_sbus_probe(struct platform_device *op)
 		goto fail_unmap_queues;
 	}
 
-	dev_set_drvdata(&op->dev, qpti);
+	platform_set_drvdata(op, qpti);
 
 	qpti_chain_add(qpti);
 
@@ -1404,7 +1404,7 @@ fail_unlink:
 
 static int qpti_sbus_remove(struct platform_device *op)
 {
-	struct qlogicpti *qpti = dev_get_drvdata(&op->dev);
+	struct qlogicpti *qpti = platform_get_drvdata(&op->dev);
 
 	qpti_chain_del(qpti);
 
@@ -1462,21 +1462,10 @@ static struct platform_driver qpti_sbus_driver = {
 	.remove		= qpti_sbus_remove,
 };
 
-static int __init qpti_init(void)
-{
-	return platform_driver_register(&qpti_sbus_driver);
-}
-
-static void __exit qpti_exit(void)
-{
-	platform_driver_unregister(&qpti_sbus_driver);
-}
+module_platform_driver(qpti_sbus_driver);
 
 MODULE_DESCRIPTION("QlogicISP SBUS driver");
 MODULE_AUTHOR("David S. Miller (davem@davemloft.net)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("2.1");
 MODULE_FIRMWARE("qlogic/isp1000.bin");
-
-module_init(qpti_init);
-module_exit(qpti_exit);
-- 
1.8.2.1


