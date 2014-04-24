Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbaDXIFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:05:51 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27237 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaDXIFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:05:42 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-86-5358c5d3d339
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3] mfd: sec-core: Update sec_pmic documentation
Date: Thu, 24 Apr 2014 10:05:38 +0200
Message-id: <1398326738-17248-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJMWRmVeSWpSXmKPExsVy+t/xy7qXj0YEG2z/qWTx+oWhxf2vRxkt
	Lu+aw2ZxupvV4uKKL0wOrB53ru1h85h3MtCjb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4Mibc
	PcBa0CxUcepPA1MD4zG+LkZODgkBE4k5n4+wQthiEhfurWcDsYUEljJKvNqR1cXIBWT3MUm8
	f/yOESTBJmAssXn5EjaQhIhAH6PE+bdrwBLMAoYSP9/9YQexhQUcJKYeWQgU5+BgEVCVaN0Z
	DRLmFXCXaFnaxw6xTE7i5LHJrBMYuRcwMqxiFE0tTS4oTkrPNdQrTswtLs1L10vOz93ECAmA
	LzsYFx+zOsQowMGoxMOrcCs8WIg1say4MvcQowQHs5II74q9EcFCvCmJlVWpRfnxRaU5qcWH
	GJk4OKUaGC1VXOzjC1O2LY/1Ubxh08+y77KFW5S266za1BT/+U/FSq766Bg/yL9ctUv+cP+F
	vkAOr9RE2X9rn8Ueved7tXO3xGWvXy8WK9qtiyr+8+Yzn2tzFMebN/dVNTbsvxu7l+fdS6EH
	fGyOKpU3pDar2mxZ8cwlRsI3+JJ1mXJdxv6Fn4WCJoefV2Ipzkg01GIuKk4EACRV4+jeAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation for sec_pmic state container structure to
reflect current code.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>

---
Changes since v2:
 - Rebased on lee/mfd.

Changes since v1:
 - Update documentation after review from Lee Jones.
---
 include/linux/mfd/samsung/core.h | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index e7e12ebacb9b..47d84242940b 100644
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
+ * @dev:		Master device of the chip
+ * @pdata:		Platform data populated with data from DTS
+ *			or board files
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
1.9.1

