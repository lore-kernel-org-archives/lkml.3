Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab3FCJIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:08:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25434 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3FCJI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:08:29 -0400
X-AuditID: cbfee68e-b7f276d000002279-98-51ac5d09f29d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "'Eric Piel'" <eric.piel@tremplin-utc.net>,
        "'Dimitri Sivanich'" <sivanich@sgi.com>, "'Robin Holt'" <holt@sgi.com>,
        "'Andy Shevchenko'" <andy.shevchenko@gmail.com>
Subject: [PATCH V2] misc: replace strict_strtoul() with kstrtoul()
Date: Mon, 03 Jun 2013 18:08:25 +0900
Message-id: <001601ce6039$e7807180$b6815480$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5gOdV3AsbiQecwQxmVBjFNfYAX7Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zY13O2DWBBif3G1m8nHCY0eLvpGPs
	Fof/XmKxaF68ns2if1oHq8XlhZeAxK45bBYTDm9mt5i8pY3dgdPj1VVHj9+/JjF67Jx1l91j
	/9w17B59W1Yxety9/pLJ40ILt8fnTXIBHFFcNimpOZllqUX6dglcGYe/yhec62Cs+NTyj7mB
	cWtOFyMnh4SAicTBJV1MELaYxIV769m6GLk4hASWMUp8bjvKDFM07+4hVojEdEaJCVPbWUAS
	QgK/GCUab5aB2GwCahJfvhxmB7FFBEwlNr6fwgjSwCywh0niybbtrCAJYQEniftft4DZLAKq
	Eke/7GcDsXkFLCWOf9vHDmELSvyYfA9sAbOAlsT6nceZIGx5ic1r3kJdpCCx4+xrRohlehJ7
	3r5kh6gRkdj34h3YYgmBr+wSs3acZIdYJiDxbfIhoKEcQAlZiU0HoOZIShxccYNlAqPYLCSr
	ZyFZPQvJ6llIVixgZFnFKJpakFxQnJReZKRXnJhbXJqXrpecn7uJERK/fTsYbx6wPsSYDLR+
	IrOUaHI+MP7zSuINjc2MLExNTI2NzC3NSBNWEudVa7EOFBJITyxJzU5NLUgtii8qzUktPsTI
	xMEp1cBoaqC0MHNSVLTO36ksq7/2crir7tXdZxPLvqHtWgPHHg+TxZwXFy2WDH/obuTKM9lY
	nj9HvqtE8ejpVzGpChJlbydXh5uKeYqKXTzrksNsNd/18LPG73faF61tYtw+zWJ7We6t4CPa
	a7ct/+Fy+48YQ54+064MHYvJaQH2cp6NMjYmhc1vDZVYijMSDbWYi4oTAba21kX1AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jQV3O2DWBBhuvaFu8nHCY0eLvpGPs
	Fof/XmKxaF68ns2if1oHq8XlhZeAxK45bBYTDm9mt5i8pY3dgdPj1VVHj9+/JjF67Jx1l91j
	/9w17B59W1Yxety9/pLJ40ILt8fnTXIBHFENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYG
	hrqGlhbmSgp5ibmptkouPgG6bpk5QOcpKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLr
	MTJAAwnrGDMOf5UvONfBWPGp5R9zA+PWnC5GTg4JAROJeXcPsULYYhIX7q1n62Lk4hASmM4o
	MWFqOwtIQkjgF6NE480yEJtNQE3iy5fD7CC2iICpxMb3UxhBGpgF9jBJPNm2HWySsICTxP2v
	W8BsFgFViaNf9rOB2LwClhLHv+1jh7AFJX5Mvge2gFlAS2L9zuNMELa8xOY1b5khLlKQ2HH2
	NSPEMj2JPW9fskPUiEjse/GOcQKjwCwko2YhGTULyahZSFoWMLKsYhRNLUguKE5KzzXSK07M
	LS7NS9dLzs/dxAhODs+kdzCuarA4xCjAwajEwxvgsSZQiDWxrLgy9xCjBAezkgjvlUCgEG9K
	YmVValF+fFFpTmrxIcZkoE8nMkuJJucDE1deSbyhsYmZkaWRmYWRibk5acJK4rwHW60DhQTS
	E0tSs1NTC1KLYLYwcXBKNTCWHq4LU1V9EdQ5z2D6WbXzh6W1zEz8l1/rqbwbrXH/cmPPk6PR
	F266dH08wc7eGHmiTjL2xdyzF8Ucwp63hl1c8S7FpfZQdmoy71w9d5GQo4uKpSR3W7zk0JLX
	bl958fbGsMOfts1ruFq8cZrW3nVTO5YeXibgxi6yRvBuidm9+0yFdimqX5qVWIozEg21mIuK
	EwGvAeTxUgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred, because
