Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752923Ab3CKGgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:36:01 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40998 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3CKGf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:35:59 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-9f-513d7b4ed2fa
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 13/14] power: rx51_battery: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:35:58 +0900
Message-id: <007d01ce1e22$b0a99c30$11fcd490$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAALIpA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI12/attAg1m9IhYHt2paTFw5mdni
	8sJLrBaXd81hc2DxmND/idFj8wotj74tqxg9Pm+SC2CJ4rJJSc3JLEst0rdL4Mo4vv0pU8Fu
	joqVy5+xNDD+YOti5OSQEDCRODbtECuELSZx4d56sLiQwDJGiQ+vLGBq1q08wdLFyAUUn84o
	0fhjGzuE84tR4s6tD8wgVWwCahJfvhxmB7FFBDQk2lZPYQGxmQXyJQ4fuswCMdVWYvfPF4wg
	NqeAncSNZZfAtgkD2V3nfoL1sgioSpzp/8QEYvMC1X/cOpUdwhaU+DH5HtRMLYnN25pYIWx5
	ic1r3gLdwAF0qbrEo7+6ECcYSUzvWMwMUSIise/FO0aQmyUEjrFL/Pp7ihlil4DEt8mHWCB6
	ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiY73ixNzi0rx0
	veT83E2MkIjs38F494D1IcZkoPUTmaVEk/OBEZ1XEm9obGZkYWpiamxkbmlGmrCSOK9ai3Wg
	kEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkaWZ1oH2n7E3ZTal1A3PzhlaR+/d79V0wK7Gfeq
	bsxiXaln8Fbsqt61RY3X/D/OZeTMPffv9MWbJz2tM5qKUjcv57vh6OU20bNFukTCeWHqxjOa
	UrahUycvu/dINuv9+i2XNP79vK3vXPyaV+8FV+t2r98Xvjmtf/WeZcHa1bOf/Zpeczc6qfia
	EktxRqKhFnNRcSIABogngd4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQV2/attAgxWrBSwObtW0mLhyMrPF
	5YWXWC0u75rD5sDiMaH/E6PH5hVaHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeYcXz7U6aC3RwVK5c/Y2lg/MHWxcjJISFgIrFu5QkWCFtM4sK99UBx
	Lg4hgemMEo0/trFDOL8YJe7c+sAMUsUmoCbx5cthdhBbREBDom31FLBuZoF8icOHLoPZQgK2
	Ert/vmAEsTkF7CRuLLsEtk0YyO469xOsl0VAVeJM/ycmEJsXqP7j1qnsELagxI/J96Bmakls
	3tbECmHLS2xe8xboBg6gS9UlHv3VhTjBSGJ6x2JmiBIRiX0v3jFOYBSahWTSLCSTZiGZNAtJ
	ywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwRH/THoH46oGi0OMAhyMSjy8E3RsA4VY
	E8uKK3MPMUpwMCuJ8K7cZBMoxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAZJRXEm9obGJm
	ZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYys87VCDvGIZMdoLJFvvTT/
	/P4T8/V3cr86wPfAUiXz+wudFBeu3a/Oidk07PgaeXS77d2GxOx9rLXnLyz3mc6mZvz+JtPj
	V1Od++2C9awecnL577Le6yRm7JGuuFpvc/jpOqGZ0858Y42XMXr1mztBe3LNDemC24dXXlDc
	vqzqrYTxvx8MXTOUWIozEg21mIuKEwH8BuVlPAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/rx51_battery.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/power/rx51_battery.c b/drivers/power/rx51_battery.c
index 8208888..f9dc9ff 100644
--- a/drivers/power/rx51_battery.c
+++ b/drivers/power/rx51_battery.c
@@ -202,7 +202,7 @@ static int rx51_battery_probe(struct platform_device *pdev)
 	struct rx51_device_info *di;
 	int ret;
 
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
+	di = devm_kzalloc(&pdev->dev, sizeof(*di), GFP_KERNEL);
 	if (!di)
 		return -ENOMEM;
 
@@ -217,7 +217,6 @@ static int rx51_battery_probe(struct platform_device *pdev)
 	ret = power_supply_register(di->dev, &di->bat);
 	if (ret) {
 		platform_set_drvdata(pdev, NULL);
-		kfree(di);
 		return ret;
 	}
 
@@ -230,7 +229,6 @@ static int rx51_battery_remove(struct platform_device *pdev)
 
 	power_supply_unregister(&di->bat);
 	platform_set_drvdata(pdev, NULL);
-	kfree(di);
 
 	return 0;
 }
-- 
1.7.2.5


