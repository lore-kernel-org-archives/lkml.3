Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab3D2Jaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 05:30:46 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25537 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3D2Jap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 05:30:45 -0400
X-AuditID: cbfee68d-b7f016d000007930-dc-517e3dc4b485
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH RESEND 1/2] watchdog: mtx1-wdt: use devm_gpio_request_one()
Date: Mon, 29 Apr 2013 18:30:43 +0900
Message-id: <000901ce44bc$38dcfbf0$aa96f3d0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5EvDaKp5djbsHuRPW7m7qSh3y5wA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zY90jtnWBBg372CzmrF/DZnF54SVW
	i8u75rBZ3Fi3j93i1owXrA6sHtc2i3mcmPGbxaNvyypGj8+b5AJYorhsUlJzMstSi/TtErgy
	Vu16xlzwiL1iyelj7A2MR9i6GDk5JARMJG4dvsgOYYtJXLi3HijOxSEksIxRYv+RKXBFjye1
	MEEkFjFK9Px5ww7h/GKUmPp+FVgVm4CaxJcvh4ESHBwiAvoSbS0aIDXMAl2MEnuf/wFbISzg
	LXF8wx4wm0VAVaJpykkmEJtXwFKiY/oDFghbUOLH5HtgNrOAlsT6nceZIGx5ic1r3jJDXKQg
	sePsa0YQW0RAT2Lt2i2sEDUiEvtevGMEWSwhsItd4vXTiSwQywQkvk0+xAJynISArMSmA1Bz
	JCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7NS9dLzs/dxAiJ
	uN4djLcPWB9iTAZaP5FZSjQ5HxixeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGan
	phakFsUXleakFh9iZOLglGpg5HGMSdzzdV2s5oytFV8jHpzw/trybflX4Yr12wIdkkRPX59+
	STM2pObencLrMdc9Xtw4v6CpNsgz/PvHK533J/q7btS1bt31Q1Bj62FZflY9BaO7a3Kmh63r
	/P+bXdVRZKGQ+9X/MYVTn8Zf2TNT5Owdnso7/ko3W+5wz9VOy1yxIOOub35ljxJLcUaioRZz
	UXEiAEv1bqHOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd0jtnWBBv+uMFnMWb+GzeLywkus
	Fpd3zWGzuLFuH7vFrRkvWB1YPa5tFvM4MeM3i0ffllWMHp83yQWwRDUw2mSkJqakFimk5iXn
	p2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VVSKEvMKQUKBSQWFyvp22Ga
	EBripmsB0xih6xsSBNdjZIAGEtYxZqza9Yy54BF7xZLTx9gbGI+wdTFyckgImEg8ntTCBGGL
	SVy4tx4ozsUhJLCIUaLnzxt2COcXo8TU96vAOtgE1CS+fDkMlODgEBHQl2hr0QCpYRboYpTY
	+/wPO0iNsIC3xPENe8BsFgFViaYpJ8E28ApYSnRMf8ACYQtK/Jh8D8xmFtCSWL/zOBOELS+x
	ec1bZoiLFCR2nH3NCGKLCOhJrF27hRWiRkRi34t3jBMYBWYhGTULyahZSEbNQtKygJFlFaNo
	akFyQXFSeq6hXnFibnFpXrpecn7uJkZwPD+T2sG4ssHiEKMAB6MSD2/A5tpAIdbEsuLK3EOM
	EhzMSiK8KyzrAoV4UxIrq1KL8uOLSnNSiw8xJgN9OpFZSjQ5H5hq8kriDY1NzIwsjcwsjEzM
	zUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBkee4lvpmy2o+VT3hN8lt53qz+EzPGW7Y
	GHgmPLgpPbZLfAWH50n1u78ant7KtfunyBcsnnOig7thb1hFTH5ctuvR3T2zlh5nkE57qP/u
	u0TjhDq3x1s6PPU3t04+eoHHIDP3ve2O77yb7+/m/PD+h+Hyyb+Fj6ZmVzUm7RCcbqjzUFHT
	+vYlJZbijERDLeai4kQA40zAhysDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_gpio_request_one() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/mtx-1_wdt.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/mtx-1_wdt.c b/drivers/watchdog/mtx-1_wdt.c
index 14dab6f..b434111 100644
--- a/drivers/watchdog/mtx-1_wdt.c
+++ b/drivers/watchdog/mtx-1_wdt.c
@@ -209,7 +209,7 @@ static int mtx1_wdt_probe(struct platform_device *pdev)
 	int ret;
 
 	mtx1_wdt_device.gpio = pdev->resource[0].start;
-	ret = gpio_request_one(mtx1_wdt_device.gpio,
+	ret = devm_gpio_request_one(&pdev->dev, mtx1_wdt_device.gpio,
 				GPIOF_OUT_INIT_HIGH, "mtx1-wdt");
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to request gpio");
@@ -241,7 +241,6 @@ static int mtx1_wdt_remove(struct platform_device *pdev)
 		wait_for_completion(&mtx1_wdt_device.stop);
 	}
 
-	gpio_free(mtx1_wdt_device.gpio);
 	misc_deregister(&mtx1_wdt_misc);
 	return 0;
 }
-- 
1.7.2.5


