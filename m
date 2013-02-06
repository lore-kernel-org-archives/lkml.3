Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3BFLXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:23:19 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:25259 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab3BFLXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:23:14 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-61-51123d20f689
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: a.zummo@towertech.it, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] rtc: max8997: Add driver for max8997 rtc.
Date: Wed, 06 Feb 2013 20:23:05 +0900
Message-id: <1360149785-19645-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t8zXV0FW6FAgzvPTC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG5rt97AUfmxkrlq3ewtjA+D6ri5GTQ0LAROLFrM9MELaYxIV7
	69m6GLk4hASWMUrs3vOUBaao/cdaqMR0Romj786zgiSEBJYySdzbFQhiswnoSPzfd5MdxBYR
	UJDY3PsMrIZZoJNRomlKDYgtLGAlca9tFRuIzSKgKtHy6xKYzSvgIfHm4g6gZRxAyxQk5kyy
	AdklIbCDTeLnlz3MEPUCEt8mH4KqkZXYdIAZ4jZJiYMrbrBMYBRcwMiwilE0tSC5oDgpPddI
	rzgxt7g0L10vOT93EyMkpKR3MK5qsDjEKMDBqMTDe0NPMFCINbGsuDL3EKMEB7OSCG+sglCg
	EG9KYmVValF+fFFpTmrxIcZkoOUTmaVEk/OB4Z5XEm9obGBsaGhpaGZqaWpAmrCSOC/jqScB
	QgLpiSWp2ampBalFMFuYODilGhjreBUEXTaZVqTUzeCcbO3tf6Tc+E3X35zo1EOF6a3HGUwE
	PA/XdgVfnFzjvWWnwUHzM9vLDX8tc2+9LLXkwbP5f06GcOzvdmjnvzV9j9bC6x7+y0xWszF9
	VPjclevvpDa75MmPn9/T+TVOpd0vPKhexyvW3Gp7eKLIwkRNFo85lUv/OtZ851FiKc5INNRi
	LipOBACDj5vibQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkkeLIzCtJLcpLzFFi42I5/e+xoK6CrVCgQfdTTYvLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsfluH3vBx2bGimWrtzA2
	ML7P6mLk5JAQMJFo/7GWDcIWk7hwbz2QzcUhJDCdUeLou/OsIAkhgaVMEvd2BYLYbAI6Ev/3
	3WQHsUUEFCQ29z4Dq2EW6GSUaJpSA2ILC1hJ3GtbBTaURUBVouXXJTCbV8BD4s3FHSxdjBxA
	yxQk5kyymcDIvYCRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcMA+k97BuKrB4hCjAAej
	Eg/vDT3BQCHWxLLiytxDjBIczEoivLEKQoFCvCmJlVWpRfnxRaU5qcWHGJOBlk9klhJNzgdG
	U15JvKGxiZmRpZGZsYm5sTFpwkrivIynngQICaQnlqRmp6YWpBbBbGHi4JRqYMxLdzI6oz9/
	foryC8mdR3NS9udae51Ola+1YWtiCtj0XkdSW0ybY2X3W/nSi4+iPokb7Ch/OeXXzekhN5s2
	LvPm+G/A36+l8GS6JoP3nemHRKYemJExbVr8K8/Dj2aZVWq6di3odt0Y1mSc+DXHImLRxBym
	xVXtQZ84LCyW1de6r5hWs2StuBJLcUaioRZzUXEiAK5LBWmcAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds rtc driver for Maxim 8997 multifunction chip.
Max8997 has rtc module in it. and it can be used for timekeeping
clock and system alarm. It provide various operational mode those are
BCD/binary, 24/12hour, am/pm. Driver sets binary/24/ for default.
Maxim 8997 also supports SMPL(Sudden Momentary Power Loss), WTSR
(Watchdog Timeout and Software Reset).

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/rtc/Kconfig       |   30 +++
 drivers/rtc/Makefile      |    1 +
 drivers/rtc/rtc-max8997.c |  542 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 573 insertions(+)
 create mode 100644 drivers/rtc/rtc-max8997.c

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index fc382af..dbeb523 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -233,6 +233,36 @@ config RTC_DRV_MAX8998
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-max8998.
 
