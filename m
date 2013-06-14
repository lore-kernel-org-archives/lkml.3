Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643Ab3FNCMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:12:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:23032 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab3FNCME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:12:04 -0400
X-AuditID: cbfee68f-b7f436d000000f81-1a-51ba7bea2233
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH] extcon: max77693: Bug fix for irq handler,
 call handler depends on ADC.
Date: Fri, 14 Jun 2013 11:11:48 +0900
Message-id: <1371175908-3040-1-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsWyRsSkQPdV9a5Ag9cPpSyuf3nOatF59gmz
	xeVdc9gsPvceYbS43biCzYHVo2/LKkaPz5vkApiiuGxSUnMyy1KL9O0SuDI+7AkuOCpV8Xfi
	HLYGxt+iXYycHBICJhJ/XhxjhrDFJC7cW8/WxcjFISSwlFFi76wp7DBFjyYeYoZILGKU+HH9
	JiOE08IkMX3LNzaQKjYBHYn/+26CdYgIyEhMvbKfFaSIWWAmo8Trs7dZQRLCAlES7+43MIHY
	LAKqEvdevQGzeQXcJd5smw3UzAG0TkFiziQbkF4JgcdsEs8XLmCBqBeQ+Db5EAtEjazEpgNQ
	Z0tKHFxxg2UCo+ACRoZVjKKpBckFxUnpRcZ6xYm5xaV56XrJ+bmbGIFBePrfs/4djHcPWB9i
	TAYaN5FZSjQ5HxjEeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUXleak
	Fh9iZOLglGpgbO3+eOvh8fgmq/L1NUV72XRsOL/u7V7+2vtC3bz5BbUN9T831V7217wtVrjX
	sZT70gvWXN11z3IuqT3/+Wdb/unQ/d5Od72exVjde8LmsffkaZdy925vges/myTadLbFW7vr
	d3xt/3Pvc8SPr64svw4ohWyxVXS7y5Q5Vd3e2k3T8tMHc9atSizFGYmGWsxFxYkA7X6ZblgC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t9jAd1X1bsCDZ6+Eba4/uU5q0Xn2SfM
	Fpd3zWGz+Nx7hNHiduMKNgdWj74tqxg9Pm+SC2CKamC0yUhNTEktUkjNS85PycxLt1XyDo53
	jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFap6RQlphTChQKSCwuVtK3wzQhNMRN1wKmMULX
	NyQIrsfIAA0krGHM+LAnuOCoVMXfiXPYGhh/i3YxcnJICJhIPJp4iBnCFpO4cG89WxcjF4eQ
	wCJGiR/XbzJCOC1MEtO3fGMDqWIT0JH4v+8mO4gtIiAjMfXKflaQImaBmYwSr8/eZgVJCAtE
	Sby738AEYrMIqErce/UGzOYVcJd4s202UDMH0DoFiTmTbCYwci9gZFjFKJpakFxQnJSea6RX
	nJhbXJqXrpecn7uJERziz6R3MK5qsDjEKMDBqMTDm3BhZ6AQa2JZcWXuIUYJDmYlEd7wv0Ah
	3pTEyqrUovz4otKc1OJDjMlAyycyS4km5wPjL68k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFC
	AumJJanZqakFqUUwW5g4OKUaGJf+S9ml4RfVcZl/f5H90Xfx615Lld6c8t/i4lYuUaXl6U+y
	v7V/vqDAkr+15kx6nla1eKDT4tm/Ha5c2Dj/jIv28182Rjs9v65/btvWditP+ymjc9/af9se
	+IZe4nbg+ylw+d7HixtbJ93ctWm5ivKJK0ezXx78v6Yh4cXM2TO3np3yL47L0O+mEktxRqKh
	FnNRcSIAbkYmELUCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it has called charger's or adc's handler depends on irq type, sometimes
