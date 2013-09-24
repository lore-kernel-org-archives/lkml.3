Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab3IXJKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:10:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:27962 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab3IXJKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:10:49 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-6f-524157176c44
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 08/22] backlight: bd6107: use devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:10:47 +0900
Message-id: <004e01ceb905$f50e6760$df2b3620$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAANAbQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zA13xcMcggz2zrS3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJYoLpuU1JzMstQifbsErozvl1+y
	FBzhqFj39AZbA2M7excjJ4eEgInE4+9rmSBsMYkL99azdTFycQgJLGOUWLvsK1xRx8LJLBCJ
	6YwSs97+Y4JwfjFKTOq7wwxSxSagJvHly2GgDg4OEQF9ibYWDZAws0COxP0ns8AGCQnYSqz7
	MBvM5hSwkzi19AwbiC0s4Cex/vYbsDiLgKrE2avHwEbyAtV/eviCHcIWlPgx+R4LxEwtic3b
	mlghbHmJzWveMoOslRBQl3j0VxckLCJgJHH43F1miBIRiX0v3jGCnCwhcI5douPgeTaIXQIS
	3yYfYoHolZXYdIAZ4l9JiYMrbrBMAPoUyeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpRcZ6xUn
	5haX5qXrJefnbmKERGX/Dsa7B6wPMSYDrZ/ILCWanA+M6rySeENjMyMLUxNTYyNzSzPShJXE
	edVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MK4smps0fZdmyX7Whi/s8g1r2RrqVokI
	PmHukfdcGvlOXI+Ft0NlR/GRuI3Ns8MEX/P5Ct5f5HVM3Oh66o+Vb82av21KP3rp+Q6Vm36B
	6r/2erybFh6/4mNvVhf7mcsi2gsPv55966X+3mm+U+f+C3eYcCH5pXOCAsOLHQv/R90MvPTd
	u0EhkkuJpTgj0VCLuag4EQC91nqI4AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQV3xcMcgg8mHzC3mrF/DZnF54SVW
	i8u75rBZ7N71lNWBxePEjN8sHnvm/2D16NuyitHj8ya5AJaoBkabjNTElNQihdS85PyUzLx0
	WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCdSgpliTmlQKGAxOJiJX07TBNCQ9x0
	LWAaI3R9Q4LgeowM0EDCOsaM75dfshQc4ahY9/QGWwNjO3sXIyeHhICJRMfCySwQtpjEhXvr
	2boYuTiEBKYzSsx6+48JwvnFKDGp7w4zSBWbgJrEly+Hgbo5OEQE9CXaWjRAwswCORL3n8wC
	GyokYCux7sNsMJtTwE7i1NIzbCC2sICfxPrbb8DiLAKqEmevHgMbyQtU/+nhC3YIW1Dix+R7
	LBAztSQ2b2tihbDlJTavecsMslZCQF3i0V9dkLCIgJHE4XN3mSFKRCT2vXjHOIFRaBaSSbOQ
	TJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTH/DPpHYyrGiwOMQpwMCrx
	8F5IcAgSYk0sK67MPcQowcGsJMJ7w9YxSIg3JbGyKrUoP76oNCe1+BBjMtCjE5mlRJPzgeko
	ryTe0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYFy6YrqT768Ke
	3M+vbjHO6TucbTsv/40FY6uQkofPn4XGkmf1+0Mv9/I31Gk5H5y0VN1urpF714fAnSZM/2bG
	tocuyJPO35LqxDulNNKWfcWR2vUH7zEcVNAvnMedePYAr+qUJZt223q8mrBp0QeF+LNsRfvY
	NXNmLc1LOPxwF0eRav/NI5LTlViKMxINtZiLihMB9JYNlD0DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/bd6107.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/bd6107.c b/drivers/video/backlight/bd6107.c
index 43c434e..16dd9bc 100644
--- a/drivers/video/backlight/bd6107.c
+++ b/drivers/video/backlight/bd6107.c
@@ -166,7 +166,8 @@ static int bd6107_probe(struct i2c_client *client,
 	props.brightness = clamp_t(unsigned int, pdata->def_value, 0,
 				   props.max_brightness);
 
-	backlight = backlight_device_register(dev_name(&client->dev),
+	backlight = devm_backlight_device_register(&client->dev,
+					      dev_name(&client->dev),
 					      &bd->client->dev, bd,
 					      &bd6107_backlight_ops, &props);
 	if (IS_ERR(backlight)) {
@@ -186,7 +187,6 @@ static int bd6107_remove(struct i2c_client *client)
 
 	backlight->props.brightness = 0;
 	backlight_update_status(backlight);
-	backlight_device_unregister(backlight);
 
 	return 0;
 }
-- 
1.7.10.4


