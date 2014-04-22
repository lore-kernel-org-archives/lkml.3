Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaDVI5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:57:18 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45448 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbaDVI4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:56:40 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-cc-53562ebd7331
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 2/2] mfd: sec-core: Update sec_pmic documentation
Date: Tue, 22 Apr 2014 10:56:10 +0200
Message-id: <1398156970-9360-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1398156970-9360-1-git-send-email-k.kozlowski@samsung.com>
References: <1398156970-9360-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCJMWRmVeSWpSXmKPExsVy+t/xy7p79cKCDQ5+kbLYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFmuP3GW3ON3NanFxxRcmBw6PO9f2sHnMOxno0bdlFaPH501yASxR
	XDYpqTmZZalF+nYJXBnr521gLlgjWNF0w62B8R9vFyMnh4SAicSHGTuZIGwxiQv31rN1MXJx
	CAksZZSY8ugFM4TTxyTR/noDC0gVm4CxxOblS8CqRAT6GCXOv13DCOIwCxxllJje+xZslrCA
	i8SbDe9ZQWwWAVWJaYfXsoHYvAJuEo1bjrFB7JOTOHlsMlgNp4C7xLO5b8A2CAHVPJn2h20C
	I+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCEh9WUH4+JjVocYBTgYlXh4JQxCg4VY
	E8uKK3MPMUpwMCuJ8LLqhgUL8aYkVlalFuXHF5XmpBYfYmTi4JRqYLQQ/rIgWC4x41qz4fvZ
	bNNMpN9nB7SUTNNy5bqYoPNCYnFKQaBx/pKX69t4v1748fhgpvpSieB1qhd5dr62j7y5xpdh
	w+1rebLfrzqdPNzxZirrQWY2Fak41aM/J9oxbsvNXBdum5gWdmC92ev82kM2ije9DeVCpgb+
	qWxLMHkQeC0hRXGrkRJLcUaioRZzUXEiAOFGGMAHAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation for sec_pmic state container structure to
reflect current code.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

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

