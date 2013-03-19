Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab3CSO50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:57:26 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55011 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3CSO5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:57:21 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Benoit <b-cousson@ti.com>, Nishanth Menon <nm@ti.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCHv2 05/12] staging: ti-soc-thermal: rename symbols to use better prefix
Date: Tue, 19 Mar 2013 10:54:21 -0400
Message-ID: <1363704868-11843-6-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
References: <1363704868-11843-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this driver has been renamed to cope with the chips it
is supposed to support, this patch also changes the symbol
names to use a proper prefix, so it is not suggestive that
this driver supports only OMAP devices.

Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Benoit <b-cousson@ti.com>
Cc: Nishanth Menon <nm@ti.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>
---
 .../staging/ti-soc-thermal/omap4-thermal-data.c    |   64 ++--
 .../staging/ti-soc-thermal/omap5-thermal-data.c    |   16 +-
 drivers/staging/ti-soc-thermal/ti-bandgap.c        |  452 ++++++++++----------
 drivers/staging/ti-soc-thermal/ti-bandgap.h        |  123 +++---
 drivers/staging/ti-soc-thermal/ti-thermal-common.c |  172 ++++----
 drivers/staging/ti-soc-thermal/ti-thermal.h        |   26 +-
 6 files changed, 421 insertions(+), 432 deletions(-)

diff --git a/drivers/staging/ti-soc-thermal/omap4-thermal-data.c b/drivers/staging/ti-soc-thermal/omap4-thermal-data.c
index 97544f7..49d0324 100644
--- a/drivers/staging/ti-soc-thermal/omap4-thermal-data.c
+++ b/drivers/staging/ti-soc-thermal/omap4-thermal-data.c
@@ -66,17 +66,17 @@ omap4430_adc_to_temp[OMAP4430_ADC_END_VALUE - OMAP4430_ADC_START_VALUE + 1] = {
 };
 
 /* OMAP4430 data */
