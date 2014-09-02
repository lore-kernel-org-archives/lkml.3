Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932132AbaIBVhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:37:32 -0400
Received: from mail-ie0-f202.google.com ([209.85.223.202]:64616 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755281AbaIBVfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:35:08 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Subject: [PATCH v3 5/9] of: Add NVIDIA Tegra xHCI controller binding
Date: Tue,  2 Sep 2014 14:34:57 -0700
Message-Id: <1409693701-16520-6-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1409693701-16520-1-git-send-email-abrestic@chromium.org>
References: <1409693701-16520-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device-tree binding documentation for the xHCI controller present
on Tegra124 and later SoCs.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
Changes from v2:
 - Added mbox-names property.
Changes from v1:
 - Updated to use common mailbox bindings.
 - Added remaining XUSB-related clocks and resets.
 - Updated list of power supplies to be more accurate wrt to the hardware.
---
 .../bindings/usb/nvidia,tegra124-xhci.txt          | 104 +++++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt

diff --git a/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt b/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
new file mode 100644
index 0000000..51a7751
--- /dev/null
+++ b/Documentation/devicetree/bindings/usb/nvidia,tegra124-xhci.txt
@@ -0,0 +1,104 @@
+NVIDIA Tegra xHCI controller
+============================
+
+The Tegra xHCI controller supports both USB2 and USB3 interfaces exposed
+by the Tegra XUSB pad controller.
+
+Required properties:
+--------------------
+ - compatible: Should be "nvidia,tegra124-xhci".
+ - reg: Address and length of the register sets.  There should be three
+   entries in the following order: xHCI host registers, FPCI registers, and
+   IPFS registers.
+ - interrupts: xHCI host interrupt.
+ - clocks: Must contain an entry for each entry in clock-names.
+   See ../clock/clock-bindings.txt for details.
+ - clock-names: Must include the following entries:
+    - xusb_host
+    - xusb_host_src
+    - xusb_dev
+    - xusb_dev_src
+    - xusb_falcon_src
+    - xusb_ss
+    - xusb_ss_src
+    - xusb_ss_div2
+    - xusb_hs_src
+    - xusb_fs_src
+    - pll_u_480m
+    - clk_m
+    - pll_e
+ - resets: Must contain an entry for each entry in reset-names.
+   See ../reset/reset.txt for details.
+ - reset-names: Must include the following entries:
+   - xusb_host
+   - xusb_dev
+   - xusb_ss
+   - xusb
+   Note that xusb_dev is the shared reset for xusb_dev and xusb_dev_src and
+   that xusb is the shared reset for xusb_{ss,hs,fs,falcon,host}_src.
+ - mboxes: Must contain an entry for the XUSB mailbox channel.
+   See ../mailbox/mailbox.txt for details.
+ - mbox-names: Must include the following entries:
+   - xusb
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
+ - avddio-pex-supply: PCIe/USB3 analog logic power supply.  Must supply 1.05V.
+ - dvddio-pex-supply: PCIe/USB3 digital logic power supply.  Must supply 1.05V.
+ - avdd-usb-supply: USB controller power supply.  Must supply 3.3V.
+ - avdd-pll-utmip-supply: UTMI PLL power supply.  Must supply 1.8V.
+ - avdd-pll-erefe-supply: PLLE reference PLL power supply.  Must supply 1.05V.
+ - avdd-pex-pll-supply: PCIe/USB3 PLL power supply.  Must supply 1.05V.
+ - hvdd-pex-supply: High-voltage PCIe/USB3 power supply.  Must supply 3.3V.
+ - hvdd-pex-plle-supply: High-voltage PLLE power supply.  Must supply 3.3V.
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
+			 <&tegra_car TEGRA124_CLK_XUSB_HOST_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_DEV>,
+			 <&tegra_car TEGRA124_CLK_XUSB_DEV_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_FALCON_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_SS>,
+			 <&tegra_car TEGRA124_CLK_XUSB_SS_DIV2>,
+			 <&tegra_car TEGRA124_CLK_XUSB_SS_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_HS_SRC>,
+			 <&tegra_car TEGRA124_CLK_XUSB_FS_SRC>,
+			 <&tegra_car TEGRA124_CLK_PLL_U_480M>,
+			 <&tegra_car TEGRA124_CLK_CLK_M>,
+			 <&tegra_car TEGRA124_CLK_PLL_E>;
+		clock-names = "xusb_host", "xusb_host_src", "xusb_dev",
+			      "xusb_dev_src", "xusb_falcon_src", "xusb_ss",
+			      "xusb_ss_div2", "xusb_ss_src", "xusb_hs_src",
+			      "xusb_fs_src", "pll_u_480m", "clk_m", "pll_e";
+		resets = <&tegra_car 89>, <&tegra_car 95>, <&tegra_car 156>,
+			 <&tegra_car 143>;
+		reset-names = "xusb_host", "xusb_dev", "xusb_ss", "xusb";
+		mboxes = <&xusb_mbox>;
+		mbox-names = "xusb";
+		phys = <&padctl TEGRA_XUSB_PADCTL_UTMI_P1>, /* mini-PCIe USB */
+		       <&padctl TEGRA_XUSB_PADCTL_UTMI_P2>, /* USB A */
+		       <&padctl TEGRA_XUSB_PADCTL_USB3_P0>; /* USB A */
+		phy-names = "utmi-1", "utmi-2", "usb3-0";
+		avddio-pex-supply = <&vdd_1v05_run>;
+		dvddio-pex-supply = <&vdd_1v05_run>;
+		avdd-usb-supply = <&vdd_3v3_lp0>;
+		avdd-pll-utmip-supply = <&vddio_1v8>;
+		avdd-pll-erefe-supply = <&avdd_1v05_run>;
+		avdd-pex-pll-supply = <&vdd_1v05_run>;
+		hvdd-pex-supply = <&vdd_3v3_lp0>;
+		hvdd-pex-plle-supply = <&vdd_3v3_lp0>;
+	};
-- 
2.1.0.rc2.206.gedb03e5

