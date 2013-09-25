Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3IYIEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:04:50 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33552 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3IYIEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:04:46 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-2a-5242991d940d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Milo Kim'" <milo.kim@ti.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 11/20] regulator: lp8788-buck: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:04:45 +0900
Message-id: <001401ceb9c5$e5de4c90$b19ae5b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAi8Qw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ13ZmU5BBq9/GFlMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMevCF5aCrVwVS480sTcw3uHoYuTgkBAwkdgyqaKLkRPIFJO4cG89WxcjF4eQwDJG
	iYWPb7FDJEwkPr/9xAKRWMQoMXPCI6iqX4wSD1adYAOpYhNQk/jy5TA7yFQRAVWJ/6/cQWqY
	BboZJa4u+ww2SUjAVmL539ssIDangJ3EsnufwXqFBXwkeprbmUBsFqDe6X/6WEFsXqD6Qwcu
	M0PYghI/Jt8D62UW0JJYv/M4E4QtL7F5zVtmiG/UJR791QUJiwgYSRxcsJgZokREYt+Ld4wg
	90gIPGKXePxuNSvELgGJb5MPsUD0ykpsOsAM8bCkxMEVN1gmMErMQrJ5FpLNs5BsnoVkxQJG
	llWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYIZHav4Px7gHrQ4zJQOsnMkuJJucDIz2vJN7Q
	2MzIwtTE1NjI3NKMNGElcV61FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYz+dQvqPx+J
	+nb2Z7WWLds/xvCthiZ8vy2WH1i4mtmo0WahpFb4o+DAJ2UsKSn7OMMn7chbOZ/dqqOv5P/e
	Qv3C1+s/C/+1Pqz7Wmdj35+ZfRwdoTZ3GKtVLesybt1ee0Fdf2EQZ1mo1O+MzS/nx9XvaZwz
	nWVy7o6JGesf71zJ9EHowBSdi2+UWIozEg21mIuKEwGMpVuH6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jAV3ZmU5BBvMX6VtMffiEzeLywkus
	Ft+udDBZXN41h81i+a91LA6sHjtn3WX32LSqk82jb8sqRo/jN7YzeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDHrwheWgq1cFUuPNLE3MN7h6GLk5JAQMJH4
	/PYTC4QtJnHh3nq2LkYuDiGBRYwSMyc8gnJ+MUo8WHWCDaSKTUBN4suXw+xdjBwcIgKqEv9f
	uYPUMAt0M0pcXfaZHaRGSMBWYvnf22BTOQXsJJbd+wzWKyzgI9HT3M4EYrMA9U7/08cKYvMC
	1R86cJkZwhaU+DH5Hlgvs4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJgJHFwwWJmiBIR
	iX0v3jFOYBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwYng
	mfQOxlUNFocYBTgYlXh4BY46BgmxJpYVV+YeYpTgYFYS4S2a6hQkxJuSWFmVWpQfX1Sak1p8
	iDEZ6NGJzFKiyfnAJJVXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1M
	HJxSDYzdnzgvWYrtnZzPuPJ64INXnILT6hljoy1f7tROWrbBu/3RsQ9M+x+cExCTSjrmOOH1
	7y1Byu0/v+7Oett8Iujm2mS1O1fePJUy2rWrKHHmG77lf+dx/hTw59r/9uOzmzU1jk21B+7+
	tNywa3f55aSZ79Yobf0ncXTyjcjG/bXfPZ2mnTh48v3zDiWW4oxEQy3mouJEAOgVBPpIAwAA
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


