Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaEONN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:13:59 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33854 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaEONN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:13:57 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-01-5374bd932f39
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: a.hajda@samsung.com, t.stanislaws@samsung.com, thierry.reding@gmail.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, kishon@ti.com,
        kyungmin.park@samsung.com, robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, joshi@samsung.com, r.sh.open@gmail.com,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: [PATCH v4 2/3] drm: exynos: hdmi: use hdmiphy as PHY
Date: Thu, 15 May 2014 18:40:53 +0530
Message-id: <1400159454-31107-3-git-send-email-rahul.sharma@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400159454-31107-1-git-send-email-rahul.sharma@samsung.com>
References: <1400159454-31107-1-git-send-email-rahul.sharma@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsWyRsSkSnfy3pJggxNHeSxurTvHajH/CJC4
	8vU9m8WBPzsYLb7v+sJu0bvgKpvFhac9bBZnm96wW1zeNYfNYsb5fUwWC1/EW0xZdJjVonXv
	EXaLeZ93MlnMa3/JavFz1zwWBwGPnbPusntsWtXJ5nHn2h42j/vdx5k8+rasYvQ4fmM7k8fn
	TXIB7FFcNimpOZllqUX6dglcGetvTWApWC5UcXHjNNYGxi38XYycHBICJhKXN61lgbDFJC7c
	W8/WxcjFISSwlFFiy+ouxi5GDrCi273WEPFFjBLTF79kh3DamSQunVvCDNLNJqArMfvgM0YQ
	W0QgTeLbgRZWkCJmgTNMEs+u7GcFSQgL2Eoc713GDmKzCKhK/Fz3BMzmFfCQ6P6whAlim4LE
	nEk2IGFOAU+JXWdugs0XAip5e3wmM8hMCYGP7BJTf65lgpgjIPFt8iEWiF5ZiU0HmCG+kZQ4
	uOIGywRG4QWMDKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxAmPq9L9nE3Yw3jtgfYgxGWjc
	RGYp0eR8YEzmlcQbGpsZWZiamBobmVuakSasJM6r9igpSEggPbEkNTs1tSC1KL6oNCe1+BAj
	EwenVANjwMzDwRfbdZOMzFrmnlqzO//in/6K0rY9Seuc/bjD/NvbhTs9Q1ZFinXE8gdoMi3R
	ra/a/laRyU+zma1Myu/OI6bNYuc3r9tc6ymWatT2szOqr9r2cHnR9sWx/MeTNmVpWe12me4R
	m6YTff/GHpHy1b5edpYni8XFVisu3Xrt3L/UwjfSlUosxRmJhlrMRcWJAG5s/1W/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xgO7kvSXBBge7GS1urTvHajH/CJC4
	8vU9m8WBPzsYLb7v+sJu0bvgKpvFhac9bBZnm96wW1zeNYfNYsb5fUwWC1/EW0xZdJjVonXv
	EXaLeZ93MlnMa3/JavFz1zwWBwGPnbPusntsWtXJ5nHn2h42j/vdx5k8+rasYvQ4fmM7k8fn
	TXIB7FENjDYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5
	QNcrKZQl5pQChQISi4uV9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDPW35rAUrBcqOLixmms
	DYxb+LsYOTgkBEwkbvdadzFyApliEhfurWfrYuTiEBJYxCgxffFLdginnUni0rklzCBVbAK6
	ErMPPmMEsUUE0iS+HWhhBSliFjjDJPHsyn5WkISwgK3E8d5l7CA2i4CqxM91T8BsXgEPie4P
	S5ggNitIzJlkAxLmFPCU2HXmJth8IaCSt8dnMk9g5F3AyLCKUTS1ILmgOCk911CvODG3uDQv
	XS85P3cTIzhin0ntYFzZYHGIUYCDUYmHl2FycbAQa2JZcWXuIUYJDmYlEd7G6SXBQrwpiZVV
	qUX58UWlOanFhxiTgY6ayCwlmpwPTCZ5JfGGxibmpsamliYWJmaWpAkrifMeaLUOFBJITyxJ
	zU5NLUgtgtnCxMEp1cBo5PpV/DYvz4nCKYfv5GyQTZt2lMcpmH3p2UOX3FJO3ZKb7nAtu2+t
	/2S75T8bI7dcj1p78vzCJzUNT65Oyn8788Wha4buS/i9HnQH/LxU0PfccPHquO/aJgce6H0J
	M9jCNpFRd3ng46i3/0OUU39c+jvp5nY9/rrK87efb/jlOXfxTZnlVXYfxZRYijMSDbWYi4oT
	AaBs8E8cAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomasz Stanislawski <t.stanislaws@samsung.com>

The HDMIPHY (physical interface) is controlled by a single
bit in a power controller's regiter. It was implemented
as clock. It was a simple but effective hack.

This patch makes HDMI driver to control HDMIPHY via PHY interface.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Rahul Sharma <Rahul.Sharma@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 9a6d652..ef1cdd0 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -36,6 +36,7 @@
 #include <linux/i2c.h>
 #include <linux/of_gpio.h>
 #include <linux/hdmi.h>
+#include <linux/phy/phy.h>
 
 #include <drm/exynos_drm.h>
 
@@ -74,8 +75,8 @@ struct hdmi_resources {
 	struct clk			*sclk_hdmi;
 	struct clk			*sclk_pixel;
 	struct clk			*sclk_hdmiphy;
-	struct clk			*hdmiphy;
 	struct clk			*mout_hdmi;
+	struct phy			*hdmiphy;
 	struct regulator_bulk_data	*regul_bulk;
 	int				regul_count;
 };
@@ -1854,7 +1855,7 @@ static void hdmi_poweron(struct exynos_drm_display *display)
 	if (regulator_bulk_enable(res->regul_count, res->regul_bulk))
 		DRM_DEBUG_KMS("failed to enable regulator bulk\n");
 
-	clk_prepare_enable(res->hdmiphy);
+	phy_power_on(res->hdmiphy);
 	clk_prepare_enable(res->hdmi);
 	clk_prepare_enable(res->sclk_hdmi);
 
@@ -1881,7 +1882,7 @@ static void hdmi_poweroff(struct exynos_drm_display *display)
 
 	clk_disable_unprepare(res->sclk_hdmi);
 	clk_disable_unprepare(res->hdmi);
-	clk_disable_unprepare(res->hdmiphy);
+	phy_power_off(res->hdmiphy);
 	regulator_bulk_disable(res->regul_count, res->regul_bulk);
 
 	pm_runtime_put_sync(hdata->dev);
@@ -1977,9 +1978,9 @@ static int hdmi_resources_init(struct hdmi_context *hdata)
 		DRM_ERROR("failed to get clock 'sclk_hdmiphy'\n");
 		goto fail;
 	}
-	res->hdmiphy = devm_clk_get(dev, "hdmiphy");
+	res->hdmiphy = devm_phy_get(dev, "hdmiphy");
 	if (IS_ERR(res->hdmiphy)) {
-		DRM_ERROR("failed to get clock 'hdmiphy'\n");
+		DRM_ERROR("failed to get phy 'hdmiphy'\n");
 		goto fail;
 	}
 	res->mout_hdmi = devm_clk_get(dev, "mout_hdmi");
-- 
1.7.9.5

