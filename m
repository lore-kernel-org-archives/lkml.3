Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbbAULDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:03:05 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:52267 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752015AbbAULCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:02:37 -0500
From: Rameshwar Prasad Sahu <rsahu@apm.com>
To: vinod.koul@intel.com, dan.j.williams@intel.com
Cc: dmaengine@vger.kernel.org, arnd@arndb.de, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        ddutile@redhat.com, jcm@redhat.com, patches@apm.com,
        Rameshwar Prasad Sahu <rsahu@apm.com>, Loc Ho <lho@apm.com>
Subject: [PATCH v4 2/3] arm64: dts: Add APM X-Gene DMA device and DMA clock DTS nodes
Date: Wed, 21 Jan 2015 16:31:10 +0530
Message-Id: <1421838071-7347-3-git-send-email-rsahu@apm.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1421838071-7347-1-git-send-email-rsahu@apm.com>
References: <1421838071-7347-1-git-send-email-rsahu@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the device tree node for APM X-Gene SoC
DMA controller and DMA clock.

Signed-off-by: Rameshwar Prasad Sahu <rsahu@apm.com>
Signed-off-by: Loc Ho <lho@apm.com>
---
 arch/arm64/boot/dts/apm/apm-storm.dtsi | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/boot/dts/apm/apm-storm.dtsi b/arch/arm64/boot/dts/apm/apm-storm.dtsi
index f1ad9c2..1c0c8ca 100644
--- a/arch/arm64/boot/dts/apm/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm/apm-storm.dtsi
@@ -102,6 +102,7 @@
 		#address-cells = <2>;
 		#size-cells = <2>;
 		ranges;
+		dma-ranges = <0x0 0x0 0x0 0x0 0x400 0x0>;

 		clocks {
 			#address-cells = <2>;
@@ -352,6 +353,15 @@
 				reg-names = "csr-reg";
 				clock-output-names = "pcie4clk";
 			};
+
+			dmaclk: dmaclk@1f27c000 {
+				compatible = "apm,xgene-device-clock";
+				#clock-cells = <1>;
+				clocks = <&socplldiv2 0>;
+				reg = <0x0 0x1f27c000 0x0 0x1000>;
+				reg-names = "csr-reg";
+				clock-output-names = "dmaclk";
+			};
 		};

 		pcie0: pcie@1f2b0000 {
@@ -656,5 +666,21 @@
 			interrupts = <0x0 0x41 0x4>;
 			clocks = <&rngpkaclk 0>;
 		};
+
+		dma: dma@1f270000 {
+			compatible = "apm,xgene-dma";
+			device_type = "dma";
+			reg = <0x0 0x1f270000 0x0 0x10000>,
+			      <0x0 0x1f200000 0x0 0x10000>,
+			      <0x0 0x1b008000 0x0 0x2000>;
+			reg-names = "dma_csr", "ring_csr", "ring_cmd";
+			interrupts = <0x0 0x82 0x4>,
+				     <0x0 0xb8 0x4>,
+				     <0x0 0xb9 0x4>,
+				     <0x0 0xba 0x4>,
+				     <0x0 0xbb 0x4>;
+			dma-coherent;
+			clocks = <&dmaclk 0>;
+		};
 	};
 };
--
1.8.2.1

