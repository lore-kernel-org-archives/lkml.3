Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3CFHvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:51:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46122 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3CFHv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:51:29 -0500
X-AuditID: cbfee68d-b7f636d0000009be-06-5136f58026bb
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 12/30] rtc: rtc-lpc32xx: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:51:28 +0900
Message-id: <008601ce1a3f$68e14a60$3aa3df20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAJCzA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zQ92Gr2aBBveu6Vtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mn/+mMhU84aiYvXwJYwPjGvYuRk4OCQETiQ0THjND2GISF+6t
	ZwOxhQSWMUp09Rt3MXKA1dz7HdbFyAUUXsQosWrxbkYIZzaTxOTFk8EGsQmoSXz5cpgdpEFE
	QF+irUUDpIZZoJdR4kzvbrC4kICtRM88HpByTgE7iSkTH4O1Cgt4SazeOQPMZhFQlbg2fyYj
	iM0LVN44q4UVwhaU+DH5HguIzSygJbF+53EmCFteYvOat8wQd6pLPPqrCxIWETCSWHzoK1SJ
	iMS+F+/ATpYQWMQucWnlShaIXQIS3yYfYoHolZXYdAAaDJISB1fcYJnAKDELyeZZSDbPQrJ5
	FpIVCxhZVjGKphYkFxQnpRcZ6hUn5haX5qXrJefnbmKERFXvDsbbB6wPMSYDrZ/ILCWanA+M
	yrySeENjYxMzE1MTc0tTc1PShJXEeeUuyQQKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYHSL
	N74VNa9s1yQxqU6R3qSrhcfneTmGexrMX/nhctbqX5qpYW6L7vfIvv9TYXmY3VZdnk/6/4/+
	aWuOXt1yd2o0t8GaxUqHZ1zPs6ysu++/KS4zWLnt5ZbGkpnRJUE3D51n3sM76cR5Za7XpuER
	Dw/xqZcx/PkbmHqE2TEg1y9/E6/aF7nYXiWW4oxEQy3mouJEAJTYWB3AAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgG7DV7NAg+43WhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4+e/qUwFTzgqZi9fwtjA
	uIa9i5GDQ0LAROLe77AuRk4gU0ziwr31bF2MXBxCAosYJVYt3s0I4cxmkpi8eDI7SBWbgJrE
	ly+HwZpFBPQl2lo0QGqYBXoZJc707gaLCwnYSvTM4wEp5xSwk5gy8TFYq7CAl8TqnTPAbBYB
	VYlr82cygti8QOWNs1pYIWxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMcbO6xKO/uiBhEQEj
	icWHvkKViEjse/GOcQKj0Cwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dL
	zs/dxAiO2mdSOxhXNlgcYhTgYFTi4bVQMgsUYk0sK67MPcQowcGsJMLLdQYoxJuSWFmVWpQf
	X1Sak1p8iDEZ6NGJzFKiyfnAhJJXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScBQgLpiSWp2amp
	BalFMFuYODilGhi92NMltSsW780yzv+vaLom3/JPq/l5765Op7PWd/5f++vwRtXNsTLd1ONk
	sVi/05M+AbbnXl/c27Tn8cxfd+b3jzNmmYpzvFlUo3PKI9WnzViw8oLQzK2xN5RO8LPrfNjH
	8JIhfOncgnOXVSfPDX1pLLq/JaHLtvSU3ZR43vWNKous3oj58CqxFGckGmoxFxUnAgAv1ky4
	HgMAAA==
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

 drivers/rtc/rtc-lpc32xx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index 40a5983..787550d 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -273,8 +273,8 @@ static int lpc32xx_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc);
 
-	rtc->rtc = rtc_device_register(RTC_NAME, &pdev->dev, &lpc32xx_rtc_ops,
-		THIS_MODULE);
+	rtc->rtc = devm_rtc_device_register(&pdev->dev, RTC_NAME,
+					&lpc32xx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc->rtc)) {
 		dev_err(&pdev->dev, "Can't get RTC\n");
 		platform_set_drvdata(pdev, NULL);
@@ -307,7 +307,6 @@ static int lpc32xx_rtc_remove(struct platform_device *pdev)
 		device_init_wakeup(&pdev->dev, 0);
 
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(rtc->rtc);
 
 	return 0;
 }
-- 
1.7.2.5


