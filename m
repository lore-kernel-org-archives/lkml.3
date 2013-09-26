Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3IZHwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:52:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28209 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab3IZHws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:52:48 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-52-5243e7cf7508
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 11/14] regulator: tps6105x: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:52:46 +0900
Message-id: <003b01ceba8d$63c9aec0$2b5d0c40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAMdPg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zA93zz52DDBa+0rKY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoErY8f6lUwFm3kq/r2dxd7AuI6ri5GTQ0LAROLD5uusELaYxIV769m6GLk4hASWMUr8
	X7ePFabo6MN9LBCJ6YwSi1c/ZgNJCAn8YpT48CETxGYTUJP48uUwexcjB4eIgKrE/1fuIPXM
	AjMZJXb272CCqLeVaPz2lwXE5hSwk5i1/yQziC0s4CPRt34tWJwFqPfnmZtgc3iB6qc2eYKE
	eQUEJX5MvgdWwiygJbF+53EmCFteYvOat8wg5RIC6hKP/uqChEUEjCTmPL3JDFEiIrHvxTtG
	iFcesUu8uS4NsUlA4tvkQywQrbISmw4wQ5RIShxccYNlAqPELCSLZyFZPAvJ4llINixgZFnF
	KJpakFxQnJReZKpXnJhbXJqXrpecn7uJERKlE3cw3j9gfYgxGWj9RGYp0eR8YJTnlcQbGpsZ
	WZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxkmD1zOvcLabL
	j6qn1aya7RGz9tnxe2rna35U7udR+3nO4hHP3UNbGtwUYuO0vvmezp0XOHXJf735xvd1svOl
	6+R+ruD9+0NU9eo/4+LGJ6f+neNaZfubJyev+HdPg0Kd3NP9SVlmyt1i24Q+chpOjD33eM2N
	1Q7Wu//9TOI5brYgtapwhdkyJZbijERDLeai4kQA4eb42+gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd3zz52DDG58VrOY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPH+pVMBZt5Kv69ncXewLiOq4uRk0NCwETi
	6MN9LBC2mMSFe+vZuhi5OIQEpjNKLF79mA0kISTwi1Hiw4dMEJtNQE3iy5fD7F2MHBwiAqoS
	/1+5g9QzC8xklNjZv4MJot5WovHbX7ChnAJ2ErP2n2QGsYUFfCT61q8Fi7MA9f48cxNsDi9Q
	/dQmT5Awr4CgxI/J98BKmAW0JNbvPM4EYctLbF7zlhmkXEJAXeLRX12QsIiAkcScpzeZIUpE
	JPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCeB
	Z1I7GFc2WBxiFOBgVOLhvcDsHCTEmlhWXJl7iFGCg1lJhPebEVCINyWxsiq1KD++qDQntfgQ
	YzLQnxOZpUST84EJKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3gOt1oFCAumJJanZqakFqUUwW5g4
	OKUaGIXi14VcZNJ9910+6vMb7oR5gTcWle7ds6OOd/p02btGt59u5UzLaWHjVdPJeClab/pj
	l/s1mZYwFcZPdSzrkt2eynDXTLhjsHHWT92t/3bXfP6y4c1TG6nt53+5L1uZtvSoIEtozabD
	it8v78wRWqzfvnNTc7HY5gX2iq6xzo/b4wMrtCMv/FViKc5INNRiLipOBAB4TQIoRgMAAA==
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
 drivers/regulator/tps6105x-regulator.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index ec9453f..e0e818d 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -146,8 +146,9 @@ static int tps6105x_regulator_probe(struct platform_device *pdev)
 	config.driver_data = tps6105x;
 
 	/* Register regulator with framework */
-	tps6105x->regulator = regulator_register(&tps6105x_regulator_desc,
-						 &config);
+	tps6105x->regulator = devm_regulator_register(&pdev->dev,
+						      &tps6105x_regulator_desc,
+						      &config);
 	if (IS_ERR(tps6105x->regulator)) {
 		ret = PTR_ERR(tps6105x->regulator);
 		dev_err(&tps6105x->client->dev,
@@ -159,20 +160,12 @@ static int tps6105x_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int tps6105x_regulator_remove(struct platform_device *pdev)
-{
-	struct tps6105x *tps6105x = dev_get_platdata(&pdev->dev);
-	regulator_unregister(tps6105x->regulator);
-	return 0;
-}
-
 static struct platform_driver tps6105x_regulator_driver = {
 	.driver = {
 		.name  = "tps6105x-regulator",
 		.owner = THIS_MODULE,
 	},
 	.probe = tps6105x_regulator_probe,
-	.remove = tps6105x_regulator_remove,
 };
 
 static __init int tps6105x_regulator_init(void)
-- 
1.7.10.4


