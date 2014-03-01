Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaCATdn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 14:33:43 -0500
Received: from ring0.de ([5.45.105.125]:46547 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbaCATdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 14:33:39 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@debian.org>
To: Sebastian Reichel <sre@ring0.de>, Marek Belisko <marek@goldelico.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Sebastian Reichel <sre@debian.org>
Subject: [PATCHv1 3/9] mfd: twl4030-madc: Cleanup driver
Date: Sat,  1 Mar 2014 20:32:39 +0100
Message-Id: <1393702365-26429-4-git-send-email-sre@debian.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1393702365-26429-1-git-send-email-sre@debian.org>
References: <1393444990-28140-1-git-send-email-sre@debian.org>
 <1393702365-26429-1-git-send-email-sre@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some style fixes in twl4030-madc driver.

Reported-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Sebastian Reichel <sre@debian.org>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/twl4030-madc.c       | 125 +++++++++++++++++++--------------------
 include/linux/i2c/twl4030-madc.h |   2 +-
 2 files changed, 61 insertions(+), 66 deletions(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 8d09abb..35514e0 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -49,22 +49,22 @@
 
 #include <linux/iio/iio.h>
 
-/*
+/**
  * struct twl4030_madc_data - a container for madc info
- * @dev - pointer to device structure for madc
- * @lock - mutex protecting this data structure
- * @requests - Array of request struct corresponding to SW1, SW2 and RT
- * @use_second_irq - IRQ selection (main or co-processor)
- * @imr - Interrupt mask register of MADC
- * @isr - Interrupt status register of MADC
+ * @dev:		Pointer to device structure for madc
+ * @lock:		Mutex protecting this data structure
+ * @requests:		Array of request struct corresponding to SW1, SW2 and RT
+ * @use_second_irq:	IRQ selection (main or co-processor)
+ * @imr:		Interrupt mask register of MADC
+ * @isr:		Interrupt status register of MADC
  */
 struct twl4030_madc_data {
 	struct device *dev;
 	struct mutex lock;	/* mutex protecting this data structure */
 	struct twl4030_madc_request requests[TWL4030_MADC_NUM_METHODS];
 	bool use_second_irq;
-	int imr;
-	int isr;
+	u8 imr;
+	u8 isr;
 };
 
 static int twl4030_madc_read(struct iio_dev *iio_dev,
@@ -157,17 +157,16 @@ twl4030_divider_ratios[16] = {
 };
 
 
-/*
- * Conversion table from -3 to 55 degree Celcius
- */
-static int therm_tbl[] = {
-30800,	29500,	28300,	27100,
-26000,	24900,	23900,	22900,	22000,	21100,	20300,	19400,	18700,	17900,
-17200,	16500,	15900,	15300,	14700,	14100,	13600,	13100,	12600,	12100,
-11600,	11200,	10800,	10400,	10000,	9630,	9280,	8950,	8620,	8310,
-8020,	7730,	7460,	7200,	6950,	6710,	6470,	6250,	6040,	5830,
-5640,	5450,	5260,	5090,	4920,	4760,	4600,	4450,	4310,	4170,
-4040,	3910,	3790,	3670,	3550
+/* Conversion table from -3 to 55 degrees Celcius */
+static int twl4030_therm_tbl[] = {
+	30800,	29500,	28300,	27100,
+	26000,	24900,	23900,	22900,	22000,	21100,	20300,	19400,	18700,
+	17900,	17200,	16500,	15900,	15300,	14700,	14100,	13600,	13100,
+	12600,	12100,	11600,	11200,	10800,	10400,	10000,	9630,	9280,
+	8950,	8620,	8310,	8020,	7730,	7460,	7200,	6950,	6710,
+	6470,	6250,	6040,	5830,	5640,	5450,	5260,	5090,	4920,
+	4760,	4600,	4450,	4310,	4170,	4040,	3910,	3790,	3670,
+	3550
 };
 
 /*
@@ -199,11 +198,12 @@ const struct twl4030_madc_conversion_method twl4030_conversion_methods[] = {
 			      },
 };
 
-/*
- * Function to read a particular channel value.
- * @madc - pointer to struct twl4030_madc_data
- * @reg - lsb of ADC Channel
- * If the i2c read fails it returns an error else returns 0.
+/**
+ * twl4030_madc_channel_raw_read() - Function to read a particular channel value
+ * @madc:	pointer to struct twl4030_madc_data
+ * @reg:	lsb of ADC Channel
+ *
+ * Return: 0 on success, an error code otherwise.
  */
 static int twl4030_madc_channel_raw_read(struct twl4030_madc_data *madc, u8 reg)
 {
@@ -229,7 +229,7 @@ static int twl4030_madc_channel_raw_read(struct twl4030_madc_data *madc, u8 reg)
 }
 
 /*
- * Return battery temperature
+ * Return battery temperature in degrees Celsius
  * Or < 0 on failure.
  */
 static int twl4030battery_temperature(int raw_volt)
@@ -238,18 +238,18 @@ static int twl4030battery_temperature(int raw_volt)
 	int temp, curr, volt, res, ret;
 
 	volt = (raw_volt * TEMP_STEP_SIZE) / TEMP_PSR_R;
-	/* Getting and calculating the supply current in micro ampers */
+	/* Getting and calculating the supply current in micro amperes */
 	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE, &val,
 		REG_BCICTL2);
 	if (ret < 0)
 		return ret;
+
 	curr = ((val & TWL4030_BCI_ITHEN) + 1) * 10;
 	/* Getting and calculating the thermistor resistance in ohms */
 	res = volt * 1000 / curr;
 	/* calculating temperature */
 	for (temp = 58; temp >= 0; temp--) {
-		int actual = therm_tbl[temp];
-
+		int actual = twl4030_therm_tbl[temp];
 		if ((actual - res) >= 0)
 			break;
 	}
@@ -271,11 +271,12 @@ static int twl4030battery_current(int raw_volt)
 	else /* slope of 0.88 mV/mA */
 		return (raw_volt * CURR_STEP_SIZE) / CURR_PSR_R2;
 }
+
 /*
  * Function to read channel values
  * @madc - pointer to twl4030_madc_data struct
  * @reg_base - Base address of the first channel
- * @Channels - 16 bit bitmap. If the bit is set, channel value is read
+ * @Channels - 16 bit bitmap. If the bit is set, channel's value is read
  * @buf - The channel values are stored here. if read fails error
  * @raw - Return raw values without conversion
  * value is stored
@@ -286,17 +287,17 @@ static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
 				      long channels, int *buf,
 				      bool raw)
 {
-	int count = 0, count_req = 0, i;
+	int count = 0;
+	int i;
 	u8 reg;
 
 	for_each_set_bit(i, &channels, TWL4030_MADC_MAX_CHANNELS) {
-		reg = reg_base + 2 * i;
+		u8 reg = reg_base + (2 * i);
 		buf[i] = twl4030_madc_channel_raw_read(madc, reg);
 		if (buf[i] < 0) {
-			dev_err(madc->dev,
-				"Unable to read register 0x%X\n", reg);
-			count_req++;
-			continue;
+			dev_err(madc->dev, "Unable to read register 0x%X\n",
+				reg);
+			return buf[i];
 		}
 		if (raw) {
 			count++;
@@ -307,7 +308,7 @@ static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
 			buf[i] = twl4030battery_current(buf[i]);
 			if (buf[i] < 0) {
 				dev_err(madc->dev, "err reading current\n");
-				count_req++;
+				return buf[i];
 			} else {
 				count++;
 				buf[i] = buf[i] - 750;
@@ -317,7 +318,7 @@ static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
 			buf[i] = twl4030battery_temperature(buf[i]);
 			if (buf[i] < 0) {
 				dev_err(madc->dev, "err reading temperature\n");
-				count_req++;
+				return buf[i];
 			} else {
 				buf[i] -= 3;
 				count++;
@@ -338,8 +339,6 @@ static int twl4030_madc_read_channels(struct twl4030_madc_data *madc,
 				twl4030_divider_ratios[i].numerator);
 		}
 	}
-	if (count_req)
-		dev_err(madc->dev, "%d channel conversion failed\n", count_req);
 
 	return count;
 }
@@ -363,13 +362,13 @@ static int twl4030_madc_enable_irq(struct twl4030_madc_data *madc, u8 id)
 			madc->imr);
 		return ret;
 	}
+
 	val &= ~(1 << id);
 	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, val, madc->imr);
 	if (ret) {
 		dev_err(madc->dev,
 			"unable to write imr register 0x%X\n", madc->imr);
 		return ret;
-
 	}
 
 	return 0;
@@ -432,7 +431,7 @@ static irqreturn_t twl4030_madc_threaded_irq_handler(int irq, void *_madc)
 			continue;
 		ret = twl4030_madc_disable_irq(madc, i);
 		if (ret < 0)
-			dev_dbg(madc->dev, "Disable interrupt failed%d\n", i);
+			dev_dbg(madc->dev, "Disable interrupt failed %d\n", i);
 		madc->requests[i].result_pending = 1;
 	}
 	for (i = 0; i < TWL4030_MADC_NUM_METHODS; i++) {
@@ -514,21 +513,17 @@ static int twl4030_madc_start_conversion(struct twl4030_madc_data *madc,
 {
 	const struct twl4030_madc_conversion_method *method;
 	int ret = 0;
+
+	if (conv_method != TWL4030_MADC_SW1 && conv_method != TWL4030_MADC_SW2)
+		return -ENOTSUPP;
+
 	method = &twl4030_conversion_methods[conv_method];
-	switch (conv_method) {
-	case TWL4030_MADC_SW1:
-	case TWL4030_MADC_SW2:
-		ret = twl_i2c_write_u8(TWL4030_MODULE_MADC,
-				       TWL4030_MADC_SW_START, method->ctrl);
-		if (ret) {
-			dev_err(madc->dev,
-				"unable to write ctrl register 0x%X\n",
-				method->ctrl);
-			return ret;
-		}
-		break;
-	default:
-		break;
+	ret = twl_i2c_write_u8(TWL4030_MODULE_MADC, TWL4030_MADC_SW_START,
+			       method->ctrl);
+	if (ret) {
+		dev_err(madc->dev, "unable to write ctrl register 0x%X\n",
+			method->ctrl);
+		return ret;
 	}
 
 	return 0;
@@ -625,8 +620,8 @@ int twl4030_madc_conversion(struct twl4030_madc_request *req)
 				       ch_lsb, method->avg);
 		if (ret) {
 			dev_err(twl4030_madc->dev,
-				"unable to write sel reg 0x%X\n",
-				method->sel + 1);
+				"unable to write avg reg 0x%X\n",
+				method->avg);
 			goto out;
 		}
 	}
@@ -667,10 +662,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(twl4030_madc_conversion);
 
-/*
- * Return channel value
- * Or < 0 on failure.
- */
 int twl4030_get_madc_conversion(int channel_no)
 {
 	struct twl4030_madc_request req;
@@ -705,6 +696,7 @@ static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc,
 					      int chan, int on)
 {
 	int ret;
+	int regmask;
 	u8 regval;
 
 	ret = twl_i2c_read_u8(TWL_MODULE_MAIN_CHARGE,
@@ -714,10 +706,13 @@ static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc,
 			TWL4030_BCI_BCICTL1);
 		return ret;
 	}
+
+	regmask = chan ? TWL4030_BCI_ITHEN : TWL4030_BCI_TYPEN;
 	if (on)
-		regval |= chan ? TWL4030_BCI_ITHEN : TWL4030_BCI_TYPEN;
+		regval |= regmask;
 	else
-		regval &= chan ? ~TWL4030_BCI_ITHEN : ~TWL4030_BCI_TYPEN;
+		regval &= ~regmask;
+
 	ret = twl_i2c_write_u8(TWL_MODULE_MAIN_CHARGE,
 			       regval, TWL4030_BCI_BCICTL1);
 	if (ret) {
@@ -732,7 +727,7 @@ static int twl4030_madc_set_current_generator(struct twl4030_madc_data *madc,
 /*
  * Function that sets MADC software power on bit to enable MADC
  * @madc - pointer to twl4030_madc_data struct
- * @on - Enable or disable MADC software powen on bit.
+ * @on - Enable or disable MADC software power on bit.
  * returns error if i2c read/write fails else 0
  */
 static int twl4030_madc_set_power(struct twl4030_madc_data *madc, int on)
diff --git a/include/linux/i2c/twl4030-madc.h b/include/linux/i2c/twl4030-madc.h
index 01f5951..1c0134d 100644
--- a/include/linux/i2c/twl4030-madc.h
+++ b/include/linux/i2c/twl4030-madc.h
@@ -44,7 +44,7 @@ struct twl4030_madc_conversion_method {
 
 struct twl4030_madc_request {
 	unsigned long channels;
-	u16 do_avg;
+	bool do_avg;
 	u16 method;
 	u16 type;
 	bool active;
-- 
1.9.0

