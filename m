Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaENTSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:18:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:35989 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbaENTS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:18:26 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-ea-5373c18028dc
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: a.hajda@samsung.com, t.stanislaws@samsung.com, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, kishon@ti.com, kyungmin.park@samsung.com,
        robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, joshi@samsung.com,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: [PATCH v3 2/3] drm: exynos: hdmi: use hdmiphy as PHY
Date: Thu, 15 May 2014 00:47:22 +0530
Message-id: <1400095043-685-3-git-send-email-rahul.sharma@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMIsWRmVeSWpSXmKPExsWyRsSkRrfhYHGwwY6DOha31p1jtZh/BEhc
	+fqezeLAnx2MFt93fWG36F1wlc3iwtMeNouzTW/YLS7vmsNmMeP8PiaLKYsOs1q07j3CbjHv
	804mi3ntL1kd+Dx2zrrL7rFpVSebx51re9g87ncfZ/Lo27KK0eP4je1MHp83yQWwR3HZpKTm
	ZJalFunbJXBlrL81gaVguVDFxY3TWBsYt/B3MXJySAiYSEy4/Z0dwhaTuHBvPVsXIxeHkMBS
	RonHUy6zwRQdmdHKDpGYziixc/I6ZginnUnizqoNjCBVbAK6ErMPPgOzRQTSJL4daGEFKWIW
	mM0ksfHFa7BRwgK2EttffWcCsVkEVCWmzzvOCmLzCrhJvLz1CqiZA2idgsScSTYgYU4Bd4mG
	SxuZQWwhoJIVLfNYIS56xC4x5bANxBgBiW+TD7FAtMpKbDrADFEiKXFwxQ2WCYzCCxgZVjGK
	phYkFxQnpReZ6BUn5haX5qXrJefnbmIERtDpf88m7GC8d8D6EGMy0LiJzFKiyfnACMwriTc0
	NjOyMDUxNTYytzQjTVhJnFftUVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkYzm1sfeGKO
	MnnMMH7tXXe+Vjf78xWxpTbXXTRfHLjPfnzlyy3sEV2/JmvvOex2JkOyRST8nPF306nuH1Ou
	sAQ9X645g71xknKKdtTHv9aXTgSKFRQqK15x/MK1YP0c2/yVjtmtb1qWNUfOYWwTcLG44537
	kOG92mJuFXkbC+GUnP3Tji/enqjEUpyRaKjFXFScCAD3gwgvtgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoG7DweJggxPXFCxurTvHajH/CJC4
	8vU9m8WBPzsYLb7v+sJu0bvgKpvFhac9bBZnm96wW1zeNYfNYsb5fUwWUxYdZrVo3XuE3WLe
	551MFvPaX7I68HnsnHWX3WPTqk42jzvX9rB53O8+zuTRt2UVo8fxG9uZPD5vkgtgj2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlpJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmLH+1gSWguVCFRc3TmNtYNzC38XIySEh
	YCJxZEYrO4QtJnHh3nq2LkYuDiGB6YwSOyevY4Zw2pkk7qzawAhSxSagKzH74DMwW0QgTeLb
	gRZWkCJmgdlMEhtfvGYDSQgL2Epsf/WdCcRmEVCVmD7vOCuIzSvgJvHy1iugZg6gdQoScybZ
	gIQ5BdwlGi5tZAaxhYBKVrTMY53AyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnCE
	PpPawbiyweIQowAHoxIPL8Pk4mAh1sSy4srcQ4wSHMxKIrxJe4FCvCmJlVWpRfnxRaU5qcWH
	GJOBjprILCWanA9MHnkl8YbGJuamxqaWJhYmZpakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLE
	wSnVwNi6/iH7Rv5DMX4nrpYbf3E7cPfb9rVOQnmV28+l3i1h5JPQei/338WvfG/7RUG7tfKn
	TdgCnd7GXlNJMbn8X9fZ4NPaO9n3dry+waYkwOjStXi+ROvrpoOz65u9/1v/s+ZnS28yu/4s
	UVJC9kT41gW/8n5U/2p/GJd+UWcBa6XxsZn75I/OC1diKc5INNRiLipOBADghx/pFAMAAA==
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

