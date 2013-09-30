Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab3I3A47 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:56:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18136 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab3I3A45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:56:57 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-ae-5248cc57edce
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 09/14] regulator: pcap: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:56:55 +0900
Message-id: <007c01cebd77$f5417a30$dfc46e90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAAN2cA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zA93wMx5BBlueallMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bhi71s
	Be3cFYf2zWZrYJzD2cXIySEhYCLx5exrRghbTOLCvfVsILaQwDJGiSWXfGFqXpx6CVTDBRRf
	xCjx6NVtZgjnF6PE/ss72EGq2ATUJL58OQxkc3CICKhK/H/lDmIyC+RKdG9Lh5hpKzHn/Fmw
	XZwCdhJ3NrSC2cICHhJb288xgdgsQJ0vu26wgbTyAtUveu0JEuYVEJT4MfkeC4jNLKAlsX7n
	cSYIW15i85q3zCDlEgLqEo/+6oKERQSMJKYue80GUSIise/FO7DrJQTOsUtcOLmLFWKVgMS3
	yYdYIHplJTYdYIb4VlLi4IobLBMYJWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CJTveLE
	3OLSvHS95PzcTYyQeJy4g/H+AetDjMlA6ycyS4km5wPjOa8k3tDYzMjC1MTU2Mjc0ow0YSVx
	XvUW60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjJ6Mu86wal5Q0dg42WBusOrVWxOKtfRC
	/PwUK01jIuzdZQtFuJ8zTtF+99/j2fYLS4S7NA78Ppm6bfHzv0qV+Z+N1GfZds/Yxf2tnnNW
	8mPJXu0pSYdldcUW8Ldk3+refK88z3YuU6W/U4nQE3OFGdNedcsIsGVdyC78MeX8PjZ+5ar2
	rUunKLEUZyQaajEXFScCALGW51DdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAd3wMx5BBgd/qllMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPG4Yu9bAXt3BWH9s1ma2Ccw9nFyMkhIWAi8eLUS0YIW0ziwr31
	bF2MXBxCAosYJR69us0M4fxilNh/eQc7SBWbgJrEly+HgWwODhEBVYn/r9xBTGaBXInubekg
	FUICthJzzp8Fm8kpYCdxZ0MrmC0s4CGxtf0cE4jNAtT5susGG0grL1D9oteeIGFeAUGJH5Pv
	sYDYzAJaEut3HmeCsOUlNq95ywxSLiGgLvHory5IWETASGLqstdsECUiEvtevGOcwCg0C8mk
	WUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguP9mfQOxlUNFocYBTgY
	lXh4LZZ6BAmxJpYVV+YeYpTgYFYS4V2eBBTiTUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGAq
	yiuJNzQ2MTOyNDKzMDIxNydNWEmc92CrdaCQQHpiSWp2ampBahHMFiYOTqkGxsg5XZOXSbcm
	nxCpWfmE+WNvzJRXBlXvWHPdTJ+4fTh0QvXrtu2WJQebrbc9c94+LWGbVvn9FP3/yge8dXxu
	Cx1wEvE0euI9zV74V9oLXq0pX51lAgPkp906VjVjj9CnRYs1d04+zqB9a6KxPF/PQxadx8ca
	cz8XRgdfOPDg04zYYn/uwDCll0osxRmJhlrMRcWJAHJ3UEU7AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/pcap-regulator.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index b49eaee..3727b7d 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -246,7 +246,8 @@ static int pcap_regulator_probe(struct platform_device *pdev)
 	config.init_data = dev_get_platdata(&pdev->dev);
 	config.driver_data = pcap;
 
-	rdev = regulator_register(&pcap_regulators[pdev->id], &config);
+	rdev = devm_regulator_register(&pdev->dev, &pcap_regulators[pdev->id],
+				       &config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
@@ -255,22 +256,12 @@ static int pcap_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int pcap_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-
-	regulator_unregister(rdev);
-
-	return 0;
-}
-
 static struct platform_driver pcap_regulator_driver = {
 	.driver = {
 		.name	= "pcap-regulator",
 		.owner	= THIS_MODULE,
 	},
 	.probe	= pcap_regulator_probe,
-	.remove	= pcap_regulator_remove,
 };
 
 static int __init pcap_regulator_init(void)
-- 
1.7.10.4


