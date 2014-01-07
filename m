Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaAGLvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:51:47 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:50638 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaAGLvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:51:31 -0500
X-AuditID: cbfee690-b7f266d00000287c-65-52cbea425b67
From: Naveen Krishna Ch <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/5] crypto:s5p-sss: Use platform_get_irq() instead of _byname()
Date: Tue, 07 Jan 2014 17:21:45 +0530
Message-id: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsWyRsSkWtfp1ekgg7t3lS1eHtK0mHO+hcWi
	+5WMxf17P5ksLu+aw2Yx4/w+JotF2/4zW5ydc4jJgcNjy8qbTB47Z91l99h2QNWjb8sqRo/P
	m+QCWKO4bFJSczLLUov07RK4Mv5sTynYL1xxtPceUwNju0AXIyeHhICJxLE3UxghbDGJC/fW
	s3UxcnEICSxllLi0fS8TTNGNT6dZIRKLGCXeN7VBOf1MEh03XrGCVLEJ6Essu74YbJSIgLPE
	7+Y1YEXMAusYJV7+nc0GkhAWCJDYdeUtC4jNIqAq8eLODDCbV8BV4uCO10DNHEDrFCTmTLIB
	CXMKuEmcPnSRHSQsBFRy+EgaxEGL2CU2HPaAmCIg8W3yIRaITlmJTQeYIUokJQ6uuMEygVF4
	ASPDKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYzAMD/979mEHYz3DlgfYkwGGjeRWUo0OR8Y
	J3kl8YbGZkYWpiamxkbmlmakCSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwBjz
	si2nzcDWma2s7b36YofrS1622VxrfyJ/6I0325+bAjs9I+1Eps1YpSHOuK255/FBfpaE6l37
	k7NWKa5Wa7mT2lJt+kfGzl3G6ZVcy6uOVPmdXy9fD/l7JdVv7nqFhnnrJjyuZNKUynLZnq85
	f998NUt1pUOzvTp0Jt28qvSKcfuPwKO7HiixFGckGmoxFxUnAgAerD5LiQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAV2nV6eDDJ7dkLZ4eUjTYs75FhaL
	7lcyFvfv/WSyuLxrDpvFjPP7mCwWbfvPbHF2ziEmBw6PLStvMnnsnHWX3WPbAVWPvi2rGD0+
	b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
	AbpESaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5jxZ3tKwX7hiqO995ga
	GNsFuhg5OSQETCRufDrNCmGLSVy4t56ti5GLQ0hgEaPE+6Y2Vginn0mi48YrsCo2AX2JZdcX
	M4LYIgLOEr+b14AVMQusY5R4+Xc2G0hCWCBAYteVtywgNouAqsSLOzPAbF4BV4mDO14DNXMA
	rVOQmDPJBiTMKeAmcfrQRXaQsBBQyeEjaRMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vO
	z93ECI6jZ9I7GFc1WBxiFOBgVOLhfbH3VJAQa2JZcWXuIUYJDmYlEV7mG6eDhHhTEiurUovy
	44tKc1KLDzEmA900kVlKNDkfGON5JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJITyxJzU5N
	LUgtgtnCxMEp1cA4JfhictqvzWlrHh2u6N5h8Cb1i+y2EzvuRW9YlcjK0jE/TufafRnF545S
	M6qYipw4VwSs0JgoecDnwyHr1h0mLZNfa3YHzFgY6r7i/d/Xt08HVOn8smGTubB9bevRWUbL
	Z8zwYMtjvuXjy7JzUcfftFOpyzxmums5i7XMY5oR2rVyb5vJEotiJZbijERDLeai4kQAaI/W
	A+cCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses the platform_get_irq() instead of the
platform_get_irq_byname(). Making feeder control interrupt
as resource "0" and hash interrupt as "1".

reasons for this change.
1. Cannot find any Arch which is currently using this driver
2. Samsung Exynos5 SoCs only use the feeder control interrupt
3. Patches adding support for DT and H/W version are in pipeline

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
 drivers/crypto/s5p-sss.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index cf149b1..dda4551 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -592,29 +592,29 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	pdata->ioaddr = devm_ioremap(dev, res->start,
 				     resource_size(res));
 
-	pdata->irq_hash = platform_get_irq_byname(pdev, "hash");
-	if (pdata->irq_hash < 0) {
+	pdata->irq_fc = platform_get_irq(pdev, 0);
+	if (pdata->irq_fc < 0) {
 		err = pdata->irq_hash;
-		dev_warn(dev, "hash interrupt is not available.\n");
+		dev_warn(dev, "feed control interrupt is not available.\n");
 		goto err_irq;
 	}
-	err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
+	err = devm_request_irq(dev, pdata->irq_fc, s5p_aes_interrupt,
 			       IRQF_SHARED, pdev->name, pdev);
 	if (err < 0) {
-		dev_warn(dev, "hash interrupt is not available.\n");
+		dev_warn(dev, "feed control interrupt is not available.\n");
 		goto err_irq;
 	}
 
-	pdata->irq_fc = platform_get_irq_byname(pdev, "feed control");
-	if (pdata->irq_fc < 0) {
-		err = pdata->irq_fc;
-		dev_warn(dev, "feed control interrupt is not available.\n");
+	pdata->irq_hash = platform_get_irq(pdev, 1);
+	if (pdata->irq_hash < 0) {
+		err = pdata->irq_hash;
+		dev_warn(dev, "hash interrupt is not available.\n");
 		goto err_irq;
 	}
-	err = devm_request_irq(dev, pdata->irq_fc, s5p_aes_interrupt,
+	err = devm_request_irq(dev, pdata->irq_hash, s5p_aes_interrupt,
 			       IRQF_SHARED, pdev->name, pdev);
 	if (err < 0) {
-		dev_warn(dev, "feed control interrupt is not available.\n");
+		dev_warn(dev, "hash interrupt is not available.\n");
 		goto err_irq;
 	}
 
-- 
1.7.9.5

