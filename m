Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaE1Jk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:40:56 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:36801 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaE1Jjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:39:51 -0400
X-AuditID: cbfee690-b7fb56d000003439-fb-5385aee51155
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 3/4] extcon: sm5502: Change internal hardware switch according
 to cable type
Date: Wed, 28 May 2014 18:39:35 +0900
Message-id: <1401269976-12754-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1401269976-12754-1-git-send-email-cw00.choi@samsung.com>
References: <1401269976-12754-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWyRsSkQPfputZgg8/7BCyuf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmKC6blNSczLLUIn27BK6Mp92TGQv26VQsnzadsYGx
	V7WLkZNDQsBE4tjGZjYIW0ziwr31QDYXh5DAUkaJe0c3M8IUXVh7ihUiMZ1RYvNbkASI08Qk
	8aJ9FjtIFZuAlsT+FzfARokIKEhs7n3GCmIzC8RLnO3uBpskLBAncWt5L1gNi4CqxKcFr1lA
	bF4BV4mpc2G2yUl82PMIbCangJvEjBmHweqFgGqWHznIBLJYQuA9m8Tsn4dYIAYJSHybDGJz
	ACVkJTYdYIaYIylxcMUNlgmMwgsYGVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525iBAbr6X/P
	JuxgvHfA+hBjMtC4icxSosn5wGDPK4k3NDYzsjA1MTU2Mrc0I01YSZxX7VFSkJBAemJJanZq
	akFqUXxRaU5q8SFGJg5OqQZGg7VLJjO5MQU+m/FZVF1oR47M6vJnNnVLDLPd+55uT3jLaN55
	RazjxV025lU/uK+d77ol8vTr3DOb1ZTOlNyZKtlic+tie3O0oO43c6bmGzuNqoQvSGn7/jXo
	XvLnyELvxxpsT43ve+1/cDwx+3fhupPiG03+Fp6wZiv4YZBgv+RscvsK/w1MSizFGYmGWsxF
	xYkAfo6XF2wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jQd2n61qDDc7cYLe4/uU5q8XZpjfs
	Fpd3zWGzuN24gs2BxaNvyypGj8+b5AKYohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwM
	dQ0tLcyVFPISc1NtlVx8AnTdMnOANikplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0Jgusx
	MkADCWsYM552T2Ys2KdTsXzadMYGxl7VLkZODgkBE4kLa0+xQthiEhfurWfrYuTiEBKYziix
	+e1mRginiUniRfssdpAqNgEtif0vbrCB2CICChKbe5+BdTMLxEuc7e5mBLGFBeIkbi3vBath
	EVCV+LTgNQuIzSvgKjF17mZGiG1yEh/2PAKbySngJjFjxmGweiGgmuVHDjJNYORdwMiwilE0
	tSC5oDgpPddIrzgxt7g0L10vOT93EyM4Fp5J72Bc1WBxiFGAg1GJh/fA4pZgIdbEsuLK3EOM
	EhzMSiK8Tktbg4V4UxIrq1KL8uOLSnNSiw8xJgNdNZFZSjQ5HxineSXxhsYmZkaWRuaGFkbG
	5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAqH+PL/PX9q93aptiV93IcDse2Ni5NNsm
	htfPWXBL+/NJanZ7EhzXCLfvy+eVivaesbsze+eSThMbW4vkf4K/XBMf/bRu2mppUB93MfYt
	Qy7vv0r5tOd1xwr7r36WFeqVchLLmXflWK3UXVe9H7sltm1pVt89uWmZ7Rr+Vf8i4r6fTAnJ
	/DNViaU4I9FQi7moOBEAOfZNh8kCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes internal hardware DP_CON/DM_CON switch according to
cable type. The SM5502 MUIC device can set hardware switch as following:
- OPEN (not connected state) / USB / UART / AUDIO
Also, this patch set VBUSIN switch according to cable type.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/extcon/extcon-sm5502.c | 78 +++++++++++++++++++++++++++++++++++++++---
 include/linux/extcon/sm5502.h  | 23 +++++++++++++
 2 files changed, 96 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-sm5502.c b/drivers/extcon/extcon-sm5502.c
