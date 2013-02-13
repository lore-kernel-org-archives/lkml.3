Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932629Ab3BMJgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:36:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43619 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932427Ab3BMJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:35:27 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-49-511b5e5d0366
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 8/9] extcon: max8997: Set default UART/USB path on probe
Date: Wed, 13 Feb 2013 18:35:24 +0900
Message-id: <1360748124-22045-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t8zTd3YOOlAg1dfpC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGoh272As2SFZ8XvaKvYHxm0gXIyeHhICJxLfVz5ghbDGJC/fW
	s3UxcnEICSxjlFg1aQkLTNHJPdOYIRLTGSWWf5zHDuEsYJJ4+mMtG0gVm4CWxP4XN8BsEQFT
	iVNPr7OD2MwCtRKnL98FWyEs4CHR+vwHmM0ioCrx7Mt7RhCbV8BV4uzBY6wQ2+QkPux5BLZA
	QmAHm0TjhglMEA0CEt8mHwI6iQMoISux6QDU2ZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6rqFe
	cWJucWleul5yfu4mRkhQSe1gXNlgcYhRgINRiYfXIUQqUIg1say4MvcQowQHs5IIr6O/dKAQ
	b0piZVVqUX58UWlOavEhxmSg5ROZpUST84EBn1cSb2hsYGxoaGloZmppakCasJI4L+OpJwFC
	AumJJanZqakFqUUwW5g4OKUaGGU9BLSPbehZsiGxX+NV1HxeXek1ndfjrCS27/2mziYUOO/I
	WhGtJycLr/D8s0xo0Qx77PGEoy70O4f/msURDIdOXrkpXXh01bKnjPn3vP+E8j/78NFfV3w2
	z3LpacmqOdsVujNfrD4a9i6aw2Tahtvnpgccl3UrFn/gvjA+7dN1K9tpSR3xXUosxRmJhlrM
	RcWJACKBkNhuAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xoG5snHSgwdZ/whaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY9GOXewFGyQrPi97xd7A
	+E2ki5GTQ0LAROLknmnMELaYxIV769m6GLk4hASmM0os/ziPHcJZwCTx9MdaNpAqNgEtif0v
	boDZIgKmEqeeXmcHsZkFaiVOX74LNklYwEOi9fkPMJtFQFXi2Zf3jCA2r4CrxNmDx1ghtslJ
	fNjziH0CI/cCRoZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEh+0xqB+PKBotDjAIcjEo8
	vA4hUoFCrIllxZW5hxglOJiVRHgd/aUDhXhTEiurUovy44tKc1KLDzEmA22fyCwlmpwPjKe8
	knhDYxMzI0sjM2MTc2Nj0oSVxHkZTz0JEBJITyxJzU5NLUgtgtnCxMEp1cCYbGHX2rj+e6pF
	/lPPr53ZLoY/g3/valSKeak2k4NJ6e2RWrfQroM2DId1cna1ternBdw/4nYq5nRaxH4W35fX
	bk1Wapi4sWy+6+XjoqtFl9xoK4ze/jQ7bKf8z1aZ/b9PnYm/yCK5NdQo5cnTL2tuJn21WHvz
	jHvQ5aN2e7gKSkRSvK+IGH9RYinOSDTUYi4qTgQA1vz5zp0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set default H/W line path according to platfomr data.
The MAX8997 MUIC device can possibly set UART/USB or UART_AUX
/USB_AUX to internal H/W line path of MUIC device. Namely, only
one H/W line is used for two operation.

For example,
if H/W line path of MAX8997 device set UART/USB, micro usb cable
is connected to AP(Application Processor) and if H/W line path
set UART_AUX/USB_AUX, micro usb cable is connected to CP(Coprocessor).

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max8997.c | 28 ++++++++++++++++++++++++++--
 include/linux/mfd/max8997.h     |  7 +++++++
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 35338a0..349f65f 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -127,6 +127,13 @@ struct max8997_muic_info {
 
 	struct max8997_muic_platform_data *muic_pdata;
 	enum max8997_muic_charger_type pre_charger_type;
+
+	/*
+	 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
+	 * h/w path of COMP2/COMN1 on CONTROL1 register.
+	 */
+	int path_usb;
+	int path_uart;
 };
 
 enum {
@@ -322,7 +329,7 @@ static int max8997_muic_handle_usb(struct max8997_muic_info *info,
 	int ret = 0;
 
 	if (usb_type == MAX8997_USB_HOST) {
-		ret = max8997_muic_set_path(info, CONTROL1_SW_USB, attached);
+		ret = max8997_muic_set_path(info, info->path_usb, attached);
 		if (ret < 0) {
 			dev_err(info->dev, "failed to update muic register\n");
 			return ret;
@@ -378,7 +385,7 @@ static int max8997_muic_handle_jig_uart(struct max8997_muic_info *info,
 	int ret = 0;
 
 	/* switch to UART */
-	ret = max8997_muic_set_path(info, CONTROL1_SW_UART, attached);
+	ret = max8997_muic_set_path(info, info->path_uart, attached);
 	if (ret) {
 		dev_err(info->dev, "failed to update muic register\n");
 		return -EINVAL;
@@ -694,6 +701,23 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		}
 	}
 
+	/*
+	 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
+	 * h/w path of COMP2/COMN1 on CONTROL1 register.
+	 */
+	if (pdata->muic_pdata->path_uart)
+		info->path_uart = pdata->muic_pdata->path_uart;
+	else
+		info->path_uart = CONTROL1_SW_UART;
+
+	if (pdata->muic_pdata->path_usb)
+		info->path_usb = pdata->muic_pdata->path_usb;
+	else
+		info->path_usb = CONTROL1_SW_USB;
+
+	/* Set initial path for UART */
+	 max8997_muic_set_path(info, info->path_uart, true);
+
 	/* Set ADC debounce time */
 	max8997_muic_set_debounce_time(info, ADC_DEBOUNCE_TIME_25MS);
 
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index 65f8d6a..2d2d67b 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -92,6 +92,13 @@ struct max8997_muic_reg_data {
 struct max8997_muic_platform_data {
 	struct max8997_muic_reg_data *init_data;
 	int num_init_data;
+
+	/*
+	 * Default usb/uart path whether UART/USB or AUX_UART/AUX_USB
+	 * h/w path of COMP2/COMN1 on CONTROL1 register.
+	 */
+	int path_usb;
+	int path_uart;
 };
 
 enum max8997_haptic_motor_type {
-- 
1.8.0

