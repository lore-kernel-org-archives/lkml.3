Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220AbaEIHox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:44:53 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45721 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbaEIHnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:43:17 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-4f-536c8714819f
From: Chanwoo Choi <cw00.choi@samsung.com>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rafael.j.wysocki@intel.com, nm@ti.com, jkosina@suse.cz,
        labbe.montjoie@gmail.com, a.kesavan@samsung.com,
        sreekumar.c@samsung.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCHv2 4/5] devfreq: exynos4: Use devm_devfreq_* function using
 device resource management
Date: Fri, 09 May 2014 16:43:10 +0900
Message-id: <1399621391-27228-5-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
In-reply-to: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
References: <1399621391-27228-1-git-send-email-cw00.choi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsWyRsSkQFekPSfYYPskfYvHaxYzWWycsZ7V
	4vqX56wWu+csZrHoXXCVzeJs0xt2i/ULFrJZbHp8jdXi8q45bBafe48wWsw4v4/J4nbjCjaL
	Nz/OMlk8XvGW3eLgwwXMFjvXdbI7CHjsnHWX3WPxnpdMHpuX1Hv0bVnF6HFmwRF2j+M3tjN5
	LL13lNHj8ya5AI4oLpuU1JzMstQifbsEroyz268zF6wTqjg9K7uB8Rx/FyMnh4SAicS79VeZ
	IWwxiQv31rN1MXJxCAksZZT4tnwNG0zR6Xs3WSESixgldv5bzQjhNDFJHLj8nBGkik1AS2L/
	ixtgHSIC5hK7lv4EG8UssI9Z4tv1q6wgCWGBdIlnh76wg9gsAqoS85d+ZAKxeQVcJSavuAF1
	h5zEhz2PwGo4Bdwk1rdNAIsLgdQs64I66Su7xO6GJIg5AhLfJh9i6WLkAIrLSmw6ADVGUuLg
	ihssExiFFzAyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjK7T/57172C8e8D6EGMy0LiJ
	zFKiyfnA6MwriTc0NjOyMDUxNTYytzQjTVhJnPf+w6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xM
	HJxSDYwzJk7K3vtaMFw+zDu8NTzN6t/UlpBtU652z3nzxHSBR/qnDROYL8+dYXVu9Ytl0Rr7
	cvvD9urvVN/Orqy/bn3bZt7LC6RXKV7uqPjkeMnr8ycNdvENfWkn7bYsdPqidveUY8TjZMPZ
	T/w+CK7RmrmJy912J/djtpIpD5RqDQX+rPy2MaRjiegqJZbijERDLeai4kQAiVqZfMQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xgK5Ie06wwZYONYvHaxYzWWycsZ7V
	4vqX56wWu+csZrHoXXCVzeJs0xt2i/ULFrJZbHp8jdXi8q45bBafe48wWsw4v4/J4nbjCjaL
	Nz/OMlk8XvGW3eLgwwXMFjvXdbI7CHjsnHWX3WPxnpdMHpuX1Hv0bVnF6HFmwRF2j+M3tjN5
	LL13lNHj8ya5AI6oBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFsl
	F58AXbfMHKAXlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGENYwZZ7dfZy5Y
	J1RxelZ2A+M5/i5GTg4JAROJ0/duskLYYhIX7q1n62Lk4hASWMQosfPfakYIp4lJ4sDl54wg
	VWwCWhL7X9xgA7FFBMwldi39CdbBLLCPWeLb9atgo4QF0iWeHfrCDmKzCKhKzF/6kQnE5hVw
	lZi84gYzxDo5iQ97HoHVcAq4SaxvmwAWFwKpWdbFNoGRdwEjwypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4Oh9Jr2DcVWDxSFGAQ5GJR7eF1Oyg4VYE8uKK3MPMUpwMCuJ8Eql5wQL8aYk
	VlalFuXHF5XmpBYfYkwGumois5Rocj4wseSVxBsam5gZWRqZG1oYGZuTJqwkznuw1TpQSCA9
	sSQ1OzW1ILUIZgsTB6dUA6PalJJbaZK+8ktfHu7h3e76vdM60vjgJ4PspV27bb/GGHE+kt7s
	/XZ1ZCWrSa5V2u151XcfSXySmxl2tI597YW3js2TlnFULjyZsmOfjeRmlRNyzYmXrHOv6Sfk
	35cpzVhzzvnQSj4GtxMy1ySTdv2J3/Xi493vvHXV67pELtg6mfvKlm6M/aLEUpyRaKjFXFSc
	CAC1boVKIgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses devm_devfreq_add_device()/devm_devfreq_register_opp_notifier()
to control automatically the resource of devfreq.

Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
---
 drivers/devfreq/exynos/exynos4_bus.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/devfreq/exynos/exynos4_bus.c b/drivers/devfreq/exynos/exynos4_bus.c
index d257f1f..bebb0a4 100644
--- a/drivers/devfreq/exynos/exynos4_bus.c
+++ b/drivers/devfreq/exynos/exynos4_bus.c
@@ -979,7 +979,7 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
-	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
+	data->devfreq = devm_devfreq_add_device(dev, &exynos4_devfreq_profile,
 					   "simple_ondemand", NULL);
 	if (IS_ERR(data->devfreq))
 		return PTR_ERR(data->devfreq);
@@ -991,27 +991,20 @@ static int exynos4_busfreq_probe(struct platform_device *pdev)
 	busfreq_mon_reset(ppmu_data);
 
 	/* Register opp_notifier for Exynos4 busfreq */
-	err = devfreq_register_opp_notifier(dev, data->devfreq);
+	err = devm_devfreq_register_opp_notifier(dev, data->devfreq);
 	if (err < 0) {
 		dev_err(dev, "Failed to register opp notifier\n");
-		goto err_notifier_opp;
+		return err;
 	}
 
 	/* Register pm_notifier for Exynos4 busfreq */
 	err = register_pm_notifier(&data->pm_notifier);
 	if (err) {
 		dev_err(dev, "Failed to setup pm notifier\n");
-		goto err_notifier_pm;
+		return err;
 	}
 
 	return 0;
-
-err_notifier_pm:
-	devfreq_unregister_opp_notifier(dev, data->devfreq);
-err_notifier_opp:
-	devfreq_remove_device(data->devfreq);
-
-	return err;
 }
 
 static int exynos4_busfreq_remove(struct platform_device *pdev)
@@ -1020,10 +1013,6 @@ static int exynos4_busfreq_remove(struct platform_device *pdev)
 
 	/* Unregister all of notifier chain */
 	unregister_pm_notifier(&data->pm_notifier);
-	devfreq_unregister_opp_notifier(data->dev, data->devfreq);
-
-	/* Remove devfreq instance */
-	devfreq_remove_device(data->devfreq);
 
 	return 0;
 }
-- 
1.8.0

