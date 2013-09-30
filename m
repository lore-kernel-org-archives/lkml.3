Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3I3A6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:58:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18231 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3I3A54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:57:56 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-89-5248cc933925
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 11/14] regulator: tps6105x: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:57:54 +0900
Message-id: <007e01cebd78$18c76910$4a563b30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAAQCrw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zfd3JZzyCDLY84LGY+vAJm8XlhZdY
	Lb5d6WCymPJnOZPF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoEr49GWqewFz3kqWh9tYmtgvMvVxcjBISFgIjF/N0sXIyeQKSZx4d56ti5GLg4hgWWM
	Ehfu/mCFSJhIXJ83lQUiMZ1R4uOMx4wQzi9GiRmPXzKDVLEJqEl8+XKYHWSqiICqxP9X7iA1
	zAIzGSV29u9gAqkRErCVmHP+LCOIzSlgJ3FnQyuYLSzgI7Hk1Vl2EJsFqPfHzbdgJ/EC1a9p
	m8wMYQtK/Jh8DyzOLKAlsX7ncSYIW15i85q3zBDfqEs8+qsLEhYRMJL4fPcSM0SJiMS+F+/A
	bpYQeMQu0dN6ihVil4DEt8mHWCB6ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEj
	yypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MkEiduIPx/gHrQ4zJQOsnMkuJJucDIz2vJN7Q
	2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYzL3uxZ8/UZ
	Gzvrmsw7MxxEpq3x+yi7zHDPs/4X90M3dxzlcjJ2Yvdp8haNUdveVPl0/S39KTffzbd7vTqs
	J3e5gHEuQ99rga0TLiQ8yPhi8nXhpVdBK7PKdiey5+r9yVk8V0n44cE17Ztt40u9GJQ5V3k+
	PfZRRNX2fWySo+WmmMO2G6+IvlqgxFKckWioxVxUnAgAUAL3TOoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd3JZzyCDFa0clpMffiEzeLywkus
	Ft+udDBZTPmznMni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPFoy1T2guc8Fa2PNrE1MN7l6mLk5JAQMJG4
	Pm8qC4QtJnHh3nq2LkYuDiGB6YwSH2c8ZoRwfjFKzHj8khmkik1ATeLLl8PsXYwcHCICqhL/
	X7mD1DALzGSU2Nm/gwmkRkjAVmLO+bOMIDangJ3EnQ2tYLawgI/Ekldn2UFsFqDeHzffgm3m
	Bapf0zaZGcIWlPgx+R5YnFlAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYRMJL4fPcSM0SJ
	iMS+F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOBE
	8Ex6B+OqBotDjAIcjEo8vBZLPYKEWBPLiitzDzFKcDArifAuTwIK8aYkVlalFuXHF5XmpBYf
	YkwGenQis5Rocj4wSeWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsT
	B6dUA6P22k3PJY70/7Y+cli9dNP6PaYv/mbtXa6sv0pyze/w3Yt273xw+Y7gxg7ZHQ8LtmU4
	3Hx7KLxOPK/hfrjtAmC8eOnJXa7e5P/C9v+TlvuyPpf3dfodPDXH8/gF31eywVu1lGIM60/w
	1HmF9idObhYWtlnwctVl3WUCrkorHLRiJjz4WvtBxFGJpTgj0VCLuag4EQCYrRDwSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler,
and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/regulator/tps6105x-regulator.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/regulator/tps6105x-regulator.c b/drivers/regulator/tps6105x-regulator.c
index ec9453f..e0e818d 100644
--- a/drivers/regulator/tps6105x-regulator.c
+++ b/drivers/regulator/tps6105x-regulator.c
@@ -146,8 +146,9 @@ static int tps6105x_regulator_probe(struct platform_device *pdev)
 	config.driver_data = tps6105x;
 
 	/* Register regulator with framework */
-	tps6105x->regulator = regulator_register(&tps6105x_regulator_desc,
-						 &config);
+	tps6105x->regulator = devm_regulator_register(&pdev->dev,
+						      &tps6105x_regulator_desc,
+						      &config);
 	if (IS_ERR(tps6105x->regulator)) {
 		ret = PTR_ERR(tps6105x->regulator);
 		dev_err(&tps6105x->client->dev,
@@ -159,20 +160,12 @@ static int tps6105x_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int tps6105x_regulator_remove(struct platform_device *pdev)
-{
-	struct tps6105x *tps6105x = dev_get_platdata(&pdev->dev);
-	regulator_unregister(tps6105x->regulator);
-	return 0;
-}
-
 static struct platform_driver tps6105x_regulator_driver = {
 	.driver = {
 		.name  = "tps6105x-regulator",
 		.owner = THIS_MODULE,
 	},
 	.probe = tps6105x_regulator_probe,
-	.remove = tps6105x_regulator_remove,
 };
 
 static __init int tps6105x_regulator_init(void)
-- 
1.7.10.4


