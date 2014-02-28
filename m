Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095AbaB1NAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:00:22 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16735 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaB1NAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:00:18 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-51-5310886040e2
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/5] mfd/rtc: sec/s5m: Rename SEC* symbols to S5M
Date: Fri, 28 Feb 2014 14:00:04 +0100
Message-id: <1393592408-27181-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
References: <1393592408-27181-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e/4Vd2EDoFggxkzRCyWXLzKbrFxxnpW
	i9cvDC3ONr1ht7j/9SijxeVdc9gs1h65y26xv7OD0eJ0N6vFxRVfmCzWz3jN4sDtsWfiSTaP
	O9f2sHnMOxno0bdlFaPH9Hk/mTw+b5ILYIvisklJzcksSy3St0vgyvh36SFTwZ+kir7PLxgb
	GI8FdDFyckgImEh8WvaIHcIWk7hwbz0biC0ksJRR4swenS5GLiC7j0nieHMXK0iCTcBYYvPy
	JWwgCRGBq4wSE5csButmFnjOKPH0eziILSzgKLGnZyZQAwcHi4CqRN85RhCTV8BdYu1vSxBT
	QkBBYs4kG5BiTgEPiZPPp7BCrHWXuLd6K/MERt4FjAyrGEVTS5MLipPScw31ihNzi0vz0vWS
	83M3MUKC78sOxsXHrA4xCnAwKvHwTvDkDxZiTSwrrsw9xCjBwawkwvukSSBYiDclsbIqtSg/
	vqg0J7X4ECMTB6dUA6OsI+uyH3+0gj91txwQ/latvfh7Y+ifeRHTwmLyL/xe9S582kvBlkh7
	Fd6Ez2b7uXpX1XIV7aiX4/jtpJyQLBOg5ysUvSJa6czuedOuvtt4h//O8q+3zIyTTJUNz/dv
	3cjNtmXygdAW3cNpMb3x6U9f3XX8GfVocvibXfNr7q/ykNvbMsuAqVSJpTgj0VCLuag4EQAJ
	e94RHAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares for adding support for S2MPS14 RTC device to the
rtc-s5m driver:
1. Renames SEC* symbols to S5M.
2. Adds S5M prefix to some of defines which are different between S5M876X
and S2MPS14.

This is only a rename-like patch, new code is not added.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/sec-core.c          |    2 +-
 drivers/rtc/rtc-s5m.c           |   64 ++++++++++++++++-----------------
 include/linux/mfd/samsung/rtc.h |   76 +++++++++++++++++++--------------------
 3 files changed, 71 insertions(+), 71 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index 44641d489398..6e5343255633 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -165,7 +165,7 @@ static const struct regmap_config s5m_rtc_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 
-	.max_register = SEC_RTC_REG_MAX,
+	.max_register = S5M_RTC_REG_MAX,
 };
 
 static const struct regmap_config s2mps14_rtc_regmap_config = {
diff --git a/drivers/rtc/rtc-s5m.c b/drivers/rtc/rtc-s5m.c
index 476af93543f6..d26e2480f8b3 100644
--- a/drivers/rtc/rtc-s5m.c
+++ b/drivers/rtc/rtc-s5m.c
@@ -30,10 +30,10 @@
 
 /*
  * Maximum number of retries for checking changes in UDR field
- * of SEC_RTC_UDR_CON register (to limit possible endless loop).
+ * of S5M_RTC_UDR_CON register (to limit possible endless loop).
  *
  * After writing to RTC registers (setting time or alarm) read the UDR field
- * in SEC_RTC_UDR_CON register. UDR is auto-cleared when data have
+ * in S5M_RTC_UDR_CON register. UDR is auto-cleared when data have
  * been transferred.
  */
 #define UDR_READ_RETRY_CNT	5
@@ -104,8 +104,8 @@ static inline int s5m8767_wait_for_udr_update(struct s5m_rtc_info *info)
 	unsigned int data;
 
 	do {
-		ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
-	} while (--retry && (data & RTC_UDR_MASK) && !ret);
+		ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &data);
+	} while (--retry && (data & S5M_RTC_UDR_MASK) && !ret);
 
 	if (!retry)
 		dev_err(info->dev, "waiting for UDR update, reached max number of retries\n");
@@ -118,16 +118,16 @@ static inline int s5m8767_rtc_set_time_reg(struct s5m_rtc_info *info)
 	int ret;
 	unsigned int data;
 
-	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
+	ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &data);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to read update reg(%d)\n", ret);
 		return ret;
 	}
 
-	data |= RTC_TIME_EN_MASK;
-	data |= RTC_UDR_MASK;
+	data |= S5M_RTC_TIME_EN_MASK;
+	data |= S5M_RTC_UDR_MASK;
 
