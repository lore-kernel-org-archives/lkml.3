Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932852AbaJ3LYa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:24:30 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59728 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbaJ3LV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:26 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-47-54521f356cea
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 09/14] regulator: max77686: Initialize opmode explicitly to
 normal mode
Date: Thu, 30 Oct 2014 12:20:48 +0100
Message-id: <1414668053-31370-10-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xq7qm8kEhBvOusFtsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKeHiMpeAle8X029vZGhgvsHUx
	cnJICJhInN+4ghHCFpO4cG89UJyLQ0hgKaPEpjPTGSGcPiaJpvazYFVsAsYSm5cvAasSEehk
	lug52MsM4jALrGaS+HnlFDNIlbBAjMTSrlssIDaLgKrE58ObwLp5BTwktk39CLVbTuLkscms
	IDYnUHzNx3YgmwNonbvEvW/aExh5FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQICfAv
	OxgXH7M6xCjAwajEw+uwMSBEiDWxrLgy9xCjBAezkgjvarGgECHelMTKqtSi/Pii0pzU4kOM
	TBycUg2MG1z9SzL2Sq0Nv37ImvM68/HpFgZvZ1tmsE6dvvzIDNMZeQJSf04ov1Q8fDjaMUOF
	0SGBpfVE112mtCtLrktcX+180KExZPZvK0lf6fbIidy6GxwmSC2ZtPrH+zi+1xNPG73e9yiz
	ysY1rbbg+af3vJN+fvaIr7L7bZdf5vlq6fcbt/9+K4ysVWIpzkg01GIuKk4EAF3wgldOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor nit: Initialize the opmode for each regulator to normal mode in a
readable explicit way.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Reviewed-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77686.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index ac05b318e405..2c276d147c90 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -473,8 +473,8 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 		struct regulator_dev *rdev;
 		int id = regulators[i].id;
 
-		max77686->opmode[id] = regulators[i].enable_mask >>
-						max77686_get_opmode_shift(id);
+		max77686->opmode[id] = MAX77686_NORMAL;
+
 		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.9.1

