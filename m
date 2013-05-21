Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756246Ab3EUGRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:17:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:24624 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3EUGRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:17:15 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-33-519b116ac40b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/8] rtc: rtc-m48t59: use devm_*() functions
Date: Tue, 21 May 2013 15:17:13 +0900
Message-id: <000601ce55ea$d5f478c0$81dd6a40$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5V6tVOXAAWgNOzRHWAwKlWaxCveQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zfd0swdmBBud6BCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKOHliMUvBAumKKdcPMTUwtot1MXJySAiYSCzfuZwJwhaTuHBvPVsXIxeHkMAyRomO
	N3eZYYp+XD7CCJGYziix7OJKVgjnF6PEqocTwNrZBNQkvnw5zN7FyMEhIqAv0daiAVLDLNDN
	KPGoeS7YJGEBG4mbS7aB2SwCqhL3Ps4A6+UVsJR4s7mBBcIWlPgx+R6YzSygJbF+53EmCFte
	YvOat1AXKUjsOPuaEcQWEdCTWDPtCCtEjYjEvhfvwC6VEDjGLrFn5n0miGUCEt8mH2IBOU5C
	QFZi0wGoOZISB1fcYJnAKDYLyepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpRcZ6hUn5haX5qXr
	JefnbmKERF/vDsbbB6wPMSYDrZ/ILCWanA+M3rySeENjMyMLUxNTYyNzSzPShJXEedVarAOF
	BNITS1KzU1MLUovii0pzUosPMTJxcEo1MPq5HtzK5fv6ifqH4mPycSw3rMVu9Kze2bksoOP/
	I+UfWj6222a2c939v8ojPCKFQ0P3a8nitWuY31kULDAWir5woVxn5RLPzN51Zd8O7jDmz9lr
	rpepZ7DP8AVfV4Kf5ayq1QcdwxcuO+2j1222M15jRrXtQSf2HPU2L4eliRtbt4iyHr39RYml
	OCPRUIu5qDgRAOc5jT/UAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd0swdmBBv2TeCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDh5YjFLwQLpiinXDzE1MLaLdTFyckgImEj8
	uHyEEcIWk7hwbz1bFyMXh5DAdEaJZRdXskI4vxglVj2cwARSxSagJvHly2H2LkYODhEBfYm2
	Fg2QGmaBbkaJR81zmUFqhAVsJG4u2QZmswioStz7OAOsl1fAUuLN5gYWCFtQ4sfke2A2s4CW
	xPqdx5kgbHmJzWveMkNcpCCx4+xrsOtEBPQk1kw7wgpRIyKx78U7xgmMArOQjJqFZNQsJKNm
	IWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4tp9J72Bc1WBxiFGAg1GJh1fAcFag
	EGtiWXFl7iFGCQ5mJRHe781AId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYSTc4Hpp28knhDYxMz
	I0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBMnrdnW/SDR4Um0++oZmRP
	bEhlnnJq9in2CHnJUsHfy+/vkDqgM/tAlI5bdeqxOIs3j8PvpBwTOG3/tpxtW8evsI9Prgce
	lF+YErdiYaTR7asB5kxNk9sn/D7q061u8pVRPbViCaPmljMT+pPYFnf8EL1Rw7H+6SQOc47f
	au7+1zhnrLbJnbREiaU4I9FQi7moOBEA8GsfxTEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-m48t59.c |   53 +++++++++++++++-------------------------------
 1 file changed, 17 insertions(+), 36 deletions(-)

diff --git a/drivers/rtc/rtc-m48t59.c b/drivers/rtc/rtc-m48t59.c
index d4d31fa..fcb0329 100644
--- a/drivers/rtc/rtc-m48t59.c
+++ b/drivers/rtc/rtc-m48t59.c
@@ -409,7 +409,8 @@ static int m48t59_rtc_probe(struct platform_device *pdev)
 	} else if (res->flags & IORESOURCE_MEM) {
 		/* we are memory-mapped */
 		if (!pdata) {
-			pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
+			pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata),
+						GFP_KERNEL);
 			if (!pdata)
 				return -ENOMEM;
 			/* Ensure we only kmalloc platform data once */
