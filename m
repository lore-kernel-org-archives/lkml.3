Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbbAHAga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 19:36:30 -0500
Received: from denmail01-v4020.amcc.com ([192.195.68.30]:55708 "EHLO
	denmail01.apm.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752373AbbAHAef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 19:34:35 -0500
From: Feng Kan <fkan@apm.com>
To: patches@apm.com, linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Feng Kan <fkan@apm.com>
Subject: [PATCH V3 3/7] arm64: dts: Add X-Gene reboot driver dts node
Date: Wed,  7 Jan 2015 17:33:34 -0700
Message-Id: <1420677218-30743-4-git-send-email-fkan@apm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1420677218-30743-1-git-send-email-fkan@apm.com>
References: <1420677218-30743-1-git-send-email-fkan@apm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add X-Gene platform reboot driver dts node.

Signed-off-by: Feng Kan <fkan@apm.com>
---
 arch/arm64/boot/dts/apm/apm-storm.dtsi |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm64/boot/dts/apm/apm-storm.dtsi b/arch/arm64/boot/dts/apm/apm-storm.dtsi
index 4b2ec83..f31e8df 100644
--- a/arch/arm64/boot/dts/apm/apm-storm.dtsi
+++ b/arch/arm64/boot/dts/apm/apm-storm.dtsi
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
1.7.1

