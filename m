Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538AbaAPPjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 10:39:22 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:33108 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbaAPPjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 10:39:17 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, arm@kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, olof@lixom.net,
        soren.brinkmann@xilinx.com, peter.crosthwaite@xilinx.com,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] ARM: moxart: move fixed rate clock child node to board level dts
Date: Thu, 16 Jan 2014 16:39:06 +0100
Message-Id: <1389886746-972-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a skeleton "clocks { .. }" remain in .dtsi, the child node can
be moved to .dts, "ref12" is then found by of_clk_get().

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Applies to next-20140116

 arch/arm/boot/dts/moxart-uc7112lx.dts | 8 ++++++++
 arch/arm/boot/dts/moxart.dtsi         | 6 ------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/moxart-uc7112lx.dts b/arch/arm/boot/dts/moxart-uc7112lx.dts
index 90749d5..10d088d 100644
--- a/arch/arm/boot/dts/moxart-uc7112lx.dts
+++ b/arch/arm/boot/dts/moxart-uc7112lx.dts
@@ -17,6 +17,14 @@
 		reg = <0x0 0x2000000>;
 	};
 
+	clocks {
+		ref12: ref12M {
+			compatible = "fixed-clock";
+			#clock-cells = <0>;
+			clock-frequency = <12000000>;
+		};
+	};
+
 	flash@80000000,0 {
 		compatible = "numonyx,js28f128", "cfi-flash";
 		reg = <0x80000000 0x1000000>;
diff --git a/arch/arm/boot/dts/moxart.dtsi b/arch/arm/boot/dts/moxart.dtsi
index da1d8ef..1fd27ed 100644
--- a/arch/arm/boot/dts/moxart.dtsi
+++ b/arch/arm/boot/dts/moxart.dtsi
@@ -26,12 +26,6 @@
 	clocks {
 		#address-cells = <1>;
 		#size-cells = <0>;
-
-		ref12: ref12M {
-			compatible = "fixed-clock";
-			#clock-cells = <0>;
-			clock-frequency = <12000000>;
-		};
 	};
 
 	soc {
-- 
1.8.2.1

