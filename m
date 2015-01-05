Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbbAEJE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:04:29 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39735 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbbAEJE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:04:26 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-8a-54aa539aa053
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/3] regulator: fan53555: Constify struct regmap_config and
 slew_rates array
Date: Mon, 05 Jan 2015 10:04:19 +0100
Message-id: <1420448659-9636-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOJMWRmVeSWpSXmKPExsVy+t/xq7qzgleFGGxYb2Yx9eETNovXLwwt
	vl3pYLK4vGsOmwOLx85Zd9k9Nq3qZPPo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujNmLT7MU
	TOGouLImu4HxKVsXIweHhICJxM3JHF2MnECmmMSFe+uBwlwcQgJLGSVWr9rKCOH0MUmsnPqO
	HaSKTcBYYvPyJWwgtohAhsTmeVNZQWxmAUOJn+/+gNUIC8RJPPy/FyzOIqAqMedRIwuIzSvg
	JjF33Wt2iG1yEiePTWadwMi9gJFhFaNoamlyQXFSeq6RXnFibnFpXrpecn7uJkaI57/uYFx6
	zOoQowAHoxIPr8eJlSFCrIllxZW5hxglOJiVRHjX3QIK8aYkVlalFuXHF5XmpBYfYmTi4JRq
	YHSV0rP/3DV1ybHM/Q+/3T5pNXcGSxjr3PRT5Sci/2YLNHrNO/ouKEzNonqHrJ+rNevF/N1N
	ccc/zr1/7VCLqpVPzdKbP/e23tY/3CO75vnNlKOX1Wb3TjETELDZ9DTQ+ooES/W+LZfOG60O
	OfBIN//HvktSwpyNq3P2vZpkUXaOwy+nsfGkjJMSS3FGoqEWc1FxIgA4LJvW2gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const. Make const also
slew_rates array.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/fan53555.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 6c43ab2d5121..3c25db89a021 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -147,7 +147,7 @@ static unsigned int fan53555_get_mode(struct regulator_dev *rdev)
 		return REGULATOR_MODE_NORMAL;
 }
 
-static int slew_rates[] = {
+static const int slew_rates[] = {
 	64000,
 	32000,
 	16000,
@@ -296,7 +296,7 @@ static int fan53555_regulator_register(struct fan53555_device_info *di,
 	return PTR_ERR_OR_ZERO(di->rdev);
 }
 
-static struct regmap_config fan53555_regmap_config = {
+static const struct regmap_config fan53555_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
-- 
1.9.1

