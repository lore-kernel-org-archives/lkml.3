Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759228Ab3CGNft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 08:35:49 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:33284 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461Ab3CGNfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 08:35:42 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <kishon@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH v3 7/7] ARM: dts: omap5: add dwc3 omap and dwc3 core dt data
Date: Thu, 7 Mar 2013 19:05:20 +0530
Message-ID: <1362663320-23799-8-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1362663320-23799-1-git-send-email-kishon@ti.com>
References: <1362663320-23799-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add dwc3 omap glue data to the omap5 dt data file. The information about
the dt node added here is available @
Documentation/devicetree/bindings/usb/omap-usb.txt.

Also added dwc3 core dt data as a subnode to dwc3 omap glue data in omap5 dt
data file. The information for the entered data node is available @
Documentation/devicetree/bindings/usb/dwc3.txt

Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 arch/arm/boot/dts/omap5.dtsi |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index bd73257..24dd69f 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -505,6 +505,24 @@
 			ti,type = <2>;
 		};
 
+		omap_dwc3@4a020000 {
+			compatible = "ti,dwc3";
+			ti,hwmods = "usb_otg_ss";
+			reg = <0x4a020000 0x1000>;
+			interrupts = <0 93 4>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			utmi-mode = <2>;
+			ranges;
+			dwc3@4a030000 {
+				compatible = "synopsys,dwc3";
+				reg = <0x4a030000 0x1000>;
+				interrupts = <0 92 4>;
+				usb-phy = <&usb2_phy>, <&usb3_phy>;
+				tx-fifo-resize;
+			};
+		};
+
 		ocp2scp {
 			compatible = "ti,omap-ocp2scp";
 			#address-cells = <1>;
-- 
1.7.10.4

