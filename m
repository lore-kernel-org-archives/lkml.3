Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3CRPBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:01:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43739 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989Ab3CRPBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:01:10 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>, Benoit <b-cousson@ti.com>
Subject: [PATCH 3/8] staging: omap-thermal: rename bg_ptr to bgp
Date: Mon, 18 Mar 2013 10:59:11 -0400
Message-ID: <1363618756-15851-4-git-send-email-eduardo.valentin@ti.com>
X-Mailer: git-send-email 1.7.7.1.488.ge8e1c
In-Reply-To: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
References: <1363618756-15851-1-git-send-email-eduardo.valentin@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a shorter name to bandgap pointer.

Cc: Benoit <b-cousson@ti.com>

Signed-off-by: Eduardo Valentin <eduardo.valentin@ti.com>

diff --git a/drivers/staging/omap-thermal/omap-bandgap.c b/drivers/staging/omap-thermal/omap-bandgap.c
index a4ac06c..89361fe 100644
--- a/drivers/staging/omap-thermal/omap-bandgap.c
+++ b/drivers/staging/omap-thermal/omap-bandgap.c
@@ -46,28 +46,28 @@
 
 /**
  * omap_bandgap_readl() - simple read helper function
- * @bg_ptr: pointer to omap_bandgap structure
+ * @bgp: pointer to omap_bandgap structure
  * @reg: desired register (offset) to be read
  *
  * Helper function to read bandgap registers. It uses the io remapped area.
  * Returns the register value.
  */
-static u32 omap_bandgap_readl(struct omap_bandgap *bg_ptr, u32 reg)
+static u32 omap_bandgap_readl(struct omap_bandgap *bgp, u32 reg)
 {
-	return readl(bg_ptr->base + reg);
+	return readl(bgp->base + reg);
 }
 
 /**
  * omap_bandgap_writel() - simple write helper function
- * @bg_ptr: pointer to omap_bandgap structure
+ * @bgp: pointer to omap_bandgap structure
  * @val: desired register value to be written
  * @reg: desired register (offset) to be written
  *
  * Helper function to write bandgap registers. It uses the io remapped area.
  */
-static void omap_bandgap_writel(struct omap_bandgap *bg_ptr, u32 val, u32 reg)
+static void omap_bandgap_writel(struct omap_bandgap *bgp, u32 val, u32 reg)
 {
-	writel(val, bg_ptr->base + reg);
+	writel(val, bgp->base + reg);
 }
 
 /**
@@ -76,38 +76,38 @@ static void omap_bandgap_writel(struct omap_bandgap *bg_ptr, u32 val, u32 reg)
  * RMW_BITS() - used to read, modify and update bandgap bitfields.
  *            The value passed will be shifted.
  */
-#define RMW_BITS(bg_ptr, id, reg, mask, val)			\
+#define RMW_BITS(bgp, id, reg, mask, val)			\
 do {								\
 	struct temp_sensor_registers *t;			\
 	u32 r;							\
 								\
-	t = bg_ptr->conf->sensors[(id)].registers;		\
-	r = omap_bandgap_readl(bg_ptr, t->reg);			\
+	t = bgp->conf->sensors[(id)].registers;		\
+	r = omap_bandgap_readl(bgp, t->reg);			\
 	r &= ~t->mask;						\
 	r |= (val) << __ffs(t->mask);				\
-	omap_bandgap_writel(bg_ptr, r, t->reg);			\
+	omap_bandgap_writel(bgp, r, t->reg);			\
 } while (0)
 
 /***   Basic helper functions   ***/
 
 /**
  * omap_bandgap_power() - controls the power state of a bandgap device
- * @bg_ptr: pointer to omap_bandgap structure
+ * @bgp: pointer to omap_bandgap structure
  * @on: desired power state (1 - on, 0 - off)
  *
  * Used to power on/off a bandgap device instance. Only used on those
  * that features tempsoff bit.
  */
-static int omap_bandgap_power(struct omap_bandgap *bg_ptr, bool on)
+static int omap_bandgap_power(struct omap_bandgap *bgp, bool on)
 {
 	int i;
 
-	if (!OMAP_BANDGAP_HAS(bg_ptr, POWER_SWITCH))
+	if (!OMAP_BANDGAP_HAS(bgp, POWER_SWITCH))
 		goto exit;
 
-	for (i = 0; i < bg_ptr->conf->sensor_count; i++)
+	for (i = 0; i < bgp->conf->sensor_count; i++)
 		/* active on 0 */
-		RMW_BITS(bg_ptr, i, temp_sensor_ctrl, bgap_tempsoff_mask, !on);
+		RMW_BITS(bgp, i, temp_sensor_ctrl, bgap_tempsoff_mask, !on);
 
 exit:
 	return 0;
@@ -115,7 +115,7 @@ exit:
 
 /**
  * omap_bandgap_read_temp() - helper function to read sensor temperature
- * @bg_ptr: pointer to omap_bandgap structure
+ * @bgp: pointer to omap_bandgap structure
  * @id: bandgap sensor id
  *
  * Function to concentrate the steps to read sensor temperature register.
@@ -123,16 +123,16 @@ exit:
  * it might be needed to freeze the bandgap state machine, before fetching
  * the register value.
  */
-static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
+static u32 omap_bandgap_read_temp(struct omap_bandgap *bgp, int id)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, reg;
 
-	tsr = bg_ptr->conf->sensors[id].registers;
+	tsr = bgp->conf->sensors[id].registers;
 	reg = tsr->temp_sensor_ctrl;
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, FREEZE_BIT)) {
-		RMW_BITS(bg_ptr, id, bgap_mask_ctrl, mask_freeze_mask, 1);
+	if (OMAP_BANDGAP_HAS(bgp, FREEZE_BIT)) {
+		RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 1);
 		/*
 		 * In case we cannot read from cur_dtemp / dtemp_0,
 		 * then we read from the last valid temp read
@@ -141,11 +141,11 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
 	}
 
 	/* read temperature */
-	temp = omap_bandgap_readl(bg_ptr, reg);
+	temp = omap_bandgap_readl(bgp, reg);
 	temp &= tsr->bgap_dtemp_mask;
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, FREEZE_BIT))
-		RMW_BITS(bg_ptr, id, bgap_mask_ctrl, mask_freeze_mask, 0);
+	if (OMAP_BANDGAP_HAS(bgp, FREEZE_BIT))
+		RMW_BITS(bgp, id, bgap_mask_ctrl, mask_freeze_mask, 0);
 
 	return temp;
 }
