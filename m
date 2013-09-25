Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3IYIPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:15:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28214 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3IYIPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:15:52 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-62-52429bb717b6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Balaji T K'" <balajitk@ti.com>,
        "'Nishanth Menon'" <nm@ti.com>
References: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
In-reply-to: <000901ceb9c3$97fe74c0$c7fb5e40$%han@samsung.com>
Subject: [PATCH 19/20] regulator: twl: use devm_regulator_register()
Date: Wed, 25 Sep 2013 17:15:51 +0900
Message-id: <001c01ceb9c7$72a353e0$57e9fba0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac65w5fHnzL+CpaSR8SldcZ2fs0oxwAA3jkQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t8zQ93ts52CDCaekLKYOnk7m8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2Cze/DjL5MDmsXPWXXaPTas62Tz6tqxi9Dh+YzuTx+dNcgGsUVw2
	Kak5mWWpRfp2CVwZf8/IFazmqHgz7xxzA2MrexcjJ4eEgIlE57JfLBC2mMSFe+vZuhi5OIQE
	ljFKXJh3mRGmaN/cg8wQiemMEpc3fWaBcH4xShxYsIYVpIpNQE3iy5fDQGM5OEQEVCX+v3IH
	CTMLrGWUmNPtDWILCdhKLP97G2wbp4CdxLJ7n9lAbGEBF4l993rALmIBar254iYziM0LVH/p
	3S0oW1Dix+R7LBAztSTW7zzOBGHLS2xe85YZZK2EgLrEo7+6IGERASOJiZs2skGUiEjse/GO
	EeRkCYFH7BIdf5YwQewSkPg2+RALRK+sxKYDzBD/SkocXHGDZQKjxCwkm2ch2TwLyeZZSFYs
	YGRZxSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iRESsf07GO8esD7EmAy0fiKzlGhyPjDi80ri
	DY3NjCxMTUyNjcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAWFm7xbBj
	beyZq4s2Mr8737is1l7d2eJLYwSv6pvFou88P2oanjzxdrbvHRkvsyoZ3dDj+y8xSIctfF+k
	p+Cq8d/0qLryEtGGJG2jkMNLXBpbzIxKw5mUr+cXzglp+fflxXH2n6cydnXl14cpHknd81fX
	/0O6Cee/OKZpzNr3N+QGmMdnTpZXYinOSDTUYi4qTgQARbtgR+4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jQd3ts52CDObfEbOYOnk7m8XUh0/Y
	LC4vvMRq8e1KB5PF5V1z2Cze/DjL5MDmsXPWXXaPTas62Tz6tqxi9Dh+YzuTx+dNcgGsUQ2M
	NhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAJygplCXm
	lAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM/6ekStYzVHxZt455gbGVvYuRk4O
	CQETiX1zDzJD2GISF+6tZ+ti5OIQEpjOKHF502cWCOcXo8SBBWtYQarYBNQkvnw5DNTNwSEi
	oCrx/5U7SJhZYC2jxJxubxBbSMBWYvnf2ywgNqeAncSye5/ZQGxhAReJffd6wBazALXeXHET
	bDEvUP2ld7egbEGJH5PvsUDM1JJYv/M4E4QtL7F5zVtmkLUSAuoSj/7qgoRFBIwkJm7ayAZR
	IiKx78U7xgmMQrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4
	HTyT2sG4ssHiEKMAB6MSD6/AUccgIdbEsuLK3EOMEhzMSiK8zjOcgoR4UxIrq1KL8uOLSnNS
	iw8xJgM9OpFZSjQ5H5iq8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSz
	hYmDU6qBUXrejIJZT5+FpkQuC2Yt2/5m/YGvHeuezyiJ/2bWwrrz/gKubb5Wx3e8mb+l4ER7
	pnb3FJ7FgktzHgV+ar3l86XknEx+UutFg+81l52U2915dzYcrvspLJbw/vXJ1S0uNcLt266+
	2LWMYcK8SfuigzrNyyU4hG62Gy0ST1WWObXC0f3VbIX2MiWW4oxEQy3mouJEAJabsqRLAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/twl-regulator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index 78aae4c..8ebd785 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -1188,7 +1188,7 @@ static int twlreg_probe(struct platform_device *pdev)
 	config.driver_data = info;
 	config.of_node = pdev->dev.of_node;
 
-	rdev = regulator_register(&info->desc, &config);
+	rdev = devm_regulator_register(&pdev->dev, &info->desc, &config);
 	if (IS_ERR(rdev)) {
 		dev_err(&pdev->dev, "can't register %s, %ld\n",
 				info->desc.name, PTR_ERR(rdev));
@@ -1217,7 +1217,6 @@ static int twlreg_remove(struct platform_device *pdev)
 	struct regulator_dev *rdev = platform_get_drvdata(pdev);
 	struct twlreg_info *info = rdev->reg_data;
 
-	regulator_unregister(rdev);
 	kfree(info);
 	return 0;
 }
-- 
1.7.10.4


