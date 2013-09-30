Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab3I3Az5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:55:57 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17887 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab3I3Azx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:55:53 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-24-5248cc18143c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 07/14] regulator: lp8788-ldo: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:55:51 +0900
Message-id: <007a01cebd77$cf595860$6e0c0920$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAALN1A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY12JMx5BBq3zmS2mPnzCZnF54SVW
	i29XOpgsLu+aw2ax/Nc6FgdWj52z7rJ7bFrVyebRt2UVo8fxG9uZPD5vkgtgjeKySUnNySxL
	LdK3S+DKWNpvVjBDsOJ6ayNTA+Nyvi5GTg4JAROJp/sXM0PYYhIX7q1nA7GFBJYxShz6ZQ1T
	8+bZYaYuRi6g+CJGieYJR1ghnF+MEnMbP4F1sAmoSXz5cpi9i5GDQ0RAVeL/K3eQGmaBbkaJ
	q8s+s0NMtZWYc/4sI4jNKWAncWdDK5gtLOAn0XT8HZjNAtR7/vgbsJm8IPWHGpggbEGJH5Pv
	sYDYzAJaEut3HmeCsOUlNq95ywyyV0JAXeLRX12QsIiAkcTla5uZIUpEJPa9ABnPBVRyj11i
	yvwNzBC7BCS+TT7EAtErK7HpADQgJCUOrrjBMoFRYhaSzbOQbJ6FZPMsJCsWMLKsYhRNLUgu
	KE5KLzLVK07MLS7NS9dLzs/dxAiJ04k7GO8fsD7EmAy0fiKzlGhyPjDO80riDY3NjCxMTUyN
	jcwtzUgTVhLnVW+xDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeFK06Bjb0Y3Fek1+Dt/n
	yaUEntglbG4gqJ5d53l9B6Oa+ept+ocq03+KNkrl/0yVDl5ibnSg1XXxZd88nm+9Pzx2lQh4
	12j/cAz4eaSzyMhPy/0MU97Cr+vZj25KdP/o79DboxY0v+mfaJjBt+sd0wIWMkyUzXyvfvBd
	1cV3N6WEjQ3/lOxUYinOSDTUYi4qTgQAg7xR9+kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAV3xMx5BBjNW2lhMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLG036xghmDF9dZGpgbG5XxdjJwcEgImEm+e
	HWaCsMUkLtxbz9bFyMUhJLCIUaJ5whFWCOcXo8Tcxk9sIFVsAmoSX74cZu9i5OAQEVCV+P/K
	HaSGWaCbUeLqss/sIDVCArYSc86fZQSxOQXsJO5saAWzhQX8JJqOvwOzWYB6zx9/AzaTF6T+
	UAMThC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lB9koIqEs8+qsLEhYRMJK4fG0zM0SJiMS+
	F+8YJzAKzUIyaRaSSbOQTJqFpGUBI8sqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOA08Ex6
	B+OqBotDjAIcjEo8vBZLPYKEWBPLiitzDzFKcDArifAuTwIK8aYkVlalFuXHF5XmpBYfYkwG
	enQis5Rocj4wReWVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dU
	A+Omjk2GzWviL31WdWg68PV8/HvFgCtxlxfFiyft69LhsD7z32va//4J8zlND9xM1pp6cMZj
	t8kP+JZ+rlkt5Xi0pz9TdgvjFL22ps+9m2aY/Vzb++7y3JjZ87/l/+K24Thi47tA6HDy49Pl
	4u3nCl7d2H5q0j6XVp6kiVumGswNuWi0/d9PEYcPSizFGYmGWsxFxYkAkpdkC0cDAAA=
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
 drivers/regulator/lp8788-ldo.c |   24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/regulator/lp8788-ldo.c b/drivers/regulator/lp8788-ldo.c
index 0527d87..b9a29a2 100644
--- a/drivers/regulator/lp8788-ldo.c
+++ b/drivers/regulator/lp8788-ldo.c
@@ -543,7 +543,7 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 	cfg.driver_data = ldo;
 	cfg.regmap = lp->regmap;
 
-	rdev = regulator_register(&lp8788_dldo_desc[id], &cfg);
+	rdev = devm_regulator_register(&pdev->dev, &lp8788_dldo_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(&pdev->dev, "DLDO%d regulator register err = %d\n",
@@ -557,18 +557,8 @@ static int lp8788_dldo_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int lp8788_dldo_remove(struct platform_device *pdev)
-{
-	struct lp8788_ldo *ldo = platform_get_drvdata(pdev);
-
-	regulator_unregister(ldo->regulator);
-
-	return 0;
-}
-
 static struct platform_driver lp8788_dldo_driver = {
 	.probe = lp8788_dldo_probe,
-	.remove = lp8788_dldo_remove,
 	.driver = {
 		.name = LP8788_DEV_DLDO,
 		.owner = THIS_MODULE,
@@ -603,7 +593,7 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 	cfg.driver_data = ldo;
 	cfg.regmap = lp->regmap;
 
-	rdev = regulator_register(&lp8788_aldo_desc[id], &cfg);
+	rdev = devm_regulator_register(&pdev->dev, &lp8788_aldo_desc[id], &cfg);
 	if (IS_ERR(rdev)) {
 		ret = PTR_ERR(rdev);
 		dev_err(&pdev->dev, "ALDO%d regulator register err = %d\n",
@@ -617,18 +607,8 @@ static int lp8788_aldo_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int lp8788_aldo_remove(struct platform_device *pdev)
-{
-	struct lp8788_ldo *ldo = platform_get_drvdata(pdev);
-
-	regulator_unregister(ldo->regulator);
-
-	return 0;
-}
-
 static struct platform_driver lp8788_aldo_driver = {
 	.probe = lp8788_aldo_probe,
-	.remove = lp8788_aldo_remove,
 	.driver = {
 		.name = LP8788_DEV_ALDO,
 		.owner = THIS_MODULE,
-- 
1.7.10.4