+config RTC_DRV_MAX8997
+	tristate "Maxim MAX8997"
+	depends on MFD_MAX8997
+	help
+	  If you say yes here you will get support for the
+	  RTC of Maxim MAX8997 PMIC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-max8997.
+
+config MAX8997_RTC_WTSR
+	bool "MAX8997_RTC_WTSR"
+	depends on RTC_DRV_MAX8997
+	help
+	  MAX8997 rtc can supports WTSR(Watchdog Timeout and Software Reset).
+	  WTSR event would keep the PMIC on regardless of PWRHOLD signal.
+	  When PWRHOLD signal is falling, it turns on WTSR timer rather executes
+	  reset imidiately. After timer expiring, it determine to reset the PMIC
+	  depends on PWRHOLD state.
+
+config MAX8997_RTC_SMPL
+	bool "MAX8997_RTC_SMPL"
+	depends on RTC_DRV_MAX8997
+	help
+	  MAX8997 rtc can supports SMPL(Sudden Momentary Power Loss).
+	  SMPL function can be used to intiate a power up sequence after momentarily
+	  loosing contact to the battery pack. If battery goes under UVLO(Under
+	  Lock Out) it starts SMPL timer. After timer exipiring, it checks battery
+	  whether its state recovers from UVLO or not to make power supplies keep on.
+
 config RTC_DRV_MAX77686
 	tristate "Maxim MAX77686"
 	depends on MFD_MAX77686
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 97e7967..6b0513b 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
 obj-$(CONFIG_RTC_DRV_MAX8907)	+= rtc-max8907.o
 obj-$(CONFIG_RTC_DRV_MAX8925)	+= rtc-max8925.o
 obj-$(CONFIG_RTC_DRV_MAX8998)	+= rtc-max8998.o
+obj-$(CONFIG_RTC_DRV_MAX8997)	+= rtc-max8997.o
 obj-$(CONFIG_RTC_DRV_MAX6902)	+= rtc-max6902.o
 obj-$(CONFIG_RTC_DRV_MAX77686)	+= rtc-max77686.o
 obj-$(CONFIG_RTC_DRV_MC13XXX)	+= rtc-mc13xxx.o