strict_strtoul() is obsolete. Thus, kstrtoul() should be
used.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Used return code from kstrtoul().

 drivers/misc/ad525x_dpot.c              |    2 +-
 drivers/misc/apds9802als.c              |    5 +--
 drivers/misc/apds990x.c                 |   37 ++++++++++++-------
 drivers/misc/bh1770glc.c                |   59 ++++++++++++++++++++-----------
 drivers/misc/bh1780gli.c                |    2 +-
 drivers/misc/carma/carma-fpga-program.c |   10 +++---
 drivers/misc/carma/carma-fpga.c         |    4 +--
 drivers/misc/hmc6352.c                  |    5 +--
 drivers/misc/isl29003.c                 |   20 ++++++-----
 drivers/misc/isl29020.c                 |    6 ++--
 drivers/misc/lis3lv02d/lis3lv02d.c      |    6 ++--
 drivers/misc/sgi-gru/gruprocfs.c        |    7 ++--
 drivers/misc/spear13xx_pcie_gadget.c    |   57 +++++++++++++++++++----------
 drivers/misc/ti_dac7512.c               |    6 ++--
 14 files changed, 146 insertions(+), 80 deletions(-)

diff --git a/drivers/misc/ad525x_dpot.c b/drivers/misc/ad525x_dpot.c
index 8f99e8e..0daadcf 100644
--- a/drivers/misc/ad525x_dpot.c
+++ b/drivers/misc/ad525x_dpot.c
@@ -470,7 +470,7 @@ static ssize_t sysfs_set_reg(struct device *dev,
 		!test_bit(DPOT_RDAC_MASK & reg, data->otp_en_mask))
 		return -EPERM;
 
-	err = strict_strtoul(buf, 10, &value);
+	err = kstrtoul(buf, 10, &value);
 	if (err)
 		return err;
 
