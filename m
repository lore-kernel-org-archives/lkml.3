Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295AbaJJI0E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:26:04 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:35895 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaJJIYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:24:07 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-d1-543797a4f562
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/4] extcon: max77693: Remove left-over code fter switching to
 regmap irq chip
Date: Fri, 10 Oct 2014 10:23:54 +0200
Message-id: <1412929436-22001-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1412929436-22001-1-git-send-email-k.kozlowski@samsung.com>
References: <1412929436-22001-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsVy+t/xK7pLppuHGEy8bW6xccZ6VovrX56z
	Wrx+YWhxtukNu8X9r0cZLS7vmsNmsfbIXXaL240r2CxOd7M6cHrcubaHzWPeyUCPvi2rGD0+
	b5ILYInisklJzcksSy3St0vgypjVfJyx4JRwxZlJD9kaGGcLdDFycEgImEjcWcjUxcgJZIpJ
	XLi3nq2LkYtDSGApo8T6E11MEE4fk8SZZ8/YQKrYBIwlNi9fAlYlIrCbUeLb3kVgVcwCRxkl
	pve+BZslLJAgcffhUkYQm0VAVeLnxrUsIOt4BdwlHryth1gnJ3Hy2GRWEJtTwEOi5fUusHIh
	oJKXPQtYJzDyLmBkWMUomlqaXFCclJ5rqFecmFtcmpeul5yfu4kRElpfdjAuPmZ1iFGAg1GJ
	h/eCjHmIEGtiWXFl7iFGCQ5mJRFefVOgEG9KYmVValF+fFFpTmrxIUYmDk6pBkajSVf7bQre
	rD1a1rW8Y9Xyx837f8+Vz+tM9akMWa2UfnqmvcN+Dd8dYjofBW1uLrnb8GIbvxfHrHlvVi/+
	bNm/c3VYv4rd2tmTbY6daf09JyY9Vr9Lourc2gKvxRbuT0RF+yYEVX3JLks4atSgerrCf+f3
	colPwSoJjUoHW+rilukelAxeWq/EUpyRaKjFXFScCABhNKW5CwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before switching to regmap irq chip the extcon driver parsed some
initialization data (from platform data or defaults hard coded in the
driver) and adjusted interrupt masks to the init data (code was located
in max77693-irq.c).

However commit 342d669c1ee4 ("mfd: max77693: Handle IRQs using regmap")
removed the max77693-irq.c and replaced whole interrupt handling with
regmap irq chip. Thus the part responsible for using adjusted interrupt
masks disappeared.

Remove left-over code as this is now useless and it is doing nothing.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max77693.c     | 21 +--------------------
 include/linux/mfd/max77693-private.h |  3 ---
 2 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index d3adacf3187f..d4b2dfab1888 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1217,28 +1217,9 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < num_init_data; i++) {
-		enum max77693_irq_source irq_src
-				= MAX77693_IRQ_GROUP_NR;
-
 		regmap_write(info->max77693->regmap_muic,
 				init_data[i].addr,
 				init_data[i].data);
-
-		switch (init_data[i].addr) {
-		case MAX77693_MUIC_REG_INTMASK1:
-			irq_src = MUIC_INT1;
-			break;
-		case MAX77693_MUIC_REG_INTMASK2:
-			irq_src = MUIC_INT2;
-			break;
-		case MAX77693_MUIC_REG_INTMASK3:
-			irq_src = MUIC_INT3;
-			break;
-		}
-
-		if (irq_src < MAX77693_IRQ_GROUP_NR)
-			info->max77693->irq_masks_cur[irq_src]
-				= init_data[i].data;
 	}
 
 	if (pdata && pdata->muic_data) {
@@ -1275,7 +1256,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	}
 
 	/* Set initial path for UART */
-	 max77693_muic_set_path(info, info->path_uart, true);
+	max77693_muic_set_path(info, info->path_uart, true);
 
 	/* Check revision number of MUIC device*/
 	ret = regmap_read(info->max77693->regmap_muic,
diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 3c51c4d01306..8006c5a1339d 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -545,9 +545,6 @@ struct max77693_dev {
 
 	int irq;
 	int irq_gpio;
-	struct mutex irqlock;
-	int irq_masks_cur[MAX77693_IRQ_GROUP_NR];
-	int irq_masks_cache[MAX77693_IRQ_GROUP_NR];
 };
 
 enum max77693_types {
-- 
1.9.1

