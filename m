Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbaEPNDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:03:25 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51853 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752309AbaEPNDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:03:20 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/11] phy: omap-usb2: Add clock names to Documentation binding
Date: Fri, 16 May 2014 18:32:57 +0530
Message-ID: <1400245387-14445-3-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400245387-14445-1-git-send-email-kishon@ti.com>
References: <1400245387-14445-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

Add "wkupclk" and "refclk" information to DT binding information.

Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 Documentation/devicetree/bindings/phy/ti-phy.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documentation/devicetree/bindings/phy/ti-phy.txt
index 788fb0f..9ce458f 100644
--- a/Documentation/devicetree/bindings/phy/ti-phy.txt
+++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
@@ -32,6 +32,11 @@ Required properties:
  - reg : Address and length of the register set for the device.
  - #phy-cells: determine the number of cells that should be given in the
    phandle while referencing this phy.
+ - clocks: a list of phandles and clock-specifier pairs, one for each entry in
+   clock-names.
+ - clock-names: should include:
+   * "wkupclk" - wakeup clock.
+   * "refclk" - reference clock (optional).
 
 Optional properties:
  - ctrl-module : phandle of the control module used by PHY driver to power on
@@ -44,6 +49,8 @@ usb2phy@4a0ad080 {
 	reg = <0x4a0ad080 0x58>;
 	ctrl-module = <&omap_control_usb>;
 	#phy-cells = <0>;
+	clocks = <&usb_phy_cm_clk32k>, <&usb_otg_ss_refclk960m>;
+	clock-names = "wkupclk", "refclk";
 };
 
 TI PIPE3 PHY
-- 
1.7.9.5

