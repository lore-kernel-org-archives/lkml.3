Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab3CRJcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:32:20 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8139 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3CRJcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:32:17 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 18 Mar 2013 02:32:16 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, <swarren@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <lrg@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] regulator: palmas: add input supply names
Date: Mon, 18 Mar 2013 14:59:48 +0530
Message-ID: <1363598989-25112-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas regulator support the different input supply pins for each of
the rails. Fill the regulator info data with their input supply pin
names.

The pin supply names is passed to regulator_register() only when there
is valid regulator_init_data. If regulator_init_data is not present
for the rail then it is assumed that given rail's input pin is left
unconnected.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/regulator/palmas-regulator.c |   28 ++++++++++++++++++++++++++++
 1 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 4a45942..119d83b 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -29,6 +29,7 @@
 
 struct regs_info {
 	char	*name;
+	char	*sname;
 	u8	vsel_addr;
 	u8	ctrl_addr;
 	u8	tstep_addr;
@@ -37,110 +38,131 @@ struct regs_info {
 static const struct regs_info palmas_regs_info[] = {
 	{
 		.name		= "SMPS12",
+		.sname		= "smps1-in",
 		.vsel_addr	= PALMAS_SMPS12_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS12_CTRL,
 		.tstep_addr	= PALMAS_SMPS12_TSTEP,
 	},
 	{
 		.name		= "SMPS123",
+		.sname		= "smps1-in",
 		.vsel_addr	= PALMAS_SMPS12_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS12_CTRL,
 		.tstep_addr	= PALMAS_SMPS12_TSTEP,
 	},
 	{
 		.name		= "SMPS3",
+		.sname		= "smps3-in",
 		.vsel_addr	= PALMAS_SMPS3_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS3_CTRL,
 	},
 	{
 		.name		= "SMPS45",
+		.sname		= "smps4-in",
 		.vsel_addr	= PALMAS_SMPS45_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS45_CTRL,
 		.tstep_addr	= PALMAS_SMPS45_TSTEP,
 	},
 	{
 		.name		= "SMPS457",
+		.sname		= "smps4-in",
 		.vsel_addr	= PALMAS_SMPS45_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS45_CTRL,
 		.tstep_addr	= PALMAS_SMPS45_TSTEP,
 	},
 	{
 		.name		= "SMPS6",
+		.sname		= "smps6-in",
 		.vsel_addr	= PALMAS_SMPS6_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS6_CTRL,
 		.tstep_addr	= PALMAS_SMPS6_TSTEP,
 	},
 	{
 		.name		= "SMPS7",
+		.sname		= "smps7-in",
 		.vsel_addr	= PALMAS_SMPS7_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS7_CTRL,
 	},
 	{
 		.name		= "SMPS8",
+		.sname		= "smps8-in",
 		.vsel_addr	= PALMAS_SMPS8_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS8_CTRL,
 		.tstep_addr	= PALMAS_SMPS8_TSTEP,
 	},
 	{
 		.name		= "SMPS9",
+		.sname		= "smps9-in",
 		.vsel_addr	= PALMAS_SMPS9_VOLTAGE,
 		.ctrl_addr	= PALMAS_SMPS9_CTRL,
 	},
 	{
 		.name		= "SMPS10",
+		.sname		= "smps10-in",
 	},
 	{
 		.name		= "LDO1",
+		.sname		= "ldo1-in",
 		.vsel_addr	= PALMAS_LDO1_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO1_CTRL,
 	},
 	{
 		.name		= "LDO2",
+		.sname		= "ldo2-in",
 		.vsel_addr	= PALMAS_LDO2_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO2_CTRL,
 	},
 	{
 		.name		= "LDO3",
+		.sname		= "ldo3-in",
 		.vsel_addr	= PALMAS_LDO3_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO3_CTRL,
 	},
 	{
 		.name		= "LDO4",
+		.sname		= "ldo4-in",
 		.vsel_addr	= PALMAS_LDO4_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO4_CTRL,
 	},
 	{
 		.name		= "LDO5",
+		.sname		= "ldo5-in",
 		.vsel_addr	= PALMAS_LDO5_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO5_CTRL,
 	},
 	{
 		.name		= "LDO6",
+		.sname		= "ldo6-in",
 		.vsel_addr	= PALMAS_LDO6_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO6_CTRL,
 	},
 	{
 		.name		= "LDO7",
+		.sname		= "ldo7-in",
 		.vsel_addr	= PALMAS_LDO7_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO7_CTRL,
 	},
 	{
 		.name		= "LDO8",
+		.sname		= "ldo8-in",
 		.vsel_addr	= PALMAS_LDO8_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO8_CTRL,
 	},
 	{
 		.name		= "LDO9",
+		.sname		= "ldo9-in",
 		.vsel_addr	= PALMAS_LDO9_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDO9_CTRL,
 	},
 	{
 		.name		= "LDOLN",
+		.sname		= "ldoln-in",
 		.vsel_addr	= PALMAS_LDOLN_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDOLN_CTRL,
 	},
 	{
 		.name		= "LDOUSB",
+		.sname		= "ldousb-in",
 		.vsel_addr	= PALMAS_LDOUSB_VOLTAGE,
 		.ctrl_addr	= PALMAS_LDOUSB_CTRL,
 	},
@@ -710,6 +732,9 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 		else
 			config.init_data = NULL;
 
+		if (config.init_data)
+			pmic->desc[id].supply_name = palmas_regs_info[id].sname;
+
 		config.of_node = palmas_matches[id].of_node;
 
 		rdev = regulator_register(&pmic->desc[id], &config);
@@ -756,6 +781,9 @@ static int palmas_regulators_probe(struct platform_device *pdev)
 		else
 			config.init_data = NULL;
 
+		if (config.init_data)
+			pmic->desc[id].supply_name = palmas_regs_info[id].sname;
+
 		config.of_node = palmas_matches[id].of_node;
 
 		rdev = regulator_register(&pmic->desc[id], &config);
-- 
1.7.1.1

