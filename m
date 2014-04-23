Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaDWONT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 10:13:19 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10814 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbaDWONO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 10:13:14 -0400
X-AuditID: cbfec7f4-b7fb36d000006ff7-d0-5357ca7704aa
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 RESEND 2/2] mfd: sec-core: Update sec_pmic documentation
Date: Wed, 23 Apr 2014 16:13:06 +0200
Message-id: <1398262386-10568-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1398262386-10568-1-git-send-email-k.kozlowski@samsung.com>
References: <1398262386-10568-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t/xK7rlp8KDDRZ+ErB4/cLQ4v7Xo4wW
	l3fNYbM43c1qcXHFFyYHVo871/awecw7GejRt2UVo8fnTXIBLFFcNimpOZllqUX6dglcGe+n
	KxS0CFW8nXycsYHxOF8XIyeHhICJxOrtT9khbDGJC/fWs4HYQgJLGSU2/M7pYuQCsvuYJNZc
	+M0KkmATMJbYvHwJG0hCRKCPUeL82zWMIAlmAUOJn+/+gE0SFvCWOL93GjOIzSKgKvFp4iSw
	OK+Au8T5qQ3MENvkJE4emww2lFPAQ+Lvnj52iM3uEu23jzJPYORdwMiwilE0tTS5oDgpPddQ
	rzgxt7g0L10vOT93EyMkYL7sYFx8zOoQowAHoxIPr8TysGAh1sSy4srcQ4wSHMxKIrxLFoUH
	C/GmJFZWpRblxxeV5qQWH2Jk4uCUamBcrR/6qF771c4ffat83I1S1Jhzc+6xaiiHlD2sXxv6
	5rWO2oGXGstrEqOu5n7Ucu/qyu+csyCJqWDGIud9kcv1b/uo77303ujOY44IcW4D9+jKFmuL
	OhP22Nip6qIPAn7t//XKRrFoJZ96sgDbAq9Slx/7/m8XbtHbouX6Zkb9+Qn7WR0umymxFGck
	GmoxFxUnAgCOAnlr9gEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation for sec_pmic state container structure to
reflect current code.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>

---

Changes since v1:
 - Update documentation after review from Lee Jones.
---
 include/linux/mfd/samsung/core.h | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index 55540b524b5a..68f1377e5c07 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -24,19 +24,23 @@ enum sec_device_type {
 };
 
 /**
- * struct sec_pmic_dev - s5m87xx master device for sub-drivers
- * @dev: master device of the chip (can be used to access platform data)
- * @pdata: pointer to private data used to pass platform data to child
- * @i2c: i2c client private data for regulator
- * @rtc: i2c client private data for rtc
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

