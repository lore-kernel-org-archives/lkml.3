Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3CNIOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:14:22 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:24403 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3CNIOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:14:19 -0400
X-AuditID: cbfee68e-b7f946d000001e37-91-514186dabcf3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 09/30] rtc: rtc-em3027: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:14:17 +0900
Message-id: <008c01ce208b$ec92f500$c5b8df00$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAIUuA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zfd1bbY6BBot6xS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuNfygL1gEUfFnXtb2BoYP7N1MXJySAiYSHx6OJ8RwhaTuHBvPVCci0NIYBmjxP8t
	PcwwRY9OzmcFsYUEpjNKND3mgij6xSjxeNImsCI2ATWJL18Os3cxcnCICOhLtLVogNQwC/Qy
	Spzp3Q0WFxKwlbj+3w7E5BSwk9iwXgykU1jATeL74hWsIGEWAVWJ3peJIGFeoOIPK5axQdiC
	Ej8m32MBsZkFtCTW7zzOBGHLS2xe85YZpFVCQF3i0V9dkLCIgJFE/9m3rBAlIhL7XrxjBDlG
	QuAeu8TzgxvYQRIsAgIS3yYfYoHolZXYdADqWUmJgytusExglJiFZPMsJJtnIdk8C8mKBYws
	qxhFUwuSC4qT0ouM9IoTc4tL89L1kvNzNzFCYrRvB+PNA9aHGJOB1k9klhJNzgfGeF5JvKGx
	mZGFqYmpsZG5pRlpwkrivGot1oFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGGdnnfi7+ft2
	j1lCigYO5Q/OWffWfK8r/P9hU+S3wx8Ltk7leC/qyz2rIS/lCv+u/5wKt1o+M54PvS14Zt1p
	5pfRquvaVku7nKnVtrjVrT3Pv/GIfWTeoQT97rN/pJalzVwY+LqzzUF2WpfkJq3yuiqhIsuM
	gGKxgFoJQ+WvV667dl9/rvfIT4mlOCPRUIu5qDgRAN6g4pjnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jQd1bbY6BBp/vClksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHGv5QF7wSKOijv3trA1MH5m62Lk5JAQMJF4
	dHI+K4QtJnHh3nqwuJDAdEaJpsdcXYxcQPYvRonHkzYxgyTYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDLKHGmdzdYXEjAVuL6fzsQk1PATmLDejGQTmEBN4nvi1ewgoRZBFQlel8mgoR5gYo/
	rFjGBmELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmkFYJAXWJR391QcIiAkYS/WffskKUiEjs
	e/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAhOAM+k
	dzCuarA4xCjAwajEwxsh6hgoxJpYVlyZe4hRgoNZSYTX0wsoxJuSWFmVWpQfX1Sak1p8iDEZ
	6M+JzFKiyfnA5JRXEm9obGJmZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxS
	DYz8jZEOh74e2uppmHbn1dykAzlmV26d8c3RqeUOzKrQOFh8U8nPivHcrCWefwyDVK46mKZe
	lDhSYvJ7t3KrlD639DsnjTd5U5Z152Qs11X2nxzo9e3/BdWZdtKPWi4eiQ1ZE9rmdjPBMND5
	146H/Ze80txcPNs5Vi7a23NetKl+89x154QOnlRiKc5INNRiLipOBAAwRl+MRAMAAA==
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
 drivers/rtc/rtc-em3027.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-em3027.c b/drivers/rtc/rtc-em3027.c
index f6c24ce..3f9eb57 100644
--- a/drivers/rtc/rtc-em3027.c
+++ b/drivers/rtc/rtc-em3027.c
@@ -121,7 +121,7 @@ static int em3027_probe(struct i2c_client *client,
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	rtc = rtc_device_register(em3027_driver.driver.name, &client->dev,
+	rtc = devm_rtc_device_register(&client->dev, em3027_driver.driver.name,
 				  &em3027_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -133,11 +133,6 @@ static int em3027_probe(struct i2c_client *client,
 
 static int em3027_remove(struct i2c_client *client)
 {
-	struct rtc_device *rtc = i2c_get_clientdata(client);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


