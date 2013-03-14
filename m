Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab3CNIVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:21:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25980 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3CNIVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:21:36 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-a6-5141888eda1f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 21/30] rtc: rtc-rs5c313: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:21:34 +0900
Message-id: <009801ce208c$f09993b0$d1ccbb10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAYpQg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zA92+DsdAg9W7dC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGw8ZDjAVtHBULJ61mbmC8zdbFyMkhIWAi0b5wOyuELSZx4d56
	oDgXh5DAMkaJTcfOwhVt3rKRCSKxiFHi0/xnLBDObCaJHxPng1WxCahJfPlymL2LkYNDREBf
	oq1FA6SGWaCXUeJM726wuJCArcT1/3YgJqeAncSG9WIgncIC7hIdn2awgNgsAqoSz5YuYQKx
	eYGq57y8zAhhC0r8mHwPrIZZQEti/c7jTBC2vMTmNW+ZQUZKCKhLPPqrCxIWETCS6O48wwxR
	IiKx78U7RpBrJASWsUtMW/kZapeAxLfJh1ggemUlNh1ghnhXUuLgihssExglZiHZPAvJ5llI
	Ns9CsmIBI8sqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJC4mriD8f4B60OMyUDrJzJLiSbn
	A+MyryTe0NjMyMLUxNTYyNzSjDRhJXFe9RbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M
	p1funJE4SaPm4oOKL5utFvwxO1/K2GTsza+feSB3f1QZj/z8RD62+PD/fKsWrPG50Bq093aO
	cU5Oe/KWaS/ilJ2m3JxhJeb+a38i08dDZwpZqmf+nrhF5MPChpM9F+2+//vwc2dU7ospgfts
	D4pskfr47+jfG8uec6mtK+qKZ+0w/8X6rN70thJLcUaioRZzUXEiAPeArVDBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG5fh2OgQe9STYvLu+awOTB6fN4k
	F8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQM0
	VUmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY8bDxEGNBG0fFwkmrmRsY
	b7N1MXJySAiYSGzespEJwhaTuHBvPVCci0NIYBGjxKf5z1ggnNlMEj8mzgfrYBNQk/jy5TB7
	FyMHh4iAvkRbiwZIDbNAL6PEmd7dYHEhAVuJ6//tQExOATuJDevFQDqFBdwlOj7NYAGxWQRU
	JZ4tXQK2lxeoes7Ly4wQtqDEj8n3wGqYBbQk1u88zgRhy0tsXvOWGWSkhIC6xKO/uiBhEQEj
	ie7OM8wQJSIS+168Y5zAKDQLyaRZSCbNQjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1
	kvNzNzGCo/aZ1A7GlQ0WhxgFOBiVeHgP9DsECrEmlhVX5h5ilOBgVhLh9fRyDBTiTUmsrEot
	yo8vKs1JLT7EmAz06ERmKdHkfGBCySuJNzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2
	ampBahHMFiYOTqkGRhY/3Yq759qCT81fvnq/RcWR9ymmq07tst30ML2P62F9u2ZbfGJ0SfuH
	VdPe/WUK+7PM/aaDvfSdQ/0xshuOW/THFK99dqf3Knfo3kX/rKa+PFib+HV9r+Gq4P/Lri/Y
	e+fAjxdrvFjjFoYbNrVnL1woueJKSaPgZF2GX82qhm7fes6m8Pg371NiKc5INNRiLipOBADe
	GJSkHgMAAA==
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
 drivers/rtc/rtc-rs5c313.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c313.c b/drivers/rtc/rtc-rs5c313.c
index d98ea5b..8089fc6 100644
--- a/drivers/rtc/rtc-rs5c313.c
+++ b/drivers/rtc/rtc-rs5c313.c
@@ -367,7 +367,7 @@ static const struct rtc_class_ops rs5c313_rtc_ops = {
 
 static int rs5c313_rtc_probe(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = rtc_device_register("rs5c313", &pdev->dev,
+	struct rtc_device *rtc = devm_rtc_device_register(&pdev->dev, "rs5c313",
 				&rs5c313_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc))
@@ -380,10 +380,6 @@ static int rs5c313_rtc_probe(struct platform_device *pdev)
 
 static int rs5c313_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata( pdev );
-
-	rtc_device_unregister(rtc);
-
 	return 0;
 }
 
-- 
1.7.2.5


