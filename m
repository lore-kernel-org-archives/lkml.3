Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbaGICQM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:16:12 -0400
Received: from exprod5og105.obsmtp.com ([64.18.0.180]:56587 "HELO
	exprod5og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754073AbaGICQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:16:07 -0400
From: Feng Kan <fkan@apm.com>
To: dbaryshkov@gmail.com, catalin.marinas@arm.com, dwmw2@infradead.org,
        arnd@arndb.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V8 4/6] arm64: dts: Add X-Gene reboot driver dts node
Date: Tue,  8 Jul 2014 19:15:51 -0700
Message-Id: <1404872153-3594-5-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404872153-3594-1-git-send-email-fkan@apm.com>
References: <1404872153-3594-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add X-Gene platform reboot driver dts node.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 40aa96c..876952c 100644
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
@@ -397,5 +402,12 @@
 			#clock-cells = <1>;
 			clocks = <&rtcclk 0>;
 		};
+
+		reboot: reboot@17000014 {
+			compatible = "syscon-reboot";
+			regmap = <&scu>;
+			offset = <0x14>;
+			mask = <0x1>;
+		};
 	};
 };
-- 
1.9.1

