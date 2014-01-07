Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaAGNMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:12:36 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:47993 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaAGNMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:12:30 -0500
MIME-Version: 1.0
Date: Tue, 7 Jan 2014 21:12:29 +0800
Message-ID: <CAPgLHd_XJqAjhdv=J8d9TwdchS203_GqUTvRYM9SAS12roiYBA@mail.gmail.com>
Subject: [PATCH -next] isp1704_charger: remove useless check in isp1704_charger_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: anton@enomsg.org, dwmw2@infradead.org, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Neither devm_usb_get_phy_by_phandle() nor devm_usb_get_phy() can
return a NULL result, so remove the useless !isp->phy check.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/power/isp1704_charger.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index 80edb7d..0b4cf9d 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -444,8 +444,6 @@ static int isp1704_charger_probe(struct platform_device *pdev)
 		ret = PTR_ERR(isp->phy);
 		goto fail0;
 	}
-	if (!isp->phy)
-		goto fail0;
 
 	isp->dev = &pdev->dev;
 	platform_set_drvdata(pdev, isp);

