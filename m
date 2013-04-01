Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758740Ab3DAJoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:44:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34865 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758725Ab3DAJoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:44:12 -0400
X-AuditID: cbfee68d-b7f786d000005188-9d-515956d79a72
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 05/27] rtc: rtc-ds1216: use devm_*() functions
Date: Mon, 01 Apr 2013 18:43:51 +0900
Message-id: <001001ce2ebd$6aa359f0$3fea0dd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAADPNQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY93rYZGBBtebNC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKaLyyhLHghFDFoiWr2BsYJ/J3MXJySAiYSCxfMJ8NwhaTuHBvPZDNxSEksIxRYt3j
	C8wwRdPvtbFAJBYxSvzqnMQK4fxilNh87gILSBWbgJrEly+H2bsYOThEBPQl2lo0QGqYBXoZ
	Jc707mYHqRESsJX4cfY72FROATuJNwvnMYLYwkD2mqd7WUB6WQRUJTbt8QUJ8wKVr/8+lw3C
	FpT4Mfke2CpmAS2J9TuPM0HY8hKb17xlBmmVEFCXePRXF+ICI4kJH4MgKkQk9r14xwhyjYTA
	PXaJtqe7wVpZBAQkvk0+xALRKiux6QDUu5ISB1fcYJnAKDELyeJZSBbPQrJ4FpIVCxhZVjGK
	phYkFxQnpRcZ6hUn5haX5qXrJefnbmKExGnvDsbbB6wPMSYDrZ/ILCWanA+M87ySeENjMyML
	UxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MGb59CZf9i7wtXhR
	qPjF+Qfv9aUPzlkeXPdXzeNI+663TYrcCcslrVuVvF/v0W9b1dOeu/Ben5n+hGaXphuHThfs
	sYqbpb0lrtv/1aXPV0vaVr7S+u9UeKGCISJmJ+vRCZNLpBZ/LZ2z49iNJVvfzXvFyKJ0qzzq
	9GHlHTtvM7s2f9DpvlftcViJpTgj0VCLuag4EQAgXzh86QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd3rYZGBBnMXqFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNF4ZQljwQmhikVLVrE3ME7k72Lk5JAQMJGY
	fq+NBcIWk7hwbz1bFyMXh5DAIkaJX52TWCGcX4wSm89dAKtiE1CT+PLlMHsXIweHiIC+RFuL
	BkgNs0Avo8SZ3t3sIDVCArYSP85+ZwaxOQXsJN4snMcIYgsD2Wue7mUB6WURUJXYtMcXJMwL
	VL7++1w2CFtQ4sfke2CrmAW0JNbvPM4EYctLbF7zlhmkVUJAXeLRX12IC4wkJnwMgqgQkdj3
	4h3jBEahWUgGzUIyaBaSQbOQtCxgZFnFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJEZwEnknv
	YFzVYHGIUYCDUYmHN+JCRKAQa2JZcWXuIUYJDmYlEV6fb0Ah3pTEyqrUovz4otKc1OJDjMlA
	b05klhJNzgcmqLySeENjEzMjSyMzCyMTc3PShJXEeQ+2WgcKCaQnlqRmp6YWpBbBbGHi4JRq
	YDReUPRPvb1hwYq1cmtP5/0J6nzSmHN84/Gen7OfffnzWdqpSZ9XuOfp/1ZJB50onrxL2Tas
	TP16ycXnHrEz+rT3R2+dOU22+LX4gl0bps7gm2PvG35OqFPz+buI/8UPmaN1Y5enrfrhPj9g
	4YRClg/LV1+Lm9hyaPqF1Wlz85foMExLtj1k/UWJpTgj0VCLuag4EQC5akiwRgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-ds1216.c |   44 +++++++++-----------------------------------
 1 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/drivers/rtc/rtc-ds1216.c b/drivers/rtc/rtc-ds1216.c
index 45cd8c9..c7702b7 100644
--- a/drivers/rtc/rtc-ds1216.c
+++ b/drivers/rtc/rtc-ds1216.c
@@ -30,8 +30,6 @@ struct ds1216_regs {
 struct ds1216_priv {
 	struct rtc_device *rtc;
 	void __iomem *ioaddr;
-	size_t size;
-	unsigned long baseaddr;
 };
 
 static const u8 magic[] = {
@@ -144,57 +142,33 @@ static int __init ds1216_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct ds1216_priv *priv;
-	int ret = 0;
 	u8 dummy[8];
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
 		return -ENODEV;
-	priv = kzalloc(sizeof *priv, GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
 	platform_set_drvdata(pdev, priv);
 
-	priv->size = resource_size(res);
-	if (!request_mem_region(res->start, priv->size, pdev->name)) {
-		ret = -EBUSY;
-		goto out;
-	}
-	priv->baseaddr = res->start;
-	priv->ioaddr = ioremap(priv->baseaddr, priv->size);
-	if (!priv->ioaddr) {
-		ret = -ENOMEM;
-		goto out;
-	}
-	priv->rtc = rtc_device_register("ds1216", &pdev->dev,
-				  &ds1216_rtc_ops, THIS_MODULE);
-	if (IS_ERR(priv->rtc)) {
-		ret = PTR_ERR(priv->rtc);
-		goto out;
-	}
+	priv->ioaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(priv->ioaddr))
+		return PTR_ERR(priv->ioaddr);
+
+	priv->rtc = devm_rtc_device_register(&pdev->dev, "ds1216",
+					&ds1216_rtc_ops, THIS_MODULE);
+	if (IS_ERR(priv->rtc))
+		return PTR_ERR(priv->rtc);
 
 	/* dummy read to get clock into a known state */
 	ds1216_read(priv->ioaddr, dummy);
 	return 0;
-
-out:
-	if (priv->ioaddr)
-		iounmap(priv->ioaddr);
-	if (priv->baseaddr)
-		release_mem_region(priv->baseaddr, priv->size);
-	kfree(priv);
-	return ret;
 }
 
 static int __exit ds1216_rtc_remove(struct platform_device *pdev)
 {
-	struct ds1216_priv *priv = platform_get_drvdata(pdev);
-
-	rtc_device_unregister(priv->rtc);
-	iounmap(priv->ioaddr);
-	release_mem_region(priv->baseaddr, priv->size);
-	kfree(priv);
 	return 0;
 }
 
-- 
1.7.2.5


