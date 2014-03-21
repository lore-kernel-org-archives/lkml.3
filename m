Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbaCUNEL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:04:11 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59159 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098AbaCUNEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:04:08 -0400
Date: Fri, 21 Mar 2014 20:45:51 +0800
From: Jimmy Li <coder.liss@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2] fix some coding style in drivers/staging/iio, and a break
 missing.
Message-ID: <20140321124551.GA7475@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jimmy Li<coder.liss@gmail.com>
---
 drivers/staging/iio/accel/sca3000_core.c |    3 ++-
 drivers/staging/iio/adc/ad7192.c         |    3 ++-
 drivers/staging/iio/adc/ad7606_core.c    |    2 +-
 drivers/staging/iio/adc/ad7816.c         |    6 +++---
 drivers/staging/iio/adc/mxs-lradc.c      |    6 ++++--
 drivers/staging/iio/addac/adt7316.c      |    3 +--
 drivers/staging/iio/frequency/ad5930.c   |   23 +++++++++++++++--------
 drivers/staging/iio/frequency/ad9850.c   |    2 +-
 drivers/staging/iio/light/isl29018.c     |   10 ++++++----
 drivers/staging/iio/light/tsl2583.c      |    2 +-
 drivers/staging/iio/light/tsl2x7x_core.c |   12 ++++++------
 drivers/staging/iio/meter/ade7854-i2c.c  |    3 ++-
 drivers/staging/iio/resolver/ad2s1200.c  |    1 +
 13 files changed, 45 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/iio/accel/sca3000_core.c b/drivers/staging/iio/accel/sca3000_core.c
index ed30e32..c099294 100644
--- a/drivers/staging/iio/accel/sca3000_core.c
+++ b/drivers/staging/iio/accel/sca3000_core.c
@@ -506,7 +506,8 @@ static int sca3000_read_raw(struct iio_dev *indio_dev,
 				mutex_unlock(&st->lock);
 				return ret;
 			}
-			*val = ((st->rx[0] & 0x3F) << 3) | ((st->rx[1] & 0xE0) >> 5);
+			*val = ((st->rx[0] & 0x3F) << 3) |
+				((st->rx[1] & 0xE0) >> 5);
 		}
 		mutex_unlock(&st->lock);
 		return IIO_VAL_INT;
