Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaDDOzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:55:01 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:12859 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbaDDOy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:54:58 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-38-533ec7c1c87d
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: t.figa@samsung.com, mturquette@linaro.org, kgene.kim@samsung.com,
        inki.dae@samsung.com, sw0312.kim@samsung.com,
        kyungmin.park@samsung.com, airlied@linux.ie, rob.herring@calxeda.com,
        sylvester.nawrocki@gmail.com, a.hajda@samsung.com, kishon@ti.com,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: [PATCH 4/4] Revert
 "drm/exynos: add mout_hdmi clock in hdmi driver to change parent"
Date: Fri, 04 Apr 2014 16:53:21 +0200
Message-id: <1396623201-26000-5-git-send-email-t.stanislaws@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
References: <1396623201-26000-1-git-send-email-t.stanislaws@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t9jQd2Dx+2CDS4tEbe4te4cq0XvuZNM
	FvOPAFlXvr5ns5h0fwKLRe+Cq2wWF572sFmcbXrDbrHp8TVWi8u75rBZzDi/j8ni6YSLbBaH
	Vxxgspgx+SWbxbzPO5ks1s94zWIxr/0lq4Ogx4LPV9g9ds66y+5x59oeNo/t3x6wetzvPs7k
	sXlJvUffllWMHsdvbGfy+LxJLoAzissmJTUnsyy1SN8ugSujbRJPwRfBiqfvNjE2MK7k72Lk
	5JAQMJGYd3kfO4QtJnHh3nq2LkYuDiGB6YwSXZu3M0E4XUwSU5sfgVWxAXUcW/KZESQhIrCK
	UWLi/6fsIA6zwCYmiZ2N3SwgVcIC8RK3P8xjA7FZBFQlDn6ayghi8wp4SGy6/5kRYp+iRPez
	CWA1nAKeEr1LvjOD2EJANd1rFrBMYORdwMiwilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4
	xJ9J7WBc2WBxiFGAg1GJh7djh12wEGtiWXFl7iFGCQ5mJRHeuglAId6UxMqq1KL8+KLSnNTi
	Q4zSHCxK4rwHWq0DhQTSE0tSs1NTC1KLYLJMHJxSDYw9a0yNH/xctf89W5/z7zfGM1al9lVd
	231mm0br4ezL59fukpJj/Pwh4jrrgpk/Jjm5rTXQ6Gu4O4MrWfm+aWBC+hRhhqv2r2ebnvwf
	9j1J758mz52bFx5t8dLVsnwu+ZWhfvvaNep8GhJN+/eI8zjLrS/cyj3rzD4pn8MO69a+OWU7
	9UrAxfelSizFGYmGWsxFxYkAutPUL20CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 59956d35a8618235ea715280b49447bb36f2c975.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_hdmi.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_hdmi.c b/drivers/gpu/drm/exynos/exynos_hdmi.c
index 9a6d652..8ebb4bf 100644
--- a/drivers/gpu/drm/exynos/exynos_hdmi.c
+++ b/drivers/gpu/drm/exynos/exynos_hdmi.c
@@ -75,7 +75,6 @@ struct hdmi_resources {
 	struct clk			*sclk_pixel;
 	struct clk			*sclk_hdmiphy;
 	struct clk			*hdmiphy;
-	struct clk			*mout_hdmi;
 	struct regulator_bulk_data	*regul_bulk;
 	int				regul_count;
 };
@@ -1282,7 +1281,7 @@ static void hdmi_v13_mode_apply(struct hdmi_context *hdata)
 	}
 
 	clk_disable_unprepare(hdata->res.sclk_hdmi);
-	clk_set_parent(hdata->res.mout_hdmi, hdata->res.sclk_hdmiphy);
+	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_hdmiphy);
 	clk_prepare_enable(hdata->res.sclk_hdmi);
 
 	/* enable HDMI and timing generator */
@@ -1449,7 +1448,7 @@ static void hdmi_v14_mode_apply(struct hdmi_context *hdata)
 	}
 
 	clk_disable_unprepare(hdata->res.sclk_hdmi);
-	clk_set_parent(hdata->res.mout_hdmi, hdata->res.sclk_hdmiphy);
+	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_hdmiphy);
 	clk_prepare_enable(hdata->res.sclk_hdmi);
 
 	/* enable HDMI and timing generator */
@@ -1475,7 +1474,7 @@ static void hdmiphy_conf_reset(struct hdmi_context *hdata)
 	u32 reg;
 
 	clk_disable_unprepare(hdata->res.sclk_hdmi);
-	clk_set_parent(hdata->res.mout_hdmi, hdata->res.sclk_pixel);
+	clk_set_parent(hdata->res.sclk_hdmi, hdata->res.sclk_pixel);
 	clk_prepare_enable(hdata->res.sclk_hdmi);
 
 	/* operation mode */
@@ -1982,13 +1981,8 @@ static int hdmi_resources_init(struct hdmi_context *hdata)
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

