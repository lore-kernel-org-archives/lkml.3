Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3IZCDj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:03:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32243 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IZCDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:03:37 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-98-524395f8b649
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
In-reply-to: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
Subject: [PATCH V2 02/18] regulator: ab8500-ext: use devm_regulator_register()
Date: Thu, 26 Sep 2013 11:03:36 +0900
Message-id: <000801ceba5c$9c450690$d4cf13b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66XGktrYXfQ+q4TvOtJpq/iZ1T4wAAB0IQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zI90fU52DDK4uELdY/+AYk8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2BxYPXbOusvusWlVJ5tH35ZVjB7fl65h9/i8SS6ANYrLJiU1J7Ms
	tUjfLoEr4/DCDSwFt/gqrn35xtjA+Iu7i5GTQ0LAROLu7+VsELaYxIV764FsLg4hgWWMEg/W
	nGeBKfq/Zx5UYhGjxKq3f5khnF+MEjP3dTOBVLEJqEl8+XKYvYuRg0NEQFXi/yt3kBpmgYWM
	ElOWPGAGqRESsJU49fsi2DpOATuJ09c2soLYwgJ+Es++nwKbwwLUO3nDXbDNvED1b3e2sUPY
	ghI/Jt8DizMLaEms33mcCcKWl9i85i0zyF4JAXWJR391IU4wkjj0LwWiQkRi34t3jCDnSAjc
	Ypc4OWs2M8QqAYlvkw+xQLTKSmw6wAzxr6TEwRU3WCYwSsxCsngWksWzkCyehWTFAkaWVYyi
	qQXJBcVJ6UUmesWJucWleel6yfm5mxghkTphB+O9A9aHGJOB1k9klhJNzgdGel5JvKGxmZGF
	qYmpsZG5pRlpwkrivOot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGFuF73rzltk2t4n7
	hNkc4A8/ve1uodXytOkSz8S8nxyYfOW3Mc/drObfB0OYmLZoNScbBC5+Wx2/kaeRN8dgrvB9
	5kkfcgVumYSENzmvOGlbbJXRkzTZ6PMS74fCF4yUjhm5TuVJV1u6hCU788C0d44X3fSmd4Vf
	MX7IbPvvUbzFjidW3zgslViKMxINtZiLihMBdwUlUuoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd0fU52DDJYsFbZY/+AYk8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2BxYPXbOusvusWlVJ5tH35ZVjB7fl65h9/i8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePwwg0sBbf4Kq59+cbYwPiLu4uRk0NCwETi
	/555bBC2mMSFe+uBbC4OIYFFjBKr3v5lhnB+MUrM3NfNBFLFJqAm8eXLYfYuRg4OEQFVif+v
	3EFqmAUWMkpMWfKAGaRGSMBW4tTvi2BTOQXsJE5f28gKYgsL+Ek8+34KbA4LUO/kDXdZQGxe
	oPq3O9vYIWxBiR+T74HFmQW0JNbvPM4EYctLbF7zlhlkr4SAusSjv7oQJxhJHPqXAlEhIrHv
	xTvGCYxCs5AMmoVk0Cwkg2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgNPJPa
	wbiyweIQowAHoxIP7wVm5yAh1sSy4srcQ4wSHMxKIrzfjIBCvCmJlVWpRfnxRaU5qcWHGJOB
	/pzILCWanA9MUXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnV
	wDgrp26p9jYjXcV8u5Lijzuuxn6U5rG8soQl3tLt3U5lUxfm21Ldu5+U1D6qzpK0mabY3j3h
	8ATrJY5di4Mtji3YcM3QxC9jo7gw/51dt0sjytY7OHMeyzSXPv7gq3PFEZfzoZU/Fv+x+c60
	5uyu+r75qqe2vWH6qafeeNuH812hplXkHcbZ9UosxRmJhlrMRcWJAG42RgJHAwAA
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


