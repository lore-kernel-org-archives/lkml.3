Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab3IZHqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:46:43 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:44416 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab3IZHqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:46:42 -0400
X-AuditID: cbfee68e-b7f756d000004512-d8-5243e65f405a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Subject: [PATCH V3 01/14] regulator: ab3100: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:46:39 +0900
Message-id: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1Dxbvczrw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zfd34Z85BBjvPalhMffiEzeLywkus
	Ft+udDBZTPmznMni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGsVlk5Kak1mW
	WqRvl8CV0XC+n6XgGXvF7rf/mRsYd7N1MXJwSAiYSOxrLOxi5AQyxSQu3FsPFObiEBJYxigx
	9eU9NoiEicTTTb+YIRKLGCWONC1jAUkICfxilHj/KAfEZhNQk/jy5TA7yFARAVWJ/6/cQeqZ
	BWYySuzs38EEUiMs4CXx42wXO4jNAlRztG0FE0g9r4CtxOojSiBhXgFBiR+T74GNZxbQkli/
	8zgThC0vsXnNW2aIm9UlHv3VBQmLCOhJrDy3nRWiRERi34t3jCBrJQROsUs8uziVDWKVgMS3
	yYdYIHplJTYdYIZ4S1Li4IobLBMYxWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CIjveLE
	3OLSvHS95PzcTYyQqOvbwXjzgPUhxmSg9ROZpUST84FRm1cSb2hsZmRhamJqbGRuaUaasJI4
	r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRvMmVqUAruxvf50j+zXMo2rmaj4JW2jx
	QEdkg4YYQ6LDM2mD11ezes2D7NM0NdJ2bDHwPlHKcNj9kOZJz8wp3OncIbsXPrN7punyepuN
	gjB7brxGc9p3myumj6rZd+1dHXNn9pl3Zv8YOMyrEoukk6IiMm9Xqh/IWzUtKH6rbfz5/jM8
	KXeUWIozEg21mIuKEwFPgTp70AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd34Z85BBhPvq1hMffiEzeLywkus
	Ft+udDBZTPmznMni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNFwvp+l4Bl7xe63/5kbGHezdTFyckgImEg8
	3fSLGcIWk7hwbz1QnItDSGARo8SRpmUsIAkhgV+MEu8f5YDYbAJqEl++HGbvYuTgEBFQlfj/
	yh2knllgJqPEzv4dTCA1wgJeEj/OdrGD2CxANUfbVjCB1PMK2EqsPqIEEuYVEJT4Mfke2Hhm
	AS2J9TuPM0HY8hKb17xlBimXEFCXePRXFyQsIqAnsfLcdlaIEhGJfS/eMU5gFJiFZNIsJJNm
	IZk0C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBUf1MagfjygaLQ4wCHIxKPLwX
	mJ2DhFgTy4orcw8xSnAwK4nwfjMCCvGmJFZWpRblxxeV5qQWH2JMBvpzIrOUaHI+MOHklcQb
	GpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAPj4Yau3bKmlm9EXi+1
	fpaw2fGL1PEss933uZpislyXH3p3wvvg5Ylmb9a6OJ18xHn0/Y77B4XcVfgYY9Z4pH289KSz
	NJN9UmKJ/R9FBXfp/QLXDZ5vPZ+x/8EU2egFnU/4vhx5zGc+jS3d683uzes69qlym0ZOKvCb
	2yTcH3JeIqy9dvb1qKoMJZbijERDLeai4kQAnNtYqC4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/ab3100.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 7d5eaa8..77b46d0 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -535,7 +535,7 @@ static int ab3100_regulator_register(struct platform_device *pdev,
 	config.dev = &pdev->dev;
 	config.driver_data = reg;
 
-	rdev = regulator_register(desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, desc, &config);
 	if (IS_ERR(rdev)) {
 		err = PTR_ERR(rdev);
 		dev_err(&pdev->dev,
@@ -616,7 +616,6 @@ static int ab3100_regulators_remove(struct platform_device *pdev)
 	for (i = 0; i < AB3100_NUM_REGULATORS; i++) {
 		struct ab3100_regulator *reg = &ab3100_regulators[i];
 
-		regulator_unregister(reg->rdev);
 		reg->rdev = NULL;
 	}
 	return 0;
-- 
1.7.10.4


