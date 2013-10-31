Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab3JaHvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 03:51:20 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:54611 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3JaHvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 03:51:19 -0400
MIME-Version: 1.0
Date: Thu, 31 Oct 2013 15:51:18 +0800
Message-ID: <CAPgLHd-5vqN_ywFRM_SCW5OkiHpXWNf-fhHEmBHnS-HwQp-kxQ@mail.gmail.com>
Subject: [PATCH -next] pinctrl: imx1: fix return value check in imx1_pinctrl_core_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, grant.likely@linaro.org, rob.herring@calxeda.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function devm_ioremap_nocache() returns NULL
pointer not ERR_PTR(). The IS_ERR() test in the return value check
should be replaced with NULL test.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/pinctrl-imx1-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-imx1-core.c b/drivers/pinctrl/pinctrl-imx1-core.c
index 4d5a9e7..f77914a 100644
--- a/drivers/pinctrl/pinctrl-imx1-core.c
+++ b/drivers/pinctrl/pinctrl-imx1-core.c
@@ -615,8 +615,8 @@ int imx1_pinctrl_core_probe(struct platform_device *pdev,
 
 	ipctl->base = devm_ioremap_nocache(&pdev->dev, res->start,
 			resource_size(res));
-	if (IS_ERR(ipctl->base))
-		return PTR_ERR(ipctl->base);
+	if (!ipctl->base)
+		return -ENOMEM;
 
 	pctl_desc = &imx1_pinctrl_desc;
 	pctl_desc->name = dev_name(&pdev->dev);