@@ -165,16 +165,16 @@ static u32 omap_bandgap_read_temp(struct omap_bandgap *bg_ptr, int id)
  */
 static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 {
-	struct omap_bandgap *bg_ptr = data;
+	struct omap_bandgap *bgp = data;
 	struct temp_sensor_registers *tsr;
 	u32 t_hot = 0, t_cold = 0, ctrl;
 	unsigned long flags;
 	int i;
 
-	spin_lock_irqsave(&bg_ptr->lock, flags);
-	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
-		tsr = bg_ptr->conf->sensors[i].registers;
-		ctrl = omap_bandgap_readl(bg_ptr, tsr->bgap_status);
+	spin_lock_irqsave(&bgp->lock, flags);
+	for (i = 0; i < bgp->conf->sensor_count; i++) {
+		tsr = bgp->conf->sensors[i].registers;
+		ctrl = omap_bandgap_readl(bgp, tsr->bgap_status);
 
 		/* Read the status of t_hot */
 		t_hot = ctrl & tsr->status_hot_mask;
@@ -185,7 +185,7 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 		if (!t_cold && !t_hot)
 			continue;
 
-		ctrl = omap_bandgap_readl(bg_ptr, tsr->bgap_mask_ctrl);
+		ctrl = omap_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
 		/*
 		 * One TALERT interrupt: Two sources
 		 * If the interrupt is due to t_hot then mask t_hot and
@@ -199,18 +199,18 @@ static irqreturn_t omap_bandgap_talert_irq_handler(int irq, void *data)
 			ctrl |= tsr->mask_hot_mask;
 		}
 
-		omap_bandgap_writel(bg_ptr, ctrl, tsr->bgap_mask_ctrl);
+		omap_bandgap_writel(bgp, ctrl, tsr->bgap_mask_ctrl);
 
-		dev_dbg(bg_ptr->dev,
+		dev_dbg(bgp->dev,
 			"%s: IRQ from %s sensor: hotevent %d coldevent %d\n",
-			__func__, bg_ptr->conf->sensors[i].domain,
+			__func__, bgp->conf->sensors[i].domain,
 			t_hot, t_cold);
 
 		/* report temperature to whom may concern */
-		if (bg_ptr->conf->report_temperature)
-			bg_ptr->conf->report_temperature(bg_ptr, i);
+		if (bgp->conf->report_temperature)
+			bgp->conf->report_temperature(bgp, i);
 	}
-	spin_unlock_irqrestore(&bg_ptr->lock, flags);
+	spin_unlock_irqrestore(&bgp->lock, flags);
 
 	return IRQ_HANDLED;
 }
@@ -238,7 +238,7 @@ static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
 
 /**
  * omap_bandgap_adc_to_mcelsius() - converts an ADC value to mCelsius scale
- * @bg_ptr: struct omap_bandgap pointer
+ * @bgp: struct omap_bandgap pointer
  * @adc_val: value in ADC representation
  * @t: address where to write the resulting temperature in mCelsius
  *
@@ -247,10 +247,10 @@ static irqreturn_t omap_bandgap_tshut_irq_handler(int irq, void *data)
  * The conversion table is indexed by the ADC values.
  */
 static
