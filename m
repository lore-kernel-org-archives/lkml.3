Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab3IZHvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:51:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45717 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab3IZHvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:51:20 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-75-5243e7769a3a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Haojian Zhuang'" <haojian.zhuang@linaro.org>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 08/14] regulator: max8925: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:51:18 +0900
Message-id: <003801ceba8d$2f3bdb10$8db39130$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAJKzw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ92y585BBrPuGltMffiEzeLyucOM
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGsVlk5Kak1mW
	WqRvl8CVcXfbPeaCKdwVcxqnsDQwLufsYuTgkBAwkbi4R6eLkRPIFJO4cG89WxcjF4eQwDJG
	iX9NT1khEiYSX9csY4dITGeUWHj6EiOE84tRovH+MxaQKjYBNYkvXw6zg0wVEVCV+P/KHaSG
	WWAuo8S0xU3sIDVCArYSjd/+gtVzCthJzNp/khnEFhbwlrg44whYDQtQ76UVfWCbeYHqHz57
	ygJhC0r8mHwPzGYW0JJYv/M4E4QtL7F5zVtmiG/UJR791QUJiwgYSRxpW8cOUSIise/FO7Cb
	JQTusUvMn/ccapeAxLfJh1ggemUlNh1ghnhYUuLgihssExglZiHZPAvJ5llINs9CsmIBI8sq
	RtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjJBInbCD8d4B60OMyUDrJzJLiSbnAyM9ryTe0NjM
	yMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MzvEb7qZv/r6T
	4YFbyr0Cqbnzl5fP2b30b2xMHouxxD1WX7O2w4ueHBF565sZp9QmWrZ42dJD579ZNuXMkD2q
	Fzj9xOeamqlx33NzHTb0tk3/+Gd2Z3rNkRXLznwsWrLbzOzedZMX0YGLvyzqEo+Wn/XIjPWC
	vBLD1yPWSVeXnd5yP+bZTOvt0kosxRmJhlrMRcWJAME2lJrqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd2y585BBvsbDSymPnzCZnH53GFG
	i8sLL7FafLvSwWRxedccNgdWj52z7rJ7bFrVyeZx59oeNo++LasYPT5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLi77R5zwRTuijmNU1gaGJdzdjFyckgImEh8
	XbOMHcIWk7hwbz1bFyMXh5DAdEaJhacvMUI4vxglGu8/YwGpYhNQk/jy5TBQBweHiICqxP9X
	7iA1zAJzGSWmLW4CmyQkYCvR+O0vWD2ngJ3ErP0nmUFsYQFviYszjoDVsAD1XlrRxwpi8wLV
	P3z2lAXCFpT4MfkemM0soCWxfudxJghbXmLzmrfMIHslBNQlHv3VBQmLCBhJHGlbxw5RIiKx
	78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4ETyT
	2sG4ssHiEKMAB6MSD+8FZucgIdbEsuLK3EOMEhzMSiK834yAQrwpiZVVqUX58UWlOanFhxiT
	gR6dyCwlmpwPTFJ5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp
	1cB48bUMy701j3N+bl+ce8OPu+LrQVmV11n9L1aZzvzUprsx3f459yYZnnvfO++w1nR/6chx
	DQ44KVD9OvmdfJHYVb8ZP441nTE+zqdtJP7g23GBVZ0eZrtyGhQ9+8usTZ3ebLy+gnetKHOI
	B2PS3fdS5bbP/9ytUD7+t6lWIDF3R9bbvCmpV2qUWIozEg21mIuKEwHQHt0RSAMAAA==
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
 drivers/regulator/max8925-regulator.c |   12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/regulator/max8925-regulator.c b/drivers/regulator/max8925-regulator.c
index d80b5fa..7595107 100644
--- a/drivers/regulator/max8925-regulator.c
+++ b/drivers/regulator/max8925-regulator.c
@@ -312,7 +312,7 @@ static int max8925_regulator_probe(struct platform_device *pdev)
 		if (pdata)
 			config.init_data = pdata;
 
-	rdev = regulator_register(&ri->desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, &ri->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "failed to register regulator %s\n",
 				ri->desc.name);
@@ -323,22 +323,12 @@ static int max8925_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int max8925_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-
-	regulator_unregister(rdev);
-
-	return 0;
-}
-
 static struct platform_driver max8925_regulator_driver = {
 	.driver		= {
 		.name	= "max8925-regulator",
 		.owner	= THIS_MODULE,
 	},
 	.probe		= max8925_regulator_probe,
-	.remove		= max8925_regulator_remove,
 };
 
 static int __init max8925_regulator_init(void)
-- 
1.7.10.4