@@ -425,7 +426,7 @@ static int m48t59_rtc_probe(struct platform_device *pdev)
 			pdata->read_byte = m48t59_mem_readb;
 	}
 
-	m48t59 = kzalloc(sizeof(*m48t59), GFP_KERNEL);
+	m48t59 = devm_kzalloc(&pdev->dev, sizeof(*m48t59), GFP_KERNEL);
 	if (!m48t59)
 		return -ENOMEM;
 
@@ -433,9 +434,10 @@ static int m48t59_rtc_probe(struct platform_device *pdev)
 
 	if (!m48t59->ioaddr) {
 		/* ioaddr not mapped externally */
-		m48t59->ioaddr = ioremap(res->start, resource_size(res));
+		m48t59->ioaddr = devm_ioremap(&pdev->dev, res->start,
+						resource_size(res));
 		if (!m48t59->ioaddr)
-			goto out;
+			return ret;
 	}
 
 	/* Try to get irq number. We also can work in
@@ -446,10 +448,11 @@ static int m48t59_rtc_probe(struct platform_device *pdev)
 		m48t59->irq = NO_IRQ;
 
 	if (m48t59->irq != NO_IRQ) {
-		ret = request_irq(m48t59->irq, m48t59_rtc_interrupt,
-			IRQF_SHARED, "rtc-m48t59", &pdev->dev);
+		ret = devm_request_irq(&pdev->dev, m48t59->irq,
+				m48t59_rtc_interrupt, IRQF_SHARED,
+				"rtc-m48t59", &pdev->dev);
 		if (ret)
-			goto out;
+			return ret;
 	}
 	switch (pdata->type) {
 	case M48T59RTC_TYPE_M48T59:
@@ -469,51 +472,29 @@ static int m48t59_rtc_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(&pdev->dev, "Unknown RTC type\n");
-		ret = -ENODEV;
-		goto out;
+		return -ENODEV;
 	}
 
 	spin_lock_init(&m48t59->lock);
 	platform_set_drvdata(pdev, m48t59);
 
-	m48t59->rtc = rtc_device_register(name, &pdev->dev, ops, THIS_MODULE);
-	if (IS_ERR(m48t59->rtc)) {
-		ret = PTR_ERR(m48t59->rtc);
-		goto out;
-	}
+	m48t59->rtc = devm_rtc_device_register(&pdev->dev, name, ops,
+						THIS_MODULE);
+	if (IS_ERR(m48t59->rtc))
+		return PTR_ERR(m48t59->rtc);
 
 	m48t59_nvram_attr.size = pdata->offset;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &m48t59_nvram_attr);
-	if (ret) {
-		rtc_device_unregister(m48t59->rtc);
-		goto out;
-	}
+	if (ret)
+		return ret;
 
 	return 0;
-
-out:
-	if (m48t59->irq != NO_IRQ)
-		free_irq(m48t59->irq, &pdev->dev);
-	if (m48t59->ioaddr)
-		iounmap(m48t59->ioaddr);
-		kfree(m48t59);
-	return ret;
 }
 
 static int m48t59_rtc_remove(struct platform_device *pdev)
 {
-	struct m48t59_private *m48t59 = platform_get_drvdata(pdev);
-	struct m48t59_plat_data *pdata = pdev->dev.platform_data;
-
 	sysfs_remove_bin_file(&pdev->dev.kobj, &m48t59_nvram_attr);
-	if (!IS_ERR(m48t59->rtc))
-		rtc_device_unregister(m48t59->rtc);
-	if (m48t59->ioaddr && !pdata->ioaddr)
-		iounmap(m48t59->ioaddr);
-	if (m48t59->irq != NO_IRQ)
-		free_irq(m48t59->irq, &pdev->dev);
-	kfree(m48t59);
 	return 0;
 }
 
-- 
1.7.10.4


