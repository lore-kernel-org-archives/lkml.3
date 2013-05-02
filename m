Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150Ab3EBPAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:00:52 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:56216 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab3EBPAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:00:51 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: dwmw2@infradead.org
Cc: artem.bityutskiy@linux.intel.com, avinashphilip@ti.com, jacmet@sunsite.dk,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: mtd: devices: elm: use devm_ioremap_resource()
Date: Thu,  2 May 2013 17:09:05 +0200
Message-Id: <1367507346-29382-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace a call to deprecated devm_request_and_ioremap by devm_ioremap_resource.

Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_request_and_ioremap.cocci.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/mtd/devices/elm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/devices/elm.c b/drivers/mtd/devices/elm.c
index 2ec5da9..2bafb06 100644
--- a/drivers/mtd/devices/elm.c
+++ b/drivers/mtd/devices/elm.c
@@ -344,9 +344,9 @@ static int elm_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	info->elm_base = devm_request_and_ioremap(&pdev->dev, res);
-	if (!info->elm_base)
-		return -EADDRNOTAVAIL;
+	info->elm_base = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(info->elm_base))
+		return PTR_ERR(info->elm_base);
 
 	ret = devm_request_irq(&pdev->dev, irq->start, elm_isr, 0,
 			pdev->name, info);
-- 
1.7.10.4

