Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421AbaFIOmi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 10:42:38 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:45859 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaFIOmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 10:42:36 -0400
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Doug Thompson <dougthompson@xmission.com>
CC: <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpc925_edac: Use module_platform_driver()
Date: Mon, 9 Jun 2014 22:40:18 +0800
Message-ID: <1402324818-12300-1-git-send-email-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 1.8.3.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.21.224]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move edac_op_state assignment operations to probe, then convert to
module_platform_drive() to eliminate boilerplate code, and use
cpc925_printk instead of printk.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 drivers/edac/cpc925_edac.c |   33 +++++++--------------------------
 1 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/drivers/edac/cpc925_edac.c b/drivers/edac/cpc925_edac.c
index df6575f..8e3192a 100644
--- a/drivers/edac/cpc925_edac.c
+++ b/drivers/edac/cpc925_edac.c
@@ -944,6 +944,12 @@ static int cpc925_probe(struct platform_device *pdev)
 
 	edac_dbg(0, "%s platform device found!\n", pdev->name);
 
+	cpc925_printk(KERN_INFO, CPC925_EDAC_REVISION "\n");
+	cpc925_printk(KERN_INFO, "\t(c) 2008 Wind River Systems, Inc\n");
+
+	/* Only support POLL mode so far */
+	edac_op_state = EDAC_OPSTATE_POLL;
+
 	if (!devres_open_group(&pdev->dev, cpc925_probe, GFP_KERNEL)) {
 		res = -ENOMEM;
 		goto out;
@@ -1065,32 +1071,7 @@ static struct platform_driver cpc925_edac_driver = {
 	}
 };
 
-static int __init cpc925_edac_init(void)
-{
-	int ret = 0;
-
-	printk(KERN_INFO "IBM CPC925 EDAC driver " CPC925_EDAC_REVISION "\n");
-	printk(KERN_INFO "\t(c) 2008 Wind River Systems, Inc\n");
-
-	/* Only support POLL mode so far */
-	edac_op_state = EDAC_OPSTATE_POLL;
-
-	ret = platform_driver_register(&cpc925_edac_driver);
-	if (ret) {
-		printk(KERN_WARNING "Failed to register %s\n",
-			CPC925_EDAC_MOD_STR);
-	}
-
-	return ret;
-}
-
-static void __exit cpc925_edac_exit(void)
-{
-	platform_driver_unregister(&cpc925_edac_driver);
-}
-
-module_init(cpc925_edac_init);
-module_exit(cpc925_edac_exit);
+module_platform_driver(cpc925_edac_driver);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Cao Qingtao <qingtao.cao@windriver.com>");
-- 
1.7.1


