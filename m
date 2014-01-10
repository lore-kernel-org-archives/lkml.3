Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaAJLla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 06:41:30 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:35461 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbaAJLl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:41:28 -0500
X-AuditID: cbfee68e-b7f566d000002344-d9-52cfdc66b437
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/8 v3] crypto:s5p-sss: Use platform_get_irq() instead of
 _byname()
Date: Fri, 10 Jan 2014 17:11:42 +0530
Message-id: <1389354102-31709-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSpZt253yQwZ27WhZ3nx9mtHh5SNNi
	zvkWFovuVzIW9+/9ZLK4vGsOm8WM8/uYLBZt+89ssWrXH0aLs3MOMTlweWxZeZPJY+esu+we
	2w6oevRtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfG9s4pLAXrRCqutl9mamC8L9DFyMEhIWAi
	sXMDexcjJ5ApJnHh3nq2LkYuDiGBpYwSm1beYoJImEgsmrqNCSKxiFFi7dpdzBBOP5PEkiWP
	wNrZBMwkDi5aDWaLCDhL/G5ewwpSxCzwiVGiYf0qVpCEsECoxN8rJ8CKWARUJe42HASzeQVc
	JQ4t2McCcZKCxJxJNiBhTgE3iQPf94BdIQRU8n3PEbDzJAQ2sUu8bfvIBDFHQOLb5ENQvbIS
	mw4wQ1wtKXFwxQ2WCYzCCxgZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmIEhv/pf8/6djDe
	PGB9iDEZaNxEZinR5Hxg/OSVxBsamxlZmJqYGhuZW5qRJqwkzrvoYVKQkEB6YklqdmpqQWpR
	fFFpTmrxIUYmDk6pBkZJdquL3kubnOMZtx5bu2HWir7cgpwZixgDlghMcGM00hfbdpW3cDJ3
	qYbylMAi8aWnIr5PYt195MH6bV8+LuGQDDZd0SrsZr+u7V3kyknJ06MXT11uJx+92HN64Ef1
	UOWGK9KahrI8/4PNxZQl/m1R/rP9eXL03VIPxknSfsvYi0TsLiRXSCuxFGckGmoxFxUnAgBZ
	gsB+lQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t9jAd20O+eDDLb8kLe4+/wwo8XLQ5oW
	c863sFh0v5KxuH/vJ5PF5V1z2CxmnN/HZLFo239mi1W7/jBanJ1ziMmBy2PLyptMHjtn3WX3
	2HZA1aNvyypGj8+b5AJYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPIS
	c1NtlVx8AnTdMnOAblJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYwZmzv
	nMJSsE6k4mr7ZaYGxvsCXYycHBICJhKLpm5jgrDFJC7cW8/WxcjFISSwiFFi7dpdzBBOP5PE
	kiWP2EGq2ATMJA4uWg1miwg4S/xuXsMKUsQs8IlRomH9KlaQhLBAqMTfKyfAilgEVCXuNhwE
	s3kFXCUOLdjH0sXIAbROQWLOJBuQMKeAm8SB73vArhACKvm+5wjbBEbeBYwMqxhFUwuSC4qT
	0nON9IoTc4tL89L1kvNzNzGC4+uZ9A7GVQ0WhxgFOBiVeHgLZp0PEmJNLCuuzD3EKMHBrCTC
	a34BKMSbklhZlVqUH19UmpNafIgxGeioicxSosn5wNjPK4k3NDYxNzU2tTSxMDGzJE1YSZz3
	YKt1oJBAemJJanZqakFqEcwWJg5OqQZGY69rP2fMdDHfdfBMHsvtKt5yljMOR3Liw774rp7w
	49Fk+S16gv3L0nbkqnWZHzUX2+hstnd7+Gqlxpzp05fd+vRTo+lcRGa2wF6rlc2zPvjcXv1z
	6+u7uUvEcmwXF5V2fcw2aZJqUywp31bW4VvWmraxSciHUblzyuTwbV4z5Zd0cLzUfuCixFKc
	kWioxVxUnAgASCX7k/MCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Ch <ch.naveen@samsung.com>

This patch uses the platform_get_irq() instead of the
platform_get_irq_byname(). Making feeder control interrupt
as resource "0" and hash interrupt as "1".

reasons for this change.
1. Cannot find any Arch which is currently using this driver
2. Samsung Exynos4 and 5 SoCs only use the feeder control interrupt
3. Patches adding support for DT and H/W version are in pipeline

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v2:
None

 drivers/crypto/s5p-sss.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index cf149b1..93cddeb 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -592,29 +592,29 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	pdata->ioaddr = devm_ioremap(dev, res->start,
 				     resource_size(res));
 
-	pdata->irq_hash = platform_get_irq_byname(pdev, "hash");
-	if (pdata->irq_hash < 0) {
-		err = pdata->irq_hash;
-		dev_warn(dev, "hash interrupt is not available.\n");
+	pdata->irq_fc = platform_get_irq(pdev, 0);
+	if (pdata->irq_fc < 0) {
+		err = pdata->irq_fc;
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

