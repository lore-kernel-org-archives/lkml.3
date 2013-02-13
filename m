Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab3BMJf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 04:35:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:43615 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491Ab3BMJfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 04:35:22 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-10-511b5e582e1d
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 6/9] extcon: max8997: Set default of ADC debounce time during
 initialization
Date: Wed, 13 Feb 2013 18:35:19 +0900
Message-id: <1360748119-21977-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t8zTd3IOOlAgye6Fpd3zWFzYPT4vEku
	gDGKyyYlNSezLLVI3y6BK+NI1x3GgjbJirM3vjI3ML4U6WLk4JAQMJFY/9Wqi5ETyBSTuHBv
	PVsXIxeHkMAyRomP+7czwdScbtaCiE9nlJj/tI0VwlnAJLF87iFGkG42AS2J/S9usIHYIgKm
	EqeeXmcHsZkFaiVOX77LDGILC8RJLOq5AFbPIqAq8Xr7IrAFvAKuEltOsEEcISfxYc8jdpD5
	EgJ72CQOPZvKAlEvIPFt8iEWiINkJTYdYIaol5Q4uOIGywRGwQWMDKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxQoJJagfjygaLQ4wCHIxKPLwOIVKBQqyJZcWVuYcYJTiYlUR4Hf2lA4V4
	UxIrq1KL8uOLSnNSiw8xJgMtn8gsJZqcDwz0vJJ4Q2MDY0NDS0MzU0tTA9KElcR5GU89CRAS
	SE8sSc1OTS1ILYLZwsTBKdXAuGvmV89U0zYzxpp7P+ZUSO0853V55z/Jr9M/T5V2sEk4MUu0
	Zk5UT9r0FRuf8R6ZfiMiuSHW1yogYPX1nkV1Xhe7bb6JFVvEn7hb5bN71ixXZ4HrJ1fwcE/w
	Ltj7WE12VdEL9afSlzg/L3x3NPjS86tTPQ+W7J1lxysezPQhnOVgu790/JeDS5RYijMSDbWY
	i4oTAc+J5sVqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgkeLIzCtJLcpLzFFi42I5/e+xoG5EnHSgwaF1ehaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x40jXHcaCNsmKsze+Mjcw
	vhTpYuTgkBAwkTjdrNXFyAlkiklcuLeerYuRi0NIYDqjxPynbawQzgImieVzDzGCVLEJaEns
	f3GDDcQWETCVOPX0OjuIzSxQK3H68l1mEFtYIE5iUc8FsHoWAVWJ19sXMYEs4xVwldhygg1i
	mZzEhz2P2Ccwci9gZFjFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJERyuz6R2MK5ssDjEKMDB
	qMTD6xAiFSjEmlhWXJl7iFGCg1lJhNfRXzpQiDclsbIqtSg/vqg0J7X4EGMy0PKJzFKiyfnA
	WMoriTc0NjEzsjQyMzYxNzYmTVhJnJfx1JMAIYH0xJLU7NTUgtQimC1MHJxSDYxmEfoz6ioL
	50dUTXZUeDtv99WfUtW/BGyP/vnEdndrsb7yk+L6mV/VxC5vKt1lv7Um8cfjDfUrGhfYngnX
	byqPaTzp17bhksi8Y+peIjvY5rD73l8QNrHSdZfSvrOvZY/+jmR9GVS7+0ySa5Rl7JvWp7pJ
	zEJHVHpZXk85tPfFbvYk73PlAReVWIozEg21mIuKEwH8whhXmwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set default of ADC Debounce Time(25ms) during probe step.
Also, can possible change ADC Debounce Time according to H/W situation
by using max8997_set_adc_debounce_time()

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max8997.c     | 42 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/max8997-private.h |  7 +++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 8739b50..3206daa 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -30,6 +30,13 @@
 
 #define	DEV_NAME			"max8997-muic"
 
+enum max8997_muic_adc_debounce_time {
+	ADC_DEBOUNCE_TIME_0_5MS = 0,	/* 0.5ms */
+	ADC_DEBOUNCE_TIME_10MS,		/* 10ms */
+	ADC_DEBOUNCE_TIME_25MS,		/* 25ms */
+	ADC_DEBOUNCE_TIME_38_62MS,	/* 38.62ms */
+};
+
 struct max8997_muic_irq {
 	unsigned int irq;
 	const char *name;
@@ -95,6 +102,38 @@ static const char *max8997_extcon_cable[] = {
 };
 
 /*
+ * max8997_muic_set_debounce_time - Set the debounce time of ADC
+ * @info: the instance including private data of max8997 MUIC
+ * @time: the debounce time of ADC
+ */
+static int max8997_muic_set_debounce_time(struct max8997_muic_info *info,
+		enum max8997_muic_adc_debounce_time time)
+{
+	int ret;
+
+	switch (time) {
+	case ADC_DEBOUNCE_TIME_0_5MS:
+	case ADC_DEBOUNCE_TIME_10MS:
+	case ADC_DEBOUNCE_TIME_25MS:
+	case ADC_DEBOUNCE_TIME_38_62MS:
+		ret = max8997_update_reg(info->muic,
+					  MAX8997_MUIC_REG_CONTROL3,
+					  time << CONTROL3_ADCDBSET_SHIFT,
+					  CONTROL3_ADCDBSET_MASK);
+		if (ret) {
+			dev_err(info->dev, "failed to set ADC debounce time\n");
+			return -EAGAIN;
+		}
+		break;
+	default:
+		dev_err(info->dev, "invalid ADC debounce time\n");
+		return -EINVAL;
+	}
+
+	return 0;
+};
+
+/*
  * max8997_muic_set_path - Set hardware line according to attached cable
  * @info: the instance including private data of max8997 MUIC
  * @value: the path according to attached cable
@@ -507,6 +546,9 @@ static int max8997_muic_probe(struct platform_device *pdev)
 		}
 	}
 
+	/* Set ADC debounce time */
+	max8997_muic_set_debounce_time(info, ADC_DEBOUNCE_TIME_25MS);
+
 	/* Initial device detection */
 	max8997_muic_detect_dev(info);
 
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index 010173a..cd37a92 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -251,6 +251,13 @@ enum max8997_muic_reg {
 #define CONTROL2_USBCPINT_MASK		(0x1 << CONTROL2_USBCPINT_SHIFT)
 #define CONTROL2_RCPS_MASK		(0x1 << CONTROL2_RCPS_SHIFT)
 
+#define CONTROL3_JIGSET_SHIFT		(0)
+#define CONTROL3_BTLDSET_SHIFT		(2)
+#define CONTROL3_ADCDBSET_SHIFT		(4)
+#define CONTROL3_JIGSET_MASK		(0x3 << CONTROL3_JIGSET_SHIFT)
+#define CONTROL3_BTLDSET_MASK		(0x3 << CONTROL3_BTLDSET_SHIFT)
+#define CONTROL3_ADCDBSET_MASK		(0x3 << CONTROL3_ADCDBSET_SHIFT)
+
 #define	MAX8997_ADC_GROUND		0x00
 #define	MAX8997_ADC_MHL			0x01
 #define	MAX8997_ADC_JIG_USB_1		0x18
-- 
1.8.0

