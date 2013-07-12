Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab3GLE7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 00:59:44 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:64473 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab3GLE7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 00:59:42 -0400
MIME-Version: 1.0
In-Reply-To: <877gh8nbpm.fsf@linaro.org>
References: <CAPgLHd_K37Uf420FRiEkiCZQiL9bAdiE2_qG4dp7WmQRaCnDqQ@mail.gmail.com>
	<20130626130641.GA26920@kahuna>
	<877gh8nbpm.fsf@linaro.org>
Date: Fri, 12 Jul 2013 12:59:40 +0800
Message-ID: <CAPgLHd-toHh8DcooiVz7222kiE-F+xsj1nai2hNEHo95X-3+Ow@mail.gmail.com>
Subject: [PATCH RESEND] PM / AVS: SmartReflex: remove redundant dev_err call
 in omap_sr_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: khilman@linaro.org
Cc: nm@ti.com, anton@enomsg.org, dwmw2@infradead.org,
        andrii.tseglytskyi@ti.com, jean.pihet@newoldbits.com, tony@atomide.com,
        yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a error message within devm_ioremap_resource
already, so remove the dev_err call to avoid redundant
error message.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Nishanth Menon <nm@ti.com>
---
cc to linux-pm with Nishanth Menon's ACK
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
 

