Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3BFLCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:02:37 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51917 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab3BFLCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:02:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, linus.walleij@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 05/49] ARM: ux500: regulators: Add mask for configuration
Date: Wed,  6 Feb 2013 10:53:27 +0000
Message-Id: <1360148051-7560-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is already before a register mask in the regulator driver
to allow some bits of a register to be initialized. The register
value is defined in the board configuration. This patch puts a
mask in the board configuration to specify which bits should
actually be altered. The purpose with this patch is to avoid
future mistakes when updating the allowed bits in the regulator
driver.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500-regulators.c |   66 ++++++++++++-------------
 drivers/regulator/ab8500.c                    |   36 ++++++--------
 include/linux/regulator/ab8500.h              |   10 ++--
 3 files changed, 53 insertions(+), 59 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500-regulators.c b/arch/arm/mach-ux500/board-mop500-regulators.c
index 4b3c519..96dd174 100644
--- a/arch/arm/mach-ux500/board-mop500-regulators.c
+++ b/arch/arm/mach-ux500/board-mop500-regulators.c
@@ -129,19 +129,19 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 * VpllRequestCtrl          = HP/LP depending on VxRequest
 	 * VextSupply1RequestCtrl   = HP/LP depending on VxRequest
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL2, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL2,       0xfc, 0x00),
 	/*
 	 * VextSupply2RequestCtrl   = HP/LP depending on VxRequest
 	 * VextSupply3RequestCtrl   = HP/LP depending on VxRequest
 	 * Vaux1RequestCtrl         = HP/LP depending on VxRequest
 	 * Vaux2RequestCtrl         = HP/LP depending on VxRequest
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL3, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL3,       0xff, 0x00),
 	/*
 	 * Vaux3RequestCtrl         = HP/LP depending on VxRequest
 	 * SwHPReq                  = Control through SWValid disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL4, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUREQUESTCTRL4,       0x07, 0x00),
 	/*
 	 * Vsmps1SysClkReq1HPValid  = enabled
 	 * Vsmps2SysClkReq1HPValid  = enabled
@@ -152,44 +152,44 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 * Vaux2SysClkReq1HPValid   = disabled
 	 * Vaux3SysClkReq1HPValid   = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0x17),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID1, 0xff, 0x17),
 	/*
 	 * VextSupply1SysClkReq1HPValid = disabled
 	 * VextSupply2SysClkReq1HPValid = disabled
 	 * VextSupply3SysClkReq1HPValid = SysClkReq1 controlled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID2, 0x40),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQ1HPVALID2, 0x70, 0x40),
 	/*
 	 * VanaHwHPReq1Valid        = disabled
 	 * Vaux1HwHPreq1Valid       = disabled
 	 * Vaux2HwHPReq1Valid       = disabled
 	 * Vaux3HwHPReqValid        = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ1VALID1, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ1VALID1,     0xe8, 0x00),
 	/*
 	 * VextSupply1HwHPReq1Valid = disabled
 	 * VextSupply2HwHPReq1Valid = disabled
 	 * VextSupply3HwHPReq1Valid = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ1VALID2, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ1VALID2,     0x07, 0x00),
 	/*
 	 * VanaHwHPReq2Valid        = disabled
 	 * Vaux1HwHPReq2Valid       = disabled
 	 * Vaux2HwHPReq2Valid       = disabled
 	 * Vaux3HwHPReq2Valid       = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ2VALID1, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ2VALID1,     0xe8, 0x00),
 	/*
 	 * VextSupply1HwHPReq2Valid = disabled
 	 * VextSupply2HwHPReq2Valid = disabled
 	 * VextSupply3HwHPReq2Valid = HWReq2 controlled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ2VALID2, 0x04),
+	INIT_REGULATOR_REGISTER(AB8500_REGUHWHPREQ2VALID2,     0x07, 0x04),
 	/*
 	 * VanaSwHPReqValid         = disabled
 	 * Vaux1SwHPReqValid        = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSWHPREQVALID1, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSWHPREQVALID1,      0xa0, 0x00),
 	/*
 	 * Vaux2SwHPReqValid        = disabled
 	 * Vaux3SwHPReqValid        = disabled
@@ -197,7 +197,7 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 * VextSupply2SwHPReqValid  = disabled
 	 * VextSupply3SwHPReqValid  = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSWHPREQVALID2, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSWHPREQVALID2,      0x1f, 0x00),
 	/*
 	 * SysClkReq2Valid1         = SysClkReq2 controlled
 	 * SysClkReq3Valid1         = disabled
@@ -207,7 +207,7 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 * SysClkReq7Valid1         = disabled
 	 * SysClkReq8Valid1         = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQVALID1, 0x2a),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQVALID1,    0xfe, 0x2a),
 	/*
 	 * SysClkReq2Valid2         = disabled
 	 * SysClkReq3Valid2         = disabled
@@ -217,7 +217,7 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 * SysClkReq7Valid2         = disabled
 	 * SysClkReq8Valid2         = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQVALID2, 0x20),
+	INIT_REGULATOR_REGISTER(AB8500_REGUSYSCLKREQVALID2,    0xfe, 0x20),
 	/*
 	 * VTVoutEna                = disabled
 	 * Vintcore12Ena            = disabled
@@ -225,57 +225,57 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 * Vintcore12LP             = inactive (HP)
 	 * VTVoutLP                 = inactive (HP)
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUMISC1, 0x10),
+	INIT_REGULATOR_REGISTER(AB8500_REGUMISC1,              0xfe, 0x10),
 	/*
 	 * VaudioEna                = disabled
 	 * VdmicEna                 = disabled
 	 * Vamic1Ena                = disabled
 	 * Vamic2Ena                = disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VAUDIOSUPPLY, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_VAUDIOSUPPLY,           0x1e, 0x00),
 	/*
 	 * Vamic1_dzout             = high-Z when Vamic1 is disabled
 	 * Vamic2_dzout             = high-Z when Vamic2 is disabled
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL1VAMIC, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL1VAMIC,         0x03, 0x00),
 	/*
 	 * VBBN                     = force OFF
 	 * VBBP                     = force OFF
 	 * NOTE! PRCMU register
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_ARMREGU2,               0x00),
+	INIT_REGULATOR_REGISTER(AB8500_ARMREGU2,               0x0f, 0x00),
 	/*
 	 * VBBNSel1                 = VBBP = VBBPFB
 	 * VBBPSel1                 = 0 V
 	 * NOTE! PRCMU register
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VBBSEL1,                0x00),
+	INIT_REGULATOR_REGISTER(AB8500_VBBSEL1,                0x0f, 0x00),
 	/*
 	 * VBBNSel2                 = VBBP = VBBPFB
 	 * VBBPSel2                 = 0 V
 	 * NOTE! PRCMU register
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VBBSEL2,                0x00),
+	INIT_REGULATOR_REGISTER(AB8500_VBBSEL2,                0x0f, 0x00),
 	/*
 	 * Vsmps1Regu               = HW control
 	 * Vsmps1SelCtrl            = Vsmps1 voltage defined by Vsmsp1Sel2
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VSMPS1REGU,             0x06),
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS1REGU,             0x0f, 0x06),
 	/*
 	 * Vsmps2Regu               = HW control
 	 * Vsmps2SelCtrl            = Vsmps2 voltage defined by Vsmsp2Sel2
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VSMPS2REGU,             0x06),
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS2REGU,             0x0f, 0x06),
 	/*
 	 * VPll                     = Hw controlled
 	 * VanaRegu                 = force off
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VPLLVANAREGU, 0x02),
+	INIT_REGULATOR_REGISTER(AB8500_VPLLVANAREGU,           0x0f, 0x02),
 	/*
 	 * VrefDDREna               = disabled
 	 * VrefDDRSleepMode         = inactive (no pulldown)
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VREFDDR, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_VREFDDR,                0x03, 0x00),
 	/*
 	 * VextSupply1Regu          = HW control
 	 * VextSupply2Regu          = HW control
@@ -283,37 +283,37 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 * ExtSupply2Bypass         = ExtSupply12LPn ball is 0 when Ena is 0
 	 * ExtSupply3Bypass         = ExtSupply3LPn ball is 0 when Ena is 0
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU, 0x2a),
+	INIT_REGULATOR_REGISTER(AB8500_EXTSUPPLYREGU,          0xff, 0x1a),
 	/*
 	 * Vaux1Regu                = force HP
 	 * Vaux2Regu                = force off
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VAUX12REGU, 0x01),
+	INIT_REGULATOR_REGISTER(AB8500_VAUX12REGU,             0x0f, 0x01),
 	/*
 	 * Vrf1Regu                 = HW control
 	 * Vaux3Regu                = force off
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3REGU, 0x08),
+	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3REGU,          0x0f, 0x08),
 	/*
 	 * Vsmps1                   = 1.15V
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VSMPS1SEL1, 0x24),
+	INIT_REGULATOR_REGISTER(AB8500_VSMPS1SEL1,             0x3f, 0x24),
 	/*
 	 * Vaux1Sel                 = 2.5 V
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VAUX1SEL, 0x08),
+	INIT_REGULATOR_REGISTER(AB8500_VAUX1SEL,               0x0f, 0x08),
 	/*
 	 * Vaux2Sel                 = 2.9 V
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VAUX2SEL, 0x0d),
+	INIT_REGULATOR_REGISTER(AB8500_VAUX2SEL,               0x0f, 0x0d),
 	/*
 	 * Vaux3Sel                 = 2.91 V
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3SEL, 0x07),
+	INIT_REGULATOR_REGISTER(AB8500_VRF1VAUX3SEL,           0x07, 0x07),
 	/*
 	 * VextSupply12LP           = disabled (no LP)
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL2SPARE, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUCTRL2SPARE,         0x01, 0x00),
 	/*
 	 * Vaux1Disch               = short discharge time
 	 * Vaux2Disch               = short discharge time
@@ -322,13 +322,13 @@ ab8500_regulator_reg_init[AB8500_NUM_REGULATOR_REGISTERS] = {
 	 * VTVoutDisch              = short discharge time
 	 * VaudioDisch              = short discharge time
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUCTRLDISCH, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUCTRLDISCH,          0xfc, 0x00),
 	/*
 	 * VanaDisch                = short discharge time
 	 * VdmicPullDownEna         = pulldown disabled when Vdmic is disabled
 	 * VdmicDisch               = short discharge time
 	 */
