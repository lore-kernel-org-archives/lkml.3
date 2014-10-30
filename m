Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759418AbaJ3LXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:23:17 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59728 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758740AbaJ3LV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:28 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-4e-54521f369d01
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
Subject: [PATCH v3 11/14] mfd/regulator: dt-bindings: max77686: Document gpio
 properties
Date: Thu, 30 Oct 2014 12:20:50 +0100
Message-id: <1414668053-31370-12-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xq7pm8kEhBpffqlpsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKWP1/H2PBUZ6K7Z0PGBsY53B1
	MXJySAiYSDyY84gJwhaTuHBvPVsXIxeHkMBSRokTXyewQzh9TBLNBzvZQarYBIwlNi9fAlYl
	ItDJLNFzsJcZxGEWWM0k8fPKKSCHg0NYIEri9XsRkAYWAVWJY30LWUFsXgEPiePnLzJCrJOT
	OHlsMlicEyi+5mM7K0irkIC7xL1v2hMYeRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93E
	CAnwLzsYFx+zOsQowMGoxMPrsDEgRIg1say4MvcQowQHs5II72qxoBAh3pTEyqrUovz4otKc
	1OJDjEwcnFINjAFaf1e8uuvxVuSqxZLVuSdb27uFHD9ek7yU9n52626bzS82e/YuWKyeExLz
	659QjNvpp7L8EzO+7jXzvS1bszNWUtORc3rMmnKfmYfCPx6yYZq+0bQn9u8pq2+6MxcsCzAu
	XmNaFCX0Y4Jd8fPYtrV/jD7uNZda13YhWNTo5Vud7sV7V+7YK6HEUpyRaKjFXFScCACSCWVX
	TgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document usage of gpio properties which turn on external/GPIO control
over regulator.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77686.txt | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
index f4010a9f66eb..b8013e69da65 100644
--- a/Documentation/devicetree/bindings/mfd/max77686.txt
+++ b/Documentation/devicetree/bindings/mfd/max77686.txt
@@ -22,7 +22,14 @@ Optional node:
   Required property:
   - compatible : Must be "maxim,max77686-pmic"
 
-  Optional properties: For each regulator use following format:
+  Optional properties:
+  - ldo20-gpio : GPIO to use for LDO20 enable control.
+  - ldo21-gpio : GPIO to use for LDO21 enable control.
+  - ldo22-gpio : GPIO to use for LDO22 enable control.
+  - buck8-gpio : GPIO to use for BUCK8 enable control.
+  - buck9-gpio : GPIO to use for BUCK9 enable control.
+
+  For each regulator use following format:
 	regulator_name {
 		regulator-compatible = LDOn/BUCKn
 		standard regulator constraints....
@@ -42,7 +49,6 @@ to get matched with their hardware counterparts as follow:
 	-BUCKn	:	1-4.
   Use standard regulator bindings for it ('regulator-off-in-suspend').
 
-
 Example:
 
 	max77686@09 {
@@ -53,6 +59,7 @@ Example:
 
 		voltage-regulators {
 			compatible = "maxim,max77686-pmic";
+			ldo21-gpio = <&gpy2 0 GPIO_ACTIVE_HIGH>;
 
 			ldo11_reg {
 				regulator-compatible = "LDO11";
-- 
1.9.1

