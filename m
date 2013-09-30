Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab3I3A50 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 20:57:26 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:59543 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab3I3A5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 20:57:24 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-4d-5248cc734d80
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
In-reply-to: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
Subject: [PATCH V4 10/14] regulator: pcf50633: use devm_regulator_register()
Date: Mon, 30 Sep 2013 09:57:23 +0900
Message-id: <007d01cebd78$05f8ce00$11ea6a00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac69dwY7qCw/SuPGSmKRawAumfnevwAAPAEg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zQ93iMx5BBjsmaFpMffiEzeLywkus
	Fksmz2e1+Halg8ni8q45bA6sHjtn3WX32LSqk81jyZtDrB59W1YxenzeJBfAGsVlk5Kak1mW
	WqRvl8CVsWKpesFfroqmjx/YGxhncnYxcnBICJhIrPkS08XICWSKSVy4t56ti5GLQ0hgGaPE
	3Dlb2WFqXn/hg4hPZ5ToPrueHcL5xShxonM/O0g3m4CaxJcvh8EaRARUJf6/cgcJMwtMBWpY
	Ww5iCwnYSsw5f5YRxOYUsJO4s6EVzBYW8JE4fuMdK4jNAtT6+/1sMJsXqP7o9iYWCFtQ4sfk
	eywQM7Uk1u88zgRhy0tsXvOWGeJOdYlHf3VBwiICRhIH57xlhSgRkdj34h0jyMkSArfYJa53
	7WSB2CUg8W3yIRaIXlmJTQeYIeEgKXFwxQ2WCYwSs5BsnoVk8ywkm2chWbGAkWUVo2hqQXJB
	cVJ6kYlecWJucWleul5yfu4mRkiMTtjBeO+A9SHGZKD1E5mlRJPzgTGeVxJvaGxmZGFqYmps
	ZG5pRpqwkjiveot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG3rMTmu7MN85VnNHc9GxP
	5TU+7tv89rp2k/rSTifekWDfe0hTjdvJ9G2T37GEL7OPWU7YUXTuy4u163dJZodYhORvLGTT
	viV6lnvNPjuOi/4Z0ez5078o3AgQtCqa/tp5lbTI4tj/YcZrkpbs+/dR8DZLwsrtIS5vixTb
	jukvrNz09vvNi+2+SizFGYmGWsxFxYkAY3YNC+cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd3iMx5BBt8mq1pMffiEzeLywkus
	Fksmz2e1+Halg8ni8q45bA6sHjtn3WX32LSqk81jyZtDrB59W1YxenzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLFiqXrBX66Kpo8f2BsYZ3J2MXJwSAiYSLz+
	wtfFyAlkiklcuLeerYuRi0NIYDqjRPfZ9ewQzi9GiROd+9lBqtgE1CS+fDnMDtIsIqAq8f+V
	O0iYWWAqUMPachBbSMBWYs75s4wgNqeAncSdDa1gtrCAj8TxG+9YQWwWoNbf72eD2bxA9Ue3
	N7FA2IISPybfY4GYqSWxfudxJghbXmLzmrfMEDerSzz6qwsSFhEwkjg45y0rRImIxL4X7xgn
	MArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4BTwTHoH46oG
	i0OMAhyMSjy8Fks9goRYE8uKK3MPMUpwMCuJ8C5PAgrxpiRWVqUW5ccXleakFh9iTAZ6dCKz
	lGhyPjA95ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo/XM
	j3plkp5LcnqKZ524ltb/MGZH74Z3HNrKMxYabjl0VE/u6tct0xZ437NkXTvvyecDn8Vvu2Rw
	xf6T7pSyWassFLrn/NuXZ77dvn8tKzM16T7jf/GHMr6eMpdfSFWeUJxT8nzp1L2fA75PK/W/
	KP04csLMzHX3ctTfPp+kuPfAm78Nl9M3pVspsRRnJBpqMRcVJwIANOOTPUUDAAA=
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
 drivers/regulator/pcf50633-regulator.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/regulator/pcf50633-regulator.c b/drivers/regulator/pcf50633-regulator.c
index 0f3576d..d7da1c1 100644
--- a/drivers/regulator/pcf50633-regulator.c
+++ b/drivers/regulator/pcf50633-regulator.c
@@ -90,7 +90,8 @@ static int pcf50633_regulator_probe(struct platform_device *pdev)
 	config.driver_data = pcf;
 	config.regmap = pcf->regmap;
 
-	rdev = regulator_register(&regulators[pdev->id], &config);
+	rdev = devm_regulator_register(&pdev->dev, &regulators[pdev->id],
+				       &config);
 	if (IS_ERR(rdev))
 		return PTR_ERR(rdev);
 
@@ -102,21 +103,11 @@ static int pcf50633_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int pcf50633_regulator_remove(struct platform_device *pdev)
-{
-	struct regulator_dev *rdev = platform_get_drvdata(pdev);
-
-	regulator_unregister(rdev);
-
-	return 0;
-}
-
 static struct platform_driver pcf50633_regulator_driver = {
 	.driver = {
 		.name = "pcf50633-regltr",
 	},
 	.probe = pcf50633_regulator_probe,
-	.remove = pcf50633_regulator_remove,
 };
 
 static int __init pcf50633_regulator_init(void)
-- 
1.7.10.4


