Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967AbaDYKQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:16:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:62989 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaDYKQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:16:39 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-f6-535a3606c86f
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 2/5] iio: exynos_adc: rearrange clock and regulator
 enable/disable calls
Date: Fri, 25 Apr 2014 15:44:44 +0530
Message-id: <1398420888-5506-3-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
References: <1398420888-5506-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42JZI2JSp8tmFhVssGuplMXd54cZLV4e0rQ4
	u+wgm0Xz4vVsFq+O/GCyWDJ5PqvFvCPvWCwu75rDZjHj/D4mi0Xb/jM7cHnMbrjI4rFz1l12
	j/1z17B7LHlziNWjb8sqRo/Pm+QC2KK4bFJSczLLUov07RK4Mh6tdixYLVFx9NBq1gbG1SJd
	jJwcEgImEuvOPWGDsMUkLtxbD2RzcQgJLGWUuNfQDORwgBVtXZAKEZ/OKPFw4idGCKefSeL0
	67Ng3WwCZhIHF61mB2kQEZCVmNmtB1LDLPCXUWLeyy2MIDXCAlESU17fAatnEVCVOPeolQXE
	5hVwkXh9fTkrxDIFiTmTbEDCnAKuEut3H2MFsYWASu5v+cMKMlNCYB+7xN7ld9gh5ghIfJt8
	iAWiV1Zi0wFmiGckJQ6uuMEygVF4ASPDKkbR1ILkguKk9CJTveLE3OLSvHS95PzcTYzASDj9
	79nEHYz3D1gfYkwGGjeRWUo0OR8YSXkl8YbGZkYWpiamxkbmlmakCSuJ86Y/SgoSEkhPLEnN
	Tk0tSC2KLyrNSS0+xMjEwSnVwDhX1/zSbb+5VgeSpqT3Mqa88a8Nb++z5+C9LMh0ovPq/upi
	lvoZYrLzJ4T9OCl/s8Bd6/4sm2lvp8zbfbzNxaZx9x5dlqPJrjPE0xfECyf4HlmZ2PpR/6G4
	9JUvZ0KVLmy9+CFrxkr+m3V57989dXu4zfXWxAaLoifehe/f+K+rUt4slzSxMlmJpTgj0VCL
	uag4EQDzaZfemgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t9jQV02s6hgg4sbBCzuPj/MaPHykKbF
	2WUH2SyaF69ns3h15AeTxZLJ81kt5h15x2JxedccNosZ5/cxWSza9p/ZgctjdsNFFo+ds+6y
	e+yfu4bdY8mbQ6wefVtWMXp83iQXwBbVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhr
	aGlhrqSQl5ibaqvk4hOg65aZA3SakkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwhjHj0WrHgtUSFUcPrWZtYFwt0sXIwSEhYCKxdUFqFyMnkCkmceHeerYuRi4OIYHpjBIP
	J35ihHD6mSROvz7LBlLFJmAmcXDRanaQZhEBWYmZ3XogNcwCfxkl5r3cwghSIywQJTHl9R2w
	ehYBVYlzj1pZQGxeAReJ19eXs0IsVpCYM8kGJMwp4CqxfvcxVhBbCKjk/pY/rBMYeRcwMqxi
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI6zZ9I7GFc1WBxiFOBgVOLhnSAbGSzEmlhWXJl7
	iFGCg1lJhFfWJCpYiDclsbIqtSg/vqg0J7X4EGMy0FETmaVEk/OBKSCvJN7Q2MTc1NjU0sTC
	xMySNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhjt1/Y2SVnUbJUtrd7j8WflwQ+XGZn/
	c1vuqtynZWQhUvTtYP4cz+Qu8UJnYeP5r9w6Mr4uP7V3ycT6Oxx3nB78mLphwYmOeQdPlbjv
	vvfr3hSPdS80ZIpW31S7r1x/0ej4+YUXLRXkXMpb67b8fJHdc32PxvFSVaONS/8GsIqdSkz+
	oj517RQRJZbijERDLeai4kQAPYlpZ/cCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Ch <ch.naveen@samsung.com>

This patch maintains the following order in
probe(), remove(), resume() and suspend() calls

regulator enable, clk prepare enable
...
clk disable unprepare, regulator disable

While at it,
1. enable the regulator before the iio_device_register()
2. handle the return values for enable/disable calls

Change-Id: I764d9d60f72caa7ea6b0609db49a74115574f081
Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
---
This change fixes the comments given by Jonathan regarding the
order of clock and regulator enable/disable calls.
https://lkml.org/lkml/2014/4/23/644

 drivers/iio/adc/exynos_adc.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index affa93f..a2b8b1a 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -316,6 +316,14 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
+	ret = regulator_enable(info->vdd);
+	if (ret)
+		goto err_irq;
+
+	ret = clk_prepare_enable(info->clk);
+	if (ret)
+		goto err_disable_reg;
+
 	info->version = exynos_adc_get_version(pdev);
 
 	platform_set_drvdata(pdev, indio_dev);
@@ -334,13 +342,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 	ret = iio_device_register(indio_dev);
 	if (ret)
-		goto err_irq;
-
-	ret = regulator_enable(info->vdd);
-	if (ret)
-		goto err_iio_dev;
-
-	clk_prepare_enable(info->clk);
+		goto err_disable_clk;
 
 	exynos_adc_hw_init(info);
 
@@ -355,10 +357,11 @@ static int exynos_adc_probe(struct platform_device *pdev)
 err_of_populate:
 	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
-	regulator_disable(info->vdd);
-	clk_disable_unprepare(info->clk);
-err_iio_dev:
 	iio_device_unregister(indio_dev);
+err_disable_clk:
+	clk_disable_unprepare(info->clk);
+err_disable_reg:
+	regulator_disable(info->vdd);
 err_irq:
 	free_irq(info->irq, info);
 	return ret;
@@ -371,9 +374,10 @@ static int exynos_adc_remove(struct platform_device *pdev)
 
 	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
-	regulator_disable(info->vdd);
 	clk_disable_unprepare(info->clk);
+	regulator_disable(info->vdd);
 	writel(0, info->enable_reg);
+
 	iio_device_unregister(indio_dev);
 	free_irq(info->irq, info);
 
@@ -398,8 +402,8 @@ static int exynos_adc_suspend(struct device *dev)
 	}
 
 	clk_disable_unprepare(info->clk);
-	writel(0, info->enable_reg);
 	regulator_disable(info->vdd);
+	writel(0, info->enable_reg);
 
 	return 0;
 }
@@ -410,12 +414,14 @@ static int exynos_adc_resume(struct device *dev)
 	struct exynos_adc *info = iio_priv(indio_dev);
 	int ret;
 
+	writel(1, info->enable_reg);
 	ret = regulator_enable(info->vdd);
 	if (ret)
 		return ret;
 
-	writel(1, info->enable_reg);
-	clk_prepare_enable(info->clk);
+	ret = clk_prepare_enable(info->clk);
+	if (ret)
+		return ret;
 
 	exynos_adc_hw_init(info);
 
-- 
1.7.9.5

