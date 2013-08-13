Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3HMFiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 01:38:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36194 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754571Ab3HMFiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 01:38:21 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <benoit.cousson@linaro.org>, <tony@atomide.com>, <swarren@wwwdotorg.org>,
        <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>, <balbi@ti.com>
Subject: [PATCH v4 2/2] arm: omap5: dts: add palmas-usb node
Date: Tue, 13 Aug 2013 11:07:21 +0530
Message-ID: <1376372241-15573-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376372241-15573-1-git-send-email-kishon@ti.com>
References: <1376302675-15795-1-git-send-email-kishon@ti.com>
 <1376372241-15573-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

Without this node, there will be no palmas
driver to notify dwc3 that a cable has
been connected and, without that, dwc3
will never initialize.

[ kishon@ti.com : fix vbus-supply value after SMPS10 is modeled as 2 regulators]

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v3:
* Changed the compatible type to ti,palmas-usb-vid

Changes from v2:
fix vbus-supply value after SMPS10 is modeled as 2 regulators. This is needed
after SMPS10 is modeled as 2 regulators.
[1] models SMPS10 as 2 regulators.
[2] splits the SMPS10 node into two to represent the 2 regulators.

[1] -> http://comments.gmane.org/gmane.linux.kernel/1542521
[2] -> http://www.mail-archive.com/linux-omap@vger.kernel.org/msg93779.html

 arch/arm/boot/dts/omap5-uevm.dts |   10 ++++++++++
 arch/arm/boot/dts/omap5.dtsi     |    2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index e8704bc..c18ea50 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -272,6 +272,11 @@
 		interrupt-controller;
 		#interrupt-cells = <2>;
 
+		extcon_usb3: palmas_usb {
+			compatible = "ti,palmas-usb-vid";
+			ti,wakeup;
+		};
+
 		palmas_pmic {
 			compatible = "ti,palmas-pmic";
 			interrupt-parent = <&palmas>;
@@ -460,6 +465,11 @@
 	phys = <0 &hsusb2_phy &hsusb3_phy>;
 };
 
+&usb3 {
+	extcon = <&extcon_usb3>;
+	vbus-supply = <&smps10_out1_reg>;
+};
+
 &mcspi1 {
 
 };
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 4e41409..1659246 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -634,7 +634,7 @@
 			ti,type = <2>;
 		};
 
-		omap_dwc3@4a020000 {
+		usb3: omap_dwc3@4a020000 {
 			compatible = "ti,dwc3";
 			ti,hwmods = "usb_otg_ss";
 			reg = <0x4a020000 0x10000>;
-- 
1.7.10.4

