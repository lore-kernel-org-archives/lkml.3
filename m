Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3IYIJt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:09:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26658 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3IYIJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:09:46 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-14-52429a49a041
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 15/20] regulator: pcap: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:09:45 +0900
Message-id: <001801ceb9c6$986ebb60$c94c3220$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAAssdQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zY13PWU5BBvvnyVhMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bhi71s
	Be3cFYf2zWZrYJzD2cXIySEhYCKx5+Z9ZghbTOLCvfVsXYxcHEICyxglls39zwRTdGD1CVaI
	xCJGiRVXXkM5vxglJnxpAWtnE1CT+PLlMHsXIweHiICqxP9X7iAms0CuRPe2dJAKIQFbieV/
	b7OA2JwCdhLL7n1mA7GFBVwlbnb8YASxWYA6Z21uBYvzAtUfaZ3DCGELSvyYfA+sl1lAS2L9
	zuNMELa8xOY1b5lBVkkIqEs8+qsLEhYRMJKYtPE0K0SJiMS+F+8YQS6WELjELrFxxn4miF0C
	Et8mH2KB6JWV2HQAGg6SEgdX3GCZwCgxC8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmeoV
	J+YWl+al6yXn525ihMTkxB2M9w9YH2JMBlo/kVlKNDkfGNN5JfGGxmZGFqYmpsZG5pZmpAkr
	ifOqt1gHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBcyPlI69pXjoRtUa1b35YKFh4W2u79
	PWrpRs0tB538K+d8ueok/U7BaCu3b6aUw5YJyp5cizuybRLTGIR4mIv/8enNb+M5uPZ9g7f5
	CeUjZuVsBp5sOrds301RVtDcdnGDkwxvT7nIHaGcp+vrqo3fPWaPF5inU7aWzyu2ezVzvqrb
	ux9H3imxFGckGmoxFxUnAgA4CkS83wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jAV3PWU5BBn9uS1hMffiEzeLywkus
	Ft+udDBZXN41h82BxWPnrLvsHptWdbJ59G1ZxejxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPG4Yu9bAXt3BWH9s1ma2Ccw9nFyMkhIWAicWD1CVYIW0ziwr31
	bF2MXBxCAosYJVZcec0K4fxilJjwpYUZpIpNQE3iy5fD7F2MHBwiAqoS/1+5g5jMArkS3dvS
	QSqEBGwllv+9zQJicwrYSSy795kNxBYWcJW42fGDEcRmAeqctbkVLM4LVH+kdQ4jhC0o8WPy
	PbBeZgEtifU7jzNB2PISm9e8ZQZZJSGgLvHory5IWETASGLSxtOsECUiEvtevGOcwCg0C8mk
	WUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgiP+mfQOxlUNFocYBTgY
	lXh4BY46BgmxJpYVV+YeYpTgYFYS4XWe4RQkxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnA
	ZJRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxtgjfVrffa
	BFrYeDUZ39/LoaxXer2CS7hB++LcwzvdqmdEVFjKirAXTFo69Xz/lBdTLE8dOrjt3I3AZXmt
	+d+Xf9PSWuIfcfyWRAZnU4uGZWRoRv6RW6+66gMOsXnP4Fmnu6ZJZ4VM4nbuhQl2SifeHCl5
	tSbVRW5P763FKjdfVp53/rQy8rgSS3FGoqEWc1FxIgAGsyvuPAMAAA==
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
 drivers/regulator/pcap-regulator.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/pcap-regulator.c b/drivers/regulator/pcap-regulator.c
index b49eaee..3727b7d 100644
--- a/drivers/regulator/pcap-regulator.c
+++ b/drivers/regulator/pcap-regulator.c
@@ -246,7 +246,8 @@ static int pcap_regulator_probe(struct platform_device *pdev)
 	config.init_data = dev_get_platdata(&pdev->dev);
 	config.driver_data = pcap;
 
-	rdev = regulator_register(&pcap_regulators[pdev->id], &config);
+	rdev = devm_regulator_register(&pdev->dev, &pcap_regulators[pdev->id],
+				       &config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
@@ -255,22 +256,12 @@ static int pcap_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int pcap_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-
-	regulator_unregister(rdev);
-
-	return 0;
-}
-
 static struct platform_driver pcap_regulator_driver = {
 	.driver = {
 		.name	= "pcap-regulator",
 		.owner	= THIS_MODULE,
 	},
 	.probe	= pcap_regulator_probe,
-	.remove	= pcap_regulator_remove,
 };
 
 static int __init pcap_regulator_init(void)
-- 
1.7.10.4