diff --git a/drivers/misc/apds9802als.c b/drivers/misc/apds9802als.c
index 5b5fd84..0c6e037 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -126,8 +126,9 @@ static ssize_t als_sensing_range_store(struct device *dev,
 	int ret_val;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	ret_val = kstrtoul(buf, 10, &val);
+	if (ret_val)
+		return ret_val;
 
 	if (val < 4096)
 		val = 1;
diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index 98f9bb2..868a30a 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -696,9 +696,11 @@ static ssize_t apds990x_lux_calib_store(struct device *dev,
 {
 	struct apds990x_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	chip->lux_calib = value;
 
@@ -759,8 +761,9 @@ static ssize_t apds990x_rate_store(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	ret = apds990x_set_arate(chip, value);
@@ -813,9 +816,11 @@ static ssize_t apds990x_prox_enable_store(struct device *dev,
 {
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 
@@ -892,11 +897,12 @@ static ssize_t apds990x_lux_thresh_below_show(struct device *dev,
 static ssize_t apds990x_set_lux_thresh(struct apds990x_chip *chip, u32 *target,
 				const char *buf)
 {
-	int ret = 0;
 	unsigned long thresh;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &thresh))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &thresh);
+	if (ret)
+		return ret;
 
 	if (thresh > APDS_RANGE)
 		return -EINVAL;
@@ -957,9 +963,11 @@ static ssize_t apds990x_prox_threshold_store(struct device *dev,
 {
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	if ((value > APDS_RANGE) || (value == 0) ||
 		(value < APDS_PROX_HYSTERESIS))
@@ -990,9 +998,12 @@ static ssize_t apds990x_power_state_store(struct device *dev,
 {
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
 	if (value) {
 		pm_runtime_get_sync(dev);
 		mutex_lock(&chip->mutex);
diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index f4975f7..99a0468 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -651,8 +651,9 @@ static ssize_t bh1770_power_state_store(struct device *dev,
 	unsigned long value;
 	ssize_t ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	if (value) {
@@ -726,9 +727,11 @@ static ssize_t bh1770_prox_enable_store(struct device *dev,
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	/* Assume no proximity. Sensor will tell real state soon */
@@ -824,9 +827,11 @@ static ssize_t bh1770_set_prox_rate_above(struct device *dev,
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	chip->prox_rate_threshold = bh1770_prox_rate_validate(value);
@@ -840,9 +845,11 @@ static ssize_t bh1770_set_prox_rate_below(struct device *dev,
 {
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	chip->prox_rate = bh1770_prox_rate_validate(value);
@@ -865,8 +872,10 @@ static ssize_t bh1770_set_prox_thres(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
+
 	if (value > BH1770_PROX_RANGE)
 		return -EINVAL;
 
@@ -893,9 +902,11 @@ static ssize_t bh1770_prox_persistence_store(struct device *dev,
 {
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	if (value > BH1770_PROX_MAX_PERSISTENCE)
 		return -EINVAL;
@@ -918,9 +929,11 @@ static ssize_t bh1770_prox_abs_thres_store(struct device *dev,
 {
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	if (value > BH1770_PROX_RANGE)
 		return -EINVAL;
@@ -963,9 +976,11 @@ static ssize_t bh1770_lux_calib_store(struct device *dev,
 	unsigned long value;
 	u32 old_calib;
 	u32 new_corr;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &value);
+	if (ret)
+		return ret;
 
 	mutex_lock(&chip->mutex);
 	old_calib = chip->lux_calib;
@@ -1012,8 +1027,9 @@ static ssize_t bh1770_set_lux_rate(struct device *dev,
 	unsigned long rate_hz;
 	int ret, i;
 
-	if (strict_strtoul(buf, 0, &rate_hz))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &rate_hz);
+	if (ret)
+		return ret;
 
 	for (i = 0; i < ARRAY_SIZE(lux_rates_hz) - 1; i++)
 		if (rate_hz >= lux_rates_hz[i])
@@ -1047,11 +1063,12 @@ static ssize_t bh1770_get_lux_thresh_below(struct device *dev,
 static ssize_t bh1770_set_lux_thresh(struct bh1770_chip *chip, u16 *target,
 				const char *buf)
 {
-	int ret = 0;
 	unsigned long thresh;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &thresh))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &thresh);
+	if (ret)
+		return ret;
 
 	if (thresh > BH1770_LUX_RANGE)
 		return -EINVAL;
diff --git a/drivers/misc/bh1780gli.c b/drivers/misc/bh1780gli.c
index 818f3a0..057580e 100644
--- a/drivers/misc/bh1780gli.c
+++ b/drivers/misc/bh1780gli.c
@@ -107,7 +107,7 @@ static ssize_t bh1780_store_power_state(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 0, &val);
+	error = kstrtoul(buf, 0, &val);
 	if (error)
 		return error;
 
diff --git a/drivers/misc/carma/carma-fpga-program.c b/drivers/misc/carma/carma-fpga-program.c
index fa017cf..c6bd7e8 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -830,8 +830,9 @@ static ssize_t penable_store(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &val))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 
 	if (val) {
 		ret = fpga_enable_power_supplies(priv);
@@ -859,8 +860,9 @@ static ssize_t program_store(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &val))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
 
 	/* We can't have an image writer and be programming simultaneously */
 	if (mutex_lock_interruptible(&priv->lock))
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index a2128af..7b56563 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -1002,10 +1002,10 @@ static ssize_t data_en_set(struct device *dev, struct device_attribute *attr,
 	unsigned long enable;
 	int ret;
 
-	ret = strict_strtoul(buf, 0, &enable);
+	ret = kstrtoul(buf, 0, &enable);
 	if (ret) {
 		dev_err(priv->dev, "unable to parse enable input\n");
-		return -EINVAL;
+		return ret;
 	}
 
 	/* protect against concurrent enable/disable */
diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
index 423cd40..170bd3d 100644
--- a/drivers/misc/hmc6352.c
+++ b/drivers/misc/hmc6352.c
@@ -46,8 +46,9 @@ static int compass_store(struct device *dev, const char *buf, size_t count,
 	int ret;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
 	if (val >= strlen(map))
 		return -EINVAL;
 	mutex_lock(&compass_mutex);
diff --git a/drivers/misc/isl29003.c b/drivers/misc/isl29003.c
index c5145b3..741071c 100644
--- a/drivers/misc/isl29003.c
+++ b/drivers/misc/isl29003.c
@@ -208,8 +208,9 @@ static ssize_t isl29003_store_range(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 3))
-		return -EINVAL;
+	ret = (kstrtoul(buf, 10, &val) < 0) || (val > 3);
+	if (ret)
+		return ret;
 
 	ret = isl29003_set_range(client, val);
 	if (ret < 0)
@@ -239,8 +240,9 @@ static ssize_t isl29003_store_resolution(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 3))
-		return -EINVAL;
+	ret = (kstrtoul(buf, 10, &val) < 0) || (val > 3);
+	if (ret)
+		return ret;
 
 	ret = isl29003_set_resolution(client, val);
 	if (ret < 0)
@@ -267,8 +269,9 @@ static ssize_t isl29003_store_mode(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 2))
-		return -EINVAL;
+	ret = (kstrtoul(buf, 10, &val) < 0) || (val > 2);
+	if (ret)
+		return ret;
 
 	ret = isl29003_set_mode(client, val);
 	if (ret < 0)
@@ -298,8 +301,9 @@ static ssize_t isl29003_store_power_state(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 1))
-		return -EINVAL;
+	ret = (kstrtoul(buf, 10, &val) < 0) || (val > 1);
+	if (ret)
+		return ret;
 
 	ret = isl29003_set_power_state(client, val);
 	return ret ? ret : count;
diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index 0aa08c7..b7f84da 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -90,8 +90,10 @@ static ssize_t als_sensing_range_store(struct device *dev,
 	int ret_val;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
-		return -EINVAL;
+	ret_val = kstrtoul(buf, 10, &val);
+	if (ret_val)
+		return ret_val;
+
 	if (val < 1 || val > 64000)
 		return -EINVAL;
 
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 4cd4a3d..036effe 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -831,9 +831,11 @@ static ssize_t lis3lv02d_rate_set(struct device *dev,
 {
 	struct lis3lv02d *lis3 = dev_get_drvdata(dev);
 	unsigned long rate;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &rate))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &rate);
+	if (ret)
+		return ret;
 
 	lis3lv02d_sysfs_poweron(lis3);
 	if (lis3lv02d_set_odr(lis3, rate))
diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index 797d796..46b892b 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -161,14 +161,17 @@ static ssize_t options_write(struct file *file, const char __user *userbuf,
 			     size_t count, loff_t *data)
 {
 	char buf[20];
+	int ret;
 
 	if (count >= sizeof(buf))
 		return -EINVAL;
 	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
 	buf[count] = '\0';
-	if (strict_strtoul(buf, 0, &gru_options))
-		return -EINVAL;
+
+	ret = kstrtoul(buf, 0, &gru_options);
+	if (ret)
+		return ret;
 
 	return count;
 }
diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index 84a8dab..807727f 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -316,8 +316,12 @@ static ssize_t pcie_gadget_store_no_of_msi(
 		struct spear_pcie_gadget_config *config,
 		const char *buf, size_t count)
 {
-	if (strict_strtoul(buf, 0, &config->requested_msi))
-		return -EINVAL;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &config->requested_msi);
+	if (ret)
+		return ret;
+
 	if (config->requested_msi > 32)
 		config->requested_msi = 32;
 
@@ -330,9 +334,11 @@ static ssize_t pcie_gadget_store_inta(
 {
 	struct pcie_app_reg __iomem *app_reg = config->va_app_base;
 	ulong en;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &en))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &en);
+	if (ret)
+		return ret;
 
 	if (en)
 		writel(readl(&app_reg->app_ctrl_0) | (1 << SYS_INT_ID),
@@ -351,9 +357,11 @@ static ssize_t pcie_gadget_store_send_msi(
 	struct pcie_app_reg __iomem *app_reg = config->va_app_base;
 	ulong vector;
 	u32 ven_msi;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &vector))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &vector);
+	if (ret)
+		return ret;
 
 	if (!config->configured_msi)
 		return -EINVAL;
@@ -395,9 +403,11 @@ static ssize_t pcie_gadget_store_vendor_id(
 		const char *buf, size_t count)
 {
 	ulong id;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &id))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &id);
+	if (ret)
+		return ret;
 
 	spear_dbi_write_reg(config, PCI_VENDOR_ID, 2, id);
 
@@ -420,9 +430,11 @@ static ssize_t pcie_gadget_store_device_id(
 		const char *buf, size_t count)
 {
 	ulong id;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &id))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &id);
+	if (ret)
+		return ret;
 
 	spear_dbi_write_reg(config, PCI_DEVICE_ID, 2, id);
 
@@ -443,9 +455,12 @@ static ssize_t pcie_gadget_store_bar0_size(
 	ulong size;
 	u32 pos, pos1;
 	u32 no_of_bit = 0;
+	int ret;
+
+	ret = kstrtoul(buf, 0, &size);
+	if (ret)
+		return ret;
 
-	if (strict_strtoul(buf, 0, &size))
-		return -EINVAL;
 	/* min bar size is 256 */
 	if (size <= 0x100)
 		size = 0x100;
@@ -490,9 +505,11 @@ static ssize_t pcie_gadget_store_bar0_address(
 {
 	struct pcie_app_reg __iomem *app_reg = config->va_app_base;
 	ulong address;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &address))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &address);
+	if (ret)
+		return ret;
 
 	address &= ~(config->bar0_size - 1);
 	if (config->va_bar0_address)
@@ -518,9 +535,11 @@ static ssize_t pcie_gadget_store_bar0_rw_offset(
 		const char *buf, size_t count)
 {
 	ulong offset;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &offset))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &offset);
+	if (ret)
+		return ret;
 
 	if (offset % 4)
 		return -EINVAL;
@@ -549,9 +568,11 @@ static ssize_t pcie_gadget_store_bar0_data(
 		const char *buf, size_t count)
 {
 	ulong data;
+	int ret;
 
-	if (strict_strtoul(buf, 0, &data))
-		return -EINVAL;
+	ret = kstrtoul(buf, 0, &data);
+	if (ret)
+		return ret;
 
 	if (!config->va_bar0_address)
 		return -ENOMEM;
diff --git a/drivers/misc/ti_dac7512.c b/drivers/misc/ti_dac7512.c
index 1d86407..9b23722 100644
--- a/drivers/misc/ti_dac7512.c
+++ b/drivers/misc/ti_dac7512.c
@@ -33,9 +33,11 @@ static ssize_t dac7512_store_val(struct device *dev,
 	struct spi_device *spi = to_spi_device(dev);
 	unsigned char tmp[2];
 	unsigned long val;
+	int ret;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
-		return -EINVAL;
+	ret = kstrtoul(buf, 10, &val);
+	if (ret)
+		return ret;
 
 	tmp[0] = val >> 8;
 	tmp[1] = val & 0xff;
-- 
1.7.10.4