-	ret = regmap_write(info->regmap, SEC_RTC_UDR_CON, data);
+	ret = regmap_write(info->regmap, S5M_RTC_UDR_CON, data);
 	if (ret < 0) {
 		dev_err(info->dev, "failed to write update reg(%d)\n", ret);
 		return ret;
@@ -143,17 +143,17 @@ static inline int s5m8767_rtc_set_alarm_reg(struct s5m_rtc_info *info)
 	int ret;
 	unsigned int data;
 
-	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &data);
+	ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read update reg(%d)\n",
 			__func__, ret);
 		return ret;
 	}
 
-	data &= ~RTC_TIME_EN_MASK;
-	data |= RTC_UDR_MASK;
+	data &= ~S5M_RTC_TIME_EN_MASK;
+	data |= S5M_RTC_UDR_MASK;
 
-	ret = regmap_write(info->regmap, SEC_RTC_UDR_CON, data);
+	ret = regmap_write(info->regmap, S5M_RTC_UDR_CON, data);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write update reg(%d)\n",
 			__func__, ret);
@@ -203,7 +203,7 @@ static int s5m_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	u8 data[8];
 	int ret;
 
-	ret = regmap_bulk_read(info->regmap, SEC_RTC_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, S5M_RTC_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -251,7 +251,7 @@ static int s5m_rtc_set_time(struct device *dev, struct rtc_time *tm)
 		1900 + tm->tm_year, 1 + tm->tm_mon, tm->tm_mday,
 		tm->tm_hour, tm->tm_min, tm->tm_sec, tm->tm_wday);
 
-	ret = regmap_raw_write(info->regmap, SEC_RTC_SEC, data, 8);
+	ret = regmap_raw_write(info->regmap, S5M_RTC_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -267,20 +267,20 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	unsigned int val;
 	int ret, i;
 
-	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, S5M_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
 	switch (info->device_type) {
 	case S5M8763X:
 		s5m8763_data_to_tm(data, &alrm->time);
-		ret = regmap_read(info->regmap, SEC_ALARM0_CONF, &val);
+		ret = regmap_read(info->regmap, S5M_ALARM0_CONF, &val);
 		if (ret < 0)
 			return ret;
 
 		alrm->enabled = !!val;
 
-		ret = regmap_read(info->regmap, SEC_RTC_STATUS, &val);
+		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
 		if (ret < 0)
 			return ret;
 
@@ -303,7 +303,7 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		}
 
 		alrm->pending = 0;
-		ret = regmap_read(info->regmap, SEC_RTC_STATUS, &val);
+		ret = regmap_read(info->regmap, S5M_RTC_STATUS, &val);
 		if (ret < 0)
 			return ret;
 		break;
@@ -312,7 +312,7 @@ static int s5m_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 		return -EINVAL;
 	}
 
-	if (val & ALARM0_STATUS)
+	if (val & S5M_ALARM0_STATUS)
 		alrm->pending = 1;
 	else
 		alrm->pending = 0;
@@ -326,7 +326,7 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
 	int ret, i;
 	struct rtc_time tm;
 
