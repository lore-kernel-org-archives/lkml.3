Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbaBMJS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 04:18:56 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48550 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbaBMJO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 04:14:28 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-cb-52fc8cf0fbe4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 05/14] mfd: sec: Use consistent S2MPS11 RTC alarm interrupt
 indexes
Date: Thu, 13 Feb 2014 10:13:58 +0100
Message-id: <1392282847-25444-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
References: <1392282847-25444-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJJMWRmVeSWpSXmKPExsVy+t/xy7ofev4EGWzYwGaxccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGFy4PS4c20Pm8e8k4EefVtWMXp8
	3iQXwBLFZZOSmpNZllqkb5fAlfGy7wdbwSa+ivstm1kbGJ9zdzFyckgImEhsntXFBmGLSVy4
	tx7I5uIQEljKKHGpt5EJwuljkvg2/wkTSBWbgLHE5uVLwKpEBDYzSiz+fpUVxGEWOMooMb33
	LViVsECExLcTU8DmsgioSsz7vpcRxOYVcJe4MncWSxcjB9A+BYk5k2xAwpwCHhL/fvxmBrGF
	gEp6Fs9in8DIu4CRYRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZGSHB93cG49JjVIUYBDkYl
	Ht4Hi38HCbEmlhVX5h5ilOBgVhLhlZH4EyTEm5JYWZValB9fVJqTWnyIkYmDU6qBsclw0uZy
	DW5bw3MBqtM2z9yhXndr+Z+fB89cErmb8lHywRmL62ti3xz4cCzjc85ae4PYZUFBd3mZ8459
	fvRW6deB1N9brYS//Pqin88e2Vi7bP4bR5FztZtDJF02ds48sXr3v7Z5suev3vlp6MWvk+RZ
	fmWu9/y6GqPtK5W+hYq09J9+M3NGlJsSS3FGoqEWc1FxIgAjeZCyDAIAAA==
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

