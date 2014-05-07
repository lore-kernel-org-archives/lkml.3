Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434AbaEGQTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:19:35 -0400
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:36577 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932148AbaEGQTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:19:32 -0400
From: Feng Kan <fkan@apm.com>
To: dbaryshkov@gmail.com, catalin.marinas@arm.com, dwmw2@infradead.org,
        arnd@arndb.de, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@apm.com
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V6 2/5] arm64: dts: Add X-Gene reboot driver dts node
Date: Wed,  7 May 2014 09:18:01 -0700
Message-Id: <1399479484-2605-3-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1399479484-2605-1-git-send-email-fkan@apm.com>
References: <1399479484-2605-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add X-Gene platform reboot driver dts node.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm-storm.dtsi |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm-storm.dtsi b/arch/arm64/boot/dts/apm-storm.dtsi
index 93f4b2d..306a9cd 100644
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
@@ -339,5 +344,12 @@
 			phys = <&phy3 0>;
 			phy-names = "sata-phy";
 		};
+
+		reboot@17000014 {
+			compatible = "syscon-reboot";
+			regmap = <&scu>;
+			offset = <0x14>;
+			mask = <0x1>;
+		};
 	};
 };
-- 
1.7.6.1

