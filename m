Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3LFHKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:10:50 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:63634 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab3LFHKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:10:49 -0500
X-AuditID: cbfee68d-b7f5c6d000004aff-8d-52a17872c493
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Heiko Stuebner'" <heiko@sntech.de>,
        "'Axel Lin'" <axel.lin@ingics.com>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
In-reply-to: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
Subject: [PATCH 4/6] regulator: gpio-regulator: use devm_regulator_register()
Date: Fri, 06 Dec 2013 16:10:42 +0900
Message-id: <000d01cef252$4680cf90$d3826eb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7yUb+lAqO9MkXdRJaD6VTAoDhw9gAAFiPQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t8zQ92iioVBBhc+aVgcmfOV2WLqwyds
	Fv8fvWa1uLzwEqvFtysdTBaXd81hc2Dz2DnrLrtH288yj02rOtk8+rasYvTYfm0es8fnTXIB
	bFFcNimpOZllqUX6dglcGQ8OP2Ar+M5RcWC9dQPjGfYuRk4OCQETiVdrGtkgbDGJC/fWg9lC
	AssYJV694Iap+T/9N3MXIxdQfDqjxPObu9ghnF+MEtO3fmEGqWITUJP48uUwUIKDQ0RAVeL/
	K3eQGmaBrYwSWyadBIsLCdhKrLpfDVLOKWAn8efoG7BWYQFfia1z7oAdxALUeuXTN7AjeIHK
	Jx/bwQxhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpDxEgLqEo/+6oKERQSMJFbO+QtVIiKx
	78U7RpBzJATeskss+/CXFWKXgMS3yYdYIHplJTYdYIb4V1Li4IobLBMYJWYh2TwLyeZZSDbP
	QrJiASPLKkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYyQuO3dwXj7gPUhxmSg9ROZpUST84Fx
	n1cSb2hsZmRhamJqbGRuaUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjLFi
	kTZHU5ks7mxfEX6sqml7+Pl7cjH7pgqvDVVoPsGk93H3xZe8P2MN8tp/V5xL2+giyPV7ktQs
	OQbFJ8fcElaplXALHtXNeyKy6uu880vXs066Y3g37/Se5Tez5UQk5jKfumGQv0U1yD2BWa1t
	5r8cl0s1wUbiiy7zJjqEZ7G3GjlwPdn7S4mlOCPRUIu5qDgRAKYMSbDxAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDKsWRmVeSWpSXmKPExsVy+t9jQd2iioVBBp8+qFgcmfOV2WLqwyds
	Fv8fvWa1uLzwEqvFtysdTBaXd81hc2Dz2DnrLrtH288yj02rOtk8+rasYvTYfm0es8fnTXIB
	bFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QGco
	KZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwnrGDMeHH7AVvCdo+LAeusGxjPs
	XYycHBICJhL/p/9mhrDFJC7cW8/WxcjFISQwnVHi+c1d7BDOL0aJ6Vu/gFWxCahJfPlyGCjB
	wSEioCrx/5U7SA2zwFZGiS2TToLFhQRsJVbdrwYp5xSwk/hz9A1Yq7CAr8TWOXfAFrMAtV75
	9I0NxOYFKp98bAczhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lBxksIqEs8+qsLEhYRMJJY
	OecvVImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT8
	3E2M4LTwTGoH48oGi0OMAhyMSjy8HKsWBAmxJpYVV+YeYpTgYFYS4e0RXxgkxJuSWFmVWpQf
	X1Sak1p8iDEZ6NGJzFKiyfnAlJVXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTU
	gtQimC1MHJxSDYwWpVWnFQOYeSK8HA6+87mjlXr6YWFeuHv9UuZMLtmNMsW2AovPGPrFli0U
	ap+dyDu/9nbvrt36jpGXgjtEP1aKlF49lDmt4My0NSsXvMjKjdn1dNestbkl3+7sKFh3r3PK
	MdEvXHsVp29b3jG5O2wSZ+9us193ba0+ZL8RzvqnsuDfjN6L28yUWIozEg21mIuKEwG02ZdD
	TwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/gpio-regulator.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/gpio-regulator.c b/drivers/regulator/gpio-regulator.c
index 13ec94d..fb4120b 100644
--- a/drivers/regulator/gpio-regulator.c
+++ b/drivers/regulator/gpio-regulator.c
@@ -324,7 +324,8 @@ static int gpio_regulator_probe(struct platform_device *pdev)
 			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
 	}
 
-	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
+	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
+						&cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
@@ -351,8 +352,6 @@ static int gpio_regulator_remove(struct platform_device *pdev)
 {
 	struct gpio_regulator_data *drvdata = platform_get_drvdata(pdev);
 
-	regulator_unregister(drvdata->dev);
-
 	gpio_free_array(drvdata->gpios, drvdata->nr_gpios);
 
 	kfree(drvdata->states);
-- 
1.7.10.4


