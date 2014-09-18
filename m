Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668AbaIRW5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 18:57:19 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:34672 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760AbaIRW5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 18:57:17 -0400
Date: Fri, 19 Sep 2014 00:57:36 +0200
From: Rene Kolarik <rene.kolarik@gmail.com>
To: gregkh@linuxfoundation.org, shawn.guo@freescale.com, kernel@pengutronix.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH]imx-drm coding style fixes
Message-ID: <20140918225736.GA15881@rendy-i5>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I've fixed coding style issues in drivers/staging/imx-drm directory. This is a part of Eudyptula Challenge.

Rene Kolarik

--lrZ03NoBR/3+SXJZ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="imx-coding-style.patch"

Signed-off-by: Rene Kolarik <rene.kolarik@gmail.com>

diff --git a/Documentation/devicetree/bindings/arm/fsl.txt b/Documentation/devicetree/bindings/arm/fsl.txt
index e935d7d..4004bb8 100644
--- a/Documentation/devicetree/bindings/arm/fsl.txt
+++ b/Documentation/devicetree/bindings/arm/fsl.txt
@@ -71,6 +71,10 @@ i.MX53 generic board
 Required root node properties:
     - compatible = "fsl,imx53";
 
+i.MX53 Television Encoder
+Required root node properties:
+    - compatible = "fsl,imx53-tve";
+
 i.MX6q generic board
 Required root node properties:
     - compatible = "fsl,imx6q";
diff --git a/drivers/staging/imx-drm/imx-drm-core.c b/drivers/staging/imx-drm/imx-drm-core.c
index e9fba97..a04b3ef 100644
--- a/drivers/staging/imx-drm/imx-drm-core.c
+++ b/drivers/staging/imx-drm/imx-drm-core.c
@@ -630,7 +630,8 @@ static int imx_drm_platform_probe(struct platform_device *pdev)
 				continue;
 			}
 
-			component_match_add(&pdev->dev, &match, compare_of, remote);
+			component_match_add(&pdev->dev, &match, compare_of,
+				remote);
 			of_node_put(remote);
 		}
 		of_node_put(port);
diff --git a/drivers/staging/imx-drm/imx-hdmi.c b/drivers/staging/imx-drm/imx-hdmi.c
index 18c9ccd..aaec6b2 100644
--- a/drivers/staging/imx-drm/imx-hdmi.c
+++ b/drivers/staging/imx-drm/imx-hdmi.c
@@ -323,8 +323,7 @@ static unsigned int hdmi_compute_cts(unsigned int freq, unsigned long pixel_clk,
 	}
 	if (ratio == 100)
 		return cts;
-	else
-		return (cts * ratio) / 100;
+	return (cts * ratio) / 100;
 }
 
 static void hdmi_set_clk_regenerator(struct imx_hdmi *hdmi,
diff --git a/drivers/staging/imx-drm/imx-tve.c b/drivers/staging/imx-drm/imx-tve.c
index 31fe7cf..a12202a 100644
--- a/drivers/staging/imx-drm/imx-tve.c
+++ b/drivers/staging/imx-drm/imx-tve.c
@@ -430,10 +430,9 @@ static long clk_tve_di_round_rate(struct clk_hw *hw, unsigned long rate,
 	div = *prate / rate;
 	if (div >= 4)
 		return *prate / 4;
-	else if (div >= 2)
+	if (div >= 2)
 		return *prate / 2;
-	else
-		return *prate;
+	return *prate;
 }
 
 static int clk_tve_di_set_rate(struct clk_hw *hw, unsigned long rate,
@@ -538,7 +537,7 @@ static struct regmap_config tve_regmap_config = {
 	.max_register = 0xdc,
 };
 
-static const char *imx_tve_modes[] = {
+static const char * const imx_tve_modes[] = {
 	[TVE_MODE_TVOUT]  = "tvout",
 	[TVE_MODE_VGA] = "vga",
 };
@@ -666,7 +665,8 @@ static int imx_tve_bind(struct device *dev, struct device *master, void *data)
 
 	ret = regmap_read(tve->regmap, TVE_COM_CONF_REG, &val);
 	if (ret < 0) {
-		dev_err(dev, "failed to read configuration register: %d\n", ret);
+		dev_err(dev, "failed to read configuration register: %d\n",
+			ret);
 		return ret;
 	}
 	if (val != 0x00100000) {
diff --git a/drivers/staging/imx-drm/parallel-display.c b/drivers/staging/imx-drm/parallel-display.c
index 1998846..601439b 100644
--- a/drivers/staging/imx-drm/parallel-display.c
+++ b/drivers/staging/imx-drm/parallel-display.c
@@ -228,7 +228,8 @@ static int imx_pd_bind(struct device *dev, struct device *master, void *data)
 		else if (!strcmp(fmt, "bgr666"))
 			imxpd->interface_pix_fmt = V4L2_PIX_FMT_BGR666;
 		else if (!strcmp(fmt, "lvds666"))
-			imxpd->interface_pix_fmt = v4l2_fourcc('L', 'V', 'D', '6');
+			imxpd->interface_pix_fmt = v4l2_fourcc(
+				'L', 'V', 'D', '6');
 	}
 
 	panel_node = of_parse_phandle(np, "fsl,panel", 0);

--lrZ03NoBR/3+SXJZ--
