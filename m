Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934017AbaJ2PNR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 11:13:17 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10181 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933723AbaJ2PLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 11:11:06 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-9d-545103871fdf
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
Subject: [PATCH v2 5/8] regulator: max77686: Initialize opmode explicitly to
 normal mode
Date: Wed, 29 Oct 2014 16:06:43 +0100
Message-id: <1414595206-1437-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
References: <1414595206-1437-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t/xy7rtzIEhBlsPK1psnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKeNj8lLngD3vFhP1vmBoYn7B1
	MXJySAiYSGzdsYYJwhaTuHBvPVCci0NIYCmjxOzJcxghnD4miQ0Xd4NVsQkYS2xevgSsSkSg
	k1mi52AvM4jDLLCaSeLnlVPMIFXCAlESzVu6GEFsFgFViUVLH4Ht4xVwk3j6+SAjxD45iZPH
	JrOC2JwC7hILWz6AxYWAat4um8QygZF3ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYyQ
	IP+yg3HxMatDjAIcjEo8vA4bA0KEWBPLiitzDzFKcDArifB+/gUU4k1JrKxKLcqPLyrNSS0+
	xMjEwSnVwBg3Lyur/uK0J5duPRRS0sz8yz6Ru3PSgS8RAoye6XPVVbvMI9fVTLn2eL1mSnrR
	HKNrqhd6IksumTnoNS6a+/2Y6MYlERHOwqHpFhtuviz9WcDfKnPo754CyxOCTouZ+7WmCHfN
	PXxD7co195ITu1f4tuoFL6z/72k28wXP+fa1oezsQtVdV5VYijMSDbWYi4oTAVl6r5xQAgAA
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
index 7ec9b4e5b917..5497e10b9659 100644
--- a/drivers/regulator/max77686.c
+++ b/drivers/regulator/max77686.c
@@ -497,8 +497,8 @@ static int max77686_pmic_probe(struct platform_device *pdev)
 		config.init_data = rdata[i].init_data;
 		config.of_node = rdata[i].of_node;
 
-		max77686->opmode[id] = regulators[i].enable_mask >>
-						max77686_get_opmode_shift(id);
+		max77686->opmode[id] = MAX77686_NORMAL;
+
 		rdev = devm_regulator_register(&pdev->dev,
 						&regulators[i], &config);
 		if (IS_ERR(rdev)) {
-- 
1.9.1

