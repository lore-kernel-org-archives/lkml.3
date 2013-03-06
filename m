Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3CFFdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:33:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17080 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab3CFFdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:33:16 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-b1-5136d51b8d38
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 18/30] rtc: rtc-palmas: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:33:15 +0900
Message-id: <005401ce1a2c$19de5f10$4d9b1d30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAANNmg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zA13pq2aBBvM69S0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG/b9r2AseclX8vLeNrYGxgbOLkZNDQsBEYuaSiewQtpjEhXvr
	2boYuTiEBJYxStx9cg7I4QAr+vuhFiK+iFHi3qlfzBDObCaJeTNms4J0swmoSXz5cpgdpEFE
	QF+irUUDpIZZoJdR4kzvbrANQgK2Ele7VzGD2JwCdhLLH89iAbGFBdwkzp95DVbDIqAqsfvQ
	DyYQmxeo/vH5ecwQtqDEj8n3wOqZBbQk1u88zgRhy0tsXvOWGeJQdYlHf3VBwiICRhLzp3cz
	Q5SISOx78Y4R5B4JgVXsEvO2/GGG2CUg8W3yIRaIXlmJTQeYIQEhKXFwxQ2WCYwSs5BsnoVk
	8ywkm2chWbGAkWUVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkhk9e9gvHvA+hBjMtD6icxS
	osn5wMjMK4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5O
	qQbGpZOZNPabGO6onxz89Nff477cvzcxT2r/9mFDVNrkTybTbnwKKvNIUXmwm9HdS+2TVkVF
	Mr+p9MW5kldOT1g3b9OcrpCr05KUu87tvFbM3fw7VMbUurtA0/W2GtN858WaET2bNB10RBr6
	VAL7JmQfa/vrM/mhspDDUo4Giakn+t1qjZYXq/xTYinOSDTUYi4qTgQAlwK0OMICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK70VbNAg7n92haXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/7fNewFD7kqft7bxtbA
	2MDZxcjBISFgIvH3Q20XIyeQKSZx4d56ti5GLg4hgUWMEvdO/WKGcGYzScybMZsVpIpNQE3i
	y5fD7CDNIgL6Em0tGiA1zAK9jBJnenezg9QICdhKXO1exQxicwrYSSx/PIsFxBYWcJM4f+Y1
	WA2LgKrE7kM/mEBsXqD6x+fnMUPYghI/Jt8Dq2cW0JJYv/M4E4QtL7F5zVtmiKPVJR791QUJ
	iwgYScyf3s0MUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4
	NC9dLzk/dxMjOG6fSe1gXNlgcYhRgINRiYfXQsksUIg1say4MvcQowQHs5IIL9cZoBBvSmJl
	VWpRfnxRaU5q8SHGZKBHJzJLiSbnA1NKXkm8obGJmZGlkZmFkYm5OWnCSuK8jKeeBAgJpCeW
	pGanphakFsFsYeLglGpg7Pr36v/tL7P41q31UGVZ9sumMf+wuTj/47LvM40PdMn5et84kzYv
	wGaPwLNTN+92iP9cfHWi5iTZ9S7qvj3LXU7s+2H2MjjX+a/fZo07j+x2b29mmWb8Jmrvky+8
	IWvfKO4r+viPc4+k1SbHxJbd3awu2ec0FcOnPF6/3XKKqHJ+z9r399Pb5imxFGckGmoxFxUn
	AgALoVmSHwMAAA==
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
 drivers/rtc/rtc-palmas.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
index df9359c..2766ca3 100644
--- a/drivers/rtc/rtc-palmas.c
+++ b/drivers/rtc/rtc-palmas.c
@@ -264,7 +264,7 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 
 	palmas_rtc->irq = platform_get_irq(pdev, 0);
 
-	palmas_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	palmas_rtc->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 				&palmas_rtc_ops, THIS_MODULE);
 	if (IS_ERR(palmas_rtc->rtc)) {
 		ret = PTR_ERR(palmas_rtc->rtc);
@@ -279,7 +279,6 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 			dev_name(&pdev->dev), palmas_rtc);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "IRQ request failed, err = %d\n", ret);
-		rtc_device_unregister(palmas_rtc->rtc);
 		return ret;
 	}
 
@@ -289,10 +288,7 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 
 static int palmas_rtc_remove(struct platform_device *pdev)
 {
-	struct palmas_rtc *palmas_rtc = platform_get_drvdata(pdev);
-
 	palmas_rtc_alarm_irq_enable(&pdev->dev, 0);
-	rtc_device_unregister(palmas_rtc->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


