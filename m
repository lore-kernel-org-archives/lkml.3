Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaBQIpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:45:52 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44833 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaBQIkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:40:42 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-c0-5301cb0886d4
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v3 05/13] mfd: sec: Use consistent S2MPS11 RTC alarm interrupt
 indexes
Date: Mon, 17 Feb 2014 09:40:19 +0100
Message-id: <1392626427-4518-6-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
References: <1392626427-4518-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e/4FV2O04zBBuuv61tsnLGe1eL1C0OL
	s01v2C3ufz3KaHF51xw2ixnn9zFZrD1yl93idDerxcUVX5gs1s94zWIxZ/o7JgdujzvX9rB5
	zDsZ6NG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZL/t+sBVs4qu437KZtYHxOXcXIyeHhICJ
	xMSG7SwQtpjEhXvr2UBsIYGljBJzZyVA2H1MEq2fzUFsNgFjic3LlwDVcHGICGxmlFj8/Sor
	iMMsMJNJ4s/NB0wgVcICERKdv2awgtgsAqoSrx4cZwexeQXcJNZ/uwDUzQG0TUFiziQbkDCn
	gLvE076prCBhIaCS/RvDJjDyLmBkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREmpfdzAu
	PWZ1iFGAg1GJh9egmjFYiDWxrLgy9xCjBAezkgiv7TqgEG9KYmVValF+fFFpTmrxIUYmDk6p
	BkbbrGzV41eKvgufd9+44P9vl+681SYcjmunaGcebMkUt5y27s9Dl0qDbvZ1Rh7/30mJfzny
	95BSXcq1evWjLow7tzonzOQ9Fqo5y0DDSuRT36qlfw9F7BPKtKxa1LNx3b0mW0H/zoSEqL9P
	10VZ7s//5hH+yzTiSFjb5pXvj3uJO69Ztf9IvY0SS3FGoqEWc1FxIgAPyOj9EwIAAA==
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

