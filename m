Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaJ0PeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:34:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48572 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbaJ0P3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:29:37 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-00-544e64db45e2
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
Subject: [PATCH 5/8] regulator: max77686: Initialize opmode explicitly to
 normal mode
Date: Mon, 27 Oct 2014 16:03:43 +0100
Message-id: <1414422226-10948-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xa7q3U/xCDP7vErHYOGM9q8WkdQeY
	LKY+fMJmcf3Lc1aL+UfOsVoc/V1g8fqFoUXvgqtsFmeb3rBb3P96lNHi25UOJotNj6+xWlze
	NYfNYsb5fUwWty/zWqw9cpfd4nQ3q4OgR0tzD5vH3+fXWTz+rnrB7LFz1l12j02rOtk87lzb
	w+Yx72Sgx+Yl9R59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CV8fj1M7aCs+wV/QfPMDYw7mbr
	YuTkkBAwkei6f58FwhaTuHBvPVCci0NIYCmjxP45rxhBEkICfUwSU5bKgthsAsYSm5cvASsS
	Eehklug52MsM4jALrGaS+HnlFDNIlbBAuMTtwytZQWwWAVWJbac6wWxeAXeJPYceQK2Wkzh5
	bDJYnFPAQ+L1/a/MENvcJT6/38o4gZF3ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQ
	EP+yg3HxMatDjAIcjEo8vDum+YYIsSaWFVfmHmKU4GBWEuE9FeAXIsSbklhZlVqUH19UmpNa
	fIiRiYNTqoGxLzXTRuvkpxnnVzL7zny6Ys/r6xITH/9b4en3VPSd1rrYcAeO0k2Fi4N0bJVf
	9jSdtI/PClP8dO1TR8br8F2HShqv+1/9mc9997KH8iWjzgMts370vrmw1IV3hv9LoziOuPeH
	HCYyLQ7m+KzGMiVR78YSVof2fZudtt//elqleUe4/zKhqTurlFiKMxINtZiLihMB3pkRFE8C	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minor nit: Initialize the opmode for each regulator to normal mode in a
readable explicit way.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Suggested-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77686.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max77686.c b/drivers/regulator/max77686.c
index 7930b4f82c0b..e5738c363f07 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -507,8 +507,8 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 		config.init_data = max77686->regulators[i].initdata;
 		config.of_node = max77686->regulators[i].of_node;
 
-		max77686->opmode[i] = regulators[i].enable_mask >>
-						max77686_get_opmode_shift(i);
+		max77686->opmode[i] = MAX77686_NORMAL;
+
 		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.9.1

