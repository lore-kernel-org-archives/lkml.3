Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736AbaHGQmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:42:32 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:8750 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbaHGQmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:42:31 -0400
X-AuditID: cbfee61a-f79e46d00000134f-43-53e3ac75aaf9
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: sec-irq: fix support for devices without irq specified
Date: Thu, 07 Aug 2014 18:42:28 +0200
Message-id: <22704524.WE4thfvSda@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsVy+t9jAd2yNY+DDV5eY7V4/cLQ4mzTG3aL
	+1+PMlpc3jWHzeJ0N6vFxRVfmBzYPO5c28PmMe9koEffllWMHp83yQWwRHHZpKTmZJalFunb
	JXBl3H0/kbWgiaNiams/SwPjG7YuRk4OCQETifNbO1ggbDGJC/fWA8W5OIQEFjFK/Pj9hR3C
	aWGSOLjzOitIFZuAlcTE9lWMXYwcHCICXhK37gSB1DCDNJxf9IwJpEZYwEfi8q6l7CA2i4Cq
	xOX1jUwg9bwCWhLT3gmBhEUFPCV2bF8JdgSvgKDEj8n3wI5gFpCX2Ld/KiuErSWxfudxpgmM
	fLOQlM1CUjYLSdkCRuZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGh+UxqB+PKBotDjAIc
	jEo8vALdj4OFWBPLiitzDzFKcDArifDqgoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQS
	SE8sSc1OTS1ILYLJMnFwSjUwGhp+8923c3/z030rVv49q2ys/8z8/rQ9ZZ8/rdu7Zk/7Wq2c
	+Rx7Xq9vVvpSOY8758HZ30qz7A83X2OybXV6sWJ9/POMc7FLT32re31Kz/+ywAlzi/6f/ZfM
	oq4U72JgeKC/+6zehOZWrv1XvRQFqndcz7p+dmZ84BXzqcEye/Ze5rZanbeqeo4SS3FGoqEW
	c1FxIgDRRpDKSQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing check for the case of device without irq specified
in sec_irq_exit() (please note that sec_irq_init() already
correctly handles such devices).

This is needed for Insignal's Exynos4412 based Origen board.

Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
patch is against next-20140804 branch of linux-next kernel

 drivers/mfd/sec-irq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index f9a5786..b65a7f0 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -478,5 +478,6 @@ int sec_irq_init(struct sec_pmic_dev *sec_pmic)
 
 void sec_irq_exit(struct sec_pmic_dev *sec_pmic)
 {
-	regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
+	if (sec_pmic->irq)
+		regmap_del_irq_chip(sec_pmic->irq, sec_pmic->irq_data);
 }
-- 
1.8.2.3