diff --git a/drivers/rtc/rtc-max8997.c b/drivers/rtc/rtc-max8997.c
new file mode 100644
index 0000000..b1c91f4
--- /dev/null
+++ b/drivers/rtc/rtc-max8997.c
@@ -0,0 +1,542 @@
+/*
+ * RTC driver for Maxim MAX8997
+ *
+ * Copyright (C) 2013 Samsung Electronics Co.Ltd
+ *
+ *  based on rtc-max8998.c
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/slab.h>
+#include <linux/rtc.h>
+#include <linux/delay.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/max8997-private.h>
+#include <linux/irqdomain.h>
+
+/* RTC Control Register */
+#define BCD_EN_SHIFT			0
+#define BCD_EN_MASK			(1 << BCD_EN_SHIFT)
+#define MODEL24_SHIFT			1
+#define MODEL24_MASK			(1 << MODEL24_SHIFT)
+/* RTC Update Register1 */
+#define RTC_UDR_SHIFT			0
+#define RTC_UDR_MASK			(1 << RTC_UDR_SHIFT)
+/* WTSR and SMPL Register */
+#define WTSRT_SHIFT			0
+#define SMPLT_SHIFT			2
+#define WTSR_EN_SHIFT			6
+#define SMPL_EN_SHIFT			7
+#define WTSRT_MASK			(3 << WTSRT_SHIFT)
+#define SMPLT_MASK			(3 << SMPLT_SHIFT)
+#define WTSR_EN_MASK			(1 << WTSR_EN_SHIFT)
+#define SMPL_EN_MASK			(1 << SMPL_EN_SHIFT)
+/* RTC Hour register */
+#define HOUR_PM_SHIFT			6
+#define HOUR_PM_MASK			(1 << HOUR_PM_SHIFT)
+/* RTC Alarm Enable */
+#define ALARM_ENABLE_SHIFT		7
+#define ALARM_ENABLE_MASK		(1 << ALARM_ENABLE_SHIFT)
+
+enum {
+	RTC_SEC = 0,
+	RTC_MIN,
+	RTC_HOUR,
+	RTC_WEEKDAY,
+	RTC_MONTH,
+	RTC_YEAR,
+	RTC_DATE,
+	RTC_NR_TIME
+};
+
+struct max8997_rtc_info {
+	struct device		*dev;
+	struct max8997_dev	*max8997;
+	struct i2c_client	*rtc;
+	struct rtc_device	*rtc_dev;
+	struct mutex		lock;
+	int virq;
+	int rtc_24hr_mode;
+};
+
+static void max8997_rtc_data_to_tm(u8 *data, struct rtc_time *tm,
+				   int rtc_24hr_mode)
+{
+	tm->tm_sec = data[RTC_SEC] & 0x7f;
+	tm->tm_min = data[RTC_MIN] & 0x7f;
+	if (rtc_24hr_mode)
+		tm->tm_hour = data[RTC_HOUR] & 0x1f;
+	else {
+		tm->tm_hour = data[RTC_HOUR] & 0x0f;
+		if (data[RTC_HOUR] & HOUR_PM_MASK)
+			tm->tm_hour += 12;
+	}
+
+	tm->tm_wday = fls(data[RTC_WEEKDAY] & 0x7f) - 1;
+	tm->tm_mday = data[RTC_DATE] & 0x1f;
+	tm->tm_mon = (data[RTC_MONTH] & 0x0f) - 1;
+	tm->tm_year = (data[RTC_YEAR] & 0x7f) + 100;
+	tm->tm_yday = 0;
+	tm->tm_isdst = 0;
+}
+
+static int max8997_rtc_tm_to_data(struct rtc_time *tm, u8 *data)
+{
+	data[RTC_SEC] = tm->tm_sec;
+	data[RTC_MIN] = tm->tm_min;
+	data[RTC_HOUR] = tm->tm_hour;
+	data[RTC_WEEKDAY] = 1 << tm->tm_wday;
+	data[RTC_DATE] = tm->tm_mday;
+	data[RTC_MONTH] = tm->tm_mon + 1;
+	data[RTC_YEAR] = tm->tm_year > 100 ? (tm->tm_year - 100) : 0 ;
+
+	if (tm->tm_year < 100) {
+		pr_warn("%s: MAX8997 RTC cannot handle the year %d."
+			"Assume it's 2000.\n", __func__, 1900 + tm->tm_year);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static inline int max8997_rtc_set_update_reg(struct max8997_rtc_info *info)
+{
+	int ret;
+
+	ret = max8997_write_reg(info->rtc, MAX8997_RTC_UPDATE1,
+						RTC_UDR_MASK);
+	if (ret < 0)
+		dev_err(info->dev, "%s: fail to write update reg(%d)\n",
+				__func__, ret);
+	else {
+		/* Minimum 16ms delay required before RTC update.
+		 * Otherwise, we may read and update based on out-of-date
+		 * value */
+		msleep(20);
+	}
+
+	return ret;
+}
+
+static int max8997_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct max8997_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	int ret;
+
+	mutex_lock(&info->lock);
+	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_SEC, RTC_NR_TIME, data);
+	mutex_unlock(&info->lock);
+
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to read time reg(%d)\n", __func__,
+				ret);
+		return ret;
+	}
+
+	max8997_rtc_data_to_tm(data, tm, info->rtc_24hr_mode);
+
+	return rtc_valid_tm(tm);
+}
+
+static int max8997_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct max8997_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	int ret;
+
+	ret = max8997_rtc_tm_to_data(tm, data);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&info->lock);
+
+	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_SEC, RTC_NR_TIME, data);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write time reg(%d)\n", __func__,
+				ret);
+		goto out;
+	}
+
+	ret = max8997_rtc_set_update_reg(info);
+out:
+	mutex_unlock(&info->lock);
+	return ret;
+}
+
+static int max8997_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct max8997_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	u8 val;
+	int i, ret;
+
+	mutex_lock(&info->lock);
+
+	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
+			data);
+	if (ret < 0) {
+		dev_err(info->dev, "%s:%d fail to read alarm reg(%d)\n",
+				__func__, __LINE__, ret);
+		goto out;
+	}
+
+	max8997_rtc_data_to_tm(data, &alrm->time, info->rtc_24hr_mode);
+
+	alrm->enabled = 0;
+	for (i = 0; i < RTC_NR_TIME; i++) {
+		if (data[i] & ALARM_ENABLE_MASK) {
+			alrm->enabled = 1;
+			break;
+		}
+	}
+
+	alrm->pending = 0;
+	ret = max8997_read_reg(info->max8997->i2c, MAX8997_REG_STATUS1, &val);
+	if (ret < 0) {
+		dev_err(info->dev, "%s:%d fail to read status1 reg(%d)\n",
+				__func__, __LINE__, ret);
+		goto out;
+	}
+
+	if (val & (1 << 4)) /* RTCA1 */
+		alrm->pending = 1;
+
+out:
+	mutex_unlock(&info->lock);
+	return 0;
+}
+
+static int max8997_rtc_stop_alarm(struct max8997_rtc_info *info)
+{
+	u8 data[RTC_NR_TIME];
+	int ret, i;
+
+	if (!mutex_is_locked(&info->lock))
+		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
+
+	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
+				data);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	for (i = 0; i < RTC_NR_TIME; i++)
+		data[i] &= ~ALARM_ENABLE_MASK;
+
+	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
+				 data);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	ret = max8997_rtc_set_update_reg(info);
+out:
+	return ret;
+}
+
+static int max8997_rtc_start_alarm(struct max8997_rtc_info *info)
+{
+	u8 data[RTC_NR_TIME];
+	int ret;
+
+	if (!mutex_is_locked(&info->lock))
+		dev_warn(info->dev, "%s: should have mutex locked\n", __func__);
+
+	ret = max8997_bulk_read(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
+				data);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to read alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	data[RTC_SEC] |= (1 << ALARM_ENABLE_SHIFT);
+	data[RTC_MIN] |= (1 << ALARM_ENABLE_SHIFT);
+	data[RTC_HOUR] |= (1 << ALARM_ENABLE_SHIFT);
+	data[RTC_WEEKDAY] &= ~ALARM_ENABLE_MASK;
+	if (data[RTC_MONTH] & 0xf)
+		data[RTC_MONTH] |= (1 << ALARM_ENABLE_SHIFT);
+	if (data[RTC_YEAR] & 0x7f)
+		data[RTC_YEAR] |= (1 << ALARM_ENABLE_SHIFT);
+	if (data[RTC_DATE] & 0x1f)
+		data[RTC_DATE] |= (1 << ALARM_ENABLE_SHIFT);
+
+	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
+				 data);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	ret = max8997_rtc_set_update_reg(info);
+out:
+	return ret;
+}
+static int max8997_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
+{
+	struct max8997_rtc_info *info = dev_get_drvdata(dev);
+	u8 data[RTC_NR_TIME];
+	int ret;
+
+	ret = max8997_rtc_tm_to_data(&alrm->time, data);
+	if (ret < 0)
+		return ret;
+
+	dev_info(info->dev, "%s: %d-%02d-%02d %02d:%02d:%02d\n", __func__,
+			data[RTC_YEAR] + 2000, data[RTC_MONTH], data[RTC_DATE],
+			data[RTC_HOUR], data[RTC_MIN], data[RTC_SEC]);
+
+	mutex_lock(&info->lock);
+
+	ret = max8997_rtc_stop_alarm(info);
+	if (ret < 0)
+		goto out;
+
+	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_ALARM1_SEC, RTC_NR_TIME,
+				data);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write alarm reg(%d)\n",
+				__func__, ret);
+		goto out;
+	}
+
+	ret = max8997_rtc_set_update_reg(info);
+	if (ret < 0)
+		goto out;
+
+	if (alrm->enabled)
+		ret = max8997_rtc_start_alarm(info);
+out:
+	mutex_unlock(&info->lock);
+	return ret;
+}
+
+static int max8997_rtc_alarm_irq_enable(struct device *dev,
+					unsigned int enabled)
+{
+	struct max8997_rtc_info *info = dev_get_drvdata(dev);
+	int ret;
+
+	mutex_lock(&info->lock);
+	if (enabled)
+		ret = max8997_rtc_start_alarm(info);
+	else
+		ret = max8997_rtc_stop_alarm(info);
+	mutex_unlock(&info->lock);
+
+	return ret;
+}
+
+static irqreturn_t max8997_rtc_alarm_irq(int irq, void *data)
+{
+	struct max8997_rtc_info *info = data;
+
+	dev_info(info->dev, "%s:irq(%d)\n", __func__, irq);
+
+	rtc_update_irq(info->rtc_dev, 1, RTC_IRQF | RTC_AF);
+
+	return IRQ_HANDLED;
+}
+
+static const struct rtc_class_ops max8997_rtc_ops = {
+	.read_time = max8997_rtc_read_time,
+	.set_time = max8997_rtc_set_time,
+	.read_alarm = max8997_rtc_read_alarm,
+	.set_alarm = max8997_rtc_set_alarm,
+	.alarm_irq_enable = max8997_rtc_alarm_irq_enable,
+};
+
+#ifdef CONFIG_MAX8997_RTC_WTSR
+static void max8997_rtc_enable_wtsr(struct max8997_rtc_info *info, bool enable)
+{
+	int ret;
+	u8 val, mask;
+
+	if (enable)
+		val = (1 << WTSR_EN_SHIFT) | (3 << WTSRT_SHIFT);
+	else
+		val = 0;
+
+	mask = WTSR_EN_MASK | WTSRT_MASK;
+
+	dev_info(info->dev, "%s: %s WTSR\n", __func__,
+			enable ? "enable" : "disable");
+
+	ret = max8997_update_reg(info->rtc, MAX8997_RTC_WTSR_SMPL, val, mask);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to update WTSR reg(%d)\n",
+				__func__, ret);
+		return;
+	}
+
+	max8997_rtc_set_update_reg(info);
+}
+#else
+static void max8997_rtc_enable_wtsr(struct max8997_rtc_info *info,
+				    bool enable) {}
+#endif
+#ifdef CONFIG_MAX8997_RTC_SMPL
+static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info, bool enable)
+{
+	int ret;
+	u8 val, mask;
+
+	if (enable)
+		val = (1 << SMPL_EN_SHIFT) | (0 << SMPLT_SHIFT);
+	else
+		val = 0;
+
+	mask = SMPL_EN_MASK | SMPLT_MASK;
+
+	dev_info(info->dev, "%s: %s SMPL\n", __func__,
+			enable ? "enable" : "disable");
+
+	ret = max8997_update_reg(info->rtc, MAX8997_RTC_WTSR_SMPL, val, mask);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to update SMPL reg(%d)\n",
+				__func__, ret);
+		return;
+	}
+
+	max8997_rtc_set_update_reg(info);
+
+	val = 0;
+	max8997_read_reg(info->rtc, MAX8997_RTC_WTSR_SMPL, &val);
+	pr_info("%s: WTSR_SMPL(0x%02x)\n", __func__, val);
+}
+#else
+static void max8997_rtc_enable_smpl(struct max8997_rtc_info *info,
+				    bool enable) {}
+#endif
+static int max8997_rtc_init_reg(struct max8997_rtc_info *info)
+{
+	u8 data[2];
+	int ret;
+
+	/* Set RTC control register : Binary mode, 24hour mdoe */
+	data[0] = (1 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
+
+	info->rtc_24hr_mode = 1;
+
+	ret = max8997_bulk_write(info->rtc, MAX8997_RTC_CTRLMASK, 2, data);
+	if (ret < 0) {
+		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
+				__func__, ret);
+		return ret;
+	}
+
+	ret = max8997_rtc_set_update_reg(info);
+	return ret;
+}
+
+static int max8997_rtc_probe(struct platform_device *pdev)
+{
+	struct max8997_dev *max8997 = dev_get_drvdata(pdev->dev.parent);
+	struct max8997_rtc_info *info;
+	int ret, virq;
+
+	info = devm_kzalloc(&pdev->dev, sizeof(struct max8997_rtc_info),
+			GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	mutex_init(&info->lock);
+	info->dev = &pdev->dev;
+	info->max8997 = max8997;
+	info->rtc = max8997->rtc;
+
+	platform_set_drvdata(pdev, info);
+
+	ret = max8997_rtc_init_reg(info);
+
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to initialize RTC reg:%d\n", ret);
+		return ret;
+	}
+
+	max8997_rtc_enable_wtsr(info, true);
+	max8997_rtc_enable_smpl(info, true);
+
+	device_init_wakeup(&pdev->dev, 1);
+
+	info->rtc_dev = rtc_device_register("max8997-rtc", &pdev->dev,
+			&max8997_rtc_ops, THIS_MODULE);
+
+	if (IS_ERR(info->rtc_dev)) {
+		ret = PTR_ERR(info->rtc_dev);
+		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
+		return ret;
+	}
+
+	virq = irq_create_mapping(max8997->irq_domain, MAX8997_PMICIRQ_RTCA1);
+	if (!virq) {
+		dev_err(&pdev->dev, "Failed to create mapping alarm IRQ\n");
+		return ret;
+	}
+	info->virq = virq;
+
+	ret = request_threaded_irq(virq, NULL, max8997_rtc_alarm_irq, 0,
+				"rtc-alarm0", info);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Failed to request alarm IRQ: %d: %d\n",
+			info->virq, ret);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int max8997_rtc_remove(struct platform_device *pdev)
+{
+	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
+
+	if (info) {
+		free_irq(info->virq, info);
+		rtc_device_unregister(info->rtc_dev);
+	}
+
+	return 0;
+}
+
+static void max8997_rtc_shutdown(struct platform_device *pdev)
+{
+	struct max8997_rtc_info *info = platform_get_drvdata(pdev);
+
+	max8997_rtc_enable_wtsr(info, false);
+	max8997_rtc_enable_smpl(info, false);
+}
+
+static const struct platform_device_id rtc_id[] = {
+	{ "max8997-rtc", 0 },
+	{},
+};
+
+static struct platform_driver max8997_rtc_driver = {
+	.driver		= {
+		.name	= "max8997-rtc",
+		.owner	= THIS_MODULE,
+	},
+	.probe		= max8997_rtc_probe,
+	.remove		= max8997_rtc_remove,
+	.shutdown	= max8997_rtc_shutdown,
+	.id_table	= rtc_id,
+};
+
+module_platform_driver(max8997_rtc_driver);
+
+MODULE_DESCRIPTION("Maxim MAX8997 RTC driver");
+MODULE_AUTHOR("<ms925.kim@samsung.com>");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

