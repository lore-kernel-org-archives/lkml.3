Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaAIE6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 23:58:24 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54532 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaAIE6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 23:58:21 -0500
X-AuditID: cbfee690-b7f266d00000287c-91-52ce2c6ba42b
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/6 v2] crypto:s5p-sss: Use platform_get_irq() instead of
 _byname()
Date: Thu, 09 Jan 2014 10:28:37 +0530
Message-id: <1389243517-13033-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSq5utcy7I4P1BQYu7zw8zWrw8pGkx
	53wLi0X3KxmL+/d+Mllc3jWHzWLG+X1MFou2/We2WLXrD6PF2TmHmBy4PLasvMnksXPWXXaP
	bQdUPfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugSvj/a8L7AXPRSr2vHjM2MA4UbCLkZNDQsBE
	YtHLc4wQtpjEhXvr2boYuTiEBJYySvSuuMHcxcgBVrRzTxREfDqjxJetf1kgnH4midcn57OC
	dLMJmEkcXLSaHcQWEXCW+N28hhWkiFngE6NEw/pVYEXCAqESJ69tZQaxWQRUJVouvmcDsXkF
	XCUu3d7FArFNQWLOJBuQMKeAm8SB73uYQGwhoJLve46AXSchsI1dYvH9e2wQcwQkvk0+BNUr
	K7HpADPEN5ISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJucWleul5yfu4mRmD4n/73bMIO
	xnsHrA8xJgONm8gsJZqcD4yfvJJ4Q2MzIwtTE1NjI3NLM9KElcR51R4lBQkJpCeWpGanphak
	FsUXleakFh9iZOLglGpg9P/J93xj/v9fzcGLC+/tKwjtDDyyo97pQtnFySfXrrk5/ba8/q+M
	qW7u8/k6yu8YMc789sDzeY2a4reKCV5ntytFHFFXK/zZsWr+B45UB70lH/eynlZTvVt/6DLv
	xuTPv17uX6sg/7O2kvMEs3bKtwLHe/oOspEbnbcJHfbdahnll5c2p51LQ4mlOCPRUIu5qDgR
	AFHvV2+VAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jQd1snXNBBn9uslncfX6Y0eLlIU2L
	OedbWCy6X8lY3L/3k8ni8q45bBYzzu9jsli07T+zxapdfxgtzs45xOTA5bFl5U0mj52z7rJ7
	bDug6tG3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJ
	uam2Si4+AbpumTlANykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM97/
	usBe8FykYs+Lx4wNjBMFuxg5OCQETCR27onqYuQEMsUkLtxbz9bFyMUhJDCdUeLL1r8sEE4/
	k8Trk/NZQarYBMwkDi5azQ5iiwg4S/xuXsMKUsQs8IlRomH9KrAiYYFQiZPXtjKD2CwCqhIt
	F9+zgdi8Aq4Sl27vYoHYrCAxZ5INSJhTwE3iwPc9TCC2EFDJ9z1H2CYw8i5gZFjFKJpakFxQ
	nJSea6hXnJhbXJqXrpecn7uJERxdz6R2MK5ssDjEKMDBqMTDu6L4bJAQa2JZcWXuIUYJDmYl
	Ed6/queChHhTEiurUovy44tKc1KLDzEmAx01kVlKNDkfGPl5JfGGxibmpsamliYWJmaWpAkr
	ifMeaLUOFBJITyxJzU5NLUgtgtnCxMEp1cC4Nin06gWRTdnzWp7cUttfXZDm2fLJpTEqRTZ1
	xYYC3YXiiTf+vSjN7klT47v99+Ij049bXi5/cEjh7mu/hr+7tu/UPOfy1Xe9TtcsvrKzS06e
	b5IwfeCwozVS7ffXs34l9+4uirvBN29fRZDwlph7DzaVNO9rTy5z4bYJEH5yNdXZ8PbhuPvi
	SizFGYmGWsxFxYkAyeO/0/ICAAA=
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
Changes since v1:
A typo fixed, from err "pdata->irq_hash;" to "pdata->irq_fc;"

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

