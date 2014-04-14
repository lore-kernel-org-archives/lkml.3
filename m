Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaDNMDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 08:03:55 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62921 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaDNMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 08:03:52 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-33-534bcea65be1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] mfd: sec-core: Update sec_pmic documentation
Date: Mon, 14 Apr 2014 14:03:35 +0200
Message-id: <1397477015-13900-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397477015-13900-1-git-send-email-k.kozlowski@samsung.com>
References: <1397477015-13900-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xy7rLznkHG3Q1M1lsnLGe1eL1C0OL
	s01v2C3ufz3KaHF51xw2i7VH7rJbnO5mtbi44guTA4fHnWt72DzmnQz06NuyitHj8ya5AJYo
	LpuU1JzMstQifbsEroztc98xFbwTqNj63qyB8QJvFyMnh4SAicSsJQvYIWwxiQv31rN1MXJx
	CAksZZRYvqUPyuljkjiz8i4jSBWbgLHE5uVLwBIiAn2MEuffrmEEcZgFjjJKTO99ywRSJSzg
	KHFz/SJWEJtFQFXiyryrQDs4OHgF3CX+LTOGWKcgsezLWmYQm1PAQ+LSqiUsILYQUMnleX9Y
	JzDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kRElBfdjAuPmZ1iFGAg1GJh7dzjnew
	EGtiWXFl7iFGCQ5mJRFe161AId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyCupyXu++rTxCIKbj4
	b75E4mfz6xM3dHtvzHzbl+FgrlJycmrcx7Yjfhd/M21TFLnXlKM78V/V/vZtDzJ5J9v5ikXM
	6bbNS+Vum73woT3bh2eerI2P9bxPJE3X+p/evLkvb9FLpaXHNSUupi4rt5Bw+pko9fWlfPa+
	Sp08D7vSd5qepzlTcpRYijMSDbWYi4oTAeiSypAGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation for sec_pmic state container structure to
reflect current code.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/mfd/samsung/core.h | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 2633083262ea..1923fe026c01 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -24,18 +24,23 @@ enum sec_device_type {
 };
 
 /**
- * struct sec_pmic_dev - s5m87xx master device for sub-drivers
- * @dev: master device of the chip (can be used to access platform data)
- * @pdata: pointer to private data used to pass platform data to child
- * @i2c: i2c client private data for regulator
- * @iolock: mutex for serializing io access
- * @irqlock: mutex for buslock
- * @irq_base: base IRQ number for sec-pmic, required for IRQs
- * @irq: generic IRQ number for s5m87xx
- * @ono: power onoff IRQ number for s5m87xx
- * @irq_masks_cur: currently active value
- * @irq_masks_cache: cached hardware value
- * @type: indicate which s5m87xx "variant" is used
+ * struct sec_pmic_dev - s2m/s5m master device for sub-drivers
+ * @dev:		Master device of the chip (can be used to access
+ *			platform data)
+ * @pdata:		Platform data from DTS or board files
+ * @regmap_pmic:	Regmap associated with PMIC's I2C address
+ * @i2c:		I2C client of the main driver
+ * @device_type:	Type of device, matches enum sec_device_type
+ * @irq_base:		Base IRQ number for device, required for IRQs
+ * @irq:		Generic IRQ number for device
+ * @irq_data:		Runtime data structure for IRQ controller
+ * @ono:		Power onoff IRQ number for s5m87xx
+ * @wakeup:		Whether or not this is a wakeup device
+ * @wtsr_smpl:		Whether or not to enable in RTC driver the Watchdog
+ *			Timer Software Reset (registers set to default value
+ *			after PWRHOLD falling) and Sudden Momentary Power Loss
+ *			(PMIC will enter power on sequence after short drop in
+ *			VBATT voltage).
  */
 struct sec_pmic_dev {
 	struct device *dev;
-- 
1.8.3.2

