Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3I3AzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:55:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21437 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab3I3AzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:55:13 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-ab-5248cbf0b8d1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 06/14] regulator: lp8788-buck: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:55:12 +0900
Message-id: <007901cebd77$b7b95f20$272c1d60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAAJ0Hg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zY90Ppz2CDN7uFreY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF8l/rWBxYPXbOusvusWlVJ5tH35ZVjB7Hb2xn8vi8SS6ANYrLJiU1J7Ms
	tUjfLoErY9aFLywFW7kqlh5pYm9gvMPRxcjJISFgIvFk2T8WCFtM4sK99WxdjFwcQgLLGCV+
	b5nNClN0bNU3VojEdEaJuXumQlX9YpRYv/EwG0gVm4CaxJcvh9m7GDk4RARUJf6/cgepYRbo
	ZpS4uuwzO0iNkICtxJzzZxlBbE4BO4k7G1rBbGEBf4m1rSvAzmAB6v1x6CETiM0LVD9l/2MW
	CFtQ4sfke2A2s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJgJHHk5CSoEhGJfS/eMYLc
	IyFwj13iwtq9bBC7BCS+TT7EAtErK7HpADPEw5ISB1fcYJnAKDELyeZZSDbPQrJ5FpIVCxhZ
	VjGKphYkFxQnpReZ6BUn5haX5qXrJefnbmKExOqEHYz3DlgfYkwGWj+RWUo0OR8Y63kl8YbG
	ZkYWpiamxkbmlmakCSuJ86q3WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJzYMGVzpsyR
	+0F5Creef1N4aMnwvTzMLGnp49MS9z1fhq24ltR3bm7/xvwmBmn23W2xRie8/pcuu3BvEfc5
	37Wz7h6XSlnPwLpmp+9iqZnBL61ZHm3kPa7DUKkiVKwkZ/L+8afcT2eXLPiW9yP2UueFCUvV
	PzmY3d4l4tugzLze0vFLesRvFhslluKMREMt5qLiRABZDxqL6wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd0Ppz2CDC5sEraY+vAJm8XlhZdY
	Lb5d6WCyuLxrDpvF8l/rWBxYPXbOusvusWlVJ5tH35ZVjB7Hb2xn8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMWPWhS8sBVu5KpYeaWJvYLzD0cXIySEhYCJx
	bNU3VghbTOLCvfVsXYxcHEIC0xkl5u6ZCuX8YpRYv/EwG0gVm4CaxJcvh9m7GDk4RARUJf6/
	cgepYRboZpS4uuwzO0iNkICtxJzzZxlBbE4BO4k7G1rBbGEBf4m1rStYQGwWoN4fhx4ygdi8
	QPVT9j9mgbAFJX5MvgdmMwtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3VBwiICRhJHTk6CKhGR
	2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRnAie
	Se1gXNlgcYhRgINRiYd3wnKPICHWxLLiytxDjBIczEoivMuTgEK8KYmVValF+fFFpTmpxYcY
	k4EencgsJZqcD0xSeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTB
	KdXAeCw6JymziSfOcWbZTatGsWnzZPc9ennzYt3srYnn60VckwT/hWmIet5z+Hx16p5Zq07Y
	TXu71Xn+6o0HjRSF+x+nt/fvWGBSv3VDiv/7zQvn75LcH/DXgF02RUijplbizbHkZRFOMrOT
	lQVnH3NqV0n+UhH+q/jpXj2hLQfqxT7JT7J9qcN7RImlOCPRUIu5qDgRAPGMuyJIAwAA
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