-int omap_bandgap_adc_to_mcelsius(struct omap_bandgap *bg_ptr,
+int omap_bandgap_adc_to_mcelsius(struct omap_bandgap *bgp,
 				 int adc_val, int *t)
 {
-	struct omap_bandgap_data *conf = bg_ptr->conf;
+	struct omap_bandgap_data *conf = bgp->conf;
 	int ret = 0;
 
 	/* look up for temperature in the table and return the temperature */
@@ -259,7 +259,7 @@ int omap_bandgap_adc_to_mcelsius(struct omap_bandgap *bg_ptr,
 		goto exit;
 	}
 
-	*t = bg_ptr->conf->conv_table[adc_val - conf->adc_start_val];
+	*t = bgp->conf->conv_table[adc_val - conf->adc_start_val];
 
 exit:
 	return ret;
@@ -267,7 +267,7 @@ exit:
 
 /**
  * omap_bandgap_mcelsius_to_adc() - converts a mCelsius value to ADC scale
- * @bg_ptr: struct omap_bandgap pointer
+ * @bgp: struct omap_bandgap pointer
  * @temp: value in mCelsius
  * @adc: address where to write the resulting temperature in ADC representation
  *
@@ -276,11 +276,11 @@ exit:
  * The conversion table is indexed by the ADC values.
  */
 static
-int omap_bandgap_mcelsius_to_adc(struct omap_bandgap *bg_ptr, long temp,
+int omap_bandgap_mcelsius_to_adc(struct omap_bandgap *bgp, long temp,
 				 int *adc)
 {
-	struct omap_bandgap_data *conf = bg_ptr->conf;
-	const int *conv_table = bg_ptr->conf->conv_table;
+	struct omap_bandgap_data *conf = bgp->conf;
+	const int *conv_table = bgp->conf->conv_table;
 	int high, low, mid, ret = 0;
 
 	low = 0;
@@ -308,7 +308,7 @@ exit:
 
 /**
  * omap_bandgap_add_hyst() - add hysteresis (in mCelsius) to an ADC value
- * @bg_ptr: struct omap_bandgap pointer
+ * @bgp: struct omap_bandgap pointer
  * @adc_val: temperature value in ADC representation
  * @hyst_val: hysteresis value in mCelsius
  * @sum: address where to write the resulting temperature (in ADC scale)
@@ -317,7 +317,7 @@ exit:
  * Returns 0 on success, -ERANGE otherwise.
  */
 static
-int omap_bandgap_add_hyst(struct omap_bandgap *bg_ptr, int adc_val,
+int omap_bandgap_add_hyst(struct omap_bandgap *bgp, int adc_val,
 			  int hyst_val, u32 *sum)
 {
 	int temp, ret;
@@ -326,13 +326,13 @@ int omap_bandgap_add_hyst(struct omap_bandgap *bg_ptr, int adc_val,
 	 * Need to add in the mcelsius domain, so we have a temperature
 	 * the conv_table range
 	 */
-	ret = omap_bandgap_adc_to_mcelsius(bg_ptr, adc_val, &temp);
+	ret = omap_bandgap_adc_to_mcelsius(bgp, adc_val, &temp);
 	if (ret < 0)
 		goto exit;
 
 	temp += hyst_val;
 
-	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, temp, sum);
+	ret = omap_bandgap_mcelsius_to_adc(bgp, temp, sum);
 
 exit:
 	return ret;
@@ -342,24 +342,24 @@ exit:
 
 /**
  * omap_bandgap_unmask_interrupts() - unmasks the events of thot & tcold
- * @bg_ptr: struct omap_bandgap pointer
+ * @bgp: struct omap_bandgap pointer
  * @t_hot: hot temperature value to trigger alert signal
  * @t_cold: cold temperature value to trigger alert signal
  *
  * Checks the requested t_hot and t_cold values and configures the IRQ event
  * masks accordingly. Call this function only if bandgap features HAS(TALERT).
  */
-static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
+static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bgp, int id,
 					   u32 t_hot, u32 t_cold)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, reg_val;
 
 	/* Read the current on die temperature */
-	temp = omap_bandgap_read_temp(bg_ptr, id);
+	temp = omap_bandgap_read_temp(bgp, id);
 
-	tsr = bg_ptr->conf->sensors[id].registers;
-	reg_val = omap_bandgap_readl(bg_ptr, tsr->bgap_mask_ctrl);
+	tsr = bgp->conf->sensors[id].registers;
+	reg_val = omap_bandgap_readl(bgp, tsr->bgap_mask_ctrl);
 
 	if (temp < t_hot)
 		reg_val |= tsr->mask_hot_mask;
@@ -370,12 +370,12 @@ static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
 		reg_val |= tsr->mask_cold_mask;
 	else
 		reg_val &= ~tsr->mask_cold_mask;
-	omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_mask_ctrl);
+	omap_bandgap_writel(bgp, reg_val, tsr->bgap_mask_ctrl);
 }
 
 /**
  * omap_bandgap_update_alert_threshold() - sequence to update thresholds
- * @bg_ptr: struct omap_bandgap pointer
+ * @bgp: struct omap_bandgap pointer
  * @id: bandgap sensor id
  * @val: value (ADC) of a new threshold
  * @hot: desired threshold to be updated. true if threshold hot, false if
@@ -388,18 +388,18 @@ static void omap_bandgap_unmask_interrupts(struct omap_bandgap *bg_ptr, int id,
  * Call this function only if bandgap features HAS(TALERT).
  */
 static
-int omap_bandgap_update_alert_threshold(struct omap_bandgap *bg_ptr, int id,
+int omap_bandgap_update_alert_threshold(struct omap_bandgap *bgp, int id,
 					int val, bool hot)
 {
-	struct temp_sensor_data *ts_data = bg_ptr->conf->sensors[id].ts_data;
+	struct temp_sensor_data *ts_data = bgp->conf->sensors[id].ts_data;
 	struct temp_sensor_registers *tsr;
 	u32 thresh_val, reg_val, t_hot, t_cold;
 	int err = 0;
 
-	tsr = bg_ptr->conf->sensors[id].registers;
+	tsr = bgp->conf->sensors[id].registers;
 
 	/* obtain the current value */
-	thresh_val = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
+	thresh_val = omap_bandgap_readl(bgp, tsr->bgap_threshold);
 	t_cold = (thresh_val & tsr->threshold_tcold_mask) >>
 		__ffs(tsr->threshold_tcold_mask);
 	t_hot = (thresh_val & tsr->threshold_thot_mask) >>
@@ -411,11 +411,11 @@ int omap_bandgap_update_alert_threshold(struct omap_bandgap *bg_ptr, int id,
 
 	if (t_cold < t_hot) {
 		if (hot)
-			err = omap_bandgap_add_hyst(bg_ptr, t_hot,
+			err = omap_bandgap_add_hyst(bgp, t_hot,
 						    -ts_data->hyst_val,
 						    &t_cold);
 		else
-			err = omap_bandgap_add_hyst(bg_ptr, t_cold,
+			err = omap_bandgap_add_hyst(bgp, t_cold,
 						    ts_data->hyst_val,
 						    &t_hot);
 	}
@@ -425,39 +425,39 @@ int omap_bandgap_update_alert_threshold(struct omap_bandgap *bg_ptr, int id,
 	reg_val |= (t_hot << __ffs(tsr->threshold_thot_mask));
 	reg_val |= thresh_val & ~tsr->threshold_tcold_mask;
 	reg_val |= (t_cold << __ffs(tsr->threshold_tcold_mask));
-	omap_bandgap_writel(bg_ptr, reg_val, tsr->bgap_threshold);
+	omap_bandgap_writel(bgp, reg_val, tsr->bgap_threshold);
 
 	if (err) {
-		dev_err(bg_ptr->dev, "failed to reprogram thot threshold\n");
+		dev_err(bgp->dev, "failed to reprogram thot threshold\n");
 		err = -EIO;
 		goto exit;
 	}
 
-	omap_bandgap_unmask_interrupts(bg_ptr, id, t_hot, t_cold);
+	omap_bandgap_unmask_interrupts(bgp, id, t_hot, t_cold);
 exit:
 	return err;
 }
 
 /**
  * omap_bandgap_validate() - helper to check the sanity of a struct omap_bandgap
- * @bg_ptr: struct omap_bandgap pointer
+ * @bgp: struct omap_bandgap pointer
  * @id: bandgap sensor id
  *
  * Checks if the bandgap pointer is valid and if the sensor id is also
  * applicable.
  */
-static inline int omap_bandgap_validate(struct omap_bandgap *bg_ptr, int id)
+static inline int omap_bandgap_validate(struct omap_bandgap *bgp, int id)
 {
 	int ret = 0;
 
-	if (IS_ERR_OR_NULL(bg_ptr)) {
+	if (IS_ERR_OR_NULL(bgp)) {
 		pr_err("%s: invalid bandgap pointer\n", __func__);
 		ret = -EINVAL;
 		goto exit;
 	}
 
-	if ((id < 0) || (id >= bg_ptr->conf->sensor_count)) {
-		dev_err(bg_ptr->dev, "%s: sensor id out of range (%d)\n",
+	if ((id < 0) || (id >= bgp->conf->sensor_count)) {
+		dev_err(bgp->dev, "%s: sensor id out of range (%d)\n",
 			__func__, id);
 		ret = -ERANGE;
 	}
@@ -468,7 +468,7 @@ exit:
 
 /**
  * _omap_bandgap_write_threshold() - helper to update TALERT t_cold or t_hot
- * @bg_ptr: struct omap_bandgap pointer
+ * @bgp: struct omap_bandgap pointer
  * @id: bandgap sensor id
  * @val: value (mCelsius) of a new threshold
  * @hot: desired threshold to be updated. true if threshold hot, false if
@@ -479,7 +479,7 @@ exit:
  * Validates the mCelsius range and update the requested threshold.
  * Call this function only if bandgap features HAS(TALERT).
  */
-int _omap_bandgap_write_threshold(struct omap_bandgap *bg_ptr, int id, int val,
+int _omap_bandgap_write_threshold(struct omap_bandgap *bgp, int id, int val,
 				  bool hot)
 {
 	struct temp_sensor_data *ts_data;
@@ -487,17 +487,17 @@ int _omap_bandgap_write_threshold(struct omap_bandgap *bg_ptr, int id, int val,
 	u32 adc_val;
 	int ret;
 
-	ret = omap_bandgap_validate(bg_ptr, id);
+	ret = omap_bandgap_validate(bgp, id);
 	if (ret)
 		goto exit;
 
-	if (!OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
+	if (!OMAP_BANDGAP_HAS(bgp, TALERT)) {
 		ret = -ENOTSUPP;
 		goto exit;
 	}
 
-	ts_data = bg_ptr->conf->sensors[id].ts_data;
-	tsr = bg_ptr->conf->sensors[id].registers;
+	ts_data = bgp->conf->sensors[id].ts_data;
+	tsr = bgp->conf->sensors[id].registers;
 	if (hot) {
 		if (val < ts_data->min_temp + ts_data->hyst_val)
 			ret = -EINVAL;
@@ -509,13 +509,13 @@ int _omap_bandgap_write_threshold(struct omap_bandgap *bg_ptr, int id, int val,
 	if (ret)
 		goto exit;
 
-	ret = omap_bandgap_mcelsius_to_adc(bg_ptr, val, &adc_val);
+	ret = omap_bandgap_mcelsius_to_adc(bgp, val, &adc_val);
 	if (ret < 0)
 		goto exit;
 
-	spin_lock(&bg_ptr->lock);
-	omap_bandgap_update_alert_threshold(bg_ptr, id, adc_val, hot);
-	spin_unlock(&bg_ptr->lock);
+	spin_lock(&bgp->lock);
+	omap_bandgap_update_alert_threshold(bgp, id, adc_val, hot);
+	spin_unlock(&bgp->lock);
 
 exit:
 	return ret;
@@ -523,7 +523,7 @@ exit:
 
 /**
  * _omap_bandgap_read_threshold() - helper to read TALERT t_cold or t_hot
- * @bg_ptr: struct omap_bandgap pointer
+ * @bgp: struct omap_bandgap pointer
  * @id: bandgap sensor id
  * @val: value (mCelsius) of a threshold
  * @hot: desired threshold to be read. true if threshold hot, false if
@@ -533,33 +533,33 @@ exit:
  * This function can be used to read t_hot or t_cold, depending on @hot value.
  * Call this function only if bandgap features HAS(TALERT).
  */
-int _omap_bandgap_read_threshold(struct omap_bandgap *bg_ptr, int id,
+int _omap_bandgap_read_threshold(struct omap_bandgap *bgp, int id,
 				 int *val, bool hot)
 {
 	struct temp_sensor_registers *tsr;
 	u32 temp, mask;
 	int ret = 0;
 
-	ret = omap_bandgap_validate(bg_ptr, id);
+	ret = omap_bandgap_validate(bgp, id);
 	if (ret)
 		goto exit;
 
-	if (!OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
+	if (!OMAP_BANDGAP_HAS(bgp, TALERT)) {
 		ret = -ENOTSUPP;
 		goto exit;
 	}
 
-	tsr = bg_ptr->conf->sensors[id].registers;
+	tsr = bgp->conf->sensors[id].registers;
 	if (hot)
 		mask = tsr->threshold_thot_mask;
 	else
 		mask = tsr->threshold_tcold_mask;
 
-	temp = omap_bandgap_readl(bg_ptr, tsr->bgap_threshold);
+	temp = omap_bandgap_readl(bgp, tsr->bgap_threshold);
 	temp = (temp & mask) >> __ffs(mask);
-	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, temp, &temp);
+	ret |= omap_bandgap_adc_to_mcelsius(bgp, temp, &temp);
 	if (ret) {
-		dev_err(bg_ptr->dev, "failed to read thot\n");
+		dev_err(bgp->dev, "failed to read thot\n");
 		ret = -EIO;
 		goto exit;
 	}
@@ -574,84 +574,84 @@ exit:
 
 /**
  * omap_bandgap_read_thot() - reads sensor current thot
- * @bg_ptr - pointer to bandgap instance
+ * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @thot - resulting current thot value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_thot(struct omap_bandgap *bg_ptr, int id,
+int omap_bandgap_read_thot(struct omap_bandgap *bgp, int id,
 			   int *thot)
 {
-	return _omap_bandgap_read_threshold(bg_ptr, id, thot, true);
+	return _omap_bandgap_read_threshold(bgp, id, thot, true);
 }
 
 /**
  * omap_bandgap_write_thot() - sets sensor current thot
- * @bg_ptr - pointer to bandgap instance
+ * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @val - desired thot value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_write_thot(struct omap_bandgap *bg_ptr, int id, int val)
+int omap_bandgap_write_thot(struct omap_bandgap *bgp, int id, int val)
 {
-	return _omap_bandgap_write_threshold(bg_ptr, id, val, true);
+	return _omap_bandgap_write_threshold(bgp, id, val, true);
 }
 
 /**
  * omap_bandgap_read_tcold() - reads sensor current tcold
- * @bg_ptr - pointer to bandgap instance
+ * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @tcold - resulting current tcold value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_tcold(struct omap_bandgap *bg_ptr, int id,
+int omap_bandgap_read_tcold(struct omap_bandgap *bgp, int id,
 			    int *tcold)
 {
-	return _omap_bandgap_read_threshold(bg_ptr, id, tcold, false);
+	return _omap_bandgap_read_threshold(bgp, id, tcold, false);
 }
 
 /**
  * omap_bandgap_write_tcold() - sets the sensor tcold
- * @bg_ptr - pointer to bandgap instance
+ * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @val - desired tcold value
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_write_tcold(struct omap_bandgap *bg_ptr, int id, int val)
+int omap_bandgap_write_tcold(struct omap_bandgap *bgp, int id, int val)
 {
-	return _omap_bandgap_write_threshold(bg_ptr, id, val, false);
+	return _omap_bandgap_write_threshold(bgp, id, val, false);
 }
 
 /**
  * omap_bandgap_read_update_interval() - read the sensor update interval
- * @bg_ptr - pointer to bandgap instance
+ * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @interval - resulting update interval in miliseconds
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_update_interval(struct omap_bandgap *bg_ptr, int id,
+int omap_bandgap_read_update_interval(struct omap_bandgap *bgp, int id,
 					 int *interval)
 {
 	struct temp_sensor_registers *tsr;
 	u32 time;
 	int ret;
 
-	ret = omap_bandgap_validate(bg_ptr, id);
+	ret = omap_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
-	if (!OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
+	if (!OMAP_BANDGAP_HAS(bgp, COUNTER))
 		return -ENOTSUPP;
 
-	tsr = bg_ptr->conf->sensors[id].registers;
-	time = omap_bandgap_readl(bg_ptr, tsr->bgap_counter);
+	tsr = bgp->conf->sensors[id].registers;
+	time = omap_bandgap_readl(bgp, tsr->bgap_counter);
 	time = (time & tsr->counter_mask) >> __ffs(tsr->counter_mask);
-	time = time * 1000 / bg_ptr->clk_rate;
+	time = time * 1000 / bgp->clk_rate;
 
 	*interval = time;
 
@@ -660,53 +660,53 @@ int omap_bandgap_read_update_interval(struct omap_bandgap *bg_ptr, int id,
 
 /**
  * omap_bandgap_write_update_interval() - set the update interval
- * @bg_ptr - pointer to bandgap instance
+ * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @interval - desired update interval in miliseconds
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_write_update_interval(struct omap_bandgap *bg_ptr,
+int omap_bandgap_write_update_interval(struct omap_bandgap *bgp,
 				       int id, u32 interval)
 {
-	int ret = omap_bandgap_validate(bg_ptr, id);
+	int ret = omap_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
-	if (!OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
+	if (!OMAP_BANDGAP_HAS(bgp, COUNTER))
 		return -ENOTSUPP;
 
-	interval = interval * bg_ptr->clk_rate / 1000;
-	spin_lock(&bg_ptr->lock);
-	RMW_BITS(bg_ptr, id, bgap_counter, counter_mask, interval);
-	spin_unlock(&bg_ptr->lock);
+	interval = interval * bgp->clk_rate / 1000;
+	spin_lock(&bgp->lock);
+	RMW_BITS(bgp, id, bgap_counter, counter_mask, interval);
+	spin_unlock(&bgp->lock);
 
 	return 0;
 }
 
 /**
  * omap_bandgap_read_temperature() - report current temperature
- * @bg_ptr - pointer to bandgap instance
+ * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @temperature - resulting temperature
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
+int omap_bandgap_read_temperature(struct omap_bandgap *bgp, int id,
 				  int *temperature)
 {
 	u32 temp;
 	int ret;
 
-	ret = omap_bandgap_validate(bg_ptr, id);
+	ret = omap_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
-	spin_lock(&bg_ptr->lock);
-	temp = omap_bandgap_read_temp(bg_ptr, id);
-	spin_unlock(&bg_ptr->lock);
+	spin_lock(&bgp->lock);
+	temp = omap_bandgap_read_temp(bgp, id);
+	spin_unlock(&bgp->lock);
 
-	ret |= omap_bandgap_adc_to_mcelsius(bg_ptr, temp, &temp);
+	ret |= omap_bandgap_adc_to_mcelsius(bgp, temp, &temp);
 	if (ret)
 		return -EIO;
 
@@ -718,20 +718,20 @@ int omap_bandgap_read_temperature(struct omap_bandgap *bg_ptr, int id,
 /**
  * omap_bandgap_set_sensor_data() - helper function to store thermal
  * framework related data.
- * @bg_ptr - pointer to bandgap instance
+ * @bgp - pointer to bandgap instance
  * @id - sensor id
  * @data - thermal framework related data to be stored
  *
  * returns 0 on success or the proper error code
  */
-int omap_bandgap_set_sensor_data(struct omap_bandgap *bg_ptr, int id,
+int omap_bandgap_set_sensor_data(struct omap_bandgap *bgp, int id,
 				 void *data)
 {
-	int ret = omap_bandgap_validate(bg_ptr, id);
+	int ret = omap_bandgap_validate(bgp, id);
 	if (ret)
 		return ret;
 
-	bg_ptr->conf->sensors[id].data = data;
+	bgp->conf->sensors[id].data = data;
 
 	return 0;
 }
@@ -739,71 +739,71 @@ int omap_bandgap_set_sensor_data(struct omap_bandgap *bg_ptr, int id,
 /**
  * omap_bandgap_get_sensor_data() - helper function to get thermal
  * framework related data.
- * @bg_ptr - pointer to bandgap instance
+ * @bgp - pointer to bandgap instance
  * @id - sensor id
  *
  * returns data stored by set function with sensor id on success or NULL
  */
-void *omap_bandgap_get_sensor_data(struct omap_bandgap *bg_ptr, int id)
+void *omap_bandgap_get_sensor_data(struct omap_bandgap *bgp, int id)
 {
-	int ret = omap_bandgap_validate(bg_ptr, id);
+	int ret = omap_bandgap_validate(bgp, id);
 	if (ret)
 		return ERR_PTR(ret);
 
-	return bg_ptr->conf->sensors[id].data;
+	return bgp->conf->sensors[id].data;
 }
 
 /***   Helper functions used during device initialization   ***/
 
 /**
  * omap_bandgap_force_single_read() - executes 1 single ADC conversion
- * @bg_ptr: pointer to struct omap_bandgap
+ * @bgp: pointer to struct omap_bandgap
  * @id: sensor id which it is desired to read 1 temperature
  *
  * Used to initialize the conversion state machine and set it to a valid
  * state. Called during device initialization and context restore events.
  */
 static int
-omap_bandgap_force_single_read(struct omap_bandgap *bg_ptr, int id)
+omap_bandgap_force_single_read(struct omap_bandgap *bgp, int id)
 {
 	u32 temp = 0, counter = 1000;
 
 	/* Select single conversion mode */
-	if (OMAP_BANDGAP_HAS(bg_ptr, MODE_CONFIG))
-		RMW_BITS(bg_ptr, id, bgap_mode_ctrl, mode_ctrl_mask, 0);
+	if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
+		RMW_BITS(bgp, id, bgap_mode_ctrl, mode_ctrl_mask, 0);
 
 	/* Start of Conversion = 1 */
-	RMW_BITS(bg_ptr, id, temp_sensor_ctrl, bgap_soc_mask, 1);
+	RMW_BITS(bgp, id, temp_sensor_ctrl, bgap_soc_mask, 1);
 	/* Wait until DTEMP is updated */
-	temp = omap_bandgap_read_temp(bg_ptr, id);
+	temp = omap_bandgap_read_temp(bgp, id);
 
 	while ((temp == 0) && --counter)
-		temp = omap_bandgap_read_temp(bg_ptr, id);
+		temp = omap_bandgap_read_temp(bgp, id);
 	/* REVISIT: Check correct condition for end of conversion */
 
 	/* Start of Conversion = 0 */
-	RMW_BITS(bg_ptr, id, temp_sensor_ctrl, bgap_soc_mask, 0);
+	RMW_BITS(bgp, id, temp_sensor_ctrl, bgap_soc_mask, 0);
 
 	return 0;
 }
 
 /**
  * omap_bandgap_set_continous_mode() - One time enabling of continuous mode
- * @bg_ptr: pointer to struct omap_bandgap
+ * @bgp: pointer to struct omap_bandgap
  *
  * Call this function only if HAS(MODE_CONFIG) is set. As this driver may
  * be used for junction temperature monitoring, it is desirable that the
  * sensors are operational all the time, so that alerts are generated
  * properly.
  */
-static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bg_ptr)
+static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bgp)
 {
 	int i;
 
-	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
+	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		/* Perform a single read just before enabling continuous */
-		omap_bandgap_force_single_read(bg_ptr, i);
-		RMW_BITS(bg_ptr, i, bgap_mode_ctrl, mode_ctrl_mask, 1);
+		omap_bandgap_force_single_read(bgp, i);
+		RMW_BITS(bgp, i, bgap_mode_ctrl, mode_ctrl_mask, 1);
 	}
 
 	return 0;
@@ -811,7 +811,7 @@ static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bg_ptr)
 
 /**
  * omap_bandgap_tshut_init() - setup and initialize tshut handling
- * @bg_ptr: pointer to struct omap_bandgap
+ * @bgp: pointer to struct omap_bandgap
  * @pdev: pointer to device struct platform_device
  *
  * Call this function only in case the bandgap features HAS(TSHUT).
@@ -821,22 +821,22 @@ static int omap_bandgap_set_continuous_mode(struct omap_bandgap *bg_ptr)
  * one of the bandgap sensors violates the TSHUT high/hot threshold.
  * And in that case, the system must go off.
  */
-static int omap_bandgap_tshut_init(struct omap_bandgap *bg_ptr,
+static int omap_bandgap_tshut_init(struct omap_bandgap *bgp,
 				   struct platform_device *pdev)
 {
-	int gpio_nr = bg_ptr->tshut_gpio;
+	int gpio_nr = bgp->tshut_gpio;
 	int status;
 
 	/* Request for gpio_86 line */
 	status = gpio_request(gpio_nr, "tshut");
 	if (status < 0) {
-		dev_err(bg_ptr->dev,
+		dev_err(bgp->dev,
 			"Could not request for TSHUT GPIO:%i\n", 86);
 		return status;
 	}
 	status = gpio_direction_input(gpio_nr);
 	if (status) {
-		dev_err(bg_ptr->dev,
+		dev_err(bgp->dev,
 			"Cannot set input TSHUT GPIO %d\n", gpio_nr);
 		return status;
 	}
@@ -847,7 +847,7 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bg_ptr,
 			     NULL);
 	if (status) {
 		gpio_free(gpio_nr);
-		dev_err(bg_ptr->dev, "request irq failed for TSHUT");
+		dev_err(bgp->dev, "request irq failed for TSHUT");
 	}
 
 	return 0;
@@ -855,7 +855,7 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bg_ptr,
 
 /**
  * omap_bandgap_alert_init() - setup and initialize talert handling
- * @bg_ptr: pointer to struct omap_bandgap
+ * @bgp: pointer to struct omap_bandgap
  * @pdev: pointer to device struct platform_device
  *
  * Call this function only in case the bandgap features HAS(TALERT).
@@ -864,20 +864,20 @@ static int omap_bandgap_tshut_init(struct omap_bandgap *bg_ptr,
  * are violated. In these situation, the driver must reprogram the thresholds,
  * accordingly to specified policy.
  */
-static int omap_bandgap_talert_init(struct omap_bandgap *bg_ptr,
+static int omap_bandgap_talert_init(struct omap_bandgap *bgp,
 				    struct platform_device *pdev)
 {
 	int ret;
 
-	bg_ptr->irq = platform_get_irq(pdev, 0);
-	if (bg_ptr->irq < 0) {
+	bgp->irq = platform_get_irq(pdev, 0);
+	if (bgp->irq < 0) {
 		dev_err(&pdev->dev, "get_irq failed\n");
-		return bg_ptr->irq;
+		return bgp->irq;
 	}
-	ret = request_threaded_irq(bg_ptr->irq, NULL,
+	ret = request_threaded_irq(bgp->irq, NULL,
 				   omap_bandgap_talert_irq_handler,
 				   IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
-				   "talert", bg_ptr);
+				   "talert", bgp);
 	if (ret) {
 		dev_err(&pdev->dev, "Request threaded irq failed.\n");
 		return ret;
@@ -888,7 +888,7 @@ static int omap_bandgap_talert_init(struct omap_bandgap *bg_ptr,
 
 /**
  * omap_bandgap_build() - parse DT and setup a struct omap_bandgap
- * @bg_ptr: pointer to struct omap_bandgap
+ * @bgp: pointer to struct omap_bandgap
  * @pdev: pointer to device struct platform_device
  *
  * Used to read the device tree properties accordingly to the bandgap
@@ -900,7 +900,7 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
 	const struct of_device_id *of_id;
-	struct omap_bandgap *bg_ptr;
+	struct omap_bandgap *bgp;
 	struct resource *res;
 	u32 prop;
 	int i;
@@ -911,16 +911,16 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 		return ERR_PTR(-EINVAL);
 	}
 
-	bg_ptr = devm_kzalloc(&pdev->dev, sizeof(struct omap_bandgap),
+	bgp = devm_kzalloc(&pdev->dev, sizeof(struct omap_bandgap),
 				    GFP_KERNEL);
-	if (!bg_ptr) {
+	if (!bgp) {
 		dev_err(&pdev->dev, "Unable to allocate mem for driver ref\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
 	of_id = of_match_device(of_omap_bandgap_match, &pdev->dev);
 	if (of_id)
-		bg_ptr->conf = of_id->data;
+		bgp->conf = of_id->data;
 
 	i = 0;
 	do {
@@ -931,27 +931,27 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 			break;
 		chunk = devm_ioremap_resource(&pdev->dev, res);
 		if (i == 0)
-			bg_ptr->base = chunk;
+			bgp->base = chunk;
 		if (IS_ERR(chunk))
 			return ERR_CAST(chunk);
 
 		i++;
 	} while (res);
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT)) {
+	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
 		if (of_property_read_u32(node, "ti,tshut-gpio", &prop) < 0) {
 			dev_err(&pdev->dev, "missing tshut gpio in device tree\n");
 			return ERR_PTR(-EINVAL);
 		}
-		bg_ptr->tshut_gpio = prop;
-		if (!gpio_is_valid(bg_ptr->tshut_gpio)) {
+		bgp->tshut_gpio = prop;
+		if (!gpio_is_valid(bgp->tshut_gpio)) {
 			dev_err(&pdev->dev, "invalid gpio for tshut (%d)\n",
-				bg_ptr->tshut_gpio);
+				bgp->tshut_gpio);
 			return ERR_PTR(-EINVAL);
 		}
 	}
 
-	return bg_ptr;
+	return bgp;
 }
 
 /***   Device driver call backs   ***/
@@ -959,18 +959,18 @@ static struct omap_bandgap *omap_bandgap_build(struct platform_device *pdev)
 static
 int omap_bandgap_probe(struct platform_device *pdev)
 {
-	struct omap_bandgap *bg_ptr;
+	struct omap_bandgap *bgp;
 	int clk_rate, ret = 0, i;
 
-	bg_ptr = omap_bandgap_build(pdev);
-	if (IS_ERR_OR_NULL(bg_ptr)) {
+	bgp = omap_bandgap_build(pdev);
+	if (IS_ERR_OR_NULL(bgp)) {
 		dev_err(&pdev->dev, "failed to fetch platform data\n");
-		return PTR_ERR(bg_ptr);
+		return PTR_ERR(bgp);
 	}
-	bg_ptr->dev = &pdev->dev;
+	bgp->dev = &pdev->dev;
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT)) {
-		ret = omap_bandgap_tshut_init(bg_ptr, pdev);
+	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
+		ret = omap_bandgap_tshut_init(bgp, pdev);
 		if (ret) {
 			dev_err(&pdev->dev,
 				"failed to initialize system tshut IRQ\n");
@@ -978,111 +978,111 @@ int omap_bandgap_probe(struct platform_device *pdev)
 		}
 	}
 
-	bg_ptr->fclock = clk_get(NULL, bg_ptr->conf->fclock_name);
-	ret = IS_ERR_OR_NULL(bg_ptr->fclock);
+	bgp->fclock = clk_get(NULL, bgp->conf->fclock_name);
+	ret = IS_ERR_OR_NULL(bgp->fclock);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request fclock reference\n");
 		goto free_irqs;
 	}
 
-	bg_ptr->div_clk = clk_get(NULL,  bg_ptr->conf->div_ck_name);
-	ret = IS_ERR_OR_NULL(bg_ptr->div_clk);
+	bgp->div_clk = clk_get(NULL,  bgp->conf->div_ck_name);
+	ret = IS_ERR_OR_NULL(bgp->div_clk);
 	if (ret) {
 		dev_err(&pdev->dev,
 			"failed to request div_ts_ck clock ref\n");
 		goto free_irqs;
 	}
 
-	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
+	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		struct temp_sensor_registers *tsr;
 		u32 val;
 
-		tsr = bg_ptr->conf->sensors[i].registers;
+		tsr = bgp->conf->sensors[i].registers;
 		/*
 		 * check if the efuse has a non-zero value if not
 		 * it is an untrimmed sample and the temperatures
 		 * may not be accurate
 		 */
-		val = omap_bandgap_readl(bg_ptr, tsr->bgap_efuse);
+		val = omap_bandgap_readl(bgp, tsr->bgap_efuse);
 		if (ret || !val)
 			dev_info(&pdev->dev,
 				 "Non-trimmed BGAP, Temp not accurate\n");
 	}
 
-	clk_rate = clk_round_rate(bg_ptr->div_clk,
-				  bg_ptr->conf->sensors[0].ts_data->max_freq);
-	if (clk_rate < bg_ptr->conf->sensors[0].ts_data->min_freq ||
+	clk_rate = clk_round_rate(bgp->div_clk,
+				  bgp->conf->sensors[0].ts_data->max_freq);
+	if (clk_rate < bgp->conf->sensors[0].ts_data->min_freq ||
 	    clk_rate == 0xffffffff) {
 		ret = -ENODEV;
 		dev_err(&pdev->dev, "wrong clock rate (%d)\n", clk_rate);
 		goto put_clks;
 	}
 
-	ret = clk_set_rate(bg_ptr->div_clk, clk_rate);
+	ret = clk_set_rate(bgp->div_clk, clk_rate);
 	if (ret)
 		dev_err(&pdev->dev, "Cannot re-set clock rate. Continuing\n");
 
-	bg_ptr->clk_rate = clk_rate;
-	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
-		clk_prepare_enable(bg_ptr->fclock);
+	bgp->clk_rate = clk_rate;
+	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+		clk_prepare_enable(bgp->fclock);
 
 
-	spin_lock_init(&bg_ptr->lock);
-	bg_ptr->dev = &pdev->dev;
-	platform_set_drvdata(pdev, bg_ptr);
+	spin_lock_init(&bgp->lock);
+	bgp->dev = &pdev->dev;
+	platform_set_drvdata(pdev, bgp);
 
-	omap_bandgap_power(bg_ptr, true);
+	omap_bandgap_power(bgp, true);
 
 	/* Set default counter to 1 for now */
-	if (OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
-		for (i = 0; i < bg_ptr->conf->sensor_count; i++)
-			RMW_BITS(bg_ptr, i, bgap_counter, counter_mask, 1);
+	if (OMAP_BANDGAP_HAS(bgp, COUNTER))
+		for (i = 0; i < bgp->conf->sensor_count; i++)
+			RMW_BITS(bgp, i, bgap_counter, counter_mask, 1);
 
 	/* Set default thresholds for alert and shutdown */
-	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
+	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		struct temp_sensor_data *ts_data;
 
-		ts_data = bg_ptr->conf->sensors[i].ts_data;
+		ts_data = bgp->conf->sensors[i].ts_data;
 
-		if (OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
+		if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
 			/* Set initial Talert thresholds */
-			RMW_BITS(bg_ptr, i, bgap_threshold,
+			RMW_BITS(bgp, i, bgap_threshold,
 				 threshold_tcold_mask, ts_data->t_cold);
-			RMW_BITS(bg_ptr, i, bgap_threshold,
+			RMW_BITS(bgp, i, bgap_threshold,
 				 threshold_thot_mask, ts_data->t_hot);
 			/* Enable the alert events */
-			RMW_BITS(bg_ptr, i, bgap_mask_ctrl, mask_hot_mask, 1);
-			RMW_BITS(bg_ptr, i, bgap_mask_ctrl, mask_cold_mask, 1);
+			RMW_BITS(bgp, i, bgap_mask_ctrl, mask_hot_mask, 1);
+			RMW_BITS(bgp, i, bgap_mask_ctrl, mask_cold_mask, 1);
 		}
 
-		if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT_CONFIG)) {
+		if (OMAP_BANDGAP_HAS(bgp, TSHUT_CONFIG)) {
 			/* Set initial Tshut thresholds */
-			RMW_BITS(bg_ptr, i, tshut_threshold,
+			RMW_BITS(bgp, i, tshut_threshold,
 				 tshut_hot_mask, ts_data->tshut_hot);
-			RMW_BITS(bg_ptr, i, tshut_threshold,
+			RMW_BITS(bgp, i, tshut_threshold,
 				 tshut_cold_mask, ts_data->tshut_cold);
 		}
 	}
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, MODE_CONFIG))
-		omap_bandgap_set_continuous_mode(bg_ptr);
+	if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
+		omap_bandgap_set_continuous_mode(bgp);
 
 	/* Set .250 seconds time as default counter */
-	if (OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
-		for (i = 0; i < bg_ptr->conf->sensor_count; i++)
-			RMW_BITS(bg_ptr, i, bgap_counter, counter_mask,
-				 bg_ptr->clk_rate / 4);
+	if (OMAP_BANDGAP_HAS(bgp, COUNTER))
+		for (i = 0; i < bgp->conf->sensor_count; i++)
+			RMW_BITS(bgp, i, bgap_counter, counter_mask,
+				 bgp->clk_rate / 4);
 
 	/* Every thing is good? Then expose the sensors */
-	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
+	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		char *domain;
 
-		if (bg_ptr->conf->sensors[i].register_cooling)
-			bg_ptr->conf->sensors[i].register_cooling(bg_ptr, i);
+		if (bgp->conf->sensors[i].register_cooling)
+			bgp->conf->sensors[i].register_cooling(bgp, i);
 
-		domain = bg_ptr->conf->sensors[i].domain;
-		if (bg_ptr->conf->expose_sensor)
-			bg_ptr->conf->expose_sensor(bg_ptr, i, domain);
+		domain = bgp->conf->sensors[i].domain;
+		if (bgp->conf->expose_sensor)
+			bgp->conf->expose_sensor(bgp, i, domain);
 	}
 
 	/*
@@ -1090,11 +1090,11 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	 * might be called as soon as it is enabled where as rest of framework
 	 * is still getting initialised.
 	 */
-	if (OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
-		ret = omap_bandgap_talert_init(bg_ptr, pdev);
+	if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
+		ret = omap_bandgap_talert_init(bgp, pdev);
 		if (ret) {
 			dev_err(&pdev->dev, "failed to initialize Talert IRQ\n");
-			i = bg_ptr->conf->sensor_count;
+			i = bgp->conf->sensor_count;
 			goto disable_clk;
 		}
 	}
@@ -1102,15 +1102,15 @@ int omap_bandgap_probe(struct platform_device *pdev)
 	return 0;
 
 disable_clk:
-	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
-		clk_disable_unprepare(bg_ptr->fclock);
+	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+		clk_disable_unprepare(bgp->fclock);
 put_clks:
-	clk_put(bg_ptr->fclock);
-	clk_put(bg_ptr->div_clk);
+	clk_put(bgp->fclock);
+	clk_put(bgp->div_clk);
 free_irqs:
-	if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT)) {
-		free_irq(gpio_to_irq(bg_ptr->tshut_gpio), NULL);
-		gpio_free(bg_ptr->tshut_gpio);
+	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
+		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
+		gpio_free(bgp->tshut_gpio);
 	}
 
 	return ret;
@@ -1119,102 +1119,102 @@ free_irqs:
 static
 int omap_bandgap_remove(struct platform_device *pdev)
 {
-	struct omap_bandgap *bg_ptr = platform_get_drvdata(pdev);
+	struct omap_bandgap *bgp = platform_get_drvdata(pdev);
 	int i;
 
 	/* First thing is to remove sensor interfaces */
-	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
-		if (bg_ptr->conf->sensors[i].register_cooling)
-			bg_ptr->conf->sensors[i].unregister_cooling(bg_ptr, i);
+	for (i = 0; i < bgp->conf->sensor_count; i++) {
+		if (bgp->conf->sensors[i].register_cooling)
+			bgp->conf->sensors[i].unregister_cooling(bgp, i);
 
-		if (bg_ptr->conf->remove_sensor)
-			bg_ptr->conf->remove_sensor(bg_ptr, i);
+		if (bgp->conf->remove_sensor)
+			bgp->conf->remove_sensor(bgp, i);
 	}
 
-	omap_bandgap_power(bg_ptr, false);
+	omap_bandgap_power(bgp, false);
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
-		clk_disable_unprepare(bg_ptr->fclock);
-	clk_put(bg_ptr->fclock);
-	clk_put(bg_ptr->div_clk);
+	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+		clk_disable_unprepare(bgp->fclock);
+	clk_put(bgp->fclock);
+	clk_put(bgp->div_clk);
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, TALERT))
-		free_irq(bg_ptr->irq, bg_ptr);
+	if (OMAP_BANDGAP_HAS(bgp, TALERT))
+		free_irq(bgp->irq, bgp);
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT)) {
-		free_irq(gpio_to_irq(bg_ptr->tshut_gpio), NULL);
-		gpio_free(bg_ptr->tshut_gpio);
+	if (OMAP_BANDGAP_HAS(bgp, TSHUT)) {
+		free_irq(gpio_to_irq(bgp->tshut_gpio), NULL);
+		gpio_free(bgp->tshut_gpio);
 	}
 
 	return 0;
 }
 
 #ifdef CONFIG_PM
-static int omap_bandgap_save_ctxt(struct omap_bandgap *bg_ptr)
+static int omap_bandgap_save_ctxt(struct omap_bandgap *bgp)
 {
 	int i;
 
-	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
+	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		struct temp_sensor_registers *tsr;
 		struct temp_sensor_regval *rval;
 
-		rval = &bg_ptr->conf->sensors[i].regval;
-		tsr = bg_ptr->conf->sensors[i].registers;
+		rval = &bgp->conf->sensors[i].regval;
+		tsr = bgp->conf->sensors[i].registers;
 
-		if (OMAP_BANDGAP_HAS(bg_ptr, MODE_CONFIG))
-			rval->bg_mode_ctrl = omap_bandgap_readl(bg_ptr,
+		if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
+			rval->bg_mode_ctrl = omap_bandgap_readl(bgp,
 							tsr->bgap_mode_ctrl);
-		if (OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
-			rval->bg_counter = omap_bandgap_readl(bg_ptr,
+		if (OMAP_BANDGAP_HAS(bgp, COUNTER))
+			rval->bg_counter = omap_bandgap_readl(bgp,
 							tsr->bgap_counter);
-		if (OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
-			rval->bg_threshold = omap_bandgap_readl(bg_ptr,
+		if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
+			rval->bg_threshold = omap_bandgap_readl(bgp,
 							tsr->bgap_threshold);
-			rval->bg_ctrl = omap_bandgap_readl(bg_ptr,
+			rval->bg_ctrl = omap_bandgap_readl(bgp,
 						   tsr->bgap_mask_ctrl);
 		}
 
-		if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT_CONFIG))
-			rval->tshut_threshold = omap_bandgap_readl(bg_ptr,
+		if (OMAP_BANDGAP_HAS(bgp, TSHUT_CONFIG))
+			rval->tshut_threshold = omap_bandgap_readl(bgp,
 						   tsr->tshut_threshold);
 	}
 
 	return 0;
 }
 
-static int omap_bandgap_restore_ctxt(struct omap_bandgap *bg_ptr)
+static int omap_bandgap_restore_ctxt(struct omap_bandgap *bgp)
 {
 	int i;
 
-	for (i = 0; i < bg_ptr->conf->sensor_count; i++) {
+	for (i = 0; i < bgp->conf->sensor_count; i++) {
 		struct temp_sensor_registers *tsr;
 		struct temp_sensor_regval *rval;
 		u32 val = 0;
 
-		rval = &bg_ptr->conf->sensors[i].regval;
-		tsr = bg_ptr->conf->sensors[i].registers;
+		rval = &bgp->conf->sensors[i].regval;
+		tsr = bgp->conf->sensors[i].registers;
 
-		if (OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
-			val = omap_bandgap_readl(bg_ptr, tsr->bgap_counter);
+		if (OMAP_BANDGAP_HAS(bgp, COUNTER))
+			val = omap_bandgap_readl(bgp, tsr->bgap_counter);
 
-		if (OMAP_BANDGAP_HAS(bg_ptr, TSHUT_CONFIG))
-			omap_bandgap_writel(bg_ptr, rval->tshut_threshold,
+		if (OMAP_BANDGAP_HAS(bgp, TSHUT_CONFIG))
+			omap_bandgap_writel(bgp, rval->tshut_threshold,
 					    tsr->tshut_threshold);
 		/* Force immediate temperature measurement and update
 		 * of the DTEMP field
 		 */
-		omap_bandgap_force_single_read(bg_ptr, i);
+		omap_bandgap_force_single_read(bgp, i);
 
-		if (OMAP_BANDGAP_HAS(bg_ptr, COUNTER))
-			omap_bandgap_writel(bg_ptr, rval->bg_counter,
+		if (OMAP_BANDGAP_HAS(bgp, COUNTER))
+			omap_bandgap_writel(bgp, rval->bg_counter,
 					    tsr->bgap_counter);
-		if (OMAP_BANDGAP_HAS(bg_ptr, MODE_CONFIG))
-			omap_bandgap_writel(bg_ptr, rval->bg_mode_ctrl,
+		if (OMAP_BANDGAP_HAS(bgp, MODE_CONFIG))
+			omap_bandgap_writel(bgp, rval->bg_mode_ctrl,
 					    tsr->bgap_mode_ctrl);
-		if (OMAP_BANDGAP_HAS(bg_ptr, TALERT)) {
-			omap_bandgap_writel(bg_ptr, rval->bg_threshold,
+		if (OMAP_BANDGAP_HAS(bgp, TALERT)) {
+			omap_bandgap_writel(bgp, rval->bg_threshold,
 					    tsr->bgap_threshold);
-			omap_bandgap_writel(bg_ptr, rval->bg_ctrl,
+			omap_bandgap_writel(bgp, rval->bg_ctrl,
 					    tsr->bgap_mask_ctrl);
 		}
 	}
@@ -1224,28 +1224,28 @@ static int omap_bandgap_restore_ctxt(struct omap_bandgap *bg_ptr)
 
 static int omap_bandgap_suspend(struct device *dev)
 {
-	struct omap_bandgap *bg_ptr = dev_get_drvdata(dev);
+	struct omap_bandgap *bgp = dev_get_drvdata(dev);
 	int err;
 
-	err = omap_bandgap_save_ctxt(bg_ptr);
-	omap_bandgap_power(bg_ptr, false);
+	err = omap_bandgap_save_ctxt(bgp);
+	omap_bandgap_power(bgp, false);
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
-		clk_disable_unprepare(bg_ptr->fclock);
+	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+		clk_disable_unprepare(bgp->fclock);
 
 	return err;
 }
 
 static int omap_bandgap_resume(struct device *dev)
 {
-	struct omap_bandgap *bg_ptr = dev_get_drvdata(dev);
+	struct omap_bandgap *bgp = dev_get_drvdata(dev);
 
-	if (OMAP_BANDGAP_HAS(bg_ptr, CLK_CTRL))
-		clk_prepare_enable(bg_ptr->fclock);
+	if (OMAP_BANDGAP_HAS(bgp, CLK_CTRL))
+		clk_prepare_enable(bgp->fclock);
 
-	omap_bandgap_power(bg_ptr, true);
+	omap_bandgap_power(bgp, true);
 
-	return omap_bandgap_restore_ctxt(bg_ptr);
+	return omap_bandgap_restore_ctxt(bgp);
 }
 static const struct dev_pm_ops omap_bandgap_dev_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(omap_bandgap_suspend,
-- 
1.7.7.1.488.ge8e1c

