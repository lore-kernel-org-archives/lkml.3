Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbaHGQoW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:44:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:41089 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913AbaHGQoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:44:21 -0400
X-AuditID: cbfee61b-f79f86d00000144c-6e-53e3ace473d4
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: sec-core: add missing sec_irq_init() return value checking
Date: Thu, 07 Aug 2014 18:44:18 +0200
Message-id: <2486284.NeLpWWu75g@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t9jQd0nax4HG/T/lrJ4/cLQ4mzTG3aL
	+1+PMlpc3jWHzeJ0N6vFxRVfmBzYPO5c28PmMe9koEffllWMHp83yQWwRHHZpKTmZJalFunb
	JXBlzH52krWgh6PizJXSBsaXbF2MnBwSAiYST9a3MUHYYhIX7q0HiwsJTGeUuNpn0cXIBWS3
	MEn8+rsGLMEmYCUxsX0VYxcjB4eIgJfErTtBIDXMAosYJc4vegY2SFggQOLoo6uMIDaLgKrE
	y3MbwGxeAU2JH4eWsoDYogKeEju2r2SDiAtK/Jh8DyzOLCAvsW//VFYIW0ti/c7jTBMY+WYh
	KZuFpGwWkrIFjMyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYID85n0DsZVDRaHGAU4GJV4
	eAW6HwcLsSaWFVfmHmKU4GBWEuHVBQnxpiRWVqUW5ccXleakFh9ilOZgURLnPdhqHSgkkJ5Y
	kpqdmlqQWgSTZeLglGpgXNv4iL9BmsfKnsvnTsxcxl95i+/IbmD/9NB794YOpxLnuOTL5VmT
	ykITPvdYfjjDvdHsyyrVzAoTPvcu996twaE3D6pLr4hfz9KpoNr72Lba8VfjnsKmJf8e6206
	9VRWSGZrz6SNsr8cF1b8WnLPe+KqFu/NPZs/ZNVtD9zQ17J0z51nZpNLlViKMxINtZiLihMB
	gaLzZUgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sec_irq_init() can fail if it encounters unknown device type or
on regmap_add_irq_chip() error.  Add missing sec_irq_init() return
value checking to sec_pmic_probe().

Tested on Insignal's Exynos4412 based Origen board.

Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
patch is against next-20140804 branch of linux-next kernel

 drivers/mfd/sec-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index dba7e2b..f498867 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -353,7 +353,9 @@ static int sec_pmic_probe(struct i2c_client *i2c,
 	if (pdata && pdata->cfg_pmic_irq)
 		pdata->cfg_pmic_irq();
 
-	sec_irq_init(sec_pmic);
+	ret = sec_irq_init(sec_pmic);
+	if (ret)
+		return ret;
 
 	pm_runtime_set_active(sec_pmic->dev);
 
-- 
1.8.2.3


