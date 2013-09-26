Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab3IZCFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:05:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16032 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3IZCFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:05:36 -0400
X-AuditID: cbfee68e-b7f756d000004512-91-5243966f5d36
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Steve Twiss'" <stwiss.opensource@diasemi.com>,
        "'David Dajun Chen'" <david.chen@diasemi.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 05/18] regulator: fixed: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:05:35 +0900
Message-id: <000b01ceba5c$e35a8140$aa0f83c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAGb4w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t8zQ938ac5BBv/71C2mPnzCZnH7x2lW
	i8sLL7FafLvSwWRxedccNourv9ezOLB5rPik77Fz1l12j02rOtk8+rasYvT4vEkugDWKyyYl
	NSezLLVI3y6BK+P7X5aC8xwVm5bfZGlgXMjexcjJISFgIrHwTzMThC0mceHeerYuRi4OIYFl
	jBKrp85nhSl6tvsoM4gtJLCIUWLGJi2Iol+MEsfn/AYrYhNQk/jy5TDQVA4OEQFVif+v3EHC
	zAJnGSXuduhB9NpKnPp9kQ3E5hSwkzh9bSNYq7CAp8T1+5dZQGwWoNau2SsZQWxeoPrP676w
	QdiCEj8m32OBmKklsX7ncSYIW15i85q3zCBrJQTUJR791QUJiwgYSWxdcpsZokREYt+Ld4wg
	J0sI3GOX+Hf4ASPELgGJb5MPsUD0ykpsOsAM8a6kxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJG
	llWMoqkFyQXFSelFRnrFibnFpXnpesn5uZsYIdHat4Px5gHrQ4zJQOsnMkuJJucDoz2vJN7Q
	2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxcKpUek2bM
	XqMw46K87/qLTF7WtZxsVZPW/BYQyvRr2LWX68v+xzte1r3myDjalvxm+3XHZ42bH3H+SM1x
	4k7+t5LbUM76aIeIxkGuZ+nxl9PiNNd+Nwqp+Kn18PHZ6dVvY0I+fdrl3B28V2j9OU3uxH8f
	a2f+Vr/y9uSifU3Lnz4viDkcePypEktxRqKhFnNRcSIAWeQKKuwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAd38ac5BBi8mK1tMffiEzeL2j9Os
	FpcXXmK1+Halg8ni8q45bBZXf69ncWDzWPFJ32PnrLvsHptWdbJ59G1ZxejxeZNcAGtUA6NN
	RmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtAFSgpliTml
	QKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM0EDCOsaM739ZCs5zVGxafpOlgXEhexcjJ4eE
	gInEs91HmSFsMYkL99azgdhCAosYJWZs0upi5AKyfzFKHJ/zmxUkwSagJvHly2GgZg4OEQFV
	if+v3EHCzAJnGSXuduhB9NpKnPp9EWwOp4CdxOlrG8FahQU8Ja7fv8wCYrMAtXbNXskIYvMC
	1X9e94UNwhaU+DH5HgvETC2J9TuPM0HY8hKb17xlBlkrIaAu8eivLkhYRMBIYuuS28wQJSIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCU8Ez
	qR2MKxssDjEKcDAq8fBeYHYOEmJNLCuuzD3EKMHBrCTC+80IKMSbklhZlVqUH19UmpNafIgx
	GejRicxSosn5wDSVVxJvaGxiZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2M7neZNv55tTF2V6XBtvM8rgcqDRfdb0n4WHtAPGLm5SVPt2xJ9UnpXv69QPKNzvdo5TUl
	XO8M9i/mlOqffODY3u2Ty72V1r863Op/97jtHvEJBmun7n0tXFHVyMr+/zWniq921bMDq152
	nW1OzGLfe7a2cc3k27HdyXGfneqlFL3rTp0WPr/rmhJLcUaioRZzUXEiAM6AROVJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/fixed.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index de811f3..5dadcad 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -188,7 +188,8 @@ static int reg_fixed_voltage_probe(struct platform_device *pdev)
 	cfg.driver_data = drvdata;
 	cfg.of_node = pdev->dev.of_node;
 
-	drvdata->dev = regulator_register(&drvdata->desc, &cfg);
+	drvdata->dev = devm_regulator_register(&pdev->dev, &drvdata->desc,
+					       &cfg);
 	if (IS_ERR(drvdata->dev)) {
 		ret = PTR_ERR(drvdata->dev);
 		dev_err(&pdev->dev, "Failed to register regulator: %d\n", ret);
@@ -214,7 +215,6 @@ static int reg_fixed_voltage_remove(struct platform_device *pdev)
 {
 	struct fixed_voltage_data *drvdata = platform_get_drvdata(pdev);
 
-	regulator_unregister(drvdata->dev);
 	kfree(drvdata->desc.supply_name);
 	kfree(drvdata->desc.name);
 
-- 
1.7.10.4


