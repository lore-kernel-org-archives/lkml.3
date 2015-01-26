Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbbAZLPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:15:16 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:58730 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbbAZLOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:14:15 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, mturquette@linaro.org,
        sboyd@codeaurora.org, devicetree@vger.kernel.org
Subject: [PATCH 2/4] ARM: sti: stih407-family: Provide Clock Domain information
Date: Mon, 26 Jan 2015 11:13:58 +0000
Message-Id: <1422270840-3039-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422270840-3039-1-git-send-email-lee.jones@linaro.org>
References: <1422270840-3039-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Certain clocks should not be turned of by clk_disable_unused.  Until
now we have been using the kernel command-line of the same name to
prevent common clk from turning off all clocks without a reference,
as this would ensure hardware lockup.  This patch lists each clock
which need to stay on to prevent the aforementioned issue from
arising.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/stih407-family.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/stih407-family.dtsi b/arch/arm/boot/dts/stih407-family.dtsi
index 3e31d32..0478b41 100644
--- a/arch/arm/boot/dts/stih407-family.dtsi
+++ b/arch/arm/boot/dts/stih407-family.dtsi
@@ -34,6 +34,19 @@
 		reg = <0x08761000 0x1000>, <0x08760100 0x100>;
 	};
 
+	clk-domain {
+		compatible = "st,clk-domain";
+		clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>,
+			 <&clk_s_c0_flexgen CLK_COMPO_DVP>,
+			 <&clk_s_c0_flexgen CLK_MMC_1>,
+			 <&clk_s_c0_flexgen CLK_ICN_SBC>,
+			 <&clk_s_c0_flexgen CLK_ICN_LMI>,
+			 <&clk_s_c0_flexgen CLK_ICN_CPU>,
+			 <&clk_s_c0_flexgen CLK_TX_ICN_DMU>,
+			 <&clk_s_a0_flexgen CLK_IC_LMI0>,
+			 <&clk_m_a9>;
+	};
+
 	scu@08760000 {
 		compatible = "arm,cortex-a9-scu";
 		reg = <0x08760000 0x1000>;
-- 
1.9.1