-const struct omap_bandgap_data omap4430_data = {
-	.features = OMAP_BANDGAP_FEATURE_MODE_CONFIG |
-			OMAP_BANDGAP_FEATURE_CLK_CTRL |
-			OMAP_BANDGAP_FEATURE_POWER_SWITCH,
+const struct ti_bandgap_data omap4430_data = {
+	.features = TI_BANDGAP_FEATURE_MODE_CONFIG |
+			TI_BANDGAP_FEATURE_CLK_CTRL |
+			TI_BANDGAP_FEATURE_POWER_SWITCH,
 	.fclock_name = "bandgap_fclk",
 	.div_ck_name = "bandgap_fclk",
 	.conv_table = omap4430_adc_to_temp,
 	.adc_start_val = OMAP4430_ADC_START_VALUE,
 	.adc_end_val = OMAP4430_ADC_END_VALUE,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
+	.expose_sensor = ti_thermal_expose_sensor,
+	.remove_sensor = ti_thermal_remove_sensor,
 	.sensors = {
 		{
 		.registers = &omap4430_mpu_temp_sensor_registers,
@@ -86,8 +86,8 @@ const struct omap_bandgap_data omap4430_data = {
 		.constant = 20000,
 		.slope_pcb = 0,
 		.constant_pcb = 20000,
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.register_cooling = ti_thermal_register_cpu_cooling,
+		.unregister_cooling = ti_thermal_unregister_cpu_cooling,
 		},
 	},
 	.sensor_count = 1,
@@ -201,21 +201,21 @@ omap4460_adc_to_temp[OMAP4460_ADC_END_VALUE - OMAP4460_ADC_START_VALUE + 1] = {
 };
 
 /* OMAP4460 data */
-const struct omap_bandgap_data omap4460_data = {
-	.features = OMAP_BANDGAP_FEATURE_TSHUT |
-			OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
-			OMAP_BANDGAP_FEATURE_TALERT |
-			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
-			OMAP_BANDGAP_FEATURE_POWER_SWITCH |
-			OMAP_BANDGAP_FEATURE_CLK_CTRL |
-			OMAP_BANDGAP_FEATURE_COUNTER,
+const struct ti_bandgap_data omap4460_data = {
+	.features = TI_BANDGAP_FEATURE_TSHUT |
+			TI_BANDGAP_FEATURE_TSHUT_CONFIG |
+			TI_BANDGAP_FEATURE_TALERT |
+			TI_BANDGAP_FEATURE_MODE_CONFIG |
+			TI_BANDGAP_FEATURE_POWER_SWITCH |
+			TI_BANDGAP_FEATURE_CLK_CTRL |
+			TI_BANDGAP_FEATURE_COUNTER,
 	.fclock_name = "bandgap_ts_fclk",
 	.div_ck_name = "div_ts_ck",
 	.conv_table = omap4460_adc_to_temp,
 	.adc_start_val = OMAP4460_ADC_START_VALUE,
 	.adc_end_val = OMAP4460_ADC_END_VALUE,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
+	.expose_sensor = ti_thermal_expose_sensor,
+	.remove_sensor = ti_thermal_remove_sensor,
 	.sensors = {
 		{
 		.registers = &omap4460_mpu_temp_sensor_registers,
@@ -225,29 +225,29 @@ const struct omap_bandgap_data omap4460_data = {
 		.constant = OMAP_GRADIENT_CONST_4460,
 		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4460,
 		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4460,
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.register_cooling = ti_thermal_register_cpu_cooling,
+		.unregister_cooling = ti_thermal_unregister_cpu_cooling,
 		},
 	},
 	.sensor_count = 1,
 };
 
 /* OMAP4470 data */
-const struct omap_bandgap_data omap4470_data = {
-	.features = OMAP_BANDGAP_FEATURE_TSHUT |
-			OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
-			OMAP_BANDGAP_FEATURE_TALERT |
-			OMAP_BANDGAP_FEATURE_MODE_CONFIG |
-			OMAP_BANDGAP_FEATURE_POWER_SWITCH |
-			OMAP_BANDGAP_FEATURE_CLK_CTRL |
-			OMAP_BANDGAP_FEATURE_COUNTER,
+const struct ti_bandgap_data omap4470_data = {
+	.features = TI_BANDGAP_FEATURE_TSHUT |
+			TI_BANDGAP_FEATURE_TSHUT_CONFIG |
+			TI_BANDGAP_FEATURE_TALERT |
+			TI_BANDGAP_FEATURE_MODE_CONFIG |
+			TI_BANDGAP_FEATURE_POWER_SWITCH |
+			TI_BANDGAP_FEATURE_CLK_CTRL |
+			TI_BANDGAP_FEATURE_COUNTER,
 	.fclock_name = "bandgap_ts_fclk",
 	.div_ck_name = "div_ts_ck",
 	.conv_table = omap4460_adc_to_temp,
 	.adc_start_val = OMAP4460_ADC_START_VALUE,
 	.adc_end_val = OMAP4460_ADC_END_VALUE,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
+	.expose_sensor = ti_thermal_expose_sensor,
+	.remove_sensor = ti_thermal_remove_sensor,
 	.sensors = {
 		{
 		.registers = &omap4460_mpu_temp_sensor_registers,
@@ -257,8 +257,8 @@ const struct omap_bandgap_data omap4470_data = {
 		.constant = OMAP_GRADIENT_CONST_4470,
 		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_4470,
 		.constant_pcb = OMAP_GRADIENT_CONST_W_PCB_4470,
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.register_cooling = ti_thermal_register_cpu_cooling,
+		.unregister_cooling = ti_thermal_unregister_cpu_cooling,
 		},
 	},
 	.sensor_count = 1,
diff --git a/drivers/staging/ti-soc-thermal/omap5-thermal-data.c b/drivers/staging/ti-soc-thermal/omap5-thermal-data.c
index 172b4ad..0afe9c8 100644
--- a/drivers/staging/ti-soc-thermal/omap5-thermal-data.c
+++ b/drivers/staging/ti-soc-thermal/omap5-thermal-data.c
@@ -312,24 +312,24 @@ omap5430_adc_to_temp[
 
 /* OMAP54xx ES2.0 data */
 /* TODO : Need to update the slope/constant for ES2.0 silicon */
-const struct omap_bandgap_data omap5430_data = {
-	.features = OMAP_BANDGAP_FEATURE_TSHUT_CONFIG |
-			OMAP_BANDGAP_FEATURE_FREEZE_BIT |
-			OMAP_BANDGAP_FEATURE_TALERT,
+const struct ti_bandgap_data omap5430_data = {
+	.features = TI_BANDGAP_FEATURE_TSHUT_CONFIG |
+			TI_BANDGAP_FEATURE_FREEZE_BIT |
+			TI_BANDGAP_FEATURE_TALERT,
 	.fclock_name = "l3instr_ts_gclk_div",
 	.div_ck_name = "l3instr_ts_gclk_div",
 	.conv_table = omap5430_adc_to_temp,
 	.adc_start_val = OMAP5430_ADC_START_VALUE,
 	.adc_end_val = OMAP5430_ADC_END_VALUE,
-	.expose_sensor = omap_thermal_expose_sensor,
-	.remove_sensor = omap_thermal_remove_sensor,
+	.expose_sensor = ti_thermal_expose_sensor,
+	.remove_sensor = ti_thermal_remove_sensor,
 	.sensors = {
 		{
 		.registers = &omap5430_mpu_temp_sensor_registers,
 		.ts_data = &omap5430_mpu_temp_sensor_data,
 		.domain = "cpu",
-		.register_cooling = omap_thermal_register_cpu_cooling,
-		.unregister_cooling = omap_thermal_unregister_cpu_cooling,
+		.register_cooling = ti_thermal_register_cpu_cooling,
+		.unregister_cooling = ti_thermal_unregister_cpu_cooling,
 		.slope = OMAP_GRADIENT_SLOPE_5430_CPU,
 		.constant = OMAP_GRADIENT_CONST_5430_CPU,
 		.slope_pcb = OMAP_GRADIENT_SLOPE_W_PCB_5430_CPU,
diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.c b/drivers/staging/ti-soc-thermal/ti-bandgap.c
index 5a8ae9c..a09ebfc 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.c
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.c
@@ -1,5 +1,5 @@
 /*
- * OMAP4 Bandgap temperature sensor driver
+ * TI Bandgap temperature sensor driver
  *
  * Copyright (C) 2011-2012 Texas Instruments Incorporated - http://www.ti.com/
  * Author: J Keerthy <j-keerthy@ti.com>
@@ -45,27 +45,27 @@
 /***   Helper functions to access registers and their bitfields   ***/
 
 /**
- * omap_bandgap_readl() - simple read helper function
- * @bgp: pointer to omap_bandgap structure
+ * ti_bandgap_readl() - simple read helper function
+ * @bgp: pointer to ti_bandgap structure
  * @reg: desired register (offset) to be read
  *
  * Helper function to read bandgap registers. It uses the io remapped area.
  * Returns the register value.
  */
-static u32 omap_bandgap_readl(struct omap_bandgap *bgp, u32 reg)
+static u32 ti_bandgap_readl(struct ti_bandgap *bgp, u32 reg)
 {
 	return readl(bgp->base + reg);
 }
 
 /**
- * omap_bandgap_writel() - simple write helper function
- * @bgp: pointer to omap_bandgap structure
+ * ti_bandgap_writel() - simple write helper function
+ * @bgp: pointer to ti_bandgap structure
  * @val: desired register value to be written
  * @reg: desired register (offset) to be written
  *
  * Helper function to write bandgap registers. It uses the io remapped area.
  */
-static void omap_bandgap_writel(struct omap_bandgap *bgp, u32 val, u32 reg)
+static void ti_bandgap_writel(struct ti_bandgap *bgp, u32 val, u32 reg)
 {
 	writel(val, bgp->base + reg);
 }
@@ -82,27 +82,27 @@ do {								\
 	u32 r;							\
 								\
 	t = bgp->conf->sensors[(id)].registers;		\
-	r = omap_bandgap_readl(bgp, t->reg);			\
+	r = ti_bandgap_readl(bgp, t->reg);			\
 	r &= ~t->mask;						\
 	r |= (val) << __ffs(t->mask);				\
-	omap_bandgap_writel(bgp, r, t->reg);			\
+	ti_bandgap_writel(bgp, r, t->reg);			\
 } while (0)
 
 /***   Basic helper functions   ***/
 
 /**
- * omap_bandgap_power() - controls the power state of a bandgap device
- * @bgp: pointer to omap_bandgap structure
+ * ti_bandgap_power() - controls the power state of a bandgap device
+ * @bgp: pointer to ti_bandgap structure
  * @on: desired power state (1 - on, 0 - off)
  *
  * Used to power on/off a bandgap device instance. Only used on those
  * that features tempsoff bit.
  */
-static int omap_bandgap_power(struct omap_bandgap *bgp, bool on)
+static int ti_bandgap_power(struct ti_bandgap *bgp, bool on)
 {
 	int i;
 
-	if (!OMAP_BANDGAP_HAS(bgp, POWER_SWITCH))
+	if (!TI_BANDGAP_HAS(bgp, POWER_SWITCH))
 		goto exit;
 
 	for (i = 0; i < bgp->conf->sensor_count; i++)
@@ -114,8 +114,8 @@ exit:
 }
 
 /**
- * omap_bandgap_read_temp() - helper function to read sensor temperature
- * @bgp: pointer to omap_bandgap structure
+ * ti_bandgap_read_temp() - helper function to read sensor temperature
+ * @bgp: pointer to ti_bandgap structure
  * @id: bandgap sensor id
  *
  * Function to concentrate the steps to read sensor temperature register.
@@ -123,7 +123,7 @@ exit:
  * it might be needed to freeze the bandgap state machine, before fetching
  * the register value.
  */
-static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
+static u32 ti_bandgap_read_temp(struct ti_bandgap *bgp, int id)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, reg;
@@ -131,7 +131,7 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
 	tsr = bgp->conf->sensors[id].registers;
 	reg = tsr->temp_sensor_ctrl;
 
-	if (OMAP_BANDGAP_HAS(bgp, FREEZE_BIT)) {
+	if (TI_BANDGAP_HAS(bgp, FREEZE_BIT)) {
 		RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 1);
 		/*
 		 * In case we cannot read from cur_dtemp / dtemp_0,
@@ -141,10 +141,10 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
 	}
 
 	/* read temperature */
-	temp = omap_bandgap_readl(bgp, reg);
+	temp = ti_bandgap_readl(bgp, reg);
 	temp &= tsr->bgap_dtemp_mask;
 
-	if (OMAP_BANDGAP_HAS(bgp, FREEZE_BIT))
+	if (TI_BANDGAP_HAS(bgp, FREEZE_BIT))
 		RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 0);
 
 	return temp;
@@ -153,9 +153,9 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
 /***   IRQ handlers   ***/
 
 /**
- * omap_bandgap_talert_irq_handler() - handles Temperature alert IRQs
+ * ti_bandgap_talert_irq_handler() - handles Temperature alert IRQs
  * @irq: IRQ number
- * @data: private data (struct omap_bandgap *)
+ * @data: private data (struct ti_bandgap *)
  *
  * This is the Talert handler. Use it only if bandgap device features
  * HAS(TALERT). This handler goes over all sensors and checks their
@@ -163,9 +163,9 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
  * it will reset the event mask to wait for the opposite event (next event).
  * Every time there is a new event, it will be reported to thermal layer.
  */
-static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
+static irqreturn_t ti_bandgap_talert_irq_handler(int irq, void *data)
 {
-	struct omap_bandgap *bgp = data;
+	struct ti_bandgap *bgp = data;
 	struct temp_sensor_registers *tsr;
 	u32 t_hot = 0, t_cold = 0, ctrl;
 	int i;
@@ -173,7 +173,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 	spin_lock(&bgp->lock);
 	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		tsr = bgp->conf->sensors[i].registers;
-		ctrl = omap_bandgap_readl(bgp, tsr->bgap_status);
+		ctrl = ti_bandgap_readl(bgp, tsr->bgap_status);
 
 		/* Read the status of t_hot */
 		t_hot = ctrl & tsr->status_hot_mask;
@@ -184,7 +184,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 		if (!t_cold && !t_hot)
 			continue;
 
-		ctrl = omap_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
+		ctrl = ti_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
 		/*
 		 * One TALERT interrupt: Two sources
 		 * If the interrupt is due to t_hot then mask t_hot and
@@ -198,7 +198,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 			ctrl |= tsr->mask_hot_mask;
 		}
 
-		omap_bandgap_writel(bgp, ctrl, tsr->bgap_mask_ctrl);
+		ti_bandgap_writel(bgp, ctrl, tsr->bgap_mask_ctrl);
 
 		dev_dbg(bgp->dev,
 			"%s: IRQ from %s sensor: hotevent %d coldevent %d\n",
@@ -215,7 +215,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 }
 
 /**
- * omap_bandgap_tshut_irq_handler() - handles Temperature shutdown signal
+ * ti_bandgap_tshut_irq_handler() - handles Temperature shutdown signal
  * @irq: IRQ number
  * @data: private data (unused)
  *
@@ -223,7 +223,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
  * HAS(TSHUT). If any sensor fires the Tshut signal, we simply shutdown
  * the system.
  */
-static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
+static irqreturn_t ti_bandgap_tshut_irq_handler(int irq, void *data)
 {
 	pr_emerg("%s: TSHUT temperature reached. Needs shut down...\n",
 		 __func__);
@@ -236,8 +236,8 @@ static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
 /***   Helper functions which manipulate conversion ADC <-> mi Celsius   ***/
 
 /**
- * omap_bandgap_adc_to_mcelsius() - converts an ADC value to mCelsius scale
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_adc_to_mcelsius() - converts an ADC value to mCelsius scale
+ * @bgp: struct ti_bandgap pointer
  * @adc_val: value in ADC representation
  * @t: address where to write the resulting temperature in mCelsius
  *
@@ -246,10 +246,9 @@ static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
  * The conversion table is indexed by the ADC values.
  */
 static
-int omap_bandgap_adc_to_mcelsius(struct omap_bandgap *bgp,
-				 int adc_val, int *t)
+int ti_bandgap_adc_to_mcelsius(struct ti_bandgap *bgp, int adc_val, int *t)
 {
-	struct omap_bandgap_data *conf = bgp->conf;
+	struct ti_bandgap_data *conf = bgp->conf;
 	int ret = 0;
 
 	/* look up for temperature in the table and return the temperature */
@@ -265,8 +264,8 @@ exit:
 }
 
 /**
- * omap_bandgap_mcelsius_to_adc() - converts a mCelsius value to ADC scale
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_mcelsius_to_adc() - converts a mCelsius value to ADC scale
+ * @bgp: struct ti_bandgap pointer
  * @temp: value in mCelsius
  * @adc: address where to write the resulting temperature in ADC representation
  *
@@ -275,10 +274,9 @@ exit:
  * The conversion table is indexed by the ADC values.
  */
 static
-int omap_bandgap_mcelsius_to_adc(struct omap_bandgap *bgp, long temp,
-				 int *adc)
+int ti_bandgap_mcelsius_to_adc(struct ti_bandgap *bgp, long temp, int *adc)
 {
-	struct omap_bandgap_data *conf = bgp->conf;
+	struct ti_bandgap_data *conf = bgp->conf;
 	const int *conv_table = bgp->conf->conv_table;
 	int high, low, mid, ret = 0;
 
@@ -306,8 +304,8 @@ exit:
 }
 
 /**
- * omap_bandgap_add_hyst() - add hysteresis (in mCelsius) to an ADC value
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_add_hyst() - add hysteresis (in mCelsius) to an ADC value
+ * @bgp: struct ti_bandgap pointer
  * @adc_val: temperature value in ADC representation
  * @hyst_val: hysteresis value in mCelsius
  * @sum: address where to write the resulting temperature (in ADC scale)
@@ -316,8 +314,8 @@ exit:
  * Returns 0 on success, -ERANGE otherwise.
  */
 static
-int omap_bandgap_add_hyst(struct omap_bandgap *bgp, int adc_val,
-			  int hyst_val, u32 *sum)
+int ti_bandgap_add_hyst(struct ti_bandgap *bgp, int adc_val, int hyst_val,
+			u32 *sum)
 {
 	int temp, ret;
 
@@ -325,13 +323,13 @@ int omap_bandgap_add_hyst(struct omap_bandgap *bgp, int adc_val,
 	 * Need to add in the mcelsius domain, so we have a temperature
 	 * the conv_table range
 	 */
-	ret = omap_bandgap_adc_to_mcelsius(bgp, adc_val, &temp);
+	ret = ti_bandgap_adc_to_mcelsius(bgp, adc_val, &temp);
 	if (ret < 0)
 		goto exit;
 
 	temp += hyst_val;
 
-	ret = omap_bandgap_mcelsius_to_adc(bgp, temp, sum);
+	ret = ti_bandgap_mcelsius_to_adc(bgp, temp, sum);
 
 exit:
 	return ret;
@@ -340,25 +338,25 @@ exit:
 /***   Helper functions handling device Alert/Shutdown signals   ***/
 
 /**
- * omap_bandgap_unmask_interrupts() - unmasks the events of thot & tcold
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_unmask_interrupts() - unmasks the events of thot & tcold
+ * @bgp: struct ti_bandgap pointer
  * @t_hot: hot temperature value to trigger alert signal
  * @t_cold: cold temperature value to trigger alert signal
  *
  * Checks the requested t_hot and t_cold values and configures the IRQ event
  * masks accordingly. Call this function only if bandgap features HAS(TALERT).
  */
-static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bgp, int id,
-					   u32 t_hot, u32 t_cold)
+static void ti_bandgap_unmask_interrupts(struct ti_bandgap *bgp, int id,
+					 u32 t_hot, u32 t_cold)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, reg_val;
 
 	/* Read the current on die temperature */
-	temp = omap_bandgap_read_temp(bgp, id);
+	temp = ti_bandgap_read_temp(bgp, id);
 
 	tsr = bgp->conf->sensors[id].registers;
-	reg_val = omap_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
+	reg_val = ti_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
 
 	if (temp < t_hot)
 		reg_val |= tsr->mask_hot_mask;
@@ -369,12 +367,12 @@ static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bgp, int id,
 		reg_val |= tsr->mask_cold_mask;
 	else
 		reg_val &= ~tsr->mask_cold_mask;
-	omap_bandgap_writel(bgp, reg_val, tsr->bgap_mask_ctrl);
+	ti_bandgap_writel(bgp, reg_val, tsr->bgap_mask_ctrl);
 }
 
 /**
- * omap_bandgap_update_alert_threshold() - sequence to update thresholds
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_update_alert_threshold() - sequence to update thresholds
+ * @bgp: struct ti_bandgap pointer
  * @id: bandgap sensor id
  * @val: value (ADC) of a new threshold
  * @hot: desired threshold to be updated. true if threshold hot, false if
@@ -386,9 +384,8 @@ static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bgp, int id,
  * and configures the thresholds so that t_hot is always greater than t_cold.
  * Call this function only if bandgap features HAS(TALERT).
  */
-static
-int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
-					int val, bool hot)
+static int ti_bandgap_update_alert_threshold(struct ti_bandgap *bgp, int id,
+					     int val, bool hot)
 {
 	struct temp_sensor_data *ts_data = bgp->conf->sensors[id].ts_data;
 	struct temp_sensor_registers *tsr;
@@ -398,7 +395,7 @@ int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
 	tsr = bgp->conf->sensors[id].registers;
 
 	/* obtain the current value */
-	thresh_val = omap_bandgap_readl(bgp, tsr->bgap_threshold);
+	thresh_val = ti_bandgap_readl(bgp, tsr->bgap_threshold);
 	t_cold = (thresh_val & tsr->threshold_tcold_mask) >>
 		__ffs(tsr->threshold_tcold_mask);
 	t_hot = (thresh_val & tsr->threshold_thot_mask) >>
@@ -410,13 +407,13 @@ int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
 
 	if (t_cold < t_hot) {
 		if (hot)
-			err = omap_bandgap_add_hyst(bgp, t_hot,
-						    -ts_data->hyst_val,
-						    &t_cold);
+			err = ti_bandgap_add_hyst(bgp, t_hot,
+						  -ts_data->hyst_val,
+						  &t_cold);
 		else
-			err = omap_bandgap_add_hyst(bgp, t_cold,
-						    ts_data->hyst_val,
-						    &t_hot);
+			err = ti_bandgap_add_hyst(bgp, t_cold,
+						  ts_data->hyst_val,
+						  &t_hot);
 	}
 
 	/* write the new threshold values */
@@ -424,7 +421,7 @@ int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
 	reg_val |= (t_hot << __ffs(tsr->threshold_thot_mask));
 	reg_val |= thresh_val & ~tsr->threshold_tcold_mask;
 	reg_val |= (t_cold << __ffs(tsr->threshold_tcold_mask));
-	omap_bandgap_writel(bgp, reg_val, tsr->bgap_threshold);
+	ti_bandgap_writel(bgp, reg_val, tsr->bgap_threshold);
 
 	if (err) {
 		dev_err(bgp->dev, "failed to reprogram thot threshold\n");
@@ -432,20 +429,20 @@ int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
 		goto exit;
 	}
 
-	omap_bandgap_unmask_interrupts(bgp, id, t_hot, t_cold);
+	ti_bandgap_unmask_interrupts(bgp, id, t_hot, t_cold);
 exit:
 	return err;
 }
 
 /**
- * omap_bandgap_validate() - helper to check the sanity of a struct omap_bandgap
- * @bgp: struct omap_bandgap pointer
+ * ti_bandgap_validate() - helper to check the sanity of a struct ti_bandgap
+ * @bgp: struct ti_bandgap pointer
  * @id: bandgap sensor id
  *
  * Checks if the bandgap pointer is valid and if the sensor id is also
  * applicable.
  */
-static inline int omap_bandgap_validate(struct omap_bandgap *bgp, int id)
+static inline int ti_bandgap_validate(struct ti_bandgap *bgp, int id)
 {
 	int ret = 0;
 
@@ -466,8 +463,8 @@ exit:
 }
 
 /**
- * _omap_bandgap_write_threshold() - helper to update TALERT t_cold or t_hot
- * @bgp: struct omap_bandgap pointer
+ * _ti_bandgap_write_threshold() - helper to update TALERT t_cold or t_hot
+ * @bgp: struct ti_bandgap pointer
  * @id: bandgap sensor id
  * @val: value (mCelsius) of a new threshold
  * @hot: desired threshold to be updated. true if threshold hot, false if
@@ -478,19 +475,19 @@ exit:
  * Validates the mCelsius range and update the requested threshold.
  * Call this function only if bandgap features HAS(TALERT).
  */
-int _omap_bandgap_write_threshold(struct omap_bandgap *bgp, int id, int val,
-				  bool hot)
+int _ti_bandgap_write_threshold(struct ti_bandgap *bgp, int id, int val,
+				bool hot)
 {
 	struct temp_sensor_data *ts_data;
 	struct temp_sensor_registers *tsr;
 	u32 adc_val;
 	int ret;
 
-	ret = omap_bandgap_validate(bgp, id);
+	ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		goto exit;
 
-	if (!OMAP_BANDGAP_HAS(bgp, TALERT)) {
+	if (!TI_BANDGAP_HAS(bgp, TALERT)) {
 		ret = -ENOTSUPP;
 		goto exit;
 	}
@@ -508,12 +505,12 @@ int _omap_bandgap_write_threshold(struct omap_bandgap *bgp, int id, int val,
 	if (ret)
 		goto exit;
 
-	ret = omap_bandgap_mcelsius_to_adc(bgp, val, &adc_val);
+	ret = ti_bandgap_mcelsius_to_adc(bgp, val, &adc_val);
 	if (ret < 0)
 		goto exit;
 
 	spin_lock(&bgp->lock);
-	omap_bandgap_update_alert_threshold(bgp, id, adc_val, hot);
+	ti_bandgap_update_alert_threshold(bgp, id, adc_val, hot);
 	spin_unlock(&bgp->lock);
 
 exit:
@@ -521,8 +518,8 @@ exit:
 }
 
 /**
- * _omap_bandgap_read_threshold() - helper to read TALERT t_cold or t_hot
- * @bgp: struct omap_bandgap pointer
+ * _ti_bandgap_read_threshold() - helper to read TALERT t_cold or t_hot
+ * @bgp: struct ti_bandgap pointer
  * @id: bandgap sensor id
  * @val: value (mCelsius) of a threshold
  * @hot: desired threshold to be read. true if threshold hot, false if
@@ -532,18 +529,18 @@ exit:
  * This function can be used to read t_hot or t_cold, depending on @hot value.
  * Call this function only if bandgap features HAS(TALERT).
  */
-int _omap_bandgap_read_threshold(struct omap_bandgap *bgp, int id,
-				 int *val, bool hot)
+int _ti_bandgap_read_threshold(struct ti_bandgap *bgp, int id,
+			       int *val, bool hot)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, mask;
 	int ret = 0;
 
-	ret = omap_bandgap_validate(bgp, id);
+	ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		goto exit;
 
-	if (!OMAP_BANDGAP_HAS(bgp, TALERT)) {
+	if (!TI_BANDGAP_HAS(bgp, TALERT)) {
 		ret = -ENOTSUPP;
 		goto exit;
 	}
@@ -554,9 +551,9 @@ int _omap_bandgap_read_threshold(struct omap_bandgap *bgp, int id,
 	else
 		mask = tsr->threshold_tcold_mask;
 
-	temp = omap_bandgap_readl(bgp, tsr->bgap_threshold);
+	temp = ti_bandgap_readl(bgp, tsr->bgap_threshold);
 	temp = (temp & mask) >> __ffs(mask);
-	ret |= omap_bandgap_adc_to_mcelsius(bgp, temp, &temp);
+	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
 	if (ret) {
 		dev_err(bgp->dev, "failed to read thot\n");
 		ret = -EIO;
@@ -572,83 +569,81 @@ exit:
 /***   Exposed APIs   ***/
 
 /**
- * omap_bandgap_read_thot() - reads sensor current thot
+ * ti_bandgap_read_thot() - reads sensor current thot
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @thot - resulting current thot value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_thot(struct omap_bandgap *bgp, int id,
-			   int *thot)
+int ti_bandgap_read_thot(struct ti_bandgap *bgp, int id, int *thot)
 {
-	return _omap_bandgap_read_threshold(bgp, id, thot, true);
+	return _ti_bandgap_read_threshold(bgp, id, thot, true);
 }
 
 /**
- * omap_bandgap_write_thot() - sets sensor current thot
+ * ti_bandgap_write_thot() - sets sensor current thot
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @val - desired thot value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_write_thot(struct omap_bandgap *bgp, int id, int val)
+int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val)
 {
-	return _omap_bandgap_write_threshold(bgp, id, val, true);
+	return _ti_bandgap_write_threshold(bgp, id, val, true);
 }
 
 /**
- * omap_bandgap_read_tcold() - reads sensor current tcold
+ * ti_bandgap_read_tcold() - reads sensor current tcold
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @tcold - resulting current tcold value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_tcold(struct omap_bandgap *bgp, int id,
-			    int *tcold)
+int ti_bandgap_read_tcold(struct ti_bandgap *bgp, int id, int *tcold)
 {
-	return _omap_bandgap_read_threshold(bgp, id, tcold, false);
+	return _ti_bandgap_read_threshold(bgp, id, tcold, false);
 }
 
 /**
- * omap_bandgap_write_tcold() - sets the sensor tcold
+ * ti_bandgap_write_tcold() - sets the sensor tcold
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @val - desired tcold value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_write_tcold(struct omap_bandgap *bgp, int id, int val)
+int ti_bandgap_write_tcold(struct ti_bandgap *bgp, int id, int val)
 {
-	return _omap_bandgap_write_threshold(bgp, id, val, false);
+	return _ti_bandgap_write_threshold(bgp, id, val, false);
 }
 
 /**
- * omap_bandgap_read_update_interval() - read the sensor update interval
+ * ti_bandgap_read_update_interval() - read the sensor update interval
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @interval - resulting update interval in miliseconds
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_update_interval(struct omap_bandgap *bgp, int id,
-					 int *interval)
+int ti_bandgap_read_update_interval(struct ti_bandgap *bgp, int id,
+				    int *interval)
 {
 	struct temp_sensor_registers *tsr;
 	u32 time;
 	int ret;
 
-	ret = omap_bandgap_validate(bgp, id);
+	ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
-	if (!OMAP_BANDGAP_HAS(bgp, COUNTER))
+	if (!TI_BANDGAP_HAS(bgp, COUNTER))
 		return -ENOTSUPP;
 
 	tsr = bgp->conf->sensors[id].registers;
-	time = omap_bandgap_readl(bgp, tsr->bgap_counter);
+	time = ti_bandgap_readl(bgp, tsr->bgap_counter);
 	time = (time & tsr->counter_mask) >> __ffs(tsr->counter_mask);
 	time = time * 1000 / bgp->clk_rate;
 
@@ -658,21 +653,21 @@ int omap_bandgap_read_update_interval(struct omap_bandgap *bgp, int id,
 }
 
 /**
- * omap_bandgap_write_update_interval() - set the update interval
+ * ti_bandgap_write_update_interval() - set the update interval
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @interval - desired update interval in miliseconds
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_write_update_interval(struct omap_bandgap *bgp,
-				       int id, u32 interval)
+int ti_bandgap_write_update_interval(struct ti_bandgap *bgp,
+				     int id, u32 interval)
 {
-	int ret = omap_bandgap_validate(bgp, id);
+	int ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
-	if (!OMAP_BANDGAP_HAS(bgp, COUNTER))
+	if (!TI_BANDGAP_HAS(bgp, COUNTER))
 		return -ENOTSUPP;
 
 	interval = interval * bgp->clk_rate / 1000;
@@ -684,28 +679,28 @@ int omap_bandgap_write_update_interval(struct omap_bandgap *bgp,
 }
 
 /**
- * omap_bandgap_read_temperature() - report current temperature
+ * ti_bandgap_read_temperature() - report current temperature
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @temperature - resulting temperature
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_temperature(struct omap_bandgap *bgp, int id,
-				  int *temperature)
+int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
+				int *temperature)
 {
 	u32 temp;
 	int ret;
 
-	ret = omap_bandgap_validate(bgp, id);
+	ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
 	spin_lock(&bgp->lock);
-	temp = omap_bandgap_read_temp(bgp, id);
+	temp = ti_bandgap_read_temp(bgp, id);
 	spin_unlock(&bgp->lock);
 
-	ret |= omap_bandgap_adc_to_mcelsius(bgp, temp, &temp);
+	ret |= ti_bandgap_adc_to_mcelsius(bgp, temp, &temp);
 	if (ret)
 		return -EIO;
 
@@ -715,7 +710,7 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bgp, int id,
 }
 
 /**
- * omap_bandgap_set_sensor_data() - helper function to store thermal
+ * ti_bandgap_set_sensor_data() - helper function to store thermal
  * framework related data.
  * @bgp - pointer to bandgap instance
  * @id - sensor id
@@ -723,10 +718,9 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bgp, int id,
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_set_sensor_data(struct omap_bandgap *bgp, int id,
-				 void *data)
+int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data)
 {
-	int ret = omap_bandgap_validate(bgp, id);
+	int ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
@@ -736,16 +730,16 @@ int omap_bandgap_set_sensor_data(struct omap_bandgap *bgp, int id,
 }
 
 /**
- * omap_bandgap_get_sensor_data() - helper function to get thermal
+ * ti_bandgap_get_sensor_data() - helper function to get thermal
  * framework related data.
  * @bgp - pointer to bandgap instance
  * @id - sensor id
  *
  * returns data stored by set function with sensor id on success or NULL
  */
-void *omap_bandgap_get_sensor_data(struct omap_bandgap *bgp, int id)
+void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id)
 {
-	int ret = omap_bandgap_validate(bgp, id);
+	int ret = ti_bandgap_validate(bgp, id);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -755,29 +749,29 @@ void *omap_bandgap_get_sensor_data(struct omap_bandgap *bgp, int id)
 /***   Helper functions used during device initialization   ***/
 
 /**
- * omap_bandgap_force_single_read() - executes 1 single ADC conversion
- * @bgp: pointer to struct omap_bandgap
+ * ti_bandgap_force_single_read() - executes 1 single ADC conversion
+ * @bgp: pointer to struct ti_bandgap
  * @id: sensor id which it is desired to read 1 temperature
  *
  * Used to initialize the conversion state machine and set it to a valid
  * state. Called during device initialization and context restore events.
  */
 static int
-omap_bandgap_force_single_read(struct omap_bandgap *bgp, int id)
+ti_bandgap_force_single_read(struct ti_bandgap *bgp, int id)
 {
 	u32 temp = 0, counter = 1000;
 
 	/* Select single conversion mode */
-	if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
+	if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
 		RMW_BITS(bgp, id, bgap_mode_ctrl, mode_ctrl_mask, 0);
 
 	/* Start of Conversion = 1 */
 	RMW_BITS(bgp, id, temp_sensor_ctrl, bgap_soc_mask, 1);
 	/* Wait until DTEMP is updated */
-	temp = omap_bandgap_read_temp(bgp, id);
+	temp = ti_bandgap_read_temp(bgp, id);
 
 	while ((temp == 0) && --counter)
-		temp = omap_bandgap_read_temp(bgp, id);
+		temp = ti_bandgap_read_temp(bgp, id);
 	/* REVISIT: Check correct condition for end of conversion */
 
 	/* Start of Conversion = 0 */
@@ -787,21 +781,21 @@ omap_bandgap_force_single_read(struct omap_bandgap *bgp, int id)
 }
 
 /**
- * omap_bandgap_set_continous_mode() - One time enabling of continuous mode
- * @bgp: pointer to struct omap_bandgap
+ * ti_bandgap_set_continous_mode() - One time enabling of continuous mode
+ * @bgp: pointer to struct ti_bandgap
  *
  * Call this function only if HAS(MODE_CONFIG) is set. As this driver may
  * be used for junction temperature monitoring, it is desirable that the
  * sensors are operational all the time, so that alerts are generated
  * properly.
  */
-static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bgp)
+static int ti_bandgap_set_continuous_mode(struct ti_bandgap *bgp)
 {
 	int i;
 
 	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		/* Perform a single read just before enabling continuous */
-		omap_bandgap_force_single_read(bgp, i);
+		ti_bandgap_force_single_read(bgp, i);
 		RMW_BITS(bgp, i, bgap_mode_ctrl, mode_ctrl_mask, 1);
 	}
 
@@ -809,8 +803,8 @@ static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bgp)
 }
 
 /**
- * omap_bandgap_tshut_init() - setup and initialize tshut handling
- * @bgp: pointer to struct omap_bandgap
+ * ti_bandgap_tshut_init() - setup and initialize tshut handling
+ * @bgp: pointer to struct ti_bandgap
  * @pdev: pointer to device struct platform_device
  *
  * Call this function only in case the bandgap features HAS(TSHUT).
@@ -820,8 +814,8 @@ static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bgp)
  * one of the bandgap sensors violates the TSHUT high/hot threshold.
  * And in that case, the system must go off.
  */
-static int omap_bandgap_tshut_init(struct omap_bandgap *bgp,
-				   struct platform_device *pdev)
+static int ti_bandgap_tshut_init(struct ti_bandgap *bgp,
+				 struct platform_device *pdev)
 {
 	int gpio_nr = bgp->tshut_gpio;
 	int status;
@@ -838,10 +832,8 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bgp,
 		return status;
 	}
 
-	status = request_irq(gpio_to_irq(gpio_nr),
-			     omap_bandgap_tshut_irq_handler,
-			     IRQF_TRIGGER_RISING, "tshut",
-			     NULL);
+	status = request_irq(gpio_to_irq(gpio_nr), ti_bandgap_tshut_irq_handler,
+			     IRQF_TRIGGER_RISING, "tshut", NULL);
 	if (status) {
 		gpio_free(gpio_nr);
 		dev_err(bgp->dev, "request irq failed for TSHUT");
@@ -851,8 +843,8 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bgp,
 }
 
 /**
- * omap_bandgap_alert_init() - setup and initialize talert handling
- * @bgp: pointer to struct omap_bandgap
+ * ti_bandgap_alert_init() - setup and initialize talert handling
+ * @bgp: pointer to struct ti_bandgap
  * @pdev: pointer to device struct platform_device
  *
  * Call this function only in case the bandgap features HAS(TALERT).
@@ -861,8 +853,8 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bgp,
  * are violated. In these situation, the driver must reprogram the thresholds,
  * accordingly to specified policy.
  */
-static int omap_bandgap_talert_init(struct omap_bandgap *bgp,
-				    struct platform_device *pdev)
+static int ti_bandgap_talert_init(struct ti_bandgap *bgp,
+				  struct platform_device *pdev)
 {
 	int ret;
 
@@ -872,7 +864,7 @@ static int omap_bandgap_talert_init(struct omap_bandgap *bgp,
 		return bgp->irq;
 	}
 	ret = request_threaded_irq(bgp->irq, NULL,
-				   omap_bandgap_talert_irq_handler,
+				   ti_bandgap_talert_irq_handler,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				   "talert", bgp);
 	if (ret) {
@@ -884,20 +876,20 @@ static int omap_bandgap_talert_init(struct omap_bandgap *bgp,
 }
 
 /**
- * omap_bandgap_build() - parse DT and setup a struct omap_bandgap
- * @bgp: pointer to struct omap_bandgap
+ * ti_bandgap_build() - parse DT and setup a struct ti_bandgap
+ * @bgp: pointer to struct ti_bandgap
  * @pdev: pointer to device struct platform_device
  *
  * Used to read the device tree properties accordingly to the bandgap
  * matching version. Based on bandgap version and its capabilities it
- * will build a struct omap_bandgap out of the required DT entries.
+ * will build a struct ti_bandgap out of the required DT entries.
  */
-static const struct of_device_id of_omap_bandgap_match[];
-static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
+static const struct of_device_id of_ti_bandgap_match[];
+static struct ti_bandgap *ti_bandgap_build(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
 	const struct of_device_id *of_id;
-	struct omap_bandgap *bgp;
+	struct ti_bandgap *bgp;
 	struct resource *res;
 	u32 prop;
 	int i;
@@ -908,14 +900,14 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	bgp = devm_kzalloc(&pdev->dev, sizeof(struct omap_bandgap),
+	bgp = devm_kzalloc(&pdev->dev, sizeof(struct ti_bandgap),
 				    GFP_KERNEL);
 	if (!bgp) {
 		dev_err(&pdev->dev, "Unable to allocate mem for driver ref\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
-	of_id = of_match_device(of_omap_bandgap_match, &pdev->dev);
+	of_id = of_match_device(of_ti_bandgap_match, &pdev->dev);
 	if (of_id)
 		bgp->conf = of_id->data;
 
@@ -935,7 +927,7 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 		i++;
 	} while (res);
 
-	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
+	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
 		if (of_property_read_u32(node, "ti,tshut-gpio", &prop) < 0) {
 			dev_err(&pdev->dev, "missing tshut gpio in device tree\n");
 			return ERR_PTR(-EINVAL);
@@ -954,20 +946,20 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 /***   Device driver call backs   ***/
 
 static
-int omap_bandgap_probe(struct platform_device *pdev)
+int ti_bandgap_probe(struct platform_device *pdev)
 {
-	struct omap_bandgap *bgp;
+	struct ti_bandgap *bgp;
 	int clk_rate, ret = 0, i;
 
-	bgp = omap_bandgap_build(pdev);
+	bgp = ti_bandgap_build(pdev);
 	if (IS_ERR_OR_NULL(bgp)) {
 		dev_err(&pdev->dev, "failed to fetch platform data\n");
 		return PTR_ERR(bgp);
 	}
 	bgp->dev = &pdev->dev;
 
-	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
-		ret = omap_bandgap_tshut_init(bgp, pdev);
+	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
+		ret = ti_bandgap_tshut_init(bgp, pdev);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"failed to initialize system tshut IRQ\n");
@@ -1000,7 +992,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 		 * it is an untrimmed sample and the temperatures
 		 * may not be accurate
 		 */
-		val = omap_bandgap_readl(bgp, tsr->bgap_efuse);
+		val = ti_bandgap_readl(bgp, tsr->bgap_efuse);
 		if (ret || !val)
 			dev_info(&pdev->dev,
 				 "Non-trimmed BGAP, Temp not accurate\n");
@@ -1020,7 +1012,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 		dev_err(&pdev->dev, "Cannot re-set clock rate. Continuing\n");
 
 	bgp->clk_rate = clk_rate;
-	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_prepare_enable(bgp->fclock);
 
 
@@ -1028,10 +1020,10 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	bgp->dev = &pdev->dev;
 	platform_set_drvdata(pdev, bgp);
 
-	omap_bandgap_power(bgp, true);
+	ti_bandgap_power(bgp, true);
 
 	/* Set default counter to 1 for now */
-	if (OMAP_BANDGAP_HAS(bgp, COUNTER))
+	if (TI_BANDGAP_HAS(bgp, COUNTER))
 		for (i = 0; i < bgp->conf->sensor_count; i++)
 			RMW_BITS(bgp, i, bgap_counter, counter_mask, 1);
 
@@ -1041,7 +1033,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 
 		ts_data = bgp->conf->sensors[i].ts_data;
 
-		if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
+		if (TI_BANDGAP_HAS(bgp, TALERT)) {
 			/* Set initial Talert thresholds */
 			RMW_BITS(bgp, i, bgap_threshold,
 				 threshold_tcold_mask, ts_data->t_cold);
@@ -1052,7 +1044,7 @@ int omap_bandgap_probe(struct platform_device *pdev)
 			RMW_BITS(bgp, i, bgap_mask_ctrl, mask_cold_mask, 1);
 		}
 
-		if (OMAP_BANDGAP_HAS(bgp, TSHUT_CONFIG)) {
+		if (TI_BANDGAP_HAS(bgp, TSHUT_CONFIG)) {
 			/* Set initial Tshut thresholds */
 			RMW_BITS(bgp, i, tshut_threshold,
 				 tshut_hot_mask, ts_data->tshut_hot);
@@ -1061,11 +1053,11 @@ int omap_bandgap_probe(struct platform_device *pdev)
 		}
 	}
 
-	if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
-		omap_bandgap_set_continuous_mode(bgp);
+	if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
+		ti_bandgap_set_continuous_mode(bgp);
 
 	/* Set .250 seconds time as default counter */
-	if (OMAP_BANDGAP_HAS(bgp, COUNTER))
+	if (TI_BANDGAP_HAS(bgp, COUNTER))
 		for (i = 0; i < bgp->conf->sensor_count; i++)
 			RMW_BITS(bgp, i, bgap_counter, counter_mask,
 				 bgp->clk_rate / 4);
@@ -1087,8 +1079,8 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	 * might be called as soon as it is enabled where as rest of framework
 	 * is still getting initialised.
 	 */
-	if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
-		ret = omap_bandgap_talert_init(bgp, pdev);
+	if (TI_BANDGAP_HAS(bgp, TALERT)) {
+		ret = ti_bandgap_talert_init(bgp, pdev);
 		if (ret) {
 			dev_err(&pdev->dev, "failed to initialize Talert IRQ\n");
 			i = bgp->conf->sensor_count;
@@ -1099,13 +1091,13 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	return 0;
 
 disable_clk:
-	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_disable_unprepare(bgp->fclock);
 put_clks:
 	clk_put(bgp->fclock);
 	clk_put(bgp->div_clk);
 free_irqs:
-	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
+	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
 		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
 		gpio_free(bgp->tshut_gpio);
 	}
@@ -1114,9 +1106,9 @@ free_irqs:
 }
 
 static
-int omap_bandgap_remove(struct platform_device *pdev)
+int ti_bandgap_remove(struct platform_device *pdev)
 {
-	struct omap_bandgap *bgp = platform_get_drvdata(pdev);
+	struct ti_bandgap *bgp = platform_get_drvdata(pdev);
 	int i;
 
 	/* First thing is to remove sensor interfaces */
@@ -1128,17 +1120,17 @@ int omap_bandgap_remove(struct platform_device *pdev)
 			bgp->conf->remove_sensor(bgp, i);
 	}
 
-	omap_bandgap_power(bgp, false);
+	ti_bandgap_power(bgp, false);
 
-	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_disable_unprepare(bgp->fclock);
 	clk_put(bgp->fclock);
 	clk_put(bgp->div_clk);
 
-	if (OMAP_BANDGAP_HAS(bgp, TALERT))
+	if (TI_BANDGAP_HAS(bgp, TALERT))
 		free_irq(bgp->irq, bgp);
 
-	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
+	if (TI_BANDGAP_HAS(bgp, TSHUT)) {
 		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
 		gpio_free(bgp->tshut_gpio);
 	}
@@ -1147,7 +1139,7 @@ int omap_bandgap_remove(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM
-static int omap_bandgap_save_ctxt(struct omap_bandgap *bgp)
+static int ti_bandgap_save_ctxt(struct ti_bandgap *bgp)
 {
 	int i;
 
@@ -1158,28 +1150,28 @@ static int omap_bandgap_save_ctxt(struct omap_bandgap *bgp)
 		rval = &bgp->conf->sensors[i].regval;
 		tsr = bgp->conf->sensors[i].registers;
 
-		if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
-			rval->bg_mode_ctrl = omap_bandgap_readl(bgp,
+		if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
+			rval->bg_mode_ctrl = ti_bandgap_readl(bgp,
 							tsr->bgap_mode_ctrl);
-		if (OMAP_BANDGAP_HAS(bgp, COUNTER))
-			rval->bg_counter = omap_bandgap_readl(bgp,
+		if (TI_BANDGAP_HAS(bgp, COUNTER))
+			rval->bg_counter = ti_bandgap_readl(bgp,
 							tsr->bgap_counter);
-		if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
-			rval->bg_threshold = omap_bandgap_readl(bgp,
+		if (TI_BANDGAP_HAS(bgp, TALERT)) {
+			rval->bg_threshold = ti_bandgap_readl(bgp,
 							tsr->bgap_threshold);
-			rval->bg_ctrl = omap_bandgap_readl(bgp,
+			rval->bg_ctrl = ti_bandgap_readl(bgp,
 						   tsr->bgap_mask_ctrl);
 		}
 
-		if (OMAP_BANDGAP_HAS(bgp, TSHUT_CONFIG))
-			rval->tshut_threshold = omap_bandgap_readl(bgp,
+		if (TI_BANDGAP_HAS(bgp, TSHUT_CONFIG))
+			rval->tshut_threshold = ti_bandgap_readl(bgp,
 						   tsr->tshut_threshold);
 	}
 
 	return 0;
 }
 
-static int omap_bandgap_restore_ctxt(struct omap_bandgap *bgp)
+static int ti_bandgap_restore_ctxt(struct ti_bandgap *bgp)
 {
 	int i;
 
@@ -1191,70 +1183,70 @@ static int omap_bandgap_restore_ctxt(struct omap_bandgap *bgp)
 		rval = &bgp->conf->sensors[i].regval;
 		tsr = bgp->conf->sensors[i].registers;
 
-		if (OMAP_BANDGAP_HAS(bgp, COUNTER))
-			val = omap_bandgap_readl(bgp, tsr->bgap_counter);
+		if (TI_BANDGAP_HAS(bgp, COUNTER))
+			val = ti_bandgap_readl(bgp, tsr->bgap_counter);
 
-		if (OMAP_BANDGAP_HAS(bgp, TSHUT_CONFIG))
-			omap_bandgap_writel(bgp, rval->tshut_threshold,
-					    tsr->tshut_threshold);
+		if (TI_BANDGAP_HAS(bgp, TSHUT_CONFIG))
+			ti_bandgap_writel(bgp, rval->tshut_threshold,
+					  tsr->tshut_threshold);
 		/* Force immediate temperature measurement and update
 		 * of the DTEMP field
 		 */
-		omap_bandgap_force_single_read(bgp, i);
-
-		if (OMAP_BANDGAP_HAS(bgp, COUNTER))
-			omap_bandgap_writel(bgp, rval->bg_counter,
-					    tsr->bgap_counter);
-		if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
-			omap_bandgap_writel(bgp, rval->bg_mode_ctrl,
-					    tsr->bgap_mode_ctrl);
-		if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
-			omap_bandgap_writel(bgp, rval->bg_threshold,
-					    tsr->bgap_threshold);
-			omap_bandgap_writel(bgp, rval->bg_ctrl,
-					    tsr->bgap_mask_ctrl);
+		ti_bandgap_force_single_read(bgp, i);
+
+		if (TI_BANDGAP_HAS(bgp, COUNTER))
+			ti_bandgap_writel(bgp, rval->bg_counter,
+					  tsr->bgap_counter);
+		if (TI_BANDGAP_HAS(bgp, MODE_CONFIG))
+			ti_bandgap_writel(bgp, rval->bg_mode_ctrl,
+					  tsr->bgap_mode_ctrl);
+		if (TI_BANDGAP_HAS(bgp, TALERT)) {
+			ti_bandgap_writel(bgp, rval->bg_threshold,
+					  tsr->bgap_threshold);
+			ti_bandgap_writel(bgp, rval->bg_ctrl,
+					  tsr->bgap_mask_ctrl);
 		}
 	}
 
 	return 0;
 }
 
-static int omap_bandgap_suspend(struct device *dev)
+static int ti_bandgap_suspend(struct device *dev)
 {
-	struct omap_bandgap *bgp = dev_get_drvdata(dev);
+	struct ti_bandgap *bgp = dev_get_drvdata(dev);
 	int err;
 
-	err = omap_bandgap_save_ctxt(bgp);
-	omap_bandgap_power(bgp, false);
+	err = ti_bandgap_save_ctxt(bgp);
+	ti_bandgap_power(bgp, false);
 
-	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_disable_unprepare(bgp->fclock);
 
 	return err;
 }
 
-static int omap_bandgap_resume(struct device *dev)
+static int ti_bandgap_resume(struct device *dev)
 {
-	struct omap_bandgap *bgp = dev_get_drvdata(dev);
+	struct ti_bandgap *bgp = dev_get_drvdata(dev);
 
-	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+	if (TI_BANDGAP_HAS(bgp, CLK_CTRL))
 		clk_prepare_enable(bgp->fclock);
 
-	omap_bandgap_power(bgp, true);
+	ti_bandgap_power(bgp, true);
 
-	return omap_bandgap_restore_ctxt(bgp);
+	return ti_bandgap_restore_ctxt(bgp);
 }
-static const struct dev_pm_ops omap_bandgap_dev_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(omap_bandgap_suspend,
-				omap_bandgap_resume)
+static const struct dev_pm_ops ti_bandgap_dev_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(ti_bandgap_suspend,
+				ti_bandgap_resume)
 };
 
-#define DEV_PM_OPS	(&omap_bandgap_dev_pm_ops)
+#define DEV_PM_OPS	(&ti_bandgap_dev_pm_ops)
 #else
 #define DEV_PM_OPS	NULL
 #endif
 
-static const struct of_device_id of_omap_bandgap_match[] = {
+static const struct of_device_id of_ti_bandgap_match[] = {
 #ifdef CONFIG_OMAP4_THERMAL
 	{
 		.compatible = "ti,omap4430-bandgap",
@@ -1278,21 +1270,21 @@ static const struct of_device_id of_omap_bandgap_match[] = {
 	/* Sentinel */
 	{ },
 };
-MODULE_DEVICE_TABLE(of, of_omap_bandgap_match);
+MODULE_DEVICE_TABLE(of, of_ti_bandgap_match);
 
-static struct platform_driver omap_bandgap_sensor_driver = {
-	.probe = omap_bandgap_probe,
-	.remove = omap_bandgap_remove,
+static struct platform_driver ti_bandgap_sensor_driver = {
+	.probe = ti_bandgap_probe,
+	.remove = ti_bandgap_remove,
 	.driver = {
-			.name = "omap-bandgap",
+			.name = "ti-soc-thermal",
 			.pm = DEV_PM_OPS,
-			.of_match_table	= of_omap_bandgap_match,
+			.of_match_table	= of_ti_bandgap_match,
 	},
 };
 
-module_platform_driver(omap_bandgap_sensor_driver);
+module_platform_driver(ti_bandgap_sensor_driver);
 
 MODULE_DESCRIPTION("OMAP4+ bandgap temperature sensor driver");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS("platform:omap-bandgap");
+MODULE_ALIAS("platform:ti-soc-thermal");
 MODULE_AUTHOR("Texas Instrument Inc.");
diff --git a/drivers/staging/ti-soc-thermal/ti-bandgap.h b/drivers/staging/ti-soc-thermal/ti-bandgap.h
index ad83be8..72c760f 100644
--- a/drivers/staging/ti-soc-thermal/ti-bandgap.h
+++ b/drivers/staging/ti-soc-thermal/ti-bandgap.h
@@ -20,8 +20,8 @@
  * 02110-1301 USA
  *
  */
-#ifndef __OMAP_BANDGAP_H
-#define __OMAP_BANDGAP_H
+#ifndef __TI_BANDGAP_H
+#define __TI_BANDGAP_H
 
 #include <linux/spinlock.h>
 #include <linux/types.h>
@@ -30,22 +30,22 @@
 /**
  * DOC: bandgap driver data structure
  * ==================================
- *   +---------------------+   +-----------------+
- *   | struct omap_bandgap |-->| struct device * |
- *   +----------+----------+   +-----------------+
+ *   +-------------------+   +-----------------+
+ *   | struct ti_bandgap |-->| struct device * |
+ *   +----------+--------+   +-----------------+
  *              |
  *              |
  *              V
- *   +--------------------------+
- *   | struct omap_bandgap_data |
- *   +--------------------------+
+ *   +------------------------+
+ *   | struct ti_bandgap_data |
+ *   +------------------------+
  *              |
  *              |
  *              * (Array of)
  * +------------+------------------------------------------------------+
- * | +----------+--------------+   +-------------------------+         |
- * | | struct omap_temp_sensor |-->| struct temp_sensor_data |         |
- * | +-------------------------+   +------------+------------+         |
+ * | +----------+------------+   +-------------------------+           |
+ * | | struct ti_temp_sensor |-->| struct temp_sensor_data |           |
+ * | +-----------------------+   +------------+------------+           |
  * |            |                                                      |
  * |            +--------------------------+                           |
  * |            V                          V                           |
@@ -56,7 +56,7 @@
  * +-------------------------------------------------------------------+
  *
  * Above is a simple diagram describing how the data structure below
- * are organized. For each bandgap device there should be a omap_bandgap_data
+ * are organized. For each bandgap device there should be a ti_bandgap_data
  * containing the device instance configuration, as well as, an array of
  * sensors, representing every sensor instance present in this bandgap.
  */
@@ -187,16 +187,16 @@ struct temp_sensor_data {
 	u32     update_int2; /* not used */
 };
 
-struct omap_bandgap_data;
+struct ti_bandgap_data;
 
 /**
- * struct omap_bandgap - bandgap device structure
+ * struct ti_bandgap - bandgap device structure
  * @dev: struct device pointer
  * @base: io memory base address
  * @conf: struct with bandgap configuration set (# sensors, conv_table, etc)
  * @fclock: pointer to functional clock of temperature sensor
  * @div_clk: pointer to divider clock of temperature sensor fclk
- * @bg_mutex: mutex for omap_bandgap structure
+ * @bg_mutex: mutex for ti_bandgap structure
  * @irq: MPU IRQ number for thermal alert
  * @tshut_gpio: GPIO where Tshut signal is routed
  * @clk_rate: Holds current clock rate
@@ -205,10 +205,10 @@ struct omap_bandgap_data;
  * It holds most of the dynamic stuff. Configurations and sensor specific
  * entries are inside the @conf structure.
  */
-struct omap_bandgap {
+struct ti_bandgap {
 	struct device			*dev;
 	void __iomem			*base;
-	struct omap_bandgap_data	*conf;
+	struct ti_bandgap_data		*conf;
 	struct clk			*fclock;
 	struct clk			*div_clk;
 	spinlock_t			lock; /* shields this struct */
@@ -237,7 +237,7 @@ struct temp_sensor_regval {
 };
 
 /**
- * struct omap_temp_sensor - bandgap temperature sensor configuration data
+ * struct ti_temp_sensor - bandgap temperature sensor configuration data
  * @ts_data: pointer to struct with thresholds, limits of temperature sensor
  * @registers: pointer to the list of register offsets and bitfields
  * @regval: temperature sensor register values
@@ -258,7 +258,7 @@ struct temp_sensor_regval {
  * assess the gradient from hotspot, how to cooldown the domain when sensor
  * reports too hot temperature.
  */
-struct omap_temp_sensor {
+struct ti_temp_sensor {
 	struct temp_sensor_data		*ts_data;
 	struct temp_sensor_registers	*registers;
 	struct temp_sensor_regval	regval;
@@ -269,56 +269,56 @@ struct omap_temp_sensor {
 	const int			slope_pcb;
 	const int			constant_pcb;
 	void				*data;
-	int (*register_cooling)(struct omap_bandgap *bgp, int id);
-	int (*unregister_cooling)(struct omap_bandgap *bgp, int id);
+	int (*register_cooling)(struct ti_bandgap *bgp, int id);
+	int (*unregister_cooling)(struct ti_bandgap *bgp, int id);
 };
 
 /**
  * DOC: omap bandgap feature types
  *
- * OMAP_BANDGAP_FEATURE_TSHUT - used when the thermal shutdown signal output
+ * TI_BANDGAP_FEATURE_TSHUT - used when the thermal shutdown signal output
  *      of a bandgap device instance is routed to the processor. This means
  *      the system must react and perform the shutdown by itself (handle an
  *      IRQ, for instance).
  *
- * OMAP_BANDGAP_FEATURE_TSHUT_CONFIG - used when the bandgap device has control
+ * TI_BANDGAP_FEATURE_TSHUT_CONFIG - used when the bandgap device has control
  *      over the thermal shutdown configuration. This means that the thermal
  *      shutdown thresholds are programmable, for instance.
  *
- * OMAP_BANDGAP_FEATURE_TALERT - used when the bandgap device instance outputs
+ * TI_BANDGAP_FEATURE_TALERT - used when the bandgap device instance outputs
  *      a signal representing violation of programmable alert thresholds.
  *
- * OMAP_BANDGAP_FEATURE_MODE_CONFIG - used when it is possible to choose which
+ * TI_BANDGAP_FEATURE_MODE_CONFIG - used when it is possible to choose which
  *      mode, continuous or one shot, the bandgap device instance will operate.
  *
- * OMAP_BANDGAP_FEATURE_COUNTER - used when the bandgap device instance allows
+ * TI_BANDGAP_FEATURE_COUNTER - used when the bandgap device instance allows
  *      programming the update interval of its internal state machine.
  *
- * OMAP_BANDGAP_FEATURE_POWER_SWITCH - used when the bandgap device allows
+ * TI_BANDGAP_FEATURE_POWER_SWITCH - used when the bandgap device allows
  *      itself to be switched on/off.
  *
- * OMAP_BANDGAP_FEATURE_CLK_CTRL - used when the clocks feeding the bandgap
+ * TI_BANDGAP_FEATURE_CLK_CTRL - used when the clocks feeding the bandgap
  *      device are gateable or not.
  *
- * OMAP_BANDGAP_FEATURE_FREEZE_BIT - used when the bandgap device features
+ * TI_BANDGAP_FEATURE_FREEZE_BIT - used when the bandgap device features
  *      a history buffer that its update can be freezed/unfreezed.
  *
- * OMAP_BANDGAP_HAS(b, f) - macro to check if a bandgap device is capable of a
+ * TI_BANDGAP_HAS(b, f) - macro to check if a bandgap device is capable of a
  *      specific feature (above) or not. Return non-zero, if yes.
  */
-#define OMAP_BANDGAP_FEATURE_TSHUT		BIT(0)
-#define OMAP_BANDGAP_FEATURE_TSHUT_CONFIG	BIT(1)
-#define OMAP_BANDGAP_FEATURE_TALERT		BIT(2)
-#define OMAP_BANDGAP_FEATURE_MODE_CONFIG	BIT(3)
-#define OMAP_BANDGAP_FEATURE_COUNTER		BIT(4)
-#define OMAP_BANDGAP_FEATURE_POWER_SWITCH	BIT(5)
-#define OMAP_BANDGAP_FEATURE_CLK_CTRL		BIT(6)
-#define OMAP_BANDGAP_FEATURE_FREEZE_BIT		BIT(7)
-#define OMAP_BANDGAP_HAS(b, f)			\
-			((b)->conf->features & OMAP_BANDGAP_FEATURE_ ## f)
+#define TI_BANDGAP_FEATURE_TSHUT		BIT(0)
+#define TI_BANDGAP_FEATURE_TSHUT_CONFIG		BIT(1)
+#define TI_BANDGAP_FEATURE_TALERT		BIT(2)
+#define TI_BANDGAP_FEATURE_MODE_CONFIG		BIT(3)
+#define TI_BANDGAP_FEATURE_COUNTER		BIT(4)
+#define TI_BANDGAP_FEATURE_POWER_SWITCH		BIT(5)
+#define TI_BANDGAP_FEATURE_CLK_CTRL		BIT(6)
+#define TI_BANDGAP_FEATURE_FREEZE_BIT		BIT(7)
+#define TI_BANDGAP_HAS(b, f)			\
+			((b)->conf->features & TI_BANDGAP_FEATURE_ ## f)
 
 /**
- * struct omap_bandgap_data - omap bandgap data configuration structure
+ * struct ti_bandgap_data - omap bandgap data configuration structure
  * @features: a bitwise flag set to describe the device features
  * @conv_table: Pointer to ADC to temperature conversion table
  * @adc_start_val: ADC conversion table starting value
@@ -337,7 +337,7 @@ struct omap_temp_sensor {
  * their configuration representation, and how to export and unexport them to
  * a thermal API.
  */
-struct omap_bandgap_data {
+struct ti_bandgap_data {
 	unsigned int			features;
 	const int			*conv_table;
 	u32				adc_start_val;
@@ -345,32 +345,31 @@ struct omap_bandgap_data {
 	char				*fclock_name;
 	char				*div_ck_name;
 	int				sensor_count;
-	int (*report_temperature)(struct omap_bandgap *bgp, int id);
-	int (*expose_sensor)(struct omap_bandgap *bgp, int id, char *domain);
-	int (*remove_sensor)(struct omap_bandgap *bgp, int id);
+	int (*report_temperature)(struct ti_bandgap *bgp, int id);
+	int (*expose_sensor)(struct ti_bandgap *bgp, int id, char *domain);
+	int (*remove_sensor)(struct ti_bandgap *bgp, int id);
 
 	/* this needs to be at the end */
-	struct omap_temp_sensor		sensors[];
+	struct ti_temp_sensor		sensors[];
 };
 
-int omap_bandgap_read_thot(struct omap_bandgap *bgp, int id, int *thot);
-int omap_bandgap_write_thot(struct omap_bandgap *bgp, int id, int val);
-int omap_bandgap_read_tcold(struct omap_bandgap *bgp, int id, int *tcold);
-int omap_bandgap_write_tcold(struct omap_bandgap *bgp, int id, int val);
-int omap_bandgap_read_update_interval(struct omap_bandgap *bgp, int id,
-				      int *interval);
-int omap_bandgap_write_update_interval(struct omap_bandgap *bgp, int id,
-				       u32 interval);
-int omap_bandgap_read_temperature(struct omap_bandgap *bgp, int id,
+int ti_bandgap_read_thot(struct ti_bandgap *bgp, int id, int *thot);
+int ti_bandgap_write_thot(struct ti_bandgap *bgp, int id, int val);
+int ti_bandgap_read_tcold(struct ti_bandgap *bgp, int id, int *tcold);
+int ti_bandgap_write_tcold(struct ti_bandgap *bgp, int id, int val);
+int ti_bandgap_read_update_interval(struct ti_bandgap *bgp, int id,
+				    int *interval);
+int ti_bandgap_write_update_interval(struct ti_bandgap *bgp, int id,
+				     u32 interval);
+int ti_bandgap_read_temperature(struct ti_bandgap *bgp, int id,
 				  int *temperature);
-int omap_bandgap_set_sensor_data(struct omap_bandgap *bgp, int id,
-				 void *data);
-void *omap_bandgap_get_sensor_data(struct omap_bandgap *bgp, int id);
+int ti_bandgap_set_sensor_data(struct ti_bandgap *bgp, int id, void *data);
+void *ti_bandgap_get_sensor_data(struct ti_bandgap *bgp, int id);
 
 #ifdef CONFIG_OMAP4_THERMAL
-extern const struct omap_bandgap_data omap4430_data;
-extern const struct omap_bandgap_data omap4460_data;
-extern const struct omap_bandgap_data omap4470_data;
+extern const struct ti_bandgap_data omap4430_data;
+extern const struct ti_bandgap_data omap4460_data;
+extern const struct ti_bandgap_data omap4470_data;
 #else
 #define omap4430_data					NULL
 #define omap4460_data					NULL
@@ -378,7 +377,7 @@ extern const struct omap_bandgap_data omap4470_data;
 #endif
 
 #ifdef CONFIG_OMAP5_THERMAL
-extern const struct omap_bandgap_data omap5430_data;
+extern const struct ti_bandgap_data omap5430_data;
 #else
 #define omap5430_data					NULL
 #endif
diff --git a/drivers/staging/ti-soc-thermal/ti-thermal-common.c b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
index feab2f4..fb50e7e 100644
--- a/drivers/staging/ti-soc-thermal/ti-thermal-common.c
+++ b/drivers/staging/ti-soc-thermal/ti-thermal-common.c
@@ -36,33 +36,33 @@
 #include "ti-bandgap.h"
 
 /* common data structures */
-struct omap_thermal_data {
-	struct thermal_zone_device *omap_thermal;
+struct ti_thermal_data {
+	struct thermal_zone_device *ti_thermal;
 	struct thermal_cooling_device *cool_dev;
-	struct omap_bandgap *bgp;
+	struct ti_bandgap *bgp;
 	enum thermal_device_mode mode;
 	struct work_struct thermal_wq;
 	int sensor_id;
 };
 
-static void omap_thermal_work(struct work_struct *work)
+static void ti_thermal_work(struct work_struct *work)
 {
-	struct omap_thermal_data *data = container_of(work,
-					struct omap_thermal_data, thermal_wq);
+	struct ti_thermal_data *data = container_of(work,
+					struct ti_thermal_data, thermal_wq);
 
-	thermal_zone_device_update(data->omap_thermal);
+	thermal_zone_device_update(data->ti_thermal);
 
-	dev_dbg(&data->omap_thermal->device, "updated thermal zone %s\n",
-		data->omap_thermal->type);
+	dev_dbg(&data->ti_thermal->device, "updated thermal zone %s\n",
+		data->ti_thermal->type);
 }
 
 /**
- * omap_thermal_hotspot_temperature - returns sensor extrapolated temperature
+ * ti_thermal_hotspot_temperature - returns sensor extrapolated temperature
  * @t:	omap sensor temperature
  * @s:	omap sensor slope value
  * @c:	omap sensor const value
  */
-static inline int omap_thermal_hotspot_temperature(int t, int s, int c)
+static inline int ti_thermal_hotspot_temperature(int t, int s, int c)
 {
 	int delta = t * s / 1000 + c;
 
@@ -74,12 +74,12 @@ static inline int omap_thermal_hotspot_temperature(int t, int s, int c)
 
 /* thermal zone ops */
 /* Get temperature callback function for thermal zone*/
-static inline int omap_thermal_get_temp(struct thermal_zone_device *thermal,
-					 unsigned long *temp)
+static inline int ti_thermal_get_temp(struct thermal_zone_device *thermal,
+				      unsigned long *temp)
 {
-	struct omap_thermal_data *data = thermal->devdata;
-	struct omap_bandgap *bgp;
-	struct omap_temp_sensor *s;
+	struct ti_thermal_data *data = thermal->devdata;
+	struct ti_bandgap *bgp;
+	struct ti_temp_sensor *s;
 	int ret, tmp, pcb_temp, slope, constant;
 
 	if (!data)
@@ -88,7 +88,7 @@ static inline int omap_thermal_get_temp(struct thermal_zone_device *thermal,
 	bgp = data->bgp;
 	s = &bgp->conf->sensors[data->sensor_id];
 
-	ret = omap_bandgap_read_temperature(bgp, data->sensor_id, &tmp);
+	ret = ti_bandgap_read_temperature(bgp, data->sensor_id, &tmp);
 	if (ret)
 		return ret;
 
@@ -103,16 +103,16 @@ static inline int omap_thermal_get_temp(struct thermal_zone_device *thermal,
 		slope = s->slope;
 		constant = s->constant;
 	}
-	*temp = omap_thermal_hotspot_temperature(tmp, slope, constant);
+	*temp = ti_thermal_hotspot_temperature(tmp, slope, constant);
 
 	return ret;
 }
 
 /* Bind callback functions for thermal zone */
-static int omap_thermal_bind(struct thermal_zone_device *thermal,
-			      struct thermal_cooling_device *cdev)
+static int ti_thermal_bind(struct thermal_zone_device *thermal,
+			   struct thermal_cooling_device *cdev)
 {
-	struct omap_thermal_data *data = thermal->devdata;
+	struct ti_thermal_data *data = thermal->devdata;
 	int id;
 
 	if (IS_ERR_OR_NULL(data))
@@ -132,10 +132,10 @@ static int omap_thermal_bind(struct thermal_zone_device *thermal,
 }
 
 /* Unbind callback functions for thermal zone */
-static int omap_thermal_unbind(struct thermal_zone_device *thermal,
-				struct thermal_cooling_device *cdev)
+static int ti_thermal_unbind(struct thermal_zone_device *thermal,
+			     struct thermal_cooling_device *cdev)
 {
-	struct omap_thermal_data *data = thermal->devdata;
+	struct ti_thermal_data *data = thermal->devdata;
 
 	if (IS_ERR_OR_NULL(data))
 		return -ENODEV;
@@ -149,10 +149,10 @@ static int omap_thermal_unbind(struct thermal_zone_device *thermal,
 }
 
 /* Get mode callback functions for thermal zone */
-static int omap_thermal_get_mode(struct thermal_zone_device *thermal,
-				  enum thermal_device_mode *mode)
+static int ti_thermal_get_mode(struct thermal_zone_device *thermal,
+			       enum thermal_device_mode *mode)
 {
-	struct omap_thermal_data *data = thermal->devdata;
+	struct ti_thermal_data *data = thermal->devdata;
 
 	if (data)
 		*mode = data->mode;
@@ -161,38 +161,38 @@ static int omap_thermal_get_mode(struct thermal_zone_device *thermal,
 }
 
 /* Set mode callback functions for thermal zone */
-static int omap_thermal_set_mode(struct thermal_zone_device *thermal,
-				  enum thermal_device_mode mode)
+static int ti_thermal_set_mode(struct thermal_zone_device *thermal,
+			       enum thermal_device_mode mode)
 {
-	struct omap_thermal_data *data = thermal->devdata;
+	struct ti_thermal_data *data = thermal->devdata;
 
-	if (!data->omap_thermal) {
+	if (!data->ti_thermal) {
 		dev_notice(&thermal->device, "thermal zone not registered\n");
 		return 0;
 	}
 
-	mutex_lock(&data->omap_thermal->lock);
+	mutex_lock(&data->ti_thermal->lock);
 
 	if (mode == THERMAL_DEVICE_ENABLED)
-		data->omap_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
+		data->ti_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
 	else
-		data->omap_thermal->polling_delay = 0;
+		data->ti_thermal->polling_delay = 0;
 
-	mutex_unlock(&data->omap_thermal->lock);
+	mutex_unlock(&data->ti_thermal->lock);
 
 	data->mode = mode;
-	thermal_zone_device_update(data->omap_thermal);
+	thermal_zone_device_update(data->ti_thermal);
 	dev_dbg(&thermal->device, "thermal polling set for duration=%d msec\n",
-		data->omap_thermal->polling_delay);
+		data->ti_thermal->polling_delay);
 
 	return 0;
 }
 
 /* Get trip type callback functions for thermal zone */
-static int omap_thermal_get_trip_type(struct thermal_zone_device *thermal,
-				       int trip, enum thermal_trip_type *type)
+static int ti_thermal_get_trip_type(struct thermal_zone_device *thermal,
+				    int trip, enum thermal_trip_type *type)
 {
-	if (!omap_thermal_is_valid_trip(trip))
+	if (!ti_thermal_is_valid_trip(trip))
 		return -EINVAL;
 
 	if (trip + 1 == OMAP_TRIP_NUMBER)
@@ -204,41 +204,41 @@ static int omap_thermal_get_trip_type(struct thermal_zone_device *thermal,
 }
 
 /* Get trip temperature callback functions for thermal zone */
-static int omap_thermal_get_trip_temp(struct thermal_zone_device *thermal,
-				       int trip, unsigned long *temp)
+static int ti_thermal_get_trip_temp(struct thermal_zone_device *thermal,
+				    int trip, unsigned long *temp)
 {
-	if (!omap_thermal_is_valid_trip(trip))
+	if (!ti_thermal_is_valid_trip(trip))
 		return -EINVAL;
 
-	*temp = omap_thermal_get_trip_value(trip);
+	*temp = ti_thermal_get_trip_value(trip);
 
 	return 0;
 }
 
 /* Get critical temperature callback functions for thermal zone */
-static int omap_thermal_get_crit_temp(struct thermal_zone_device *thermal,
-				       unsigned long *temp)
+static int ti_thermal_get_crit_temp(struct thermal_zone_device *thermal,
+				    unsigned long *temp)
 {
 	/* shutdown zone */
-	return omap_thermal_get_trip_temp(thermal, OMAP_TRIP_NUMBER - 1, temp);
+	return ti_thermal_get_trip_temp(thermal, OMAP_TRIP_NUMBER - 1, temp);
 }
 
-static struct thermal_zone_device_ops omap_thermal_ops = {
-	.get_temp = omap_thermal_get_temp,
+static struct thermal_zone_device_ops ti_thermal_ops = {
+	.get_temp = ti_thermal_get_temp,
 	/* TODO: add .get_trend */
-	.bind = omap_thermal_bind,
-	.unbind = omap_thermal_unbind,
-	.get_mode = omap_thermal_get_mode,
-	.set_mode = omap_thermal_set_mode,
-	.get_trip_type = omap_thermal_get_trip_type,
-	.get_trip_temp = omap_thermal_get_trip_temp,
-	.get_crit_temp = omap_thermal_get_crit_temp,
+	.bind = ti_thermal_bind,
+	.unbind = ti_thermal_unbind,
+	.get_mode = ti_thermal_get_mode,
+	.set_mode = ti_thermal_set_mode,
+	.get_trip_type = ti_thermal_get_trip_type,
+	.get_trip_temp = ti_thermal_get_trip_temp,
+	.get_crit_temp = ti_thermal_get_crit_temp,
 };
 
-static struct omap_thermal_data
-*omap_thermal_build_data(struct omap_bandgap *bgp, int id)
+static struct ti_thermal_data
+*ti_thermal_build_data(struct ti_bandgap *bgp, int id)
 {
-	struct omap_thermal_data *data;
+	struct ti_thermal_data *data;
 
 	data = devm_kzalloc(bgp->dev, sizeof(*data), GFP_KERNEL);
 	if (!data) {
@@ -248,69 +248,69 @@ static struct omap_thermal_data
 	data->sensor_id = id;
 	data->bgp = bgp;
 	data->mode = THERMAL_DEVICE_ENABLED;
-	INIT_WORK(&data->thermal_wq, omap_thermal_work);
+	INIT_WORK(&data->thermal_wq, ti_thermal_work);
 
 	return data;
 }
 
-int omap_thermal_expose_sensor(struct omap_bandgap *bgp, int id,
-			       char *domain)
+int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id,
+			     char *domain)
 {
-	struct omap_thermal_data *data;
+	struct ti_thermal_data *data;
 
-	data = omap_bandgap_get_sensor_data(bgp, id);
+	data = ti_bandgap_get_sensor_data(bgp, id);
 
 	if (IS_ERR_OR_NULL(data))
-		data = omap_thermal_build_data(bgp, id);
+		data = ti_thermal_build_data(bgp, id);
 
 	if (!data)
 		return -EINVAL;
 
 	/* TODO: remove TC1 TC2 */
 	/* Create thermal zone */
-	data->omap_thermal = thermal_zone_device_register(domain,
-				OMAP_TRIP_NUMBER, 0, data, &omap_thermal_ops,
+	data->ti_thermal = thermal_zone_device_register(domain,
+				OMAP_TRIP_NUMBER, 0, data, &ti_thermal_ops,
 				NULL, FAST_TEMP_MONITORING_RATE,
 				FAST_TEMP_MONITORING_RATE);
-	if (IS_ERR_OR_NULL(data->omap_thermal)) {
+	if (IS_ERR_OR_NULL(data->ti_thermal)) {
 		dev_err(bgp->dev, "thermal zone device is NULL\n");
-		return PTR_ERR(data->omap_thermal);
+		return PTR_ERR(data->ti_thermal);
 	}
-	data->omap_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
-	omap_bandgap_set_sensor_data(bgp, id, data);
+	data->ti_thermal->polling_delay = FAST_TEMP_MONITORING_RATE;
+	ti_bandgap_set_sensor_data(bgp, id, data);
 
 	return 0;
 }
 
-int omap_thermal_remove_sensor(struct omap_bandgap *bgp, int id)
+int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
 {
-	struct omap_thermal_data *data;
+	struct ti_thermal_data *data;
 
-	data = omap_bandgap_get_sensor_data(bgp, id);
+	data = ti_bandgap_get_sensor_data(bgp, id);
 
-	thermal_zone_device_unregister(data->omap_thermal);
+	thermal_zone_device_unregister(data->ti_thermal);
 
 	return 0;
 }
 
-int omap_thermal_report_sensor_temperature(struct omap_bandgap *bgp, int id)
+int ti_thermal_report_sensor_temperature(struct ti_bandgap *bgp, int id)
 {
-	struct omap_thermal_data *data;
+	struct ti_thermal_data *data;
 
-	data = omap_bandgap_get_sensor_data(bgp, id);
+	data = ti_bandgap_get_sensor_data(bgp, id);
 
 	schedule_work(&data->thermal_wq);
 
 	return 0;
 }
 
-int omap_thermal_register_cpu_cooling(struct omap_bandgap *bgp, int id)
+int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
 {
-	struct omap_thermal_data *data;
+	struct ti_thermal_data *data;
 
-	data = omap_bandgap_get_sensor_data(bgp, id);
+	data = ti_bandgap_get_sensor_data(bgp, id);
 	if (IS_ERR_OR_NULL(data))
-		data = omap_thermal_build_data(bgp, id);
+		data = ti_thermal_build_data(bgp, id);
 
 	if (!data)
 		return -EINVAL;
@@ -322,16 +322,16 @@ int omap_thermal_register_cpu_cooling(struct omap_bandgap *bgp, int id)
 			"Failed to register cpufreq cooling device\n");
 		return PTR_ERR(data->cool_dev);
 	}
-	omap_bandgap_set_sensor_data(bgp, id, data);
+	ti_bandgap_set_sensor_data(bgp, id, data);
 
 	return 0;
 }
 
-int omap_thermal_unregister_cpu_cooling(struct omap_bandgap *bgp, int id)
+int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id)
 {
-	struct omap_thermal_data *data;
+	struct ti_thermal_data *data;
 
-	data = omap_bandgap_get_sensor_data(bgp, id);
+	data = ti_bandgap_get_sensor_data(bgp, id);
 	cpufreq_cooling_unregister(data->cool_dev);
 
 	return 0;
diff --git a/drivers/staging/ti-soc-thermal/ti-thermal.h b/drivers/staging/ti-soc-thermal/ti-thermal.h
index 3ed4adb..ef6981c 100644
--- a/drivers/staging/ti-soc-thermal/ti-thermal.h
+++ b/drivers/staging/ti-soc-thermal/ti-thermal.h
@@ -60,47 +60,45 @@
 
 /* helper macros */
 /**
- * omap_thermal_get_trip_value - returns trip temperature based on index
+ * ti_thermal_get_trip_value - returns trip temperature based on index
  * @i:	trip index
  */
-#define omap_thermal_get_trip_value(i)					\
+#define ti_thermal_get_trip_value(i)					\
 	(OMAP_TRIP_HOT + ((i) * OMAP_TRIP_STEP))
 
 /**
- * omap_thermal_is_valid_trip - check for trip index
+ * ti_thermal_is_valid_trip - check for trip index
  * @i:	trip index
  */
-#define omap_thermal_is_valid_trip(trip)				\
+#define ti_thermal_is_valid_trip(trip)				\
 	((trip) >= 0 && (trip) < OMAP_TRIP_NUMBER)
 
 #ifdef CONFIG_TI_THERMAL
-int omap_thermal_expose_sensor(struct omap_bandgap *bgp, int id,
-			       char *domain);
-int omap_thermal_remove_sensor(struct omap_bandgap *bgp, int id);
-int omap_thermal_register_cpu_cooling(struct omap_bandgap *bgp, int id);
-int omap_thermal_unregister_cpu_cooling(struct omap_bandgap *bgp, int id);
+int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id, char *domain);
+int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id);
+int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id);
+int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id);
 #else
 static inline
-int omap_thermal_expose_sensor(struct omap_bandgap *bgp, int id,
-			       char *domain)
+int ti_thermal_expose_sensor(struct ti_bandgap *bgp, int id, char *domain)
 {
 	return 0;
 }
 
 static inline
-int omap_thermal_remove_sensor(struct omap_bandgap *bgp, int id)
+int ti_thermal_remove_sensor(struct ti_bandgap *bgp, int id)
 {
 	return 0;
 }
 
 static inline
-int omap_thermal_register_cpu_cooling(struct omap_bandgap *bgp, int id)
+int ti_thermal_register_cpu_cooling(struct ti_bandgap *bgp, int id)
 {
 	return 0;
 }
 
 static inline
-int omap_thermal_unregister_cpu_cooling(struct omap_bandgap *bgp, int id)
+int ti_thermal_unregister_cpu_cooling(struct ti_bandgap *bgp, int id)
 {
 	return 0;
 }
-- 
1.7.7.1.488.ge8e1c

