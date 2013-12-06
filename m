Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab3LFHHP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 02:07:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:44873 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3LFHHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 02:07:11 -0500
X-AuditID: cbfee68f-b7f256d000003c1b-42-52a1779d068b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>,
        "'Axel Lin'" <axel.lin@ingics.com>
Subject: [PATCH 1/6] regulator: ab8500: use devm_regulator_register()
Date: Fri, 06 Dec 2013 16:07:09 +0900
Message-id: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7yUb+lAqO9MkXdRJaD6VTAoDhw9g==
Content-language: ko
x-cr-hashedpuzzle: B6p4 i4cf vH+a yZbS 1MmC AAWnCQ== AAmIxA== AA33fw== ABCOaA==
 ABZ7dg== AB+Xsg== ACnDfA== ADnTZQ== AE0VJg== AFAmrg==
 AFvadQ==;7;YQB4AGUAbAAuAGwAaQBuAEAAaQBuAGcAaQBjAHMALgBjAG8AbQA7AGIAZQBuAGcAdAAuAGcALgBqAG8AbgBzAHMAbwBuAEAAcwB0AGUAcgBpAGMAcwBzAG8AbgAuAGMAbwBtADsAYgByAG8AbwBuAGkAZQBAAGsAZQByAG4AZQBsAC4AbwByAGcAOwBqAGcAMQAuAGgAYQBuAEAAcwBhAG0AcwB1AG4AZwAuAGMAbwBtADsAbABlAGUALgBqAG8AbgBlAHMAQABsAGkAbgBhAHIAbwAuAG8AcgBnADsAbABnAGkAcgBkAHcAbwBvAGQAQABnAG0AYQBpAGwALgBjAG8AbQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcA;Sosha1_v1;7;{16487644-B78F-4963-98A3-171330066DA9};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 06 Dec 2013 07:06:56
 GMT;WwBQAEEAVABDAEgAIAAxAC8ANgBdACAAcgBlAGcAdQBsAGEAdABvAHIAOgAgAGEAYgA4ADUAMAAwADoAIAB1AHMAZQAgAGQAZQB2AG0AXwByAGUAZwB1AGwAYQB0AG8AcgBfAHIAZQBnAGkAcwB0AGUAcgAoACkA
x-cr-puzzleid: {16487644-B78F-4963-98A3-171330066DA9}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsVy+t8zI9155QuDDM75WByZ85XZYv2DY0wW
	Ux8+YbO4vPASq8X9r0cZLb5d6WCyuLxrDpsDu8fOWXfZPdp+lnlsWtXJ5nHn2h42j74tqxg9
	vi9dw+7xeZNcAHsUl01Kak5mWWqRvl0CV8aiWyvYC47wV8x+vYyxgfE1TxcjJ4eEgInE5cn9
	jBC2mMSFe+vZuhi5OIQEljFKfHp3kAWm6PmLLmaIxHRGiZ7ub+wQzi8gZ/JsZpAqNgE1iS9f
	DgMlODhEBFQl/r9yB6lhFnjJKPFgcx8TSI2wgKtE6+V5jCA1LEA11+Zpg4R5BWwl5vZsYYGw
	BSV+TL4HZjMLaEms33mcCcKWl9i85i0zSKuEgLrEo7+6IGERAT2Ji8d/QpWLSOx78Y4RZK2E
	wAs2iYUn25kg6k0l7j4qhIj/ZJeY8/0qWAOLgIDEt8mHWCBqZCU2HWCG+FdS4uCKGywTGCVm
	IbloFpKLZiG5aBaS1QsYWVYxiqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihERz/w7GuwesDzEm
	A62fyCwlmpwPTAZ5JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNa
	fIiRiYNTqoExkPll7dSbm74eEw3o7jK9+bFXPzFby/NT3RXpdmOr2SejVpcKdyxMn5V0K4Bj
	n3fp7t8HPzRtFvspe6z1z5Ul4rPObKoQUQ1JTBP/FjCve2WG3cV7PG9l1ua0u7tsyP6etMTn
	2LmOBj+Wqrxc9/2OoQ822YmvDD+4v8YvacXsPe/rH0i1R9xQYinOSDTUYi4qTgQAD7NlIfwC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jQd255QuDDKa2WlocmfOV2WL9g2NM
	FlMfPmGzuLzwEqvF/a9HGS2+Xelgsri8aw6bA7vHzll32T3afpZ5bFrVyeZx59oeNo++LasY
	Pb4vXcPu8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
	kotPgK5bZg7QQUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjEW3VrAX
	HOGvmP16GWMD42ueLkZODgkBE4nnL7qYIWwxiQv31rN1MXJxCAlMZ5To6f7GDuH8AnImzwar
	YhNQk/jy5TBQgoNDREBV4v8rd5AaZoGXjBIPNvcxgdQIC7hKtF6exwhSwwJUc22eNkiYV8BW
	Ym7PFhYIW1Dix+R7YDazgJbE+p3HmSBseYnNa94yg7RKCKhLPPqrCxIWEdCTuHj8J1S5iMS+
	F+8YQdZKCLxgk1h4sp0Jot5U4u6jwgmMQrOQbJiFZMMsJBtmIRm1gJFlFaNoakFyQXFSeq6R
	XnFibnFpXrpecn7uJkZwsngmvYNxVYPFIUYBDkYlHl6OVQuChFgTy4orcw8xSnAwK4nw9ogv
	DBLiTUmsrEotyo8vKs1JLT7EmAz0/0RmKdHkfGAiyyuJNzQ2MTOyNDKzMDIxNydNWEmc92Cr
	daCQQHpiSWp2ampBahHMFiYOTqkGxgDXCWoFN54daMnMFrXzNO4Xk9x07dz0+ETVGn/J7zM1
	kn9WBez8VTm/1XlxZ1XDy+RJqTsMk9zVha+Jye1j/jWPY/MWDamd+lbfns/2+ppvqPk0pOyF
	fSnTcac3VjxbXTq7Kid6zdv4y8Hih3XW9f+rBFt+eZ3Yz7pycfgMf5uuyv1L/xTFKLEUZyQa
	ajEXFScCABdY/2taAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/ab8500.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 0f86695..c625468 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3005,7 +3005,6 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_regulator_info *info = NULL;
 	struct regulator_config config = { };
-	int err;
 
 	/* assign per-regulator data */
 	info = &abx500_regulator.info[id];
@@ -3027,17 +3026,12 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 	}
 
 	/* register regulator with framework */
-	info->regulator = regulator_register(&info->desc, &config);
+	info->regulator = devm_regulator_register(&pdev->dev, &info->desc,
+						&config);
 	if (IS_ERR(info->regulator)) {
-		err = PTR_ERR(info->regulator);
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			info->desc.name);
-		/* when we fail, un-register all earlier regulators */
-		while (--id >= 0) {
-			info = &abx500_regulator.info[id];
-			regulator_unregister(info->regulator);
-		}
-		return err;
+		return PTR_ERR(info->regulator);
 	}
 
 	return 0;
@@ -3086,17 +3080,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 
 static int ab8500_regulator_remove(struct platform_device *pdev)
 {
-	int i, err;
-
-	for (i = 0; i < abx500_regulator.info_size; i++) {
-		struct ab8500_regulator_info *info = NULL;
-		info = &abx500_regulator.info[i];
-
-		dev_vdbg(rdev_get_dev(info->regulator),
-			"%s-remove\n", info->desc.name);
-
-		regulator_unregister(info->regulator);
-	}
+	int err;
 
 	/* remove regulator debug */
 	err = ab8500_regulator_debug_exit(pdev);
-- 
1.7.10.4


