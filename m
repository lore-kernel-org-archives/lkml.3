Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaAFK4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 05:56:38 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:39845 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323AbaAFK4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 05:56:37 -0500
From: Jesper Falk <jesperfalk94@gmail.com>
To: anton@enomsg.org
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
        Jesper Falk <jesperfalk94@gmail.com>
Subject: [PATCH] Power: ab8500: Fixed coding style issues and made array const
Date: Mon,  6 Jan 2014 11:55:51 +0100
Message-Id: <1389005751-1840-1-git-send-email-jesperfalk94@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style.

Made some arrays constant on request.

Signed-off-by: Jesper Falk <jesperfalk94@gmail.com>
---
 drivers/power/Module.symvers   |   0
 drivers/power/ab8500_bmdata.c  | 122 ++++++++++++++++++++---------------------
 drivers/power/ab8500_btemp.c   |   8 +--
 drivers/power/ab8500_charger.c |  10 ++--
 drivers/power/ab8500_fg.c      |  38 ++++++++-----
 5 files changed, 92 insertions(+), 86 deletions(-)
 create mode 100644 drivers/power/Module.symvers

diff --git a/drivers/power/Module.symvers b/drivers/power/Module.symvers
new file mode 100644
index 0000000..e69de29
diff --git a/drivers/power/ab8500_bmdata.c b/drivers/power/ab8500_bmdata.c
index d298645..d591a6d 100644
--- a/drivers/power/ab8500_bmdata.c
+++ b/drivers/power/ab8500_bmdata.c
@@ -430,10 +430,10 @@ static const struct abx500_maxim_parameters ab8500_maxi_params = {
 };
 
 static const struct abx500_maxim_parameters abx540_maxi_params = {
-        .ena_maxi = true,
-        .chg_curr = 3000,
-        .wait_cycles = 10,
-        .charger_curr_step = 200,
+	.ena_maxi = true,
+	.chg_curr = 3000,
+	.wait_cycles = 10,
+	.charger_curr_step = 200,
 };
 
 static const struct abx500_bm_charger_parameters chg = {
@@ -447,40 +447,40 @@ static const struct abx500_bm_charger_parameters chg = {
  * This array maps the raw hex value to charger output current used by the
  * AB8500 values
  */
-static int ab8500_charge_output_curr_map[] = {
-        100,    200,    300,    400,    500,    600,    700,    800,
-        900,    1000,   1100,   1200,   1300,   1400,   1500,   1500,
+static const int ab8500_charge_output_curr_map[] = {
+	100,    200,    300,    400,    500,    600,    700,    800,
+	900,    1000,   1100,   1200,   1300,   1400,   1500,   1500,
 };
 
-static int ab8540_charge_output_curr_map[] = {
-        0,      0,      0,      75,     100,    125,    150,    175,
-        200,    225,    250,    275,    300,    325,    350,    375,
-        400,    425,    450,    475,    500,    525,    550,    575,
-        600,    625,    650,    675,    700,    725,    750,    775,
-        800,    825,    850,    875,    900,    925,    950,    975,
-        1000,   1025,   1050,   1075,   1100,   1125,   1150,   1175,
-        1200,   1225,   1250,   1275,   1300,   1325,   1350,   1375,
-        1400,   1425,   1450,   1500,   1600,   1700,   1900,   2000,
+static const int ab8540_charge_output_curr_map[] = {
+	0,      0,      0,      75,     100,    125,    150,    175,
+	200,    225,    250,    275,    300,    325,    350,    375,
+	400,    425,    450,    475,    500,    525,    550,    575,
+	600,    625,    650,    675,    700,    725,    750,    775,
+	800,    825,    850,    875,    900,    925,    950,    975,
+	1000,   1025,   1050,   1075,   1100,   1125,   1150,   1175,
+	1200,   1225,   1250,   1275,   1300,   1325,   1350,   1375,
+	1400,   1425,   1450,   1500,   1600,   1700,   1900,   2000,
 };
 
 /*
  * This array maps the raw hex value to charger input current used by the
  * AB8500 values
  */
-static int ab8500_charge_input_curr_map[] = {
-        50,     98,     193,    290,    380,    450,    500,    600,
-        700,    800,    900,    1000,   1100,   1300,   1400,   1500,
+static const int ab8500_charge_input_curr_map[] = {
+	50,     98,     193,    290,    380,    450,    500,    600,
+	700,    800,    900,    1000,   1100,   1300,   1400,   1500,
 };
 
-static int ab8540_charge_input_curr_map[] = {
-        25,     50,     75,     100,    125,    150,    175,    200,
-        225,    250,    275,    300,    325,    350,    375,    400,
-        425,    450,    475,    500,    525,    550,    575,    600,
-        625,    650,    675,    700,    725,    750,    775,    800,
-        825,    850,    875,    900,    925,    950,    975,    1000,
-        1025,   1050,   1075,   1100,   1125,   1150,   1175,   1200,
-        1225,   1250,   1275,   1300,   1325,   1350,   1375,   1400,
-        1425,   1450,   1475,   1500,   1500,   1500,   1500,   1500,
+static const int ab8540_charge_input_curr_map[] = {
+	25,     50,     75,     100,    125,    150,    175,    200,
+	225,    250,    275,    300,    325,    350,    375,    400,
+	425,    450,    475,    500,    525,    550,    575,    600,
+	625,    650,    675,    700,    725,    750,    775,    800,
+	825,    850,    875,    900,    925,    950,    975,    1000,
+	1025,   1050,   1075,   1100,   1125,   1150,   1175,   1200,
+	1225,   1250,   1275,   1300,   1325,   1350,   1375,   1400,
+	1425,   1450,   1475,   1500,   1500,   1500,   1500,   1500,
 };
 
 struct abx500_bm_data ab8500_bm_data = {
@@ -513,42 +513,42 @@ struct abx500_bm_data ab8500_bm_data = {
 	.maxi                   = &ab8500_maxi_params,
 	.chg_params             = &chg,
 	.fg_params              = &fg,
-        .chg_input_curr         = ab8500_charge_input_curr_map,
-        .n_chg_in_curr          = ARRAY_SIZE(ab8500_charge_input_curr_map),
+	.chg_input_curr         = ab8500_charge_input_curr_map,
+	.n_chg_in_curr          = ARRAY_SIZE(ab8500_charge_input_curr_map),
 };
 
 struct abx500_bm_data ab8540_bm_data = {
-        .temp_under             = 3,
-        .temp_low               = 8,
-        .temp_high              = 43,
-        .temp_over              = 48,
-        .main_safety_tmr_h      = 4,
-        .temp_interval_chg      = 20,
-        .temp_interval_nochg    = 120,
-        .usb_safety_tmr_h       = 4,
-        .bkup_bat_v             = BUP_VCH_SEL_2P6V,
-        .bkup_bat_i             = BUP_ICH_SEL_150UA,
-        .no_maintenance         = false,
-        .capacity_scaling       = false,
-        .adc_therm              = ABx500_ADC_THERM_BATCTRL,
-        .chg_unknown_bat        = false,
-        .enable_overshoot       = false,
-        .fg_res                 = 100,
-        .cap_levels             = &cap_levels,
-        .bat_type               = bat_type_thermistor,
-        .n_btypes               = ARRAY_SIZE(bat_type_thermistor),
-        .batt_id                = 0,
-        .interval_charging      = 5,
-        .interval_not_charging  = 120,
-        .temp_hysteresis        = 3,
-        .gnd_lift_resistance    = 0,
-        .maxi                   = &abx540_maxi_params,
-        .chg_params             = &chg,
-        .fg_params              = &fg,
-        .chg_output_curr        = ab8540_charge_output_curr_map,
-        .n_chg_out_curr         = ARRAY_SIZE(ab8540_charge_output_curr_map),
-        .chg_input_curr         = ab8540_charge_input_curr_map,
-        .n_chg_in_curr          = ARRAY_SIZE(ab8540_charge_input_curr_map),
+	.temp_under             = 3,
+	.temp_low               = 8,
+	.temp_high              = 43,
+	.temp_over              = 48,
+	.main_safety_tmr_h      = 4,
+	.temp_interval_chg      = 20,
+	.temp_interval_nochg    = 120,
+	.usb_safety_tmr_h       = 4,
+	.bkup_bat_v             = BUP_VCH_SEL_2P6V,
+	.bkup_bat_i             = BUP_ICH_SEL_150UA,
+	.no_maintenance         = false,
+	.capacity_scaling       = false,
+	.adc_therm              = ABx500_ADC_THERM_BATCTRL,
+	.chg_unknown_bat        = false,
+	.enable_overshoot       = false,
+	.fg_res                 = 100,
+	.cap_levels             = &cap_levels,
+	.bat_type               = bat_type_thermistor,
+	.n_btypes               = ARRAY_SIZE(bat_type_thermistor),
+	.batt_id                = 0,
+	.interval_charging      = 5,
+	.interval_not_charging  = 120,
+	.temp_hysteresis        = 3,
+	.gnd_lift_resistance    = 0,
+	.maxi                   = &abx540_maxi_params,
+	.chg_params             = &chg,
+	.fg_params              = &fg,
+	.chg_output_curr        = ab8540_charge_output_curr_map,
+	.n_chg_out_curr         = ARRAY_SIZE(ab8540_charge_output_curr_map),
+	.chg_input_curr         = ab8540_charge_input_curr_map,
+	.n_chg_in_curr          = ARRAY_SIZE(ab8540_charge_input_curr_map),
 };
 
 int ab8500_bm_of_probe(struct device *dev,
diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 7f9a454..6ef7d92 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -84,7 +84,7 @@ struct ab8500_btemp_ranges {
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
  * @fg:			Pointer to the struct fg
- * @bm:           	Platform specific battery management information
+ * @bm:			Platform specific battery management information
  * @btemp_psy:		Structure for BTEMP specific battery properties
  * @events:		Structure for information about events triggered
  * @btemp_ranges:	Battery temperature range structure
@@ -946,9 +946,8 @@ static int ab8500_btemp_get_ext_psy_data(struct device *dev, void *data)
 			switch (ext->type) {
 			case POWER_SUPPLY_TYPE_MAINS:
 				/* AC disconnected */
-				if (!ret.intval && di->events.ac_conn) {
+				if (!ret.intval && di->events.ac_conn)
 					di->events.ac_conn = false;
-				}
 				/* AC connected */
 				else if (ret.intval && !di->events.ac_conn) {
 					di->events.ac_conn = true;
@@ -958,9 +957,8 @@ static int ab8500_btemp_get_ext_psy_data(struct device *dev, void *data)
 				break;
 			case POWER_SUPPLY_TYPE_USB:
 				/* USB disconnected */
-				if (!ret.intval && di->events.usb_conn) {
+				if (!ret.intval && di->events.usb_conn)
 					di->events.usb_conn = false;
-				}
 				/* USB connected */
 				else if (ret.intval && !di->events.usb_conn) {
 					di->events.usb_conn = true;
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 19110aa..481e304 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -236,7 +236,7 @@ struct ab8500_charger_max_usb_in_curr {
  *			Counter for current stepping sessions
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
- * @bm:           	Platform specific battery management information
+ * @bm:			Platform specific battery management information
  * @flags:		Structure for information about events triggered
  * @usb_state:		Structure for usb stack information
  * @max_usb_in_curr:	Max USB charger input current
@@ -385,17 +385,15 @@ static void ab8500_enable_disable_sw_fallback(struct ab8500_charger *di,
 
 	/* write back the changed fallback bit value to register */
 	ret = abx500_set_register_interruptible(di->dev, bank, reg, val);
-	if (ret) {
+	if (ret)
 		dev_err(di->dev, "%d write failed\n", __LINE__);
-	}
 
 disable_otp:
 	if (is_ab8500(di->parent)) {
 		/* disable the set OTP registers again */
 		ret = abx500_set_register_interruptible(di->dev, 0x11, 0x00, 0x0);
-		if (ret) {
+		if (ret)
 			dev_err(di->dev, "%d write failed\n", __LINE__);
-		}
 	}
 }
 
@@ -2397,7 +2395,7 @@ static void ab8500_charger_usb_link_status_work(struct work_struct *work)
 		return;
 	}
 
-	dev_dbg(di->dev,"%s di->vbus_detected = true\n",__func__);
+	dev_dbg(di->dev, "%s di->vbus_detected = true\n", __func__);
 	di->vbus_detected = true;
 	ret = ab8500_charger_read_usb_type(di);
 	if (ret) {
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index 3cb4178..13d6903 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -185,7 +185,7 @@ struct inst_curr_result_list {
  * @avg_cap:		Average capacity filter
  * @parent:		Pointer to the struct ab8500
  * @gpadc:		Pointer to the struct gpadc
- * @bm:           	Platform specific battery management information
+ * @bm:			Platform specific battery management information
  * @fg_psy:		Structure that holds the FG specific battery properties
  * @fg_wq:		Work queue for running the FG algorithm
  * @fg_periodic_work:	Work to run the FG algorithm periodically
@@ -821,7 +821,8 @@ static void ab8500_fg_acc_cur_work(struct work_struct *work)
 	queue_work(di->fg_wq, &di->fg_work);
 
 	dev_dbg(di->dev, "fg_res: %d, fg_samples: %d, gasg: %d, accu_charge: %d \n",
-				di->bm->fg_res, di->fg_samples, val, di->accu_charge);
+				di->bm->fg_res, di->fg_samples, val,
+				di->accu_charge);
 	return;
 exit:
 	dev_err(di->dev,
@@ -1884,9 +1885,9 @@ static void ab8500_fg_low_bat_work(struct work_struct *work)
 			dev_warn(di->dev, "Shut down pending...\n");
 		} else {
 			/*
-			* Else we need to re-schedule this check to be able to detect
-			* if the voltage increases again during charging or
-			* due to decreasing load.
+			* Else we need to re-schedule this check to be able to
+			* detect if the voltage increases again during charging
+			* or due to decreasing load.
 			*/
 			di->low_bat_cnt--;
 			dev_warn(di->dev, "Battery voltage still LOW\n");
@@ -2735,7 +2736,8 @@ static ssize_t ab8505_powercut_restart_write(struct device *dev,
 	}
 
 	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
-						AB8505_RTC_PCUT_RESTART_REG, (u8)reg_value);
+						AB8505_RTC_PCUT_RESTART_REG,
+						(u8)reg_value);
 
 	if (ret < 0)
 		dev_err(dev, "Failed to set AB8505_RTC_PCUT_RESTART_REG\n");
@@ -2757,7 +2759,8 @@ static ssize_t ab8505_powercut_timer_read(struct device *dev,
 	di = to_ab8500_fg_device_info(psy);
 
 	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
-						AB8505_RTC_PCUT_TIME_REG, &reg_value);
+						AB8505_RTC_PCUT_TIME_REG,
+						&reg_value);
 
 	if (ret < 0) {
 		dev_err(dev, "Failed to read AB8505_RTC_PCUT_TIME_REG\n");
@@ -2782,7 +2785,8 @@ static ssize_t ab8505_powercut_restart_counter_read(struct device *dev,
 	di = to_ab8500_fg_device_info(psy);
 
 	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
-						AB8505_RTC_PCUT_RESTART_REG, &reg_value);
+						AB8505_RTC_PCUT_RESTART_REG,
+						&reg_value);
 
 	if (ret < 0) {
 		dev_err(dev, "Failed to read AB8505_RTC_PCUT_RESTART_REG\n");
@@ -2807,7 +2811,8 @@ static ssize_t ab8505_powercut_read(struct device *dev,
 	di = to_ab8500_fg_device_info(psy);
 
 	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
-						AB8505_RTC_PCUT_CTL_STATUS_REG, &reg_value);
+						AB8505_RTC_PCUT_CTL_STATUS_REG,
+						&reg_value);
 
 	if (ret < 0)
 		goto fail;
@@ -2836,7 +2841,8 @@ static ssize_t ab8505_powercut_write(struct device *dev,
 	}
 
 	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
-						AB8505_RTC_PCUT_CTL_STATUS_REG, (u8)reg_value);
+						AB8505_RTC_PCUT_CTL_STATUS_REG,
+						(u8)reg_value);
 
 	if (ret < 0)
 		dev_err(dev, "Failed to set AB8505_RTC_PCUT_CTL_STATUS_REG\n");
@@ -2858,7 +2864,8 @@ static ssize_t ab8505_powercut_flag_read(struct device *dev,
 	di = to_ab8500_fg_device_info(psy);
 
 	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
-						AB8505_RTC_PCUT_CTL_STATUS_REG,  &reg_value);
+						AB8505_RTC_PCUT_CTL_STATUS_REG,
+						&reg_value);
 
 	if (ret < 0) {
 		dev_err(dev, "Failed to read AB8505_RTC_PCUT_CTL_STATUS_REG\n");
@@ -2883,7 +2890,8 @@ static ssize_t ab8505_powercut_debounce_read(struct device *dev,
 	di = to_ab8500_fg_device_info(psy);
 
 	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
-						AB8505_RTC_PCUT_DEBOUNCE_REG,  &reg_value);
+						AB8505_RTC_PCUT_DEBOUNCE_REG,
+						&reg_value);
 
 	if (ret < 0) {
 		dev_err(dev, "Failed to read AB8505_RTC_PCUT_DEBOUNCE_REG\n");
@@ -2914,7 +2922,8 @@ static ssize_t ab8505_powercut_debounce_write(struct device *dev,
 	}
 
 	ret = abx500_set_register_interruptible(di->dev, AB8500_RTC,
-						AB8505_RTC_PCUT_DEBOUNCE_REG, (u8)reg_value);
+						AB8505_RTC_PCUT_DEBOUNCE_REG,
+						(u8)reg_value);
 
 	if (ret < 0)
 		dev_err(dev, "Failed to set AB8505_RTC_PCUT_DEBOUNCE_REG\n");
@@ -2935,7 +2944,8 @@ static ssize_t ab8505_powercut_enable_status_read(struct device *dev,
 	di = to_ab8500_fg_device_info(psy);
 
 	ret = abx500_get_register_interruptible(di->dev, AB8500_RTC,
-						AB8505_RTC_PCUT_CTL_STATUS_REG, &reg_value);
+						AB8505_RTC_PCUT_CTL_STATUS_REG,
+						&reg_value);
 
 	if (ret < 0) {
 		dev_err(dev, "Failed to read AB8505_RTC_PCUT_CTL_STATUS_REG\n");
-- 
1.8.5.2

