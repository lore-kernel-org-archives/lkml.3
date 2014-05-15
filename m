Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaEONOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 09:14:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33921 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbaEONOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 09:14:34 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-da-5374bdb8fb89
From: Rahul Sharma <rahul.sharma@samsung.com>
To: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Cc: a.hajda@samsung.com, t.stanislaws@samsung.com, thierry.reding@gmail.com,
        devicetree@vger.kernel.org, kgene.kim@samsung.com, kishon@ti.com,
        kyungmin.park@samsung.com, robh+dt@kernel.org, grant.likely@linaro.org,
        sylvester.nawrocki@gmail.com, joshi@samsung.com, r.sh.open@gmail.com,
        Rahul Sharma <rahul.sharma@samsung.com>
Subject: [PATCH v4 3/3] s5p-tv: hdmi: use hdmiphy as PHY
Date: Thu, 15 May 2014 18:40:54 +0530
Message-id: <1400159454-31107-4-git-send-email-rahul.sharma@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400159454-31107-1-git-send-email-rahul.sharma@samsung.com>
References: <1400159454-31107-1-git-send-email-rahul.sharma@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsWyRsSkVnfH3pJgg74uXotb686xWsw/AiSu
	fH3PZnHgzw5Gi++7vrBb9C64ymZx4WkPm8XZpjfsFpd3zWGzmHF+H5PFwhfxFlMWHWa1aN17
	hN1i3uedTBbz2l+yWvzcNY/FQcBj56y77B6bVnWyedy5tofN4373cSaPvi2rGD2O39jO5PF5
	k1wAexSXTUpqTmZZapG+XQJXRsOrhYwFPSIVV2bMYmlgfCnQxcjJISFgInF/TT8rhC0mceHe
	erYuRi4OIYGljBK7t79gginq+XifBSKxiFHi3/Zl7BBOO5PE+5tnmEGq2AR0JWYffMYIYosI
	pEl8O9DCClLELHCGSeLZlf1ADgeHsICFxLIHqiA1LAKqEg83fmQBCfMKeEhMfqYEYkoIKEjM
	mWQDUsEp4Cmx68xNsOlCQBVvj89kBpkoIfCRXWL3j25miDECEt8mH2KB6JWV2HSAGeJmSYmD
	K26wTGAUXsDIsIpRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjMKJO/3s2cQfj/QPWhxiTgcZN
	ZJYSTc4HRmReSbyhsZmRhamJqbGRuaUZacJK4rzpj5KChATSE0tSs1NTC1KL4otKc1KLDzEy
	cXBKNTBy8lbvPBvLl7r7yMVti2JX6KcGXPvmbdQ6bdu76phH6xfuvSeioLH+7JGIB7+K0nzX
	Z27IMkhe+2K/1z+NvSWTS4vf3JxyXibx/hmOyztZTnkc6ro3I0AvqzLcvnhZ3cO/3wobHecb
	+pza/Ly7L9A/9suCHaxtM08cD1hqsJR5l/A+gczvzhM7lViKMxINtZiLihMBjCk6PL4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xgO6OvSXBBhd+MFncWneO1WL+ESBx
	5et7NosDf3YwWnzf9YXdonfBVTaLC0972CzONr1ht7i8aw6bxYzz+5gsFr6It5iy6DCrReve
	I+wW8z7vZLKY1/6S1eLnrnksDgIeO2fdZffYtKqTzePOtT1sHve7jzN59G1Zxehx/MZ2Jo/P
	m+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
	gK5XUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGY0vFrIWNAjUnFlxiyW
	BsaXAl2MnBwSAiYSPR/vs0DYYhIX7q1n62Lk4hASWMQo8W/7MnYIp51J4v3NM8wgVWwCuhKz
	Dz5jBLFFBNIkvh1oYQUpYhY4wyTx7Mp+IIeDQ1jAQmLZA1WQGhYBVYmHGz+ygIR5BTwkJj9T
	AjElBBQk5kyyAangFPCU2HXmJth0IaCKt8dnMk9g5F3AyLCKUTS1ILmgOCk910ivODG3uDQv
	XS85P3cTIzhen0nvYFzVYHGIUYCDUYmHl2FycbAQa2JZcWXuIUYJDmYlEd7G6SXBQrwpiZVV
	qUX58UWlOanFhxiTgW6ayCwlmpwPTCV5JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJITyxJ
	zU5NLUgtgtnCxMEp1cBo+GTr1dRMx38hi6fP91XPKDvLxfos2E5W7OGqKx927jipt8xzeUfe
	kq3sslNOzQn7tuet0U2euElhq7fNuVV0Jvv7nrvCa69uNZ+1JNDxc98fd70JXLWtfHfczRL1
	Vue8O37ydOKsJF31eJ7vVcZ34nOyD3y2tX2U7j7nxBHBa8m7eL+Xh5WvUmIpzkg01GIuKk4E
	ACaXi4kbAwAA
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

