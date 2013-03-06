Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3CFF2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:28:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:24902 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab3CFF2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:28:41 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-62-5136d407861a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 05/30] rtc: rtc-davinci: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:28:39 +0900
Message-id: <004701ce1a2b$7569d8b0$603d8a10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAADBiQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zY132K2aBBk27DSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKaJq/l62gmafi82WBBsbvnF2MnBwSAiYSfW+7mSFsMYkL99azdTFycQgJLGOU2HJ2
	PRNM0e25r8FsIYHpjBIz32lBFP1ilJg14xsLSIJNQE3iy5fD7F2MHBwiAvoSbS0aIDXMAr2M
	Emd6d7NDNNtKXO1eBbaNU8BOYvnjWWC9wgLuEguu72cDsVkEVCV+fzgCtowXqL556XZmCFtQ
	4sfke2D1zAJaEut3HmeCsOUlNq95ywyyV0JAXeLRX12IE4wkLmxXg6gQkdj34h0jyDkSAtfY
	JR60n2CEWCUg8W3yIRaIVlmJTQeg4SApcXDFDZYJQM8hWTwLyeJZSBbPQrJiASPLKkbR1ILk
	guKk9CIjveLE3OLSvHS95PzcTYyQKO3bwXjzgPUhxmSg9ROZpUST84FRnlcSb2hsbGJmYmpi
	bmlqbkqasJI4r/wlmUAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjI7Hl+/rm/p2zo7pLyex
	XnOduPbR/ddZln7CMU9XfVa4+MLzW9AZ9wIrhSeWcRUNOn7WYi/ZovztdW0ORNuHTtWfWhx0
	dWmozHV5XflFdQIlbe97Vz7Yt/QN24+NARP0Z/0/q+zr840r2HnlQfEDSzy2Tl5Xd6YkRmjj
	s1kzDY41ZjsYiPw2NVRiKc5INNRiLipOBAAScbfi6AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEKsWRmVeSWpSXmKPExsVy+t9jQV32K2aBBudm6lgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNE0fy9bQTNPxefLAg2M3zm7GDk5JARMJG7P
	fc0EYYtJXLi3ng3EFhKYzigx851WFyMXkP2LUWLWjG8sIAk2ATWJL18Os3cxcnCICOhLtLVo
	gNQwC/QySpzp3c0O0WwrcbV7FTOIzSlgJ7H88SywXmEBd4kF1/eDLWARUJX4/eEI2GJeoPrm
	pduZIWxBiR+T74HVMwtoSazfeZwJwpaX2LzmLTPIXgkBdYlHf3UhTjCSuLBdDaJCRGLfi3eM
	ExiFZiEZNAvJoFlIBs1C0rKAkWUVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnAKeCa9g3FV
	g8UhRgEORiUe3gkqZoFCrIllxZW5hxglOJiVRHi5zgCFeFMSK6tSi/Lji0pzUosPMSYD/TmR
	WUo0OR+YnvJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1OzW1ILUIZgsTB6dUA2OO
	9M7WmtQ3E+qs7iVzc9ZVdPLG+DnqVUx11V1pwdb+L07M+0RhVKht8xubX9qbnoQE7tDfsM4x
	wLvBUXHD9bnJwgv+nOZaKrP6hb0MR9HJtX9KCiQMuH98yT5keMyjsPVl3ZUDAczmAu9vXLif
	PnmfdDKfZfcvvbXbXj39ZJo5QWlhVO2mRUosxRmJhlrMRcWJALLaVvlFAwAA
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
 drivers/rtc/rtc-davinci.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index db877e0..8b49f7a 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -523,7 +523,7 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, davinci_rtc);
 
-	davinci_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	davinci_rtc->rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 				    &davinci_rtc_ops, THIS_MODULE);
 	if (IS_ERR(davinci_rtc->rtc)) {
 		ret = PTR_ERR(davinci_rtc->rtc);
@@ -543,7 +543,7 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 			  0, "davinci_rtc", davinci_rtc);
 	if (ret < 0) {
 		dev_err(dev, "unable to register davinci RTC interrupt\n");
-		goto fail2;
+		goto fail1;
 	}
 
 	/* Enable interrupts */
@@ -557,8 +557,6 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail2:
-	rtc_device_unregister(davinci_rtc->rtc);
 fail1:
 	platform_set_drvdata(pdev, NULL);
 	return ret;
@@ -572,8 +570,6 @@ static int __exit davinci_rtc_remove(struct platform_device *pdev)
 
 	rtcif_write(davinci_rtc, 0, PRTCIF_INTEN);
 
-	rtc_device_unregister(davinci_rtc->rtc);
-
 	platform_set_drvdata(pdev, NULL);
 
 	return 0;
-- 
1.7.2.5


