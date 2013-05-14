Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483Ab3ENMMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 08:12:34 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:46634 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3ENMMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 08:12:33 -0400
From: Laurent Navet <laurent.navet@gmail.com>
To: grant.likely@linaro.org, linus.walleij@linaro.org
Cc: linux-kernel@vger.kernel.org, Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] drivers: gpio: gpio-msm-v1.c: use devm_ioremap_resource()
Date: Tue, 14 May 2013 14:21:25 +0200
Message-Id: <1368534085-32582-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace calls to deprecated devm_request_and_ioremap by devm_ioremap_resource.
Found with coccicheck and this semantic patch:
 scripts/coccinelle/api/devm_ioremap_resource.cocci

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/gpio/gpio-msm-v1.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-msm-v1.c b/drivers/gpio/gpio-msm-v1.c
index c798585..c0ead43 100644
--- a/drivers/gpio/gpio-msm-v1.c
+++ b/drivers/gpio/gpio-msm-v1.c
@@ -652,14 +652,14 @@ static int __devinit gpio_msm_v1_probe(struct platform_device *pdev)
 		return irq2;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	base1 = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base1)
-		return -EADDRNOTAVAIL;
+	base1 = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base1))
+		return PTR_ERR(base1);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	base2 = devm_request_and_ioremap(&pdev->dev, res);
-	if (!base2)
-		return -EADDRNOTAVAIL;
+	base2 = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(base2))
+		return PTR_ERR(base2);
 
 	for (i = FIRST_GPIO_IRQ; i < FIRST_GPIO_IRQ + NR_GPIO_IRQS; i++) {
 		if (i - FIRST_GPIO_IRQ >=
-- 
1.7.10.4

