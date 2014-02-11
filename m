Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486AbaBKNIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 08:08:38 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34136 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaBKNEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 08:04:15 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-90-52fa1fce6ec7
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 05/14] mfd: sec: Use consistent S2MPS11 RTC alarm interrupt
 indexes
Date: Tue, 11 Feb 2014 14:03:48 +0100
Message-id: <1392123837-5517-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
References: <1392123837-5517-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t/xK7rn5H8FGSx8JWixccZ6VovXLwwt
	zja9Ybe4//Uoo8XlXXPYLGac38dksfbIXXaL092sFhdXfGFy4PS4c20Pm8e8k4EefVtWMXp8
	3iQXwBLFZZOSmpNZllqkb5fAlTHr6wemgja+iu37hBsYD3B3MXJySAiYSJz+PJMZwhaTuHBv
	PVsXIxeHkMBSRokd62cxQTh9TBIzZr9iAqliEzCW2Lx8CViViMBmRonF36+ygjjMAkcZJab3
	vgWrEhYIlXjw5CsLiM0ioCox9/o1NhCbV8BNomf1csYuRg6gfQoScybZgIQ5Bdwl+j79ZwMJ
	CwGVLO+PncDIu4CRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSGB92cG4+JjVIUYBDkYl
	Ht4Nij+DhFgTy4orcw8xSnAwK4nwfhH+FSTEm5JYWZValB9fVJqTWnyIkYmDU6qBUbz5uEpP
	lfSfggj9vv9yDGduXXrz8N78j3/yFGdWbfKvd8pUWvItQ+f2Da8P/RyX/ns+0haNWpg/YcvM
	i3+ZZW2zwvo670rYLrrx/H/HspBvXHvu3l0gNzH1+IbbR6KiwnKD1a6uWPXZ+05rXvDW2Dch
	Fnr7NJw9RQyyX1xX6Ny+NqJrh6u6mBJLcUaioRZzUXEiALfuf08KAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S2MPS11 RTC has two alarms: alarm0 and alarm1 (corresponding
interrupts are named similarly). Use consistent names for interrupts to
limit possible errors.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
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

