Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab3CMJCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:02:41 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29028 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3CMJCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:02:37 -0400
X-AuditID: cbfee68e-b7f946d000001e37-70-514040a73e18
From: Chanwoo Choi <cw00.choi@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, cw00.choi@samsung.com
Subject: [PATCH 3/3] extcon: max77693: Initialize register of MUIC device to
 bring up it without platform data
Date: Wed, 13 Mar 2013 18:02:18 +0900
Message-id: <1363165338-989-4-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1363165338-989-1-git-send-email-cw00.choi@samsung.com>
References: <1363165338-989-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t8zXd3lDg6BBj+O6Ftc//Kc1eJs0xt2
	i8u75rBZ3G5cwebA4tG3ZRWjx+dNcgFMUVw2Kak5mWWpRfp2CVwZ8890MRZ06VacmvSHvYFx
	omoXIyeHhICJxJRPn9ghbDGJC/fWs3UxcnEICSxjlDizahYzTNGz0/3sEInpjBLvtyxjhHD+
	M0osufacBaSKTUBLYv+LG2wgtoiAgsTm3mesIDazgJ/Em81fgRo4OIQFCiSaWwJBwiwCqhJr
	91wAK+EVcJa4NfM3I8QyOYkPex6xg5RzCrhIHLhQDhIWAipZfvMXC8haCYH3bBL/Z/azQMwR
	kPg2+RALSL2EgKzEpgNQN0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmb
	GCGB2reD8eYB60OMyUDjJjJLiSbnAwM9ryTe0NjMyMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS
	1OzU1ILUovii0pzU4kOMTBycUg2Mom4NRtvDpJgyQibtSxR4w+4txjSPYRcj/1zXvvXZ1iGH
	PI69DKpUcji9f9cGvmQdt/mXv5S/WHRPcOfs/KgJy87f5v8he/dKCffbudYLFlf9mF5gHB1x
	7Zns6z3rHhrtfOGrxb/ZrYg1cuWqK3F2R/pfWdakCx+cGVW398Ejj9ibR48rT626rcRSnJFo
	qMVcVJwIAKoJ6eVqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jQd3lDg6BBqe7tCyuf3nOanG26Q27
	xeVdc9gsbjeuYHNg8ejbsorR4/MmuQCmqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwND
	XUNLC3MlhbzE3FRbJRefAF23zBygTUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqM
	DNBAwjrGjPlnuhgLunQrTk36w97AOFG1i5GTQ0LAROLZ6X52CFtM4sK99WxdjFwcQgLTGSXe
	b1nGCOH8Z5RYcu05C0gVm4CWxP4XN9hAbBEBBYnNvc9YQWxmAT+JN5u/AjVwcAgLFEg0twSC
	hFkEVCXW7rkAVsIr4Cxxa+ZvRohlchIf9jxiBynnFHCROHChHCQsBFSy/OYvlgmMvAsYGVYx
	iqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBMfBM+kdjKsaLA4xCnAwKvHwSqTZBwqxJpYVV+Ye
	YpTgYFYS4f1m4xAoxJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnAGM0riTc0NjEzsjQyMzYx
	NzYmTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsYlc0s0/ZJ5Fjx40iMsPqcmzk21LWr7
	z79zEyx+v85XYMxvmJFsMsX1YrSS17uwvsZLl6ZE7ElpnbozPoHFb858h20/ha7KLv6a7HQ2
	o1RbKC2vf8WKyy8l/ybkXVHNc3svccQiyu2Zz6ILXIKybd914ydq/0jqk2qpTXgWu0X6umO1
	70y3vUosxRmJhlrMRcWJAHIrkHzHAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set default value of MUIC register to bring up MUIC device.

If user don't set some initial value for MUIC device through platform data,
extcon-max77693 driver use 'default_init_data' to bring up base operation
of MAX77693 MUIC device.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max77693.c     | 93 ++++++++++++++++++++++++++----------
 include/linux/mfd/max77693-private.h | 23 +++++++++
 2 files changed, 91 insertions(+), 25 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index fea1062..8f3c947 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -32,6 +32,38 @@
 #define	DEV_NAME			"max77693-muic"
 #define	DELAY_MS_DEFAULT		20000		/* unit: millisecond */
 
