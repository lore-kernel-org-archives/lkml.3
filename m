Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbaFHSJz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 14:09:55 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:60909 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbaFHSJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 14:09:51 -0400
From: Alexander Bersenev <bay@hackerdom.ru>
To: linux-sunxi@googlegroups.com, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, pawel.moll@arm.com,
        rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
        srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Cc: Alexander Bersenev <bay@hackerdom.ru>
Subject: [PATCH v9 4/5] ARM: sunxi: Add IR controllers on A20 to dtsi
Date: Mon,  9 Jun 2014 00:08:12 +0600
Message-Id: <1402250893-5412-5-git-send-email-bay@hackerdom.ru>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402250893-5412-1-git-send-email-bay@hackerdom.ru>
References: <1402250893-5412-1-git-send-email-bay@hackerdom.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds records for two IR controllers on A20

Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
---
 arch/arm/boot/dts/sun7i-a20.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index c057c3e..fe1f8ff 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -763,6 +763,24 @@
 			interrupts = <0 24 4>;
 		};
 
+		ir0: ir@01c21800 {
+			compatible = "allwinner,sun7i-a20-ir";
+			clocks = <&apb0_gates 6>, <&ir0_clk>;
+			clock-names = "apb", "ir";
+			interrupts = <0 5 4>;
+			reg = <0x01c21800 0x40>;
+			status = "disabled";
+		};
+
+		ir1: ir@01c21c00 {
+			compatible = "allwinner,sun7i-a20-ir";
+			clocks = <&apb0_gates 7>, <&ir1_clk>;
+			clock-names = "apb", "ir";
+			interrupts = <0 6 4>;
+			reg = <0x01c21c00 0x40>;
+			status = "disabled";
+		};
+
 		lradc: lradc@01c22800 {
 			compatible = "allwinner,sun4i-lradc-keys";
 			reg = <0x01c22800 0x100>;
-- 
1.9.3

