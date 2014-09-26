Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaIZNOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 09:14:25 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58669 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468AbaIZNOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 09:14:23 -0400
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: kernel@pengutronix.de, a.zummo@towertech.it
Cc: b35083@freescale.com, rtc-linux@googlegroups.com, shawn.guo@freescale.com,
        stefan@agner.ch, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 1/3] ARM: imx: clk-vf610: Add SNVS clock
Date: Fri, 26 Sep 2014 18:43:59 +0530
Message-Id: <75fd6d21e5ebfbe918c9beeb15f361ca4e59f29b.1411736171.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1411736171.git.maitysanchayan@gmail.com>
References: <cover.1411736171.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1411736171.git.maitysanchayan@gmail.com>
References: <cover.1411736171.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the SNVS clock gating which is
required by the SNVS peripheral.

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 arch/arm/mach-imx/clk-vf610.c           |    1 +
 include/dt-bindings/clock/vf610-clock.h |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/clk-vf610.c b/arch/arm/mach-imx/clk-vf610.c
index a178184..2a3a759f 100644
--- a/arch/arm/mach-imx/clk-vf610.c
+++ b/arch/arm/mach-imx/clk-vf610.c
@@ -318,6 +318,7 @@ static void __init vf610_clocks_init(struct device_node *ccm_node)
 	clk[VF610_CLK_DMAMUX1] = imx_clk_gate2("dmamux1", "platform_bus", CCM_CCGR0, CCM_CCGRx_CGn(5));
 	clk[VF610_CLK_DMAMUX2] = imx_clk_gate2("dmamux2", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(1));
 	clk[VF610_CLK_DMAMUX3] = imx_clk_gate2("dmamux3", "platform_bus", CCM_CCGR6, CCM_CCGRx_CGn(2));
+	clk[VF610_CLK_SNVS] = imx_clk_gate2("snvs", "ipg_bus", CCM_CCGR6, CCM_CCGRx_CGn(7));
 
 	imx_check_clocks(clk, ARRAY_SIZE(clk));
 
diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-bindings/clock/vf610-clock.h
index d6b56b2..358eab9 100644
--- a/include/dt-bindings/clock/vf610-clock.h
+++ b/include/dt-bindings/clock/vf610-clock.h
@@ -169,6 +169,7 @@
 #define VF610_CLK_PLL7_MAIN		156
 #define VF610_CLK_USBPHY0		157
 #define VF610_CLK_USBPHY1		158
-#define VF610_CLK_END			159
+#define VF610_CLK_SNVS			159
+#define VF610_CLK_END			160
 
 #endif /* __DT_BINDINGS_CLOCK_VF610_H */
-- 
1.7.9.5