diff --git a/drivers/staging/iio/adc/ad7192.c b/drivers/staging/iio/adc/ad7192.c
index 83bb44b..d1f9790 100644
--- a/drivers/staging/iio/adc/ad7192.c
+++ b/drivers/staging/iio/adc/ad7192.c
@@ -223,7 +223,8 @@ static int ad7192_setup(struct ad7192_state *st,
 	id &= AD7192_ID_MASK;
 
 	if (id != st->devid)
-		dev_warn(&st->sd.spi->dev, "device ID query failed (0x%X)\n", id);
+		dev_warn(&st->sd.spi->dev,
+				"device ID query failed (0x%X)\n", id);
 
 	switch (pdata->clock_source_sel) {
 	case AD7192_CLK_EXT_MCLK1_2:
diff --git a/drivers/staging/iio/adc/ad7606_core.c b/drivers/staging/iio/adc/ad7606_core.c
index f0f05f1..bf2c801 100644
--- a/drivers/staging/iio/adc/ad7606_core.c
+++ b/drivers/staging/iio/adc/ad7606_core.c
@@ -140,7 +140,7 @@ static ssize_t ad7606_store_range(struct device *dev,
 	return count;
 }
 
-static IIO_DEVICE_ATTR(in_voltage_range, S_IRUGO | S_IWUSR, \
+static IIO_DEVICE_ATTR(in_voltage_range, S_IRUGO | S_IWUSR,
 		       ad7606_show_range, ad7606_store_range, 0);
 static IIO_CONST_ATTR(in_voltage_range_available, "5000 10000");
 
diff --git a/drivers/staging/iio/adc/ad7816.c b/drivers/staging/iio/adc/ad7816.c
index 2369cf2..ec86c01 100644
--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -153,7 +153,8 @@ static ssize_t ad7816_show_available_modes(struct device *dev,
 	return sprintf(buf, "full\npower-save\n");
 }
 
-static IIO_DEVICE_ATTR(available_modes, S_IRUGO, ad7816_show_available_modes, NULL, 0);
+static IIO_DEVICE_ATTR(available_modes, S_IRUGO,
+		ad7816_show_available_modes, NULL, 0);
 
 static ssize_t ad7816_show_channel(struct device *dev,
 		struct device_attribute *attr,
@@ -442,6 +443,5 @@ static struct spi_driver ad7816_driver = {
 module_spi_driver(ad7816_driver);
 
 MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
-MODULE_DESCRIPTION("Analog Devices AD7816/7/8 digital"
-			" temperature sensor driver");
+MODULE_DESCRIPTION("Analog Devices AD7816/7/8 digital temperature sensor driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/iio/adc/mxs-lradc.c b/drivers/staging/iio/adc/mxs-lradc.c
index 11fb952..84f7177 100644
--- a/drivers/staging/iio/adc/mxs-lradc.c
+++ b/drivers/staging/iio/adc/mxs-lradc.c
@@ -462,7 +462,8 @@ static void mxs_lradc_setup_ts_channel(struct mxs_lradc *lradc, unsigned ch)
 	 * SoC's delay unit and start the conversion later
 	 * and automatically.
 	 */
-	mxs_lradc_reg_wrt(lradc, LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
+	mxs_lradc_reg_wrt(lradc,
+		LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
 		LRADC_DELAY_TRIGGER_DELAYS(1 << 3) | /* trigger DELAY unit#3 */
 		LRADC_DELAY_KICK |
 		LRADC_DELAY_DELAY(lradc->settling_delay),
@@ -520,7 +521,8 @@ static void mxs_lradc_setup_ts_pressure(struct mxs_lradc *lradc, unsigned ch1,
 	 * SoC's delay unit and start the conversion later
 	 * and automatically.
 	 */
-	mxs_lradc_reg_wrt(lradc, LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
+	mxs_lradc_reg_wrt(lradc,
+		LRADC_DELAY_TRIGGER(0) | /* don't trigger ADC */
 		LRADC_DELAY_TRIGGER_DELAYS(1 << 3) | /* trigger DELAY unit#3 */
 		LRADC_DELAY_KICK |
 		LRADC_DELAY_DELAY(lradc->settling_delay), LRADC_DELAY(2));
diff --git a/drivers/staging/iio/addac/adt7316.c b/drivers/staging/iio/addac/adt7316.c
index 9f0ebb3..2890f04 100644
--- a/drivers/staging/iio/addac/adt7316.c
+++ b/drivers/staging/iio/addac/adt7316.c
@@ -2185,6 +2185,5 @@ int adt7316_probe(struct device *dev, struct adt7316_bus *bus,
 EXPORT_SYMBOL(adt7316_probe);
 
 MODULE_AUTHOR("Sonic Zhang <sonic.zhang@analog.com>");
-MODULE_DESCRIPTION("Analog Devices ADT7316/7/8 and ADT7516/7/9 digital"
-			" temperature sensor, ADC and DAC driver");
+MODULE_DESCRIPTION("Analog Devices ADT7316/7/8 and ADT7516/7/9 digital temperature sensor, ADC and DAC driver");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/staging/iio/frequency/ad5930.c b/drivers/staging/iio/frequency/ad5930.c
index a4aeee6..cc6a8dc 100644
--- a/drivers/staging/iio/frequency/ad5930.c
+++ b/drivers/staging/iio/frequency/ad5930.c
@@ -21,7 +21,7 @@
 
 #define DRV_NAME "ad5930"
 
-#define value_mask (u16)0xf000
+#define value_mask ((u16)0xf000)
 #define addr_shift 12
 
 /* Register format: 4 bits addr + 12 bits value */
@@ -51,13 +51,20 @@ static ssize_t ad5930_set_parameter(struct device *dev,
 	struct ad5930_state *st = iio_priv(idev);
 
 	config->control = (config->control & ~value_mask);
-	config->incnum = (config->control & ~value_mask) | (1 << addr_shift);
-	config->frqdelt[0] = (config->control & ~value_mask) | (2 << addr_shift);
-	config->frqdelt[1] = (config->control & ~value_mask) | 3 << addr_shift;
-	config->incitvl = (config->control & ~value_mask) | 4 << addr_shift;
-	config->buritvl = (config->control & ~value_mask) | 8 << addr_shift;
-	config->strtfrq[0] = (config->control & ~value_mask) | 0xc << addr_shift;
-	config->strtfrq[1] = (config->control & ~value_mask) | 0xd << addr_shift;
+	config->incnum = (config->control & ~value_mask) |
+		(1 << addr_shift);
+	config->frqdelt[0] = (config->control & ~value_mask) |
+		(2 << addr_shift);
+	config->frqdelt[1] = (config->control & ~value_mask) |
+		(3 << addr_shift);
+	config->incitvl = (config->control & ~value_mask) |
+		(4 << addr_shift);
+	config->buritvl = (config->control & ~value_mask) |
+		(8 << addr_shift);
+	config->strtfrq[0] = (config->control & ~value_mask) |
+		(0xc << addr_shift);
+	config->strtfrq[1] = (config->control & ~value_mask) |
+		(0xd << addr_shift);
 
 	xfer.len = len;
 	xfer.tx_buf = config;
diff --git a/drivers/staging/iio/frequency/ad9850.c b/drivers/staging/iio/frequency/ad9850.c
index af877ff..6183670 100644
--- a/drivers/staging/iio/frequency/ad9850.c
+++ b/drivers/staging/iio/frequency/ad9850.c
@@ -21,7 +21,7 @@
 
 #define DRV_NAME "ad9850"
 
-#define value_mask (u16)0xf000
+#define value_mask ((u16)0xf000)
 #define addr_shift 12
 
 /* Register format: 4 bits addr + 12 bits value */
diff --git a/drivers/staging/iio/light/isl29018.c b/drivers/staging/iio/light/isl29018.c
index 3660a43..b42c435 100644
--- a/drivers/staging/iio/light/isl29018.c
+++ b/drivers/staging/iio/light/isl29018.c
@@ -479,8 +479,9 @@ static int isl29018_chip_init(struct isl29018_chip *chip)
 	 */
 	status = regmap_write(chip->regmap, ISL29018_REG_TEST, 0x0);
 	if (status < 0) {
-		dev_err(chip->dev, "Failed to clear isl29018 TEST reg."
-					"(%d)\n", status);
+		dev_err(chip->dev,
+				"Failed to clear isl29018 TEST reg.(%d)\n",
+				status);
 		return status;
 	}
 
@@ -490,8 +491,9 @@ static int isl29018_chip_init(struct isl29018_chip *chip)
 	 */
 	status = regmap_write(chip->regmap, ISL29018_REG_ADD_COMMAND1, 0);
 	if (status < 0) {
-		dev_err(chip->dev, "Failed to clear isl29018 CMD1 reg."
-					"(%d)\n", status);
+		dev_err(chip->dev,
+				"Failed to clear isl29018 CMD1 reg.(%d)\n",
+				status);
 		return status;
 	}
 
diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
index 0a60def..57dcd55 100644
--- a/drivers/staging/iio/light/tsl2583.c
+++ b/drivers/staging/iio/light/tsl2583.c
@@ -787,7 +787,7 @@ static struct attribute_group tsl2583_attribute_group = {
 /* Use the default register values to identify the Taos device */
 static int taos_tsl258x_device(unsigned char *bufp)
 {
-	return ((bufp[TSL258X_CHIPID] & 0xf0) == 0x90);
+	return (bufp[TSL258X_CHIPID] & 0xf0) == 0x90;
 }
 
 static const struct iio_info tsl2583_info = {
diff --git a/drivers/staging/iio/light/tsl2x7x_core.c b/drivers/staging/iio/light/tsl2x7x_core.c
index 9e0f2a9..f1cce3a 100644
--- a/drivers/staging/iio/light/tsl2x7x_core.c
+++ b/drivers/staging/iio/light/tsl2x7x_core.c
@@ -1569,8 +1569,8 @@ static struct attribute *tsl2x7x_ALS_device_attrs[] = {
 	&dev_attr_power_state.attr,
 	&dev_attr_in_illuminance0_calibscale_available.attr,
 	&dev_attr_in_illuminance0_integration_time.attr,
-	&iio_const_attr_in_illuminance0_integration_time_available\
-	.dev_attr.attr,
+	&iio_const_attr_in_illuminance0_integration_time_available
+		.dev_attr.attr,
 	&dev_attr_in_illuminance0_target_input.attr,
 	&dev_attr_in_illuminance0_calibrate.attr,
 	&dev_attr_in_illuminance0_lux_table.attr,
@@ -1587,8 +1587,8 @@ static struct attribute *tsl2x7x_ALSPRX_device_attrs[] = {
 	&dev_attr_power_state.attr,
 	&dev_attr_in_illuminance0_calibscale_available.attr,
 	&dev_attr_in_illuminance0_integration_time.attr,
-	&iio_const_attr_in_illuminance0_integration_time_available\
-	.dev_attr.attr,
+	&iio_const_attr_in_illuminance0_integration_time_available
+		.dev_attr.attr,
 	&dev_attr_in_illuminance0_target_input.attr,
 	&dev_attr_in_illuminance0_calibrate.attr,
 	&dev_attr_in_illuminance0_lux_table.attr,
@@ -1607,8 +1607,8 @@ static struct attribute *tsl2x7x_ALSPRX2_device_attrs[] = {
 	&dev_attr_power_state.attr,
 	&dev_attr_in_illuminance0_calibscale_available.attr,
 	&dev_attr_in_illuminance0_integration_time.attr,
-	&iio_const_attr_in_illuminance0_integration_time_available\
-	.dev_attr.attr,
+	&iio_const_attr_in_illuminance0_integration_time_available
+		.dev_attr.attr,
 	&dev_attr_in_illuminance0_target_input.attr,
 	&dev_attr_in_illuminance0_calibrate.attr,
 	&dev_attr_in_illuminance0_lux_table.attr,
diff --git a/drivers/staging/iio/meter/ade7854-i2c.c b/drivers/staging/iio/meter/ade7854-i2c.c
index 5b33c7f..5d0671a 100644
--- a/drivers/staging/iio/meter/ade7854-i2c.c
+++ b/drivers/staging/iio/meter/ade7854-i2c.c
@@ -195,7 +195,8 @@ static int ade7854_i2c_read_reg_32(struct device *dev,
 	if (ret)
 		goto out;
 
-	*val = (st->rx[0] << 24) | (st->rx[1] << 16) | (st->rx[2] << 8) | st->rx[3];
+	*val = (st->rx[0] << 24) | (st->rx[1] << 16) |
+		(st->rx[2] << 8) | st->rx[3];
 out:
 	mutex_unlock(&st->buf_lock);
 	return ret;
diff --git a/drivers/staging/iio/resolver/ad2s1200.c b/drivers/staging/iio/resolver/ad2s1200.c
index 36eedd8..e2b4820 100644
--- a/drivers/staging/iio/resolver/ad2s1200.c
+++ b/drivers/staging/iio/resolver/ad2s1200.c
@@ -70,6 +70,7 @@ static int ad2s1200_read_raw(struct iio_dev *indio_dev,
 		vel = (((s16)(st->rx[0])) << 4) | ((st->rx[1] & 0xF0) >> 4);
 		vel = (vel << 4) >> 4;
 		*val = vel;
+		break;
 	default:
 		mutex_unlock(&st->lock);
 		return -EINVAL;
-- 
1.7.9.5

