Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaKCOmw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:42:52 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38887 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbaKCOmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:42:49 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v4 13/14] regulator: max77802: Set regulator modes translation callback
Date: Mon,  3 Nov 2014 15:40:48 +0100
Message-Id: <1415025649-8119-14-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The max77802 PMIC regulators output can be configured in one of two
modes: Output ON (normal) and Output ON in Low Power Mode. Some of
the regulators support their operating mode to be changed on startup
or by consumers when the system is running while others only support
their operating mode to be changed while the system has entered in a
suspend state.

Use the max77802_map_mode() function to translate the device specific
modes to the standard operating modes as used by the regulator core.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/regulator/max77802.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/regulator/max77802.c b/drivers/regulator/max77802.c
index 1d1f7b4..09276c2 100644
--- a/drivers/regulator/max77802.c
+++ b/drivers/regulator/max77802.c
@@ -375,6 +375,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 	.vsel_mask	= MAX77802_VSEL_MASK,				\
 	.enable_reg	= MAX77802_REG_LDO1CTRL1 + num - 1,		\
 	.enable_mask	= MAX77802_OPMODE_MASK << MAX77802_OPMODE_SHIFT_LDO, \
+	.map_modes	= max77802_map_mode,				\
 }
 
 /* LDOs 1, 2, 8, 15, 17, 27, 30, 35 */
@@ -393,6 +394,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 	.vsel_mask	= MAX77802_VSEL_MASK,				\
 	.enable_reg	= MAX77802_REG_LDO1CTRL1 + num - 1,		\
 	.enable_mask	= MAX77802_OPMODE_MASK << MAX77802_OPMODE_SHIFT_LDO, \
+	.map_modes	= max77802_map_mode,				\
 }
 
 /* BUCKs 1, 6 */
@@ -411,6 +413,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 	.vsel_mask	= MAX77802_DVS_VSEL_MASK,			\
 	.enable_reg	= MAX77802_REG_BUCK ## num ## CTRL,		\
 	.enable_mask	= MAX77802_OPMODE_MASK,				\
+	.map_modes	= max77802_map_mode,				\
 }
 
 /* BUCKS 2-4 */
@@ -430,6 +433,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 	.enable_reg	= MAX77802_REG_BUCK ## num ## CTRL1,		\
 	.enable_mask	= MAX77802_OPMODE_MASK <<			\
 				MAX77802_OPMODE_BUCK234_SHIFT,		\
+	.map_modes	= max77802_map_mode,				\
 }
 
 /* BUCK 5 */
@@ -448,6 +452,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 	.vsel_mask	= MAX77802_VSEL_MASK,				\
 	.enable_reg	= MAX77802_REG_BUCK5CTRL,			\
 	.enable_mask	= MAX77802_OPMODE_MASK,				\
+	.map_modes	= max77802_map_mode,				\
 }
 
 /* BUCKs 7-10 */
@@ -466,6 +471,7 @@ static struct regulator_ops max77802_buck_dvs_ops = {
 	.vsel_mask	= MAX77802_VSEL_MASK,				\
 	.enable_reg	= MAX77802_REG_BUCK7CTRL + (num - 7) * 3,	\
 	.enable_mask	= MAX77802_OPMODE_MASK,				\
+	.map_modes	= max77802_map_mode,				\
 }
 
 static const struct regulator_desc regulators[] = {
@@ -540,6 +546,7 @@ static int max77802_pmic_dt_parse_pdata(struct platform_device *pdev,
 
 	for (i = 0; i < pdata->num_regulators; i++) {
 		rmatch.name = regulators[i].name;
+		rmatch.desc = &regulators[i];
 		rmatch.init_data = NULL;
 		rmatch.of_node = NULL;
 		if (of_regulator_match(&pdev->dev, regulators_np, &rmatch,
-- 
2.1.0

