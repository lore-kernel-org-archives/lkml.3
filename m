Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab3CFHyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:54:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53206 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab3CFHyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:54:16 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-4b-5136f616f22a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 19/30] rtc: rtc-pcf8523: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:53:57 +0900
Message-id: <008d01ce1a3f$c1e3d9c0$45ab8d40$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAOq+g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ12xb2aBBi8mMlssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsfz8KfaCDRwV26fNY2lg/MDWxcjJISFgIjG39xeULSZx4d56IJuLQ0hgGaPEwTWb
	GGGKXkw5BGYLCUxnlJj6XAOi6BejxOGGDiaQBJuAmsSXL4fZuxg5OEQE9CXaWsBqmAV6GSXO
	9O4GiwsJ2Er0zOMBKecUsJOYMvExO4gtLOAl8W72LbAjWARUJR4fhdjLC1Q+b+5qKFtQ4sfk
	eywgNrOAlsT6nceZIGx5ic1r3jKDjJcQUJd49FcXJCwiYCTRO+0CG0SJiMS+F+8YQc6RELjF
	LvHp814WiF0CEt8mH2KB6JWV2HSAGeJdSYmDK26wTGCUmIVk8ywkm2ch2TwLyYoFjCyrGEVT
	C5ILipPSi4z0ihNzi0vz0vWS83M3MULitG8H480D1ocYk4HWT2SWEk3OB8Z5Xkm8obGxiZmJ
	qYm5pam5KWnCSuK88pdkAoUE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwTnB+E7L1sLOwQH5l
	QV6P1P6Fv34t+HBPeJ6j9JsUpknff39lc0y9ENxm66P2UCwjgtX5fHomT5/LnWtmf/2nFF5q
	7+5re7Vw7omva9/8DGWx29fl2m00ieH4/028R3asOm/7O2LrvlDbnjt8rKnxidzS19s+M82f
	ujsqruTOWZOPh3Q2HAzZrsRSnJFoqMVcVJwIAHMJbw7pAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQV3Rb2aBBpuOWlssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLH8/Cn2gg0cFdunzWNpYPzA1sXIySEhYCLx
	YsohRghbTOLCvfVgcSGB6YwSU59rdDFyAdm/GCUON3QwgSTYBNQkvnw5zN7FyMEhIqAv0dYC
	VsMs0MsocaZ3N1hcSMBWomceD0g5p4CdxJSJj9lBbGEBL4l3s2+BzWcRUJV4fHQT2F5eoPJ5
	c1dD2YISPybfYwGxmQW0JNbvPM4EYctLbF7zlhlkvISAusSjv7ogYREBI4neaRfYIEpEJPa9
	eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBCeBZ1I7
	GFc2WBxiFOBgVOLhtVAyCxRiTSwrrsw9xCjBwawkwst1BijEm5JYWZValB9fVJqTWnyIMRno
	0YnMUqLJ+cAElVcSb2hsYmZkaWRmYWRibk6asJI4L+OpJwFCAumJJanZqakFqUUwW5g4OKUa
	GGMnT72+YHvr05YHHaeTVbrezZ2WmWC8Xqh8emy2/P81r/uPiTj/q9pg1PHfVjvwxw0L9XKB
	5z2mHNsEgp5NMV4QPCvVY4vuocri2bLywedjf+2LuaXSpxlz6qpHWXzCRXnrHy55gbfE/gje
	2CgiLMh2QGxaeBnnj19sa+sTLd00hXc2lx87rcRSnJFoqMVcVJwIAHn/Ut5GAwAA
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
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-pcf8523.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8523.c b/drivers/rtc/rtc-pcf8523.c
index 889e316..305c951 100644
--- a/drivers/rtc/rtc-pcf8523.c
+++ b/drivers/rtc/rtc-pcf8523.c
@@ -307,7 +307,7 @@ static int pcf8523_probe(struct i2c_client *client,
 	if (err < 0)
 		return err;
 
-	pcf->rtc = rtc_device_register(DRIVER_NAME, &client->dev,
+	pcf->rtc = devm_rtc_device_register(&client->dev, DRIVER_NAME,
 				       &pcf8523_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pcf->rtc))
 		return PTR_ERR(pcf->rtc);
@@ -319,10 +319,6 @@ static int pcf8523_probe(struct i2c_client *client,
 
 static int pcf8523_remove(struct i2c_client *client)
 {
-	struct pcf8523 *pcf = i2c_get_clientdata(client);
-
-	rtc_device_unregister(pcf->rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


