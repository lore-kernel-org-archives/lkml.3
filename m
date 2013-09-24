Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab3IXP7n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 11:59:43 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10451 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab3IXP7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 11:59:41 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-b1-5241b6eb05f5
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: kgene.kim@samsung.com
Cc: ben-linux@fluff.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        t.figa@samsung.com, s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com, t.stanislaws@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] ARM: SAMSUNG: S5P: If detected device tree skip irq init
Date: Tue, 24 Sep 2013 17:59:23 +0200
Message-id: <1380038363-487-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsVy+t9jQd3X2xyDDOZ81LTYOGM9q8WkdQeY
	LHoXXGWzONv0ht1i0+NrrBaXd81hs5hxfh+Txe3LvBan15xitlh75C67xeE37awW62e8ZrGY
	1/6S1YHXo6W5h83j76oXzB6bl9R7HHy3h8mjb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4Ml41
	TWQv2Mde0fNzNVMD40q2LkZODgkBE4ndC/oYIWwxiQv31gPFuTiEBKYzSrx7fYkRwmlnkjh8
	+ho7SBWbgLnExGebWEBsEQFJiaaGP8wgRcwCP5gkbtw9zgSSEBbwkXhw9ShQEQcHi4CqxIdu
	b5AwL1D4wIydTBDbFCR+Xj7BNoGRewEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4EB7
	Jr2DcVWDxSFGAQ5GJR7eCwkOQUKsiWXFlbmHGCU4mJVEeM03OAYJ8aYkVlalFuXHF5XmpBYf
	YpTmYFES5z3Yah0oJJCeWJKanZpakFoEk2Xi4JRqYDRi2m0X9HCCQj2f+sZrpucXVM6ycZh6
	Zmmg+tprDPtye0xlw8vWzHi2pOBWBMeMv1HbwmdwPP0hnuYhFl7Stoft8l3nCu1j3yf8d83X
	sK96/L5UfVnY8RtCwS+yde60nnjq6TNjZs6Rzog1b7XZq3rjeHtlzhndyWu7GXv4UOuND84t
	b9a8/qHEUpyRaKjFXFScCAAoJwPJMAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It prevents from executing things already handled by pinctrl-exynos driver,
when device tree is available.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/plat-samsung/s5p-irq-eint.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/plat-samsung/s5p-irq-eint.c b/arch/arm/plat-samsung/s5p-irq-eint.c
index faa6516..ebee4dc 100644
--- a/arch/arm/plat-samsung/s5p-irq-eint.c
+++ b/arch/arm/plat-samsung/s5p-irq-eint.c
@@ -16,6 +16,7 @@
 #include <linux/device.h>
 #include <linux/gpio.h>
 #include <linux/irqchip/arm-vic.h>
+#include <linux/of.h>
 
 #include <plat/regs-irqtype.h>
 
@@ -202,6 +203,9 @@ static int __init s5p_init_irq_eint(void)
 {
 	int irq;
 
+	if (of_have_populated_dt())
+		return -ENODEV;
+
 	for (irq = IRQ_EINT(0); irq <= IRQ_EINT(15); irq++)
 		irq_set_chip(irq, &s5p_irq_vic_eint);
 
-- 
1.8.1.2

