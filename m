Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab3IYHwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 03:52:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30338 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3IYHwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 03:52:12 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-f0-5242961ec993
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 02/20] regulator: ab8500: use devm_regulator_register()
Date: Wed, 25 Sep 2013 16:51:58 +0900
Message-id: <000b01ceb9c4$1c77e0b0$5567a210$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAADPYg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ125aU5BBovuS1msf3CMyWLqwyds
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX32LSqk82jb8sqRo/vS9ewe3zeJBfAGsVlk5Kak1mW
	WqRvl8CV0frpBmvBSZ6K7y3zWRsY13F1MXJwSAiYSDw+W97FyAlkiklcuLeerYuRi0NIYBmj
	xO4p09ggEiYS0x8uhEpMZ5TY1rCECcL5xShxYP0RZpAqNgE1iS9fDrODTBURUJX4/8odpIZZ
	YCGjxJQlD8BqhARsJZb/vc0CYnMK2Eksu/cZbIOwgLvEpQ9L2EFsFqDe81MuMIHYvED1jddv
	M0LYghI/Jt8D62UW0JJYv/M4E4QtL7F5zVtmiG/UJR791YU4wUji22ZeiAoRiX0v3jGCnCMh
	cI9d4triU4wQqwQkvk0+xALRKiux6QAzxL+SEgdX3GCZwCgxC8niWUgWz0KyeBaSFQsYWVYx
	iqYWJBcUJ6UXGesVJ+YWl+al6yXn525ihMRp/w7GuwesDzEmA62fyCwlmpwPjPO8knhDYzMj
	C1MTU2Mjc0sz0oSVxHnVWqwDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB2VXnpJ5581cU+
	d8buH/xbC9S5W6XMNLundURsP8Hl48TTc5/XaXKyxirNJ5m3J1zVebPijBq7AY9zzK9j885Z
	R3W+87hxc/PKo5slMtO8Prgp2aZsiFuSun5CjKN0B4f7AYnPd2K/d33tr3k2g4XDPLbYfLON
	1DqRhTqP1ZdN+fLUbtYyj0IlluKMREMt5qLiRAA7lEEy6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV25aU5BBtvniFusf3CMyWLqwyds
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX32LSqk82jb8sqRo/vS9ewe3zeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNH66QZrwUmeiu8t81kbGNdxdTFyckgImEhM
	f7iQDcIWk7hwbz2QzcUhJDCdUWJbwxImCOcXo8SB9UeYQarYBNQkvnw5zN7FyMEhIqAq8f+V
	O0gNs8BCRokpSx6A1QgJ2Eos/3ubBcTmFLCTWHbvM9gGYQF3iUsflrCD2CxAveenXGACsXmB
	6huv32aEsAUlfky+B9bLLKAlsX7ncSYIW15i85q3zCB7JQTUJR791YU4wUji22ZeiAoRiX0v
	3jFOYBSahWTQLCSDZiEZNAtJywJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYwWngmdQO
	xpUNFocYBTgYlXh4BY46BgmxJpYVV+YeYpTgYFYS4S2a6hQkxJuSWFmVWpQfX1Sak1p8iDEZ
	6M+JzFKiyfnAFJVXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxS
	DYwVwonTlx6LUJc7m1H7onDWx4LQczzqFrJLmf6vjDRTZ4/83LFt7WbvaSaWYYn6tRUaRou3
	zZym07/qljF70xVbZrkLE3Vi5OW0tn8q+j03/cn+hjn7GSZusN5erTHXZeuuwJdnalu547bq
	uU1r3Bu2R/Wx965bYjU5FdL3D8pqca98NjcxXFCJpTgj0VCLuag4EQCE/FF+RwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/ab8500.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index 603f192..a4a4a42 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -3058,16 +3058,12 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 	}
 
 	/* register regulator with framework */
-	info->regulator = regulator_register(&info->desc, &config);
+	info->regulator = devm_regulator_register(&pdev->dev, &info->desc,
+						  &config);
 	if (IS_ERR(info->regulator)) {
 		err = PTR_ERR(info->regulator);
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 			info->desc.name);
-		/* when we fail, un-register all earlier regulators */
-		while (--id >= 0) {
-			info = &abx500_regulator.info[id];
-			regulator_unregister(info->regulator);
-		}
 		return err;
 	}
 
@@ -3172,17 +3168,7 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 
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


