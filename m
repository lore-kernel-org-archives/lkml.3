Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268Ab3CMTwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 15:52:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17386 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934236Ab3CMTwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 15:52:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 13 Mar 2013 12:52:08 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 5/5] ARM: tegra: add spi nodes to Tegra114 DT
Date: Thu, 14 Mar 2013 01:19:54 +0530
Message-ID: <1363204194-19487-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1363204194-19487-1-git-send-email-ldewangan@nvidia.com>
References: <1363204194-19487-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NVIDIA's Tegra114 has 6 spi controllers. These controllers are
redesign on T114 with different register interface.

Add DT entry for spi controllers and make it compatible with
"nvidia,tegra114-spi".

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
- None
Changes fro V2:
- Rebase  to for-3.10/dt of Stephen's Tegra tree.

 arch/arm/boot/dts/tegra114.dtsi |   72 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
index d2bbfaf..95c4369 100644
--- a/arch/arm/boot/dts/tegra114.dtsi
+++ b/arch/arm/boot/dts/tegra114.dtsi
@@ -212,6 +212,78 @@
 		clock-names = "div-clk";
 	};
 
+	spi@7000d400 {
+		compatible = "nvidia,tegra114-spi";
+		reg = <0x7000d400 0x200>;
+		interrupts = <0 59 0x04>;
+		nvidia,dma-request-selector = <&apbdma 15>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&tegra_car 41>;
+		clock-names = "spi";
+		status = "disabled";
+	};
+
+	spi@7000d600 {
+		compatible = "nvidia,tegra114-spi";
+		reg = <0x7000d600 0x200>;
+		interrupts = <0 82 0x04>;
+		nvidia,dma-request-selector = <&apbdma 16>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&tegra_car 44>;
+		clock-names = "spi";
+		status = "disabled";
+	};
+
+	spi@7000d800 {
+		compatible = "nvidia,tegra114-spi";
+		reg = <0x7000d480 0x200>;
+		interrupts = <0 83 0x04>;
+		nvidia,dma-request-selector = <&apbdma 17>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&tegra_car 46>;
+		clock-names = "spi";
+		status = "disabled";
+	};
+
+	spi@7000da00 {
+		compatible = "nvidia,tegra114-spi";
+		reg = <0x7000da00 0x200>;
+		interrupts = <0 93 0x04>;
+		nvidia,dma-request-selector = <&apbdma 18>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&tegra_car 68>;
+		clock-names = "spi";
+		status = "disabled";
+	};
+
+	spi@7000dc00 {
+		compatible = "nvidia,tegra114-spi";
+		reg = <0x7000dc00 0x200>;
+		interrupts = <0 94 0x04>;
+		nvidia,dma-request-selector = <&apbdma 27>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&tegra_car 104>;
+		clock-names = "spi";
+		status = "disabled";
+	};
+
+	spi@7000de00 {
+		compatible = "nvidia,tegra114-spi";
+		reg = <0x7000de00 0x200>;
+		interrupts = <0 79 0x04>;
+		nvidia,dma-request-selector = <&apbdma 28>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		clocks = <&tegra_car 105>;
+		clock-names = "spi";
+		status = "disabled";
+	};
+
 	rtc {
 		compatible = "nvidia,tegra114-rtc", "nvidia,tegra20-rtc";
 		reg = <0x7000e000 0x100>;
-- 
1.7.1.1

