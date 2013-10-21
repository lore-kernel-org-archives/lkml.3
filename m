Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872Ab3JUOTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 10:19:23 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11962 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab3JUOTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 10:19:20 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-7b-526537e7ccb8
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, kyungmin.park@samsung.com,
        t.figa@samsung.com, kishon@ti.com, sw0312.kim@samsung.com,
        inki.dae@samsung.com, rahul.sharma@samsung.com, kgene.kim@samsung.com,
        s.nawrocki@samsung.com, thomas.abraham@linaro.org,
        mturquette@linaro.org, Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [RFC 06/12] Revert
 "drm/exynos: add mout_hdmi clock in hdmi driver to change parent"
Date: Mon, 21 Oct 2013 16:18:25 +0200
Message-id: <1382365111-6533-7-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
References: <1382365111-6533-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jAd3n5qlBBh8aBS3mHznHanHl63s2
	i0n3J7BY9C64ymZx4WkPm8XZpjfsFpd3zWGzmHF+H5PF0wkX2SymLDrManH4TTurxYzJL9ks
	1s94zWIxr/0lq8WxGUsYHfg97lzbw+Zxv/s4k0ffllWMHsdvbGfy+LxJLoA1issmJTUnsyy1
	SN8ugStjwump7AWbBSsajvSwNzC+5+ti5OSQEDCReDh9FhuELSZx4d56IJuLQ0hgEaPE4zfL
	mSCcLiaJ1/0NzCBVbEAdx5Z8ZgSxRQQSJX4132UGKWIWOMQksbtlCliRsEC8xPtHE8GKWARU
	JU729TKB2LwC7hIX9l9nhVgnL/H0fh/Yak4BD4lTL9eC1QsB1bz7No9lAiPvAkaGVYyiqQXJ
	BcVJ6blGesWJucWleel6yfm5mxjBgfpMegfjqgaLQ4wCHIxKPLwBLilBQqyJZcWVuYcYJTiY
	lUR4q0xTg4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmy1DhQSSE8sSc1OTS1ILYLJMnFwSjUw
	5n7+2ta994TNdNe/UbtPcD3N4H30cYcq46Tp7oc7fj6f8ae348qtsBz96FNlYloFArXLBMKk
	nzqZskkf832wWYCV8apijvEBvkyTw9FuLtY9ntdj7npp3vG81nDm1dXqCuXNVxUenGGv+3XF
	3jzZg/uK939bvx5xTr4VAgeazeRuzbI3+92ixFKckWioxVxUnAgADTemI1ACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 59956d35a8618235ea715280b49447bb36f2c975.
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index a0e10ae..fcfa23a 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -83,7 +83,6 @@ struct hdmi_resources {
 	struct clk			*sclk_pixel;
 	struct clk			*sclk_hdmiphy;
 	struct clk			*hdmiphy;
-	struct clk			*mout_hdmi;
 	struct regulator_bulk_data	*regul_bulk;
 	int				regul_count;
 };
@@ -1113,7 +1112,7 @@ static void hdmi_v13_mode_apply(struct hdmi_context *hdata)
 	}
 
 	clk_disable_unprepare(hdata->res.sclk_hdmi);
-	clk_set_parent(hdata->res.mout_hdmi, hdata->res.sclk_hdmiphy);
+	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_hdmiphy);
 	clk_prepare_enable(hdata->res.sclk_hdmi);
 
 	/* enable HDMI and timing generator */
@@ -1280,7 +1279,7 @@ static void hdmi_v14_mode_apply(struct hdmi_context *hdata)
 	}
 
 	clk_disable_unprepare(hdata->res.sclk_hdmi);
-	clk_set_parent(hdata->res.mout_hdmi, hdata->res.sclk_hdmiphy);
+	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_hdmiphy);
 	clk_prepare_enable(hdata->res.sclk_hdmi);
 
 	/* enable HDMI and timing generator */
@@ -1306,7 +1305,7 @@ static void hdmiphy_conf_reset(struct hdmi_context *hdata)
 	u32 reg;
 
 	clk_disable_unprepare(hdata->res.sclk_hdmi);
-	clk_set_parent(hdata->res.mout_hdmi, hdata->res.sclk_pixel);
+	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_pixel);
 	clk_prepare_enable(hdata->res.sclk_hdmi);
 
 	/* operation mode */
@@ -1815,13 +1814,8 @@ static int hdmi_resources_init(struct hdmi_context *hdata)
 		DRM_ERROR("failed to get clock 'hdmiphy'\n");
 		goto fail;
 	}
-	res->mout_hdmi = devm_clk_get(dev, "mout_hdmi");
-	if (IS_ERR(res->mout_hdmi)) {
-		DRM_ERROR("failed to get clock 'mout_hdmi'\n");
-		goto fail;
-	}
 
-	clk_set_parent(res->mout_hdmi, res->sclk_pixel);
+	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
 
 	res->regul_bulk = devm_kzalloc(dev, ARRAY_SIZE(supply) *
 		sizeof(res->regul_bulk[0]), GFP_KERNEL);
-- 
1.7.9.5

