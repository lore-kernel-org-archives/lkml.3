Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbaJ3LVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:21:31 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:42895 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889AbaJ3LVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:21:24 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-35-54521f300eca
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
Subject: [PATCH v3 03/14] regulator: dt-bindings: max77802: Document
 of_compatible for regulator
Date: Thu, 30 Oct 2014 12:20:42 +0100
Message-id: <1414668053-31370-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xq7oG8kEhBsuuaVtsnLGe1WLSugNM
	FlMfPmGzuP7lOavF/CPnWC2O/i6weP3C0KJ3wVU2i7NNb9gt7n89ymjx7UoHk8Wmx9dYLS7v
	msNmMeP8PiaL25d5LdYeuctucbqb1UHQo6W5h83j7/PrLB5/V71g9tg56y67x6ZVnWwed67t
	YfOYdzLQY/OSeo++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKmHZrEktBG3fF/L1/GRsYZ3F2
	MXJySAiYSBz/eJkNwhaTuHBvPZgtJLCUUeLDbNYuRi4gu49JYtHV/4wgCTYBY4nNy5ewgSRE
	BDqZJXoO9jKDOMwCq5kkfl45xQxSJSyQJLGv7TALiM0ioCoxacECVhCbV8BdYu3jHiaIdXIS
	J49NBotzCnhIrPnYDmRzAK1zl7j3TXsCI+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmb
	GCEB/mUH4+JjVocYBTgYlXh4HTYGhAixJpYVV+YeYpTgYFYS4V0tFhQixJuSWFmVWpQfX1Sa
	k1p8iJGJg1OqgXHGnp7LeUae23yiI2qeXZY6465hmXBh1dV9XmWhlns9drveVp3KGex5eubc
	PZseyc/556T1YMPkpKwlc27E3OoW1BUssbW0DHyWy19xZuVvv3M8upcP9seKnnlef0Ti490U
	Q2m3s5Ymz4slb3exmk98lGRlvtDzbZrmM/dWbsXjpbl/akX/r1diKc5INNRiLipOBAB3IYqL
	TgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document new required property for regulator driver: of_compatible.
The property allows MFD core to bind the driver to node with regulators
and this simplifies parsing regulators init data from DTS

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 Documentation/devicetree/bindings/regulator/max77802.txt | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/regulator/max77802.txt b/Documentation/devicetree/bindings/regulator/max77802.txt
index 5aeaffc0f1f0..fa545e7d3b0a 100644
--- a/Documentation/devicetree/bindings/regulator/max77802.txt
+++ b/Documentation/devicetree/bindings/regulator/max77802.txt
@@ -10,7 +10,11 @@ Following properties should be present in main device node of the MFD chip.
 
 Optional node:
 - regulators : The regulators of max77802 have to be instantiated
-  under subnode named "regulators" using the following format.
+  under subnode named "regulators".
+  Required property:
+  - compatible : Must be "maxim,max77802-pmic"
+
+  Optional properties: For each regulator use following format:
 
 	regulator-name {
 		standard regulator constraints....
@@ -36,6 +40,8 @@ Example:
 		#size-cells = <0>;
 
 		regulators {
+			compatible = "maxim,max77802-pmic";
+
 			ldo11_reg: LDO11 {
 				regulator-name = "vdd_ldo11";
 				regulator-min-microvolt = <1900000>;
-- 
1.9.1

