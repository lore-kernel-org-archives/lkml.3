Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3IYIGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:06:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34025 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3IYIGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:06:51 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-88-524299999a0e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Haojian Zhuang'" <haojian.zhuang@linaro.org>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 13/20] regulator: max8925: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:06:49 +0900
Message-id: <001601ceb9c6$2f86ce30$8e946a90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAm7SQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zA92ZM52CDHbMVbSY+vAJm8Xlc4cZ
	LS4vvMRq8e1KB5PF5V1z2BxYPXbOusvusWlVJ5vHnWt72Dz6tqxi9Pi8SS6ANYrLJiU1J7Ms
	tUjfLoEr4+62e8wFU7gr5jROYWlgXM7ZxcjJISFgIrHpzVs2CFtM4sK99UA2F4eQwDJGiU/n
	1zDCFD3vWwKVmM4osfx0FwuE84tR4v3uQ+wgVWwCahJfvhwGsjk4RARUJf6/cgepYRaYyygx
	bXETWI2QgK3E8r+3WUBsTgE7iWX3PoOtFhbwkHhxvR0szgLU+233RTCbF6j+6pkPjBC2oMSP
	yffA4swCWhLrdx5ngrDlJTavecsMsldCQF3i0V9dkLCIgJHEpEtTmCFKRCT2vXjHCHKPhMA9
	dokr228yQuwSkPg2+RALRK+sxKYDzBAPS0ocXHGDZQKjxCwkm2ch2TwLyeZZSFYsYGRZxSia
	WpBcUJyUXmSqV5yYW1yal66XnJ+7iRESqxN3MN4/YH2IMRlo/URmKdHkfGCs55XEGxqbGVmY
	mpgaG5lbmpEmrCTOq95iHSgkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBsXimz88U26nrWKOu
	3tq19NR3xQN2XNxeLoWpDNvOZB46kKMqxPnr1C0ReZ1PS9YrcE25ejVeK6gkTpc5Q7MokYn3
	SnM7k+Llbbf1o1RXXCnSYr1VuvZuUfukv7piukpGK29sOyJmuO1ERC//lXmlEYelJ6y1n5pb
	ErhXi23fn8IMiX55vkQhJZbijERDLeai4kQAMyz/eOsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd2ZM52CDPo2yFpMffiEzeLyucOM
	FpcXXmK1+Halg8ni8q45bA6sHjtn3WX32LSqk83jzrU9bB59W1YxenzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHF32z3mgincFXMap7A0MC7n7GLk5JAQMJF4
	3reEDcIWk7hwbz2QzcUhJDCdUWL56S4WCOcXo8T73YfYQarYBNQkvnw5DGRzcIgIqEr8f+UO
	UsMsMJdRYtriJrAaIQFbieV/b7OA2JwCdhLL7n0G2yAs4CHx4no7WJwFqPfb7otgNi9Q/dUz
	HxghbEGJH5PvgcWZBbQk1u88zgRhy0tsXvOWGWSvhIC6xKO/uiBhEQEjiUmXpjBDlIhI7Hvx
	jnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITgTPpHcw
	rmqwOMQowMGoxMMrcNQxSIg1say4MvcQowQHs5IIb9FUpyAh3pTEyqrUovz4otKc1OJDjMlA
	j05klhJNzgcmqbySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRq
	YFzLdG9v8w7Hn6UpC/7l+7ofFnW+MfGtjmLR4s6NVle3ndhfzp0cWbPl9+Xde85N/TuBa20n
	g/PDbUs85LJO6K7eEXJ+3ioZztRZxvfqEx6s07ffEBLwM30jl9nEO7URs4t4ZFan66xsFJpd
	Jmo+L/N9Qgnfxltze8XKrhrM7ldnkTwiMmXafB0lluKMREMt5qLiRAC/AJWKSAMAAA==
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


