Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607AbaB0FGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 00:06:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:17935 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaB0FGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 00:06:35 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-0d-530ec7d7fba0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Rubini'" <rubini@gnudd.com>,
        "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
In-reply-to: <003e01cf3378$c9f54420$5ddfcc60$%han@samsung.com>
Subject: [PATCH 4/5] hwrng: nomadik - Use devm_*() functions
Date: Thu, 27 Feb 2014 14:06:31 +0900
Message-id: <004101cf3379$ada38d30$08eaa790$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8zeMUulUPjKSZTQeuQ54WfZho3FgAAJyJg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zY93rx/mCDX5v1LDofiVjcXnhJVaL
	KX+WM1lc3jWHzeL3yWQHVo+trQdYPbYdUPW4c20Pm0ffllWMHp83yQWwRnHZpKTmZJalFunb
	JXBlnLyym6XgJ0/FyvermRsYT3J1MXJwSAiYSExZE9nFyAlkiklcuLeerYuRi0NIYBmjxOGp
	55kgEiYSvRs3QCUWMUo83HGKGSQhJPCbUWLFkywQm01ATeLLl8PsILaIgJ5E3/pGRpAGZoFZ
	jBIdR/6wQzTYSjybtIQNxOYUsJOYMGEdC4gtLGAjMXPTJlaQi1gEVCV2/YsHCfMClc85/JYJ
	whaU+DH5Hlg5s4CWxOZtTawQtrzE5jVvmSGeUZd49FcX4gQjiVPvjjNClIhI7HvxDuwcCYFr
	7BKdS2aB9bIICEh8m3yIBaJXVmLTAWaIfyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIU
	TS1ILihOSi8y1StOzC0uzUvXS87P3cQIidCJOxjvH7A+xJgMtH4is5Rocj4wwvNK4g2NzYws
	TE1MjY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgXHHp+3z42/beB01
	1TJrCmcrmXLx+oUNXJd2Tq9nnT7nNK+jUfzMTTXXzrt9rXFvsHY1CT3KVmKseaZmclRq2Jvb
	X/fPPvO48ceqG7uSynOuPNkSblU3r61d2eXOv8uc857wrtLSnPb7uZztnC0iJy2PZXL802nf
	E/ne4V5ptUPsBInIFTz/NhcpsRRnJBpqMRcVJwIAw0qS9uYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jAd3rx/mCDZaeUbHofiVjcXnhJVaL
	KX+WM1lc3jWHzeL3yWQHVo+trQdYPbYdUPW4c20Pm0ffllWMHp83yQWwRjUw2mSkJqakFimk
	5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYArVZSKEvMKQUKBSQWFyvp
	22GaEBripmsB0xih6xsSBNdjZIAGEtYxZpy8spul4CdPxcr3q5kbGE9ydTFyckgImEj0btzA
	BmGLSVy4tx7I5uIQEljEKPFwxylmkISQwG9GiRVPskBsNgE1iS9fDrOD2CICehJ96xsZQRqY
	BWYxSnQc+cMO0WAr8WzSErCpnAJ2EhMmrGMBsYUFbCRmbtrE2sXIwcEioCqx6188SJgXqHzO
	4bdMELagxI/J98DKmQW0JDZva2KFsOUlNq95ywzSKiGgLvHory7ECUYSp94dZ4QoEZHY9+Id
	4wRGoVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iRGcAJ5J7WBc
	2WBxiFGAg1GJh1eBjS9YiDWxrLgy9xCjBAezkgjvIRegEG9KYmVValF+fFFpTmrxIcZkoD8n
	MkuJJucDk1NeSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KLYLYwcXBKNTCW
	/VN4vpnj8B5Xy7Kzk3XPXE1OWl866YVSJW+0MHNnF5/dlzYf91+esYeb0mY3M86quxzk8kDv
	4L9uX++X8d+rX6a23F6pXj6fmWtB27Gygx43PDkdA5rVdHmLbmxvDa82YdrF8WSmgZ79Vbsn
	RjNv3amM6ZYV4W0KM9bkLvmieGiK8NS0U0osxRmJhlrMRcWJAP25dblEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/char/hw_random/nomadik-rng.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/nomadik-rng.c b/drivers/char/hw_random/nomadik-rng.c
index 00e9d2d..9c85815 100644
--- a/drivers/char/hw_random/nomadik-rng.c
+++ b/drivers/char/hw_random/nomadik-rng.c
@@ -43,7 +43,7 @@ static int nmk_rng_probe(struct amba_device *dev, const struct amba_id *id)
 	void __iomem *base;
 	int ret;
 
-	rng_clk = clk_get(&dev->dev, NULL);
+	rng_clk = devm_clk_get(&dev->dev, NULL);
 	if (IS_ERR(rng_clk)) {
 		dev_err(&dev->dev, "could not get rng clock\n");
 		ret = PTR_ERR(rng_clk);
@@ -56,33 +56,28 @@ static int nmk_rng_probe(struct amba_device *dev, const struct amba_id *id)
 	if (ret)
 		goto out_clk;
 	ret = -ENOMEM;
-	base = ioremap(dev->res.start, resource_size(&dev->res));
+	base = devm_ioremap(&dev->dev, dev->res.start,
+			    resource_size(&dev->res));
 	if (!base)
 		goto out_release;
 	nmk_rng.priv = (unsigned long)base;
 	ret = hwrng_register(&nmk_rng);
 	if (ret)
-		goto out_unmap;
+		goto out_release;
 	return 0;
 
-out_unmap:
-	iounmap(base);
 out_release:
 	amba_release_regions(dev);
 out_clk:
 	clk_disable(rng_clk);
-	clk_put(rng_clk);
 	return ret;
 }
 
 static int nmk_rng_remove(struct amba_device *dev)
 {
-	void __iomem *base = (void __iomem *)nmk_rng.priv;
 	hwrng_unregister(&nmk_rng);
-	iounmap(base);
 	amba_release_regions(dev);
 	clk_disable(rng_clk);
-	clk_put(rng_clk);
 	return 0;
 }
 
-- 
1.7.10.4


