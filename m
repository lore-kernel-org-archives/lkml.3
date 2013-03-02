Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3CBNZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:25:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:12955 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3CBNZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:25:28 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-08-5131fdc75965
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        kishon@ti.com
Subject: [PATCH v2 05/10] usb: dwc3: exynos: Enable runtime power management
Date: Sat, 02 Mar 2013 18:53:06 +0530
Message-id: <1362230590-20960-6-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
References: <1362230590-20960-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkWvf4X8NAg/dtghYH79dbNC9ez2bR
	u+Aqm8WFpz1sFpd3zWGzmL2kn8Vixvl9TBaLlrUyWzSfOMXswOkx72Sgx/65a9g9+rasYvQ4
	fmM7k8fnTXIBrFFcNimpOZllqUX6dglcGbeePWUtOM1bMfHxdeYGxqPcXYycHBICJhKHn7Qw
	Q9hiEhfurWfrYuTiEBJYyihx5uwrJpiic8+vQCWmM0rMP78aypnCJHH98DM2kCo2AV2Jpre7
	GEFsEQFZicNXfjODFDELXGKUWLFiCwtIQljAR6L92F0wm0VAVaJnxXyw3bwCHhIn565ih1in
	IPHm9jOwOKeAp8T065tZQWwhoJo/945D1Sxjl3j3VQBijoDEt8mHgGZyAMVlJTYdgHpHUuLg
	ihssExiFFzAyrGIUTS1ILihOSi8y0itOzC0uzUvXS87P3cQIDPzT/5717WC8ecD6EGMy0LiJ
	zFKiyfnAyMkriTc0NjE3NTY1M7K0tDQlTVhJnFf+kkygkEB6YklqdmpqQWpRfFFpTmrxIUYm
	Dk6pBsZ232r9RgblOKbLETx7n8gt8sm/63jKVMDm6s8mrRkJq/etXzDf5/I0q+uyvAoLtXod
	r3pdN0t9fXvPTM/uh1te/y/Zf0lfsedTt+sfmx/cHgXWZxPPW6S8ePPg3+YLi9R0TVlYFczD
	L19aefxDz0kx82dCGwuz//Plfrp0dev8hPp/d7V1vVuUWIozEg21mIuKEwFQJBS1kgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jQd3jfw0DDb5O5rA4eL/eonnxejaL
	3gVX2SwuPO1hs7i8aw6bxewl/SwWM87vY7JYtKyV2aL5xClmB06PeScDPfbPXcPu0bdlFaPH
	8RvbmTw+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hx69lT1oLT
	vBUTH19nbmA8yt3FyMkhIWAice75FTYIW0ziwr31QDYXh5DAdEaJ+edXQzlTmCSuH34GVsUm
	oCvR9HYXI4gtIiArcfjKb2aQImaBS4wSK1ZsYQFJCAv4SLQfuwtmswioSvSsmM8MYvMKeEic
	nLuKHWKdgsSb28/A4pwCnhLTr29mBbGFgGr+3DvOPoGRdwEjwypG0dSC5ILipPRcI73ixNzi
	0rx0veT83E2M4Mh6Jr2DcVWDxSFGAQ5GJR7egI8GgUKsiWXFlbmHGCU4mJVEeM9fNQwU4k1J
	rKxKLcqPLyrNSS0+xJgMdNVEZinR5Hxg1OeVxBsam5ibGptamliYmFmSJqwkzst46kmAkEB6
	YklqdmpqQWoRzBYmDk6pBkYJIz+jJ3+dLPi3TwzzMfCa2M7sE6f/3eGoZEuzLMeZ1GmhazPX
	rxNSSdqq4F25eOLOmyVnp8WE57074xXAZnPDZTZbqOMuMZ7pnfv5BKp2RuxN7wnrzNLO5tsh
	/JXltrtSgt+rVxs5lzOcnxQnJ3dls2BSt7WvS8/dKrNYjzCDhqw1DQvtlFiKMxINtZiLihMB
	gBfU5fACAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling runtime power management on dwc3-exynos
letting dwc3 controller to be autosuspended on exynos
platform when not in use.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index e6771d9..28b5f8a 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -19,6 +19,7 @@
 #include <linux/platform_data/dwc3-exynos.h>
 #include <linux/dma-mapping.h>
 #include <linux/clk.h>
+#include <linux/pm_runtime.h>
 #include <linux/usb/otg.h>
 #include <linux/usb/nop-usb-xceiv.h>
 #include <linux/of.h>
@@ -143,6 +144,10 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 	exynos->dev	= dev;
 	exynos->clk	= clk;
 
+	pm_runtime_enable(dev);
+	pm_runtime_get_sync(dev);
+	pm_runtime_forbid(dev);
+
 	clk_enable(exynos->clk);
 
 	ret = platform_device_add_resources(dwc3, pdev->resource,
@@ -158,10 +163,14 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
+	pm_runtime_put_sync(dev);
+	pm_runtime_allow(dev);
+
 	return 0;
 
 err2:
 	clk_disable(clk);
+	pm_runtime_disable(dev);
 err1:
 	platform_device_put(dwc3);
 
@@ -172,6 +181,10 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 
+	if (!pm_runtime_suspended(&pdev->dev))
+		pm_runtime_put(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+
 	platform_device_unregister(exynos->dwc3);
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
-- 
1.7.6.5

