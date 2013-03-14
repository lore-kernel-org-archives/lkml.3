Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3CNIPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:15:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:42742 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3CNIPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:15:03 -0400
X-AuditID: cbfee68d-b7f786d000005188-df-51418706febc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 11/30] rtc: hid-sensor-time: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:15:02 +0900
Message-id: <008e01ce208c$06e1ba90$14a52fb0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAJ5Rw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI122dsdAg5XrVSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGjGlfWQuauCqaLt5ha2A8xNHFyMkhIWAi0fJrAyuELSZx4d56
	ti5GLg4hgWWMEqu+nWOFKVrQuhkqsYhR4uGeA2AJIYHZTBIvNuqD2GwCahJfvhxm72Lk4BAR
	0Jdoa9EAqWcW6GWUONO7GywuJGArcf2/HYjJKWAnsWG9GEinsIC3xPw3q8AmsgioSmzfcY4R
	xOYFqj757AkbhC0o8WPyPRYQm1lAS2L9zuNMELa8xOY1b5lBRkoIqEs8+qsLEhYRMJJYu+ox
	G0SJiMS+F+8YQa6REFjGLjHx4nU2iF0CEt8mH2KB6JWV2HSAGeJbSYmDK26wTGCUmIVk8ywk
	m2ch2TwLyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MUKiqncH4+0D1ocYk4HWT2SW
	Ek3OB0ZlXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4
	pRoYhWadC2pd6Zi9f6FdzeXH3SdvG2YGsfbUmqls2rmjUFKQbZlwwxnJ32Gv7i8KaZzWoBoQ
	+2fjHeP5f2YocuQGN3/k0apj7UjlOpvHHCiz3+/t1pqdDO3hiWcPPpXd6hm6SDiSb4r8nh2c
	pdYnC841TGNJrxUWFZ46Yc+0x4dVf9oImB5nTONRYinOSDTUYi4qTgQAd1Rj38ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgC5bu2OgwabbshaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY8a0r6wFTVwVTRfvsDUw
	HuLoYuTkkBAwkVjQupkNwhaTuHBvPZDNxSEksIhR4uGeA6wgCSGB2UwSLzbqg9hsAmoSX74c
	Zu9i5OAQEdCXaGvRAKlnFuhllDjTuxssLiRgK3H9vx2IySlgJ7FhvRhIp7CAt8T8N6vAJrII
	qEps33GOEcTmBao++ewJG4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+ZQUZKCKhLPPqrCxIW
	ETCSWLvqMRtEiYjEvhfvGCcwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLS
	vHS95PzcTYzgmH0mvYNxVYPFIUYBDkYlHt4IUcdAIdbEsuLK3EOMEhzMSiK8nl5AId6UxMqq
	1KL8+KLSnNTiQ4zJQI9OZJYSTc4HppO8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5ak
	ZqemFqQWwWxh4uCUamDk65x9W+5FQ8Smlq2tegKM86axRyixljNKfrwxcYoFZ9WjLcuCDwvs
	fPaVf5/Zi3Oz5syq31N5+P0xF/FEzuubdvMG1dyotsluD56/saM0bKY6x5eN25dPOX3dyP3W
	6/nfrr//pPjF+k0/1wNhzcR7pydYfn8q9YV1xj+2Lwv8F5ezmswo2HS5UomlOCPRUIu5qDgR
	ADp8xpodAwAA
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
 drivers/rtc/rtc-hid-sensor-time.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-hid-sensor-time.c b/drivers/rtc/rtc-hid-sensor-time.c
index 31c5728..6302450 100644
--- a/drivers/rtc/rtc-hid-sensor-time.c
+++ b/drivers/rtc/rtc-hid-sensor-time.c
@@ -255,8 +255,9 @@ static int hid_time_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	time_state->rtc = rtc_device_register("hid-sensor-time",
-				&pdev->dev, &hid_time_rtc_ops, THIS_MODULE);
+	time_state->rtc = devm_rtc_device_register(&pdev->dev,
+					"hid-sensor-time", &hid_time_rtc_ops,
+					THIS_MODULE);
 
 	if (IS_ERR(time_state->rtc)) {
 		dev_err(&pdev->dev, "rtc device register failed!\n");
@@ -269,9 +270,7 @@ static int hid_time_probe(struct platform_device *pdev)
 static int hid_time_remove(struct platform_device *pdev)
 {
 	struct hid_sensor_hub_device *hsdev = pdev->dev.platform_data;
-	struct hid_time_state *time_state = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(time_state->rtc);
 	sensor_hub_remove_callback(hsdev, HID_USAGE_SENSOR_TIME);
 
 	return 0;
-- 
1.7.2.5


