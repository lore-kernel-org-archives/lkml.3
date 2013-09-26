Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab3IZCK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:10:59 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:33836 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IZCK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:10:57 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-f1-524397b1c1ab
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Haojian Zhuang'" <haojian.zhuang@linaro.org>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 13/18] regulator: pcap: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:10:56 +0900
Message-id: <001301ceba5d$a2f2d070$e8d87150$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAASYbw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ92N052DDD5uYraY+vAJm8Xlc4cZ
	LS4vvMRq8e1KB5PF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoEr4/DFXraCdu6KQ/tmszUwzuHsYuTkkBAwkTg9v5cRwhaTuHBvPVsXIxeHkMAyRok3
	S6+ywhSd/zuLHSKxiFGiZdcbsA4hgV+MEv1PYkBsNgE1iS9fDgMVcXCICKhK/H/lDlLPLDCX
	UWLa4iZ2iHpbiVO/L7KB2JwCdhKnr20EWyAs4CGx5c5BZpBeFqDeTeuYQcK8QOWrvj1lg7AF
	JX5MvscCYjMLaEms33mcCcKWl9i85i1Yq4SAusSjv7ogYREBI4lNk1uhykUk9r14xwhyjoTA
	PXaJn9emgK1lERCQ+Db5EAtEr6zEpgPMEO9KShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnF
	KJpakFxQnJReZKpXnJhbXJqXrpecn7uJERKnE3cw3j9gfYgxGWj9RGYp0eR8YJznlcQbGpsZ
	WZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxHlvcp3vTtA2Z
	f799Xxq179/m1ptrcrWWpBxjePPapsPSMsSKLZSjx07ZTO66+2XLbVyTJ31I/Hb0zUUH0V2R
	ecrz61Vexqke+XLHTc7ObRV/T/DEsqsxsYG3piYKH5WUub9l04kJ9mF3/XUzHLWfRPjOnHdy
	ydTsyrm2p8rDDVxfz1Hzu9SoxFKckWioxVxUnAgAUyWjZ+kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd0N052DDH6/srGY+vAJm8Xlc4cZ
	LS4vvMRq8e1KB5PF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePwxV62gnbuikP7ZrM1MM7h7GLk5JAQMJE4
	/3cWO4QtJnHh3nq2LkYuDiGBRYwSLbveMIIkhAR+MUr0P4kBsdkE1CS+fDkM1MDBISKgKvH/
	lTtIPbPAXEaJaYub2CHqbSVO/b7IBmJzCthJnL62kRXEFhbwkNhy5yAzSC8LUO+mdcwgYV6g
	8lXfnrJB2IISPybfYwGxmQW0JNbvPM4EYctLbF7zFqxVQkBd4tFfXZCwiICRxKbJrVDlIhL7
	XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKTwDPp
	HYyrGiwOMQpwMCrx8F5gdg4SYk0sK67MPcQowcGsJML7zQgoxJuSWFmVWpQfX1Sak1p8iDEZ
	6M+JzFKiyfnABJVXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxS
	DYwV4rIvLy90On6Fz/HxnM7r+cwLXAX7SixfmOx5wFF5Itn39w3xC4XPZt/dm2rjFHzH4fax
	VVz3BUI103N/Plmn2Boy70t+XrX/l1n2UhkcbE3PLst0WJW9FpdseXPck82r/5CuntvJDXPM
	wr+nu0zSnHRA4inDzpqofblSJ6Onzgx3YlrevEaJpTgj0VCLuag4EQCfIQuFRgMAAA==
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


