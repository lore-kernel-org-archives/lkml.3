Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaB1KmA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:42:00 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9691 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbaB1Kly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:41:54 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-6f-531067f0611a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 3/4] mfd: sec: Use consistent S2MPS11 RTC alarm interrupt
 indexes
Date: Fri, 28 Feb 2014 11:41:43 +0100
Message-id: <1393584104-18912-4-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393584104-18912-1-git-send-email-k.kozlowski@samsung.com>
References: <1393584104-18912-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xK7of0gWCDXbckrXYOGM9q8XrF4YW
	Z5vesFvc/3qU0eLyrjlsFjPO72OyWHvkLrvF6W5Wi4srvjBZrJ/xmsWBy+POtT1sHvNOBnr0
	bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxsu+H2wFm/gq7rdsZm1gfM7dxcjJISFgInHk2Qx2
	CFtM4sK99WxdjFwcQgJLGSX2PHrJBOH0MUk8XXiLBaSKTcBYYvPyJWBVIgKbGSUWf7/KCpJg
	FnjOKPH0eziILSwQLPG4oZMNxGYRUJXYO2EDE4jNK+Au8W7BS6B6DqB1ChJzJtmAhDkFPCRm
	z38ONkYIqORZ2wXmCYy8CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEBNnXHYxLj1kd
	YhTgYFTi4Z3gyR8sxJpYVlyZe4hRgoNZSYQ3z10gWIg3JbGyKrUoP76oNCe1+BAjEwenVANj
	2J1Nu3f0bXu3VmHhHK1irzPi/fEJJbpM6WI3t/4/MtMlfn1uQdGhTLFOhw8Vq+7zHTnGYKm/
	9kDHvo0lM/fzfbx8z/JkSPhMvxi9L2eubhQ/eNnTx7OIPePs89WNj+93aB5iWP/qVs+0fbNu
	SYteP8SSOkdaIDEkWZNLQldlY0SrTtx0nd3TlViKMxINtZiLihMB+YfVLxACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S2MPS11 RTC has two alarms: alarm0 and alarm1 (corresponding
interrupts are named similarly). Use consistent names for interrupts to
limit possible errors.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Acked-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/sec-irq.c           |    8 ++++----
 include/linux/mfd/samsung/irq.h |    4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/sec-irq.c b/drivers/mfd/sec-irq.c
index 4de494f51d40..e403c293b437 100644
--- a/drivers/mfd/sec-irq.c
+++ b/drivers/mfd/sec-irq.c
@@ -59,13 +59,13 @@ static const struct regmap_irq s2mps11_irqs[] = {
 		.reg_offset = 1,
 		.mask = S2MPS11_IRQ_RTC60S_MASK,
 	},
-	[S2MPS11_IRQ_RTCA1] = {
+	[S2MPS11_IRQ_RTCA0] = {
 		.reg_offset = 1,
-		.mask = S2MPS11_IRQ_RTCA1_MASK,
+		.mask = S2MPS11_IRQ_RTCA0_MASK,
 	},
-	[S2MPS11_IRQ_RTCA2] = {
+	[S2MPS11_IRQ_RTCA1] = {
 		.reg_offset = 1,
-		.mask = S2MPS11_IRQ_RTCA2_MASK,
+		.mask = S2MPS11_IRQ_RTCA1_MASK,
 	},
 	[S2MPS11_IRQ_SMPL] = {
 		.reg_offset = 1,
diff --git a/include/linux/mfd/samsung/irq.h b/include/linux/mfd/samsung/irq.h
index d43b4f9e7fb2..abe1a6aae3b7 100644
--- a/include/linux/mfd/samsung/irq.h
+++ b/include/linux/mfd/samsung/irq.h
@@ -24,8 +24,8 @@ enum s2mps11_irq {
 	S2MPS11_IRQ_MRB,
 
 	S2MPS11_IRQ_RTC60S,
+	S2MPS11_IRQ_RTCA0,
 	S2MPS11_IRQ_RTCA1,
-	S2MPS11_IRQ_RTCA2,
 	S2MPS11_IRQ_SMPL,
 	S2MPS11_IRQ_RTC1S,
 	S2MPS11_IRQ_WTSR,
@@ -47,7 +47,7 @@ enum s2mps11_irq {
 
 #define S2MPS11_IRQ_RTC60S_MASK		(1 << 0)
 #define S2MPS11_IRQ_RTCA1_MASK		(1 << 1)
-#define S2MPS11_IRQ_RTCA2_MASK		(1 << 2)
+#define S2MPS11_IRQ_RTCA0_MASK		(1 << 2)
 #define S2MPS11_IRQ_SMPL_MASK		(1 << 3)
 #define S2MPS11_IRQ_RTC1S_MASK		(1 << 4)
 #define S2MPS11_IRQ_WTSR_MASK		(1 << 5)
-- 
1.7.9.5

