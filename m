Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab3AOM5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:57:42 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:52424 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab3AOM5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:57:10 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, sameo@linux.intel.com,
        Philippe Langlais <philippe.langlais@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 26/26] mfd: ab8500-gpadc: Use new ab8500_gpadc_get() with name parameter
Date: Tue, 15 Jan 2013 12:56:06 +0000
Message-Id: <1358254566-12419-27-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
References: <1358254566-12419-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philippe Langlais <philippe.langlais@linaro.org>

The new format of ab8500_gpadc_get() accepts a device name as a
parameter to specify which device to retrieve. This patch
enforces the use of that new format.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
---
 drivers/mfd/ab8500-debugfs.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 4147984..f7e6d11 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -806,7 +806,7 @@ static int ab8500_gpadc_bat_ctrl_print(struct seq_file *s, void *p)
 	int bat_ctrl_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	bat_ctrl_raw = ab8500_gpadc_read_raw(gpadc, BAT_CTRL);
 	bat_ctrl_convert = ab8500_gpadc_ad_to_voltage(gpadc,
 			BAT_CTRL, bat_ctrl_raw);
@@ -834,7 +834,7 @@ static int ab8500_gpadc_btemp_ball_print(struct seq_file *s, void *p)
 	int btemp_ball_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	btemp_ball_raw = ab8500_gpadc_read_raw(gpadc, BTEMP_BALL);
 	btemp_ball_convert = ab8500_gpadc_ad_to_voltage(gpadc, BTEMP_BALL,
 			btemp_ball_raw);
@@ -863,7 +863,7 @@ static int ab8500_gpadc_main_charger_v_print(struct seq_file *s, void *p)
 	int main_charger_v_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	main_charger_v_raw = ab8500_gpadc_read_raw(gpadc, MAIN_CHARGER_V);
 	main_charger_v_convert = ab8500_gpadc_ad_to_voltage(gpadc,
 			MAIN_CHARGER_V, main_charger_v_raw);
@@ -893,7 +893,7 @@ static int ab8500_gpadc_acc_detect1_print(struct seq_file *s, void *p)
 	int acc_detect1_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	acc_detect1_raw = ab8500_gpadc_read_raw(gpadc, ACC_DETECT1);
 	acc_detect1_convert = ab8500_gpadc_ad_to_voltage(gpadc, ACC_DETECT1,
 			acc_detect1_raw);
@@ -923,7 +923,7 @@ static int ab8500_gpadc_acc_detect2_print(struct seq_file *s, void *p)
 	int acc_detect2_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	acc_detect2_raw = ab8500_gpadc_read_raw(gpadc, ACC_DETECT2);
 	acc_detect2_convert = ab8500_gpadc_ad_to_voltage(gpadc,
 	    ACC_DETECT2, acc_detect2_raw);
@@ -953,7 +953,7 @@ static int ab8500_gpadc_aux1_print(struct seq_file *s, void *p)
 	int aux1_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	aux1_raw = ab8500_gpadc_read_raw(gpadc, ADC_AUX1);
 	aux1_convert = ab8500_gpadc_ad_to_voltage(gpadc, ADC_AUX1,
 			aux1_raw);
@@ -981,7 +981,7 @@ static int ab8500_gpadc_aux2_print(struct seq_file *s, void *p)
 	int aux2_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	aux2_raw = ab8500_gpadc_read_raw(gpadc, ADC_AUX2);
 	aux2_convert = ab8500_gpadc_ad_to_voltage(gpadc, ADC_AUX2,
 			aux2_raw);
@@ -1009,7 +1009,7 @@ static int ab8500_gpadc_main_bat_v_print(struct seq_file *s, void *p)
 	int main_bat_v_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	main_bat_v_raw = ab8500_gpadc_read_raw(gpadc, MAIN_BAT_V);
 	main_bat_v_convert = ab8500_gpadc_ad_to_voltage(gpadc, MAIN_BAT_V,
 			main_bat_v_raw);
@@ -1038,7 +1038,7 @@ static int ab8500_gpadc_vbus_v_print(struct seq_file *s, void *p)
 	int vbus_v_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	vbus_v_raw = ab8500_gpadc_read_raw(gpadc, VBUS_V);
 	vbus_v_convert = ab8500_gpadc_ad_to_voltage(gpadc, VBUS_V,
 			vbus_v_raw);
@@ -1066,7 +1066,7 @@ static int ab8500_gpadc_main_charger_c_print(struct seq_file *s, void *p)
 	int main_charger_c_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	main_charger_c_raw = ab8500_gpadc_read_raw(gpadc, MAIN_CHARGER_C);
 	main_charger_c_convert = ab8500_gpadc_ad_to_voltage(gpadc,
 			MAIN_CHARGER_C, main_charger_c_raw);
@@ -1096,7 +1096,7 @@ static int ab8500_gpadc_usb_charger_c_print(struct seq_file *s, void *p)
 	int usb_charger_c_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	usb_charger_c_raw = ab8500_gpadc_read_raw(gpadc, USB_CHARGER_C);
 	usb_charger_c_convert = ab8500_gpadc_ad_to_voltage(gpadc,
 	    USB_CHARGER_C, usb_charger_c_raw);
@@ -1126,7 +1126,7 @@ static int ab8500_gpadc_bk_bat_v_print(struct seq_file *s, void *p)
 	int bk_bat_v_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	bk_bat_v_raw = ab8500_gpadc_read_raw(gpadc, BK_BAT_V);
 	bk_bat_v_convert = ab8500_gpadc_ad_to_voltage(gpadc,
 			BK_BAT_V, bk_bat_v_raw);
@@ -1154,7 +1154,7 @@ static int ab8500_gpadc_die_temp_print(struct seq_file *s, void *p)
 	int die_temp_convert;
 	struct ab8500_gpadc *gpadc;
 
-	gpadc = ab8500_gpadc_get();
+	gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
 	die_temp_raw = ab8500_gpadc_read_raw(gpadc, DIE_TEMP);
 	die_temp_convert = ab8500_gpadc_ad_to_voltage(gpadc, DIE_TEMP,
 			die_temp_raw);
-- 
1.7.9.5

