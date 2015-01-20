Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbbATKf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 05:35:58 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:60490 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbbATKf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 05:35:56 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Kukjin Kim <kgene@kernel.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Arun Kumar K <arun.kk@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tobias Jakobi <liquid.acid@gmx.net>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kevin Hilman <khilman@linaro.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 1/2] clk: exynos5420: Add IDs for clocks used in DISP1 power domain
Date: Tue, 20 Jan 2015 11:35:26 +0100
Message-Id: <1421750127-22536-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1421750127-22536-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1421750127-22536-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a power domain is powered off on Exynos5420 SoC, the input clocks of
the devices attached to this power domain are re-parented to oscclk and
restored to the original parent after powering on the power domain.

So a reference to the input and parent clocks for the devices attached to
a power domain are needed to be able to do the re-parenting. The DISP1 pd
includes modules which uses the following clocks:

ACLK_200_DISP1 (MIXER and HDMILINK)
ACLK_300_DISP1 (FIMD1)
ACLK_400_DISP1 (Internal Buses)

Each of these clocks are generated as the output of a clock mux so add an
ID for all of these clock muxes and their parents to be referenced in the
DISP1 power domain device node.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 drivers/clk/samsung/clk-exynos5420.c   | 23 ++++++++++++-----------
 include/dt-bindings/clock/exynos5420.h |  6 ++++++
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 848d602efc06..07d666cc6a29 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -635,8 +635,8 @@ static struct samsung_mux_clock exynos5x_mux_clks[] __initdata = {
 			SRC_TOP3, 0, 1),
 	MUX(0, "mout_user_aclk400_mscl", mout_user_aclk400_mscl_p,
 			SRC_TOP3, 4, 1),
-	MUX(0, "mout_user_aclk200_disp1", mout_user_aclk200_disp1_p,
-			SRC_TOP3, 8, 1),
+	MUX(CLK_MOUT_USER_ACLK200_DISP1, "mout_user_aclk200_disp1",
+			mout_user_aclk200_disp1_p, SRC_TOP3, 8, 1),
 	MUX(0, "mout_user_aclk200_fsys2", mout_user_aclk200_fsys2_p,
 			SRC_TOP3, 12, 1),
 	MUX(0, "mout_user_aclk400_wcore", mout_user_aclk400_wcore_p,
@@ -663,8 +663,8 @@ static struct samsung_mux_clock exynos5x_mux_clks[] __initdata = {
 	MUX(CLK_MOUT_USER_ACLK333, "mout_user_aclk333", mout_user_aclk333_p,
 			SRC_TOP4, 28, 1),
 
-	MUX(0, "mout_user_aclk400_disp1", mout_user_aclk400_disp1_p,
-			SRC_TOP5, 0, 1),
+	MUX(CLK_MOUT_USER_ACLK400_DISP1, "mout_user_aclk400_disp1",
+			mout_user_aclk400_disp1_p, SRC_TOP5, 0, 1),
 	MUX(0, "mout_user_aclk66_psgen", mout_user_aclk66_peric_p,
 			SRC_TOP5, 4, 1),
 	MUX(0, "mout_user_aclk333_g2d", mout_user_aclk333_g2d_p,
@@ -675,8 +675,8 @@ static struct samsung_mux_clock exynos5x_mux_clks[] __initdata = {
 			SRC_TOP5, 16, 1),
 	MUX(0, "mout_user_aclk300_jpeg", mout_user_aclk300_jpeg_p,
 			SRC_TOP5, 20, 1),
-	MUX(0, "mout_user_aclk300_disp1", mout_user_aclk300_disp1_p,
-			SRC_TOP5, 24, 1),
+	MUX(CLK_MOUT_USER_ACLK300_DISP1, "mout_user_aclk300_disp1",
+			mout_user_aclk300_disp1_p, SRC_TOP5, 24, 1),
 	MUX(0, "mout_user_aclk300_gscl", mout_user_aclk300_gscl_p,
 			SRC_TOP5, 28, 1),
 
@@ -693,7 +693,8 @@ static struct samsung_mux_clock exynos5x_mux_clks[] __initdata = {
 			SRC_TOP10, 0, 1),
 	MUX(0, "mout_sw_aclk400_mscl", mout_sw_aclk400_mscl_p,
 			SRC_TOP10, 4, 1),
-	MUX(0, "mout_sw_aclk200", mout_sw_aclk200_p, SRC_TOP10, 8, 1),
+	MUX(CLK_MOUT_SW_ACLK200, "mout_sw_aclk200", mout_sw_aclk200_p,
+			SRC_TOP10, 8, 1),
 	MUX(0, "mout_sw_aclk200_fsys2", mout_sw_aclk200_fsys2_p,
 			SRC_TOP10, 12, 1),
 	MUX(0, "mout_sw_aclk400_wcore", mout_sw_aclk400_wcore_p,
@@ -717,8 +718,8 @@ static struct samsung_mux_clock exynos5x_mux_clks[] __initdata = {
 	MUX(CLK_MOUT_SW_ACLK333, "mout_sw_aclk333", mout_sw_aclk333_p,
 			SRC_TOP11, 28, 1),
 
-	MUX(0, "mout_sw_aclk400_disp1", mout_sw_aclk400_disp1_p,
-			SRC_TOP12, 4, 1),
+	MUX(CLK_MOUT_SW_ACLK400, "mout_sw_aclk400_disp1",
+			mout_sw_aclk400_disp1_p, SRC_TOP12, 4, 1),
 	MUX(0, "mout_sw_aclk333_g2d", mout_sw_aclk333_g2d_p,
 			SRC_TOP12, 8, 1),
 	MUX(0, "mout_sw_aclk266_g2d", mout_sw_aclk266_g2d_p,
@@ -726,8 +727,8 @@ static struct samsung_mux_clock exynos5x_mux_clks[] __initdata = {
 	MUX(0, "mout_sw_aclk_g3d", mout_sw_aclk_g3d_p, SRC_TOP12, 16, 1),
 	MUX(0, "mout_sw_aclk300_jpeg", mout_sw_aclk300_jpeg_p,
 			SRC_TOP12, 20, 1),
-	MUX(0, "mout_sw_aclk300_disp1", mout_sw_aclk300_disp1_p,
-			SRC_TOP12, 24, 1),
+	MUX(CLK_MOUT_SW_ACLK300, "mout_sw_aclk300_disp1",
+			mout_sw_aclk300_disp1_p, SRC_TOP12, 24, 1),
 	MUX(0, "mout_sw_aclk300_gscl", mout_sw_aclk300_gscl_p,
 			SRC_TOP12, 28, 1),
 
diff --git a/include/dt-bindings/clock/exynos5420.h b/include/dt-bindings/clock/exynos5420.h
index 8dc0913f1775..99da0d117a7d 100644
--- a/include/dt-bindings/clock/exynos5420.h
+++ b/include/dt-bindings/clock/exynos5420.h
@@ -204,6 +204,12 @@
 #define CLK_MOUT_MAUDIO0	643
 #define CLK_MOUT_USER_ACLK333	644
 #define CLK_MOUT_SW_ACLK333	645
+#define CLK_MOUT_USER_ACLK200_DISP1	646
+#define CLK_MOUT_SW_ACLK200	647
+#define CLK_MOUT_USER_ACLK300_DISP1     648
+#define CLK_MOUT_SW_ACLK300     649
+#define CLK_MOUT_USER_ACLK400_DISP1     650
+#define CLK_MOUT_SW_ACLK400     651
 
 /* divider clocks */
 #define CLK_DOUT_PIXEL		768
-- 
2.1.3

