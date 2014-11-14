Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaKNAUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 19:20:10 -0500
Received: from exprod5og121.obsmtp.com ([64.18.0.139]:41621 "HELO
	exprod5og121.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754368AbaKNAUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 19:20:05 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, =devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V2 3/7] arm64: dts: Add X-Gene reboot driver dts node
Date: Thu, 13 Nov 2014 16:19:57 -0800
Message-Id: <1415924401-3013-4-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415924401-3013-1-git-send-email-fkan@apm.com>
References: <1415924401-3013-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add X-Gene platform reboot driver dts node.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 6b4c577..9a28d3a 100644
--- a/arch/arm64/boot/dts/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm-storm.dtsi
@@ -103,6 +103,11 @@
 		#size-cells = <2>;
 		ranges;
 
+		scu: system-clk-controller@17000000 {
+			compatible = "apm,xgene-scu","syscon";
+			reg = <0x0 0x17000000 0x0 0x400>;
+		};
+
 		clocks {
 			#address-cells = <2>;
 			#size-cells = <2>;
@@ -354,6 +359,13 @@
 			};
 		};
 
+		reboot: reboot@17000014 {
+			compatible = "syscon-reboot";
+			regmap = <&scu>;
+			offset = <0x14>;
+			mask = <0x1>;
+		};
+
 		pcie0: pcie@1f2b0000 {
 			status = "disabled";
 			device_type = "pci";
-- 
1.9.1

