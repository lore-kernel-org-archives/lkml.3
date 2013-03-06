Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab3CFFgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:36:12 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:29569 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3CFFgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:36:09 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-d2-5136d5c8c866
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 27/30] rtc: rtc-tps80031: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:36:07 +0900
Message-id: <005d01ce1a2c$8092a360$81b7ea20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAATs5w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zQ90TV80CDVquMVssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV0bHiCFPBZK6Kp4uWsjYwrufoYuTkkBAwkbjWvp8NwhaTuHBvPZgtJLCMUWL7mmCY
	mgeH/zBCxKczSuyf59rFyAVk/2KU6HuwBizBJqAm8eXLYfYuRg4OEQF9ibYWDZAaZoFeRokz
	vbvZIZptJa52r2IGsTkF7CSWP57FAmILC3hIHHm5mAWkl0VAVeL+HWWQMC9Q+cqDt5khbEGJ
	H5PvgZUzC2hJrN95nAnClpfYvOYtM0irhIC6xKO/uiBhEQEjiV+71rJClIhI7HvxjhHilXvs
	Esd2hIHYLAICEt8mH2KBaJWV2HSAGaJEUuLgihssExglZiFZPAvJ4llIFs9CsmEBI8sqRtHU
	guSC4qT0IiO94sTc4tK8dL3k/NxNjJAY7dvBePOA9SHGZKD1E5mlRJPzgTGeVxJvaGxsYmZi
	amJuaWpuSpqwkjiv/CWZQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MeZmqZ2P8nlxm034b
	auz45o3v0vkX1ELnvuLYb1ucuiNly806nd2nNJetu7p+b3dU1eF3PLKeIm8ZAgLrZm1bH8qQ
	3ipyYVPdosXS0VJFt9as0Nh+qfVV3QejPNfHzZlmEaFn+FKqHdrS7RX9tb7Nt03Rlrmz+ZzT
	9N3afSUtMx9VTqy652ulxFKckWioxVxUnAgA2W8KJOcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd3jV80CDeactrFYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANaqB0SYjNTEl
	tUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLuSQlliTilQKCCx
	uFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMaNjxRGmgslcFU8XLWVtYFzP0cXIySEhYCLx
	4PAfRghbTOLCvfVsILaQwHRGif3zXLsYuYDsX4wSfQ/WgBWxCahJfPlymL2LkYNDREBfoq1F
	A6SGWaCXUeJM7252iGZbiavdq5hBbE4BO4nlj2exgNjCAh4SR14uZgHpZRFQlbh/RxkkzAtU
	vvLgbWYIW1Dix+R7YOXMAloS63ceZ4Kw5SU2r3nLDNIqIaAu8eivLkhYRMBI4teutawQJSIS
	+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCk8Az
	6R2MqxosDjEKcDAq8fBOUDELFGJNLCuuzD3EKMHBrCTCy3UGKMSbklhZlVqUH19UmpNafIgx
	GejPicxSosn5wASVVxJvaGxiZmRpZGZhZGJuTpqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4
	pRoYl39TlezmS1acI7Vou21Zk9euWYZJbeW/+Fy3sumuvs7L7eWrpekTkbsn+s5Zo7sMq80m
	RHpPmOpSU71xW2iG7JFlex5pXGPbcci3YnubyaTGdSzb/qisvvVi+8/6q19k67Tl7wvnqpeZ
	PXx5er7w3fy8LjOvqRraXLyKb9+z7a27ceGbyIdOJZbijERDLeai4kQAi1W5TEYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-tps80031.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-tps80031.c b/drivers/rtc/rtc-tps80031.c
index 9aaf8aa..f5f6c32 100644
--- a/drivers/rtc/rtc-tps80031.c
+++ b/drivers/rtc/rtc-tps80031.c
@@ -277,7 +277,7 @@ static int tps80031_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 			       &tps80031_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		ret = PTR_ERR(rtc->rtc);
@@ -292,7 +292,6 @@ static int tps80031_rtc_probe(struct platform_device *pdev)
 	if (ret < 0) {
 		dev_err(&pdev->dev, "request IRQ:%d failed, err = %d\n",
 			 rtc->irq, ret);
-		rtc_device_unregister(rtc->rtc);
 		return ret;
 	}
 	device_set_wakeup_capable(&pdev->dev, 1);
@@ -301,9 +300,6 @@ static int tps80031_rtc_probe(struct platform_device *pdev)
 
 static int tps80031_rtc_remove(struct platform_device *pdev)
 {
-	struct tps80031_rtc *rtc = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(rtc->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