-	INIT_REGULATOR_REGISTER(AB8500_REGUCTRLDISCH2, 0x00),
+	INIT_REGULATOR_REGISTER(AB8500_REGUCTRLDISCH2,         0x16, 0x00),
 };
 
 /* AB8500 regulators */
diff --git a/drivers/regulator/ab8500.c b/drivers/regulator/ab8500.c
index be9d842..b1b9687 100644
--- a/drivers/regulator/ab8500.c
+++ b/drivers/regulator/ab8500.c
@@ -812,23 +812,20 @@ static struct ab8500_reg_init ab8500_reg_init[] = {
 	REG_INIT(AB8500_REGUCTRLDISCH2,		0x04, 0x44, 0x16),
 };
 
-static int
-ab8500_regulator_init_registers(struct platform_device *pdev, int id, int value)
+static int ab8500_regulator_init_registers(struct platform_device *pdev,
+					   int id, int mask, int value)
 {
 	int err;
 
-	if (value & ~ab8500_reg_init[id].mask) {
-		dev_err(&pdev->dev,
-			"Configuration error: value outside mask.\n");
-		return -EINVAL;
-	}
+	BUG_ON(value & ~mask);
+	BUG_ON(mask & ~ab8500_reg_init[id].mask);
 
+	/* initialize register */
 	err = abx500_mask_and_set_register_interruptible(
 		&pdev->dev,
 		ab8500_reg_init[id].bank,
 		ab8500_reg_init[id].addr,
-		ab8500_reg_init[id].mask,
-		value);
+		mask, value);
 	if (err < 0) {
 		dev_err(&pdev->dev,
 			"Failed to initialize 0x%02x, 0x%02x.\n",
@@ -836,13 +833,11 @@ ab8500_regulator_init_registers(struct platform_device *pdev, int id, int value)
 			ab8500_reg_init[id].addr);
 		return err;
 	}
