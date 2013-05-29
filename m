Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001Ab3E2Ars (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 20:47:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20140 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933208Ab3E2Arn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 20:47:43 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-13-51a550221588
From: Jingoo Han <jg1.han@samsung.com>
To: "'Herbert Xu'" <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, "'Matt Mackall'" <mpm@selenic.com>,
        "'Deepak Saxena'" <dsaxena@plexity.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2] hwrng: use platform_{get,set}_drvdata()
Date: Wed, 29 May 2013 09:47:29 +0900
Message-id: <001801ce5c06$190091f0$4b01b5d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5cBhIWX9brmHKVSUWi8YtAKybhfg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zQ12lgKWBBvtm8Vi0T/7GZNH9Ssbi
	8sJLrBaXd81hs1iwrY/RgdVj2wFVj8ctrcwefVtWMXr0vdzA6PF5k1wAaxSXTUpqTmZZapG+
	XQJXxseetcwFzyQrTty6zNLAeF60i5GTQ0LAROJAeycbhC0mceHeeiCbi0NIYBmjxKwTC1hg
	iq5PfMoKkZjOKLFsVhszhPOLUWL3wzdgVWwCahJfvhxmB7FFBPQk+tY3MoIUMQv0M0qsP3CW
	FSQhLGAtserxVmYQm0VAVeL9/51gDbwClhKznhxghrAFJX5Mvgc2lFlAS2L9zuNMELa8xOY1
	b5khTlKQ2HH2NSPMsmvfVjJD1IhI7HvxDmyxhMA+doljj/YyQSwTkPg2+RDQUA6ghKzEpgNQ
	cyQlDq64wTKBUWwWktWzkKyehWT1LCQrFjCyrGIUTS1ILihOSi8y0StOzC0uzUvXS87P3cQI
	ib0JOxjvHbA+xJgMtH4is5Rocj4wdvNK4g2NzYwsTE1MjY3MLc1IE1YS51VvsQ4UEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwDi/3nfS489eqpac8x64CiVkvXhx9vpc49WLF/1nfhj7P7BJ
	77DE9vlPxdp7bmU1Vq1c5L/pj+iB6m0qr3J5TKN/s/08Pt14eZxKCm+Y94/I6t0RH/6+eZZd
	sVlZIIG7/VLFMt9dS51dtZlvGj7Wa5wq62ITLTQh2kX8/vtZpkfvhqvI3JlkGazEUpyRaKjF
	XFScCAAjj98N0wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV2lgKWBBu+fs1u0T/7GZNH9Ssbi
	8sJLrBaXd81hs1iwrY/RgdVj2wFVj8ctrcwefVtWMXr0vdzA6PF5k1wAa1QDo01GamJKapFC
	al5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0G4lhbLEnFKgUEBicbGS
	vh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bHnrXMBc8kK07cuszSwHhetIuRk0NCwETi+sSn
	rBC2mMSFe+vZuhi5OIQEpjNKLJvVxgzh/GKU2P3wDQtIFZuAmsSXL4fZQWwRAT2JvvWNjCBF
	zAL9jBLrD5wFGyUsYC2x6vFWZhCbRUBV4v3/nWANvAKWErOeHGCGsAUlfky+BzaUWUBLYv3O
	40wQtrzE5jVvmSFOUpDYcfY1I8yya99WMkPUiEjse/GOcQKjwCwko2YhGTULyahZSFoWMLKs
	YhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO7GfSOxhXNVgcYhTgYFTi4Q34uiRQiDWxrLgy
	9xCjBAezkghvquDSQCHelMTKqtSi/Pii0pzU4kOMyUCfTmSWEk3OByadvJJ4Q2MTMyNLIzML
	IxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpgDHjeVz4rVvOXdlvPjeazaQwLS86y
	nXYJVeZY+T8jfdU9lgDuDwc5zgsv6FfLy1XSnnXVkOFeTqrlv6jXwqILyzUmuv5Itt7l8fFr
	T4InQ4qRuOXy1Akpx2NMLma+OK9y7tR34Y0mjD/vuM6rtC4rNmGbHbx7su+8y6U1kXe/v510
	wZvTRDRRiaU4I9FQi7moOBEALqirujADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
so we can directly pass a struct platform_device.

Also, unnecessary dev_set_drvdata() is removed, because the driver core
clears the driver data to NULL after device_release or on probe failure.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- re-based on the latest 'cryptodev' tree

 drivers/char/hw_random/n2-drv.c     |    6 ++----
 drivers/char/hw_random/octeon-rng.c |    4 ++--
 drivers/char/hw_random/omap-rng.c   |    6 +++---
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 20b962e..f9beed5 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -700,7 +700,7 @@ static int n2rng_probe(struct platform_device *op)
 	if (err)
 		goto out_free_units;
 
-	dev_set_drvdata(&op->dev, np);
+	platform_set_drvdata(op, np);
 
 	schedule_delayed_work(&np->work, 0);
 
@@ -721,7 +721,7 @@ out:
 
 static int n2rng_remove(struct platform_device *op)
 {
-	struct n2rng *np = dev_get_drvdata(&op->dev);
+	struct n2rng *np = platform_get_drvdata(op);
 
 	np->flags |= N2RNG_FLAG_SHUTDOWN;
 
@@ -736,8 +736,6 @@ static int n2rng_remove(struct platform_device *op)
 
 	kfree(np);
 
-	dev_set_drvdata(&op->dev, NULL);
-
 	return 0;
 }
 
diff --git a/drivers/char/hw_random/octeon-rng.c b/drivers/char/hw_random/octeon-rng.c
index 1eada56..f2885db 100644
--- a/drivers/char/hw_random/octeon-rng.c
+++ b/drivers/char/hw_random/octeon-rng.c
@@ -96,7 +96,7 @@ static int octeon_rng_probe(struct platform_device *pdev)
 
 	rng->ops = ops;
 
-	dev_set_drvdata(&pdev->dev, &rng->ops);
+	platform_set_drvdata(pdev, &rng->ops);
 	ret = hwrng_register(&rng->ops);
 	if (ret)
 		return -ENOENT;
@@ -108,7 +108,7 @@ static int octeon_rng_probe(struct platform_device *pdev)
 
 static int __exit octeon_rng_remove(struct platform_device *pdev)
 {
-	struct hwrng *rng = dev_get_drvdata(&pdev->dev);
+	struct hwrng *rng = platform_get_drvdata(pdev);
 
 	hwrng_unregister(rng);
 
diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index 749dc16..e5deb99 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -116,7 +116,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	};
 
 	omap_rng_ops.priv = (unsigned long)priv;
-	dev_set_drvdata(&pdev->dev, priv);
+	platform_set_drvdata(pdev, priv);
 
 	priv->mem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!priv->mem_res) {
@@ -129,7 +129,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 		ret = PTR_ERR(priv->base);
 		goto err_ioremap;
 	}
-	dev_set_drvdata(&pdev->dev, priv);
+	platform_set_drvdata(pdev, priv);
 
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_sync(&pdev->dev);
@@ -156,7 +156,7 @@ err_ioremap:
 
 static int __exit omap_rng_remove(struct platform_device *pdev)
 {
-	struct omap_rng_private_data *priv = dev_get_drvdata(&pdev->dev);
+	struct omap_rng_private_data *priv = platform_get_drvdata(pdev);
 
 	hwrng_unregister(&omap_rng_ops);
 
-- 
1.7.10.4


