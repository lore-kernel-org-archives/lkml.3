Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396Ab3FZB5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 21:57:17 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:58701 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZB5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 21:57:16 -0400
MIME-Version: 1.0
Date: Wed, 26 Jun 2013 09:57:14 +0800
Message-ID: <CAPgLHd_K37Uf420FRiEkiCZQiL9bAdiE2_qG4dp7WmQRaCnDqQ@mail.gmail.com>
Subject: [PATCH -next] PM / AVS: SmartReflex: remove redundant dev_err call in omap_sr_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: anton@enomsg.org, dwmw2@infradead.org, khilman@linaro.org,
        andrii.tseglytskyi@ti.com, nm@ti.com, jean.pihet@newoldbits.com,
        tony@atomide.com
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
 drivers/power/avs/smartreflex.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index db9973b..c26acfc 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -871,10 +871,8 @@ static int __init omap_sr_probe(struct platform_device *pdev)
 
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	sr_info->base = devm_ioremap_resource(&pdev->dev, mem);
-	if (IS_ERR(sr_info->base)) {
-		dev_err(&pdev->dev, "%s: ioremap fail\n", __func__);
+	if (IS_ERR(sr_info->base))
 		return PTR_ERR(sr_info->base);
-	}
 
 	irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 

