Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3IXJG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:06:28 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:20620 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786Ab3IXJG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:06:26 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-ef-524156114ea6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>
References: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
In-reply-to: <004701ceb905$03e8da50$0bba8ef0$%han@samsung.com>
Subject: [PATCH 03/22] backlight: adp5520: use devm_backlight_device_register()
Date: Tue, 24 Sep 2013 18:06:25 +0900
Message-id: <004901ceb905$58926fd0$09b74f70$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65BQPO2UlhwYgjRvaJnkuV9ccl+gAADjzA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zI13BMMcggykfVCzmrF/DZnF54SVW
	i8u75rBZTDi8md1i966nrA6sHq+uOnqcmPGbxWPP/B+sHn1bVjF6fN4kF8AaxWWTkpqTWZZa
	pG+XwJXRfPIcS8E+7ootdyewNDCe4uxi5OSQEDCReLLkEzuELSZx4d56ti5GLg4hgWWMEgt/
	HmHtYuQAK5r/OQYivohR4sHsDmYI5xejxN+5e9hAutkE1CS+fDnMDtIgIqAv0daiAVLDDNKw
	/UE7C0iNkICtxLoPs8G2cQrYSZxaegasV1jAX+LUut+sIDaLgKrEkuZFYPW8QPUT9z5hhrAF
	JX5MvgcWZxbQkti8rYkVwpaX2LzmLTPEoeoSj/7qQpxgJPH0MFS1iMS+F+8YQc6RELjGLnH4
	zmE2iFUCEt8mH2KBaJWV2HSAGRIOkhIHV9xgmcAoMQvJ4llIFs9CsngWkhULGFlWMYqmFiQX
	FCelFxnrFSfmFpfmpesl5+duYoREaf8OxrsHrA8xJgOtn8gsJZqcD4zyvJJ4Q2MzIwtTE1Nj
	I3NLM9KElcR51VqsA4UE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwFra3qjtKZVnHLWkTjnlp
	dlosvsj96jyJ83ccXcOEpALOBD76vfBeB/dEOZE9JqrxkkI3+HqN9l1bt5KNcSvzHgfWWZzq
	ydsWrjfJzTmy833Fa49sF17jyLtXSvcWGbllFvu1ntv48ObyW8ZqtTNvbb73et08ZlNW4V9p
	79UK+qSdTh7vVnylxFKckWioxVxUnAgAFrN9r+gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jAV3BMMcgg41fFCzmrF/DZnF54SVW
	i8u75rBZTDi8md1i966nrA6sHq+uOnqcmPGbxWPP/B+sHn1bVjF6fN4kF8Aa1cBok5GamJJa
	pJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0XEmhLDGnFCgUkFhc
	rKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0XzyHEvBPu6KLXcnsDQwnuLsYuTgkBAwkZj/
	OaaLkRPIFJO4cG89WxcjF4eQwCJGiQezO5ghnF+MEn/n7mEDqWITUJP48uUwO0iziIC+RFuL
	BkgNM0jD9gftLCA1QgK2Eus+zGYHsTkF7CROLT0D1iss4C9xat1vVhCbRUBVYknzIrB6XqD6
	iXufMEPYghI/Jt8DizMLaEls3tbECmHLS2xe85YZ4mh1iUd/dSFOMJJ4ehiqWkRi34t3jBMY
	hWYhGTQLyaBZSAbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwCngmvYNxVYPF
	IUYBDkYlHt4LCQ5BQqyJZcWVuYcYJTiYlUR4b9g6BgnxpiRWVqUW5ccXleakFh9iTAb6cyKz
	lGhyPjA95ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDY1tt
	lsE0WYHCKaX7b3O9m+ulIl6x9MFHmTrJ0nnJ9ofjCzTm/fhzeA+b8eknjv9ylseeL31VqxPG
	ETvx1xfTvphfbNpfG/MqbF6l/zgcpHp028toNzGzX4WlXD6vwnc/E5rSVhs69cmRXreZpsJd
	zi9lZGLalxffVeia0ieQnim6NWxCDoOfEktxRqKhFnNRcSIA8rXSs0UDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_backlight_device_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/adp5520_bl.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index fe8e3d1..f37097a 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -312,8 +312,9 @@ static int adp5520_bl_probe(struct platform_device *pdev)
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_RAW;
 	props.max_brightness = ADP5020_MAX_BRIGHTNESS;
-	bl = backlight_device_register(pdev->name, data->master, data,
-				       &adp5520_bl_ops, &props);
+	bl = devm_backlight_device_register(&pdev->dev, pdev->name,
+					data->master, data, &adp5520_bl_ops,
+					&props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
 		return PTR_ERR(bl);
@@ -326,7 +327,7 @@ static int adp5520_bl_probe(struct platform_device *pdev)
 
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register sysfs\n");
-		backlight_device_unregister(bl);
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, bl);
@@ -347,8 +348,6 @@ static int adp5520_bl_remove(struct platform_device *pdev)
 		sysfs_remove_group(&bl->dev.kobj,
 				&adp5520_bl_attr_group);
 
-	backlight_device_unregister(bl);
-
 	return 0;
 }
 
-- 
1.7.10.4


