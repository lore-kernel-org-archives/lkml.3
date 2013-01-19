Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068Ab3ASK2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 05:28:48 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:64240 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab3ASK2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 05:28:45 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Mark Zhang <markz@nvidia.com>,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 3/3] tegra: ventana: of: add host1x device to DT
Date: Sat, 19 Jan 2013 19:30:20 +0900
Message-Id: <1358591420-7790-4-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358591420-7790-1-git-send-email-acourbot@nvidia.com>
References: <1358591420-7790-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the host1x device and DDC i2c bus to enable internal panel on
Ventana.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 arch/arm/boot/dts/tegra20-ventana.dts | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index a77b529..4477e9c 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -10,6 +10,15 @@
 		reg = <0x00000000 0x40000000>;
 	};
 
+	host1x {
+		dc@54200000 {
+			rgb {
+				status = "okay";
+				nvidia,ddc-i2c-bus = <&lcd_ddc>;
+			};
+		};
+	};
+
 	pinmux {
 		pinctrl-names = "default";
 		pinctrl-0 = <&state_default>;
@@ -341,7 +350,7 @@
 			#size-cells = <0>;
 		};
 
-		i2c@1 {
+		lcd_ddc: i2c@1 {
 			reg = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
1.8.1.1

