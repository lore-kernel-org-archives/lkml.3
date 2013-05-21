Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3EUPLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 11:11:13 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:36521 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3EUPLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 11:11:12 -0400
MIME-Version: 1.0
Date: Tue, 21 May 2013 23:11:10 +0800
Message-ID: <CAPgLHd_DTQ8Ncc6a7uin8zMY+Uy+zdX56RGVBE5VtVdtMB+gXA@mail.gmail.com>
Subject: [PATCH -next] gpio-ml-ioh: fix error return code in ioh_gpio_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@linaro.org, linus.walleij@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code in the irq descs alloc error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpio/gpio-ml-ioh.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpio/gpio-ml-ioh.c b/drivers/gpio/gpio-ml-ioh.c
index 0966f26..6da6d76 100644
--- a/drivers/gpio/gpio-ml-ioh.c
+++ b/drivers/gpio/gpio-ml-ioh.c
@@ -465,6 +465,7 @@ static int ioh_gpio_probe(struct pci_dev *pdev,
 			dev_warn(&pdev->dev,
 				"ml_ioh_gpio: Failed to get IRQ base num\n");
 			chip->irq_base = -1;
+			ret = irq_base;
 			goto err_irq_alloc_descs;
 		}
 		chip->irq_base = irq_base;