-	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, S5M_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -337,14 +337,14 @@ static int s5m_rtc_stop_alarm(struct s5m_rtc_info *info)
 
 	switch (info->device_type) {
 	case S5M8763X:
-		ret = regmap_write(info->regmap, SEC_ALARM0_CONF, 0);
+		ret = regmap_write(info->regmap, S5M_ALARM0_CONF, 0);
 		break;
 
 	case S5M8767X:
 		for (i = 0; i < 7; i++)
 			data[i] &= ~ALARM_ENABLE_MASK;
 
-		ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
+		ret = regmap_raw_write(info->regmap, S5M_ALARM0_SEC, data, 8);
 		if (ret < 0)
 			return ret;
 
@@ -366,7 +366,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 	u8 alarm0_conf;
 	struct rtc_time tm;
 
-	ret = regmap_bulk_read(info->regmap, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_bulk_read(info->regmap, S5M_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -378,7 +378,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 	switch (info->device_type) {
 	case S5M8763X:
 		alarm0_conf = 0x77;
-		ret = regmap_write(info->regmap, SEC_ALARM0_CONF, alarm0_conf);
+		ret = regmap_write(info->regmap, S5M_ALARM0_CONF, alarm0_conf);
 		break;
 
 	case S5M8767X:
@@ -393,7 +393,7 @@ static int s5m_rtc_start_alarm(struct s5m_rtc_info *info)
 		if (data[RTC_YEAR1] & 0x7f)
 			data[RTC_YEAR1] |= ALARM_ENABLE_MASK;
 
-		ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
+		ret = regmap_raw_write(info->regmap, S5M_ALARM0_SEC, data, 8);
 		if (ret < 0)
 			return ret;
 		ret = s5m8767_rtc_set_alarm_reg(info);
@@ -435,7 +435,7 @@ static int s5m_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	if (ret < 0)
 		return ret;
 
-	ret = regmap_raw_write(info->regmap, SEC_ALARM0_SEC, data, 8);
+	ret = regmap_raw_write(info->regmap, S5M_ALARM0_SEC, data, 8);
 	if (ret < 0)
 		return ret;
 
@@ -480,7 +480,7 @@ static const struct rtc_class_ops s5m_rtc_ops = {
 static void s5m_rtc_enable_wtsr(struct s5m_rtc_info *info, bool enable)
 {
 	int ret;
-	ret = regmap_update_bits(info->regmap, SEC_WTSR_SMPL_CNTL,
+	ret = regmap_update_bits(info->regmap, S5M_WTSR_SMPL_CNTL,
 				 WTSR_ENABLE_MASK,
 				 enable ? WTSR_ENABLE_MASK : 0);
 	if (ret < 0)
@@ -491,7 +491,7 @@ static void s5m_rtc_enable_wtsr(struct s5m_rtc_info *info, bool enable)
 static void s5m_rtc_enable_smpl(struct s5m_rtc_info *info, bool enable)
 {
 	int ret;
-	ret = regmap_update_bits(info->regmap, SEC_WTSR_SMPL_CNTL,
+	ret = regmap_update_bits(info->regmap, S5M_WTSR_SMPL_CNTL,
 				 SMPL_ENABLE_MASK,
 				 enable ? SMPL_ENABLE_MASK : 0);
 	if (ret < 0)
@@ -506,7 +506,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 	int ret;
 	struct rtc_time tm;
 
-	ret = regmap_read(info->regmap, SEC_RTC_UDR_CON, &tp_read);
+	ret = regmap_read(info->regmap, S5M_RTC_UDR_CON, &tp_read);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to read control reg(%d)\n",
 			__func__, ret);
@@ -518,7 +518,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 	data[1] = (0 << BCD_EN_SHIFT) | (1 << MODEL24_SHIFT);
 
 	info->rtc_24hr_mode = 1;
-	ret = regmap_raw_write(info->regmap, SEC_ALARM0_CONF, data, 2);
+	ret = regmap_raw_write(info->regmap, S5M_ALARM0_CONF, data, 2);
 	if (ret < 0) {
 		dev_err(info->dev, "%s: fail to write controlm reg(%d)\n",
 			__func__, ret);
@@ -540,7 +540,7 @@ static int s5m8767_rtc_init_reg(struct s5m_rtc_info *info)
 		ret = s5m_rtc_set_time(info->dev, &tm);
 	}
 
-	ret = regmap_update_bits(info->regmap, SEC_RTC_UDR_CON,
+	ret = regmap_update_bits(info->regmap, S5M_RTC_UDR_CON,
 				 RTC_TCON_MASK, tp_read | RTC_TCON_MASK);
 	if (ret < 0)
 		dev_err(info->dev, "%s: fail to update TCON reg(%d)\n",
@@ -623,7 +623,7 @@ static void s5m_rtc_shutdown(struct platform_device *pdev)
 	if (info->wtsr_smpl) {
 		for (i = 0; i < 3; i++) {
 			s5m_rtc_enable_wtsr(info, false);
-			regmap_read(info->regmap, SEC_WTSR_SMPL_CNTL, &val);
+			regmap_read(info->regmap, S5M_WTSR_SMPL_CNTL, &val);
 			pr_debug("%s: WTSR_SMPL reg(0x%02x)\n", __func__, val);
 			if (val & WTSR_ENABLE_MASK)
 				pr_emerg("%s: fail to disable WTSR\n",
diff --git a/include/linux/mfd/samsung/rtc.h b/include/linux/mfd/samsung/rtc.h
index 3e02b768d537..207fcfbde82e 100644
--- a/include/linux/mfd/samsung/rtc.h
+++ b/include/linux/mfd/samsung/rtc.h
@@ -18,38 +18,38 @@
 #ifndef __LINUX_MFD_SEC_RTC_H
 #define __LINUX_MFD_SEC_RTC_H
 
-enum sec_rtc_reg {
-	SEC_RTC_SEC,
-	SEC_RTC_MIN,
-	SEC_RTC_HOUR,
-	SEC_RTC_WEEKDAY,
-	SEC_RTC_DATE,
-	SEC_RTC_MONTH,
-	SEC_RTC_YEAR1,
-	SEC_RTC_YEAR2,
-	SEC_ALARM0_SEC,
-	SEC_ALARM0_MIN,
-	SEC_ALARM0_HOUR,
-	SEC_ALARM0_WEEKDAY,
-	SEC_ALARM0_DATE,
-	SEC_ALARM0_MONTH,
-	SEC_ALARM0_YEAR1,
-	SEC_ALARM0_YEAR2,
-	SEC_ALARM1_SEC,
-	SEC_ALARM1_MIN,
-	SEC_ALARM1_HOUR,
-	SEC_ALARM1_WEEKDAY,
-	SEC_ALARM1_DATE,
-	SEC_ALARM1_MONTH,
-	SEC_ALARM1_YEAR1,
-	SEC_ALARM1_YEAR2,
-	SEC_ALARM0_CONF,
-	SEC_ALARM1_CONF,
-	SEC_RTC_STATUS,
-	SEC_WTSR_SMPL_CNTL,
-	SEC_RTC_UDR_CON,
+enum s5m_rtc_reg {
+	S5M_RTC_SEC,
+	S5M_RTC_MIN,
+	S5M_RTC_HOUR,
+	S5M_RTC_WEEKDAY,
+	S5M_RTC_DATE,
+	S5M_RTC_MONTH,
+	S5M_RTC_YEAR1,
+	S5M_RTC_YEAR2,
+	S5M_ALARM0_SEC,
+	S5M_ALARM0_MIN,
+	S5M_ALARM0_HOUR,
+	S5M_ALARM0_WEEKDAY,
+	S5M_ALARM0_DATE,
+	S5M_ALARM0_MONTH,
+	S5M_ALARM0_YEAR1,
+	S5M_ALARM0_YEAR2,
+	S5M_ALARM1_SEC,
+	S5M_ALARM1_MIN,
+	S5M_ALARM1_HOUR,
+	S5M_ALARM1_WEEKDAY,
+	S5M_ALARM1_DATE,
+	S5M_ALARM1_MONTH,
+	S5M_ALARM1_YEAR1,
+	S5M_ALARM1_YEAR2,
+	S5M_ALARM0_CONF,
+	S5M_ALARM1_CONF,
+	S5M_RTC_STATUS,
+	S5M_WTSR_SMPL_CNTL,
+	S5M_RTC_UDR_CON,
 
-	SEC_RTC_REG_MAX,
+	S5M_RTC_REG_MAX,
 };
 
 enum s2mps_rtc_reg {
@@ -88,9 +88,9 @@ enum s2mps_rtc_reg {
 #define HOUR_12			(1 << 7)
 #define HOUR_AMPM		(1 << 6)
 #define HOUR_PM			(1 << 5)
-#define ALARM0_STATUS		(1 << 1)
-#define ALARM1_STATUS		(1 << 2)
-#define UPDATE_AD		(1 << 0)
+#define S5M_ALARM0_STATUS	(1 << 1)
+#define S5M_ALARM1_STATUS	(1 << 2)
+#define S5M_UPDATE_AD		(1 << 0)
 
 #define S2MPS_ALARM0_STATUS	(1 << 2)
 #define S2MPS_ALARM1_STATUS	(1 << 1)
@@ -101,16 +101,16 @@ enum s2mps_rtc_reg {
 #define MODEL24_SHIFT		1
 #define MODEL24_MASK		(1 << MODEL24_SHIFT)
 /* RTC Update Register1 */
-#define RTC_UDR_SHIFT		0
-#define RTC_UDR_MASK		(1 << RTC_UDR_SHIFT)
+#define S5M_RTC_UDR_SHIFT	0
+#define S5M_RTC_UDR_MASK	(1 << S5M_RTC_UDR_SHIFT)
 #define S2MPS_RTC_WUDR_SHIFT	4
 #define S2MPS_RTC_WUDR_MASK	(1 << S2MPS_RTC_WUDR_SHIFT)
 #define S2MPS_RTC_RUDR_SHIFT	0
 #define S2MPS_RTC_RUDR_MASK	(1 << S2MPS_RTC_RUDR_SHIFT)
 #define RTC_TCON_SHIFT		1
 #define RTC_TCON_MASK		(1 << RTC_TCON_SHIFT)
-#define RTC_TIME_EN_SHIFT	3
-#define RTC_TIME_EN_MASK	(1 << RTC_TIME_EN_SHIFT)
+#define S5M_RTC_TIME_EN_SHIFT	3
+#define S5M_RTC_TIME_EN_MASK	(1 << S5M_RTC_TIME_EN_SHIFT)
 
 /* RTC Hour register */
 #define HOUR_PM_SHIFT		6
-- 
1.7.9.5

