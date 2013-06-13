Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759134Ab3FMSaJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:30:09 -0400
Received: from etezian.org ([198.101.225.253]:56460 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758959Ab3FMS3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:29:00 -0400
From: Andi Shyti <andi@etezian.org>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, pc@asdf.org, oatilla@gmail.com,
        andi@etezian.org
Subject: [PATCH 13/19] bh1770glc: Code cleaning and aligning in source code
Date: Thu, 13 Jun 2013 20:20:47 +0200
Message-Id: <ccace4fcc6af928dfc0b4cc95b5f021ed2767e23.1371145891.git.andi@etezian.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
In-Reply-To: <cover.1371145891.git.andi@etezian.org>
References: <cover.1371145891.git.andi@etezian.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Onur Atilla <oatilla@gmail.com>

Removed unused variables and definitions, adjusted some code
alignement and removed trailing spaces.

Signed-off-by: Onur Atilla <oatilla@gmail.com>
Signed-off-by: Andi Shyti <andi@etezian.org>
---
 drivers/misc/bh1770glc.c      |   55 +++++++++++++++++++----------------------
 include/linux/i2c/bh1770glc.h |   25 ++++++++++---------
 2 files changed, 38 insertions(+), 42 deletions(-)

diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index fe49964..054d3f3 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -105,27 +105,25 @@
 #define BH1770_ENABLE		1
 #define BH1770_PROX_CHANNELS	1
 
-#define BH1770_LUX_DEFAULT_RATE	1 /* Index to lux rate table */
-#define BH1770_PROX_DEFAULT_RATE 1 /* Direct HW value =~ 50Hz */
-#define BH1770_PROX_DEF_RATE_THRESH 6 /* Direct HW value =~ 5 Hz */
-#define BH1770_STARTUP_DELAY	50
-#define BH1770_RESET_TIME	10
-#define BH1770_TIMEOUT		2100 /* Timeout in 2.1 seconds */
-
-#define BH1770_LUX_RANGE	65535
-#define BH1770_PROX_RANGE	255
-#define BH1770_COEF_SCALER	1024
-#define BH1770_CALIB_SCALER	8192
-#define BH1770_LUX_NEUTRAL_CALIB_VALUE (1 * BH1770_CALIB_SCALER)
-#define BH1770_LUX_DEF_THRES	1000
-#define BH1770_PROX_DEF_THRES	70
-#define BH1770_PROX_DEF_ABS_THRES   100
-#define BH1770_DEFAULT_PERSISTENCE  10
-#define BH1770_PROX_MAX_PERSISTENCE 50
 #define BH1770_LUX_GA_SCALE	16384
 #define BH1770_LUX_CF_SCALE	2048 /* CF ChipFactor */
-#define BH1770_NEUTRAL_CF	BH1770_LUX_CF_SCALE
-#define BH1770_LUX_CORR_SCALE	4096
+#define BH1770_LUX_DEFAULT_RATE		1 /* Index to lux rate table */
+#define BH1770_PROX_DEFAULT_RATE	1 /* Direct HW value =~ 50Hz */
+#define BH1770_PROX_DEF_RATE_THRESH	6 /* Direct HW value =~ 5 Hz */
+#define BH1770_STARTUP_DELAY		50
+#define BH1770_RESET_TIME		10
+#define BH1770_TIMEOUT			2100 /* Timeout in 2.1 seconds */
+
+#define BH1770_LUX_RANGE		65535
+#define BH1770_PROX_RANGE		255
+#define BH1770_CALIB_SCALER		8192
+#define BH1770_LUX_NEUTRAL_CALIB_VALUE	(1 * BH1770_CALIB_SCALER)
+#define BH1770_LUX_DEF_THRES		1000
+#define BH1770_PROX_DEF_THRES		100
+#define BH1770_DEFAULT_PERSISTENCE	10
+#define BH1770_PROX_MAX_PERSISTENCE	50
+#define BH1770_NEUTRAL_CF		BH1770_LUX_CF_SCALE
+#define BH1770_LUX_CORR_SCALE		4096
 
 #define PROX_ABOVE_THRESHOLD	1
 #define PROX_BELOW_THRESHOLD	0
@@ -158,7 +156,6 @@ struct bh1770_chip {
 
 	int	prox_enable_count;
 	u16	prox_coef;
-	u16	prox_const;
 	int	prox_rate;
 	int	prox_rate_threshold;
 	u8	prox_persistence;
@@ -356,7 +353,7 @@ static int bh1770_ps_get_result(struct bh1770_chip *chip)
 	 * when ALS levels goes above limit, proximity result may be
 	 * false proximity. Thus ignore the result. With real proximity
 	 * there is a shadow causing low als levels.
-	*/
+	 */
 	if (chip->lux_data_raw > PROX_IGNORE_LUX_LIMIT)
 		return 0;
 
@@ -547,8 +544,6 @@ static int bh1770_detect(struct bh1770_chip *chip)
 	part = (u8)ret;
 
 	chip->revision = (part & BH1770_REV_MASK) >> BH1770_REV_SHIFT;
-	chip->prox_coef = BH1770_COEF_SCALER;
-	chip->prox_const = 0;
 	chip->lux_cf = BH1770_NEUTRAL_CF;
 	chip->prox_min_threshold = BH1770_PROX_DEF_THRES;
 
@@ -816,7 +811,7 @@ static ssize_t bh1770_prox_enable_show(struct device *dev,
 static ssize_t bh1770_prox_result_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
-	struct bh1770_chip *chip =  dev_get_drvdata(dev);
+	struct bh1770_chip *chip = dev_get_drvdata(dev);
 	ssize_t ret;
 
 	mutex_lock(&chip->mutex);
@@ -1218,7 +1213,6 @@ static DEVICE_ATTR(chip_id, S_IRUGO, bh1770_chip_id_show, NULL);
 static DEVICE_ATTR(power_state, S_IRUGO | S_IWUSR, bh1770_power_state_show,
 						 bh1770_power_state_store);
 
-
 static struct attribute *sysfs_attrs[] = {
 	&dev_attr_lux0_calibscale.attr,
 	&dev_attr_lux0_calibscale_default.attr,
@@ -1282,11 +1276,6 @@ static int bh1770_probe(struct i2c_client *client,
 	else
 		chip->lux_ga = chip->pdata->glass_attenuation;
 
-	chip->prox_led		= chip->pdata->led_def_curr;
-	chip->prox_persistence	= BH1770_DEFAULT_PERSISTENCE;
-	chip->prox_rate_threshold = BH1770_PROX_DEF_RATE_THRESH;
-	chip->prox_rate		= BH1770_PROX_DEFAULT_RATE;
-	chip->prox_data		= 0;
 	/* Make sure that the given hysteresis value is in range */
 	if ((chip->pdata->prox_hysteresis > BH1770_PROX_RANGE) ||
 		(chip->pdata->prox_hysteresis < 0)) {
@@ -1295,6 +1284,12 @@ static int bh1770_probe(struct i2c_client *client,
 		chip->prox_hysteresis = chip->pdata->prox_hysteresis;
 	}
 
+	chip->prox_led			= chip->pdata->led_def_curr;
+	chip->prox_persistence		= BH1770_DEFAULT_PERSISTENCE;
+	chip->prox_rate_threshold	= BH1770_PROX_DEF_RATE_THRESH;
+	chip->prox_rate			= BH1770_PROX_DEFAULT_RATE;
+	chip->prox_data			= 0;
+
 	chip->regs[0].supply = reg_vcc;
 	chip->regs[1].supply = reg_vleds;
 
diff --git a/include/linux/i2c/bh1770glc.h b/include/linux/i2c/bh1770glc.h
index ed670dd..3efbae4 100644
--- a/include/linux/i2c/bh1770glc.h
+++ b/include/linux/i2c/bh1770glc.h
@@ -25,6 +25,15 @@
 #ifndef __BH1770_H__
 #define __BH1770_H__
 
+#define BH1770_LED_5mA		0
+#define BH1770_LED_10mA		1
+#define BH1770_LED_20mA		2
+#define BH1770_LED_50mA		3
+#define BH1770_LED_100mA	4
+#define BH1770_LED_150mA	5
+#define BH1770_LED_200mA	6
+#define BH1770_NEUTRAL_GA 16384 /* 16384 / 16384 = 1 */
+
 /**
  * struct bh1770_platform_data - platform data for bh1770glc driver
  * @led_def_curr: IR led driving current.
@@ -37,18 +46,10 @@
  */
 
 struct bh1770_platform_data {
-#define BH1770_LED_5mA	0
-#define BH1770_LED_10mA	1
-#define BH1770_LED_20mA	2
-#define BH1770_LED_50mA	3
-#define BH1770_LED_100mA 4
-#define BH1770_LED_150mA 5
-#define BH1770_LED_200mA 6
-	__u8 led_def_curr;
-#define BH1770_NEUTRAL_GA 16384 /* 16384 / 16384 = 1 */
-	__u32 glass_attenuation;
-	__u32 als_scf_BH1770;
-	__u32 als_scf_SFH7770;
+	u8 led_def_curr;
+	u32 glass_attenuation;
+	u32 als_scf_BH1770;
+	u32 als_scf_SFH7770;
 	u8 prox_hysteresis;
 	u8 prox_min_thresh_BH1770;
 	u8 prox_min_thresh_SFH7770;
-- 
1.7.10.4

