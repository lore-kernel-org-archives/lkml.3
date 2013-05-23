Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908Ab3EWP21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 11:28:27 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:51295 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509Ab3EWPZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 11:25:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org, sameo@linux.intel.com
Cc: Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 13/16] mfd: htc-pasic3: Convert to managed resources for allocating memory
Date: Thu, 23 May 2013 16:25:14 +0100
Message-Id: <1369322717-30429-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
References: <1369322717-30429-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/htc-pasic3.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mfd/htc-pasic3.c b/drivers/mfd/htc-pasic3.c
index 0285fce..0a5e85f 100644
--- a/drivers/mfd/htc-pasic3.c
+++ b/drivers/mfd/htc-pasic3.c
@@ -147,7 +147,7 @@ static int __init pasic3_probe(struct platform_device *pdev)
 	if (!request_mem_region(r->start, resource_size(r), "pasic3"))
 		return -EBUSY;
 
-	asic = kzalloc(sizeof(struct pasic3_data), GFP_KERNEL);
+	asic = devm_kzalloc(dev, sizeof(struct pasic3_data), GFP_KERNEL);
 	if (!asic)
 		return -ENOMEM;
 
@@ -156,7 +156,6 @@ static int __init pasic3_probe(struct platform_device *pdev)
 	asic->mapping = ioremap(r->start, resource_size(r));
 	if (!asic->mapping) {
 		dev_err(dev, "couldn't ioremap PASIC3\n");
-		kfree(asic);
 		return -ENOMEM;
 	}
 
@@ -195,7 +194,6 @@ static int pasic3_remove(struct platform_device *pdev)
 	iounmap(asic->mapping);
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(r->start, resource_size(r));
-	kfree(asic);
 	return 0;
 }
 
-- 
1.7.10.4

