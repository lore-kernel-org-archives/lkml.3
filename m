Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbbAZTul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 14:50:41 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:38141 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400AbbAZTuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:50:32 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH 2/2] ARM: zynq: DT: Add pinctrl information to USB nodes
Date: Mon, 26 Jan 2015 11:49:56 -0800
Message-Id: <1422301796-22888-2-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 2.2.2.1.g63c5777
In-Reply-To: <1422301796-22888-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1422301796-22888-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Hi Michal,

This could be squashed into 1643b31658c4 'ARM: zynq: DT: Add USB to
device tree' if you decide to rebuild the zynq/dt branch.

	Sören
---
 arch/arm/boot/dts/zynq-zc702.dts | 26 ++++++++++++++++++++++++++
 arch/arm/boot/dts/zynq-zc706.dts | 26 ++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/arch/arm/boot/dts/zynq-zc702.dts b/arch/arm/boot/dts/zynq-zc702.dts
index 4f8835be4874..483f69ba2cf5 100644
--- a/arch/arm/boot/dts/zynq-zc702.dts
+++ b/arch/arm/boot/dts/zynq-zc702.dts
@@ -312,6 +312,30 @@
 			bias-disable;
 		};
 	};
+
+	pinctrl_usb0_default: usb0-default {
+		mux {
+			groups = "usb0_0_grp";
+			function = "usb0";
+		};
+
+		conf {
+			groups = "usb0_0_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		conf-rx {
+			pins = "MIO29", "MIO31", "MIO36";
+			bias-high-impedance;
+		};
+
+		conf-tx {
+			pins = "MIO28", "MIO30", "MIO32", "MIO33", "MIO34",
+			       "MIO35", "MIO37", "MIO38", "MIO39";
+			bias-disable;
+		};
+	};
 };
 
 &sdhci0 {
@@ -330,4 +354,6 @@
 	status = "okay";
 	dr_mode = "host";
 	usb-phy = <&usb_phy0>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usb0_default>;
 };
diff --git a/arch/arm/boot/dts/zynq-zc706.dts b/arch/arm/boot/dts/zynq-zc706.dts
index 6979ce23175f..3a6260998116 100644
--- a/arch/arm/boot/dts/zynq-zc706.dts
+++ b/arch/arm/boot/dts/zynq-zc706.dts
@@ -261,6 +261,30 @@
 			bias-disable;
 		};
 	};
+
+	pinctrl_usb0_default: usb0-default {
+		mux {
+			groups = "usb0_0_grp";
+			function = "usb0";
+		};
+
+		conf {
+			groups = "usb0_0_grp";
+			slew-rate = <0>;
+			io-standard = <1>;
+		};
+
+		conf-rx {
+			pins = "MIO29", "MIO31", "MIO36";
+			bias-high-impedance;
+		};
+
+		conf-tx {
+			pins = "MIO28", "MIO30", "MIO32", "MIO33", "MIO34",
+			       "MIO35", "MIO37", "MIO38", "MIO39";
+			bias-disable;
+		};
+	};
 };
 
 &sdhci0 {
@@ -279,4 +303,6 @@
 	status = "okay";
 	dr_mode = "host";
 	usb-phy = <&usb_phy0>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_usb0_default>;
 };
-- 
2.2.2.1.g63c5777

