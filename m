Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab3DAJsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:48:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20455 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758184Ab3DAJsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:48:04 -0400
X-AuditID: cbfee68d-b7f786d000005188-f0-515957d30d82
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 18/27] rtc: rtc-pcf50633: use devm_*() functions
Date: Mon, 01 Apr 2013 18:48:02 +0900
Message-id: <001d01ce2ebe$0048ad70$00da0850$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAMwhQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ93L4ZGBBlfXSlosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0Xp/A3PBIe6K6XN62BsYT3J2MXJySAiYSOx6No0VwhaTuHBvPVsXIxeHkMAyRolD
	66ezwhQtW/2dFSKxiFHi0dlPUFW/GCWWPb7NBFLFJqAm8eXLYfYuRg4OEQF9ibYWDZAaZoFe
	RokzvbvZQWqEBGwlfpz9zgxicwrYSbxZOI8RxBYWcJDYerGFCaSXRUBVonmaHUiYF6i8qX0V
	C4QtKPFj8j0wm1lAS2L9zuNMELa8xOY1b5lBWiUE1CUe/dUFCYsIGEnc7Z/ODlEiIrHvxTtG
	kHMkBB6xS2xeBfExi4CAxLfJh1ggemUlNh1ghvhXUuLgihssExglZiHZPAvJ5llINs9CsmIB
	I8sqRtHUguSC4qT0IkO94sTc4tK8dL3k/NxNjJBI7d3BePuA9SHGZKD1E5mlRJPzgZGeVxJv
	aGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGuy3KSjtm
	BXYceM0z4bnx0qCdl+uEG1rS7/+7k+7Y93bhtK3iqbcNzF7bXWK++W/RXPFJRbUTE/08uAQK
	xPRreSN+TtmyjrV/+2oZ06P34wp6pb+ouhp82PxF+9qvG/4WHMwBN4OsPpdVJkZWmH3zKnEz
	Y1i+xHY/p4KGxJvuPPUnnR/FDL8osRRnJBpqMRcVJwIADpEDa+oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd1L4ZGBBkf2mVksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNF6fwNzwSHuiulzetgbGE9ydjFyckgImEgs
	W/2dFcIWk7hwbz1bFyMXh5DAIkaJR2c/QTm/GCWWPb7NBFLFJqAm8eXLYfYuRg4OEQF9ibYW
	DZAaZoFeRokzvbvZQWqEBGwlfpz9zgxicwrYSbxZOI8RxBYWcJDYerGFCaSXRUBVonmaHUiY
	F6i8qX0VC4QtKPFj8j0wm1lAS2L9zuNMELa8xOY1b5lBWiUE1CUe/dUFCYsIGEnc7Z/ODlEi
	IrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzgN
	PJPawbiyweIQowAHoxIPb8SFiEAh1sSy4srcQ4wSHMxKIrw+34BCvCmJlVWpRfnxRaU5qcWH
	GJOB/pzILCWanA9MUXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLE
	wSnVwCh115JXO8qHVSIx4p5Y2LGKA2fd1a9K6x5ZZNXGMel++f6AbO+HWmmLJt1ZPetXu+zc
	yrsN+ds7t99RfnPHU+Kor/OdBWvr6p6Uvnv0yONIHOP+9nXSVUEWS/ueiSWxSjX+P8Pjdrmh
	7Nyeracyt5jW3Fo1ZXvyr6AZtScTPmwLWfw3ZK2Zeo0SS3FGoqEWc1FxIgDu+3YKRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pcf50633.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-pcf50633.c b/drivers/rtc/rtc-pcf50633.c
index e9f3135..e6b6911 100644
--- a/drivers/rtc/rtc-pcf50633.c
+++ b/drivers/rtc/rtc-pcf50633.c
@@ -252,20 +252,17 @@ static int pcf50633_rtc_probe(struct platform_device *pdev)
 {
 	struct pcf50633_rtc *rtc;
 
-	rtc = kzalloc(sizeof(*rtc), GFP_KERNEL);
+	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
 		return -ENOMEM;
 
 	rtc->pcf = dev_to_pcf50633(pdev->dev.parent);
 	platform_set_drvdata(pdev, rtc);
-	rtc->rtc_dev = rtc_device_register("pcf50633-rtc", &pdev->dev,
+	rtc->rtc_dev = devm_rtc_device_register(&pdev->dev, "pcf50633-rtc",
 				&pcf50633_rtc_ops, THIS_MODULE);
 
-	if (IS_ERR(rtc->rtc_dev)) {
-		int ret =  PTR_ERR(rtc->rtc_dev);
-		kfree(rtc);
-		return ret;
-	}
+	if (IS_ERR(rtc->rtc_dev))
+		return PTR_ERR(rtc->rtc_dev);
 
 	pcf50633_register_irq(rtc->pcf, PCF50633_IRQ_ALARM,
 					pcf50633_rtc_irq, rtc);
@@ -277,12 +274,8 @@ static int pcf50633_rtc_remove(struct platform_device *pdev)
 	struct pcf50633_rtc *rtc;
 
 	rtc = platform_get_drvdata(pdev);
-
 	pcf50633_free_irq(rtc->pcf, PCF50633_IRQ_ALARM);
 
-	rtc_device_unregister(rtc->rtc_dev);
-	kfree(rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


