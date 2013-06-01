Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152Ab3FAHhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 03:37:36 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43800 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab3FAHhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 03:37:34 -0400
X-AuditID: cbfee68f-b7f436d000000f81-30-51a9a4bcd8c4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "'Eric Piel'" <eric.piel@tremplin-utc.net>,
        "'Dimitri Sivanich'" <sivanich@sgi.com>, "'Robin Holt'" <holt@sgi.com>
Subject: [PATCH] misc: replace strict_strtoul() with kstrtoul()
Date: Sat, 01 Jun 2013 16:37:32 +0900
Message-id: <001701ce5e9a$e05feac0$a11fc040$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5empq6rzB+C0tsRu+4JGx0nUqSXg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zA909S1YGGvx5KWvxd9IxdovDfy+x
	WDQvXs9m0T+tg9Xi8sJLQGLXHDaLCYc3s1tM3tLG7sDh8eqqo8fvX5MYPfbPXcPu0bdlFaPH
	3esvmTwutHB7fN4kF8AexWWTkpqTWZZapG+XwJWx699L9oJj+RXLP2xhaWDsi+pi5OSQEDCR
	uD9vBSuELSZx4d56ti5GLg4hgWWMEm9m97HBFD1f/4ERIjGdUWLOuSZmkISQwC9GiYdN3CA2
	m4CaxJcvh9lBbBEBU4mN76eANTALdDNJ7Pq6GiwhLGAvsW3mOrBmFgFViecbHjCB2LwClhLr
	T81jhLAFJX5MvscCYjMLaEms33mcCcKWl9i85i0zxEUKEjvOvmaEWKYncevtR2aIGhGJfS/e
	gS2WEHjJLrG94SzUMgGJb5MPAQ3lAErISmw6ADVHUuLgihssExjFZiFZPQvJ6llIVs9CsmIB
	I8sqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJBY7d/BePeA9SHGZKD1E5mlRJPzgbGeVxJv
	aGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGNpaS/bVL
	PmxgvDJr4juXll+Kr+3i/67602qmfPqbMD/jQodrO5jKZVjcRE8c/5p4LvGQxpRHR+a7ftmh
	4sUbU+uhd9r+8IxFBwK/71C84LOi5XJahzlLIo+ljS+7/r0TK4t7K7+aJf51y2M5eU+ZO+3B
	tZSX363XV3pMmulmwG+8MTsjR1pDiaU4I9FQi7moOBEAhFoAeOsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd09S1YGGtxeJ27xd9IxdovDfy+x
	WDQvXs9m0T+tg9Xi8sJLQGLXHDaLCYc3s1tM3tLG7sDh8eqqo8fvX5MYPfbPXcPu0bdlFaPH
	3esvmTwutHB7fN4kF8Ae1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeY
	m2qr5OIToOuWmQN0lJJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY9e/
	l+wFx/Irln/YwtLA2BfVxcjJISFgIvF8/QdGCFtM4sK99WxdjFwcQgLTGSXmnGtiBkkICfxi
	lHjYxA1iswmoSXz5cpgdxBYRMJXY+H4KI0gDs0A3k8Sur6vBEsIC9hLbZq4Da2YRUJV4vuEB
	E4jNK2Apsf7UPEYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMkNcpCCx4+xrRohlehK33n5k
	hqgRkdj34h3jBEaBWUhGzUIyahaSUbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJ
	EZwInkntYFzZYHGIUYCDUYmH12DFikAh1sSy4srcQ4wSHMxKIrwrF6wMFOJNSaysSi3Kjy8q
	zUktPsSYDPTpRGYp0eR8YJLKK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFq
	EcwWJg5OqQbG7A8fd52ODvJZE9hWZTij4dnXEGsbtxmzU3e8e9m16PnhZeqa65/XO/tOu3bK
	jOXEBt33crVWl4IzDvUrrPnnb8KScOTO82NzI3k8bDb8MOW8ccvzQvJPTs2rS0KL87vapLKX
	KnM0W3E0OWQ6+T0+6DPtNxvXqsSuZSvy3637e+nlFtlcvUdRSizFGYmGWsxFxYkAkqFAg0gD	AAA=
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
 drivers/misc/ad525x_dpot.c              |    2 +-
 drivers/misc/apds9802als.c              |    2 +-
 drivers/misc/apds990x.c                 |   12 ++++++------
 drivers/misc/bh1770glc.c                |   20 ++++++++++----------
 drivers/misc/bh1780gli.c                |    2 +-
 drivers/misc/carma/carma-fpga-program.c |    4 ++--
 drivers/misc/carma/carma-fpga.c         |    2 +-
 drivers/misc/hmc6352.c                  |    2 +-
 drivers/misc/isl29003.c                 |    8 ++++----
 drivers/misc/isl29020.c                 |    2 +-
 drivers/misc/lis3lv02d/lis3lv02d.c      |    2 +-
 drivers/misc/sgi-gru/gruprocfs.c        |    2 +-
 drivers/misc/spear13xx_pcie_gadget.c    |   18 +++++++++---------
 drivers/misc/ti_dac7512.c               |    2 +-
 14 files changed, 40 insertions(+), 40 deletions(-)

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
index 5b5fd84..4be1c79 100644
--- a/drivers/misc/apds9802als.c
+++ b/drivers/misc/apds9802als.c
@@ -126,7 +126,7 @@ static ssize_t als_sensing_range_store(struct device *dev,
 	int ret_val;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
+	if (kstrtoul(buf, 10, &val))
 		return -EINVAL;
 
 	if (val < 4096)
diff --git a/drivers/misc/apds990x.c b/drivers/misc/apds990x.c
index 98f9bb2..3684331 100644
--- a/drivers/misc/apds990x.c
+++ b/drivers/misc/apds990x.c
@@ -697,7 +697,7 @@ static ssize_t apds990x_lux_calib_store(struct device *dev,
 	struct apds990x_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	chip->lux_calib = value;
@@ -759,7 +759,7 @@ static ssize_t apds990x_rate_store(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -814,7 +814,7 @@ static ssize_t apds990x_prox_enable_store(struct device *dev,
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -895,7 +895,7 @@ static ssize_t apds990x_set_lux_thresh(struct apds990x_chip *chip, u32 *target,
 	int ret = 0;
 	unsigned long thresh;
 
-	if (strict_strtoul(buf, 0, &thresh))
+	if (kstrtoul(buf, 0, &thresh))
 		return -EINVAL;
 
 	if (thresh > APDS_RANGE)
@@ -958,7 +958,7 @@ static ssize_t apds990x_prox_threshold_store(struct device *dev,
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	if ((value > APDS_RANGE) || (value == 0) ||
@@ -991,7 +991,7 @@ static ssize_t apds990x_power_state_store(struct device *dev,
 	struct apds990x_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 	if (value) {
 		pm_runtime_get_sync(dev);
diff --git a/drivers/misc/bh1770glc.c b/drivers/misc/bh1770glc.c
index f4975f7..fddd4d6 100644
--- a/drivers/misc/bh1770glc.c
+++ b/drivers/misc/bh1770glc.c
@@ -651,7 +651,7 @@ static ssize_t bh1770_power_state_store(struct device *dev,
 	unsigned long value;
 	ssize_t ret;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -727,7 +727,7 @@ static ssize_t bh1770_prox_enable_store(struct device *dev,
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -825,7 +825,7 @@ static ssize_t bh1770_set_prox_rate_above(struct device *dev,
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -841,7 +841,7 @@ static ssize_t bh1770_set_prox_rate_below(struct device *dev,
 	struct bh1770_chip *chip =  dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -865,7 +865,7 @@ static ssize_t bh1770_set_prox_thres(struct device *dev,
 	unsigned long value;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 	if (value > BH1770_PROX_RANGE)
 		return -EINVAL;
@@ -894,7 +894,7 @@ static ssize_t bh1770_prox_persistence_store(struct device *dev,
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	if (value > BH1770_PROX_MAX_PERSISTENCE)
@@ -919,7 +919,7 @@ static ssize_t bh1770_prox_abs_thres_store(struct device *dev,
 	struct bh1770_chip *chip = dev_get_drvdata(dev);
 	unsigned long value;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	if (value > BH1770_PROX_RANGE)
@@ -964,7 +964,7 @@ static ssize_t bh1770_lux_calib_store(struct device *dev,
 	u32 old_calib;
 	u32 new_corr;
 
-	if (strict_strtoul(buf, 0, &value))
+	if (kstrtoul(buf, 0, &value))
 		return -EINVAL;
 
 	mutex_lock(&chip->mutex);
@@ -1012,7 +1012,7 @@ static ssize_t bh1770_set_lux_rate(struct device *dev,
 	unsigned long rate_hz;
 	int ret, i;
 
-	if (strict_strtoul(buf, 0, &rate_hz))
+	if (kstrtoul(buf, 0, &rate_hz))
 		return -EINVAL;
 
 	for (i = 0; i < ARRAY_SIZE(lux_rates_hz) - 1; i++)
@@ -1050,7 +1050,7 @@ static ssize_t bh1770_set_lux_thresh(struct bh1770_chip *chip, u16 *target,
 	int ret = 0;
 	unsigned long thresh;
 
-	if (strict_strtoul(buf, 0, &thresh))
+	if (kstrtoul(buf, 0, &thresh))
 		return -EINVAL;
 
 	if (thresh > BH1770_LUX_RANGE)
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
index fa017cf..421c044 100644
--- a/drivers/misc/carma/carma-fpga-program.c
+++ b/drivers/misc/carma/carma-fpga-program.c
@@ -830,7 +830,7 @@ static ssize_t penable_store(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &val))
+	if (kstrtoul(buf, 0, &val))
 		return -EINVAL;
 
 	if (val) {
@@ -859,7 +859,7 @@ static ssize_t program_store(struct device *dev, struct device_attribute *attr,
 	unsigned long val;
 	int ret;
 
-	if (strict_strtoul(buf, 0, &val))
+	if (kstrtoul(buf, 0, &val))
 		return -EINVAL;
 
 	/* We can't have an image writer and be programming simultaneously */
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index a2128af..2c57566 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -1002,7 +1002,7 @@ static ssize_t data_en_set(struct device *dev, struct device_attribute *attr,
 	unsigned long enable;
 	int ret;
 
-	ret = strict_strtoul(buf, 0, &enable);
+	ret = kstrtoul(buf, 0, &enable);
 	if (ret) {
 		dev_err(priv->dev, "unable to parse enable input\n");
 		return -EINVAL;
diff --git a/drivers/misc/hmc6352.c b/drivers/misc/hmc6352.c
index 423cd40..95e28b7 100644
--- a/drivers/misc/hmc6352.c
+++ b/drivers/misc/hmc6352.c
@@ -46,7 +46,7 @@ static int compass_store(struct device *dev, const char *buf, size_t count,
 	int ret;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
+	if (kstrtoul(buf, 10, &val))
 		return -EINVAL;
 	if (val >= strlen(map))
 		return -EINVAL;
diff --git a/drivers/misc/isl29003.c b/drivers/misc/isl29003.c
index c5145b3..943133f 100644
--- a/drivers/misc/isl29003.c
+++ b/drivers/misc/isl29003.c
@@ -208,7 +208,7 @@ static ssize_t isl29003_store_range(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 3))
+	if ((kstrtoul(buf, 10, &val) < 0) || (val > 3))
 		return -EINVAL;
 
 	ret = isl29003_set_range(client, val);
@@ -239,7 +239,7 @@ static ssize_t isl29003_store_resolution(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 3))
+	if ((kstrtoul(buf, 10, &val) < 0) || (val > 3))
 		return -EINVAL;
 
 	ret = isl29003_set_resolution(client, val);
@@ -267,7 +267,7 @@ static ssize_t isl29003_store_mode(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 2))
+	if ((kstrtoul(buf, 10, &val) < 0) || (val > 2))
 		return -EINVAL;
 
 	ret = isl29003_set_mode(client, val);
@@ -298,7 +298,7 @@ static ssize_t isl29003_store_power_state(struct device *dev,
 	unsigned long val;
 	int ret;
 
-	if ((strict_strtoul(buf, 10, &val) < 0) || (val > 1))
+	if ((kstrtoul(buf, 10, &val) < 0) || (val > 1))
 		return -EINVAL;
 
 	ret = isl29003_set_power_state(client, val);
diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index 0aa08c7..e4fdc39 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -90,7 +90,7 @@ static ssize_t als_sensing_range_store(struct device *dev,
 	int ret_val;
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val))
+	if (kstrtoul(buf, 10, &val))
 		return -EINVAL;
 	if (val < 1 || val > 64000)
 		return -EINVAL;
diff --git a/drivers/misc/lis3lv02d/lis3lv02d.c b/drivers/misc/lis3lv02d/lis3lv02d.c
index 4cd4a3d..57ef5ea 100644
--- a/drivers/misc/lis3lv02d/lis3lv02d.c
+++ b/drivers/misc/lis3lv02d/lis3lv02d.c
@@ -832,7 +832,7 @@ static ssize_t lis3lv02d_rate_set(struct device *dev,
 	struct lis3lv02d *lis3 = dev_get_drvdata(dev);
 	unsigned long rate;
 
-	if (strict_strtoul(buf, 0, &rate))
+	if (kstrtoul(buf, 0, &rate))
 		return -EINVAL;
 
 	lis3lv02d_sysfs_poweron(lis3);
diff --git a/drivers/misc/sgi-gru/gruprocfs.c b/drivers/misc/sgi-gru/gruprocfs.c
index 797d796..87f1d57 100644
--- a/drivers/misc/sgi-gru/gruprocfs.c
+++ b/drivers/misc/sgi-gru/gruprocfs.c
@@ -167,7 +167,7 @@ static ssize_t options_write(struct file *file, const char __user *userbuf,
 	if (copy_from_user(buf, userbuf, count))
 		return -EFAULT;
 	buf[count] = '\0';
-	if (strict_strtoul(buf, 0, &gru_options))
+	if (kstrtoul(buf, 0, &gru_options))
 		return -EINVAL;
 
 	return count;
diff --git a/drivers/misc/spear13xx_pcie_gadget.c b/drivers/misc/spear13xx_pcie_gadget.c
index 84a8dab..c55dbb6 100644
--- a/drivers/misc/spear13xx_pcie_gadget.c
+++ b/drivers/misc/spear13xx_pcie_gadget.c
@@ -316,7 +316,7 @@ static ssize_t pcie_gadget_store_no_of_msi(
 		struct spear_pcie_gadget_config *config,
 		const char *buf, size_t count)
 {
-	if (strict_strtoul(buf, 0, &config->requested_msi))
+	if (kstrtoul(buf, 0, &config->requested_msi))
 		return -EINVAL;
 	if (config->requested_msi > 32)
 		config->requested_msi = 32;
@@ -331,7 +331,7 @@ static ssize_t pcie_gadget_store_inta(
 	struct pcie_app_reg __iomem *app_reg = config->va_app_base;
 	ulong en;
 
-	if (strict_strtoul(buf, 0, &en))
+	if (kstrtoul(buf, 0, &en))
 		return -EINVAL;
 
 	if (en)
@@ -352,7 +352,7 @@ static ssize_t pcie_gadget_store_send_msi(
 	ulong vector;
 	u32 ven_msi;
 
-	if (strict_strtoul(buf, 0, &vector))
+	if (kstrtoul(buf, 0, &vector))
 		return -EINVAL;
 
 	if (!config->configured_msi)
@@ -396,7 +396,7 @@ static ssize_t pcie_gadget_store_vendor_id(
 {
 	ulong id;
 
-	if (strict_strtoul(buf, 0, &id))
+	if (kstrtoul(buf, 0, &id))
 		return -EINVAL;
 
 	spear_dbi_write_reg(config, PCI_VENDOR_ID, 2, id);
@@ -421,7 +421,7 @@ static ssize_t pcie_gadget_store_device_id(
 {
 	ulong id;
 
-	if (strict_strtoul(buf, 0, &id))
+	if (kstrtoul(buf, 0, &id))
 		return -EINVAL;
 
 	spear_dbi_write_reg(config, PCI_DEVICE_ID, 2, id);
@@ -444,7 +444,7 @@ static ssize_t pcie_gadget_store_bar0_size(
 	u32 pos, pos1;
 	u32 no_of_bit = 0;
 
-	if (strict_strtoul(buf, 0, &size))
+	if (kstrtoul(buf, 0, &size))
 		return -EINVAL;
 	/* min bar size is 256 */
 	if (size <= 0x100)
@@ -491,7 +491,7 @@ static ssize_t pcie_gadget_store_bar0_address(
 	struct pcie_app_reg __iomem *app_reg = config->va_app_base;
 	ulong address;
 
-	if (strict_strtoul(buf, 0, &address))
+	if (kstrtoul(buf, 0, &address))
 		return -EINVAL;
 
 	address &= ~(config->bar0_size - 1);
@@ -519,7 +519,7 @@ static ssize_t pcie_gadget_store_bar0_rw_offset(
 {
 	ulong offset;
 
-	if (strict_strtoul(buf, 0, &offset))
+	if (kstrtoul(buf, 0, &offset))
 		return -EINVAL;
 
 	if (offset % 4)
@@ -550,7 +550,7 @@ static ssize_t pcie_gadget_store_bar0_data(
 {
 	ulong data;
 
-	if (strict_strtoul(buf, 0, &data))
+	if (kstrtoul(buf, 0, &data))
 		return -EINVAL;
 
 	if (!config->va_bar0_address)
diff --git a/drivers/misc/ti_dac7512.c b/drivers/misc/ti_dac7512.c
index 1d86407..09aa6fd 100644
--- a/drivers/misc/ti_dac7512.c
+++ b/drivers/misc/ti_dac7512.c
@@ -34,7 +34,7 @@ static ssize_t dac7512_store_val(struct device *dev,
 	unsigned char tmp[2];
 	unsigned long val;
 
-	if (strict_strtoul(buf, 10, &val) < 0)
+	if (kstrtoul(buf, 10, &val) < 0)
 		return -EINVAL;
 
 	tmp[0] = val >> 8;
-- 
1.7.10.4