index 3588df0..e9f9311 100644
--- a/drivers/extcon/extcon-sm5502.c
+++ b/drivers/extcon/extcon-sm5502.c
@@ -228,6 +228,61 @@ static const struct regmap_config sm5502_muic_regmap_config = {
 	.max_register	= SM5502_REG_END,
 };
 
+/* Change DM_CON/DP_CON/VBUSIN switch according to cable type */
+static int sm5502_muic_set_path(struct sm5502_muic_info *info,
+				unsigned int con_sw, unsigned int vbus_sw,
+				bool attached)
+{
+	int ret;
+
+	if (!attached) {
+		con_sw	= DM_DP_SWITCH_OPEN;
+		vbus_sw	= VBUSIN_SWITCH_OPEN;
+	}
+
+	switch (con_sw) {
+	case DM_DP_SWITCH_OPEN:
+	case DM_DP_SWITCH_USB:
+	case DM_DP_SWITCH_AUDIO:
+	case DM_DP_SWITCH_UART:
+		ret = regmap_update_bits(info->regmap, SM5502_REG_MANUAL_SW1,
+					 SM5502_REG_MANUAL_SW1_DP_MASK |
+					 SM5502_REG_MANUAL_SW1_DM_MASK,
+					 con_sw);
+		if (ret < 0) {
+			dev_err(info->dev,
+				"cannot update DM_CON/DP_CON switch\n");
+			return ret;
+		}
+		break;
+	default:
+		dev_err(info->dev, "Unknown DM_CON/DP_CON switch type (%d)\n",
+				con_sw);
+		return -EINVAL;
+	};
+
+	switch (vbus_sw) {
+	case VBUSIN_SWITCH_OPEN:
+	case VBUSIN_SWITCH_VBUSOUT:
+	case VBUSIN_SWITCH_MIC:
+	case VBUSIN_SWITCH_VBUSOUT_WITH_USB:
+		ret = regmap_update_bits(info->regmap, SM5502_REG_MANUAL_SW1,
+					 SM5502_REG_MANUAL_SW1_VBUSIN_MASK,
+					 vbus_sw);
+		if (ret < 0) {
+			dev_err(info->dev,
+				"cannot update VBUSIN switch\n");
+			return ret;
+		}
+		break;
+	default:
+		dev_err(info->dev, "Unknown VBUS switch type (%d)\n", vbus_sw);
+		return -EINVAL;
+	};
+
+	return 0;
+}
+
 /* Return cable type of attached or detached accessories */
 static unsigned int sm5502_muic_get_cable_type(struct sm5502_muic_info *info)
 {
@@ -329,7 +384,10 @@ static int sm5502_muic_cable_handler(struct sm5502_muic_info *info,
 	static unsigned int prev_cable_type = SM5502_MUIC_ADC_GROUND;
 	const char **cable_names = info->edev->supported_cable;
 	unsigned int cable_type = SM5502_MUIC_ADC_GROUND;
+	unsigned int con_sw = DM_DP_SWITCH_OPEN;
+	unsigned int vbus_sw = VBUSIN_SWITCH_OPEN;
 	unsigned int idx = 0;
+	int ret;
 
 	if (!cable_names)
 		return 0;
@@ -343,15 +401,19 @@ static int sm5502_muic_cable_handler(struct sm5502_muic_info *info,
 
 	switch (cable_type) {
 	case SM5502_MUIC_ADC_OPEN_USB:
-		idx = EXTCON_CABLE_USB;
+		idx	= EXTCON_CABLE_USB;
+		con_sw	= DM_DP_SWITCH_USB;
+		vbus_sw	= VBUSIN_SWITCH_VBUSOUT_WITH_USB;
 		break;
 	case SM5502_MUIC_ADC_OPEN_TA:
-		idx = EXTCON_CABLE_TA;
+		idx	= EXTCON_CABLE_TA;
+		con_sw	= DM_DP_SWITCH_OPEN;
+		vbus_sw	= VBUSIN_SWITCH_VBUSOUT;
 		break;
 	case SM5502_MUIC_ADC_OPEN_USB_OTG:
-		idx = EXTCON_CABLE_USB_HOST;
-		break;
-	case SM5502_MUIC_ADC_GROUND:
+		idx	= EXTCON_CABLE_USB_HOST;
+		con_sw	= DM_DP_SWITCH_USB;
+		vbus_sw	= VBUSIN_SWITCH_OPEN;
 		break;
 	default:
 		dev_dbg(info->dev,
@@ -359,6 +421,12 @@ static int sm5502_muic_cable_handler(struct sm5502_muic_info *info,
 		return 0;
 	};
 
+	/* Change internal hardware path(DM_CON/DP_CON, VBUSIN) */
+	ret = sm5502_muic_set_path(info, con_sw, vbus_sw, attached);
+	if (ret < 0)
+		return ret;
+
+	/* Change the state of external accessory */
 	extcon_set_cable_state(info->edev, cable_names[idx], attached);
 
 	return 0;
diff --git a/include/linux/extcon/sm5502.h b/include/linux/extcon/sm5502.h
index 17bd655..030526b 100644
--- a/include/linux/extcon/sm5502.h
+++ b/include/linux/extcon/sm5502.h
@@ -223,6 +223,29 @@ enum sm5502_reg {
 #define SM5502_REG_DEV_TYPE2_TTY_MASK			(0x1 << SM5502_REG_DEV_TYPE2_TTY_SHIFT)
 #define SM5502_REG_DEV_TYPE2_AV_CABLE_MASK		(0x1 << SM5502_REG_DEV_TYPE2_AV_CABLE_SHIFT)
 
+#define SM5502_REG_MANUAL_SW1_VBUSIN_SHIFT	0
+#define SM5502_REG_MANUAL_SW1_DP_SHIFT		2
+#define SM5502_REG_MANUAL_SW1_DM_SHIFT		5
+#define SM5502_REG_MANUAL_SW1_VBUSIN_MASK	(0x3 << SM5502_REG_MANUAL_SW1_VBUSIN_SHIFT)
+#define SM5502_REG_MANUAL_SW1_DP_MASK		(0x7 << SM5502_REG_MANUAL_SW1_DP_SHIFT)
+#define SM5502_REG_MANUAL_SW1_DM_MASK		(0x7 << SM5502_REG_MANUAL_SW1_DM_SHIFT)
+#define VBUSIN_SWITCH_OPEN			0x0
+#define VBUSIN_SWITCH_VBUSOUT			0x1
+#define VBUSIN_SWITCH_MIC			0x2
+#define VBUSIN_SWITCH_VBUSOUT_WITH_USB		0x3
+#define DM_DP_CON_SWITCH_OPEN			0x0
+#define DM_DP_CON_SWITCH_USB			0x1
+#define DM_DP_CON_SWITCH_AUDIO			0x2
+#define DM_DP_CON_SWITCH_UART			0x3
+#define DM_DP_SWITCH_OPEN			((DM_DP_CON_SWITCH_OPEN <<SM5502_REG_MANUAL_SW1_DP_SHIFT) \
+						| (DM_DP_CON_SWITCH_OPEN <<SM5502_REG_MANUAL_SW1_DM_SHIFT))
+#define DM_DP_SWITCH_USB			((DM_DP_CON_SWITCH_USB <<SM5502_REG_MANUAL_SW1_DP_SHIFT) \
+						| (DM_DP_CON_SWITCH_USB <<SM5502_REG_MANUAL_SW1_DM_SHIFT))
+#define DM_DP_SWITCH_AUDIO			((DM_DP_CON_SWITCH_AUDIO <<SM5502_REG_MANUAL_SW1_DP_SHIFT) \
+						| (DM_DP_CON_SWITCH_AUDIO <<SM5502_REG_MANUAL_SW1_DM_SHIFT))
+#define DM_DP_SWITCH_UART			((DM_DP_CON_SWITCH_UART <<SM5502_REG_MANUAL_SW1_DP_SHIFT) \
+						| (DM_DP_CON_SWITCH_UART <<SM5502_REG_MANUAL_SW1_DM_SHIFT))
+
 /* SM5502 Interrupts */
 enum sm5502_irq {
 	/* INT1 */
-- 
1.8.0

