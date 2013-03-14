Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3CNIX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:23:57 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34014 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755612Ab3CNIXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:23:54 -0400
X-AuditID: cbfee68e-b7f946d000001e37-b6-51418919de06
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 28/30] rtc: rtc-tile: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:23:52 +0900
Message-id: <009f01ce208d$4331d560$c9958020$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAdvbA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zfV3JTsdAgz17hCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGpN5LbAXtHBXvH09la2A8z9bFyMkhIWAisWXdbChbTOLCvfVA
	NheHkMAyRolzxy4ywhRtbfzFApFYxCjxYMkWVghnNpNE3/MOJpAqNgE1iS9fDrN3MXJwiAjo
	S7S1aIDUMAv0Mkqc6d0NFhcSsJW4/t8OxOQUsJPYsF4MpFNYwEVi6bEDYEewCKhKvOx4Dmbz
	AlW3H33BCGELSvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmkJESAuoSj/7qgoRFBIwkHp04DVUi
	IrHvxTtGkGskBBaxSyx9sZodYpeAxLfJh1ggemUlNh1ghnhXUuLgihssExglZiHZPAvJ5llI
	Ns9CsmIBI8sqRtHUguSC4qT0IiO94sTc4tK8dL3k/NxNjJC46tvBePOA9SHGZKD1E5mlRJPz
	gXGZVxJvaGxmZGFqYmpsZG5pRpqwkjivWot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG
	qVO6j20859Iee0Pu+/xzrCcfLAs7p+v2/prf6rTW/hkcNvyP10zrZbY3d2Dlnb/g6FYGy3XX
	pl2cd0CY3b7CS0u15UjixfNcEytXLGb6OjVyRtVRte0LnukJR0lVL279x3Q+x0Rr2octTP8z
	jr9mV78a5tIs4zZvg6qf5R/xq3nmb39vl1x8RomlOCPRUIu5qDgRANtPkF7BAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgK5kp2OgweHdfBaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY1LvJbaCdo6K94+nsjUw
	nmfrYuTkkBAwkdja+IsFwhaTuHBvPVCci0NIYBGjxIMlW1ghnNlMEn3PO5hAqtgE1CS+fDnM
	3sXIwSEioC/R1qIBUsMs0MsocaZ3N1hcSMBW4vp/OxCTU8BOYsN6MZBOYQEXiaXHDoDtZRFQ
	lXjZ8RzM5gWqbj/6ghHCFpT4Mfke2D3MAloS63ceZ4Kw5SU2r3nLDDJSQkBd4tFfXZCwiICR
	xKMTp6FKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl
	5+duYgRH7TPpHYyrGiwOMQpwMCrx8EaIOgYKsSaWFVfmHmKU4GBWEuH19AIK8aYkVlalFuXH
	F5XmpBYfYkwGenQis5Rocj4woeSVxBsam5gZWRqZWRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1
	ILUIZgsTB6dUA6P7s5nXdwgvKnAWPLfMLkd2+deyTrdbXcWxEZc3MB0uZJmkWXOmn3HV/LBp
	dVJroxd66px8tubwMXeN/g+v35hkb246eNFm8QIuT/FLCzsS9tdEnAp/vtzPfy/Lvamv7n/Y
	nnbzwp9/jJ+mHr9aVilwIik2zGbNhOduzht3n/w13XdPYfjBQ8+mKbEUZyQaajEXFScCAOCa
	2J8eAwAA
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
 drivers/rtc/rtc-tile.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-tile.c b/drivers/rtc/rtc-tile.c
index 62db484..249b653 100644
--- a/drivers/rtc/rtc-tile.c
+++ b/drivers/rtc/rtc-tile.c
@@ -80,8 +80,8 @@ static int tile_rtc_probe(struct platform_device *dev)
 {
 	struct rtc_device *rtc;
 
-	rtc = rtc_device_register("tile",
-				  &dev->dev, &tile_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&dev->dev, "tile",
+				&tile_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
@@ -96,11 +96,6 @@ static int tile_rtc_probe(struct platform_device *dev)
  */
 static int tile_rtc_remove(struct platform_device *dev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(dev);
-
-	if (rtc)
-		rtc_device_unregister(rtc);
-
 	platform_set_drvdata(dev, NULL);
 
 	return 0;
-- 
1.7.2.5


