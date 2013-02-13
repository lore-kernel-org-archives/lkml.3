Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925Ab3BMJfe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:35:34 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43619 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932578Ab3BMJf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:35:28 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-56-511b5e5fdace
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 9/9] extcon: max8997: Use workqueue to check cable state after
 completing boot of platform
Date: Wed, 13 Feb 2013 18:35:26 +0900
Message-id: <1360748126-22079-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zTd34OOlAg8WPlSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldGw+PvzAW75Ct6j3cwNTBOlOpi5OSQEDCRePLrBDuELSZx4d56
	ti5GLg4hgWWMEs8b/rPBFL393MYEkZjOKPHoXQMzhLOASWLynkYWkCo2AS2J/S9ugHWICJhK
	nHp6HWwss0CtxOnLd5lBbGGBHIm5z34xgdgsAqoSPWeugtXwCrhKPJw9BeoMOYkPex6xgyyQ
	ENjBJvH80DdGiAYBiW+TDwEt4wBKyEpsOsAMUS8pcXDFDZYJjIILGBlWMYqmFiQXFCel5xrq
	FSfmFpfmpesl5+duYoQEldQOxpUNFocYBTgYlXh4HUKkAoVYE8uKK3MPMUpwMCuJ8Dr6SwcK
	8aYkVlalFuXHF5XmpBYfYkwGWj6RWUo0OR8Y8Hkl8YbGBsaGhpaGZqaWpgakCSuJ8zKeehIg
	JJCeWJKanZpakFoEs4WJg1OqgTHkZOseY7G3qa7b90lN/FiyUU1sMm8ey+3za55+n/Oz5t/x
	s0fX9Vckv3z3qmW/5RZF3uxWoYk/ZZf7nr2zTuOL1mmLa6bhvtfft+0/XDzR+bR9wGPRve9s
	nujPuKhuWLiu+MTl2u17Y65lTsy4vvtDUb/GetXCpy49v3aUzjt/J7R4b/73zH9ZSizFGYmG
	WsxFxYkARpQ+z24CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xoG58nHSgwc1/0haXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo+Hxd+aCXfIVvcc7mBoY
	J0p1MXJySAiYSLz93MYEYYtJXLi3nq2LkYtDSGA6o8Sjdw3MEM4CJonJexpZQKrYBLQk9r+4
	wQZiiwiYSpx6ep0dxGYWqJU4ffkuM4gtLJAjMffZL7CpLAKqEj1nroLV8Aq4SjycPYUdYpuc
	xIc9j9gnMHIvYGRYxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcss+kdjCubLA4xCjAwajE
	w+sQIhUoxJpYVlyZe4hRgoNZSYTX0V86UIg3JbGyKrUoP76oNCe1+BBjMtD2icxSosn5wHjK
	K4k3NDYxM7I0MjM2MTc2Jk1YSZyX8dSTACGB9MSS1OzU1ILUIpgtTBycUg2M5223Nh4+7b3Z
	TurxLS1x/xdnVofOCDHOaelWaOO4uI2HpfXerR9T6yYrXexLnxZUY3bvZ/crx59cxUsFkuaV
	FB/9rymXeLCxo21Gj3Kju8R3Aed/q1TtWKU+XqtZ+rFb5PAc22WK69/+f3rn5JfZ5lbn76xj
	2bT56fOsd/6/Em+nejrE/dSdrcRSnJFoqMVcVJwIACVzoZ2dAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch use delayed workqueue to check cable state after a certain
time. If extcon-max8997 driver check cable state during booting of
platform, this couldn't send the correct notification of cable state
to extcon consumer. Alwasys, this driver should check cable state
after the completion of platform initialization

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max8997.c | 45 ++++++++++++++++++++++++++++++++---------
 include/linux/mfd/max8997.h     |  3 +++
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 349f65f..e636d95 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -29,6 +29,7 @@
 #include <linux/irqdomain.h>
 
 #define	DEV_NAME			"max8997-muic"
+#define	DELAY_MS_DEFAULT		20000		/* unit: millisecond */
 
 enum max8997_muic_adc_debounce_time {
 	ADC_DEBOUNCE_TIME_0_5MS = 0,	/* 0.5ms */
@@ -129,6 +130,14 @@ struct max8997_muic_info {
 	enum max8997_muic_charger_type pre_charger_type;
 
 	/*
+	 * Use delayed workqueue to detect cable state and then
+	 * notify cable state to notifiee/platform through uevent.
+	 * After completing the booting of platform, the extcon provider
+	 * driver should notify cable state to upper layer.
+	 */
+	struct delayed_work wq_detcable;
+
+	/*
 	 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
 	 * h/w path of COMP2/COMN1 on CONTROL1 register.
 	 */
@@ -629,11 +638,23 @@ static int max8997_muic_detect_dev(struct max8997_muic_info *info)
 	return 0;
 }
 
+static void max8997_muic_detect_cable_wq(struct work_struct *work)
+{
+	struct max8997_muic_info *info = container_of(to_delayed_work(work),
+				struct max8997_muic_info, wq_detcable);
+	int ret;
+
+	ret = max8997_muic_detect_dev(info);
+	if (ret < 0)
+		pr_err("failed to detect cable type\n");
+}
+
 static int max8997_muic_probe(struct platform_device *pdev)
 {
 	struct max8997_dev *max8997 = dev_get_drvdata(pdev->dev.parent);
 	struct max8997_platform_data *pdata = dev_get_platdata(max8997->dev);
 	struct max8997_muic_info *info;
+	int delay_jiffies;
 	int ret, i;
 
 	info = devm_kzalloc(&pdev->dev, sizeof(struct max8997_muic_info),
@@ -721,17 +742,23 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	/* Set ADC debounce time */
 	max8997_muic_set_debounce_time(info, ADC_DEBOUNCE_TIME_25MS);
 
-	/* Initial device detection */
-	ret = max8997_muic_detect_dev(info);
-	if (ret < 0) {
-		dev_err(&pdev->dev, "failed to detect cable type\n");
-		goto err_extcon;
-	}
+	/*
+	 * Detect accessory after completing the initialization of platform
+	 *
+	 * - Use delayed workqueue to detect cable state and then
+	 * notify cable state to notifiee/platform through uevent.
+	 * After completing the booting of platform, the extcon provider
+	 * driver should notify cable state to upper layer.
+	 */
+	INIT_DELAYED_WORK(&info->wq_detcable, max8997_muic_detect_cable_wq);
+	if (pdata->muic_pdata->detcable_delay_ms)
+		delay_jiffies = msecs_to_jiffies(pdata->muic_pdata->detcable_delay_ms);
+	else
+		delay_jiffies = msecs_to_jiffies(DELAY_MS_DEFAULT);
+	schedule_delayed_work(&info->wq_detcable, delay_jiffies);
 
-	return ret;
+	return 0;
 
-err_extcon:
-	extcon_dev_unregister(info->edev);
 err_irq:
 	while (--i >= 0)
 		free_irq(muic_irqs[i].virq, info);
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index 2d2d67b..cf81557 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -93,6 +93,9 @@ struct max8997_muic_platform_data {
 	struct max8997_muic_reg_data *init_data;
 	int num_init_data;
 
+	/* Check cable state after certain delay */
+	int detcable_delay_ms;
+
 	/*
 	 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
 	 * h/w path of COMP2/COMN1 on CONTROL1 register.
-- 
1.8.0

