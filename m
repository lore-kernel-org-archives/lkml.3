Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693Ab3DAJmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:42:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19649 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab3DAJmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:42:38 -0400
X-AuditID: cbfee68d-b7f786d000005188-c8-5159568cb12e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 02/27] rtc: rtc-at91sam9: use devm_*() functions
Date: Mon, 01 Apr 2013 18:42:36 +0900
Message-id: <000d01ce2ebd$3e0bcb20$ba236160$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAAc6w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zI92esMhAg+4llhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRnHZpKTmZJal
	FunbJXBlbHz1ibWgSbLiy9YL7A2MO0W6GDk4JARMJK5P1uli5AQyxSQu3FvP1sXIxSEksIxR
	omVbHxNEwkRi5p+FLBCJRYwS/zafZYRwfjFK9JzqYgGpYhNQk/jy5TA7yFQRAX2JthYNkBpm
	gV5GiTO9u9lBaoQEbCV+nP3ODGJzCthJvFk4jxGkXljAQeLXsmyQMIuAqsT8WefBynmByk+v
	vsAMYQtK/Jh8D2wVs4CWxPqdx5kgbHmJzWveMkM8oy7x6K8uSFhEwEjixMY5bBAlIhL7Xrxj
	hPjlEbvEw1+aEKsEJL5NPsQC0SorsekAM0SJpMTBFTdYJjBKzEKyeBaSxbOQLJ6FZMMCRpZV
	jKKpBckFxUnpRYZ6xYm5xaV56XrJ+bmbGCFR2ruD8fYB60OMyUDrJzJLiSbnA6M8ryTe0NjM
	yMLUxNTYyNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MQQquBjYaG+O7
	uk/ethEQf5ncsexN0c9LaTYi0XEceZGbhdRedQYsjPyR/m/PJWmRyY7zC5R88tRz1A9Z6mxf
	O3WfxmTLMxGfrX2KXNTKns/SLlQwf72kMnDHalbHprQF6/+GtE7WvzZxjpd2yf9jJyYdKM/0
	MAnqae/UlnyTxnD6yem9/GuVWIozEg21mIuKEwHeW5X/6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd2esMhAgx0XTSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNj46hNrQZNkxZetF9gbGHeKdDFyckgImEjM
	/LOQBcIWk7hwbz1bFyMXh5DAIkaJf5vPMkI4vxglek51gVWxCahJfPlymL2LkYNDREBfoq1F
	A6SGWaCXUeJM7252kBohAVuJH2e/M4PYnAJ2Em8WzmMEqRcWcJD4tSwbJMwioCoxf9Z5sHJe
	oPLTqy8wQ9iCEj8m3wNbxSygJbF+53EmCFteYvOat8wgYyQE1CUe/dUFCYsIGEmc2DiHDaJE
	RGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnAa
	eCa1g3Flg8UhRgEORiUe3ogLEYFCrIllxZW5hxglOJiVRHh9vgGFeFMSK6tSi/Lji0pzUosP
	MSYDPTqRWUo0OR+YovJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJ
	g1OqgbHFlr163Z4JQkK/9X8urt//cdp8qYxd4l993yw1PHr3sO6h99s9Uqexrm8VOPdR4rgW
	e/BtA88359n/P4q252vS+SB+57ryqtnZG1/FpVcvWnrq5s1pzq+XM9vF/JcXEYj0msLEnd26
	/lJhtn26f36JhPbsqwHPejR+F6+tzvhYs8o9+XD41V9KLMUZiYZazEXFiQADgGRpRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-at91sam9.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 39cfd2e..7b77c27 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -20,6 +20,7 @@
 #include <linux/ioctl.h>
 #include <linux/slab.h>
 #include <linux/platform_data/atmel.h>
+#include <linux/io.h>
 
 #include <mach/at91_rtt.h>
 #include <mach/cpu.h>
@@ -309,7 +310,7 @@ static int at91_rtc_probe(struct platform_device *pdev)
 		return irq;
 	}
 
-	rtc = kzalloc(sizeof *rtc, GFP_KERNEL);
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
 		return -ENOMEM;
 
@@ -320,18 +321,19 @@ static int at91_rtc_probe(struct platform_device *pdev)
 		device_init_wakeup(&pdev->dev, 1);
 
 	platform_set_drvdata(pdev, rtc);
-	rtc->rtt = ioremap(r->start, resource_size(r));
+	rtc->rtt = devm_ioremap(&pdev->dev, r->start, resource_size(r));
 	if (!rtc->rtt) {
 		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
 		ret = -ENOMEM;
 		goto fail;
 	}
 
-	rtc->gpbr = ioremap(r_gpbr->start, resource_size(r_gpbr));
+	rtc->gpbr = devm_ioremap(&pdev->dev, r_gpbr->start,
+				resource_size(r_gpbr));
 	if (!rtc->gpbr) {
 		dev_err(&pdev->dev, "failed to map gpbr registers, aborting.\n");
 		ret = -ENOMEM;
-		goto fail_gpbr;
+		goto fail;
 	}
 
 	mr = rtt_readl(rtc, MR);
@@ -346,20 +348,19 @@ static int at91_rtc_probe(struct platform_device *pdev)
 	mr &= ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN);
 	rtt_writel(rtc, MR, mr);
 
-	rtc->rtcdev = rtc_device_register(pdev->name, &pdev->dev,
-				&at91_rtc_ops, THIS_MODULE);
+	rtc->rtcdev = devm_rtc_device_register(&pdev->dev, pdev->name,
+					&at91_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtcdev)) {
 		ret = PTR_ERR(rtc->rtcdev);
-		goto fail_register;
+		goto fail;
 	}
 
 	/* register irq handler after we know what name we'll use */
-	ret = request_irq(rtc->irq, at91_rtc_interrupt, IRQF_SHARED,
-				dev_name(&rtc->rtcdev->dev), rtc);
+	ret = devm_request_irq(&pdev->dev, rtc->irq, at91_rtc_interrupt,
+				IRQF_SHARED, dev_name(&rtc->rtcdev->dev), rtc);
 	if (ret) {
 		dev_dbg(&pdev->dev, "can't share IRQ %d?\n", rtc->irq);
-		rtc_device_unregister(rtc->rtcdev);
-		goto fail_register;
+		goto fail;
 	}
 
 	/* NOTE:  sam9260 rev A silicon has a ROM bug which resets the
@@ -374,13 +375,8 @@ static int at91_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail_register:
-	iounmap(rtc->gpbr);
-fail_gpbr:
-	iounmap(rtc->rtt);
 fail:
 	platform_set_drvdata(pdev, NULL);
-	kfree(rtc);
 	return ret;
 }
 
@@ -394,14 +390,8 @@ static int at91_rtc_remove(struct platform_device *pdev)
 
 	/* disable all interrupts */
 	rtt_writel(rtc, MR, mr & ~(AT91_RTT_ALMIEN | AT91_RTT_RTTINCIEN));
-	free_irq(rtc->irq, rtc);
-
-	rtc_device_unregister(rtc->rtcdev);
 
-	iounmap(rtc->gpbr);
-	iounmap(rtc->rtt);
 	platform_set_drvdata(pdev, NULL);
-	kfree(rtc);
 	return 0;
 }
 
-- 
1.7.2.5


