Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760168AbaGYLMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:12:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38335 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbaGYLMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:12:42 -0400
From: =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Andreas Olofsson <andreas@adapteva.com>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        harini.katakam@xilinx.com, soren.brinkmann@xilinx.com,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v3] ARM: dts: zynq: Add SPI
Date: Fri, 25 Jul 2014 13:12:31 +0200
Message-Id: <1406286752-8905-1-git-send-email-afaerber@suse.de>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1cf9126b-c5e4-4ae7-a294-071584857d6c@BN1AFFO11FD052.protection.gbl>
References: <1cf9126b-c5e4-4ae7-a294-071584857d6c@BN1AFFO11FD052.protection.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Färber <afaerber@suse.de>
---
 v3: Split off from QSPI (Michal Simek).
 
 arch/arm/boot/dts/zynq-7000.dtsi | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-7000.dtsi
index cf0f3e4..ef11dab 100644
--- a/arch/arm/boot/dts/zynq-7000.dtsi
+++ b/arch/arm/boot/dts/zynq-7000.dtsi
@@ -140,6 +140,30 @@
 			interrupts = <0 50 4>;
 		};
 
+		spi0: spi@e0006000 {
+			compatible = "xlnx,zynq-spi-r1p6";
+			reg = <0xe0006000 0x1000>;
+			status = "disabled";
+			interrupt-parent = <&intc>;
+			interrupts = <0 26 4>;
+			clocks = <&clkc 25>, <&clkc 34>;
+			clock-names = "ref_clk", "pclk";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
+		spi1: spi@e0007000 {
+			compatible = "xlnx,zynq-spi-r1p6";
+			reg = <0xe0007000 0x1000>;
+			status = "disabled";
+			interrupt-parent = <&intc>;
+			interrupts = <0 49 4>;
+			clocks = <&clkc 26>, <&clkc 35>;
+			clock-names = "ref_clk", "pclk";
+			#address-cells = <1>;
+			#size-cells = <0>;
+		};
+
 		gem0: ethernet@e000b000 {
 			compatible = "cdns,gem";
 			reg = <0xe000b000 0x4000>;
-- 
1.9.3

