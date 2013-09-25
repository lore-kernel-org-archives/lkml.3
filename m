Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3IYHsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:48:19 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22120 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab3IYHsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:48:17 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-75-52429540307a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Subject: [PATCH 01/20] regulator: ab3100: use devm_regulator_register()
Date: Wed, 25 Sep 2013 16:48:15 +0900
Message-id: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zI12HqU5BBic6eS2mPnzCZnF54SVW
	i29XOpgspvxZzmRxedccNgdWj52z7rJ7bFrVyeZx59oeNo++LasYPT5vkgtgjeKySUnNySxL
	LdK3S+DKaDjfz1LwjL1i99v/zA2Mu9m6GDk5JARMJK6faWKEsMUkLtxbDxTn4hASWMYocejb
	ZXaYokMrfrNAJKYzSix+9YwRwvnFKLG56T5YO5uAmsSXL4eBOjg4RARUJf6/cgepYRaYySix
	s38HE0iNsIC7xPTLncwgNgtQTef962AbeAVsJSZ/m8UIYQtK/Jh8jwXEZhbQkli/8zgThC0v
	sXnNW2aQ+RIC6hKP/uqChEUE9CSuT1nNClEiIrHvxTuob06xSxxs94dYJSDxbfIhFohWWYlN
	B5ghSiQlDq64wTKBUWwWksWzkCyehWTxLCQbFjCyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P
	3cQIibz+HYx3D1gfYkwGWj+RWUo0OR8YuXkl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYGyVPLbBWO+CSc+vl14M07dkLb/0vzwuu+mx1Nbg2zEl
	Hm7/D+7+urlIrs23JH7Z6/0ix+KmSh9Zf68s7D1H69Sa/+aKu76HmIsqdfZvK9ewOOsgfm7H
	aveuiq679ZXXZj1pNLvmrPLS5OFnj/8nPe2z0jY/8tF7xn1YVuOKmfze/wKn555zc1NiKc5I
	NNRiLipOBABKjG6a0gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV2HqU5BBk8nc1pMffiEzeLywkus
	Ft+udDBZTPmznMni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNFwvp+l4Bl7xe63/5kbGHezdTFyckgImEgc
	WvGbBcIWk7hwbz1QnItDSGA6o8TiV88YIZxfjBKbm+4zglSxCahJfPlymL2LkYNDREBV4v8r
	d5AaZoGZjBI7+3cwgdQIC7hLTL/cyQxiswDVdN6/zg5i8wrYSkz+NosRwhaU+DH5HthmZgEt
	ifU7jzNB2PISm9e8ZQaZLyGgLvHory5IWERAT+L6lNWsECUiEvtevGOcwCgwC8mkWUgmzUIy
	aRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgiP7mdQOxpUNFocYBTgYlXh4BY46
	BgmxJpYVV+YeYpTgYFYS4V3b7xQkxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnApJNXEm9o
	bGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxqG38paBZPv9kcVlSb
	mK32eeLHqx1pyfHLeCL0n/iWPBfa39yucXahUxT/5Y8Rr36z6CyJ6Ny5YzrbmTurt3rJu9ya
	eOD/tiDBp/u+8H7vWqcglXDuWfSOhXnxUnPcLx24MjVmUaxzd9Dqdc4qvreF3iXqnAsQemnY
	VdMlyrbHy69iIsvVvQFKLMUZiYZazEXFiQCqBMobMAMAAA==
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


