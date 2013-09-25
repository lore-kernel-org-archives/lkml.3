Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101Ab3IYIIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:08:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34358 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3IYIIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:08:15 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-b5-524299ed5afd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'MyungJoo Ham'" <myungjoo.ham@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 14/20] regulator: max8952: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:08:13 +0900
Message-id: <001701ceb9c6$61e00ea0$25a02be0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAApkLQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zQ923M52CDD7d07OY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF7cYVbA6sHjtn3WX32LSqk82jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mjbse8pa8Iej4tO0WUwNjOfYuxg5OSQETCR2dvYxQthiEhfurWfrYuTiEBJYxiixfedbIIcD
	rKjhrhpEfBGjxMZ9jUwQzi9GiatvTzGBdLMJqEl8+XKYHaRBREBV4v8rd5Aws8AMRokPb3RA
	bCEBW4nlf2+zgNicAnYSy+59ZgOxhQU8JBbc2wY2hgWo9dW/LUwgY3iB6vddDQAJ8woISvyY
	fI8FYqSWxPqdx5kgbHmJzWveMkOcqS7x6K8uSFhEwEji8aNLjBAlIhL7XrxjBLlYQuAau8S3
	Va1QqwQkvk0+xALRKyux6QAzJBgkJQ6uuMEygVFiFpLNs5BsnoVk8ywkKxYwsqxiFE0tSC4o
	TkovMtQrTswtLs1L10vOz93ECInN3h2Mtw9YH2JMBlo/kVlKNDkfGNt5JfGGxmZGFqYmpsZG
	5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBcn3zx2Rp5+azskysu3g/7
	8kfxgdJCX8ZsaaubrpsPHK32UFp4fsERv9jigqIfprwt22NztnX7JF3kSJfa2DWvXHvyc651
	5yrXsc99+OxD3rPAw1de7VkjdDS3JOjYFNFv9/zE3isayJRL/Tgbn/I0fLPOP3arMy+2yp1t
	uPlg9+mLW89vfhseo8RSnJFoqMVcVJwIABnwc+XjAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jAd23M52CDK60aVtMffiEzeLywkus
	Ft+udDBZXN41h83iduMKNgdWj52z7rJ7bFrVyebRt2UVo8fnTXIBLFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYR1jBkb9j1lLfjDUfFp2iymBsZz7F2MHBwSAiYSDXfVuhg5
	gUwxiQv31rN1MXJxCAksYpTYuK+RCcL5xShx9e0pJpAqNgE1iS9fDoM1iwioSvx/5Q4SZhaY
	wSjx4Y0OiC0kYCux/O9tFhCbU8BOYtm9z2wgtrCAh8SCe9vAxrAAtb76t4UJZAwvUP2+qwEg
	YV4BQYkfk++xQIzUkli/8zgThC0vsXnNW2aIk9UlHv3VBQmLCBhJPH50iRGiRERi34t3jBMY
	hWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZw5D+T2sG4ssHi
	EKMAB6MSD6/AUccgIdbEsuLK3EOMEhzMSiK8RVOdgoR4UxIrq1KL8uOLSnNSiw8xJgP9OZFZ
	SjQ5H5iU8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qB8dCB
	rSXuR/+axO1Yfv111rSbTyz2q57daxd590PgPztXgcoDX9/wKJsdmzhzosfJQ4/eCjx87cLT
	/X6abFKlTuG9qQUrmpOcd2894p5RNMXlhsw9VwElBj877o3RlfsEm6vr/4W8rdY53BDFXCsw
	NW32eZ+U0m0TrzGdfaATt8rJtOpqbojZciWW4oxEQy3mouJEACburc1AAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/max8952.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/max8952.c b/drivers/regulator/max8952.c
index 788e5ae..6fb7ec1 100644
--- a/drivers/regulator/max8952.c
+++ b/drivers/regulator/max8952.c
@@ -231,7 +231,8 @@ static int max8952_pmic_probe(struct i2c_client *client,
 	if (pdata->reg_data->constraints.boot_on)
 		config.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
 
-	max8952->rdev = regulator_register(&regulator, &config);
+	max8952->rdev = devm_regulator_register(&client->dev, &regulator,
+						&config);
 
 	if (IS_ERR(max8952->rdev)) {
 		ret = PTR_ERR(max8952->rdev);
@@ -321,9 +322,6 @@ static int max8952_pmic_remove(struct i2c_client *client)
 {
 	struct max8952_data *max8952 = i2c_get_clientdata(client);
 	struct max8952_platform_data *pdata = max8952->pdata;
-	struct regulator_dev *rdev = max8952->rdev;
-
-	regulator_unregister(rdev);
 
 	gpio_free(pdata->gpio_vid0);
 	gpio_free(pdata->gpio_vid1);
-- 
1.7.10.4


