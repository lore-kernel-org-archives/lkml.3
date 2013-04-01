Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab3DAJri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:47:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58366 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757125Ab3DAJrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:47:37 -0400
X-AuditID: cbfee690-b7f656d0000007e3-87-515957adbbed
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 16/27] rtc: rtc-pcap: use devm_*() functions
Date: Mon, 01 Apr 2013 18:47:25 +0900
Message-id: <001b01ce2ebd$ea2f0610$be8d1230$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAALXhQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zA9214ZGBBmuaVS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKOH/eveCdYMXG73cYGxgf8HUxcnJICJhIvJx0jhHCFpO4cG89WxcjF4eQwDJGiZ/n
	HzDCFD2+vBsqMZ1RYtqlBSwgCSGBX4wS66bqg9hsAmoSX74cZu9i5OAQEdCXaGvRAKlnFuhl
	lDjTu5sdot5W4sfZ78wgNqeAncSbhfPAFggL2Ejs3tTPBGKzCKhKPF13jxlkDi9Q/c4WP5Aw
	r4CgxI/J98DWMgtoSazfeZwJwpaX2LzmLVi5hIC6xKO/uiBhEQEjiW/n37FDlIhI7HvxjhHk
	HAmBe+wSe14uhVolIPFt8iEWiF5ZiU0HmCHelZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiy
	ilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMkSifsYLx3wPoQYzLQ+onMUqLJ+cAozyuJNzQ2
	M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDoyG7WZRw9yMt
	zdhlvz4GPgw5Pee43TrNw9xsXWJ+a5fm9EbF3Ba4t7bI2snMcLV7+OWDBla9rD8mqMSp/Qx4
	K5aQ22B8VehP6q3t56T6mFrvLdhaqqa8ZY1Zklpo76RDk1ef+yY5OzFadtW5klSnlc3vMk36
	JNZNmeb48fTs1R7KW08YlO1cosRSnJFoqMVcVJwIAPYWKxfoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQd214ZGBBhsPKlgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHH+vHvBO8GKjd/vMDYwPuDrYuTkkBAwkXh8
	eTcbhC0mceHeeiCbi0NIYDqjxLRLC1hAEkICvxgl1k3VB7HZBNQkvnw5zN7FyMEhIqAv0dai
	AVLPLNDLKHGmdzc7RL2txI+z35lBbE4BO4k3C+cxgtjCAjYSuzf1M4HYLAKqEk/X3WMGmcML
	VL+zxQ8kzCsgKPFj8j2wtcwCWhLrdx5ngrDlJTaveQtWLiGgLvHory5IWETASOLb+XfsECUi
	EvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxglPA
	M6kdjCsbLA4xCnAwKvHwRlyICBRiTSwrrsw9xCjBwawkwuvzDSjEm5JYWZValB9fVJqTWnyI
	MRnoz4nMUqLJ+cD0lFcSb2hsYmZkaWRmYWRibk6asJI474FW60AhgfTEktTs1NSC1CKYLUwc
	nFINjELLkk2Twr9EBopcONe+4WNnSd1Ks/2br+wN3FB4VS6ywTlD/ptcg1KDLW/lVr7sFdLl
	4XNL76YvrK58vTPC/vEzplTT2frBqz48XtPW+6Ze/a/bPhNO0Y7Tmw7FrvL8veQ0/6mV9a0r
	p3ekPHuzdctJ2+fWs2Ufrls787tk97OdqSw5i1r0bZVYijMSDbWYi4oTAYcuPmtFAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pcap.c |   34 ++++++++++++----------------------
 1 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index ce09824..539a90b 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -145,7 +145,8 @@ static int __init pcap_rtc_probe(struct platform_device *pdev)
 	int timer_irq, alarm_irq;
 	int err = -ENOMEM;
 
-	pcap_rtc = kmalloc(sizeof(struct pcap_rtc), GFP_KERNEL);
+	pcap_rtc = devm_kzalloc(&pdev->dev, sizeof(struct pcap_rtc),
+				GFP_KERNEL);
 	if (!pcap_rtc)
 		return err;
 
@@ -153,45 +154,34 @@ static int __init pcap_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pcap_rtc);
 
-	pcap_rtc->rtc = rtc_device_register("pcap", &pdev->dev,
-				  &pcap_rtc_ops, THIS_MODULE);
+	pcap_rtc->rtc = devm_rtc_device_register(&pdev->dev, "pcap",
+					&pcap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pcap_rtc->rtc)) {
 		err = PTR_ERR(pcap_rtc->rtc);
-		goto fail_rtc;
+		goto fail;
 	}
 
-
 	timer_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ);
 	alarm_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA);
 
-	err = request_irq(timer_irq, pcap_rtc_irq, 0, "RTC Timer", pcap_rtc);
+	err = devm_request_irq(&pdev->dev, timer_irq, pcap_rtc_irq, 0,
+				"RTC Timer", pcap_rtc);
 	if (err)
-		goto fail_timer;
+		goto fail;
 
-	err = request_irq(alarm_irq, pcap_rtc_irq, 0, "RTC Alarm", pcap_rtc);
+	err = devm_request_irq(&pdev->dev, alarm_irq, pcap_rtc_irq, 0,
+				"RTC Alarm", pcap_rtc);
 	if (err)
-		goto fail_alarm;
+		goto fail;
 
 	return 0;
-fail_alarm:
-	free_irq(timer_irq, pcap_rtc);
-fail_timer:
-	rtc_device_unregister(pcap_rtc->rtc);
-fail_rtc:
+fail:
 	platform_set_drvdata(pdev, NULL);
-	kfree(pcap_rtc);
 	return err;
 }
 
 static int __exit pcap_rtc_remove(struct platform_device *pdev)
 {
-	struct pcap_rtc *pcap_rtc = platform_get_drvdata(pdev);
-
-	free_irq(pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ), pcap_rtc);
-	free_irq(pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA), pcap_rtc);
-	rtc_device_unregister(pcap_rtc->rtc);
-	kfree(pcap_rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


