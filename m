Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674Ab3FZB4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:56:33 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:39635 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3FZB4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:56:32 -0400
MIME-Version: 1.0
Date: Wed, 26 Jun 2013 09:56:30 +0800
Message-ID: <CAPgLHd8wYkHaqH90Xyg=QgBKaREwjgS=H-pOMz-jLrwtdWuQ3g@mail.gmail.com>
Subject: [PATCH -next] pinctrl: vt8500: wmt: remove redundant dev_err call in wmt_pinctrl_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: linus.walleij@linaro.org, linux@prisktech.co.nz, axel.lin@ingics.com,
        maxime.ripard@free-electrons.com, swarren@nvidia.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/pinctrl/vt8500/pinctrl-wmt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pinctrl/vt8500/pinctrl-wmt.c b/drivers/pinctrl/vt8500/pinctrl-wmt.c
index fb30edf3..0cc4335 100644
--- a/drivers/pinctrl/vt8500/pinctrl-wmt.c
+++ b/drivers/pinctrl/vt8500/pinctrl-wmt.c
@@ -570,10 +570,8 @@ int wmt_pinctrl_probe(struct platform_device *pdev,
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	data->base = devm_ioremap_resource(&pdev->dev, res);
-	if (IS_ERR(data->base)) {
-		dev_err(&pdev->dev, "failed to map memory resource\n");
+	if (IS_ERR(data->base))
 		return PTR_ERR(data->base);
-	}
 
 	wmt_desc.pins = data->pins;
 	wmt_desc.npins = data->npins;

