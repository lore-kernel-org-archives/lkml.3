Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3IZHrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:47:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:27000 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab3IZHrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:47:45 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-cb-5243e69f8a04
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 02/14] regulator: ab8500-ext: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:47:43 +0900
Message-id: <003201ceba8c$af22bc00$0d683400$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAArcQ
Content-language: ko
x-cr-hashedpuzzle: AeB0 BlRI CT36 PH1m P48l UQXD U5Pd YAU9 Ylu4 b+qj coqo crAr
 gUw7 hrPL kteq
 mBSb;5;YgBlAG4AZwB0AC4AZwAuAGoAbwBuAHMAcwBvAG4AQABzAHQAZQByAGkAYwBzAHMAbwBuAC4AYwBvAG0AOwBiAHIAbwBvAG4AaQBlAEAAawBlAHIAbgBlAGwALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGcAaQByAGQAdwBvAG8AZABAAGcAbQBhAGkAbAAuAGMAbwBtADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{3239E0E4-120D-4210-814F-BBB507A5375E};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 26 Sep 2013 07:47:37
 GMT;WwBQAEEAVABDAEgAIABWADMAIAAwADIALwAxADQAXQAgAHIAZQBnAHUAbABhAHQAbwByADoAIABhAGIAOAA1ADAAMAAtAGUAeAB0ADoAIAB1AHMAZQAgAGQAZQB2AG0AXwByAGUAZwB1AGwAYQB0AG8AcgBfAHIAZQBnAGkAcwB0AGUAcgAoACkA
x-cr-puzzleid: {3239E0E4-120D-4210-814F-BBB507A5375E}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zfd35z5yDDJads7BY/+AYk8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2BxYPXbOusvusWlVJ5tH35ZVjB7fl65h9/i8SS6ANYrLJiU1J7Ms
	tUjfLoEr4/DCDSwFt/gqrn35xtjA+Iu7i5GDQ0LARGLpHq0uRk4gU0ziwr31bF2MXBxCAssY
	JdbvnsYEU7NygjpEfDqjxJajd6CKfjFKXD7QzArSzSagJvHly2F2kAYRAVWJ/6/cQWqYBRYy
	SkxZ8oAZpEZIwFai8dtfFhCbU8BOYtb+k8wg9cICfhKP99WBhFmAWn/Mb2YCsXmBytc/28wM
	YQtK/Jh8D6yVWUBLYv3O40wQtrzE5jVvmSHuVJd49FcXJCwiYCRxcP4PZogSEYl9L94xgpwj
	IfCCVeL7s+0sEA+bSnw+0ssGkfjLLrFrzXEWiCMEJL5NPsQCMVRWYtMBZoh6SYmDK26wTGCU
	moXkpFlITpqF5KRZSHYvYGRZxSiaWpBcUJyUXmSqV5yYW1yal66XnJ+7iRES1xN3MN4/YH2I
	MRlo/URmKdHkfGBayCuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQn
	tfgQIxMHp1QDI6tL5elLfZ7fKi8xrSmzLLQNLY+1u6m3ctnzxMwpBssdlfxObuFwdL0ttoNj
	tfGKyrvbBIKbTdcePvD5Ytr2FPekH0L3ThX4i2dYTshW9ls+W/WHdtnknzvD6u1D1BujXx3c
	eoV1yvp0MbvKxP8tNQrz5qtu/n7y7zOuY816jvzxRtH79wq9VmIpzkg01GIuKk4EAAbU2lEB	AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDKsWRmVeSWpSXmKPExsVy+t9jQd35z5yDDI4tMbFY/+AYk8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2BxYPXbOusvusWlVJ5tH35ZVjB7fl65h9/i8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePwwg0sBbf4Kq59+cbYwPiLu4uRg0NCwERi
	5QT1LkZOIFNM4sK99WxdjFwcQgLTGSW2HL0D5fxilLh8oJkVpIpNQE3iy5fD7CDNIgKqEv9f
	uYPUMAssZJSYsuQBM0iNkICtROO3vywgNqeAncSs/SeZQeqFBfwkHu+rAwmzALX+mN/MBGLz
	ApWvf7aZGcIWlPgx+R5YK7OAlsT6nceZIGx5ic1r3jJD3Kwu8eivLkhYRMBI4uD8H8wQJSIS
	+168YwQ5R0LgBavE92fbWSAeM5X4fKSXbQKjyCwkK2YhWTELyYpZSGYtYGRZxSiaWpBcUJyU
	nmuoV5yYW1yal66XnJ+7iRGcNp5J7WBc2WBxiFGAg1GJh/cCs3OQEGtiWXFl7iFGCQ5mJRHe
	b0ZAId6UxMqq1KL8+KLSnNTiQ4zJwBCYyCwlmpwPTGl5JfGGxiZmRpZGZhZGJubmpAkrifMe
	aLUOFBJITyxJzU5NLUgtgtnCxMEp1cC4bvuJlFBWjsi8twGWu5Z8v/puTfqvG2HTSkS35zce
	9AtpNGzfsj/1a2Qf0+cM0/h1nv6JZvODZGeeD/Fr/5V7mOXtL5Yv79rV+5eEOJ18bnqSV0Vz
	23tJyQjHB5fmyO7t0NLU853W03OybcWEP42M0+5uXazMdd+YV76esUjqz5/HGg+MC64qsRRn
	JBpqMRcVJwIApA7cdF8DAAA=
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
 drivers/regulator/ab8500-ext.c |   26 ++------------------------
 1 file changed, 2 insertions(+), 24 deletions(-)

diff --git a/drivers/regulator/ab8500-ext.c b/drivers/regulator/ab8500-ext.c
index 02ff691..29c0faa 100644
--- a/drivers/regulator/ab8500-ext.c
+++ b/drivers/regulator/ab8500-ext.c
@@ -413,16 +413,12 @@ static int ab8500_ext_regulator_probe(struct platform_device *pdev)
 			&pdata->ext_regulator[i];
 
 		/* register regulator with framework */
-		info->rdev = regulator_register(&info->desc, &config);
+		info->rdev = devm_regulator_register(&pdev->dev, &info->desc,
+						     &config);
 		if (IS_ERR(info->rdev)) {
 			err = PTR_ERR(info->rdev);
 			dev_err(&pdev->dev, "failed to register regulator %s\n",
 					info->desc.name);
-			/* when we fail, un-register all earlier regulators */
-			while (--i >= 0) {
-				info = &ab8500_ext_regulator_info[i];
-				regulator_unregister(info->rdev);
-			}
 			return err;
 		}
 
@@ -433,26 +429,8 @@ static int ab8500_ext_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int ab8500_ext_regulator_remove(struct platform_device *pdev)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(ab8500_ext_regulator_info); i++) {
-		struct ab8500_ext_regulator_info *info = NULL;
-		info = &ab8500_ext_regulator_info[i];
-
-		dev_vdbg(rdev_get_dev(info->rdev),
-			"%s-remove\n", info->desc.name);
-
-		regulator_unregister(info->rdev);
-	}
-
-	return 0;
-}
-
 static struct platform_driver ab8500_ext_regulator_driver = {
 	.probe = ab8500_ext_regulator_probe,
-	.remove = ab8500_ext_regulator_remove,
 	.driver         = {
 		.name   = "ab8500-ext-regulator",
 		.owner  = THIS_MODULE,
-- 
1.7.10.4


