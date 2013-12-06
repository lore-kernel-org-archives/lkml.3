Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161184Ab3LFSHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 13:07:23 -0500
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:38818 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161126Ab3LFSHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:07:19 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Cc: Chen-Yu Tsai <wens@csie.org>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 05/10] ARM: dts: sun7i: Add GMAC controller node to sun7i DTSI
Date: Sat,  7 Dec 2013 01:29:38 +0800
Message-Id: <1386350983-13281-6-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1386350983-13281-1-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index e46cfed..ebb2cce 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -395,6 +395,20 @@
 			status = "disabled";
 		};
 
+		gmac: ethernet@01c50000 {
+			compatible = "allwinner,sun7i-gmac", "snps,dwmac";
+			reg = <0x01c50000 0x10000>,
+			      <0x01c20164 0x4>;
+			interrupts = <0 85 1>;
+			interrupt-names = "macirq";
+			clocks = <&ahb_gates 49>;
+			clock-names = "stmmaceth";
+			snps,pbl = <2>;
+			snps,fixed-burst;
+			snps,force_sf_dma_mode;
+			status = "disabled";
+		};
+
 		gic: interrupt-controller@01c81000 {
 			compatible = "arm,cortex-a7-gic", "arm,cortex-a15-gic";
 			reg = <0x01c81000 0x1000>,
-- 
1.8.5.1