-
 	dev_vdbg(&pdev->dev,
-		"init: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
-		ab8500_reg_init[id].bank,
-		ab8500_reg_init[id].addr,
-		ab8500_reg_init[id].mask,
-		value);
+		 "  init: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n",
+		 ab8500_reg_init[id].bank,
+		 ab8500_reg_init[id].addr,
+		 mask, value);
 
 	return 0;
 }
@@ -961,19 +956,16 @@ static int ab8500_regulator_probe(struct platform_device *pdev)
 
 	/* initialize registers */
 	for (i = 0; i < pdata->num_regulator_reg_init; i++) {
-		int id, value;
+		int id, mask, value;
 
 		id = pdata->regulator_reg_init[i].id;
+		mask = pdata->regulator_reg_init[i].mask;
 		value = pdata->regulator_reg_init[i].value;
 
 		/* check for configuration errors */
-		if (id >= AB8500_NUM_REGULATOR_REGISTERS) {
-			dev_err(&pdev->dev,
-				"Configuration error: id outside range.\n");
-			return -EINVAL;
-		}
+		BUG_ON(id >= AB8500_NUM_REGULATOR_REGISTERS);
 
-		err = ab8500_regulator_init_registers(pdev, id, value);
+		err = ab8500_regulator_init_registers(pdev, id, mask, value);
 		if (err < 0)
 			return err;
 	}
diff --git a/include/linux/regulator/ab8500.h b/include/linux/regulator/ab8500.h
index 2c6c962..a1d245f 100644
--- a/include/linux/regulator/ab8500.h
+++ b/include/linux/regulator/ab8500.h
@@ -48,13 +48,15 @@ enum ab9540_regulator_id {
 /* AB8500 and AB9540 register initialization */
 struct ab8500_regulator_reg_init {
 	int id;
+	u8 mask;
 	u8 value;
 };
 
-#define INIT_REGULATOR_REGISTER(_id, _value)	\
-	{					\
-		.id = _id,			\
-		.value = _value,		\
+#define INIT_REGULATOR_REGISTER(_id, _mask, _value)	\
+	{						\
+		.id = _id,				\
+		.mask = _mask,				\
+		.value = _value,			\
 	}
 
 /* AB8500 registers */
-- 
1.7.9.5

