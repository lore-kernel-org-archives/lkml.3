Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab3LFHMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:12:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:16490 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab3LFHMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:12:43 -0500
X-AuditID: cbfee68d-b7f5c6d000004aff-9b-52a178ea9140
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
In-reply-to: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
Subject: [PATCH 6/6] regulator: stw481x-vmmc: use devm_regulator_register()
Date: Fri, 06 Dec 2013 16:12:41 +0900
Message-id: <000f01cef252$8dbe1d90$a93a58b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7yUb+lAqO9MkXdRJaD6VTAoDhw9gAALZlQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ91XFQuDDNb/4LaY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoEr4+2+M8wF/3kqbh64wdLA2MzdxcjJISFgItEx+Q4zhC0mceHeerYuRi4OIYFljBLb
	t59nhCm61DuNHSIxnVHi9LqnjBDOL0aJpdsbWEGq2ATUJL58OQxUxcEhIqAq8f+VO0gNs8BM
	Romd/TuYQOJCArYSq+5Xg5RzCthJ/Dn6BmyzsIC3xIar/WwgNgtQa++fj4wg5bxA5d23JUHC
	vAKCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZpFxCQF3i0V9dkLCIgJHEtBd7mCFKRCT2vXgH
	drGEwCN2iR8PrrFDrBKQ+Db5EAtEr6zEpgPQcJCUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDI
	sopRNLUguaA4Kb3IUK84Mbe4NC9dLzk/dxMjJE57dzDePmB9iDEZaP1EZinR5HxgnOeVxBsa
	mxlZmJqYGhuZW5qRJqwkzpv0MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OEo7c3HdoR
	pC73aMOChXc+aX2MKTw+2WBT5DsvG1PP0EJtt4Wb1jqdEJ+5QZ2T/5j9vI1XpbfxzfHsDn56
	tK1n/4y1q+eI3z7SoHdd2ELR3YpBY8W7xe0fQ95Ub7u7Z/qcn2bbmMJ2bjTamWHnYbz6133R
	xOkrGk/FyX53EAhjesu3+dd+m49WSizFGYmGWsxFxYkAj4kaFOkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd1XFQuDDB5P5bCY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePtvjPMBf95Km4euMHSwNjM3cXIySEhYCJx
	qXcaO4QtJnHh3nq2LkYuDiGB6YwSp9c9ZYRwfjFKLN3ewApSxSagJvHly2GgDg4OEQFVif+v
	3EFqmAVmMkrs7N/BBBIXErCVWHW/GqScU8BO4s/RN8wgtrCAt8SGq/1sIDYLUGvvn4+MIOW8
	QOXdtyVBwrwCghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGaRcQkBd4tFfXZCwiICRxLQXe5gh
	SkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIE
	J4FnUjsYVzZYHGIU4GBU4uHlWLUgSIg1say4MvcQowQHs5IIb4/4wiAh3pTEyqrUovz4otKc
	1OJDjMlAf05klhJNzgcmqLySeENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbB
	bGHi4JRqYNSeyyKQq7Hy85cdZ5SUl6125f+lHX/IdHdm1lJG9dkb9GyNKllOVQgZem3/Mm9r
	yHm+JqU4g93ZbUenvLj2da1K68bnzbwd0V4SKQ5X5NZ67JB0vjNpT93Oj0fEjs9PnsF780B5
	6gO5bn4/lSyVOlNdPmHVfN+vggv/F8lvvxC48rmq6OyjfEosxRmJhlrMRcWJAIK8KU5GAwAA
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
 drivers/regulator/stw481x-vmmc.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/stw481x-vmmc.c b/drivers/regulator/stw481x-vmmc.c
index f78857b..a7e1526 100644
--- a/drivers/regulator/stw481x-vmmc.c
+++ b/drivers/regulator/stw481x-vmmc.c
@@ -74,7 +74,8 @@ static int stw481x_vmmc_regulator_probe(struct platform_device *pdev)
 	config.init_data = of_get_regulator_init_data(&pdev->dev,
 						      pdev->dev.of_node);
 
-	stw481x->vmmc_regulator = regulator_register(&vmmc_regulator, &config);
+	stw481x->vmmc_regulator = devm_regulator_register(&pdev->dev,
+						&vmmc_regulator, &config);
 	if (IS_ERR(stw481x->vmmc_regulator)) {
 		dev_err(&pdev->dev,
 			"error initializing STw481x VMMC regulator\n");
@@ -85,14 +86,6 @@ static int stw481x_vmmc_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int stw481x_vmmc_regulator_remove(struct platform_device *pdev)
-{
-	struct stw481x *stw481x = dev_get_platdata(&pdev->dev);
-
-	regulator_unregister(stw481x->vmmc_regulator);
-	return 0;
-}
-
 static const struct of_device_id stw481x_vmmc_match[] = {
 	{ .compatible = "st,stw481x-vmmc", },
 	{},
@@ -105,7 +98,6 @@ static struct platform_driver stw481x_vmmc_regulator_driver = {
 		.of_match_table = stw481x_vmmc_match,
 	},
 	.probe = stw481x_vmmc_regulator_probe,
-	.remove = stw481x_vmmc_regulator_remove,
 };
 
 module_platform_driver(stw481x_vmmc_regulator_driver);
-- 
1.7.10.4


