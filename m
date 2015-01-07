Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbbAGHJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:09:59 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:57905 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbbAGHJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:09:51 -0500
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: shawn.guo@linaro.org
Cc: linux@arm.linux.org.uk, kernel@pengutronix.de, stefan@agner.ch,
        jingchang.lu@freescale.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 1/2] ARM: imx: clk-vf610: Add clock for SNVS
Date: Wed,  7 Jan 2015 12:39:29 +0530
Message-Id: <832a4b2b28431f8e73606dfec5f9acac75ecae49.1420612799.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1420612799.git.maitysanchayan@gmail.com>
References: <cover.1420612799.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1420612799.git.maitysanchayan@gmail.com>
References: <cover.1420612799.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for clock gating of the SNVS peripheral.

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 arch/arm/mach-imx/clk-vf610.c           |    2 ++
 include/dt-bindings/clock/vf610-clock.h |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index cb21777..b7688b6 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -380,6 +380,8 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	clk[VF610_CLK_DMAMUX2] = imx_clk_gate2("dmamux2", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(1));
 	clk[VF610_CLK_DMAMUX3] = imx_clk_gate2("dmamux3", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(2));
 
+	clk[VF610_CLK_SNVS] = imx_clk_gate2("snvs-rtc", "ipg_bus", CCM_CCGR6, CCM_CCGRx_CGn(7));
+
 	imx_check_clocks(clk, ARRAY_SIZE(clk));
 
 	clk_set_parent(clk[VF610_CLK_QSPI0_SEL], clk[VF610_CLK_PLL1_PFD4]);
diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
index 801c0ac..68f1886 100644
--- a/include/dt-bindings/clock/vf610-clock.h
+++ b/include/dt-bindings/clock/vf610-clock.h
@@ -192,6 +192,7 @@
 #define VF610_PLL5_BYPASS		179
 #define VF610_PLL6_BYPASS		180
 #define VF610_PLL7_BYPASS		181
-#define VF610_CLK_END			182
+#define VF610_CLK_SNVS			182
+#define VF610_CLK_END			183
 
 #endif /* __DT_BINDINGS_CLOCK_VF610_H */
-- 
1.7.9.5

