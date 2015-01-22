Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbbAVPp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:45:57 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:37193 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbbAVPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:45:50 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 3/5] regulators: axp20x: Use "clock-frequency" property for dcdc work frequency
Date: Thu, 22 Jan 2015 23:39:05 +0800
Message-Id: <1421941147-9682-4-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421941147-9682-1-git-send-email-wens@csie.org>
References: <1421941147-9682-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the dcdc regulator work frequency is a property of the regulators
DT sub-tree, there is no issue of naming collisions, so we can use the
standard "clock-frequency" binding for this.

The driver sets a reasonable default value (same as the datasheet), and
only 1 dts has the old binding, with the default value.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 drivers/regulator/axp20x-regulator.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/axp20x-regulator.c b/drivers/regulator/axp20x-regulator.c
index e4331f5e5d7d..990ac453abc8 100644
--- a/drivers/regulator/axp20x-regulator.c
+++ b/drivers/regulator/axp20x-regulator.c
@@ -186,8 +186,10 @@ static int axp20x_regulator_parse_dt(struct platform_device *pdev)
 	if (!regulators) {
 		dev_warn(&pdev->dev, "regulators node not found\n");
 	} else {
-		dcdcfreq = 1500;
-		of_property_read_u32(regulators, "x-powers,dcdc-freq", &dcdcfreq);
+		dcdcfreq = 1500000;
+		of_property_read_u32(regulators, "clock-frequency", &dcdcfreq);
+		/* axp20x_set_dcdc_freq() takes kHZ */
+		dcdcfreq /= 1000;
 		ret = axp20x_set_dcdc_freq(pdev, dcdcfreq);
 		if (ret < 0) {
 			dev_err(&pdev->dev, "Error setting dcdc frequency: %d\n", ret);
-- 
2.1.4

