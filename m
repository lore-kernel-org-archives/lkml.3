Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaKGNE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:04:58 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:48562 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbaKGNEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:04:54 -0500
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: rtc-linux@googlegroups.com
Cc: shawn.guo@linaro.org, linux@arm.linux.org.uk, kernel@pengutronix.de,
        stefan@agner.ch, b35083@freescale.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [[PATCHv2] 1/3] ARM: imx: clk-vf610: Add clock for SNVS
Date: Fri,  7 Nov 2014 18:34:26 +0530
Message-Id: <bbe86ff8ff7461451be5c53242842e966bfd3966.1415364391.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1415364391.git.maitysanchayan@gmail.com>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1415364391.git.maitysanchayan@gmail.com>
References: <cover.1415364391.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for clock gating of
the SNVS peripheral.

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 arch/arm/mach-imx/clk-vf610.c           |    1 +
 include/dt-bindings/clock/vf610-clock.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index 5937dde..bbf4785 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -379,6 +379,7 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(5));
 	clk[VF610_CLK_DMAMUX2] = imx_clk_gate2("dmamux2", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(1));
 	clk[VF610_CLK_DMAMUX3] = imx_clk_gate2("dmamux3", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(2));
+	clk[VF610_CLK_SNVS] = imx_clk_gate2("snvs-rtc", "ipg_bus", CCM_CCGR6, CCM_CCGRx_CGn(7));
 
 	imx_check_clocks(clk, ARRAY_SIZE(clk));
 
diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
index 801c0ac..979d24a 100644
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

