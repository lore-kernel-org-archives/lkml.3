Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002Ab3FMNn5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 09:43:57 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:50137 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3FMNny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 09:43:54 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 1/4] ARM: cfa10036: Add USB0 OTG port
Date: Thu, 13 Jun 2013 15:43:42 +0200
Message-Id: <1371131025-12200-2-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1371131025-12200-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 arch/arm/boot/dts/imx28-cfa10036.dts | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/imx28-cfa10036.dts b/arch/arm/boot/dts/imx28-cfa10036.dts
index 1594694..eae9c97 100644
--- a/arch/arm/boot/dts/imx28-cfa10036.dts
+++ b/arch/arm/boot/dts/imx28-cfa10036.dts
@@ -45,6 +45,17 @@
 					fsl,voltage = <1>;
 					fsl,pull-up = <0>;
 				};
+
+				usb0_otg_cfa10036: otg-10036@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x0142 /* MX28_PAD_GPMI_READY0__USB0_ID */
+					>;
+					fsl,drive-strength = <0>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <0>;
+				};
+
 			};
 
 			ssp0: ssp@80010000 {
@@ -82,6 +93,18 @@
 					reset-gpios = <&gpio2 7 0>;
 				};
 			};
+
+			usbphy0: usbphy@8007c000 {
+				status = "okay";
+			};
+		};
+	};
+
+	ahb@80080000 {
+		usb0: usb@80080000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&usb0_otg_cfa10036>;
+			status = "okay";
 		};
 	};
 
-- 
1.8.3

