Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaIWSV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:21:57 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45943 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbaIWSVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:21:43 -0400
From: Kumar Gala <galak@codeaurora.org>
To: linux-arm-msm@vger.kernel.org
Cc: Kumar Gala <galak@codeaurora.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] ARM: dts: qcom: Add SATA support on IPQ8064/AP148
Date: Tue, 23 Sep 2014 13:21:41 -0500
Message-Id: <1411496501-20130-2-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1411496501-20130-1-git-send-email-galak@codeaurora.org>
References: <1411496501-20130-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add SATA PHY and SATA AHCI controller nodes to device tree to enable
generic ahci support on the IPQ8064/AP148 board.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 arch/arm/boot/dts/qcom-ipq8064-ap148.dts |  8 ++++++++
 arch/arm/boot/dts/qcom-ipq8064.dtsi      | 33 ++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/qcom-ipq8064-ap148.dts b/arch/arm/boot/dts/qcom-ipq8064-ap148.dts
index 95e6495..55b2910 100644
--- a/arch/arm/boot/dts/qcom-ipq8064-ap148.dts
+++ b/arch/arm/boot/dts/qcom-ipq8064-ap148.dts
@@ -81,5 +81,13 @@
 				};
 			};
 		};
+
+		sata-phy@1b400000 {
+			status = "ok";
+		};
+
+		sata@29000000 {
+			status = "ok";
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/qcom-ipq8064.dtsi b/arch/arm/boot/dts/qcom-ipq8064.dtsi
index 244f857..63b2146 100644
--- a/arch/arm/boot/dts/qcom-ipq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq8064.dtsi
@@ -234,6 +234,39 @@
 			};
 		};
 
+		sata_phy: sata-phy@1b400000 {
+			compatible = "qcom,ipq806x-sata-phy";
+			reg = <0x1b400000 0x200>;
+
+			clocks = <&gcc SATA_PHY_CFG_CLK>;
+			clock-names = "cfg";
+
+			#phy-cells = <0>;
+			status = "disabled";
+		};
+
+		sata@29000000 {
+			compatible = "qcom,ipq806x-ahci", "generic-ahci";
+			reg = <0x29000000 0x180>;
+
+			interrupts = <0 209 0x0>;
+
+			clocks = <&gcc SFAB_SATA_S_H_CLK>,
+				 <&gcc SATA_H_CLK>,
+				 <&gcc SATA_A_CLK>,
+				 <&gcc SATA_RXOOB_CLK>,
+				 <&gcc SATA_PMALIVE_CLK>;
+			clock-names = "slave_face", "iface", "core",
+					"rxoob", "pmalive";
+
+			assigned-clocks = <&gcc SATA_RXOOB_CLK>, <&gcc SATA_PMALIVE_CLK>;
+			assigned-clock-rates = <100000000>, <100000000>;
+
+			phys = <&sata_phy>;
+			phy-names = "sata-phy";
+			status = "disabled";
+		};
+
 		qcom,ssbi@500000 {
 			compatible = "qcom,ssbi";
 			reg = <0x00500000 0x1000>;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

