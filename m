Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaA3AH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 19:07:56 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:57480 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752370AbaA3AHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 19:07:55 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V5 3/5] arm64: dts: Add X-Gene reboot driver dts node
Date: Wed, 29 Jan 2014 16:03:16 -0800
Message-Id: <1391040198-14185-4-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1391040198-14185-1-git-send-email-fkan@apm.com>
References: <1391040198-14185-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add X-Gene platform reboot driver dts node.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index d37d736..4ef9d26 100644
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
@@ -187,5 +192,13 @@
 			interrupt-parent = <&gic>;
 			interrupts = <0x0 0x4c 0x4>;
 		};
+
+		reboot@17000014 {
+			compatible = "syscon-reboot";
+			regmap = <&scu>;
+			offset = <0x14>;
+			mask = <0x1>;
+		};
+
 	};
 };
-- 
1.7.6.1