+/*
+ * Default value of MAX77693 register to bring up MUIC device.
+ * If user don't set some initial value for MUIC device through platform data,
+ * extcon-max77693 driver use 'default_init_data' to bring up base operation
+ * of MAX77693 MUIC device.
+ */
+struct max77693_reg_data default_init_data[] = {
+	{
+		/* STATUS2 - [3]ChgDetRun */
+		.addr = MAX77693_MUIC_REG_STATUS2,
+		.data = STATUS2_CHGDETRUN_MASK,
+	}, {
+		/* INTMASK1 - Unmask [3]ADC1KM,[0]ADCM */
+		.addr = MAX77693_MUIC_REG_INTMASK1,
+		.data = INTMASK1_ADC1K_MASK
+			| INTMASK1_ADC_MASK,
+	}, {
+		/* INTMASK2 - Unmask [0]ChgTypM */
+		.addr = MAX77693_MUIC_REG_INTMASK2,
+		.data = INTMASK2_CHGTYP_MASK,
+	}, {
+		/* INTMASK3 - Mask all of interrupts */
+		.addr = MAX77693_MUIC_REG_INTMASK3,
+		.data = 0x0,
+	}, {
+		/* CDETCTRL2 */
+		.addr = MAX77693_MUIC_REG_CDETCTRL2,
+		.data = CDETCTRL2_VIDRMEN_MASK
+			| CDETCTRL2_DXOVPEN_MASK,
+	},
+};
+
 enum max77693_muic_adc_debounce_time {
 	ADC_DEBOUNCE_TIME_5MS = 0,
 	ADC_DEBOUNCE_TIME_10MS,
@@ -1046,6 +1078,8 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	struct max77693_dev *max77693 = dev_get_drvdata(pdev->dev.parent);
 	struct max77693_platform_data *pdata = dev_get_platdata(max77693->dev);
 	struct max77693_muic_info *info;
+	struct max77693_reg_data *init_data;
+	int num_init_data;
 	int delay_jiffies;
 	int ret;
 	int i;
@@ -1144,35 +1178,44 @@ static int max77693_muic_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
+
+	/* Initialize MUIC register by using platform data or default data */
 	if (pdata->muic_data) {
-		struct max77693_muic_platform_data *muic_pdata = pdata->muic_data;
+		init_data = pdata->muic_data->init_data;
+		num_init_data = pdata->muic_data->num_init_data;
+	} else {
+		init_data = default_init_data;
+		num_init_data = ARRAY_SIZE(default_init_data);
+	}
+
+	for (i = 0 ; i < num_init_data ; i++) {
+		enum max77693_irq_source irq_src
+				= MAX77693_IRQ_GROUP_NR;
 
-		/* Initialize MUIC register by using platform data */
-		for (i = 0 ; i < muic_pdata->num_init_data ; i++) {
-			enum max77693_irq_source irq_src
-					= MAX77693_IRQ_GROUP_NR;
-
-			max77693_write_reg(info->max77693->regmap_muic,
-					muic_pdata->init_data[i].addr,
-					muic_pdata->init_data[i].data);
-
-			switch (muic_pdata->init_data[i].addr) {
-			case MAX77693_MUIC_REG_INTMASK1:
-				irq_src = MUIC_INT1;
-				break;
-			case MAX77693_MUIC_REG_INTMASK2:
-				irq_src = MUIC_INT2;
-				break;
-			case MAX77693_MUIC_REG_INTMASK3:
-				irq_src = MUIC_INT3;
-				break;
-			}
-
-			if (irq_src < MAX77693_IRQ_GROUP_NR)
-				info->max77693->irq_masks_cur[irq_src]
-					= muic_pdata->init_data[i].data;
+		max77693_write_reg(info->max77693->regmap_muic,
+				init_data[i].addr,
+				init_data[i].data);
+
+		switch (init_data[i].addr) {
+		case MAX77693_MUIC_REG_INTMASK1:
+			irq_src = MUIC_INT1;
+			break;
+		case MAX77693_MUIC_REG_INTMASK2:
+			irq_src = MUIC_INT2;
+			break;
+		case MAX77693_MUIC_REG_INTMASK3:
+			irq_src = MUIC_INT3;
+			break;
 		}
 
+		if (irq_src < MAX77693_IRQ_GROUP_NR)
+			info->max77693->irq_masks_cur[irq_src]
+				= init_data[i].data;
+	}
+
+	if (pdata->muic_data) {
+		struct max77693_muic_platform_data *muic_pdata = pdata->muic_data;
+
 		/*
 		 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
 		 * h/w path of COMP2/COMN1 on CONTROL1 register.
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 5b18ecd..1aa4f13 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -106,6 +106,29 @@ enum max77693_muic_reg {
 	MAX77693_MUIC_REG_END,
 };
 
+/* MAX77693 INTMASK1~2 Register */
+#define INTMASK1_ADC1K_SHIFT		3
+#define INTMASK1_ADCERR_SHIFT		2
+#define INTMASK1_ADCLOW_SHIFT		1
+#define INTMASK1_ADC_SHIFT		0
+#define INTMASK1_ADC1K_MASK		(1 << INTMASK1_ADC1K_SHIFT)
+#define INTMASK1_ADCERR_MASK		(1 << INTMASK1_ADCERR_SHIFT)
+#define INTMASK1_ADCLOW_MASK		(1 << INTMASK1_ADCLOW_SHIFT)
+#define INTMASK1_ADC_MASK		(1 << INTMASK1_ADC_SHIFT)
+
+#define INTMASK2_VIDRM_SHIFT		5
+#define INTMASK2_VBVOLT_SHIFT		4
+#define INTMASK2_DXOVP_SHIFT		3
+#define INTMASK2_DCDTMR_SHIFT		2
+#define INTMASK2_CHGDETRUN_SHIFT	1
+#define INTMASK2_CHGTYP_SHIFT		0
+#define INTMASK2_VIDRM_MASK		(1 << INTMASK2_VIDRM_SHIFT)
+#define INTMASK2_VBVOLT_MASK		(1 << INTMASK2_VBVOLT_SHIFT)
+#define INTMASK2_DXOVP_MASK		(1 << INTMASK2_DXOVP_SHIFT)
+#define INTMASK2_DCDTMR_MASK		(1 << INTMASK2_DCDTMR_SHIFT)
+#define INTMASK2_CHGDETRUN_MASK		(1 << INTMASK2_CHGDETRUN_SHIFT)
+#define INTMASK2_CHGTYP_MASK		(1 << INTMASK2_CHGTYP_SHIFT)
+
 /* MAX77693 MUIC - STATUS1~3 Register */
 #define STATUS1_ADC_SHIFT		(0)
 #define STATUS1_ADCLOW_SHIFT		(5)
-- 
1.8.0

