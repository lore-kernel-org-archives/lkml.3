Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab3BFLD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:03:29 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52183 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab3BFKzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 05:55:03 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 23/49] regulator: ab8500: Add support for the ab9540
Date: Wed,  6 Feb 2013 10:53:45 +0000
Message-Id: <1360148051-7560-24-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To obtain full AB9540 regulator support, the AB8500 regulator driver
first needs to know its register layout and their initialisation values
for each. That information is provided via a couple of large data
structures which we provide here.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/regulator/ab8500.c |  582 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 573 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index aadaa9c..104a4c7 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -375,6 +375,7 @@ static struct regulator_ops ab8500_regulator_ops = {
 	.list_voltage		= regulator_list_voltage_table,
 };
 
+/* AB8500 regulator information */
 static struct ab8500_regulator_info
 		ab8500_regulator_info[AB8500_NUM_REGULATORS] = {
 	/*
@@ -576,8 +577,264 @@ static struct ab8500_regulator_info
 		.update_val_idle	= 0x0c,
 		.update_val_normal	= 0x04,
 	},
+};
+
+/* AB9540 regulator information */
+static struct ab8500_regulator_info
+		ab9540_regulator_info[AB9540_NUM_REGULATORS] = {
+	/*
+	 * Variable Voltage Regulators
+	 *   name, min mV, max mV,
+	 *   update bank, reg, mask, enable val
+	 *   volt bank, reg, mask, table, table length
+	 */
+	[AB9540_LDO_AUX1] = {
+		.desc = {
+			.name		= "LDO-AUX1",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
+		.load_lp_uA		= 5000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x09,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x1f,
+		.voltage_mask		= 0x0f,
+		.voltages		= ldo_vauxn_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
+	},
+	[AB9540_LDO_AUX2] = {
+		.desc = {
+			.name		= "LDO-AUX2",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
+		.load_lp_uA		= 5000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x09,
+		.update_mask		= 0x0c,
+		.update_val		= 0x04,
+		.update_val_idle	= 0x0c,
+		.update_val_normal	= 0x04,
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x20,
+		.voltage_mask		= 0x0f,
+		.voltages		= ldo_vauxn_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
+	},
+	[AB9540_LDO_AUX3] = {
+		.desc = {
+			.name		= "LDO-AUX3",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUX3,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vaux3_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
+		.load_lp_uA		= 5000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x0a,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x21,
+		.voltage_mask		= 0x07,
+		.voltages		= ldo_vaux3_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vaux3_voltages),
+	},
+	[AB9540_LDO_AUX4] = {
+		.desc = {
+			.name		= "LDO-AUX4",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB9540_LDO_AUX4,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vauxn_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
+		.load_lp_uA		= 5000,
+		/* values for Vaux4Regu register */
+		.update_bank		= 0x04,
+		.update_reg		= 0x2e,
+		.update_mask		= 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
+		/* values for Vaux4SEL register */
+		.voltage_bank		= 0x04,
+		.voltage_reg		= 0x2f,
+		.voltage_mask		= 0x0f,
+		.voltages		= ldo_vauxn_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vauxn_voltages),
+	},
+	[AB9540_LDO_INTCORE] = {
+		.desc = {
+			.name		= "LDO-INTCORE",
+			.ops		= &ab8500_regulator_volt_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_INTCORE,
+			.owner		= THIS_MODULE,
+			.n_voltages	= ARRAY_SIZE(ldo_vintcore_voltages),
+		},
+		.min_uV			= 1100000,
+		.max_uV			= 3300000,
+		.load_lp_uA		= 5000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x80,
+		.update_mask		= 0x44,
+		.update_val		= 0x44,
+		.update_val_idle	= 0x44,
+		.update_val_normal	= 0x04,
+		.voltage_bank		= 0x03,
+		.voltage_reg		= 0x80,
+		.voltage_mask		= 0x38,
+		.voltages		= ldo_vintcore_voltages,
+		.voltages_len		= ARRAY_SIZE(ldo_vintcore_voltages),
+	},
 
+	/*
+	 * Fixed Voltage Regulators
+	 *   name, fixed mV,
+	 *   update bank, reg, mask, enable val
+	 */
+	[AB9540_LDO_TVOUT] = {
+		.desc = {
+			.name		= "LDO-TVOUT",
+			.ops		= &ab8500_regulator_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_TVOUT,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.delay			= 10000,
+		.fixed_uV		= 2000000,
+		.load_lp_uA		= 1000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x80,
+		.update_mask		= 0x82,
+		.update_val		= 0x02,
+		.update_val_idle	= 0x82,
+		.update_val_normal	= 0x02,
+	},
+	[AB9540_LDO_USB] = {
+		.desc = {
+			.name           = "LDO-USB",
+			.ops            = &ab8500_regulator_ops,
+			.type           = REGULATOR_VOLTAGE,
+			.id             = AB9540_LDO_USB,
+			.owner          = THIS_MODULE,
+			.n_voltages     = 1,
+		},
+		.fixed_uV               = 3300000,
+		.update_bank            = 0x03,
+		.update_reg             = 0x82,
+		.update_mask            = 0x03,
+		.update_val		= 0x01,
+		.update_val_idle	= 0x03,
+		.update_val_normal	= 0x01,
+	},
+	[AB9540_LDO_AUDIO] = {
+		.desc = {
+			.name		= "LDO-AUDIO",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_AUDIO,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 2000000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x02,
+		.update_val		= 0x02,
+	},
+	[AB9540_LDO_ANAMIC1] = {
+		.desc = {
+			.name		= "LDO-ANAMIC1",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANAMIC1,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 2050000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x08,
+		.update_val		= 0x08,
+	},
+	[AB9540_LDO_ANAMIC2] = {
+		.desc = {
+			.name		= "LDO-ANAMIC2",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANAMIC2,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 2050000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x10,
+		.update_val		= 0x10,
+	},
+	[AB9540_LDO_DMIC] = {
+		.desc = {
+			.name		= "LDO-DMIC",
+			.ops		= &ab8500_regulator_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_DMIC,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 1800000,
+		.update_bank		= 0x03,
+		.update_reg		= 0x83,
+		.update_mask		= 0x04,
+		.update_val		= 0x04,
+	},
 
+	/*
+	 * Regulators with fixed voltage and normal/idle modes
+	 */
+	[AB9540_LDO_ANA] = {
+		.desc = {
+			.name		= "LDO-ANA",
+			.ops		= &ab8500_regulator_mode_ops,
+			.type		= REGULATOR_VOLTAGE,
+			.id		= AB8500_LDO_ANA,
+			.owner		= THIS_MODULE,
+			.n_voltages	= 1,
+		},
+		.fixed_uV		= 1200000,
+		.load_lp_uA		= 1000,
+		.load_lp_uA		= 1000,
+		.update_bank		= 0x04,
+		.update_reg		= 0x06,
+		.update_mask		= 0x0c,
+		.update_val		= 0x08,
+		.update_val_idle	= 0x0c,
+		.update_val_normal	= 0x08,
+	},
 };
 
 struct ab8500_reg_init {
@@ -593,6 +850,7 @@ struct ab8500_reg_init {
 		.mask = _mask,			\
 	}
 
+/* AB8500 register init */
 static struct ab8500_reg_init ab8500_reg_init[] = {
 	/*
 	 * 0x30, VanaRequestCtrl
@@ -763,6 +1021,281 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	REG_INIT(AB8500_REGUCTRLDISCH2,		0x04, 0x44, 0x16),
 };
 
+/* AB9540 register init */
+static struct ab8500_reg_init ab9540_reg_init[] = {
+	/*
+	 * 0x03, VarmRequestCtrl
+	 * 0x0c, VapeRequestCtrl
+	 * 0x30, Vsmps1RequestCtrl
+	 * 0xc0, Vsmps2RequestCtrl
+	 */
+	REG_INIT(AB9540_REGUREQUESTCTRL1,	0x03, 0x03, 0xff),
+	/*
+	 * 0x03, Vsmps3RequestCtrl
+	 * 0x0c, VpllRequestCtrl
+	 * 0x30, VanaRequestCtrl
+	 * 0xc0, VextSupply1RequestCtrl
+	 */
+	REG_INIT(AB9540_REGUREQUESTCTRL2,	0x03, 0x04, 0xff),
+	/*
+	 * 0x03, VextSupply2RequestCtrl
+	 * 0x0c, VextSupply3RequestCtrl
+	 * 0x30, Vaux1RequestCtrl
+	 * 0xc0, Vaux2RequestCtrl
+	 */
+	REG_INIT(AB9540_REGUREQUESTCTRL3,	0x03, 0x05, 0xff),
+	/*
+	 * 0x03, Vaux3RequestCtrl
+	 * 0x04, SwHPReq
+	 */
+	REG_INIT(AB9540_REGUREQUESTCTRL4,	0x03, 0x06, 0x07),
+	/*
+	 * 0x01, Vsmps1SysClkReq1HPValid
+	 * 0x02, Vsmps2SysClkReq1HPValid
+	 * 0x04, Vsmps3SysClkReq1HPValid
+	 * 0x08, VanaSysClkReq1HPValid
+	 * 0x10, VpllSysClkReq1HPValid
+	 * 0x20, Vaux1SysClkReq1HPValid
+	 * 0x40, Vaux2SysClkReq1HPValid
+	 * 0x80, Vaux3SysClkReq1HPValid
+	 */
+	REG_INIT(AB9540_REGUSYSCLKREQ1HPVALID1,	0x03, 0x07, 0xff),
+	/*
+	 * 0x01, VapeSysClkReq1HPValid
+	 * 0x02, VarmSysClkReq1HPValid
+	 * 0x04, VbbSysClkReq1HPValid
+	 * 0x08, VmodSysClkReq1HPValid
+	 * 0x10, VextSupply1SysClkReq1HPValid
+	 * 0x20, VextSupply2SysClkReq1HPValid
+	 * 0x40, VextSupply3SysClkReq1HPValid
+	 */
+	REG_INIT(AB9540_REGUSYSCLKREQ1HPVALID2,	0x03, 0x08, 0x7f),
+	/*
+	 * 0x01, Vsmps1HwHPReq1Valid
+	 * 0x02, Vsmps2HwHPReq1Valid
+	 * 0x04, Vsmps3HwHPReq1Valid
+	 * 0x08, VanaHwHPReq1Valid
+	 * 0x10, VpllHwHPReq1Valid
+	 * 0x20, Vaux1HwHPReq1Valid
+	 * 0x40, Vaux2HwHPReq1Valid
+	 * 0x80, Vaux3HwHPReq1Valid
+	 */
+	REG_INIT(AB9540_REGUHWHPREQ1VALID1,	0x03, 0x09, 0xff),
+	/*
+	 * 0x01, VextSupply1HwHPReq1Valid
+	 * 0x02, VextSupply2HwHPReq1Valid
+	 * 0x04, VextSupply3HwHPReq1Valid
+	 * 0x08, VmodHwHPReq1Valid
+	 */
+	REG_INIT(AB9540_REGUHWHPREQ1VALID2,	0x03, 0x0a, 0x0f),
+	/*
+	 * 0x01, Vsmps1HwHPReq2Valid
+	 * 0x02, Vsmps2HwHPReq2Valid
+	 * 0x03, Vsmps3HwHPReq2Valid
+	 * 0x08, VanaHwHPReq2Valid
+	 * 0x10, VpllHwHPReq2Valid
+	 * 0x20, Vaux1HwHPReq2Valid
+	 * 0x40, Vaux2HwHPReq2Valid
+	 * 0x80, Vaux3HwHPReq2Valid
+	 */
+	REG_INIT(AB9540_REGUHWHPREQ2VALID1,	0x03, 0x0b, 0xff),
+	/*
+	 * 0x01, VextSupply1HwHPReq2Valid
+	 * 0x02, VextSupply2HwHPReq2Valid
+	 * 0x04, VextSupply3HwHPReq2Valid
+	 * 0x08, VmodHwHPReq2Valid
+	 */
+	REG_INIT(AB9540_REGUHWHPREQ2VALID2,	0x03, 0x0c, 0x0f),
+	/*
+	 * 0x01, VapeSwHPReqValid
+	 * 0x02, VarmSwHPReqValid
+	 * 0x04, Vsmps1SwHPReqValid
+	 * 0x08, Vsmps2SwHPReqValid
+	 * 0x10, Vsmps3SwHPReqValid
+	 * 0x20, VanaSwHPReqValid
+	 * 0x40, VpllSwHPReqValid
+	 * 0x80, Vaux1SwHPReqValid
+	 */
+	REG_INIT(AB9540_REGUSWHPREQVALID1,	0x03, 0x0d, 0xff),
+	/*
+	 * 0x01, Vaux2SwHPReqValid
+	 * 0x02, Vaux3SwHPReqValid
+	 * 0x04, VextSupply1SwHPReqValid
+	 * 0x08, VextSupply2SwHPReqValid
+	 * 0x10, VextSupply3SwHPReqValid
+	 * 0x20, VmodSwHPReqValid
+	 */
+	REG_INIT(AB9540_REGUSWHPREQVALID2,	0x03, 0x0e, 0x3f),
+	/*
+	 * 0x02, SysClkReq2Valid1
+	 * ...
+	 * 0x80, SysClkReq8Valid1
+	 */
+	REG_INIT(AB9540_REGUSYSCLKREQVALID1,	0x03, 0x0f, 0xfe),
+	/*
+	 * 0x02, SysClkReq2Valid2
+	 * ...
+	 * 0x80, SysClkReq8Valid2
+	 */
+	REG_INIT(AB9540_REGUSYSCLKREQVALID2,	0x03, 0x10, 0xfe),
+	/*
+	 * 0x01, Vaux4SwHPReqValid
+	 * 0x02, Vaux4HwHPReq2Valid
+	 * 0x04, Vaux4HwHPReq1Valid
+	 * 0x08, Vaux4SysClkReq1HPValid
+	 */
+	REG_INIT(AB9540_REGUVAUX4REQVALID,	0x03, 0x11, 0x0f),
+	/*
+	 * 0x02, VTVoutEna
+	 * 0x04, Vintcore12Ena
+	 * 0x38, Vintcore12Sel
+	 * 0x40, Vintcore12LP
+	 * 0x80, VTVoutLP
+	 */
+	REG_INIT(AB9540_REGUMISC1,		0x03, 0x80, 0xfe),
+	/*
+	 * 0x02, VaudioEna
+	 * 0x04, VdmicEna
+	 * 0x08, Vamic1Ena
+	 * 0x10, Vamic2Ena
+	 */
+	REG_INIT(AB9540_VAUDIOSUPPLY,		0x03, 0x83, 0x1e),
+	/*
+	 * 0x01, Vamic1_dzout
+	 * 0x02, Vamic2_dzout
+	 */
+	REG_INIT(AB9540_REGUCTRL1VAMIC,		0x03, 0x84, 0x03),
+	/*
+	 * 0x03, Vsmps1Regu
+	 * 0x0c, Vsmps1SelCtrl
+	 * 0x10, Vsmps1AutoMode
+	 * 0x20, Vsmps1PWMMode
+	 */
+	REG_INIT(AB9540_VSMPS1REGU,		0x04, 0x03, 0x3f),
+	/*
+	 * 0x03, Vsmps2Regu
+	 * 0x0c, Vsmps2SelCtrl
+	 * 0x10, Vsmps2AutoMode
+	 * 0x20, Vsmps2PWMMode
+	 */
+	REG_INIT(AB9540_VSMPS2REGU,		0x04, 0x04, 0x3f),
+	/*
+	 * 0x03, Vsmps3Regu
+	 * 0x0c, Vsmps3SelCtrl
+	 * NOTE! PRCMU register
+	 */
+	REG_INIT(AB9540_VSMPS3REGU,		0x04, 0x05, 0x0f),
+	/*
+	 * 0x03, VpllRegu
+	 * 0x0c, VanaRegu
+	 */
+	REG_INIT(AB9540_VPLLVANAREGU,		0x04, 0x06, 0x0f),
+	/*
+	 * 0x03, VextSupply1Regu
+	 * 0x0c, VextSupply2Regu
+	 * 0x30, VextSupply3Regu
+	 * 0x40, ExtSupply2Bypass
+	 * 0x80, ExtSupply3Bypass
+	 */
+	REG_INIT(AB9540_EXTSUPPLYREGU,		0x04, 0x08, 0xff),
+	/*
+	 * 0x03, Vaux1Regu
+	 * 0x0c, Vaux2Regu
+	 */
+	REG_INIT(AB9540_VAUX12REGU,		0x04, 0x09, 0x0f),
+	/*
+	 * 0x0c, Vrf1Regu
+	 * 0x03, Vaux3Regu
+	 */
+	REG_INIT(AB9540_VRF1VAUX3REGU,		0x04, 0x0a, 0x0f),
+	/*
+	 * 0x3f, Vsmps1Sel1
+	 */
+	REG_INIT(AB9540_VSMPS1SEL1,		0x04, 0x13, 0x3f),
+	/*
+	 * 0x3f, Vsmps1Sel2
+	 */
+	REG_INIT(AB9540_VSMPS1SEL2,		0x04, 0x14, 0x3f),
+	/*
+	 * 0x3f, Vsmps1Sel3
+	 */
+	REG_INIT(AB9540_VSMPS1SEL3,		0x04, 0x15, 0x3f),
+	/*
+	 * 0x3f, Vsmps2Sel1
+	 */
+	REG_INIT(AB9540_VSMPS2SEL1,		0x04, 0x17, 0x3f),
+	/*
+	 * 0x3f, Vsmps2Sel2
+	 */
+	REG_INIT(AB9540_VSMPS2SEL2,		0x04, 0x18, 0x3f),
+	/*
+	 * 0x3f, Vsmps2Sel3
+	 */
+	REG_INIT(AB9540_VSMPS2SEL3,		0x04, 0x19, 0x3f),
+	/*
+	 * 0x7f, Vsmps3Sel1
+	 * NOTE! PRCMU register
+	 */
+	REG_INIT(AB9540_VSMPS3SEL1,             0x04, 0x1b, 0x7f),
+	/*
+	 * 0x7f, Vsmps3Sel2
+	 * NOTE! PRCMU register
+	 */
+	REG_INIT(AB9540_VSMPS3SEL2,             0x04, 0x1c, 0x7f),
+	/*
+	 * 0x0f, Vaux1Sel
+	 */
+	REG_INIT(AB9540_VAUX1SEL,		0x04, 0x1f, 0x0f),
+	/*
+	 * 0x0f, Vaux2Sel
+	 */
+	REG_INIT(AB9540_VAUX2SEL,		0x04, 0x20, 0x0f),
+	/*
+	 * 0x07, Vaux3Sel
+	 * 0x30, Vrf1Sel
+	 */
+	REG_INIT(AB9540_VRF1VAUX3SEL,		0x04, 0x21, 0x37),
+	/*
+	 * 0x01, VextSupply12LP
+	 */
+	REG_INIT(AB9540_REGUCTRL2SPARE,		0x04, 0x22, 0x01),
+	/*
+	 * 0x03, Vaux4RequestCtrl
+	 */
+	REG_INIT(AB9540_VAUX4REQCTRL,		0x04, 0x2d, 0x03),
+	/*
+	 * 0x03, Vaux4Regu
+	 */
+	REG_INIT(AB9540_VAUX4REGU,		0x04, 0x2e, 0x03),
+	/*
+	 * 0x08, Vaux4Sel
+	 */
+	REG_INIT(AB9540_VAUX4SEL,		0x04, 0x2f, 0x0f),
+	/*
+	 * 0x01, VpllDisch
+	 * 0x02, Vrf1Disch
+	 * 0x04, Vaux1Disch
+	 * 0x08, Vaux2Disch
+	 * 0x10, Vaux3Disch
+	 * 0x20, Vintcore12Disch
+	 * 0x40, VTVoutDisch
+	 * 0x80, VaudioDisch
+	 */
+	REG_INIT(AB9540_REGUCTRLDISCH,		0x04, 0x43, 0xff),
+	/*
+	 * 0x01, VsimDisch
+	 * 0x02, VanaDisch
+	 * 0x04, VdmicPullDownEna
+	 * 0x08, VpllPullDownEna
+	 * 0x10, VdmicDisch
+	 */
+	REG_INIT(AB9540_REGUCTRLDISCH2,		0x04, 0x44, 0x1f),
+	/*
+	 * 0x01, Vaux4Disch
+	 */
+	REG_INIT(AB9540_REGUCTRLDISCH3,		0x04, 0x48, 0x01),
+};
+
 static int ab8500_regulator_init_registers(struct platform_device *pdev,
 					   struct ab8500_reg_init *reg_init,
 					   int id, int mask, int value)
@@ -799,6 +1332,7 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 				     struct ab8500_regulator_info *regulator_info,
 				     int id, struct device_node *np)
 {
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_regulator_info *info = NULL;
 	struct regulator_config config = { };
 	int err;
@@ -813,7 +1347,7 @@ static int ab8500_regulator_register(struct platform_device *pdev,
 	config.of_node = np;
 
 	/* fix for hardware before ab8500v2.0 */
-	if (abx500_get_chip_id(info->dev) < 0x20) {
+	if (is_ab8500_1p1_or_earlier(ab8500)) {
 		if (info->desc.id == AB8500_LDO_AUX3) {
 			info->desc.n_voltages =
 				ARRAY_SIZE(ldo_vauxn_voltages);
@@ -852,6 +1386,20 @@ static struct of_regulator_match ab8500_regulator_match[] = {
 	{ .name	= "ab8500_ldo_ana",     .driver_data = (void *) AB8500_LDO_ANA, },
 };
 
+static struct of_regulator_match ab9540_regulator_match[] = {
+	{ .name = "ab9540_ldo_aux1",    .driver_data = (void *) AB9540_LDO_AUX1, },
+	{ .name = "ab9540_ldo_aux2",    .driver_data = (void *) AB9540_LDO_AUX2, },
+	{ .name = "ab9540_ldo_aux3",    .driver_data = (void *) AB9540_LDO_AUX3, },
+	{ .name = "ab9540_ldo_intcore", .driver_data = (void *) AB9540_LDO_INTCORE, },
+	{ .name = "ab9540_ldo_tvout",   .driver_data = (void *) AB9540_LDO_TVOUT, },
+	{ .name = "ab9540_ldo_usb",     .driver_data = (void *) AB9540_LDO_USB, },
+	{ .name = "ab9540_ldo_audio",   .driver_data = (void *) AB9540_LDO_AUDIO, },
+	{ .name = "ab9540_ldo_anamic1", .driver_data = (void *) AB9540_LDO_ANAMIC1, },
+	{ .name = "ab9540_ldo_amamic2", .driver_data = (void *) AB9540_LDO_ANAMIC2, },
+	{ .name = "ab9540_ldo_dmic",    .driver_data = (void *) AB9540_LDO_DMIC, },
+	{ .name = "ab9540_ldo_ana",     .driver_data = (void *) AB9540_LDO_ANA, },
+};
+
 static int
 ab8500_regulator_of_probe(struct platform_device *pdev,
 			  struct ab8500_regulator_info *regulator_info,
@@ -885,12 +1433,21 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 	struct ab8500_reg_init *reg_init;
 	int reg_init_size;
 
-	regulator_info = ab8500_regulator_info;
-	regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
-	reg_init = ab8500_reg_init;
-	reg_init_size = AB8500_NUM_REGULATOR_REGISTERS;
-	match = ab8500_regulator_match;
-	match_size = ARRAY_SIZE(ab8500_regulator_match)
+	if (is_ab9540(ab8500)) {
+		regulator_info = ab9540_regulator_info;
+		regulator_info_size = ARRAY_SIZE(ab9540_regulator_info);
+		reg_init = ab9540_reg_init;
+		reg_init_size = AB9540_NUM_REGULATOR_REGISTERS;
+		match = ab9540_regulator_match;
+		match_size = ARRAY_SIZE(ab9540_regulator_match)
+	} else {
+		regulator_info = ab8500_regulator_info;
+		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
+		reg_init = ab8500_reg_init;
+		reg_init_size = AB8500_NUM_REGULATOR_REGISTERS;
+		match = ab8500_regulator_match;
+		match_size = ARRAY_SIZE(ab8500_regulator_match)
+	}
 
 	if (np) {
 		err = of_regulator_match(&pdev->dev, np, match, match_size);
@@ -968,11 +1525,18 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 static int ab8500_regulator_remove(struct platform_device *pdev)
 {
 	int i, err;
+	struct ab8500 *ab8500 = dev_get_drvdata(pdev->dev.parent);
 	struct ab8500_regulator_info *regulator_info;
 	int regulator_info_size;
 
-	regulator_info = ab8500_regulator_info;
-	regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
+
+	if (is_ab9540(ab8500)) {
+		regulator_info = ab9540_regulator_info;
+		regulator_info_size = ARRAY_SIZE(ab9540_regulator_info);
+	} else {
+		regulator_info = ab8500_regulator_info;
+		regulator_info_size = ARRAY_SIZE(ab8500_regulator_info);
+	}
 
 	for (i = 0; i < regulator_info_size; i++) {
 		struct ab8500_regulator_info *info = NULL;
-- 
1.7.9.5

