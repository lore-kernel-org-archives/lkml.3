Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755693Ab3CNIWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:22:38 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26165 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab3CNIWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:22:35 -0400
X-AuditID: cbfee690-b7f656d0000007e3-aa-514188ca20f0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 24/30] rtc: rtc-rx8581: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:22:33 +0900
Message-id: <009b01ce208d$13fc1c10$3bf45430$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAayBw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI91THY6BBktnsVlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MXTOnshds56jY1bibtYGxmb2LkYNDQsBE4te6nC5GTiBTTOLC
	vfVsXYxcHEICyxglzh6+zw6RMJH4c/YZE0RiEaPE3pYuFghnNpPE128TGEGq2ATUJL58OQw2
	VURAX6KtRQOkhlmgl1HiTO9usLiQgK3E9f92ICangJ3EhvViIJ3CAm4SXZuWMYPYLAKqEm0n
	jrKC2LxA1ZcX7GOHsAUlfky+xwJiMwtoSazfeZwJwpaX2LzmLTPEL+oSj/7qgoRFBIwkNryf
	yAhRIiKx78U7RpBrJAQWsUtMfbwbapeAxLfJh1ggemUlNh1ghnhXUuLgihssExglZiHZPAvJ
	5llINs9CsmIBI8sqRtHUguSC4qT0IhO94sTc4tK8dL3k/NxNjJComrCD8d4B60OMyUDrJzJL
	iSbnA6MyryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTByc
	Ug2MM26GWLwzn8Mpuu1uR57jrJ8Xg5v2Vm866KjAyW59vkMqJPDZ8WbhW7snOLDIeoim1i/o
	Tj1wnqXV6mfpc5uuNuXXt+fvE0zfrJUxN3OGb2rPKyOduKyuaa2n3h6pXf59VkJ1nUJoqN4i
	ixzhz+c2KHD/uPz7sB/D6cdZvB4e6lKixaFTJcSVWIozEg21mIuKEwE/aTvHwAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgO6pDsdAg2MmFpd3zWFzYPT4vEku
	gDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2io
	kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjFj18yp7AXbOSp2Ne5mbWBs
	Zu9i5OSQEDCR+HP2GROELSZx4d56ti5GLg4hgUWMEntbulggnNlMEl+/TWAEqWITUJP48uUw
	UDcHh4iAvkRbiwZIDbNAL6PEmd7dYHEhAVuJ6//tQExOATuJDevFQDqFBdwkujYtYwaxWQRU
	JdpOHGUFsXmBqi8v2McOYQtK/Jh8jwXEZhbQkli/8zgThC0vsXnNW2aQkRIC6hKP/uqChEUE
	jCQ2vJ/ICFEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQv
	XS85P3cTIzhmn0nvYFzVYHGIUYCDUYmHN0LUMVCINbGsuDL3EKMEB7OSCK+nF1CINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84HpJK8k3tDYxMzI0sjMwsjE3Jw0YSVx3oOt1oFCAumJJanZ
	qakFqUUwW5g4OKUaGGXsVsU3ODIsvFkk0R3tLdJrpxteOP3zrM+hz3fNvhDo2uNVVHP3YXqU
	5u3K71PP3QyTKpdcUP3sMcfVR3EHmc9xSZ/cJmt0zHtd44mUKoc5Rtc2s3d9lFjyvVzo2dnK
	uR3LmPltZD7YGEq/nBDZtNd6uV2Hk9+d9FUprilzpRhnef/idzinqMRSnJFoqMVcVJwIADF8
	IqMdAwAA
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
 drivers/rtc/rtc-rx8581.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-rx8581.c b/drivers/rtc/rtc-rx8581.c
index b0c2726..07f3037 100644
--- a/drivers/rtc/rtc-rx8581.c
+++ b/drivers/rtc/rtc-rx8581.c
@@ -240,8 +240,8 @@ static int rx8581_probe(struct i2c_client *client,
 
 	dev_info(&client->dev, "chip found, driver version " DRV_VERSION "\n");
 
-	rtc = rtc_device_register(rx8581_driver.driver.name,
-				&client->dev, &rx8581_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&client->dev, rx8581_driver.driver.name,
+					&rx8581_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -253,10 +253,6 @@ static int rx8581_probe(struct i2c_client *client,
 
 static int rx8581_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	rtc_device_unregister(rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


