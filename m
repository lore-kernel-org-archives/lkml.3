Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964790AbaFRGSq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:18:46 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:33659 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933819AbaFRGQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:16:38 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Kishon Vijay Abraham I <kishon@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH v1 5/9] of: Add NVIDIA Tegra XHCI controller binding
Date: Tue, 17 Jun 2014 23:16:16 -0700
Message-Id: <1403072180-4944-6-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
References: <1403072180-4944-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree binding documentation for the XHCI controller present
on Tegra124 and later SoCs.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 .../bindings/usb/nvidia,tegra124-xhci.txt          | 76 ++++++++++++++++++++++
 1 file changed, 76 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt

diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
new file mode 100644
index 0000000..fdb8624
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
@@ -0,0 +1,76 @@
+NVIDIA Tegra XHCI controller
+============================
+
+The Tegra XHCI controller supports both USB2 and USB3 interfaces exposed
+by the Tegra XUSB pad controller.
+
+Required properties:
+--------------------
+ - compatible: Should be "nvidia,tegra124-xhci".
+ - reg: Address and length of the register sets.  There should be three
+   entries in the following order: XHCI host registers, FPCI registers, and
+   IPFS registers.
+ - interrupts: XHCI host interrupt.
+ - clocks: Must contain an entry for each entry in clock-names.
+   See ../clock/clock-bindings.txt for details.
+ - clock-names: Must include the following entries:
+    - xusb_host
+    - xusb_falcon_src
+    - xusb_ss
+    - xusb_ss_src
+    - xusb_hs_src
+    - xusb_fs_src
+    - pll_u_480m
+    - clk_m
+    - pll_e
+ - resets: Must contain an entry for each entry in reset-names.
+   See ../reset/reset.txt for details.
+ - reset-names: Must include the following entries:
+   - xusb_host
+   - xusb_ss
+ - nvidia,xusb-mbox: Handle to the Tegra XUSB mailbox node.
+
+Optional properties:
+--------------------
+ - phys: Must contain an entry for each entry in phy-names.
+   See ../phy/phy-bindings.txt for details.
+ - phy-names: Should include an entry for each PHY used by the controller.
+   May be a subset of the following:
+    - utmi-{0,1,2}
+    - hsic-{0,1}
+    - usb3-{0,1}
+ - s1p05v-supply: 1.05V supply regulator.
+ - s1p8v-supply: 1.8V supply regulator.
+ - s3p3v-supply: 3.3V supply regulator.
+
+Example:
+--------
+	usb@0,70090000 {
+		compatible = "nvidia,tegra124-xhci";
+		reg = <0x0 0x70090000 0x0 0x8000>,
+		      <0x0 0x70098000 0x0 0x1000>,
+		      <0x0 0x70099000 0x0 0x1000>;
+		interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&tegra_car TEGRA124_CLK_XUSB_HOST>,
+			 <&tegra_car TEGRA124_CLK_XUSB_FALCON_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_SS>,
+			 <&tegra_car TEGRA124_CLK_XUSB_SS_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_HS_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_FS_SRC>,
+			 <&tegra_car TEGRA124_CLK_PLL_U_480M>,
+			 <&tegra_car TEGRA124_CLK_CLK_M>,
+			 <&tegra_car TEGRA124_CLK_PLL_E>;
+		clock-names = "xusb_host", "xusb_falcon_src", "xusb_ss",
+			      "xusb_ss_src", "xusb_hs_src", "xusb_fs_src",
+			      "pll_u_480m", "clk_m", "pll_e";
+		resets = <&tegra_car 89>, <&tegra_car 156>;
+		reset-names = "xusb_host", "xusb_ss";
+		nvidia,xusb-mbox = <&mbox>;
+		phys = <&padctl TEGRA_XUSB_PADCTL_UTMI_P1>, /* mini-PCIe USB */
+		       <&padctl TEGRA_XUSB_PADCTL_UTMI_P2>, /* USB A */
+		       <&padctl TEGRA_XUSB_PADCTL_USB3_P0>; /* USB A */
+		phy-names = "utmi-1", "utmi-2", "usb3-0";
+		s1p05v-supply = <&vdd_1v05_run>;
+		s3p3v-supply = <&vdd_3v3_lp0>;
+		s1p8v-supply = <&vddio_1v8>;
+	};
-- 
2.0.0.526.g5318336

