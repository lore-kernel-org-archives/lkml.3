Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693AbbAEJGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:06:04 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32608 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbbAEJGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:06:00 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ef-54aa53f6b0d1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/3] regulator: tps65023: Constify struct regmap_config and
 regulator_ops
Date: Mon, 05 Jan 2015 10:05:48 +0100
Message-id: <1420448748-9810-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448748-9810-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448659-9636-1-git-send-email-k.kozlowski@samsung.com>
 <1420448748-9810-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xK7rfgleFGBycy2Ux9eETNovXLwwt
	vl3pYLK4vGsOmwOLx85Zd9k9Nq3qZPPo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujMm7JzMW
	bOSp+DDjG1MD4x6uLkZODgkBE4me9U1MELaYxIV769m6GLk4hASWMkqsWbWQDSQhJNDHJLHq
	vyeIzSZgLLF5+RKwuIhAhsTmeVNZQWxmAUOJn+/+sIPYwgLREpMnrQcbyiKgKrGt5RqYzSvg
	JrHi+ikWiGVyEiePTQbr5RRwl1jV8YcZYnEzo8TNhQ+YJzDyLmBkWMUomlqaXFCclJ5rqFec
	mFtcmpeul5yfu4kREixfdjAuPmZ1iFGAg1GJh9fjxMoQIdbEsuLK3EOMEhzMSiK8624BhXhT
	EiurUovy44tKc1KLDzEycXBKNTCyaP2+URwXfqHjjWLKrgv9mskPbs70284c8GxNkvScT10a
	CwsDF8l84besmSh5KI195Wm/1NMrRBbbvO7QVrub+u7gwTTub2eND23t0PrQ+a2A3fT0qcnG
	Qfo2a1KO7rg669mZaVOudvAX8MqnHg/f6qL3jt9F/sy6F/+cN0rxbbWqvHBP2uK2EktxRqKh
	FnNRcSIAtfkxd/QBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by
the driver and regmap_init() accepts pointer to const. Make struct
regulator_ops const as well.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/tps65023-regulator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/tps65023-regulator.c b/drivers/regulator/tps65023-regulator.c
index 7380af8bd50d..b941e564b3f3 100644
--- a/drivers/regulator/tps65023-regulator.c
+++ b/drivers/regulator/tps65023-regulator.c
@@ -173,7 +173,7 @@ static int tps65023_dcdc_set_voltage_sel(struct regulator_dev *dev,
 }
 
 /* Operations permitted on VDCDCx */
-static struct regulator_ops tps65023_dcdc_ops = {
+static const struct regulator_ops tps65023_dcdc_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -184,7 +184,7 @@ static struct regulator_ops tps65023_dcdc_ops = {
 };
 
 /* Operations permitted on LDOx */
-static struct regulator_ops tps65023_ldo_ops = {
+static const struct regulator_ops tps65023_ldo_ops = {
 	.is_enabled = regulator_is_enabled_regmap,
 	.enable = regulator_enable_regmap,
 	.disable = regulator_disable_regmap,
@@ -194,7 +194,7 @@ static struct regulator_ops tps65023_ldo_ops = {
 	.map_voltage = regulator_map_voltage_ascend,
 };
 
-static struct regmap_config tps65023_regmap_config = {
+static const struct regmap_config tps65023_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
-- 
1.9.1

