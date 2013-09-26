Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab3IZHyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 03:54:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57221 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab3IZHx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 03:53:59 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-04-5243e816f1fe
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Balaji T K'" <balajitk@ti.com>,
        "'Nishanth Menon'" <nm@ti.com>
References: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
In-reply-to: <003101ceba8c$88d6a840$9a83f8c0$%han@samsung.com>
Subject: [PATCH V3 13/14] regulator: twl: use devm_regulator_register()
Date: Thu, 26 Sep 2013 16:53:57 +0900
Message-id: <003d01ceba8d$8e35d210$aaa17630$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac66jIjCzH3ID+v5Qym5l1DxbvczrwAAPKOg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t8zA12xF85BBkv+8VhMnbydzWLqwyds
	FpcXXmK1+Halg8ni8q45bBZvfpxlcmDz2DnrLrvHplWdbB59W1Yxehy/sZ3J4/MmuQDWKC6b
	lNSczLLUIn27BK6Mrv3SBRc5Kr5332NuYFzG3sXIySEhYCLRfXIDG4QtJnHh3nogm4tDSGAZ
	o8S0v9fYYIqmnVnHDpGYzihxaNo5sISQwC9GiVufjUBsNgE1iS9fDgMVcXCICKhK/H/lDhJm
	FljLKDGn2xui3Fai8dtfFhCbU8BOYtb+k8wgtrCAu8TMW2cZQWwWoNbtM7pZQWxeoPrlh39B
	2YISPybfY4GYqSWxfudxJghbXmLzmrfMIGslBNQlHv3VBQmLCBhJNO35ywxRIiKx78U7RpDz
	JQTusUvsm7yYBWKXgMS3yYdYIHplJTYdYIZ4V1Li4IobLBMYJWYh2TwLyeZZSDbPQrJiASPL
	KkbR1ILkguKk9CJDveLE3OLSvHS95PzcTYyQeO3dwXj7gPUhxmSg9ROZpUST84HxnlcSb2hs
	ZmRhamJqbGRuaUaasJI4r1qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRqFpPR3Z8avy
	p7c8Pbxi7vfo2btf3pU996A/Kks/Uc+hzj2MKc+N0U/a5ejbp69Fts3al+btw1qkEvPh3ZUo
	jaVzVZ694/vvMfeBY6Ulf1K0e/OD51NfBm/jeBkiws+x4u6z0H+JBh2msavFzV/JnWeva9tf
	yL7TtEimbbXarn0LqmueKXmWKLEUZyQaajEXFScCABSwu8/tAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQV2xF85BBgf+cFhMnbydzWLqwyds
	FpcXXmK1+Halg8ni8q45bBZvfpxlcmDz2DnrLrvHplWdbB59W1Yxehy/sZ3J4/MmuQDWqAZG
	m4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygE5QUyhJz
	SoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGV37pQsuclR8777H3MC4jL2LkZND
	QsBEYtqZdVC2mMSFe+vZuhi5OIQEpjNKHJp2jg0kISTwi1Hi1mcjEJtNQE3iy5fDQA0cHCIC
	qhL/X7mDhJkF1jJKzOn2hii3lWj89pcFxOYUsJOYtf8kM4gtLOAuMfPWWUYQmwWodfuMblYQ
	mxeofvnhX1C2oMSPyfdYIGZqSazfeZwJwpaX2LzmLTPIWgkBdYlHf3VBwiICRhJNe/4yQ5SI
	SOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECE4G
	z6R3MK5qsDjEKMDBqMTDe4HZOUiINbGsuDL3EKMEB7OSCO83I6AQb0piZVVqUX58UWlOavEh
	xmSgRycyS4km5wMTVV5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBx
	cEo1MLJWZtWaz+LaqT/X8biAMmd4eIpc1NPlOjklGrp/7ee3dzxbn9LidEuckbt1wemHs/j1
	dvMzn52/0umN/caVO0409YfeTlsS3TFJzon1kbne64UiwuqcTl3M/9vv6n/+eenUuuW3Xu7O
	UzT9XreVI/V+xYlFt5Q4L/jqbWcv7YqeyKYp5PHutxJLcUaioRZzUXEiAFseB3ZKAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_regulator_register() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Nishanth Menon <nm@ti.com>
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


