Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaDZLmp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 07:42:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57122 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbaDZLjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 07:39:42 -0400
X-AuditID: cbfee68d-b7f4e6d000004845-5c-535b9afc9757
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de, cpgs@samsung.com,
        grundler@chromium.org, jic23@kernel.org,
        Naveen Krishna Ch <ch.naveen@samsung.com>
Subject: [PATCH 1/5 v2] iio: exynos_adc: use indio_dev->dev structure to handle
 child nodes
Date: Sat, 26 Apr 2014 17:07:52 +0530
Message-id: <1398512276-4105-2-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
References: <1398512276-4105-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsWyRsSkTvfvrOhgg1d72SzuPj/MaPHykKbF
	2WUH2SyaF69ns3h15AeTxYOmVUwWSybPZ7WYd+Qdi8XlXXPYLGac38dksWjbf2YHbo/ZDRdZ
	PHbOusvusWlVJ5vH/rlr2D2WvDnE6tG3ZRWjx+dNcgHsUVw2Kak5mWWpRfp2CVwZXa3f2Qo2
	81ecWbyavYFxIm8XIyeHhICJRMPuVcwQtpjEhXvr2boYuTiEBJYySlw5cZcJpujDy9ksEInp
	jBL/p75hhXD6mSSWn/gFVsUmYCZxcNFq9i5GDg4RAVmJmd16IDXMIDUNTy8ygsSFBWIlTh9m
	BSlnEVCV6OxYCtbKK+Ai8XX6GWaQEgkBBYk5k2xAwpwCrhITF10FKxECKnk78TU7yEgJgVPs
	El2/3rFBzBGQ+Db5EAtEr6zEpgNQz0hKHFxxg2UCo/ACRoZVjKKpBckFxUnpRYZ6xYm5xaV5
	6XrJ+bmbGIHxcfrfs94djLcPWB9iTAYaN5FZSjQ5HxhfeSXxhsZmRhamJqbGRuaWZqQJK4nz
	Jj1MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAeKhHYd+66So/zl2b3Zs68YGpcq5trPjU
	V4dfOnDYbZK+ebDgwcXCb0yKXkl8H7YciPy2bnPVF98fC6Wybv4tSBewOVOkkmQcfuqQh/GJ
	ze2/5onZH/vsKS+tf8iYs/ef33umbH11ldm6Tjn/l3/Y++zw1j+bTucd6jnmEySvb/Y4J044
	13z7ZiWW4oxEQy3mouJEAAmLndOlAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsVy+t9jQd0/s6KDDU7NsrK4+/wwo8XLQ5oW
	Z5cdZLNoXryezeLVkR9MFg+aVjFZLJk8n9Vi3pF3LBaXd81hs5hxfh+TxaJt/5kduD1mN1xk
	8dg56y67x6ZVnWwe++euYfdY8uYQq0ffllWMHp83yQWwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHamkUJaYUwoUCkgsLlbSt8M0ITTETdcC
	pjFC1zckCK7HyAANJKxhzOhq/c5WsJm/4szi1ewNjBN5uxg5OSQETCQ+vJzNAmGLSVy4t56t
	i5GLQ0hgOqPE/6lvWCGcfiaJ5Sd+MYFUsQmYSRxctJq9i5GDQ0RAVmJmtx5IDTNITcPTi4wg
	cWGBWInTh1lBylkEVCU6O5aCtfIKuEh8nX6GGaREQkBBYs4kG5Awp4CrxMRFV8FKhIBK3k58
	zT6BkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODoeya1g3Flg8UhRgEORiUe3h05
	UcFCrIllxZW5hxglOJiVRHgXpUQHC/GmJFZWpRblxxeV5qQWH2JMBjpqIrOUaHI+MDHklcQb
	GpuYmxqbWppYmJhZkiasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVANjSk1E7vL31XffK/4o
	DXkhVvqdN/Oics0SRocT2tfOWL/68Ub66OSeWVGMF+b5TdK5/J1r95yWR+4fcvc2Tt14s3Xf
	rPKZZX7v9OyMu+X8+v3KREQfn+ks6apomfNhS/i7zctDhb9p17SIV81Ke/dnaTnDSseiHke2
	CaYsa7aa5UbvWnvx449GJZbijERDLeai4kQAKl1uEgIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Naveen Krishna Ch <ch.naveen@samsung.com>

Using pdev->dev with device_for_each_child() would iterate over all
of the children of the platform device and delete them.
Thus, causing crashes during module unload.

We should be using the indio_dev->dev structure for
registering/unregistering child nodes.

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
Reported-by: Doug Anderson <dianders@chromium.org>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Tested-by: Doug Anderson <dianders@chromium.org>
---
This change was tested on top of 
   https://lkml.org/lkml/2014/4/21/481 from Doug.

 drivers/iio/adc/exynos_adc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index d25b262..affa93f 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -344,7 +344,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 	exynos_adc_hw_init(info);
 
-	ret = of_platform_populate(np, exynos_adc_match, NULL, &pdev->dev);
+	ret = of_platform_populate(np, exynos_adc_match, NULL, &indio_dev->dev);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed adding child nodes\n");
 		goto err_of_populate;
@@ -353,7 +353,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	return 0;
 
 err_of_populate:
-	device_for_each_child(&pdev->dev, NULL,
+	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
 	regulator_disable(info->vdd);
 	clk_disable_unprepare(info->clk);
@@ -369,7 +369,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct exynos_adc *info = iio_priv(indio_dev);
 
-	device_for_each_child(&pdev->dev, NULL,
+	device_for_each_child(&indio_dev->dev, NULL,
 				exynos_adc_remove_devices);
 	regulator_disable(info->vdd);
 	clk_disable_unprepare(info->clk);
-- 
1.7.9.5

