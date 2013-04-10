Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933250Ab3DJVCB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:02:01 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:45837 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab3DJVCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:02:00 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: linux-mtd@lists.infradead.org
Cc: David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Philip Avinash <avinashphilip@ti.com>,
        Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] drivers: mtd: devices: convert to devm_ioremap_resource()
Date: Thu, 11 Apr 2013 00:01:51 +0300
Message-Id: <1365627711-17476-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
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
1.7.9.5

