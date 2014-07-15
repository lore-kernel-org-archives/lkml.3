Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbaGORCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:02:41 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:33001 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbaGORCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:17 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Arun Kumar K <arun.kk@samsung.com>,
        Shaik Ameer Basha <shaik.ameer@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 61/94] clk: exynos5420: Add IDs for clocks used in PD mfc
Date: Tue, 15 Jul 2014 20:01:16 +0300
Message-Id: <1405443709-15288-61-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arun Kumar K <arun.kk@samsung.com>

Adds IDs for MUX clocks to be used by power domain for MFC
for doing re-parenting while pd on/off.

Signed-off-by: Arun Kumar K <arun.kk@samsung.com>
Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
Acked-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/clk/samsung/clk-exynos5420.c   |    6 ++++--
 include/dt-bindings/clock/exynos5420.h |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos5420.c b/drivers/clk/samsung/clk-exynos5420.c
index 61eccf0..a4e6cc7 100644
--- a/drivers/clk/samsung/clk-exynos5420.c
+++ b/drivers/clk/samsung/clk-exynos5420.c
@@ -631,7 +631,8 @@ static struct samsung_mux_clock exynos5x_mux_clks[] __initdata = {
 			SRC_TOP4, 16, 1),
 	MUX(0, "mout_user_aclk266", mout_user_aclk266_p, SRC_TOP4, 20, 1),
 	MUX(0, "mout_user_aclk166", mout_user_aclk166_p, SRC_TOP4, 24, 1),
-	MUX(0, "mout_user_aclk333", mout_user_aclk333_p, SRC_TOP4, 28, 1),
+	MUX(CLK_MOUT_USER_ACLK333, "mout_user_aclk333", mout_user_aclk333_p,
+			SRC_TOP4, 28, 1),
 
 	MUX(0, "mout_user_aclk400_disp1", mout_user_aclk400_disp1_p,
 			SRC_TOP5, 0, 1),
@@ -684,7 +685,8 @@ static struct samsung_mux_clock exynos5x_mux_clks[] __initdata = {
 			SRC_TOP11, 12, 1),
 	MUX(0, "mout_sw_aclk266", mout_sw_aclk266_p, SRC_TOP11, 20, 1),
 	MUX(0, "mout_sw_aclk166", mout_sw_aclk166_p, SRC_TOP11, 24, 1),
-	MUX(0, "mout_sw_aclk333", mout_sw_aclk333_p, SRC_TOP11, 28, 1),
+	MUX(CLK_MOUT_SW_ACLK333, "mout_sw_aclk333", mout_sw_aclk333_p,
+			SRC_TOP11, 28, 1),
 
 	MUX(0, "mout_sw_aclk400_disp1", mout_sw_aclk400_disp1_p,
 			SRC_TOP12, 4, 1),
diff --git a/include/dt-bindings/clock/exynos5420.h b/include/dt-bindings/clock/exynos5420.h
index 14e1c8f..21d51ae 100644
--- a/include/dt-bindings/clock/exynos5420.h
+++ b/include/dt-bindings/clock/exynos5420.h
@@ -202,6 +202,8 @@
 #define CLK_MOUT_G3D		641
 #define CLK_MOUT_VPLL		642
 #define CLK_MOUT_MAUDIO0	643
+#define CLK_MOUT_USER_ACLK333	644
+#define CLK_MOUT_SW_ACLK333	645
 
 /* divider clocks */
 #define CLK_DOUT_PIXEL		768
-- 
1.7.10.4

