Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaBGFVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:21:47 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23562 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaBGFVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:21:44 -0500
X-AuditID: cbfee690-b7f266d00000287c-50-52f46d668894
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, Naveen Krishna Ch <ch.naveen@samsung.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 1/9 v6] crypto:s5p-sss: Use platform_get_irq() instead of
 _byname()
Date: Fri, 07 Feb 2014 10:51:25 +0530
Message-id: <1391750485-27225-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
References: <1389095509-14357-2-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkRjct90uQwcNeAYu7zw8zWrw8pGkx
	53wLi0X3KxmL+/d+Mllc3jWHzWLG+X1MFou2/We2ODvnEJMDp8eWlTeZPHbOusvuse2Aqkff
	llWMHp83yQWwRnHZpKTmZJalFunbJXBlXFy0iLngrkjFknN2DYydgl2MnBwSAiYSizY1M0PY
	YhIX7q1n62Lk4hASWMoosWbSfxaYoo+d51ggEtMZJZZvXMII4fQzSdx/9gCsnU3ATOLgotXs
	ILaIgLPE7+Y1rCBFzAK3GSUWHXsLNkpYIFRi55QrQAkODhYBVYnl03lAwrwCrhJnp7cygYQl
	BBQk5kyyAQlzCrhJHPi+hwnEFgIq+b7nCNh1EgLr2CVevl3MCJJgERCQ+Db5EAtEr6zEpgNQ
	30hKHFxxg2UCo/ACRoZVjKKpBckFxUnpRSZ6xYm5xaV56XrJ+bmbGIEhf/rfswk7GO8dsD7E
	mAw0biKzlGhyPjBm8kriDY3NjCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqT
	WnyIkYmDU6qBsWK/67vjBi/ev0q00tu6c9c8w75d/yOTvRxzm6fNk/50iG+tQp1vwJ+eb1d4
	I4OUAn+0Xj6kzFwc3BZ3Jb5AKYopw+2P4/n9K/v7ty9eH6wj2Cq99+rDHSFLJlmGLTK0CTyp
	17d+67+g14vTHV9H3rAOmfnzYkpYnmZE33TWw82rfN6X20YlKrEUZyQaajEXFScCAFM/oBGP	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsVy+t9jQd203C9BBvNmslrcfX6Y0eLlIU2L
	OedbWCy6X8lY3L/3k8ni8q45bBYzzu9jsli07T+zxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8bFRYuYC+6K
	VCw5Z9fA2CnYxcjJISFgIvGx8xwLhC0mceHeerYuRi4OIYHpjBLLNy5hhHD6mSTuP3vADFLF
	JmAmcXDRanYQW0TAWeJ38xpWkCJmgduMEouOvQUbJSwQKrFzyhWgBAcHi4CqxPLpPCBhXgFX
	ibPTW5lAwhICChJzJtmAhDkF3CQOfN/DBGILAZV833OEbQIj7wJGhlWMoqkFyQXFSem5hnrF
	ibnFpXnpesn5uZsYwRH1TGoH48oGi0OMAhyMSjy8J5Z+DhJiTSwrrsw9xCjBwawkwsud8CVI
	iDclsbIqtSg/vqg0J7X4EGMy0E0TmaVEk/OB0Z5XEm9obGJuamxqaWJhYmZJmrCSOO+BVutA
	IYH0xJLU7NTUgtQimC1MHJxSDYxFX20U/wh+njfPjOv8e/3lJnU9j3f+/1PrmP5OP/jfo4j1
	5sfX/50jsr73ep1vxN4Hl+odIw8UTefgv3P7ouYPq7SoM/LrjIO/hoZs/e2m1dd0Q1abJXRH
	tN6ULWFP3UVkrJau2beuM2zi2mVNlZxPNbbJxMVY1H3qfaSV5KlkfCG1NVAh47kSS3FGoqEW
	c1FxIgByV4AI7AIAAA==
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
Changes since v5:
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

