Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934136Ab3FSCrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:47:09 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:61092 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836Ab3FSCrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:47:08 -0400
MIME-Version: 1.0
Date: Wed, 19 Jun 2013 10:47:06 +0800
Message-ID: <CAPgLHd-k_HkBa+oKU+7gPZfY3vT4u-xzsKZTqjkw_GdyK1rGcg@mail.gmail.com>
Subject: [PATCH -next] mfd: htc-egpio: use devm_ioremap_nocache() instead of ioremap_nocache()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Replace probe-time ioremap_nocache() call with devm_ioremap_nocache()
to avoid iounmap() missing and get rid of the corresponding iounmap()
call on remove.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/htc-egpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/htc-egpio.c b/drivers/mfd/htc-egpio.c
index f2e0ad4..26aca54 100644
--- a/drivers/mfd/htc-egpio.c
+++ b/drivers/mfd/htc-egpio.c
@@ -286,7 +286,8 @@ static int __init egpio_probe(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		goto fail;
-	ei->base_addr = ioremap_nocache(res->start, resource_size(res));
+	ei->base_addr = devm_ioremap_nocache(&pdev->dev, res->start,
+					     resource_size(res));
 	if (!ei->base_addr)
 		goto fail;
 	pr_debug("EGPIO phys=%08x virt=%p\n", (u32)res->start, ei->base_addr);
@@ -380,7 +381,6 @@ static int __exit egpio_remove(struct platform_device *pdev)
 		irq_set_chained_handler(ei->chained_irq, NULL);
 		device_init_wakeup(&pdev->dev, 0);
 	}
-	iounmap(ei->base_addr);
 
 	return 0;
 }

