Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbbAZLOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:14:25 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:57412 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbbAZLOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:14:19 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, mturquette@linaro.org,
        sboyd@codeaurora.org, devicetree@vger.kernel.org
Subject: [PATCH 4/4] clk: dt: st: Introduce clock domain documentation
Date: Mon, 26 Jan 2015 11:14:00 +0000
Message-Id: <1422270840-3039-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422270840-3039-1-git-send-email-lee.jones@linaro.org>
References: <1422270840-3039-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 .../devicetree/bindings/clock/st/st,clk-domain.txt | 34 ++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/st/st,clk-domain.txt

diff --git a/Documentation/devicetree/bindings/clock/st/st,clk-domain.txt b/Documentation/devicetree/bindings/clock/st/st,clk-domain.txt
new file mode 100644
index 0000000..7309937
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/st/st,clk-domain.txt
@@ -0,0 +1,34 @@
+STMicroelectronics Clock Domain
+
+ST hardware have a bunch of clocks which must not be turned off.
+If drivers a) fail to obtain a reference to any of these or b) give
+up a previously obtained reference during suspend, the common clk
+framework will attempt to turn them off and the hardware will
+subsequently die.  The only way to recover from this failure is to
+restart.
+
+To avoid either of these two scenarios from catastrophically
+disabling the running system we have implemented a clock domain
+where clocks are consumed and references are taken, thus preventing
+them from being shut down by the framework.
+
+We use the generic clock bindings found in:
+  Documentation/devicetree/bindings/clock/clock-bindings.txt
+
+Required properties:
+- compatible : Must be "st,clk-domain"
+
+Example:
+
+clk-domain {
+	compatible = "st,clk-domain";
+	clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>,
+		 <&clk_s_c0_flexgen CLK_COMPO_DVP>,
+		 <&clk_s_c0_flexgen CLK_MMC_1>,
+		 <&clk_s_c0_flexgen CLK_ICN_SBC>,
+		 <&clk_s_c0_flexgen CLK_ICN_LMI>,
+		 <&clk_s_c0_flexgen CLK_ICN_CPU>,
+		 <&clk_s_c0_flexgen CLK_TX_ICN_DMU>,
+		 <&clk_s_a0_flexgen CLK_IC_LMI0>,
+		 <&clk_m_a9>;
+};
-- 
1.9.1

