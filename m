Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947Ab3IZHuQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:50:16 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29804 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab3IZHuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:50:15 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-e6-5243e7366f90
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 06/14] regulator: lp8788-buck: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:50:13 +0900
Message-id: <003601ceba8d$08b1fb00$1a15f100$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAG75g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA12z585BBmtPcVtMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMevCF5aCrVwVS480sTcw3uHoYuTkkBAwkfj97S4jhC0mceHeejYQW0hgGaPEorPu
	MDUr+x8A1XABxRcxSrStfcUC4fxilJi5/DI7SBWbgJrEly+HgWwODhEBVYn/r9xBapgFuhkl
	ri77zA4x1Vai8dtfFhCbU8BOYtb+k8wgtrCAv8STtlNgNgtQ74K+SWD1vED1HTc/MUPYghI/
	Jt8D62UW0JJYv/M4E4QtL7F5zVtmkL0SAuoSj/7qgoRFBIwkjvVMYYcoEZHY9+Id2AMSAvfY
	JW52bGCH2CUg8W3yIRaIXlmJTQeYIR6WlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1
	ILmgOCm9yFivODG3uDQvXS85P3cTIyRS+3cw3j1gfYgxGWj9RGYp0eR8YKTnlcQbGpsZWZia
	mBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxnn7vvd4/7V8/7Qx6
	2+YllKBzQf9GhW/wwqATgcIN0/uMlwUL700Ol1wg2rcu+vPV7Qm758T+lKhYv+RrwYzTUSfK
	dk61dRL5/Txs4vZ3D+YsfyCaMmV/eG5kl5p90/X33Z/69ljo5SSwt7cVi240i9ngOsXD68MN
	A5a1kS8+ND3bryC/8qeYEktxRqKhFnNRcSIAB/GkheoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAV2z585BBod2sVtMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDHrwheWgq1cFUuPNLE3MN7h6GLk5JAQMJFY
	2f+AEcIWk7hwbz1bFyMXh5DAIkaJtrWvWCCcX4wSM5dfZgepYhNQk/jy5TCQzcEhIqAq8f+V
	O0gNs0A3o8TVZZ/BaoQEbCUav/1lAbE5BewkZu0/yQxiCwv4SzxpOwVmswD1LuibBFbPC1Tf
	cfMTM4QtKPFj8j2wXmYBLYn1O48zQdjyEpvXvGUG2SshoC7x6K8uSFhEwEjiWM8UdogSEYl9
	L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGJ4Jn0
	DsZVDRaHGAU4GJV4eC8wOwcJsSaWFVfmHmKU4GBWEuH9ZgQU4k1JrKxKLcqPLyrNSS0+xJgM
	9OhEZinR5HxgksoriTc0NjEzsjQyszAyMTcnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6p
	Bsa8qxtO3JgmezHr7MZVn1jvv7ZMTub3+aHd/HWPWd5qmQtPtW9l293cPPF2prr2RS7F6jnW
	Dstz1Z+q2i3nCCr0Pvw2yvhUgpHDj4c/XkvzNk1+6ryC6a3N0YjQlwcS7Kae9Xi7Ou1b4teS
	4kO7086tSCtZGPA02Dn4wTvmEvYmt1nah15Oy72qxFKckWioxVxUnAgAZbVgd0gDAAA=
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
 drivers/regulator/lp8788-buck.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index 0b015f2..948afc2 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -515,7 +515,7 @@ static int lp8788_buck_probe(struct platform_device *pdev)
 	cfg.driver_data = buck;
 	cfg.regmap = lp->regmap;
 
-	rdev = regulator_register(&lp8788_buck_desc[id], &cfg);
+	rdev = devm_regulator_register(&pdev->dev, &lp8788_buck_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(&pdev->dev, "BUCK%d regulator register err = %d\n",
@@ -529,18 +529,8 @@ static int lp8788_buck_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int lp8788_buck_remove(struct platform_device *pdev)
-{
-	struct lp8788_buck *buck = platform_get_drvdata(pdev);
-
-	regulator_unregister(buck->regulator);
-
-	return 0;
-}
-
 static struct platform_driver lp8788_buck_driver = {
 	.probe = lp8788_buck_probe,
-	.remove = lp8788_buck_remove,
 	.driver = {
 		.name = LP8788_DEV_BUCK,
 		.owner = THIS_MODULE,
-- 
1.7.10.4


