Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaAOJOS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:14:18 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:22668 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOJOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:14:11 -0500
X-AuditID: cbfee68e-b7f566d000002344-ed-52d6516103fd
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, tomasz.figa@gmail.com,
        Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/8 v4] crypto:s5p-sss: Use platform_get_irq() instead of
 _byname()
Date: Wed, 15 Jan 2014 14:44:22 +0530
Message-id: <1389777262-14978-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42JZI2JSpZsYeC3I4OJZNYu7zw8zWrw8pGkx
	53wLi0X3KxmL+/d+Mllc3jWHzWLG+X1MFou2/We2WLXrD6PF2TmHmBy4PLasvMnksXPWXXaP
	bQdUPfq2rGL0+LxJLoA1issmJTUnsyy1SN8ugStjy9KrzAV3RSrW7etma2DsFOxi5OSQEDCR
	uLf4DRuELSZx4d56IJuLQ0hgKaPE3ZabzDBFLV8vsEMkFjFKdD8/wwTh9DNJzP3bzwRSxSZg
	JnFw0Wp2EFtEwFnid/MaVpAiZoFPjBIN61exgiSEBUIlOh9sANrBwcEioCpx64E3SJhXwFVi
	75YPTCBhCQEFiTmTbEDCnAJuEge+7wEbLwRU8n3PEbDrJAQ2sUucmf0NbBeLgIDEt8mHWCB6
	ZSU2HYA6WlLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECAz/0/+e9e1g
	vHnA+hBjMtC4icxSosn5wPjJK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS1OzU1ILU
	ovii0pzU4kOMTBycUg2Mm+RzhLez7p3nbL6J2aiieMkybtfobZn3chlYjjUZrqpdm/k87dfO
	+qJZX6rXqQgvuvgozd/Z6O4BnU0JW+Vn30kSXXijXl7qcLjUkzhRoU+bN7WuqlrceN1PYqvO
	HokMh7NdM/KD3j7esaOrcfckjto7S962828227ugdEXOksDlVbe0exs4lViKMxINtZiLihMB
	+5oOeJUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPIsWRmVeSWpSXmKPExsVy+t9jAd3EwGtBBn/2SlvcfX6Y0eLlIU2L
	OedbWCy6X8lY3L/3k8ni8q45bBYzzu9jsli07T+zxapdfxgtzs45xOTA5bFl5U0mj52z7rJ7
	bDug6tG3ZRWjx+dNcgGsUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJ
	uam2Si4+AbpumTlANykplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM7Ys
	vcpccFekYt2+brYGxk7BLkZODgkBE4mWrxfYIWwxiQv31rN1MXJxCAksYpTofn6GCcLpZ5KY
	+7efCaSKTcBM4uCi1WAdIgLOEr+b17CCFDELfGKUaFi/ihUkISwQKtH5YAPQKA4OFgFViVsP
	vEHCvAKuEnu3fGACCUsIKEjMmWQDEuYUcJM48H0P2HghoJLve46wTWDkXcDIsIpRNLUguaA4
	KT3XSK84Mbe4NC9dLzk/dxMjOLqeSe9gXNVgcYhRgINRiYf3R/jVICHWxLLiytxDjBIczEoi
	vFI+14KEeFMSK6tSi/Lji0pzUosPMSYD3TSRWUo0OR8Y+Xkl8YbGJuamxqaWJhYmZpakCSuJ
	8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwKhgtPD45rrC5zX3I25cy75f59deqcn9lSuIletV
	e/8Urh/l8kYmLD8M3DUns0xOWyakJLL0xM3T/y5FsEV6f+cMiHv/ZvNXRfGrwtVfjvt9bUi7
	enbqHf4XJq/W7ChmYAqd/kRM/VmWdMsLFQ2L5Lc+s+dY3Xy2u9en/9/3JqOq0hulusIRa5RY
	ijMSDbWYi4oTAa8X39nyAgAA
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
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v3:
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

