Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbaENTSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:18:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:16363 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593AbaENTS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:18:29 -0400
X-AuditID: cbfee690-b7fcd6d0000026e0-ed-5373c1826ffe
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: a.hajda@samsung.com, t.stanislaws@samsung.com, devicetree@vger.kernel.org,
        kgene.kim@samsung.com, kishon@ti.com, kyungmin.park@samsung.com,
        robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, joshi@samsung.com,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: [PATCH v3 3/3] s5p-tv: hdmi: use hdmiphy as PHY
Date: Thu, 15 May 2014 00:47:23 +0530
Message-id: <1400095043-685-4-git-send-email-rahul.sharma@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
References: <1400095043-685-1-git-send-email-rahul.sharma@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCIsWRmVeSWpSXmKPExsWyRsSkVrfpYHGwQXOvucWtdedYLeYfARJX
	vr5nszjwZwejxfddX9gtehdcZbO48LSHzeJs0xt2i8u75rBZzDi/j8liyqLDrBate4+wW8z7
	vJPJYl77S1YHPo+ds+6ye2xa1cnmcefaHjaP+93HmTz6tqxi9Dh+YzuTx+dNcgHsUVw2Kak5
	mWWpRfp2CVwZDa8WMhb0iFRcmTGLpYHxpUAXIyeHhICJxOkJ7cwQtpjEhXvr2boYuTiEBJYy
	Sjxp+8MEU3T80HZGiMR0RomFB/6xQzjtTBKT+t6AtbMJ6ErMPviMEcQWEUiT+HaghRWkiFlg
	NpPExhev2UASwgIWEuu+dII1sAioSvS8WQTWwCvgJvHv63WWLkYOoHUKEnMm2YCEOQXcJRou
	bQQrFwIqWdEyD2ymhMA9domXX34zQswRkPg2+RBUr6zEpgNQ70hKHFxxg2UCo/ACRoZVjKKp
	BckFxUnpRSZ6xYm5xaV56XrJ+bmbGIExdPrfswk7GO8dsD7EmAw0biKzlGhyPjAG80riDY3N
	jCxMTUyNjcwtzUgTVhLnVXuUFCQkkJ5YkpqdmlqQWhRfVJqTWnyIkYmDU6qBccUfzYk31Xtz
	AjeIsrtHzZlbvnCJ0sc4g1fnnqWLRW5ZefXmBXl3kXWlyWtP7udqPHJkGn9H6iQzueauXwdv
	lnq4LVsTfYPrRvtLnkWbpyr2TtI92vDxwpJyk1dPDEstDxbaXrawahaOdi5+6sq/gOdZ2cx1
	kQ1vczXuRpyQ+sw6x/F+RmGSqxJLcUaioRZzUXEiACUOHhS3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkleLIzCtJLcpLzFFi42I5/e+xoG7TweJggz1XtS1urTvHajH/CJC4
	8vU9m8WBPzsYLb7v+sJu0bvgKpvFhac9bBZnm96wW1zeNYfNYsb5fUwWUxYdZrVo3XuE3WLe
	551MFvPaX7I68HnsnHWX3WPTqk42jzvX9rB53O8+zuTRt2UVo8fxG9uZPD5vkgtgj2pgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlpJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmNHwaiFjQY9IxZUZs1gaGF8KdDFyckgI
	mEgcP7SdEcIWk7hwbz1bFyMXh5DAdEaJhQf+sUM47UwSk/reMINUsQnoSsw++AysQ0QgTeLb
	gRZWkCJmgdlMEhtfvGYDSQgLWEis+9IJ1sAioCrR82YRWAOvgJvEv6/XWboYOYDWKUjMmWQD
	EuYUcJdouLQRrFwIqGRFyzzWCYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER+gz
	qR2MKxssDjEKcDAq8fAyTC4OFmJNLCuuzD3EKMHBrCTCm7QXKMSbklhZlVqUH19UmpNafIgx
	GeioicxSosn5wOSRVxJvaGxibmpsamliYWJmSZqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTByc
	Ug2M0XYOs/7znEtjkd500f9zQUO4sVVohubR5rCDhs7JHxwW7fgV7/1tWWtAu9SUf0ZLneX4
	OH/dSy97dmvT3u3be2ukGQ3Wnck6xPGEI2RBwfOPPoU/XllrXSuafdas7/i6ppaS/d12umxG
	5mkT/wjO9Zg9Z1rFQa3aTe4MgfO29pxVP3pry10XJZbijERDLeai4kQAnDL4OhQDAAA=
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

This patch makes S5P-HDMI driver to control HDMIPHY via PHY interface.

Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
Signed-off-by: Rahul Sharma <Rahul.Sharma@samsung.com>
---
 drivers/media/platform/s5p-tv/hdmi_drv.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 534722c..8013e52 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -32,6 +32,7 @@
 #include <linux/clk.h>
 #include <linux/regulator/consumer.h>
 #include <linux/v4l2-dv-timings.h>
+#include <linux/phy/phy.h>
 
 #include <media/s5p_hdmi.h>
 #include <media/v4l2-common.h>
@@ -66,7 +67,7 @@ struct hdmi_resources {
 	struct clk *sclk_hdmi;
 	struct clk *sclk_pixel;
 	struct clk *sclk_hdmiphy;
-	struct clk *hdmiphy;
+	struct phy *hdmiphy;
 	struct regulator_bulk_data *regul_bulk;
 	int regul_count;
 };
@@ -586,7 +587,7 @@ static int hdmi_resource_poweron(struct hdmi_resources *res)
 	if (ret < 0)
 		return ret;
 	/* power-on hdmi physical interface */
-	clk_enable(res->hdmiphy);
+	phy_power_on(res->hdmiphy);
 	/* use VPP as parent clock; HDMIPHY is not working yet */
 	clk_set_parent(res->sclk_hdmi, res->sclk_pixel);
 	/* turn clocks on */
@@ -600,7 +601,7 @@ static void hdmi_resource_poweroff(struct hdmi_resources *res)
 	/* turn clocks off */
 	clk_disable(res->sclk_hdmi);
 	/* power-off hdmiphy */
-	clk_disable(res->hdmiphy);
+	phy_power_off(res->hdmiphy);
 	/* turn HDMI power off */
 	regulator_bulk_disable(res->regul_count, res->regul_bulk);
 }
@@ -784,7 +785,7 @@ static void hdmi_resources_cleanup(struct hdmi_device *hdev)
 	/* kfree is NULL-safe */
 	kfree(res->regul_bulk);
 	if (!IS_ERR(res->hdmiphy))
-		clk_put(res->hdmiphy);
+		phy_put(res->hdmiphy);
 	if (!IS_ERR(res->sclk_hdmiphy))
 		clk_put(res->sclk_hdmiphy);
 	if (!IS_ERR(res->sclk_pixel))
@@ -835,7 +836,7 @@ static int hdmi_resources_init(struct hdmi_device *hdev)
 		dev_err(dev, "failed to get clock 'sclk_hdmiphy'\n");
 		goto fail;
 	}
-	res->hdmiphy = clk_get(dev, "hdmiphy");
+	res->hdmiphy = phy_get(dev, "hdmiphy");
 	if (IS_ERR(res->hdmiphy)) {
 		dev_err(dev, "failed to get clock 'hdmiphy'\n");
 		goto fail;
-- 
1.7.9.5

