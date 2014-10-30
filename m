Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406AbaJ3LV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:21:28 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59728 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827AbaJ3LVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:23 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-90-54521f2f49c8
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
Subject: [PATCH v3 02/14] mfd/regulator: dt-bindings: max77686: Document
 of_compatible for regulator
Date: Thu, 30 Oct 2014 12:20:41 +0100
Message-id: <1414668053-31370-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDLMWRmVeSWpSXmKPExsVy+t/xq7oG8kEhBu9OM1psnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKmPB6I3vBI66KyTd7mRoY/3J0
	MXJySAiYSNz4/owdwhaTuHBvPVsXIxeHkMBSRolL35exQjh9TBLN87YzglSxCRhLbF6+BKxK
	RKCTWaLnYC8ziMMssJpJ4ueVU8wgVcICaRJvWx+xgtgsAqoSD1d2s4DYvALuErMWTmOC2Ccn
	cfLYZLAaTgEPiTUf24FsDqB17hL3vmlPYORdwMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93
	EyMkxL/uYFx6zOoQowAHoxIPb8SxgBAh1sSy4srcQ4wSHMxKIryrxYJChHhTEiurUovy44tK
	c1KLDzEycXBKNTBaBwcFaC8Van4yMzNre1T78vccbrYP5Wsdr5d9ksqf+yRf/2R5r+1r4xen
	ToaWWb+avej8Qw0lw6maOiUyTMd01WbaHE+brKQavLtsm9jSucXFEXrHc3e+bQxhtu1w5rsX
	euWVv5fMr7ob2WsXhk5n5Xq84Ox/YZ1Lu/zEpD+8mmy9KmnyPT0lluKMREMt5qLiRADI8Zj/
	TwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document new required property for regulator driver: of_compatible. The
property allows MFD core to bind the driver to node with regulators and
this simplifies parsing regulators init data from DTS

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/mfd/max77686.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
index 75fdfaf41831..f4010a9f66eb 100644
--- a/Documentation/devicetree/bindings/mfd/max77686.txt
+++ b/Documentation/devicetree/bindings/mfd/max77686.txt
@@ -18,8 +18,11 @@ Required properties:
 
 Optional node:
 - voltage-regulators : The regulators of max77686 have to be instantiated
-  under subnode named "voltage-regulators" using the following format.
+  under subnode named "voltage-regulators".
+  Required property:
+  - compatible : Must be "maxim,max77686-pmic"
 
+  Optional properties: For each regulator use following format:
 	regulator_name {
 		regulator-compatible = LDOn/BUCKn
 		standard regulator constraints....
@@ -49,6 +52,8 @@ Example:
 		reg = <0x09>;
 
 		voltage-regulators {
+			compatible = "maxim,max77686-pmic";
+
 			ldo11_reg {
 				regulator-compatible = "LDO11";
 				regulator-name = "vdd_ldo11";
-- 
1.9.1

