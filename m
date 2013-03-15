Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3CONC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 09:02:56 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49865 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab3CONCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 09:02:53 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [PATCH 04/50] staging: omap-thermal: update documentation of omap-bandgap.h
Date: Fri, 15 Mar 2013 08:59:52 -0400
Message-ID: <1363352438-15935-5-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
References: <1363352438-15935-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the existing data structures for omap bandgap,
inside omap-bandgap.h.

TODO: remove unused fields.

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 drivers/staging/omap-thermal/omap-bandgap.h |  230 ++++++++++++++++++++++-----
 1 files changed, 189 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/omap-thermal/omap-bandgap.h b/drivers/staging/omap-thermal/omap-bandgap.h
index 7d5ac3f..28d9104 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.h
+++ b/drivers/staging/omap-thermal/omap-bandgap.h
@@ -28,24 +28,101 @@
 #include <linux/err.h>
 
 /**
- * The register offsets and bit fields might change across
- * OMAP versions hence populating them in this structure.
+ * DOC: bandgap driver data structure
+ * ==================================
+ *   +---------------------+   +-----------------+
+ *   | struct omap_bandgap |-->| struct device * |
+ *   +----------+----------+   +-----------------+
+ *              |
+ *              |
+ *              V
+ *   +--------------------------+
+ *   | struct omap_bandgap_data |
+ *   +--------------------------+
+ *              |
+ *              |
+ *              * (Array of)
+ * +------------+------------------------------------------------------+
+ * | +----------+--------------+   +-------------------------+         |
+ * | | struct omap_temp_sensor |-->| struct temp_sensor_data |         |
+ * | +-------------------------+   +------------+------------+         |
+ * |            |                                                      |
+ * |            +--------------------------+                           |
+ * |            V                          V                           |
+ * | +----------+- --------------+  +----+-------------------------+   |
+ * | | struct temp_sensor_regval |  | struct temp_sensor_registers |   |
+ * | +---------------------------+  +------------------------------+   |
+ * |                                                                   |
+ * +-------------------------------------------------------------------+
+ *
+ * Above is a simple diagram describing how the data structure below
+ * are organized. For each bandgap device there should be a omap_bandgap_data
+ * containing the device instance configuration, as well as, an array of
+ * sensors, representing every sensor instance present in this bandgap.
+ */
+
+/**
+ * struct temp_sensor_registers - descriptor to access registers and bitfields
+ * @temp_sensor_ctrl: TEMP_SENSOR_CTRL register offset
+ * @bgap_tempsoff_mask: mask to temp_sensor_ctrl.tempsoff
+ * @bgap_soc_mask: mask to temp_sensor_ctrl.soc
+ * @bgap_eocz_mask: mask to temp_sensor_ctrl.eocz
+ * @bgap_dtemp_mask: mask to temp_sensor_ctrl.dtemp
+ * @bgap_mask_ctrl: BANDGAP_MASK_CTRL register offset
+ * @mask_hot_mask: mask to bandgap_mask_ctrl.mask_hot
+ * @mask_cold_mask: mask to bandgap_mask_ctrl.mask_cold
+ * @mask_sidlemode_mask: mask to bandgap_mask_ctrl.mask_sidlemode
+ * @mask_freeze_mask: mask to bandgap_mask_ctrl.mask_free
+ * @mask_clear_mask: mask to bandgap_mask_ctrl.mask_clear
+ * @mask_clear_accum_mask: mask to bandgap_mask_ctrl.mask_clear_accum
+ * @bgap_mode_ctrl: BANDGAP_MODE_CTRL register offset
+ * @mode_ctrl_mask: mask to bandgap_mode_ctrl.mode_ctrl
+ * @bgap_counter: BANDGAP_COUNTER register offset
+ * @counter_mask: mask to bandgap_counter.counter
+ * @bgap_threshold: BANDGAP_THRESHOLD register offset (TALERT thresholds)
+ * @threshold_thot_mask: mask to bandgap_threhold.thot
+ * @threshold_tcold_mask: mask to bandgap_threhold.tcold
+ * @tshut_threshold: TSHUT_THRESHOLD register offset (TSHUT thresholds)
+ * @tshut_efuse_mask: mask to tshut_threshold.tshut_efuse
+ * @tshut_efuse_shift: shift to tshut_threshold.tshut_efuse
+ * @tshut_hot_mask: mask to tshut_threhold.thot
+ * @tshut_cold_mask: mask to tshut_threhold.thot
+ * @bgap_status: BANDGAP_STATUS register offset
+ * @status_clean_stop_mask: mask to bandgap_status.clean_stop
+ * @status_bgap_alert_mask: mask to bandgap_status.bandgap_alert
+ * @status_hot_mask: mask to bandgap_status.hot
+ * @status_cold_mask: mask to bandgap_status.cold
+ * @bgap_cumul_dtemp: BANDGAP_CUMUL_DTEMP register offset
+ * @ctrl_dtemp_0: CTRL_DTEMP0 register offset
+ * @ctrl_dtemp_1: CTRL_DTEMP1 register offset
+ * @ctrl_dtemp_2: CTRL_DTEMP2 register offset
+ * @ctrl_dtemp_3: CTRL_DTEMP3 register offset
+ * @ctrl_dtemp_4: CTRL_DTEMP4 register offset
+ * @bgap_efuse: BANDGAP_EFUSE register offset
+ *
+ * The register offsets and bitfields might change across
+ * OMAP and variants versions. Hence this struct serves as a
+ * descriptor map on how to access the registers and the bitfields.
+ *
+ * This descriptor contains registers of all versions of bandgap chips.
+ * Not all versions will use all registers, depending on the available
+ * features. Please read TRMs for descriptive explanation on each bitfield.
  */
 
 struct temp_sensor_registers {
 	u32	temp_sensor_ctrl;
 	u32	bgap_tempsoff_mask;
 	u32	bgap_soc_mask;
-	u32	bgap_eocz_mask;
+	u32	bgap_eocz_mask; /* not used: but needs revisit */
 	u32	bgap_dtemp_mask;
 
 	u32	bgap_mask_ctrl;
 	u32	mask_hot_mask;
 	u32	mask_cold_mask;
-	u32	mask_sidlemode_mask;
+	u32	mask_sidlemode_mask; /* not used: but may be needed for pm */
 	u32	mask_freeze_mask;
-	u32	mask_clear_mask;
-	u32	mask_clear_accum_mask;
+	u32	mask_clear_mask; /* not used: but needed for trending */
+	u32	mask_clear_accum_mask; /* not used: but needed for trending */
 
 	u32	bgap_mode_ctrl;
 	u32	mode_ctrl_mask;
@@ -58,28 +135,45 @@ struct temp_sensor_registers {
 	u32	threshold_tcold_mask;
 
 	u32	tshut_threshold;
-	u32	tshut_efuse_mask;
-	u32	tshut_efuse_shift;
+	u32	tshut_efuse_mask; /* not used */
+	u32	tshut_efuse_shift; /* not used */
 	u32	tshut_hot_mask;
 	u32	tshut_cold_mask;
 
 	u32	bgap_status;
-	u32	status_clean_stop_mask;
-	u32	status_bgap_alert_mask;
+	u32	status_clean_stop_mask; /* not used: but needed for trending */
+	u32	status_bgap_alert_mask; /* not used */
 	u32	status_hot_mask;
 	u32	status_cold_mask;
 
-	u32	bgap_cumul_dtemp;
-	u32	ctrl_dtemp_0;
-	u32	ctrl_dtemp_1;
-	u32	ctrl_dtemp_2;
-	u32	ctrl_dtemp_3;
-	u32	ctrl_dtemp_4;
+	u32	bgap_cumul_dtemp; /* not used: but needed for trending */
+	u32	ctrl_dtemp_0; /* not used: but needed for trending */
+	u32	ctrl_dtemp_1; /* not used: but needed for trending */
+	u32	ctrl_dtemp_2; /* not used: but needed for trending */
+	u32	ctrl_dtemp_3; /* not used: but needed for trending */
+	u32	ctrl_dtemp_4; /* not used: but needed for trending */
 	u32	bgap_efuse;
 };
 
 /**
- * The thresholds and limits for temperature sensors.
+ * struct temp_sensor_data - The thresholds and limits for temperature sensors.
+ * @tshut_hot: temperature to trigger a thermal reset (initial value)
+ * @tshut_cold: temp to get the plat out of reset due to thermal (init val)
+ * @t_hot: temperature to trigger a thermal alert (high initial value)
+ * @t_cold: temperature to trigger a thermal alert (low initial value)
+ * @min_freq: sensor minimum clock rate
+ * @max_freq: sensor maximum clock rate
+ * @max_temp: sensor maximum temperature
+ * @min_temp: sensor minimum temperature
+ * @hyst_val: temperature hysteresis considered while converting ADC values
+ * @adc_start_val: ADC conversion table starting value
+ * @adc_end_val: ADC conversion table ending value
+ * @update_int1: update interval
+ * @update_int2: update interval
+ *
+ * This data structure will hold the required thresholds and temperature limits
+ * for a specific temperature sensor, like shutdown temperature, alert
+ * temperature, clock / rate used, ADC conversion limits and update intervals
  */
 struct temp_sensor_data {
 	u32	tshut_hot;
@@ -93,23 +187,27 @@ struct temp_sensor_data {
 	int     hyst_val;
 	u32     adc_start_val;
 	u32     adc_end_val;
-	u32     update_int1;
-	u32     update_int2;
+	u32     update_int1; /* not used */
+	u32     update_int2; /* not used */
 };
 
 struct omap_bandgap_data;
 
 /**
  * struct omap_bandgap - bandgap device structure
- * @dev: device pointer
- * @conf: platform data with sensor data
+ * @dev: struct device pointer
+ * @base: io memory base address
+ * @conf: struct with bandgap configuration set (# sensors, conv_table, etc)
  * @fclock: pointer to functional clock of temperature sensor
- * @div_clk: pointer to parent clock of temperature sensor fclk
- * @conv_table: Pointer to adc to temperature conversion table
- * @bg_mutex: Mutex for sysfs, irq and PM
- * @irq: MPU Irq number for thermal alert
+ * @div_clk: pointer to divider clock of temperature sensor fclk
+ * @bg_mutex: mutex for omap_bandgap structure
+ * @irq: MPU IRQ number for thermal alert
  * @tshut_gpio: GPIO where Tshut signal is routed
  * @clk_rate: Holds current clock rate
+ *
+ * The bandgap device structure representing the bandgap device instance.
+ * It holds most of the dynamic stuff. Configurations and sensor specific
+ * entries are inside the @conf structure.
  */
 struct omap_bandgap {
 	struct device			*dev;
@@ -117,7 +215,7 @@ struct omap_bandgap {
 	struct omap_bandgap_data	*conf;
 	struct clk			*fclock;
 	struct clk			*div_clk;
-	struct mutex			bg_mutex; /* Mutex for irq and PM */
+	struct mutex			bg_mutex; /* shields this struct */
 	int				irq;
 	int				tshut_gpio;
 	u32				clk_rate;
@@ -130,6 +228,9 @@ struct omap_bandgap {
  * @bg_counter: bandgap counter value
  * @bg_threshold: bandgap threshold register value
  * @tshut_threshold: bandgap tshut register value
+ *
+ * Data structure to save and restore bandgap register set context. Only
+ * required registers are shadowed, when needed.
  */
 struct temp_sensor_regval {
 	u32			bg_mode_ctrl;
@@ -140,21 +241,26 @@ struct temp_sensor_regval {
 };
 
 /**
- * struct omap_temp_sensor - bandgap temperature sensor platform data
+ * struct omap_temp_sensor - bandgap temperature sensor configuration data
  * @ts_data: pointer to struct with thresholds, limits of temperature sensor
  * @registers: pointer to the list of register offsets and bitfields
  * @regval: temperature sensor register values
  * @domain: the name of the domain where the sensor is located
- * @cooling_data: description on how the zone should be cooled off.
- * @slope: sensor gradient slope info for hotspot extrapolation
- * @const: sensor gradient const info for hotspot extrapolation
- * @slope_pcb: sensor gradient slope info for hotspot extrapolation
+ * @slope: sensor gradient slope info for hotspot extrapolation equation
+ * @const: sensor gradient const info for hotspot extrapolation equation
+ * @slope_pcb: sensor gradient slope info for hotspot extrapolation equation
  *             with no external influence
- * @const_pcb: sensor gradient const info for hotspot extrapolation
+ * @constant_pcb: sensor gradient const info for hotspot extrapolation equation
  *             with no external influence
  * @data: private data
  * @register_cooling: function to describe how this sensor is going to be cooled
  * @unregister_cooling: function to release cooling data
+ *
+ * Data structure to describe a temperature sensor handled by a bandgap device.
+ * It should provide configuration details on this sensor, such as how to
+ * access the registers affecting this sensor, shadow register buffer, how to
+ * assess the gradient from hotspot, how to cooldown the domain when sensor
+ * reports too hot temperature.
  */
 struct omap_temp_sensor {
 	struct temp_sensor_data		*ts_data;
@@ -172,16 +278,38 @@ struct omap_temp_sensor {
 };
 
 /**
- * struct omap_bandgap_data - bandgap platform data structure
- * @features: a bitwise flag set to describe the device features
- * @conv_table: Pointer to adc to temperature conversion table
- * @fclock_name: clock name of the functional clock
- * @div_ck_nme: clock name of the clock divisor
- * @sensor_count: count of temperature sensor device in scm
- * @sensors: array of sensors present in this bandgap instance
- * @expose_sensor: callback to export sensor to thermal API
+ * DOC: omap bandgap feature types
+ *
+ * OMAP_BANDGAP_FEATURE_TSHUT - used when the thermal shutdown signal output
+ *      of a bandgap device instance is routed to the processor. This means
+ *      the system must react and perform the shutdown by itself (handle an
+ *      IRQ, for instance).
+ *
+ * OMAP_BANDGAP_FEATURE_TSHUT_CONFIG - used when the bandgap device has control
+ *      over the thermal shutdown configuration. This means that the thermal
+ *      shutdown thresholds are programmable, for instance.
+ *
+ * OMAP_BANDGAP_FEATURE_TALERT - used when the bandgap device instance outputs
+ *      a signal representing violation of programmable alert thresholds.
+ *
+ * OMAP_BANDGAP_FEATURE_MODE_CONFIG - used when it is possible to choose which
+ *      mode, continuous or one shot, the bandgap device instance will operate.
+ *
+ * OMAP_BANDGAP_FEATURE_COUNTER - used when the bandgap device instance allows
+ *      programming the update interval of its internal state machine.
+ *
+ * OMAP_BANDGAP_FEATURE_POWER_SWITCH - used when the bandgap device allows
+ *      itself to be switched on/off.
+ *
+ * OMAP_BANDGAP_FEATURE_CLK_CTRL - used when the clocks feeding the bandgap
+ *      device are gateable or not.
+ *
+ * OMAP_BANDGAP_FEATURE_FREEZE_BIT - used when the bandgap device features
+ *      a history buffer that its update can be freezed/unfreezed.
+ *
+ * OMAP_BANDGAP_HAS(b, f) - macro to check if a bandgap device is capable of a
+ *      specific feature (above) or not. Return non-zero, if yes.
  */
-struct omap_bandgap_data {
 #define OMAP_BANDGAP_FEATURE_TSHUT		BIT(0)
 #define OMAP_BANDGAP_FEATURE_TSHUT_CONFIG	BIT(1)
 #define OMAP_BANDGAP_FEATURE_TALERT		BIT(2)
@@ -192,6 +320,26 @@ struct omap_bandgap_data {
 #define OMAP_BANDGAP_FEATURE_FREEZE_BIT		BIT(7)
 #define OMAP_BANDGAP_HAS(b, f)			\
 			((b)->conf->features & OMAP_BANDGAP_FEATURE_ ## f)
+
+/**
+ * struct omap_bandgap_data - omap bandgap data configuration structure
+ * @features: a bitwise flag set to describe the device features
+ * @conv_table: Pointer to ADC to temperature conversion table
+ * @fclock_name: clock name of the functional clock
+ * @div_ck_name: clock name of the clock divisor
+ * @sensor_count: count of temperature sensor within this bandgap device
+ * @report_temperature: callback to report thermal alert to thermal API
+ * @expose_sensor: callback to export sensor to thermal API
+ * @remove_sensor: callback to destroy sensor from thermal API
+ * @sensors: array of sensors present in this bandgap instance
+ *
+ * This is a data structure which should hold most of the static configuration
+ * of a bandgap device instance. It should describe which features this instance
+ * is capable of, the clock names to feed this device, the amount of sensors and
+ * their configuration representation, and how to export and unexport them to
+ * a thermal API.
+ */
+struct omap_bandgap_data {
 	unsigned int			features;
 	const int			*conv_table;
 	char				*fclock_name;
-- 
1.7.7.1.488.ge8e1c