it failed to call proper handler. For example, during the driver's probing,
it set ADC debouce time to 25ms by default, then it occurs HW interrupt
which is flagged as CHGTYP. In previous irq handler it called charger handler
because CHGTYP irq is classified as a charger's. But it even happens when
other accessories had been connected. So it is better to call seperate handler
depends on ADC's value.

If ADC is 0x1F, it means that charger is possibly connected so charger's
handler might be needed. Otherwise different handler would be called such as
JIG's or DOCK's and so on.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
---
 drivers/extcon/extcon-max77693.c |   44 +++++++-------------------------------
 1 file changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index b56bdaa..1c50d23 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -945,18 +945,14 @@ static void max77693_muic_irq_work(struct work_struct *work)
 {
 	struct max77693_muic_info *info = container_of(work,
 			struct max77693_muic_info, irq_work);
-	int irq_type = -1;
-	int i, ret = 0;
+	int ret = 0;
+	int adc;
 
 	if (!info->edev)
 		return;
 
 	mutex_lock(&info->mutex);
 
-	for (i = 0 ; i < ARRAY_SIZE(muic_irqs) ; i++)
-		if (info->irq == muic_irqs[i].virq)
-			irq_type = muic_irqs[i].irq;
-
 	ret = max77693_bulk_read(info->max77693->regmap_muic,
 			MAX77693_MUIC_REG_STATUS1, 2, info->status);
 	if (ret) {
@@ -965,36 +961,15 @@ static void max77693_muic_irq_work(struct work_struct *work)
 		return;
 	}
 
-	switch (irq_type) {
-	case MAX77693_MUIC_IRQ_INT1_ADC:
-	case MAX77693_MUIC_IRQ_INT1_ADC_LOW:
-	case MAX77693_MUIC_IRQ_INT1_ADC_ERR:
-	case MAX77693_MUIC_IRQ_INT1_ADC1K:
+	adc = info->status[0] & STATUS1_ADC_MASK;
+	adc >>= STATUS1_ADC_SHIFT;
+
+	if (adc == MAX77693_MUIC_ADC_OPEN) {
+		ret = max77693_muic_chg_handler(info);
+	} else {
 		/* Handle all of accessory except for
 		   type of charger accessory */
 		ret = max77693_muic_adc_handler(info);
-		break;
-	case MAX77693_MUIC_IRQ_INT2_CHGTYP:
-	case MAX77693_MUIC_IRQ_INT2_CHGDETREUN:
-	case MAX77693_MUIC_IRQ_INT2_DCDTMR:
-	case MAX77693_MUIC_IRQ_INT2_DXOVP:
-	case MAX77693_MUIC_IRQ_INT2_VBVOLT:
-	case MAX77693_MUIC_IRQ_INT2_VIDRM:
-		/* Handle charger accessory */
-		ret = max77693_muic_chg_handler(info);
-		break;
-	case MAX77693_MUIC_IRQ_INT3_EOC:
-	case MAX77693_MUIC_IRQ_INT3_CGMBC:
-	case MAX77693_MUIC_IRQ_INT3_OVP:
-	case MAX77693_MUIC_IRQ_INT3_MBCCHG_ERR:
-	case MAX77693_MUIC_IRQ_INT3_CHG_ENABLED:
-	case MAX77693_MUIC_IRQ_INT3_BAT_DET:
-		break;
-	default:
-		dev_err(info->dev, "muic interrupt: irq %d occurred\n",
-				irq_type);
-		mutex_unlock(&info->mutex);
-		return;
 	}
 
 	if (ret < 0)
@@ -1245,9 +1220,6 @@ static int max77693_muic_probe(struct platform_device *pdev)
 		delay_jiffies = msecs_to_jiffies(DELAY_MS_DEFAULT);
 	}
 
-	/* Set initial path for UART */
-	 max77693_muic_set_path(info, info->path_uart, true);
-
 	/* Check revision number of MUIC device*/
 	ret = max77693_read_reg(info->max77693->regmap_muic,
 			MAX77693_MUIC_REG_ID, &id);
-- 
1.7.9.5

